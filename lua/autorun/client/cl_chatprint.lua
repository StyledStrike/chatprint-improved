net.Receive( "chatprint.print", function()
    local author = net.ReadEntity()

    if not IsValid( author ) then return end

    local argsLen = net.ReadUInt( 16 )
    local argsStr = net.ReadData( argsLen )
    local args = util.JSONToTable( argsStr )

    MsgC( Color( 255, 100, 100 ), "[" .. author:Nick() .. "] " )
    chat.AddText( unpack( args ) )
end )
