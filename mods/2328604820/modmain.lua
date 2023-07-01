-------tuning--------
local tuning = {
	USES = GetModConfigData("USES"),				--default = 75
	HARVEST_RADIUS = GetModConfigData("RADIUS"),	--default = 6
	DAMAGE = GetModConfigData("DAMAGE"),			--default = 27.2
	HARVEST_MODE = GetModConfigData("MODE"),		--default = 3,			--combine mode

	DAMAGE_RADIUS = GetModConfigData("AREADMG") and 2 or 0,					--this is your aoe radius			--4 = 1 turf, here is half a turf
--	DAMAGE_MULTIPY = 1,								--this affact the aoe damage other than your target only	--eg. 0.5 must be full damage to your targetting prefab, and half to the others

	MIGHTINESS_DELTA = GetModConfigData("MIGHTINESS"),						--player who has mightiness, gain mightiness
	MIGHTINESS_DELTA_STEP = 5,												--gain extra mightiness for every step count of plants harvested

	GROWTH_MULTIPIER = .9,							--shorten the growth time			--here I set it to be 0.9 of the normal time, i.e. 2.7 days for grass which is originally 3.0
	EXTRAPICK_MULTIPIER = 2,						--more havest before wither			--1 for normal, 2 for double, 3 for triple
	EXTRAITEM_CHANCE = .1,							--chance to get an extra item		--greater than 1 may give you more, i.e. 3.5 give you 3 extra drops and 0.5 chance to get another one
}

TUNING.SCYTHE = tuning

-------resources--------
PrefabFiles = {
	"scythe",
}

Assets = {
	Asset("ATLAS", "images/inventoryimages/scythe.xml"),
	Asset("IMAGE", "images/inventoryimages/scythe.tex"),
	Asset("ATLAS", "images/inventoryimages/goldenscythe.xml"),
	Asset("IMAGE", "images/inventoryimages/goldenscythe.tex"),
}

RegisterInventoryItemAtlas("images/inventoryimages/scythe.xml", "scythe.tex")
RegisterInventoryItemAtlas("images/inventoryimages/goldenscythe.xml", "goldenscythe.tex")

-------recipe--------
if CurrentRelease.GreaterOrEqualTo("R20_QOL_CRAFTING4LIFE") then
	AddRecipe2("scythe", {Ingredient("twigs", 2), Ingredient("flint", 2)}, GLOBAL.TECH.SCIENCE_ONE)
	AddRecipe2("goldenscythe", {Ingredient("twigs", 4), Ingredient("goldnugget", 2)}, GLOBAL.TECH.SCIENCE_TWO)

	local function AddToFilter(filter, recipe, followedby)
		local FILTERS = GLOBAL.CRAFTING_FILTERS[filter]
		if followedby == nil then
			followedby = #FILTERS.recipes + 1
		end

		local added = false
		for k, v in pairs(FILTERS.recipes) do
			if added then
				FILTERS.default_sort_values[v] = FILTERS.default_sort_values[v] + 1
			elseif v == followedby then
				table.insert(FILTERS.recipes, k, recipe)
				FILTERS.default_sort_values[recipe] = k
				added = true
			end
		end
	end

	AddToFilter("TOOLS", "scythe", "farm_hoe")
	AddToFilter("TOOLS", "goldenscythe", "golden_farm_hoe")
	AddToFilter("WEAPONS", "goldenscythe", "batbat")
	AddToFilter("WEAPONS", "scythe", "goldenscythe")

else
	local AllRecipes = GLOBAL.AllRecipes

	AddRecipe("scythe", {Ingredient("twigs", 2), Ingredient("flint", 2)}, GLOBAL.RECIPETABS.TOOLS, GLOBAL.TECH.SCIENCE_ONE)
	AddRecipe("goldenscythe", {Ingredient("twigs", 4), Ingredient("goldnugget", 2)}, GLOBAL.RECIPETABS.TOOLS, GLOBAL.TECH.SCIENCE_TWO)

	AllRecipes["scythe"].sortkey = AllRecipes["hammer"].sortkey + .1		--sort after hammer
	AllRecipes["goldenscythe"].sortkey = AllRecipes["scythe"].sortkey + .1

end

--------strings---------
local STRINGS = GLOBAL.STRINGS
local Scythe_Strings = require("scythe_strings")

local lang = GetModConfigData("LANGUAGE") == "default" and GLOBAL.LanguageTranslator.defaultlang or GetModConfigData("LANGUAGE")
for i, v in ipairs(Scythe_Strings) do
	if v.language == lang or v.language == "en" then
		STRINGS.NAMES.SCYTHE = v.STR.NAMES
		STRINGS.RECIPE_DESC.SCYTHE = v.STR.RECIPE_DESC
		STRINGS.CHARACTERS.GENERIC.DESCRIBE.SCYTHE = v.STR.CHAR_DESC
		STRINGS.NAMES.GOLDENSCYTHE = v.GOLD_STR.NAMES
		STRINGS.RECIPE_DESC.GOLDENSCYTHE = v.GOLD_STR.RECIPE_DESC
		STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDENSCYTHE = v.GOLD_STR.CHAR_DESC
		STRINGS.ACTIONS.AREAPICK = v.ACT_STR
		break
	end
