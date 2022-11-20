if ULib ~= nil then
    ULib.ucl.registerAccess(
        'chatprint',
        { 'operator', 'admin', 'superadmin' },
        'Permission to print colored messages with Expression 2',
        'ChatPrint'
    )
end

hook.Add( 'ChatPrintAccess', 'chatprint_DefaultAccessCheck', function( ply )
    if ULib and not ULib.ucl.query( ply, 'chatprint' ) then
        return 'deny'
    end

    return 'allow'
end )