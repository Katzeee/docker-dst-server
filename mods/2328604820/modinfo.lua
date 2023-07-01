name = "Scythe"
author = "CC"
version = "2.0.1"
description =
[[
Harvest your crop easily.

Main feature:
-Harvest faster
-Allow area harvest
-Allow area damage

Other feature:
-seasoning buffable
-immune to thorns

Extra function:(set in config options)
-low chance to get an extra drop from harvest
-plants harvested with scythe get a small growth boost
-transplanted plant can harvest more times before wither

Most languages are translated by google

This mod is inspired by [DST]-Scythes created by Captain_M
]]

api_version = 10

dst_compatible = true

all_clients_require_mod = true
client_only_mod = false

server_filter_tags = {"scythe"}

icon_atlas = "scythe.xml"
icon = "scythe.tex"

forumthread = ""

local function AddOption(data, description, hover)
	return {description = description, data = data, hover = hover}
end
local BoolOpt = {
	AddOption(false, "no"),
	AddOption(true, "yes"),
}
local SecOpt = {AddOption(false, "")}
local function AddConfig(name, label, default, options, hover, client)
	return {name = name, label = label, hover = hover, options = options, default = default, client = client}
end
configuration_options =
{
	AddConfig("LANGUAGE", "Language", "default",
		{
			AddOption("default", "default", "follow your game setting"),
			AddOption("en", "english"),
			AddOption("zh", "简体中文"),
			AddOption("zht", "繁體中文"),
			AddOption("jp", "日本語"),
			AddOption("ko", "한국어"),
			AddOption("ru", "русский язык"),
			AddOption("pl", "język polski"),
			AddOption("pt", "português"),
			AddOption("it", "italiano"),
			AddOption("de", "deutsch"),
			AddOption("es", "spainish"),
			AddOption("fr", "français"),
		},
		"Did nothings but help you change the item descriptions in line with your language mod. Most languages are translated by google"
	),
	AddConfig("USES", "Durabiliy", 75,
		{
			AddOption(50, "low", "50 uses"),
			AddOption(75, "medium", "75 uses"),
			AddOption(100, "high", "100 uses"),
			AddOption(125, "very high", "125 uses"),
		}
	),
	AddConfig("RADIUS", "Area", 6,
		{
			AddOption(0, "disable", "disable area harvest, and area damage"),
			AddOption(2, "very small", "half turf(horizontal)"),
			AddOption(4, "small", "1 turf(horizontal)"),
			AddOption(6, "moderate", "1 turf(diagonal)"),
			AddOption(8, "large", "2 turf(horizontal)"),
		},
		"Harvest radius(not attack)\n**attack radius fix at half turf"
	),
	AddConfig("DAMAGE", "Damage", 27.2,
		{
			AddOption(17, "low", "6 attack to kill a spider, =walking cane"),
			AddOption(27.2, "medium", "4 attack to kill a spider, =axe"),
			AddOption(34, "high", "3 attack to kill a spider, =spear"),
		}
	),
	AddConfig("VOIDSCYTHE", "Shadow Reaper", 1,
		{
			AddOption(0, "Unchange", "No change on shadow reaper harvest mechanism"),
			AddOption(1, "Modded", "Change shadow reaper harvest mechanism"),
			AddOption(2, "Official", "Make modded scythe harvest mechanism in line with shadow reaper"),
		}
	),
	AddConfig("AREADMG", "Area Damage", true, BoolOpt),
	AddConfig("EXTRADMG", "Extra Damage to Plant", true, BoolOpt,
		"Deal 1.5 times damage to plant-type mobs(eg. eyeplants)\nTurn this off may help on crashes with some data showing mods"
	),
	AddConfig("MIGHTINESS", "Mightiness Gain", 1,
		{
			AddOption(0, "disable", "will not gain mightiness after harvest action"),
			AddOption(.5, "little", "gain 0.5 mightiness per harvest action"),
			AddOption(1, "medium", "gain 1 mightiness per harvest action"),
			AddOption(2, "large", "gain 2 mightiness per harvest action"),
		},
		"Mightiness gain after each harvest action"
	),
	AddConfig("MODE", "Pick Mode", 3,
		{
			AddOption(1, "Single Species", "only same species will be picked in 1 harvest"),
			AddOption(2, "All Pickable", "all nearby plant will be picked"),
			AddOption(3, "Combine", "hold spacebar to pick all species, single click to harvest 1 species"),
		}
	),
	AddConfig("AUTOEQUIP", "Auto Equip", false,
		{
			AddOption(false, "no"),
			AddOption(true, "yes", "you will not re-equip original weapon unless you are using Auto Action."),
		},
		"Auto equip scythe when you are using space action.\nOptimized when used with Mod: Auto Actions - Full client mod.", true
	),
	AddConfig("", "Other Pickable Prefabs", false, SecOpt),
	AddConfig("PICKER_KELP", "Kelp", true, BoolOpt),
	AddConfig("PICKER_LUREPLANT", "Lureplant", true, BoolOpt),
	AddConfig("PICKER_OCEANVINE", "Fig", true, BoolOpt),
	AddConfig("PICKER_LICHEN", "Lichen", true, BoolOpt),
	AddConfig("FN_HARVESTABLE", "Mushroom", false, BoolOpt),
	AddConfig("FN_SHAVEABLE", "Barnacle", false, BoolOpt),
	AddConfig("PICKER_DRIED", "Drying Rack", false, BoolOpt),
	AddConfig("PICKER_BEEBOX", "Bee Box", false, BoolOpt),
	AddConfig("", "Extra Functions", false, SecOpt),
	AddConfig("FN_EXTRAITEMS", "extra drops", false, BoolOpt, "small chance get an extra drops(seed for crops)"),
	AddConfig("FN_EXTRAPICKS", "more collection", false, BoolOpt, "transplanted plant can harvest more times before wither"),
	AddConfig("FN_FASTGROWTH", "faster growth", false, BoolOpt, "plants harvested with scythe get a small growth boost"),
	AddConfig("FN_PICKALLFIG", "pick all figs", false, BoolOpt, "pick all nearby figs with one harvest"),
}

