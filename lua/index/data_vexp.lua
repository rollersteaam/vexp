local plymeta = FindMetaTable("Player")

VEXP.defaultData = {
	slevel = 0,
	level = 0,
	xp = 0,
	nextlevel = 100,
	skillpoints = 0,
	skills = "{}"
}

if not file.IsDir( 'vexp', 'DATA' ) then
	file.CreateDir("vexp")
end

if not file.IsDir( 'vexp/players', 'DATA' ) then
	file.CreateDir("vexp/players")
end

function plymeta:VEXP_GetData()
	local filename = string.Replace(self:SteamID(),":","_")

	if not file.Exists( 'vexp/players/' .. filename .. '.txt', 'DATA' ) then
		return VEXP.defaultData
	else
		return util.JSONToTable(file.Read( 'vexp/players/' .. filename .. '.txt' ))
	end
end

function plymeta:VEXP_SendData()
	local filename = string.Replace(self:SteamID(),":","_")

	file.Write( 'vexp/players/' .. filename .. '.txt', util.TableToJSON({
		slevel = self:GetNWInt("slevel"),
		level = self:GetNWInt("level"),
		xp = self:GetNWInt("xp"),
		nextlevel = self:GetNWInt("nextlevel"),
		skillpoints = self:GetNWInt("skillpoints"),
		skills = self:GetNWString("skills", "{}")
	}) )
end