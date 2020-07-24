// lib
VEXP.sounds = {};
VEXP.canSoundPlay = true; -- prevent interruptions in sound plays
--

// Pre-cached sound lib
VEXP.sounds.overtime = Sound( 'vexp_sfx/overtime.mp3' )
VEXP.sounds.fallprotect = Sound( 'vexp_sfx/fallprotect.mp3' )
VEXP.sounds.explodeprotect = Sound( 'vexp_sfx/explodeprotect.mp3' )
VEXP.sounds.levelup = Sound( 'vexp_sfx/vexp_levelup.mp3' )
VEXP.sounds.openmenu = Sound( 'UI/buttonclick.wav' )
--

net.Receive("VEXP WarmWelcome", function(length)
	chat.AddText(Color(100,200,100),"[VEXP] ",Color(200,200,200),
		"Welcome back, ",Color(100,200,100),
		"" .. LocalPlayer():Nick() .. "",Color(200,200,200),
		"! Your ",Color(200,100,100),
		"" .. VEXP.specialBoostRate .. "x XP gain",Color(200,200,200),
		" has been activated because of your ",
		Color(100,200,100),
		"Supporter",
		Color(200,200,200),
		" status! Enjoy! ",
		Color(135,135,135),
		"Remember: Use ",
		Color(80,135,80),
		"/vexp",
		Color(135,135,135),
		" to manage your VEXP account."
	)
end)

net.Receive("VEXP SLevel", function(length)
	local nick = net.ReadString(128)

	chat.AddText(Color(0,200,255),"[VEXP] ",Color(200,200,200),
		"Player ", Color(0,200,255), nick, Color(200,200,200),
		" has reached a ",Color(0,200,255), "higher level of understanding", Color(200,200,200),
		" and gained a ",Color(0,200,255),"spirit level.")
end)

net.Receive("VEXP Victory", function(length)
	chat.AddText(Color(100,200,100),"[VEXP] ",Color(200,200,200),
		"Player ", Color(200,100,100),
		net.ReadString(64), Color(200,200,200),
		" has just reached level ", Color(200,100,100),
		"100", Color(200,200,200),
		"."
	) -- Do not add an anti-sound interrupt. This is a one of a kind thing.
	LocalPlayer():EmitSound("maxlevelhit.mp3") -- Much better subtitute.
	VEXP.canSoundPlay = false;

	timer.Simple(90, function() VEXP.canSoundPlay = true end) -- re-enable sound play
end)

net.Receive("VEXP Ad", function(length)
	chat.AddText(Color(64,179,64),"[VEXP Ad] ",Color(135,135,135),
		"Remember:",
		Color(200,200,200),
		" You can access the ",
		Color(64,179,64),
		"VEXP Control Panel",
		Color(200,200,200),
		" with ",
		Color(64,179,64),
		"/vexp",
		Color(200,200,200),
		" or ",
		Color(64,179,64),
		"F6",
		Color(200,200,200),
		"."
	)
end)

net.Receive("VEXP LastRev", function(length)
	chat.AddText(Color(64,64,179),"[VEXP Update News] ",Color(200,200,200),
		"The latest update contains: ",
		Color(255,100,0),
		"Double XP weekend!"
	)
end)

net.Receive("VEXP Award", function(length)
	chat.AddText(Color(100,200,100),"[VEXP] ",Color(200,200,200),
		"You have made a ",
		Color(100,200,100),
		"successful",
		Color(200,200,200),
		" kill and have gained ",
		Color(200,200,100),
		"" .. net.ReadInt(32) .. "",
		Color(200,200,200),
		" XP."
	)
end)

net.Receive("VEXP Proven", function(length)
	local nick = net.ReadString(64)

	chat.AddText(Color(200,100,100),"[VEXP] ",Color(200,200,200),
		"Player ",
		Color(200,200,100),
		"" .. nick .. "",
		Color(200,200,200),
		" has killed a ",
		Color(200,100,100),
		"Traitor",
		Color(200,200,200),
		" and was awarded ",
		Color(200,200,100),
		"500",
		Color(200,200,200),
		" XP."
	)
end)