local function TranslateConfig(translate)
	local n = 1
	for i = 1, #configuration_options do
		local opt_name = configuration_options[i].name
		if translate[opt_name] then
			if translate[opt_name][1] ~= nil then	--istable
				configuration_options[i].label = translate[opt_name][1]
				configuration_options[i].hover = translate[opt_name][2]
				if translate[opt_name][3] then
					configuration_options[i].options = translate[opt_name][3]
				end
				if translate[opt_name][4] then
					configuration_options[i].default = translate[opt_name][4]
				end
			else
				configuration_options[i].label = translate[opt_name]
			end
		elseif opt_name == "" then	--if is section title
			configuration_options[i].label = translate.section[n]
			n = n + 1
		end
	end
end
if locale == "zh" or locale == "zht" then
	name = "镰刀"
	description = 
	[[
	让你收获得更轻松。

	主要特点：
	-收获更快
	-可以范围收获
	-可以范围伤害

	其他特点：
	-可被调味品增幅
	-免疫尖刺反伤

	其他功能：（在配置选项中设置）
	-低概率额外获得掉落物
	-移植的植物在枯萎前可以收获更多次
	-加快用镰刀收割的植物生长时间

	更多详情点击↘小地球

	This mod is inspired by [DST]-Scythes created by Captain_M
	]]

	BoolOpt[1].description = "否"
	BoolOpt[2].description = "是"
	local cn_translate = {
		["LANGUAGE"] = {"语言", "", {
			AddOption("default", "default", "follow your game setting"),
			AddOption("en", "english"),
			AddOption("zh", "简体中文"),
			AddOption("zht", "繁體中文"),
		}},
		["USES"] = {"耐久", "", {
			AddOption(50, "低", "50次"),
			AddOption(75, "中", "75次"),
			AddOption(100, "高", "100次"),
			AddOption(125, "超高", "125次"),
		}},
		["RADIUS"] = {"范围", "收割范围", {
			AddOption(0, "关闭", "关闭范围采集，同时关闭范围攻击"),
			AddOption(2, "超小", "半个地皮(水平)"),
			AddOption(4, "小", "1地皮(水平)"),
			AddOption(6, "中", "1地皮(对角)"),
			AddOption(8, "大", "2地皮(水平)"),
		}},
		["DAMAGE"] = {"伤害", "", {
			AddOption(17, "低", "6下1蜘蛛, =手杖"),
			AddOption(27.2, "中", "4下1蜘蛛, =斧头"),
			AddOption(34, "高", "3下1蜘蛛, =长矛"),
		}},
		["VOIDSCYTHE"] = {"暗影镰刀", "", {
			AddOption(0, "不变", "不改变暗影镰刀的收割机制"),
			AddOption(1, "模组", "暗影镰刀将会使用本模组的收割机制"),
			AddOption(2, "官方", "模组镰刀将会使用暗影镰刀的收割机制"),
		}},
		["AREADMG"] = "范围伤害",
		["EXTRADMG"] = {"对植物特攻", "对植物造成1.5倍伤害(如眼球草)\n如与物品信息显示模组冲突, 请关闭此选项"},
		["MIGHTINESS"] = {"筋肉值", "每次收割动作获得的筋肉值", {
			AddOption(0, "关闭", "收割动作将不会获得筋肉值"),
			AddOption(.5, "较少", "每次收割动作会获得 0.5 筋肉值"),
			AddOption(1, "中等", "每次收割动作会获得 1 筋肉值"),
			AddOption(2, "较多", "每次收割动作会获得 2 筋肉值"),
		}},
		["MODE"] = {"采集模式", "", {
			AddOption(1, "同种类", "1 次采集只能收获 1 种植物"),
			AddOption(2, "全种类", "附近所有植物都会收获"),
			AddOption(3, "看心情", "长按空格键收获全种类, 点击收获同种类"),
		}},
		["AUTOEQUIP"] = {"自动装备", "当你使用空格键动作时自动装备镰刀\n建议与模组: Auto Actions - Full client mod一起使用", {
			AddOption(false, "否"),
			AddOption(true, "是", "除非你使用Auto Actions, 否则将不会重新装备原来的武器"),
		}},
		["PICKER_KELP"] = "海带",
		["PICKER_LUREPLANT"] = "食人花",
		["PICKER_OCEANVINE"] = "无花果",
		["PICKER_LICHEN"] = "苔蘚",
		["FN_HARVESTABLE"] = "蘑菇",
		["FN_SHAVEABLE"] = "藤壶",
		["PICKER_DRIED"] = "晾肉架",
		["PICKER_BEEBOX"] = "蜂箱",
		["FN_EXTRAITEMS"] = {"额外掉落", "小概率额外获得一个掉落物"},
		["FN_EXTRAPICKS"] = {"更多收获次数", "增加移植的植物在枯萎前的收获次数"},
		["FN_FASTGROWTH"] = {"生长加速", "加快用镰刀收割的植物的生长时间"},
		["FN_PICKALLFIG"] = {"收获所有无花果", "直接收获附近所有无花果"},
		section = {
			[1] = "其他可收割物品",
			[2] = "其他功能",
		}
	}
	TranslateConfig(cn_translate)
end