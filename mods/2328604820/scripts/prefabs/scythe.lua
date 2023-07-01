local assets =
{
	Asset("ANIM", "anim/scythe.zip"),
	Asset("ANIM", "anim/swap_scythe.zip"),
}

local golden_assets =
{
	Asset("ANIM", "anim/goldenscythe.zip"),
	Asset("ANIM", "anim/swap_goldenscythe.zip"),
}

local function OnFinished(inst)
	if inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner ~= nil then
		inst.components.inventoryitem.owner:PushEvent("toolbroke", {tool = inst})
	end
	inst:Remove()
end

local function CalDamage(inst, owner, target)
	return target ~= nil and target:HasTag("veggie") and TUNING.SCYTHE.DAMAGE * 1.5 or TUNING.SCYTHE.DAMAGE
end

local function AreaHitCheck(target, owner)
	--return not owner.components.rider:IsRiding() and not (owner.components.combat:IsAlly(target) or target:HasTag("wall"))
	return not owner.components.combat:IsAlly(target)
end

local function AreaHitCheckVeggie(target, owner)
	return not owner.components.combat:IsAlly(target) and target:HasTag("veggie")
end
--[[
local function AreaDamage(owner, enable)		--modded stimuli can be activate
	local combat = owner.components.combat
	if combat ~= nil then
		if not combat.areahitdisabled and enable then					--save area damage data if a character has its own area damage data
			local data = {}
			data.areahitrange = combat.areahitrange
			data.areahitdamagepercent = combat.areahitdamagepercent
			data.areahitcheck = combat.areahitcheck
			owner.areadamagedata = data

		elseif owner.areadamagedata == nil then
			combat:EnableAreaDamage(enable)
		end

		if enable then
			combat:SetAreaDamage(TUNING.SCYTHE.DAMAGE_RADIUS, TUNING.SCYTHE.DAMAGE_MULTIPY, AreaHitCheck)

		elseif owner.areadamagedata then								--restore the area damage data when unequip scythe
			local data = owner.areadamagedata
			combat:SetAreaDamage(data.areahitrange, data.areahitdamagepercent, data.areahitcheck)
			owner.areadamagedata = nil

		else
			combat:SetAreaDamage()
		end
	end
end
]]
local AREA_EXCLUDE_TAGS = {"INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost", "wall"}
local function OnAttack(inst, owner, target)		--no modded stimuli will trigger
	local combat = owner.components.combat
	if TUNING.SCYTHE.HARVEST_RADIUS > 0 and TUNING.SCYTHE.HARVEST_RADIUS > 0 and (combat.areahitrange == nil or combat.areahitdisabled) then
		local stimuli = owner.components.electricattacks ~= nil and "electric"
		if inst.components.weapon ~= nil and inst.components.weapon.overridestimulifn ~= nil then
			stimuli = inst.components.weapon.overridestimulifn(inst, owner, target)
		end
		if target:HasTag("veggie") then
			combat:DoAreaAttack(target, TUNING.SCYTHE.DAMAGE_RADIUS * 10, inst, AreaHitCheckVeggie, stimuli, AREA_EXCLUDE_TAGS)
		else
			combat:DoAreaAttack(target, TUNING.SCYTHE.DAMAGE_RADIUS, inst, AreaHitCheck, stimuli, AREA_EXCLUDE_TAGS)
		end
	end
end

local function OnEquip(inst, owner)
	if inst:HasTag("goldentool") then
		owner.AnimState:OverrideSymbol("swap_object", "swap_goldenscythe", "swap_goldenscythe")
		owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
	else
		owner.AnimState:OverrideSymbol("swap_object", "swap_scythe", "swap_scythe")
	end
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
--	AreaDamage(owner, true)
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
--	AreaDamage(owner, false)
end

local function common_fn(bank, build, tooltype)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank(bank)
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation("idle")

	if tooltype then
		inst:AddTag(tooltype.."tool")
	end
	inst:AddTag("sharp")
	inst:AddTag("weapon")
	inst:AddTag("bramble_resistant")				--equipment with this tag immune from throne. as well as that from bramble trap
	inst:AddTag("areapicker")

	MakeInventoryFloatable(inst, "med", 0.05, {0.75, 0.4, 0.75}, true, -11, {sym_build = build})

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("tool")
	inst.components.tool:SetAction(ACTIONS.SCYTHE)

	local finiteuses = inst:AddComponent("finiteuses")
	finiteuses:SetMaxUses(TUNING.SCYTHE.USES)
	finiteuses:SetUses(TUNING.SCYTHE.USES)
	finiteuses:SetOnFinished(OnFinished)
	if inst:HasTag("goldentool") then
		finiteuses:SetConsumption(ACTIONS.AREAPICK, 1 / TUNING.GOLDENTOOLFACTOR)
		finiteuses:SetConsumption(ACTIONS.SCYTHE, 1 / TUNING.GOLDENTOOLFACTOR)
	else
		finiteuses:SetConsumption(ACTIONS.AREAPICK, 1)
		finiteuses:SetConsumption(ACTIONS.SCYTHE, 1)
	end

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(CalDamage)
	inst.components.weapon:SetOnAttack(OnAttack)
	inst.components.weapon.attackwear = inst:HasTag("goldentool") and 2 / TUNING.GOLDENTOOLFACTOR or 2		--double consumption when attack

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)

	inst:AddComponent("areapicker")
	inst.components.areapicker:SetRadius(TUNING.SCYTHE.HARVEST_RADIUS)

	MakeHauntableLaunch(inst)
	return inst
end

local function normal()
	return common_fn("scythe", "swap_scythe")
end

local function golden()
	return common_fn("goldenscythe", "swap_goldenscythe", "golden")
end

return 	Prefab("scythe", normal, assets),
		Prefab("goldenscythe", golden, golden_assets)