end

-------modconfigtag--------
function AddModConfigTag(prefix, tags)				--any config option with "prefix" will add its suffix to "tags"
	local config, temp_options = GLOBAL.KnownModIndex:GetModConfigurationOptions_Internal(modname, false)
	local tags = tags ~= nil and tags or {}
	if config and type(config) == "table" then
		if temp_options then
			for k, v in pairs(config) do
				if string.find(k, prefix) and v then
					table.insert(tags, string.lower(string.sub(k, string.len(prefix)+1)))
				end
			end
		else
			for k, v in pairs(config) do
				if string.find(v.name, prefix) and (v.saved ~= nil and v.saved or v.default) then
					table.insert(tags, string.lower(string.sub(v.name, string.len(prefix)+1)))
				end
			end
		end
	end
	return tags
end

modimport("scythe_pickable.lua")
--modimport("modprefab.lua")

local PICKER_TAG = AddModConfigTag("PICKER_", {"plant", "readyforharvest"})
local function TargetHasTag(target, tags)
	for i, v in ipairs(PICKER_TAG) do
		if target:HasTag(v) then
			return target:HasTag("pickable")
				or target:HasTag("takeshelfitem")			--for lureplant
				or target:HasTag("harvestable")				--for beebox
				--or target:HasTag("HACK_workable")			--for hacable plants(bamboo/tuber tree/etc)
				or (v == "dried")							--for meatrack
				or (v == "readyforharvest")					--for farmplot plants
		end
	end

	if #MOD_PREFAB > 0 then
		for i, v in ipairs(MOD_PREFAB) do
			if target.prefab == v then
				return true
			end
		end
	end
	return false
end

--------Action--------
local NORMAL_PICK = GLOBAL.ACTIONS.PICK
local AREAPICK = AddAction("AREAPICK", STRINGS.ACTIONS.AREAPICK, function(act)
	local equip = act.invobject or act.doer.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
	if act.doer ~= nil and act.target ~= nil and equip ~= nil and equip.components.areapicker ~= nil then
		--harvest single kind of plants, unless we are holding action button, i.e. spacebar
		local sameprefab =
			not (act.target:HasTag("farm_plant") or string.find(act.target.prefab, "flower_cave"))
			and (TUNING.SCYTHE.HARVEST_MODE == 1 or TUNING.SCYTHE.HARVEST_MODE ~= 2
			and act.doer.components.playercontroller ~= nil
			and not act.doer.components.playercontroller:IsControlPressed(GLOBAL.CONTROL_ACTION))
		return equip.components.areapicker:Pick(act.doer, act.target, sameprefab)
	end
end)

AREAPICK.priority = .1			--slightly higher than pick
AREAPICK.canforce = true
AREAPICK.rangecheckfn = NORMAL_PICK.rangecheckfn
AREAPICK.extra_arrive_dist = NORMAL_PICK.extra_arrive_dist
AREAPICK.mount_valid = true

--------ComponentAction---------
AddComponentAction("USEITEM", "areapicker", function(inst, doer, target, actions)
	if inst:HasTag("areapicker") and (target:HasTag("plant") and target:HasTag("pickable") or TargetHasTag(target)) then
		table.insert(actions, AREAPICK)
	end
end)

AddComponentAction("EQUIPPED", "areapicker", function(inst, doer, target, actions)
	if inst:HasTag("areapicker") and (target:HasTag("plant") and target:HasTag("pickable") or TargetHasTag(target)) then
		table.insert(actions, AREAPICK)
	end
end)

-------Stategraph--------

