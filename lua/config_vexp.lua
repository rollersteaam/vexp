VEXP = {};
VEXP.ver = "1.3-stable";
print("(VEXP-CFG) Created lib 'VEXP'.")

/*
==========================:CONFIG:==========================
*/

// Apparently changing things in the config while it is still running stops VEXP from working. So be careful.

VEXP.enabled = true --: Disables the addon completely. (default : true)
VEXP.openMenuKey = KEY_F6 --: The key to open the VEXP control panel. Uses ENUMs. (default : KEY_F6)

// VIPs automatically receive specialBoostRate.
VEXP.specialGroups = {} --: If a person is a certain rank (e.g. VIP), they will gain 2x the XP for any action. RankIDs only. (default : "vip")
VEXP.specialBoostRate = 2 --: Configure the boost in XP that 'VEXP.specialGroups' get. This number is multiplied against the usual XP gained. (e.g. 2 = 2x XP, 3 = 3x XP etc.) (default : 2)

VEXP.levelCap = 100 --: Once you reach this level, you can not level up any more. (default : 100)
VEXP.spiritCap = 5 --: A player can reset all their data, to gain 1 spirit level. They can not gain any more spirit levels after this number. Player must be level 100 before they can gain a spirit level. (default : 5)

VEXP.canSAdminModify = true --: Allows Super Admins (and above) to change data such as level, xp, or xp needed to level. Does not include admins or moderators. (default : true)
VEXP.sAdminModifyExceptions = { --: The people who can change data regardless of 'VEXP.canSAdminModify'. SteamIDs only. Make sure to use a comma after inserting a SteamID.
	"STEAM_0:0:30517277", -- Rollersteaam
	"STEAM_0:1:25655723", -- Inkie
	"STEAM_0:1:21443060" -- Bluemist
}