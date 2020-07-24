if (SERVER) then
	print("(VEXP) Loading configuration.")

	include('config_vexp.lua')
	print("(VEXP) Configuration applied.")

	if VEXP.enabled then
		print("(VEXP) 'VEXP.enabled' read OK. Continuing.")

		resource.AddFile("sound/vexp_sfx/vexp_levelup.mp3")
		resource.AddFile("sound/vexp_sfx/overtime.mp3")
		resource.AddFile("sound/vexp_sfx/fallprotect.mp3")
		resource.AddFile("sound/vexp_sfx/explodeprotect.mp3")
		resource.AddFile("sound/maxlevelhit.mp3")
		print("(VEXP) Added 5 sounds to download list.")

		AddCSLuaFile()
		AddCSLuaFile("config_vexp.lua")
		AddCSLuaFile("cl_vexp.lua")
		AddCSLuaFile("index/idx_vexp.lua")
		print("(VEXP) Added 4 scripts to download list.")

		include('index/idx_vexp.lua')
		include('index/data_vexp.lua')
		include('sv_vexp.lua')
		print("(VEXP) Executed dependencies, framework and base. Checking version.")
		print("(VEXP) Successfully initialised VEXP on build '" .. VEXP.ver .. "'.")
	else
		print("(VEXP) 'VEXP.enabled' read BAD. Stopping.")
		print("(VEXP) [WARNING] 'VEXP.enabled' = false. VEXP will not initialise. Terminating script.")
	end
end

if (CLIENT) then
	print("(VEXP) Hooking on to the client.")
	print("(VEXP) Hook successful.")

	include('config_vexp.lua')
	include('cl_vexp.lua')
	include('index/idx_vexp.lua')
	print("(VEXP) Executed idx, net, cfg.")
	print("(VEXP) Executed shared scripts.")
	print("(VEXP) Checking version...")

	print("(VEXP) Successfully initialised VEXP on build '" .. VEXP.ver .. "'.")
end