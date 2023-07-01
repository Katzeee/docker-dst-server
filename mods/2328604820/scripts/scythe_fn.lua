local scythe_fn = {
	extrapicks = {
		fn = function(owner, target)				--more no. of harvest
				local pickable = target.components.pickable
				if pickable ~= nil and pickable.canbepicked and pickable.caninteractwith then
					if pickable.transplanted and pickable.cycles_left ~= nil then
						pickable.cycles_left = pickable.cycles_left + (1 - 1 / TUNING.SCYTHE.EXTRAPICK_MULTIPIER)
					end
					if pickable.protected_cycles ~= nil then
						pickable.protected_cycles = pickable.protected_cycles + (1 - 1 / TUNING.SCYTHE.EXTRAPICK_MULTIPIER)
					end
				end
			end,
		fn_type = "before"
	},
	extraitems = {
		fn = function(owner, target)			--give an addional product(extra seed for farm plant)
				local pickable = target.components.pickable
				local item = 
					target.components.crop ~= nil and target.components.crop.product_prefab or
					pickable ~= nil and (
						pickable.product ~= nil and pickable.product or
						target.is_oversized == true and target.plant_def.product or
						pickable.use_lootdropper_for_product ~= nil and target.components.lootdropper:GenerateLoot()[2]
					) or nil
				local w = math.random()
				while w <= TUNING.SCYTHE.EXTRAITEM_CHANCE do
					if item ~= nil then
						local item = SpawnPrefab(item)
						item.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
						local pt = target:GetPosition()
						if target.components.pickable.droppicked then
							pt.y = pt.y + (target.components.pickable.dropheight or 0)
							target.components.lootdropper:FlingItem(item, pt)
						else
							owner.components.inventory:GiveItem(item, nil, pt)
						end
					end
					w = w + 1
				end
			end,
		fn_type = 0
	},
	fastgrowth = {
		fn = function(owner, target)				--growth boost
				local pickable = target.components.pickable
				if pickable ~= nil and pickable.regentime ~= nil and not (pickable.paused or pickable:IsBarren() or target:HasTag("withered")) then
					if pickable.useexternaltimer then
						pickable.setregentimertime(target, pickable.getregentimertime(target) * TUNING.SCYTHE.GROWTH_MULTIPIER)
						return
					end
					pickable.regentime = math.floor(pickable.regentime * TUNING.SCYTHE.GROWTH_MULTIPIER)
					if pickable.task ~= nil then
						pickable.task:Cancel()
					end
					pickable.task = target:DoTaskInTime(pickable.regentime, function(inst) inst.components.pickable:Regen() end)
					pickable.targettime = GetTime() + pickable.regentime
				end
			end,
		fn_type = "a"
	},--[[
	pickallfig = {
		fn = function(owner, target, inst)
				if target:HasTag("oceanvine") then
					local radius = TUNING.SHADE_CANOPY_RANGE_SMALL + TUNING.WATERTREE_PILLAR_CANOPY_BUFFER
					local use = 0
					while target do
						local x, y, z = target.Transform:GetWorldPosition()
						local ent = TheSim:FindEntities(x, y, z, radius, {"oceanvine", "pickable"})
						target = ent[1]
						if target then
							target.components.pickable:Pick(owner)
							use = use + 1
						end
					end
					inst.components.finiteuses:Use(use)
				end
			end,
		fn_type = "2"
	},]]
	pickallfig = {
		fn = function(owner, target, scythe)
				if target:HasTag("oceanvine") then
					local radius = TUNING.SHADE_CANOPY_RANGE_SMALL + TUNING.WATERTREE_PILLAR_CANOPY_BUFFER
					local x, y, z = target.Transform:GetWorldPosition()
					local ent = TheSim:FindEntities(x, y, z, radius, {"tree", "shelter"})
					for i, v in ipairs(ent) do
						if string.find(v.prefab, "oceantree") then
							x, y, z = v.Transform:GetWorldPosition()
							break
						end
					end
					local use = 0
					local fig = TheSim:FindEntities(x, y, z, radius, {"oceanvine", "pickable"}, {"FX", "DECOR", "NOCLICK", "INLIMBO"})
					for i, v in ipairs(fig) do
						v.components.pickable:Pick(owner)
						use = use + 1
					end
					scythe.components.finiteuses:Use(use)
				end
			end,
		fn_type = 2
	},
	harvestable = {
		fn = function(owner, target)
				if target:HasTag("mushroom_farm") then
					local harvestable = target.components.harvestable
					if harvestable.produce >= harvestable.maxproduce then
						return harvestable:Harvest(owner)
					end
				end
				return false
			end,
		fn_type = 1
	},
	shaveable = {
		fn = function(owner, target, scythe)
				if target:HasTag("waterplant") then
					return target.components.shaveable:Shave(owner, scythe)
				end
				return false
			end,
		fn_type = 1
	},
	hackable = {
		fn = function(owner, target, scythe)
			local finiteuses = scythe.components.finiteuses
			local hackable = target.components.hackable
			local numworks = hackable.hacksleft
			if finiteuses ~= nil and numworks >= 1 then
				local uses = (numworks - 1) * finiteuses.consumption[ACTIONS.AREAPICK] * 2 + 1
				if doer.components.efficientuser ~= nil then
					uses = uses * (doer.components.efficientuser:GetMultiplier(ACTIONS.AREAPICK) or 1)
				end
				finiteuses:Use(uses)
			end
			return hackable:Hack(owner, numworks)
		end,
		fn_type = 1
	},
	winters_feast = {
		fn = function(owner, target)
			if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
				local num = string.format("%d", math.random(NUM_WINTERFOOD))
				if math.random() <= .01 then
					LaunchAt(SpawnPrefab("winter_food"..num), target, owner)
				end
			end
		end,
		fn_type = 2
	},
	yot = {
		fn = function(owner, target)
			if IsAny_YearOfThe_EventActive() then
				local delay = math.max(math.random(-3, 10), 0)
				local firecrackers = SpawnPrefab("firecrackers")
				LaunchAt(firecrackers, target, owner)
				firecrackers:DoTaskInTime(delay, function(inst)
					inst.components.burnable:Ignite()
				end)
			end
		end,
		fn_type = 2
	},
--[[
	shelf = {			--key should be the component name
		fn = function(owner, target)
				target.components.shelf:TakeItem(owner)
			end,
		fn_type = ""
	}
]]
}
--[[
fn_list = {key1 = {fn = function() end, fn_type = ""},}

fn_type:	pick_after_fn	: 2 or "after" or "pick_after_fn" or "a";
			pick_while_fn	: 1 or "while" or "pick_while_fn" or "";
			pick_before_fn	: 0 or "before" or "pick_before_fn" or "b";

for key, v in pairs(fn_list) do
	inst.components.areapicker:SetFn(key, v.fn, v.fn_type)
end
]]

return scythe_fn


--[[
local function SuperHarvest(player, action, ...)
	local radius = TUNING.SCYTHE.HARVEST_RADIUS
	local x, y, z = player.Transform:GetWorldPosition()
	local y_step = 1.5*radius
	local x_step = y/math.sin(60)
	local angle = math.pi() * 2 / 3
	local new_collect = false
	local n = 1
	repeat
		x = x + x_step
		y = y + y_step
		local ents = TheSim:FindEntities(x, y, z, radius, ...)
		for k, v in pairs(ents) do
			action(player)
		end
		if ents ~= nil and #ents ~= 0 then
			new_collect = true
		end
		for m = 1, 6 do
			for xy = 1, n do
				x = x + x_step * math.cos(m * angle)) * 2
				y = y + y_step * math.sin(m * angle) / math.sin(angle)
				ents = TheSim:FindEntities(x, y, z, radius, ...)
				for k, v in pairs(ents) do
					action(player)
				end
				if ents ~= nil and #ents ~= 0 then
					new_collect = true
				end
			end
		end
		if n > 6 then break end
		n = n + 1
	until (not new_collect)
end
]]