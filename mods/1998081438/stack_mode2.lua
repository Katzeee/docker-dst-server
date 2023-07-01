local STACK_RADIUS = GetModConfigData('StackRadius')
local function FindEntities(x, y, z)
    return TheSim:FindEntities(x, y, z, STACK_RADIUS, {
        '_stackable',
    }, {
        'INLIMBO',
        'NOCLICK',
        'lootpump_oncatch',
        'lootpump_onflight',
    })
end
local function Put(inst, item)
    if item ~= inst and item.prefab == inst.prefab and item.skinname == inst.skinname then
        SpawnPrefab('sand_puff').Transform:SetPosition(item.Transform:GetWorldPosition())
        inst.components.stackable:Put(item)
    end
end
--[[ 标准掉落 ]]
AddPrefabPostInitAny(function(inst)
    if inst:HasTag('smallcreature') or inst:HasTag('heavy') then
        return
    end
    if inst.components.stackable == nil then
        return
    end
    inst:ListenForEvent('xt_stack_on_loot_dropped', function()
        inst:DoTaskInTime(.5, function()
            if inst and inst:IsValid() and not inst.components.stackable:IsFull() then
                for _, item in ipairs(FindEntities(inst.Transform:GetWorldPosition())) do
                    if item and item:IsValid() and not item.components.stackable:IsFull() then
                        Put(inst, item)
                    end
                end
            end
        end)
    end)
    inst:ListenForEvent('on_loot_dropped', function()
        inst:PushEvent('xt_stack_on_loot_dropped')
    end)
end)
local function PrePut(inst, x, y, z, time, ents, prefabs)
    inst:DoTaskInTime(time + FRAMES, function()
        for _, item in ipairs(FindEntities(x, y, z)) do
            if item and item:IsValid() and (prefabs == nil or table.contains(prefabs, item.prefab)) and not table.contains(ents, item) then
                item:PushEvent('xt_stack_on_loot_dropped')
            end
        end
    end)
