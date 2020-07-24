local playerObject = FindMetaTable("Player");

// VGUI-Based Net Messages
util.AddNetworkString("VEXP Menu");
util.AddNetworkString("VEXP CSPerks");
util.AddNetworkString("VEXP BuySkill");
util.AddNetworkString("VEXP Reset");
util.AddNetworkString("VEXP ResetSP");

// Chat Messages
util.AddNetworkString("VEXP Award");
util.AddNetworkString("VEXP Proven");
util.AddNetworkString("VEXP LevelUp");
util.AddNetworkString("VEXP Learn");
util.AddNetworkString("VEXP B LevelUp");
util.AddNetworkString("VEXP Ad");
util.AddNetworkString("VEXP AlertOnJoin");
util.AddNetworkString("VEXP LastRev");
util.AddNetworkString("VEXP Victory");
util.AddNetworkString("VEXP WarmWelcome");
util.AddNetworkString("VEXP TotalXPGainedForRound");
util.AddNetworkString("VEXP EndRoundXPRewards");
util.AddNetworkString("VEXP SLevel");



function FindPlayer( str )
	if !str then return end

	for k, v in pairs(player.GetAll()) do
		if string.find(string.lower(v:Name()), string.lower(str)) != nil then
			return v
		end
	end
	
	for k, v in pairs(player.GetAll()) do
		if string.find(string.lower(v:SteamID()), string.lower(str)) != nil then
			return v
		end
	end
	
	return nil
end

function VEXP:isPlySpecial(ply)
	local isSpecial = false

	for k,v in pairs(VEXP.specialGroups) do
		if ply:IsUserGroup(v) or ply:GetNWBool("Supporter") == true then
			isSpecial = true
		end
	end

	return isSpecial
end

function playerObject:VEXP_HasSkill( str )
	local cskills = util.JSONToTable(self:GetNWString("skills","{}"))

	if table.HasValue(cskills,str) then
		return true
	end

	return false

	-- for k,v in pairs(VEXP.Skills) do
	-- 	if str == v[1] then
	-- 		if table.HasValue(cskills,k) then
	-- 			return true
	-- 		else
	-- 			return false
	-- 		end
	-- 	end
	-- end
end

function playerObject:VEXP_LevelUp()
	local nick = self:Nick()
	local level = self:GetNWInt("level")
	local xp = self:GetNWInt("xp")
	local nextlevel = self:GetNWInt("nextlevel")

	if level >= VEXP.levelCap then
		if self:GetNWInt("slevel") >= VEXP.spiritCap then return end

		self:SetNWInt("slevel",self:GetNWInt("slevel")+1)
		self:SetNWInt("level",0)
		self:SetNWInt("xp",0)
		self:SetNWInt("nextlevel",100)
		self:VEXP_SendData()

		net.Start("VEXP SLevel")
			net.WriteString(nick,128)
		net.Broadcast()

		return
	end

	if xp >= nextlevel then
		self:SetNWInt("xp", 0)
		self:SetNWInt("level", self:GetNWInt("level") + 1)
		self:SetNWInt("nextlevel", ((self:GetNWInt("level"))*1000))
		self:SetNWInt("skillpoints", self:GetNWInt("skillpoints")+1)
		self:VEXP_SendData()

		if self:GetNWInt("level") >= VEXP.levelCap then
			net.Start("VEXP Victory")
				net.WriteString(self:Nick(),64)
			net.Broadcast()
		else
			net.Start("VEXP LevelUp")
			net.Send(self)

			net.Start("VEXP B LevelUp")
				net.WriteString(nick,128)
				net.WriteInt(level,16)
			net.Broadcast()
		end
	end
end

function playerObject:VEXP_Award( pts )
	if self:VEXP_HasSkill("Born from Hell") then
		pts = pts * 4
	elseif self:VEXP_HasSkill("Born to Die") then
		pts = pts * 2
	elseif self:VEXP_HasSkill("Born to Dominate") then
		pts = pts * 1.5
	elseif self:VEXP_HasSkill("Born to Ravage") then
		pts = pts * 1.2
	elseif self:VEXP_HasSkill("Born to Kill") then
		pts = pts * 1.1
	end

	if VEXP.isPlySpecial(self) or self:GetNWBool("Supporter") == true then
		pts = pts * VEXP.specialBoostRate
	end

	self:SetNWInt("xp", self:GetNWInt("xp") + pts)

	if self:GetNWInt("xp") > self:GetNWInt("nextlevel") then
		self:SetNWInt("xp",self:GetNWInt("nextlevel")) -- level it off to prevent visual artifacts
	end

	self:VEXP_SendData()
	self:VEXP_LevelUp() -- abuse this function, since it checks if a player can level up anyway. :3

	self:SetNWInt("roundxp",self:GetNWInt("roundxp",0) + pts)

	net.Start("VEXP Award")
		net.WriteInt(pts,32)
	net.Send(self)
