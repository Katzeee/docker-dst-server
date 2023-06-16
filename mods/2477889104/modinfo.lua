name = "Beefalo Status Bar"
description = "A status bar for your beefalo mount.\n\n" ..
"Shows health, domestication and tendency, obedience, ride timer, saddle uses and hunger when riding a beefalo.\n\n" ..
"Server configuration is used by default and will apply to all clients on the server. " ..
"Individual clients can choose to override this and use their own configuration from the client configuration screen.\n\n" ..
"Server Configuration: Host Game -> World -> Mods\n" ..
"Client Configuration: Main Menu -> Mods -> Server Mods"
author = "MNK"
version = "1.2.0"
forumthread = ""

dont_starve_compatible = false
reign_of_giants_compatible = true
dst_compatible = true

api_version = 10

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "icon.xml"
icon = "icon.tex"


local colors = {
    {name = "ORANGE", description = "Orange"},
    {name = "ORANGE_ALT", description = "Orange Alt"},
    {name = "BLUE", description = "Blue"},
    {name = "BLUE_ALT", description = "Blue Alt"},
    {name = "PURPLE", description = "Purple"},
    {name = "PURPLE_ALT", description = "Purple Alt"},
    {name = "RED", description = "Red"},
    {name = "RED_ALT", description = "Red Alt"},
    {name = "GREEN", description = "Green"},
    {name = "GREEN_ALT", description = "Green Alt"},
    {name = "WHITE", description = "White"},
    {name = "YELLOW", description = "Yellow"}
}

local function GenerateCommonOptions(start, count, step, default, prefix, suffix)
    local options = {}
    local current = start
    local suffix = suffix or ""
    for i = 1, count do
        local prefix = prefix and (current > 0 and "+" or "") or ""
        options[i] = {description = prefix .. current .. suffix, data = current}
        if current == default then options[i].hover = "Default" end
        current = current + step
    end
    return options
end

local function GenerateMultiplierOptions()
    local options = {}
    for i = 1, 20 do
        if i ~= 1 then
            options[i] = {description = "x" .. i, data = i}
        else
            options[i] = {description = "None", data = i, hover = "Default"}
        end
    end
    return options
end

local function GenerateColorOptions(default)
    local colorOptions = {}
    for i = 1, #colors do
        colorOptions[i] = {description = colors[i].description, data = colors[i].name}
        if default == colors[i].name then colorOptions[i].hover = "Default" end
    end
    return colorOptions
end

local offsets = GenerateCommonOptions(-200, 81, 5, 0, true)
local fineOffsets = GenerateCommonOptions(-50, 101, 1, 0, true)
local offsetMultipliers = GenerateMultiplierOptions()

