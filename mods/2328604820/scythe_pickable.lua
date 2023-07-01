local json = require("json")
local io = GLOBAL.io
local path = "scythe_prefabs.json"

local function readprefabs()
	local file = io.open(path, "r")
	local str = ""
	if file ~= nil then
		str = file:read()
		file:close()
	end
	local prefabs = str ~= "" and json.decode(str) or {}
	return prefabs
end

local function writeprefabs(data)
	local str = json.encode(data)
	local file = io.open(path, "w")
	file:write(str)
	file:close()
	return str
end

local newprefabs = readprefabs()
local MOD_PREFAB = {GLOBAL.unpack(newprefabs)}

if GetModConfigData("FN_HARVESTABLE") then
	local mushrooms = {"red_mushroom", "green_mushroom", "blue_mushroom"}
	for i, v in ipairs(mushrooms) do
		table.insert(MOD_PREFAB, v)
	end
	table.insert(MOD_PREFAB, "mushroom_farm")
end

if GetModConfigData("FN_SHAVEABLE") then
	table.insert(MOD_PREFAB, "waterplant")
end

local function AddScythePickable(target)
	if target == nil then
		target = GLOBAL.c_sel() or GLOBAL.c_select()
	end
	local prefab = type(target) == "string" and target or target.prefab
	for i, v in ipairs(newprefabs) do
		if v == prefab then
			return
		end
	end
	table.insert(MOD_PREFAB, 1, prefab)
	table.insert(newprefabs, 1, prefab)
	writeprefabs(newprefabs)
end

local function RemoveScythePickable(target)
	if target == nil then
		target = GLOBAL.c_sel() or GLOBAL.c_select()
	end
	local prefab = type(target) == "string" and target or target.prefab
	for i, v in ipairs(newprefabs) do
		if v == prefab then
			table.remove(MOD_PREFAB, i)
			table.remove(newprefabs, i)
			writeprefabs(newprefabs)
			break
		end
	end
end

local function ClearScythePickable()
	for n = 1, #newprefabs do
		table.remove(MOD_PREFAB, 1)
	end
	newprefabs = {}
	writeprefabs({})
end

GLOBAL.AddScythePickable = AddScythePickable
GLOBAL.RemoveScythePickable = RemoveScythePickable
GLOBAL.ClearScythePickable = ClearScythePickable
GLOBAL.CleanScythePickable = ClearScythePickable

env.MOD_PREFAB = MOD_PREFAB