end

// Hooks
hook.Add("PlayerDeath", "VEXP rewardKills", function(vic, mtd, atk)
	// if gamemode.Get() == "terrortown" then
		-- Turns out that adding the 'return end' if statement
		-- was causing bugs like people being able to talk even
		-- though they were dead. That is the problem when using
		-- returns in a hook like this.
		if atk:IsTraitor() then
			if vic:IsDetective() then
				atk:VEXP_Award(200)
			else
				atk:VEXP_Award(100)
			end
		else
			if vic:IsTraitor() then
				atk:VEXP_Award(500)

				net.Start("VEXP Proven")
					net.WriteString(atk:Nick(),64)
				net.Broadcast()
			end
		end
	// else -- Easier to play test with.
	// 	atk:VEXP_Award(100)
	// end
end)

local function updateActiveFromSavedData(ply)
	timer.Simple(3, function()
		local return_data = ply:VEXP_GetData()

		ply:SetNWInt("slevel", return_data.slevel)
		ply:SetNWInt("level", return_data.level)
		ply:SetNWInt("xp", return_data.xp)
		ply:SetNWInt("nextlevel", return_data.nextlevel)
		ply:SetNWInt("skillpoints", return_data.skillpoints)
		ply:SetNWString("skills", return_data.skills) -- Skills is a table inside a table. (IN JSON state) <-- wow i'm cool
	end)
end

local function timerXPOverTime(ply)
	local otamt = 20

	if ply:VEXP_HasSkill("Born from Hell") then
		otamt = otamt * 4
	elseif ply:VEXP_HasSkill("Born to Die") then
		otamt = otamt * 2
	elseif ply:VEXP_HasSkill("Born to Dominate") then
		otamt = otamt * 1.5
	elseif ply:VEXP_HasSkill("Born to Ravage") then
		otamt = otamt * 1.2
	elseif ply:VEXP_HasSkill("Born to Kill") then
		otamt = otamt * 1.1
	end

	if VEXP.isPlySpecial(ply) or ply:GetNWBool("Supporter") == true then
		otamt = otamt * VEXP.specialBoostRate
	end

	ply:SetNWInt("xp", ply:GetNWInt("xp")+otamt)

	ply:VEXP_SendData()

	// XP Over Time Message
	net.Start("VEXP Learn")
		net.WriteInt(otamt,16)
	net.Send(ply)

	if ply:GetNWInt("xp") > ply:GetNWInt("nextlevel") then
		ply:SetNWInt("xp",ply:GetNWInt("nextlevel"))
	end

	ply:VEXP_LevelUp() -- Call this to check if player is applicable
end

local function VEXP:PlayerInitialSpawn(ply)
	// VIP-Exclusive Welcome Message
	timer.Simple(6,
	function()
		if ply:GetNWBool("Supporter") == true then
			net.Start("VEXP WarmWelcome")
			net.Send(ply)
		end
	end)

	// VEXP Revision Information
	timer.Simple(2,
	function()
		net.Start("VEXP AlertOnJoin");
		net.Send(ply);
	end)

	updateActiveFromSavedData(ply);

	// XP Over Time
	timer.Create("XPOverTimeFor" .. ply:UniqueID() .. "",60,0,timerXPOverTime);
end

hook.Add("PlayerInitialSpawn", "VEXP PIS Hook", VEXP:PlayerInitialSpawn);

hook.Add("PlayerSay", "VEXP chatCommands", function(ply, msg)
	if msg == "!vexp" or msg == "/vexp" or msg == "!v" or msg == "/v" then
		print("The player command was successful...");
		net.Start("VEXP Menu");
		net.Send(ply);
		return "";
	end
end)

hook.Add("PlayerDisconnected", "VEXP removeUserAssosTimers", function(ply)
	timer.Destroy("XPOverTimeFor" .. ply:UniqueID() .. "")
end)

hook.Add("TTTEndRound", "VEXP TotalXPGained", function()
	for k,v in pairs(player.GetAll()) do
		local amt = v:GetNWInt("roundxp")

		net.Start("VEXP TotalXPGainedForRound")
			net.WriteInt(amt,16)
		net.Send(v)

		v:SetNWInt("roundxp",0)
	end
end)