net.Receive("VEXP LevelUp", function(length)
	surface.PlaySound(VEXP.sounds.levelup)
	VEXP.canSoundPlay = false;
	timer.Simple(20, function() VEXP.canSoundPlay = true end)
	LocalPlayer():ViewPunch( Angle( -90, 0, 0 ) )
	chat.AddText(Color(100,100,200),"[VEXP] ",Color(200,200,200),
		"Use ",Color(135,135,135),
		"/vexp",Color(200,200,200),
		" to spend your new ",Color(100,100,200),
		"skill point.")
end)

net.Receive("VEXP Learn", function(length)
	local otamt = net.ReadInt(16)

	chat.AddText(Color(100,100,200),"[VEXP] ",Color(200,200,200),
		"You have gained ",
		Color(100,100,200),
		"" .. otamt .. "",
		Color(200,200,200),
		" XP from ",
		Color(100,100,200),
		"learning."
	)
	surface.PlaySound(VEXP.sounds.overtime)
end)

net.Receive("VEXP B LevelUp", function(length)
	local nick = net.ReadString(128)
	local level = net.ReadInt(16)

	chat.AddText(Color(100,200,100),"[VEXP] ",Color(200,200,200),
		"Player ",
		Color(200,200,100),
		"" .. nick .. "",
		Color(200,200,200),
		" has levelled up from: ",
		Color(200,100,100),
		"" .. level .. "",
		Color(200,200,200),
		" to ",
		Color(100,200,100),
		"" .. level+1 .. "",
		Color(200,200,200),
		", and have gained a ",
		Color(100,100,200),
		"skill point!"
	)
end)

net.Receive("VEXP AlertOnJoin", function(length)
	chat.AddText(Color(200,200,200),
		"This ",
		Color(100,200,100),
		"ValkyrieGaming",
		Color(200,200,200),
		" server supports and is currently running ",
		Color(100,200,100),
		"VEXP",
		Color(200,200,200),
		" on ",
		Color(135,135,135),
		"(" .. VEXP.ver .. ")",
		Color(200,200,200),
		"."
	)

	if (!file.Exists("sound/maxlevelhit.mp3", "GAME")) or (!file.Exists("sound/vexp_sfx/overtime.mp3","GAME")) or (!file.Exists("sound/vexp_sfx/fallprotect.mp3","GAME")) then
		chat.AddText(Color(200,100,100),"[VEXP Warning] ",Color(200,200,200),
			"A sound file is missing. Some sounds may still work though. Please tell an admin or a mod.")
	end

end)

net.Receive("VEXP TotalXPGainedForRound", function(length)
	local amt = net.ReadInt(16);

	if amt >= 1000 then
		chat.AddText(Color(100,200,100),"[VEXP] ",
			Color(200,200,200),
			"This round you were awarded ",Color(200,100,100),
			"" .. amt .. " total XP",Color(200,200,200),
			". ",Color(100,200,200),
			"Epic",Color(200,200,200),
			" accumulation."
		)
	elseif amt >= 500 then
		chat.AddText(Color(100,200,100),"[VEXP] ",
			Color(200,200,200),
			"This round you were awarded ",Color(200,100,100),
			"" .. amt .. " total XP",Color(200,200,200),
			". ",Color(100,200,100),
			"Nice",Color(200,200,200),
			" accumulation."
		)
	elseif amt < 500 && amt > 0 then
		chat.AddText(Color(100,200,100),"[VEXP] ",
			Color(200,200,200),
			"This round you were awarded ",Color(200,100,100),
			"" .. amt .. " total XP",Color(200,200,200),
			". ",Color(200,200,200),
			"Decent accumulation."
		)
	else
		chat.AddText(Color(100,200,100),"[VEXP] ",
			Color(200,200,200),
			"This round you were awarded ",Color(200,100,100),
			"" .. amt .. " total XP",Color(200,200,200),
			". ",Color(200,100,100),
			"Bad",Color(200,200,200),
			" accumulation."
		)
	end
end)

net.Receive("VEXP EndRoundXPRewards", function(len)
	chat.AddText(Color(100,200,100),"[VEXP End Round] ",Color(200,200,200),
		"You won! ",Color(135,135,135),
		"You",Color(200,200,200),
		" and ",Color(135,135,135),
		"your whole team",Color(200,200,200),
		" have been ",Color(135,135,135),
		"rewarded",Color(100,200,100),
		" 1,000",Color(200,200,200),
		" XP."
	)
end)

--[[



	GUI CODE



]]--