end
--[[ 猪王交易 ]]
AddPrefabPostInit('pigking', function(inst)
    if inst.components.trader == nil or inst.components.trader.onaccept == nil then
        return
    end
    local OnGetItemFromPlayer = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(inst, giver, item, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local prefabs = {
            'goldnugget',
        }
        if item.components.tradable.tradefor then
            for _, v in ipairs(item.components.tradable.tradefor) do
                table.insert(prefabs, v)
            end
        end
        if IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) then
            for i = 1, NUM_HALLOWEENCANDY do
                table.insert(prefabs, 'halloweencandy_' .. i)
            end
        end
        OnGetItemFromPlayer(inst, giver, item, ...)
        PrePut(inst, x, y, z, 2 / 3, ents, prefabs)
    end
end)
--[[ 鱼王交易 ]]
AddPrefabPostInit('mermking', function(inst)
    if inst.TradeItem == nil then
        return
    end
    local TradeItem = inst.TradeItem
    inst.TradeItem = function(inst, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local prefabs = {
            'kelp',
            'seeds',
            'spoiled_food',
            'tentaclespots',
            'trinket_12',
            'trinket_3',
            'trinket_25',
            'trinket_17',
            'trinket_4',
            'durian_seeds',
            'pepper_seeds',
            'eggplant_seeds',
            'pumpkin_seeds',
            'onion_seeds',
            'garlic_seeds',
        }
        TradeItem(inst, ...)
        PrePut(inst, x, y, z, 0, ents, prefabs)
    end
end)
--[[ 蚁狮交易 ]]
AddPrefabPostInit('antlion', function(inst)
    if inst.GiveReward == nil then
        return
    end
    local GiveReward = inst.GiveReward
    inst.GiveReward = function(inst, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local prefabs = {
            inst.pendingrewarditem,
        }
        GiveReward(inst, ...)
        PrePut(inst, x, y, z, 0, ents, prefabs)
    end
end)
--[[ 神话聚宝盆交易 ]]
AddPrefabPostInit('myth_treasure_bowl', function(inst)
    if inst.components.trader == nil or inst.components.trader.onaccept == nil then
        return
    end
    local OnGetItemFromPlayer = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(inst, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local prefabs = nil
        OnGetItemFromPlayer(inst, ...)
        PrePut(inst, x, y, z, .5, ents, prefabs)
    end
end)
--[[ 猪人便便 ]]
AddPrefabPostInit('pigman', function(inst)
    if inst.components.eater == nil or inst.components.eater.oneatfn == nil then
        return
    end
    local OnEat = inst.components.eater.oneatfn
    inst.components.eater.oneatfn = function(inst, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local prefabs = {
            'poop',
        }
        OnEat(inst, ...)
        PrePut(inst, x, y, z, 0, ents, prefabs)
    end
end)
--[[ 石果开采 ]]
AddPrefabPostInit('rock_avocado_fruit', function(inst)
    if inst.components.workable == nil or inst.components.workable.onwork == nil then
        return
    end
    local on_mine = inst.components.workable.onwork
    inst.components.workable.onwork = function(inst, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local prefabs = {
            'rock_avocado_fruit_ripe',
            'rock_avocado_fruit_sprout',
            'rocks',
        }
        if KnownModIndex:IsModEnabled('workshop-1944492666') then
            --[[ 覆盖式改动? 你的优先级也太低了! ]]
            table.insert(prefabs, 'ice')
            table.insert(prefabs, 'nitre')
            table.insert(prefabs, 'flint')
        end
        on_mine(inst, ...)
        PrePut(inst, x, y, z, 0, ents, prefabs)
    end
end)
--[[ 熊大毛丛 ]]
AddPrefabPostInit('bearger', function(inst)
    if inst.components.shedder == nil or inst.components.shedder.DoSingleShed == nil then
        return
    end
    local DoSingleShed = inst.components.shedder.DoSingleShed
    inst.components.shedder.DoSingleShed = function(self, ...)
        local item = DoSingleShed(self, ...)
        if item then
            item:PushEvent('xt_stack_on_loot_dropped')
        end
        return item
    end
end)
--[[ 邪天翁羽毛 ]]
AddPrefabPostInit('malbatross_feather_fall', function(inst)
    if inst.event_listeners == nil or inst.event_listeners.animover == nil or inst.event_listeners.animover[inst] == nil or inst.event_listeners.animover[inst][1] == nil then
        return
    end
    local fn = inst.event_listeners.animover[inst][1]
    inst.event_listeners.animover[inst][1] = function(...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local prefabs = {
            'malbatross_feather',
        }
        fn(...)
        PrePut(inst, x, y, z, 0, ents, prefabs)
    end
end)
--[[ 格罗姆黏液 ]]
AddPrefabPostInit('glommer', function(inst)
    if inst.components.periodicspawner == nil or inst.components.periodicspawner.TrySpawn == nil then
        return
    end
    local TrySpawn = inst.components.periodicspawner.TrySpawn
    inst.components.periodicspawner.TrySpawn = function(self, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local prefabs = {
            'glommerfuel',
        }
        local bool = TrySpawn(self, ...)
        if bool then
            PrePut(inst, x, y, z, 0, ents, prefabs)
        end
        return bool
    end
end)
--[[ 灰烬 ]]
AddPrefabPostInit('ash', function(inst)
    inst:DoTaskInTime(FRAMES, function()
        if inst.components.inventoryitem == nil or inst.components.inventoryitem.owner then
            return
        end
        inst:PushEvent('xt_stack_on_loot_dropped')
    end)
end)
--[[ 风滚草采集 ]]
AddPrefabPostInit('tumbleweed', function(inst)
    if inst.components.pickable == nil or inst.components.pickable.onpickedfn == nil then
        return
    end
    local onpickup = inst.components.pickable.onpickedfn
    inst.components.pickable.onpickedfn = function(inst, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local prefabs = inst.loot
        onpickup(inst, ...)
        PrePut(inst, x, y, z, 0, ents, prefabs)
        return true
    end
end)
--[[ 包裹拆解 ]]
AddComponentPostInit('unwrappable', function(self, inst)
    local loottable = {
        bundle = {
            'waxpaper',
        },
        gift = {},
        redpouch = {
            'lucky_goldnugget',
        },
        redpouch_yotp = {},
        redpouch_yotc = {},
        yotc_seedpacket = {
            'seeds',
            'carrot_seeds',
            'corn_seeds',
            'tomato_seeds',
            'pumpkin_seeds',
            'eggplant_seeds',
            'potato_seeds',
            'watermelon_seeds',
        },
        yotc_seedpacket_rare = {
            'carrot_seeds',
            'corn_seeds',
            'tomato_seeds',
            'pumpkin_seeds',
            'eggplant_seeds',
            'potato_seeds',
            'watermelon_seeds',
            'asparagus_seeds',
            'pomegranate_seeds',
            'durian_seeds',
            'dragonfruit_seeds',
        },
        hermit_bundle = {},
        hermit_bundle_shells = {},
        wetpouch = {
            'antliontrinket',
            'trinket_1',
            'trinket_3',
            'trinket_8',
            'trinket_9',
            'trinket_26',
        },
        --[[ 神话蕉叶包裹 ]]
        myth_bundle = {
            'myth_banana_leaf',
        },
    }
    if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
        for i = 1, 12 do
            table.insert(loottable.wetpouch, 'winter_ornament_plain' .. i)
        end
        for i = 1, 8 do
            table.insert(loottable.wetpouch, 'winter_ornament_fancy' .. i)
        end
    end
    local Unwrap = self.Unwrap
    self.Unwrap = function(self, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local prefabs = {}
        if self.itemdata then
            for _, v in ipairs(self.itemdata) do
                table.insert(prefabs, v.prefab)
            end
        end
        if loottable[inst.prefab] then
            for _, v in ipairs(loottable[inst.prefab]) do
                table.insert(prefabs, v)
            end
        end
        Unwrap(self, ...)
        PrePut(inst, x, y, z, 0, ents, prefabs)
    end
end)
--[[ 地皮挖掘 ]]
AddComponentPostInit('terraformer', function(self, inst)
    -- local MOD_GROUND_TURFS = nil
    -- if KnownModIndex:IsModEnabled("workshop-1289779251") then
    -- 	--[[ To Cherry Forest: 你终于追加了! ]]
    -- 	--[[ To Cherry Forest: 为什么不把 MOD_GROUND_TURFS 追加到 GroundTiles.turf 呢? ]]
    -- 	if MOD_GROUND_TURFS == nil then MOD_GROUND_TURFS = {} end
    -- 	MOD_GROUND_TURFS[GROUND.CHERRY] = "turf_cherry"
    -- 	MOD_GROUND_TURFS[GROUND.CHERRY2] = "turf_cherry2"
    -- 	MOD_GROUND_TURFS[GROUND.CHERRY3] = "turf_cherry3"
    -- 	MOD_GROUND_TURFS[GROUND.CHERRY4] = "turf_cherry4"
    -- end
    local GroundTiles = require('worldtiledefs')
    local Terraform = self.Terraform
    self.Terraform = function(self, pt, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local original_tile_type = TheWorld.Map:GetTileAtPoint(pt:Get())
        local bool = Terraform(self, pt, ...)
        if bool then
            -- local spawnturf2 = MOD_GROUND_TURFS and MOD_GROUND_TURFS[original_tile_type] or nil
            -- if spawnturf2 then table.insert(prefabs, spawnturf2) end
            local spawnturf = GroundTiles.turf[original_tile_type] or nil
            if spawnturf then
                PrePut(inst, x, y, z, 0, ents, {
                    'turf_' .. spawnturf.name,
                })
            end
        end
        return bool
    end
end)
--[[ 食物腐烂 ]]
AddComponentPostInit('perishable', function(self, inst)
    local Perish = self.Perish
    self.Perish = function(self, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local onperishreplacement = self.onperishreplacement
        local owner = self.inst.components.inventoryitem and self.inst.components.inventoryitem.owner or nil
        Perish(self, ...)
        if onperishreplacement and owner == nil then
            PrePut(inst, x, y, z, 0, ents, {
                onperishreplacement,
            })
        end
    end
end)
--[[ 刮剃 ]]
AddComponentPostInit('beard', function(self, inst)
    local Shave = self.Shave
    self.Shave = function(self, ...)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = FindEntities(x, y, z)
        local prize = self.prize
        local bool, reason = Shave(self, ...)
        if bool and prize then
            PrePut(inst, x, y, z, 0, ents, {
                prize,
            })
        end
        return bool, reason
    end
end)