hook.Add("WeaponEquip", "VEXP Weapon Hooks", function(weapon)
	timer.Simple(0.5, function()
		if IsValid(weapon) then -- Because of the way this hook is handled, this has to be done in the most backwards fucking way possible. <-- ????
			local ply = weapon:GetOwner()

			if ply:VEXP_HasSkill("Master Anatomical Understanding") then
				if !weapon.StatsChangedDam then -- This is stupidly backward.
					weapon.Primary.PrevDam = weapon.Primary.Damage
				end
				weapon.Primary.Damage = weapon.Primary.PrevDam * 1.5
				weapon.StatsChangedDam = true
			elseif ply:VEXP_HasSkill("Advanced Anatomical Understanding") then
				if !weapon.StatsChangedDam then -- This is stupidly backward.
					weapon.Primary.PrevDam = weapon.Primary.Damage
				end
				weapon.Primary.Damage = weapon.Primary.PrevDam * 1.25
				weapon.StatsChangedDam = true
			elseif ply:VEXP_HasSkill("Intermediate Anatomical Understanding") then
				if !weapon.StatsChangedDam then -- This is stupidly backward.
					weapon.Primary.PrevDam = weapon.Primary.Damage
				end
				weapon.Primary.Damage = weapon.Primary.PrevDam * 1.10
				weapon.StatsChangedDam = true
			elseif ply:VEXP_HasSkill("Starter Anatomical Understanding") then
				if !weapon.StatsChangedDam then -- This is stupidly backward.
					weapon.Primary.PrevDam = weapon.Primary.Damage
				end
				weapon.Primary.Damage = weapon.Primary.PrevDam * 1.05
				weapon.StatsChangedDam = true
			end
			
			if ply:VEXP_HasSkill("Master Ergonomical Handling") then
				if !weapon.StatsChangedRec then -- This is stupidly backward.
					weapon.Primary.PrevRec = weapon.Primary.Recoil
				end
				weapon.Primary.Recoil = weapon.Primary.PrevRec - weapon.Primary.PrevRec
				weapon.StatsChangedRec = true
			elseif ply:VEXP_HasSkill("Advanced Ergonomical Handling") then
				if !weapon.StatsChangedRec then -- This is stupidly backward.
					weapon.Primary.PrevRec = weapon.Primary.Recoil
				end
				weapon.Primary.Recoil = weapon.Primary.PrevRec * 0.5
				weapon.StatsChangedRec = true
			elseif ply:VEXP_HasSkill("Intermediate Ergonomical Handling") then
				if !weapon.StatsChangedRec then -- This is stupidly backward.
					weapon.Primary.PrevRec = weapon.Primary.Recoil
				end
				weapon.Primary.Recoil = weapon.Primary.PrevRec * 0.75
				weapon.StatsChangedRec = true
			elseif ply:VEXP_HasSkill("Starter Ergonomical Handling") then
				if !weapon.StatsChangedRec then -- This is stupidly backward.
					weapon.Primary.PrevRec = weapon.Primary.Recoil
				end
				weapon.Primary.Recoil = weapon.Primary.PrevRec * 0.95
				weapon.StatsChangedRec = true
			end

			if ply:VEXP_HasSkill("Master Stability Training") then
				if !weapon.StatsChangedCone then -- This is stupidly backward.
					weapon.Primary.PrevCone = weapon.Primary.Cone
				end
				weapon.Primary.Cone = weapon.Primary.PrevCone - weapon.Primary.PrevCone
				weapon.StatsChangedCone = true
			elseif ply:VEXP_HasSkill("Advanced Stability Training") then
				if !weapon.StatsChangedCone then -- This is stupidly backward.
					weapon.Primary.PrevCone = weapon.Primary.Cone
				end
				weapon.Primary.Cone = weapon.Primary.PrevCone * 0.5
				weapon.StatsChangedCone = true
			elseif ply:VEXP_HasSkill("Intermediate Stability Training") then
				if !weapon.StatsChangedCone then -- This is stupidly backward.
					weapon.Primary.PrevCone = weapon.Primary.Cone
				end
				weapon.Primary.Cone = weapon.Primary.PrevCone * 0.75
				weapon.StatsChangedCone = true
			elseif ply:VEXP_HasSkill("Starter Stability Training") then
				if !weapon.StatsChangedCone then -- Did I say this was stupidly backward, yet?
					weapon.Primary.PrevCone = weapon.Primary.Cone
				end
				weapon.Primary.Cone = weapon.Primary.PrevCone * 0.95
				weapon.StatsChangedCone = true
			end
		end
	end)
end)

