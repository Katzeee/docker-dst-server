name = '掉落堆叠(Drop & Stack)'
author = '凉时白开(Xt)'
version = '2.0.11'
description = (locale == 'zh' or locale == 'zhr') and '版本: ' .. version .. '\n' .. [[
新模式: 真正的全堆叠.
旧模式兼容项:
标准掉落(砍树,挖矿,鸟笼,杀怪,等等);
交易(猪王,鱼王,蚁狮,神话聚宝盆);
猪人便便;
石果开采;
熊大毛丛;邪天翁羽毛;格罗姆黏液;
灰烬;
风滚草采集;包裹拆解;
地皮挖掘;
食物腐烂;
刮剃(牛毛人须).
]] or 'Version: ' .. version .. '\n' .. [[
New Mode: The Really All Stacking.
The list of supported drops by Old Mode:
Standard drops(Chop, Mine, Birdcage, Kill, etc.);
Trade(Pig King, King of the Merms, Antlion, Treasure Bowl from Myth Words);
Pig Man's Manure;
Mining of Stone Fruit;
Bearger's Fur Tuft; Malbatross Feather; Glommer's Goop;
Ashes;
Picking of Tumbleweed; Unwrapping of Bundle;
Digging of Turf;
Rotting Food;
Shaving(Beefalo Wool, Beard Hair, etc.).
]]
forumthread = ''
api_version = 10
dst_compatible = true
server_only_mod = true
priority = -23333 --[[ 调低优先级以便兼容其他 Mod 对原版内容的改动, 你为什么要覆盖式改动? ]]
icon_atlas = 'modicon.xml'
icon = 'modicon.tex'
configuration_options = {
    {
        name = 'StackRadius',
        label = '堆叠半径 Stack Radius',
        options = {
            {
                description = '5',
                data = 5,
            },
            {
                description = '10',
                data = 10,
            },
            {
                description = '15',
                data = 15,
            },
            {
                description = '20',
                data = 20,
            },
            {
                description = '25',
                data = 25,
            },
            {
                description = '30',
                data = 30,
            },
            {
                description = '35',
                data = 35,
            },
            {
                description = '40',
                data = 40,
            },
            {
                description = '45',
                data = 45,
            },
            {
                description = '50',
                data = 50,
            },
        },
        default = 10,
    },
    {
        name = 'StackMode',
        label = '堆叠模式 Stack Mode',
        options = {
            {
                description = '新模式 New Mode',
                data = true,
            },
            {
                description = '旧模式 Old Mode',
                data = false,
            },
        },
        default = true,
    },
}
