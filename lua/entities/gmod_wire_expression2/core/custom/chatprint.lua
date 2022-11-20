--[[
    ChatPrint Improved - Originally made by Dr. Matt
    Rewritten by StyledStrike
]]

if SERVER then
    util.AddNetworkString( 'chatprint.print' )
end

E2Lib.RegisterExtension( 'chatprint', true )

local MAX_CHARACTERS = 300

local VALID_COLOR_TYPES = {
    ['table'] = true,
    ['Color'] = true,
    ['Vector'] = true
}

local function IsValidColor( v )
    if not VALID_COLOR_TYPES[type( v )] then return false end

    if isnumber( v[1] ) and isnumber( v[2] ) and isnumber( v[3] ) then
        return true
    end

    return false
end

-- Keep track of when players can print again
local nextPrint = WireLib.RegisterPlayerTable()

local function canPrint( ply, text )
    if hook.Run( 'ChatPrintAccess', ply, text ) == 'deny' then
        return false
    end

    local now, nex = RealTime(), nextPrint[ply] or 0
    if now < nex then
        return false
    end

    return true
end

local function ChatPrint( author, target, ... )
    -- maybe the author left the game...
    if not IsValid( author ) then return end

    local args = { ... }

    if #args < 1 then return end

    if IsValid( target ) and not target:IsPlayer() then
        error( 'Target entity on chatPrint is not a player!' )

        return
    end

    local onlyText = ''
    local filteredArgs = {}

    for _, v in ipairs( args ) do
        if type( v ) == 'string' then
            onlyText = onlyText .. v
            filteredArgs[#filteredArgs + 1] = v

        elseif IsValidColor( v ) then
            filteredArgs[#filteredArgs + 1] = Color( v[1], v[2], v[3] )
        end
    end

    if string.len( onlyText ) == 0 then
        error( 'chatPrint content has no text!' )

        return

    elseif string.len( onlyText ) > MAX_CHARACTERS then
        error( 'chatPrint content was too big! (Max. ' .. MAX_CHARACTERS .. ' characters)' )

        return
    end

    if not canPrint( author, onlyText ) then return end

    nextPrint[author] = RealTime() + 0.5

    local argStr = util.TableToJSON( filteredArgs )
    local argLen = string.len( argStr )

    net.Start( 'chatprint.print', false )
    net.WriteEntity( author )
    net.WriteUInt( argLen, 16 )
    net.WriteData( argStr, argLen )

    if IsValid( target ) then
        net.Send( target )
    else
        net.Broadcast()
    end
end

--------------------------------------------------------------------------------
__e2setcost( 5 )

e2function number canChatPrint()
    return canPrint( self.player, 'canPrint' ) and 1 or 0
end

__e2setcost( 50 )

e2function void chatPrint( ... )
    ChatPrint( self.player, nil, ... )
end

e2function void chatPrint( entity ply, ... )
    ChatPrint( self.player, ply, ... )
end

e2function void chatPrint( array r )
    ChatPrint( self.player, nil, unpack( r ) )
end

e2function void chatPrint( entity ply, array r )
    ChatPrint( self.player, ply, unpack( r ) )
end