configuration_options = {
    {
        name = "SEPARATOR_GENERAL",
        label = "General",
        options = {{description = "", data = 1}},
        default = 1
    },
    {
        name = "ShowByDefault",
        label = "Show Automatically",
        hover = "Show the status bar automatically when you mount a beefalo.",
        options = {
            {description = "Enabled", data = true, hover = "Default"},
            {description = "Disabled", data = false}
        },
        default = true
    },
    {
        name = "ToggleKey",
        label = "Toggle Key",
        hover = "Press this key (when mounted) to toggle the status bar.\nToggling will override \"Show Automatically\" for the current shard session.",
        options = {
            {description = "T", data = "KEY_T", hover = "Default"},
            {description = "O", data = "KEY_O"},
            {description = "P", data = "KEY_P"},
            {description = "G", data = "KEY_G"},
            {description = "H", data = "KEY_H"},
            {description = "Z", data = "KEY_Z"},
            {description = "X", data = "KEY_X"},
            {description = "C", data = "KEY_C"},
            {description = "V", data = "KEY_V"},
            {description = "B", data = "KEY_B"}
        },
        default = "KEY_T"
    },
    {
        name = "EnableSounds",
        label = "Sounds",
        hover = "Play a sound when showing or hiding the status bar.",
        options = {
            {description = "Disabled", data = false, hover = "Default"},
            {description = "Enabled", data = true}
        },
        default = false
    },
    {
        name = "ClientConfig",
        label = "Prefer Client Configuration",
        hover = "When enabled, server configuration will be ignored.\nConfigurations from this screen will be used on every server you join or host.",
        options = {
            {description = "Disabled", data = false, hover = "Default"},
            {description = "Enabled", data = true}
        },
        default = false,
        client = true
    },
    {
        name = "SEPARATOR_BADGE_SETTINGS",
        label = "Badge Settings",
        options = {{description = "", data = 1}},
        default = 1
    },
    {
        name = "Theme",
        label = "Theme",
        hover = "Change the theme of the badges.",
        options = {
            {description = "The Forge", data = "TheForge", hover = "Default"},
            {description = "Default Theme", data = "Default", hover = "Uses the default game theme. Compatible with most HUD reskin mods."}
        },
        default = "TheForge"
    },
    {
        name = "Scale",
        label = "Scale",
        hover = "Controls the scale (size) of the badges.",
        options = {
            {description = "0.5", data = 0.5},
            {description = "0.6", data = 0.6},
            {description = "0.7", data = 0.7},
            {description = "0.8", data = 0.8},
            {description = "0.9", data = 0.9},
            {description = "1", data = 1.0, hover = "Default"},
            {description = "1.1", data = 1.1},
            {description = "1.2", data = 1.2},
            {description = "1.3", data = 1.3},
            {description = "1.4", data = 1.4},
            {description = "1.5", data = 1.5},
            {description = "1.6", data = 1.6},
            {description = "1.7", data = 1.7},
            {description = "1.8", data = 1.8},
            {description = "1.9", data = 1.9},
            {description = "2.0", data = 2.0}
        },
        default = 1.0
    },
    {
        name = "HungerThreshold",
        label = "Hunger Badge Threshold",
        hover = "A beefalo needs to have at least this amount of hunger to activate the badge.",
        options = GenerateCommonOptions(5, 30, 5, 10, false),
        default = 10
    },
    {
        name = "HEALTH_BADGE_CLEAR_BG",
        label = "Health Badge Background",
        hover = "Distinct: Uses a distinct background. Brightness and opacity will not apply.\nStandard: Uses a standard background. Brightness and opacity will apply.",
        options = {
            {description = "Distinct", data = false, hover = "Default"},
            {description = "Standard", data = true}
        },
        default = false
    },
    {
        name = "BADGE_BG_BRIGHTNESS",
        label = "Background Brightness",
        hover = "Controls the background brightness of the badges.",
        options = GenerateCommonOptions(5, 21, 5, 60, false, "%"),
        default = 60
    },
    {
        name = "BADGE_BG_OPACITY",
        label = "Background Opacity",
        hover = "Controls the background opacity (transparency) of the badges.\n100% - No transparency, 0% - Fully transparent.",
        options = GenerateCommonOptions(0, 21, 5, 100, false, "%"),
        default = 100
    },
    {
        name = "GapModifier",
        label = "Gap Modifier",
        hover = "Controls the empty space between the badges.\n Negative values - less space, positive values - more space.",
        options = GenerateCommonOptions(-15, 46, 1, 0, true),
        default = 0
    },
    {
        name = "SEPARATOR_BADGE_COLORS",
        label = "Badge Colors",
        options = {{description = "", data = 1}},
        default = 1
    },
    {
        name = "COLOR_DOMESTICATION_ORNERY",
        label = "Domestication (Ornery)",
        hover = "Domestication badge color for Ornery beefalo.",
        options = GenerateColorOptions("ORANGE"),
        default = "ORANGE"
    },
    {
        name = "COLOR_DOMESTICATION_RIDER",
        label = "Domestication (Rider)",
        hover = "Domestication badge color for Rider beefalo.",
        options = GenerateColorOptions("BLUE"),
        default = "BLUE"
    },
    {
        name = "COLOR_DOMESTICATION_PUDGY",
        label = "Domestication (Pudgy)",
        hover = "Domestication badge color for Pudgy beefalo.",
        options = GenerateColorOptions("PURPLE"),
        default = "PURPLE"
    },
    {
        name = "COLOR_DOMESTICATION_DEFAULT",
        label = "Domestication (Default)",
        hover = "Domestication badge color for Default beefalo.",
        options = GenerateColorOptions("WHITE"),
        default = "WHITE"
    },
    {
        name = "COLOR_OBEDIENCE",
        label = "Obedience",
        hover = "Obedience badge color.",
        options = GenerateColorOptions("RED"),
        default = "RED"
    },
    {
        name = "COLOR_TIMER",
        label = "Ride Timer",
        hover = "Ride Timer badge color.",
        options = GenerateColorOptions("GREEN"),
        default = "GREEN"
    },
    {
        name = "SEPARATOR_POSITIONING_X",
        label = "Positioning X",
        options = {{description = "", data = 1}},
        default = 1
    },
    {
        name = "OffsetX",
        label = "X Offset (Horizontal)",
        hover = "Negative values - move left, positive values - move right.",
        options = offsets,
        default = 0
    },
    {
        name = "OffsetXMult",
        label = "X Offset Multiplier",
        hover = "Multiplier for the \"X Offset\" setting.\nHas no effect on the \"Fine Tune\" setting.",
        options = offsetMultipliers,
        default = 1
    },
    {
        name = "OffsetXFine",
        label = "X Offset Fine Tune",
        hover = "Fine tune X Offset",
        options = fineOffsets,
        default = 0
    },
    {
        name = "SEPARATOR_POSITIONING_Y",
        label = "Positioning Y",
        options = {{description = "", data = 1}},
        default = 1
    },
    {
        name = "OffsetY",
        label = "Y Offset (Vertical)",
        hover = "Negative values - move down, positive values - move up.",
        options = offsets,
        default = 0
    },
    {
        name = "OffsetYMult",
        label = "Y Offset Multiplier",
        hover = "Multiplier for the \"Y Offset\" setting.\nHas no effect on the \"Fine Tune\" setting.",
        options = offsetMultipliers,
        default = 1
    },
    {
        name = "OffsetYFine",
        label = "Y Offset Fine Tune",
        hover = "Fine tune Y Offset",
        options = fineOffsets,
        default = 0
    }
}