--------ActionHandler---------
local ActionHandler = GLOBAL.ActionHandler
AddStategraphActionHandler("wilson", ActionHandler(AREAPICK, "dojostleaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(AREAPICK, "dojostleaction"))

--------PostInit----------
local scythe_fn = require("scythe_fn")

local ABILITY = AddModConfigTag("FN_")
local EVENTFN = AddModConfigTag("EV_")

-- local official_scythe = require("prefabs/voidcloth_scythe.lua")
local shellfn = function() return false end
local scythe_prop = {
	["SayRandomLine"] = shellfn,
	["ToggleTalking"] = shellfn,
	["DoScythe"] = shellfn,
	["IsEntityInFront"] = shellfn,
	["HarvestPickable"] = shellfn,
}

local function RecordScytheFn(inst)
	local voidscythe = inst.prefab == "voidcloth_scythe" and inst
					or GLOBAL.SpawnPrefab("voidcloth_scythe")
					or nil
	if voidscythe ~= nil then
		for prop in pairs(scythe_prop) do
			scythe_prop[prop] = voidscythe[prop] or shellfn
		end
		if inst.prefab ~= "voidcloth_scythe" and voidscythe.Remove then
			voidscythe:Remove()
		end
	end
	shellfn = nil	--put it outside if check, so that we give up further recording when we cant find void scythe at the first time
end

local scythes = {"scythe", "goldenscythe"}
if GetModConfigData("VOIDSCYTHE") == 1 then
	AddPrefabPostInit("voidcloth_scythe", function(inst)
		inst:AddTag("bramble_resistant")
		inst:AddTag("areapicker")

		if not GLOBAL.TheWorld.ismastersim then return end

		if inst.components.finiteuses ~= nil then
			inst.components.finiteuses:SetConsumption(AREAPICK, 1)
		end

		inst:AddComponent("areapicker")
		inst.components.areapicker:SetRadius(TUNING.SCYTHE.HARVEST_RADIUS)
	end)

	table.insert(scythes, "voidcloth_scythe")
end

for k, v in pairs(scythes) do
	AddPrefabPostInit(v, function(inst)
		if not GLOBAL.TheWorld.ismastersim then return end

		if not GetModConfigData("EXTRADMG") then
			inst.components.weapon:SetDamage(TUNING.SCYTHE.DAMAGE)
		end

		if GetModConfigData("VOIDSCYTHE") == 2 then
			if inst.components.areapicker ~= nil then
				inst:RemoveComponent("areapicker")
			end
		end

		--put them inside "VOIDSCYTHE" == 2 check
		--so that other options "VOIDSCYTHE" ~= 2 are independent from game update
		--ummm, lets keep it outside until problem has happened
		if shellfn ~= nil then
			RecordScytheFn(inst)
		end

		if not inst.scythe_reset then
			for prop in pairs(scythe_prop) do
				inst[prop] = scythe_prop[prop]
			end
			inst.scythe_reset = true
		end

		if not inst.components.areapicker then return end
		inst.components.areapicker:SetPicker(PICKER_TAG)

		for _, key in ipairs(ABILITY) do
			local t = scythe_fn[key]
			if t ~= nil then
				inst.components.areapicker:SetFn(key, t.fn, t.fn_type)
			end
		end

		if #MOD_PREFAB > 0 then
			for _, pref in ipairs(MOD_PREFAB) do
				inst.components.areapicker:AddPickerByPrefab(pref)
			end
		end
	end)
end

--------PlayerController--------
AddComponentPostInit("playercontroller", function(self)
	local OLD_GetActionButtonAction = self.GetActionButtonAction
	local function NEW_GetActionButtonAction(self, buffer)
		if buffer == nil then return end
		local target = buffer.target
		local tool = buffer.invobject
		if buffer.action ~= GLOBAL.ACTIONS.SMOTHER and target ~= nil and (target:HasTag("plant") and target:HasTag("pickable") or TargetHasTag(target)) then
			if tool ~= nil and tool:HasTag("areapicker") then
				buffer.action = AREAPICK
			elseif (GetModConfigData("AUTOEQUIP", true) or GLOBAL.KnownModIndex:IsModEnabled("workshop-651419070"))
				and self.inst.replica.inventory:HasItemWithTag("areapicker", 1) then

				local items = self.inst.replica.inventory:GetItems()
				local item
				for k, v in pairs(items) do
					if v:HasTag("areapicker") then
						item = v
						break
					end
				end
				if self.autoequip_lastequipped ~= nil then		--for auto actions re-equip the origin weapon
					self.autoequip_lastequipped = tool ~= nil and tool or "empty"
				end
				if item ~= nil then
					self.inst.replica.inventory:UseItemFromInvTile(item)
					buffer.invobject = item
					buffer.action = AREAPICK
				end
			end
		end
		return buffer
	end

	function self:GetActionButtonAction(...)
		--I suppose actionbuttonoverride should be placed under IsDoingOrWorking check
		--this is the only reason why usedefault is needed
		--besides, without IsDoingOrWorking check, player always repeate same action before the action has done
		--causing player "dancing" when they are holding spacebar while riding on beefalo
		local buffer = not self:IsDoingOrWorking() and OLD_GetActionButtonAction(self, ...) or nil
		return NEW_GetActionButtonAction(self, buffer)
	end
end)

--------ActtionQueuer--------
AddComponentPostInit("actionqueuer", function(self)
	if self.AddAction ~= nil then
		self.AddAction("allclick", "AREAPICK", true)
		self.AddAction("tools", "AREAPICK", true)
		self.AddAction("autocollect", "AREAPICK", true)
	end
end)