hook.Add("ScalePlayerDamage", "VEXP Damage Hooks", function( ply, hit, dmg )
	if GetRoundState() != ROUND_ACTIVE then return end
	
	if IsValid(dmg:GetAttacker()) and dmg:GetAttacker():IsPlayer() then
		local pl = dmg:GetAttacker()
		local hp = dmg:GetDamage()

		if not (ply:Armor() > 0) then
			if ply:VEXP_HasSkill("Master Medical Attainment") then
				if pl:VEXP_HasSkill("World League Play") then
					if pl:GetActiveWeapon():GetModel() != nil and pl:GetActiveWeapon():GetModel() == "models/weapons/w_crowbar.mdl" then
						hp = dmg:GetDamage()
					else
						hp = hp * 0.7
					end
				else
					hp = hp * 0.7
				end
			elseif ply:VEXP_HasSkill("Advanced Medical Attainment") then
				if pl:VEXP_HasSkill("World League Play") then
					if pl:GetActiveWeapon():GetModel() != nil and pl:GetActiveWeapon():GetModel() == "models/weapons/w_crowbar.mdl" then
						hp = dmg:GetDamage()
					else
						hp = hp * 0.8
					end
				else
					hp = hp * 0.8
				end
			elseif ply:VEXP_HasSkill("Intermediate Medical Attainment") then
				if pl:VEXP_HasSkill("World League Play") then
					if pl:GetActiveWeapon():GetModel() != nil and pl:GetActiveWeapon():GetModel() == "models/weapons/w_crowbar.mdl" then
						hp = dmg:GetDamage()
					else
						hp = hp * 0.9
					end
				else
					hp = hp * 0.9
				end
			elseif ply:VEXP_HasSkill("Starter Medical Attainment") then
				if pl:VEXP_HasSkill("World League Play") then
					if pl:GetActiveWeapon():GetModel() != nil and pl:GetActiveWeapon():GetModel() == "models/weapons/w_crowbar.mdl" then
						hp = dmg:GetDamage()
					else
						hp = hp * 0.95
					end
				else
					hp = hp * 0.95
				end
			end
		end

		if pl:VEXP_HasSkill("League Play") then
			if pl:GetActiveWeapon():GetModel() != nil and pl:GetActiveWeapon():GetModel() == "models/weapons/w_crowbar.mdl" then
				hp = dmg:GetDamage() * 1.5

				if ply:Armor() > 0 then
					hp = hp * 2
				end
			end
		end

		dmg:SetDamage(hp)
	end
end)

hook.Add("EntityTakeDamage", "VEXP DamageBasedHook", function( target, dmginfo )
	if (target:IsPlayer() and dmginfo:IsExplosionDamage()) or (target:IsPlayer() and dmginfo:IsDamageType(8)) or (target:IsPlayer() and dmginfo:IsDamageType(16384)) or (target:IsPlayer() and dmginfo:IsDamageType(1)) or (target:IsPlayer() and dmginfo:IsDamageType(2097152)) then
		if target:VEXP_HasSkill("Thick Skinned") then
			dmginfo:ScaleDamage(0.75)
			target:EmitSound("vexp_sfx/explodeprotect.mp3",40)
		end

		if target:VEXP_HasSkill("Dermal Shock Gel") then
			dmginfo:ScaleDamage(0.5)
			target:EmitSound("vexp_sfx/explodeprotect.mp3",40)
		end

		if target:VEXP_HasSkill("Atom Repulsive Field") then
			dmginfo:ScaleDamage(0.01)
			target:EmitSound("vexp_sfx/explodeprotect.mp3",40)
		end
	end

	if (target:IsPlayer() and dmginfo:IsFallDamage()) then
		if target:VEXP_HasSkill("Shock Boots") then
			if dmginfo:GetDamage() >= target:Health() then
				dmginfo:ScaleDamage(0.1)
			else
				dmginfo:ScaleDamage(0)
			end
			target:EmitSound("vexp_sfx/fallprotect.mp3")
		end
	end
end)

