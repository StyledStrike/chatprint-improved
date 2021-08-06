if ULib ~= nil then
	ULib.ucl.registerAccess("chatprint", {"operator", "admin", "superadmin"},
		"Permission to print colored messages with Expression 2", "ChatPrint")
end

local CP_PlayerNextPrint = {}

hook.Remove("PlayerDisconnected", "chatprint_PlayerDisconnected")
hook.Add("PlayerDisconnected", "chatprint_PlayerDisconnected", function(ply)
	if CP_PlayerNextPrint[ply] then
		CP_PlayerNextPrint[ply] = nil
	end
end)

hook.Remove("ChatPrintAccess", "chatprint_DefaultAccess")
hook.Add("ChatPrintAccess", "chatprint_DefaultAccess", function(ply, _)
	if ULib and not ULib.ucl.query(ply, "chatprint") then
		return "deny"
	end

	local realTime = RealTime()
	local nextPrint = CP_PlayerNextPrint[ply] or 0

	if realTime > nextPrint then
		CP_PlayerNextPrint[ply] = realTime + 0.5
		return "allow"
	end

	return "deny"
end)