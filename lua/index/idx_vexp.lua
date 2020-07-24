VEXP.Skills = {};

function VEXP.indexSk( idx, name, lvl, desc, preReqSk )
	if idx == nil then
		idx = 0
	end

	if name == nil then
		name = "Error Code (0): Bad index."
	end

	if lvl == nil then
		lvl = 0
	end

	if desc == nil then
		desc = "Error Code (0): Bad index. Bad message."
	end

	VEXP.Skills[idx] = { name, lvl, desc, preReqSk }
end

// Add some more skills. Current list is a-okay atm.

-- Combat Skills
VEXP.indexSk(1, "Starter Anatomical Understanding", 5, "With basic education of the human body, you\ndeal a 5% additional damage per bullet.")
VEXP.indexSk(2, "Starter Ergonomical Handling", 5, "With just a bit of shooting at the range, you\nexperience 5% less recoil per bullet.")
VEXP.indexSk(3, "Starter Medical Attainment", 5, "Seeing some of your friends die and survive a\nwar, you experience 5% less damage against\nyou.")
VEXP.indexSk(4, "Starter Stability Training", 5, "Just hold your gun straight. There. Your bullet\nspread is now reduced by 5%. Easy.")

VEXP.indexSk(5, "Intermediate Anatomical Understanding", 25, "Aim for the muscles to cause tissue damage\nrather than bone damage. You deal 10%\nadditional damage per bullet.",1)
VEXP.indexSk(6, "Intermediate Ergonomical Handling", 25, "Learning to handle a variety of fire-rates, you\nexperience 25% less recoil per bullet.",2)
VEXP.indexSk(7, "Intermediate Medical Attainment", 25, "You start to adjust to general tissue damage.\nYou experience 10% less damage against you.",3)
VEXP.indexSk(8, "Intermediate Stability Training", 25, "You start to lower motion in your movement\nwhen faced with danger, reducing bullet spread\nby 25%",4)

VEXP.indexSk(9, "Advanced Anatomical Understanding", 50, "Aim for certain tendons in the muscle for critical\ndamage. You deal 25% additional damage\nper bullet.", 5)
VEXP.indexSk(10, "Advanced Ergonomical Handling", 50, "You primarily focus on handling SMG fire-rates,\nexperiencing 50% less recoil per bullet.", 6)
VEXP.indexSk(11, "Advanced Medical Attainment", 50, "Your body 'hard-locks' in response to physical\ntrauma, experiencing 20% less damage\nagainst you.", 7)
VEXP.indexSk(12, "Advanced Stability Training", 50, "From your advanced medical attainment, you\ncan hard-lock your muscle motion, reducing\nbullet spread by 50%", 11)

VEXP.indexSk(13, "Master Anatomical Understanding", 100, "Aiming for individual arties and veins are more\neffective. You deal 50% additional damage per\nbullet.", 9)
VEXP.indexSk(14, "Master Ergonomical Handling", 100, "You challenged someone else to handling a Para,\nand you won. You experience heavily reduced recoil.", 10)
VEXP.indexSk(15, "Master Medical Attainment", 100, "Your body is equipt with sub-dermal nano-\nmachines activated by physical trauma. You\nexperience 30% less damage against you.", 11)
VEXP.indexSk(16, "Master Stability Training", 100, "Your body's sub-dermal nanomachines hard-lock\nmuscle motion when desired, reducing bullet\nspread by 95%.", 15)

-- General Skills
VEXP.indexSk(17, "Born to Kill", 1, "You were born to kill. Any XP you gain is\nboosted by 10% amount.")
VEXP.indexSk(18, "Born to Ravage", 10, "You were born to dominate your enemies. Any\nXP you gain is boosted by 20%", 17)
VEXP.indexSk(19, "Born to Dominate", 20, "You were born to decimate their lines. Any XP\nyou gain is boosted by 50%", 18)
VEXP.indexSk(20, "Born to Die", 40, "Not so resiliant to death, your spirit does not let\nup. Any XP you gain is boosted by 100%.", 19)
VEXP.indexSk(21, "Born from Hell", 60, "Your spirit learns at a faster rate. Any XP you\ngain is effectively quadrupled.", 20)

-- New General Skills
VEXP.indexSk(22, "Thick Skinned", 15, "Any damage source that is not by a player is\nreduced by 25%, except from falling.")
VEXP.indexSk(23, "Dermal Shock Gel", 35, "Any damage source that is not by a player is\nreduced by 50%, except from falling.", 22)
VEXP.indexSk(24, "Atom Repulsive Field", 65, "You do not receive damage from non-player\nentities, except from falling.", 23)

VEXP.indexSk(25, "League Play", 15, "You now deal 50% more damage with the\ncrowbar. In addition, your hits pierce armor.")
VEXP.indexSk(26, "World League Play", 30, "Your hits are unaffected by damage resistance.", 25)

VEXP.indexSk(27, "Shock Boots", 80, "You receive no damage from falling. Will not\ncompletely nullify if fall would normally kill.",24)

-- Detective Skills
-- Traitor Skills