local function endRoundXPRewards(wintype)
	if (wintype == WIN_INNOCENT) or (wintype == WIN_TIMELIMIT) then

		for k,v in pairs(player.GetAll()) do
			if not v:IsTraitor() then
				local roundreward = 1000

				if v:VEXP_HasSkill("Born from Hell") then
					roundreward = roundreward * 4
				elseif v:VEXP_HasSkill("Born to Die") then
					roundreward = roundreward * 2
				elseif v:VEXP_HasSkill("Born to Dominate") then
					roundreward = roundreward * 1.5
				elseif v:VEXP_HasSkill("Born to Ravage") then
					roundreward = roundreward * 1.2
				elseif v:VEXP_HasSkill("Born to Kill") then
					roundreward = roundreward * 1.1
				end

				if VEXP.isPlySpecial(v) or v:GetNWBool("Supporter") == true then
					roundreward = roundreward * VEXP.specialBoostRate
				end

				v:SetNWInt("xp",v:GetNWInt("xp")+roundreward)
				v:VEXP_LevelUp()

				net.Start("VEXP EndRoundXPRewards")
				net.Send(v)
			end
		end

	elseif wintype == WIN_TRAITOR then

		for k,v in pairs(player.GetAll()) do
			if v:IsTraitor() then
				local roundreward = 1000

				if v:VEXP_HasSkill("Born from Hell") then
					roundreward = roundreward * 4
				elseif v:VEXP_HasSkill("Born to Die") then
					roundreward = roundreward * 2
				elseif v:VEXP_HasSkill("Born to Dominate") then
					roundreward = roundreward * 1.5
				elseif v:VEXP_HasSkill("Born to Ravage") then
					roundreward = roundreward * 1.2
				elseif v:VEXP_HasSkill("Born to Kill") then
					roundreward = roundreward * 1.1
				end

				if VEXP.isPlySpecial(v) or v:GetNWBool("Supporter") == true then
					roundreward = roundreward * VEXP.specialBoostRate
				end

				v:SetNWInt("xp",v:GetNWInt("xp")+roundreward)
				v:VEXP_LevelUp()

				net.Start("VEXP EndRoundXPRewards")
				net.Send(v)
			end
		end

	end
end

hook.Add("TTTEndRound", "VEXP EndRoundRewards", endRoundXPRewards);

// Timers
timer.Create("VEXP Advertisement",75,0,function()
	net.Start("VEXP Ad")
	net.Broadcast()
end)

timer.Create("VEXP LatRev",300,0,function()
	net.Start("VEXP LastRev")
	net.Broadcast()
end)

function VEXP.GiveXP(caller, cmd, args, fullcmd)
	if (!args[1] or !args[2]) then return end

	local target = FindPlayer(args[1])
	local amount = tonumber(args[2])

	target:SetNWInt("xp", (target:GetNWInt("xp")+amount))

	if (target:GetNWInt("xp") > target:GetNWInt("nextlevel")) then
		target:SetNWInt("xp", target:GetNWInt("nextlevel"))
	end

	target:VEXP_SendData()
	target:VEXP_LevelUp()
end

concommand.Add("vexp_givexp", VEXP.GiveXP)

function VEXP.SetLevel(caller, cmd, args, fullcmd)
	if (!args[1] or !args[2]) return

	local target = FindPlayer(args[1])
	local amount = tonumber(args[2])

	target:SetNWInt("level", amount)
	target:VEXP_SendData()
end

concommand.Add("vexp_setlevel", VEXP.SetLevel)

// Received CS Net Messages

net.Receive("VEXP BuySkill", function(len, ply)
	local return_data = ply:VEXP_GetData()
	local csSkills = util.JSONToTable(return_data.skills)
	local skilltobuy = net.ReadFloat()

	if table.HasValue(csSkills,skilltobuy) then return end -- Don't charge for lag.

	ply:SetNWInt("skillpoints",ply:GetNWInt("skillpoints") - 1)
	table.insert(csSkills,skilltobuy)

	local recompile = util.TableToJSON(csSkills)
	ply:SetNWString("skills",recompile)

	ply:VEXP_SendData();
end)

net.Receive("VEXP Reset", function(len, ply)
	local filename = string.Replace(ply:SteamID(),":","_")
	print("[VEXP Reset] " .. ply:Nick() .. " has reset their data. OLD: Level: " .. ply:GetNWInt("level") .. " XP: " .. ply:GetNWInt("xp") .. "/" .. ply:GetNWInt("nextlevel") .. " SP: " .. ply:GetNWInt("skillpoints") .. " Skills: " .. ply:GetNWString("skills"))
	
	file.Delete('vexp/players/' .. filename .. '.txt')

	ply:SetNWInt("slevel",0)
	ply:SetNWInt("level",0)
	ply:SetNWInt("xp",0)
	ply:SetNWInt("nextlevel",100)
	ply:SetNWInt("skillpoints",0)
	ply:SetNWString("skills","{}")
end)

net.Receive("VEXP ResetSP", function(len, ply)
	ply:SetNWInt("skillpoints",ply:GetNWInt("level"))
	ply:SetNWString("skills","{}")

	ply:VEXP_SendData()
end)