function VEXP.DrawMenu()
	VEXP.clientSkills = util.JSONToTable(LocalPlayer():GetNWString("skills"))
	surface.PlaySound(VEXP.sounds.openmenu)
	selected = "Starter Anatomical Understanding";

	local VEXPMenu = vgui.Create("DFrame")
	VEXPMenu:SetSize(450,200)
	VEXPMenu:Center()
	VEXPMenu:SetTitle("VEXP || Control Panel")
	VEXPMenu:SetDeleteOnClose(true)
	VEXPMenu:MakePopup()

	local CPPSheet = vgui.Create("DPropertySheet", VEXPMenu)
	CPPSheet:SetPos(13, 30)
	CPPSheet:SetSize(VEXPMenu:GetWide() - 25, VEXPMenu:GetTall() - 42)
	CPPSheet:SetMouseInputEnabled(true)

	local Manage = vgui.Create("DPanel",CPPSheet)
	Manage:SetPos( 25, 50 )
	Manage:SetSize( 250, 250 )

		-- {
			local Manage_AltLBG = vgui.Create("DPanel",Manage)
			Manage_AltLBG:SetPos(5,5)
			Manage_AltLBG:SetSize(399,20)
			Manage_AltLBG:SetBackgroundColor(Color(225,225,225))

			local Manage_AltL = vgui.Create("DLabel",Manage_AltLBG)
			Manage_AltL:SetPos(5,3)
			Manage_AltL:SetText("Here is an overlook of your account with vG. Have a look for yourself.")
			Manage_AltL:SetTextColor(Color(80,80,80))
			Manage_AltL:SizeToContents()

			local Manage_Alt2LBG = vgui.Create("DPanel",Manage)
			Manage_Alt2LBG:SetPos(5,30)
			Manage_Alt2LBG:SetSize(134,20)
			Manage_Alt2LBG:SetBackgroundColor(Color(225,225,225))

			local Manage_Alt2L = vgui.Create("DLabel",Manage_Alt2LBG)
			Manage_Alt2L:SetPos(5,3)
			Manage_Alt2L:SetText("Your account information:")
			Manage_Alt2L:SetTextColor(Color(80,80,80))
			Manage_Alt2L:SizeToContents()

			local Manage_AltML = vgui.Create("DLabel",Manage)
			Manage_AltML:SetPos(6,52)
			Manage_AltML:SetText("You have had an account with Valkyrie-\nGaming since the " .. LocalPlayer():GetNWInt("DateJoined") .. ",\nand have been a donator since\n" .. LocalPlayer():GetNWInt("DateGiven") .. ".")
			Manage_AltML:SetTextColor(Color(80,80,80))
			Manage_AltML:SizeToContents()

			local Manage_AltNBG = vgui.Create("DPanel",Manage)
			Manage_AltNBG:SetPos(199,30)
			Manage_AltNBG:SetSize(205,20)
			Manage_AltNBG:SetBackgroundColor(Color(225,225,225))

			local Manage_AltN = vgui.Create("DLabel",Manage_AltNBG)
			Manage_AltN:SetPos(5,3)
			Manage_AltN:SetText("" .. LocalPlayer():Nick() .. "")
			Manage_AltN:SetTextColor(Color(80,80,80))
			Manage_AltN:SizeToContents()

			local Manage_Alt3LBG = vgui.Create("DPanel",Manage)
			Manage_Alt3LBG:SetPos(334,51)
			Manage_Alt3LBG:SetSize(70,70)
			Manage_Alt3LBG:SetBackgroundColor(Color(225,225,225))

			local Manage_AvIm = vgui.Create("AvatarImage",Manage_Alt3LBG)
			Manage_AvIm:SetPos(3,3)
			Manage_AvIm:SetSize(64, 64)
			Manage_AvIm:SetPlayer(LocalPlayer(), 64)

			local Manage_AvLBG = vgui.Create("DPanel",Manage)
			Manage_AvLBG:SetPos(199,51)
			Manage_AvLBG:SetSize(134,20)
			Manage_AvLBG:SetBackgroundColor(Color(225,225,225))

			local Manage_AvL = vgui.Create("DLabel",Manage_AvLBG)
			Manage_AvL:SetPos(5,3)
			Manage_AvL:SetText("Level: " .. LocalPlayer():GetNWInt("level") .. "")
			Manage_AvL:SetTextColor(Color(80,80,80))
			Manage_AvL:SizeToContents()

			local Manage_AvLBG2 = vgui.Create("DPanel",Manage)
			Manage_AvLBG2:SetPos(199,72)
			Manage_AvLBG2:SetSize(134,20)
			Manage_AvLBG2:SetBackgroundColor(Color(225,225,225))

			local Manage_AvL2 = vgui.Create("DLabel",Manage_AvLBG2)
			Manage_AvL2:SetPos(5,3)
			Manage_AvL2:SetText("XP: " .. LocalPlayer():GetNWInt("xp") .. "/" .. LocalPlayer():GetNWInt("nextlevel") .. "")
			Manage_AvL2:SetTextColor(Color(80,80,80))
			Manage_AvL2:SizeToContents()

			if !timer.Exists("VEXP CsUpd") then
				timer.Create("VEXP CSUpd", 1, 0, function()
					if VEXPMenu and VEXPMenu:IsVisible() then
						Manage_AvL:SetText("Level: " .. LocalPlayer():GetNWInt("level") .. "")
						Manage_AvL2:SetText("XP: " .. LocalPlayer():GetNWInt("xp") .. "/" .. LocalPlayer():GetNWInt("nextlevel") .. "")
						Manage_AvL:SizeToContents()
						Manage_AvL2:SizeToContents()
					end
				end)
			end

			local Manage_AvLBG3 = vgui.Create("DPanel",Manage)
			Manage_AvLBG3:SetPos(199,93)
			Manage_AvLBG3:SetSize(134,20)
			Manage_AvLBG3:SetBackgroundColor(Color(225,225,225))

			local Manage_AvL3 = vgui.Create("DLabel",Manage_AvLBG3)
			Manage_AvL3:SetPos(5,3)

			if LocalPlayer():SteamID() == "STEAM_0:0:30517277" then
				Manage_AvL3:SetText("Developer")
				Manage_AvL3:SetTextColor(Color(135,70,70))
			elseif LocalPlayer():SteamID() == "STEAM_0:1:25655723" then
				Manage_AvL3:SetText("Owner")
				Manage_AvL3:SetTextColor(Color(135,70,70))
			elseif LocalPlayer():GetNWBool("Supporter") == true then
				Manage_AvL3:SetText("Donator")
				Manage_AvL3:SetTextColor(Color(135,70,135))
			elseif LocalPlayer():IsUserGroup("mod") then
				Manage_AvL3:SetText("Moderator")
				Manage_AvL3:SetTextColor(Color(70,70,135))
			elseif LocalPlayer():IsAdmin() then
				Manage_AvL3:SetText("Administrator")
				Manage_AvL3:SetTextColor(Color(70,70,135))
			elseif LocalPlayer():IsUserGroup("regular") then
				Manage_AvL3:SetText("Regular")
				Manage_AvL3:SetTextColor(Color(70,135,70))
			else
				Manage_AvL3:SetText("Guest")
				Manage_AvL3:SetTextColor(Color(80,80,80))
			end

			Manage_AvL3:SizeToContents()
		-- }

	VEXP.isPlayerExcept = function(ply)
		local except = false

		for k,v in pairs(VEXP.sAdminModifyExceptions) do
			if ply:SteamID() == v then
				except = true
			end
		end

		return except
	end

	if (VEXP.canSAdminModify and LocalPlayer():IsSuperAdmin()) or VEXP.isPlayerExcept(LocalPlayer()) then
		Admin_CPP_VEXP = vgui.Create("DPanel",CPPSheet)
		Admin_CPP_VEXP:SetPos( 25, 50 )
		Admin_CPP_VEXP:SetSize( 250, 250 )

			local Admin_PList = vgui.Create("DListView",Admin_CPP_VEXP)
			Admin_PList:SetPos(5,5)
			Admin_PList:SetSize(150,112)

			Admin_PList:AddColumn("ID")
			Admin_PList:AddColumn("Nick")
			Admin_PList:AddColumn("Level")
			Admin_PList:AddColumn("XP")

			for k,v in pairs(player.GetAll()) do
				Admin_PList:AddLine(v,v:Nick(),v:GetNWInt("level"),"" .. v:GetNWInt("xp") .. "/" .. v:GetNWInt("nextlevel") .. "")
			end

			local Admin_P = vgui.Create("DPanel",Admin_CPP_VEXP)
			Admin_P:SetPos(160,5)
			Admin_P:SetSize(243,20)
			Admin_P:SetBackgroundColor(Color(225,225,225))
			-- {
				Admin_Lab = vgui.Create("DLabel",Admin_P)
				Admin_Lab:SetPos(5,4)
				Admin_Lab:SetText("Selected Player: N/A")
				Admin_Lab:SetTextColor(Color(80,80,80))
				Admin_Lab:SizeToContents()

				Admin_PList.OnRowSelected = function( pnl, ln )
					surface.PlaySound(VEXP.sounds.openmenu)
					admin_plist_sel = pnl:GetLine(ln):GetValue(1)

					Admin_Lab:SetText(
						"Selected Player: " .. admin_plist_sel:Nick()
					)

					Admin_Input1:SetText("" .. admin_plist_sel:GetNWInt("level") .. "")
					Admin_Input2:SetText("" .. admin_plist_sel:GetNWInt("xp") .. "")

					Admin_Lab4:SetText("Level: " .. admin_plist_sel:GetNWInt("level") .. "\nXP: " .. admin_plist_sel:GetNWInt("xp") .. "/" .. admin_plist_sel:GetNWInt("nextlevel") .. "")

					timer.Simple(0.005, function() Admin_Lab:SizeToContents() Admin_Lab4:SizeToContents() end)
				end

			local Admin_Lab4_BG = vgui.Create("DPanel",Admin_CPP_VEXP)
			Admin_Lab4_BG:SetPos(160,29)
			Admin_Lab4_BG:SetSize(243,39)
			Admin_Lab4_BG:SetBackgroundColor(Color(225,225,225))

			Admin_Lab4 = vgui.Create("DLabel",Admin_Lab4_BG)
			Admin_Lab4:SetPos(5,4)
			Admin_Lab4:SetText("Level: (No Data)\nXP: (No Data)/(No Data)")
			Admin_Lab4:SetTextColor(Color(80,80,80))
			Admin_Lab4:SizeToContents()

			local Admin_Lab2_BG = vgui.Create("DPanel",Admin_CPP_VEXP)
			Admin_Lab2_BG:SetPos(160,72)
			Admin_Lab2_BG:SetSize(38,20)
			Admin_Lab2_BG:SetBackgroundColor(Color(225,225,225))

			local Admin_Lab2 = vgui.Create("DLabel",Admin_Lab2_BG)
			Admin_Lab2:SetPos(5,4)
			Admin_Lab2:SetText("Level: ")
			Admin_Lab2:SetTextColor(Color(80,80,80))
			Admin_Lab2:SizeToContents()

			local Admin_Lab3_BG = vgui.Create("DPanel",Admin_CPP_VEXP)
			Admin_Lab3_BG:SetPos(160,97)
			Admin_Lab3_BG:SetSize(38,20)
			Admin_Lab3_BG:SetBackgroundColor(Color(225,225,225))

			local Admin_Lab3 = vgui.Create("DLabel",Admin_Lab3_BG)
			Admin_Lab3:SetPos(5,4)
			Admin_Lab3:SetText("XP: ")
			Admin_Lab3:SetTextColor(Color(80,80,80))
			Admin_Lab3:SizeToContents()

			Admin_Input1 = vgui.Create("DTextEntry",Admin_CPP_VEXP)
			Admin_Input1:SetPos(203,72)
			Admin_Input1:SetSize(200,20)
			Admin_Input1:SetText("The selected player's level will appear here.")
			Admin_Input1.OnEnter = function( self )
				admininput1_input = self:GetValue()
					local before_change = admin_plist_sel:GetNWInt("level")
					LocalPlayer():ConCommand("vexp_setlevel \"" .. admin_plist_sel:SteamID() .. "\" " .. tonumber(admininput1_input))

					chat.AddText(Color(100,200,100),"[VEXP] ",Color(200,200,200),
						"You have changed ",
						Color(100,100,200),
						admin_plist_sel:Nick(),
						Color(200,200,200),
						"'s level to: ",
						Color(200,200,100),
						"" .. admininput1_input .. "",
						Color(200,200,200),
						". ",
						Color(135,135,135),
						"(OLD LEVEL: " .. before_change .. ")"
					)
			end

			Admin_Input2 = vgui.Create("DTextEntry",Admin_CPP_VEXP)
			Admin_Input2:SetPos(203,97)
			Admin_Input2:SetSize(200,20)
			Admin_Input2:SetText("The selected player's XP will appear here.")
			Admin_Input2.OnEnter = function( self )
				admininput2_input = self:GetValue()
					LocalPlayer():ConCommand("vexp_givexp \"" .. admin_plist_sel:SteamID() .. "\" " .. tonumber(admininput2_input))

						chat.AddText(Color(100,200,100),"[VEXP] ",Color(200,200,200),
							"You have given ",
							Color(200,200,100),
							"" .. admininput2_input .. "",
							Color(200,200,200),
							" XP to ",
							Color(100,100,200),
							admin_plist_sel:Nick(),
							Color(200,200,200),
							". ",
							Color(135,135,135),
							"(NEW DATA: " .. admin_plist_sel:GetNWInt("xp") .. "/" .. admin_plist_sel:GetNWInt("nextlevel") .. ")"
						)
			end
		--}
	end

		VEXP_Skills = vgui.Create("DPanel",CPPSheet)
		VEXP_Skills:SetPos( 25, 50 )
		VEXP_Skills:SetSize( 250, 250 )

		VEXPMenu.Refresh = function()
			--
			local Skills = vgui.Create("DScrollPanel", VEXP_Skills)
			Skills:SetSize(160,112)
			Skills:SetPos(5, 5)
			Skills.Paint = function()
				draw.RoundedBox(2, 0, 0, Skills:GetWide(), Skills:GetTall(), Color(200,200,200))
			end
			Skills.Refresh = function()
				local SkillsLayout = vgui.Create("DIconLayout", Skills)
				SkillsLayout:SetPos(0, 0)
				SkillsLayout:SetSize(Skills:GetWide(), Skills:GetTall())
				SkillsLayout:SetSpaceX(2)
				SkillsLayout:SetSpaceY(2)
				
				for k,v in SortedPairs(VEXP.Skills) do
					local SkillsPanel = SkillsLayout:Add("DPanel")
					SkillsPanel:SetSize(Skills:GetWide(), 60)
					SkillsPanel.Paint = function()
						draw.RoundedBox(2, 0, 0, Skills:GetWide(), Skills:GetTall(), Color(135,135,135))
					end
					
					local SkillName = vgui.Create("DLabel", SkillsPanel)
					SkillName:SetPos(4, 0)
					SkillName:SetSize(Skills:GetWide(), 30)
					SkillName:SetText(v[1])
					SkillName:SetTextColor(Color(255, 255, 255))
					
					if LocalPlayer():GetNWInt("level", 0) < v[2] then
						SkillName:SetTextColor(Color(180, 180, 180))
					end
					
					local SkillLevel = vgui.Create("DLabel", SkillsPanel)
					SkillLevel:SetPos(4, 30)
					SkillLevel:SetSize(Skills:GetWide(), 30)
					SkillLevel:SetText("Lvl. " .. v[2])
					SkillLevel:SetTextColor(Color(255, 255, 255))
					
					if LocalPlayer():GetNWInt("level", 0) < v[2] then
						SkillLevel:SetTextColor(Color(180, 180, 180))
					end
					
					local SkillsButton = vgui.Create("DButton", SkillsPanel)
					SkillsButton:SetSize(Skills:GetWide(), 60)
					SkillsButton:SetPos(0, 0)
					SkillsButton:SetText("")
					SkillsButton.Paint = function() end
					SkillsButton.DoClick = function()
						selected = v[1]
						VEXPMenu:Refresh()
					end
				end
			end
			Skills:Refresh()

			for k, v in pairs(VEXP.Skills) do
				if selected == v[1] then
					local SkillsPanel = vgui.Create("DPanel", VEXP_Skills)
					SkillsPanel:SetSize(239, 360)
					SkillsPanel:SetPos(165, 5)
					SkillsPanel.Paint = function()
						draw.RoundedBox(2, 0, 0, SkillsPanel:GetWide(), Skills:GetTall(), Color(80,80,80))
					end
					
					local SPPanel = vgui.Create("DPanel", SkillsPanel)
					SPPanel:SetSize(50,20)
					SPPanel:SetPos( SkillsPanel:GetWide() - 50 ,0)
					SPPanel.Paint = function()
						draw.RoundedBox(2, 0, 0, SPPanel:GetWide(), SPPanel:GetTall(), Color(75,200,75))
					end

					local SPNumber = vgui.Create("DLabel",SPPanel)
					SPNumber:SetPos(5,0)
					SPNumber:SetText("SP: " .. LocalPlayer():GetNWInt("skillpoints"))
					SPNumber:SetTextColor(Color(0,255,255))

					if LocalPlayer():GetNWInt("skillpoints") == 0 then
						SPNumber:SetTextColor(Color(255,0,0))
					end

					local LevelNumber = vgui.Create("DLabel", SkillsPanel)
					LevelNumber:SetPos(5, 25)
					LevelNumber:SetText("Level " .. v[2])
					LevelNumber:SetTextColor(Color(255, 255, 255))
					
					if LocalPlayer():GetNWInt("level", 0) < v[2] then
						LevelNumber:SetTextColor(Color(180, 180, 180))
					end
					
					LevelNumber:SizeToContents()
					
					local SkillTitle = vgui.Create("DLabel", SkillsPanel)
					SkillTitle:SetPos(5, 5)
					SkillTitle:SetText(v[1])
					SkillTitle:SetTextColor(Color(255, 255, 255))
					
					if LocalPlayer():GetNWInt("level", 0) < v[2] then
						SkillTitle:SetTextColor(Color(180, 180, 180))
					end

					SkillTitle:SizeToContents()
					
					local SkillDescription = vgui.Create("DLabel", SkillsPanel)
					SkillDescription:SetPos(5, 5)
					SkillDescription:SetSize(290, 120)
					SkillDescription:SetTextColor(Color(255, 255, 255))
					
					if LocalPlayer():GetNWInt("level", 0) < v[2] then
						SkillDescription:SetTextColor(Color(180, 180, 180))
					end
					
					SkillDescription:SetText(v[3])
					SkillDescription:SetAutoStretchVertical()

						if LocalPlayer():GetNWInt("skillpoints", 0) > 0 and LocalPlayer():GetNWInt("level", 0) >= v[2] and !table.HasValue(VEXP.clientSkills, k) then
							VEXP.clientSkills = util.JSONToTable(LocalPlayer():GetNWString("skills"))
							local AddButton = vgui.Create("DButton", SkillsPanel)
							AddButton:SetSize(70, 15)
							AddButton:SetPos(164, 92)
							AddButton:SetText("ADD")
							AddButton:SetTextColor(Color(255, 255, 255))
							AddButton.DoClick = function()
								if v[4] then
									if table.HasValue(VEXP.clientSkills,v[4]) then
										net.Start("VEXP BuySkill")
											net.WriteFloat(k)
										net.SendToServer()
										
										selected = v[1]

										chat.AddText(Color(100,100,200),"[VEXP] ",Color(200,200,200),
											"Skill ",Color(100,200,100),
											"'" .. v[1] .. "'",Color(200,200,200),
											" has been learnt."
										)

										timer.Simple(0.1, function()
											VEXP.clientSkills = util.JSONToTable(LocalPlayer():GetNWString("skills"))
											timer.Simple(0.4, function()
												VEXPMenu:Refresh()
											end)
										end)
									else
										for id,unpkd in pairs(VEXP.Skills) do
											if v[4] == id then
												skillreqname = unpkd[1]
											end
										end

										chat.AddText(Color(200,100,100),"[VEXP] ",Color(200,200,200),
											"You require the ",Color(100,100,200),
											"'" .. skillreqname .. "'",Color(200,200,200),
											" skill before you can learn this skill."
										)
									end
								else
									net.Start("VEXP BuySkill")
										net.WriteFloat(k)
									net.SendToServer()
										
									selected = v[1]

									chat.AddText(Color(100,100,200),"[VEXP] ",Color(200,200,200),
										"Skill ",Color(100,200,100),
										"'" .. v[1] .. "'",Color(200,200,200),
										" has been learnt."
									)
										
									timer.Simple(0.1, function()
										VEXP.clientSkills = util.JSONToTable(LocalPlayer():GetNWString("skills"))
										VEXPMenu:Refresh()
									end)
								end
							end
							AddButton.Paint = function()
								draw.RoundedBox(2, 0, 0, AddButton:GetWide(), AddButton:GetTall(), Color(0, 200, 0))
							end
						else
							VEXP.clientSkills = util.JSONToTable(LocalPlayer():GetNWString("skills"))
							if table.HasValue(VEXP.clientSkills, k) then
								local AddButton = vgui.Create("DButton", SkillsPanel)
								AddButton:SetSize(70, 15)
								AddButton:SetPos(164, 92)
								AddButton:SetText("OWNED")
								AddButton:SetTextColor(Color(255, 255, 255))
								AddButton.DoClick = function() end
								AddButton.Paint = function()
									draw.RoundedBox(2, 0, 0, AddButton:GetWide(), AddButton:GetTall(), Color(175, 0, 0))
								end
							else
								local AddButton = vgui.Create("DButton", SkillsPanel)
								AddButton:SetSize(70, 15)
								AddButton:SetPos(164, 92)
								AddButton:SetText("ADD")
								AddButton:SetTextColor(Color(255, 255, 255))
								AddButton.DoClick = function() end
								AddButton.Paint = function()
									draw.RoundedBox(2, 0, 0, AddButton:GetWide(), AddButton:GetTall(), Color(218, 165, 32))
								end
							end
						end
					end
				end
			end
		VEXPMenu:Refresh()

		local HelpTab = vgui.Create("DPanel",CPPSheet)
		HelpTab:SetPos( 25, 50 )
		HelpTab:SetSize( 250, 250 )

		local Help1_BG = vgui.Create("DPanel",HelpTab)
		Help1_BG:SetPos(4,5)
		Help1_BG:SetSize(400,36)
		Help1_BG:SetBackgroundColor(Color(225,225,225))

		local Help1 = vgui.Create("DLabel",Help1_BG)
		Help1:SetPos(5,5)
		Help1:SetText("This is the Help tab. You can reset your data from here. If you need any addition-\nal help or advice, you can ask one of the people on the server.")
		Help1:SetTextColor(Color(80,80,80))
		Help1:SizeToContents()

		local ResetAllData = vgui.Create("DButton",HelpTab)
		ResetAllData:SetPos(4,48)
		ResetAllData:SetSize(400,30)
		ResetAllData:SetText("Delete All Data")
		ResetAllData.DoClick = function()
			net.Start("VEXP Reset")
			net.SendToServer()

			chat.AddText(Color(100,100,200),"[VEXP] ",Color(200,200,200),
				"All your data is now gone. If this was a mistake, re-join before you gain any more XP to restore your data."
			)
		end

		local ResetSP = vgui.Create("DButton",HelpTab)
		ResetSP:SetPos(4,85)
		ResetSP:SetSize(400,30)
		ResetSP:SetText("Un-assign Skill Points")
		ResetSP.DoClick = function()
			net.Start("VEXP ResetSP")
			net.SendToServer()

			chat.AddText(Color(100,100,200),"[VEXP] ",Color(200,200,200),
				"Your skills have been reset, and all your skill points have been refunded."
			)
		end

	--

	local order = {}
	order[1] = {"Manage", Manage, "icon16/application.png", false, false, "Manage your account on ValkyrieGaming."}
	order[2] = {"General Skills", VEXP_Skills, "icon16/package_green.png", false, false, "Preview and improve your player."}
	order[3] = {"Help", HelpTab, "icon16/help.png", false, false, "Additional actions and assistance can be found here."}

	if (VEXP.canSAdminModify and LocalPlayer():IsSuperAdmin()) or VEXP.isPlayerExcept(LocalPlayer()) then
		order[4] = {"Admin", Admin_CPP_VEXP, "icon16/shield.png", false, false, "Modify account information here."}
	end

	for _, tab in pairs(order) do
		CPPSheet:AddSheet(unpack(tab))
	end

	hook.Add("Think", "VEXP keyOpenMenu", function()
		if input.IsKeyDown(VEXP.openMenuKey) then
			if !VEXPMenu or !VEXPMenu:IsVisible() then
				VEXP.DrawMenu()
				return true
			end
		end
	end)
end
concommand.Add("+vexp_menu", VEXP.DrawMenu)

net.Receive("VEXP Menu", function(length)
	VEXP.DrawMenu()
end)