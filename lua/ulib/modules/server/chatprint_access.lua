if ULib ~= nil then
	ULib.ucl.registerAccess("chatprint", {"operator", "admin", "superadmin"},
		"Permission to print colored messages with Expression 2", "ChatPrint")
end

hook.Remove("ChatPrintAccess", "chatprint_DefaultAccess")
hook.Add("ChatPrintAccess", "chatprint_DefaultAccess", function(ply, _)
	if ULib and not ULib.ucl.query(ply, "chatprint") then
		return "deny"
	end

	return "allow"
end)