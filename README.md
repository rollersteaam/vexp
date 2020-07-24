# ValkyrieGaming's Valkyrie Experience System (VEXP)
A levelling system for Garry's Mod gamemode Trouble in Terrorist Town (TTT), created when I was 14 years old, for a community called ValkyrieGaming.

## How does it work?
VEXP gives experience (XP) to players for playing on the server overtime. I think if I remember correctly, you get some flat XP every minute. You also earn XP for killing other players, and earn bonus XP depending on what role you are when you kill certain players. Killing a traitor as an innocent for instance will net you a significant amount of XP compared to killing an innocent as a traitor. I can't remember if I ever made discovering bodies give you bonus XP as a detective. Who knows.

Players level up when they reach a certain amount of XP. Every level up grants them 1 skill point, that they can use on perks in the VEXP menu (accessed using /vexp). These perks are locked until you reach a certain level.

## What perks can a player buy?
The provisioned perks I imagined when I was 14 years old were wildly unbalanced, and I would not bother adding an experience system in a PVP game today. However, that doesn't change the fact that I _did_ do that, and therefore I still need to talk about the perks. Also, I apologise in advance for the angry comments in the code about the way Garry's Mod Lua works.

### Damage
There are 4 "Anatomical Understanding" perks which increase in the amount of effect that they have. Every perk increases damage per bullet by about 12.5%, although I could be wrong. For obvious reasons, being able to deal 50% more damage per bullet than other players when you are max level is incredibly unbalanced. But anyway.

### Accuracy
There are 4 "Stability Training" perks which reduce the spread of your bullets per shot. At max level, spread is removed.

### Recoil
There are 4 "Ergonomical Handling" perks which reduce recoil. At max level, recoil is removed.

### Damage Resistance
There are 4 "Medical Attainment" perks which reduce the amount of damage you receive against all sources of damage. At max level, this is reduced by 30%, which is surprisingly balanced for 14 year old me...

### Experience Boosting
There are 4 "Born to X" (where X is some verb) perks which increase the amount of XP you gain by a multiplier. At max level, this is 4x.

### Non-Player Damage Resistance
There are 3 creatively named perks which reduce damage from any damage source that is not a player. At max level, you receive no damage from non-player damage sources. This includes things like bombs. Very balanced, I know.

### Melee Damage
There are 2 perks that boost melee damage. "League Play" allows players to deal 50% more damage with the crowbar, and your hits will ignore the armor of a player. "World League Play" allows players to ignore **damage resistance** perks.

### Fall Damage Resistance
There is only 1 perk that reduces fall damage. "Shock Boots" allows you to receive no damage when falling, however it will not nullify damage if the fall would normally kill you. Thank God.

### Any other planned perks?
Apparently in the code and documentation, I planned on making traitor and detective perks. However, this would take more effort than basic 'stat boosts' like I did above, and therefore I didn't do them.
