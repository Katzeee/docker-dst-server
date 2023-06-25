--There are two functions that will install mods, ServerModSetup and ServerModCollectionSetup. Put the calls to the functions in this file and they will be executed on boot.

--ServerModSetup takes a string of a specific mod's Workshop id. It will download and install the mod to your mod directory on boot.
	--The Workshop id can be found at the end of the url to the mod's Workshop page.
	--Example: http://steamcommunity.com/sharedfiles/filedetails/?id=350811795
	--ServerModSetup("350811795")

--ServerModCollectionSetup takes a string of a specific mod's Workshop id. It will download all the mods in the collection and install them to the mod directory on boot.
	--The Workshop id can be found at the end of the url to the collection's Workshop page.
	--Example: http://steamcommunity.com/sharedfiles/filedetails/?id=379114180
	--ServerModCollectionSetup("379114180")

ServerModSetup("347079953") --Display Food Values
ServerModSetup("362175979") --Wormhole Marks [DST]
ServerModSetup("375850593") --Extra Equip Slots
ServerModSetup("375859599") --Health Info
ServerModSetup("378160973") --Global Positions
ServerModSetup("569043634") --Campfire Respawn
ServerModSetup("623749604") --[DST] Storeroom
ServerModSetup("661253977") --Don't Drop Everything
ServerModSetup("666155465") --SHow me
ServerModSetup("812723897") --Extended Map Icons
ServerModSetup("856487758") --Quick Drop
ServerModSetup("1185229307") --史诗般的血量条 (Epic Healthbar)
ServerModSetup("1207269058") --简易血条DST
ServerModSetup("1221281706") --The Forge Items Pack
ServerModSetup("2078243581") --Display Attack Range
ServerModSetup("2477889104") --Beefalo Status Bar

