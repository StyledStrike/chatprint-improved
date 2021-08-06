## ChatPrint - Improved

A Expression 2 extension that allows players to print colorful text to chat. A few key differences between this addon and the original [ChatPrint (by Dr. Matt)](https://github.com/MattJeanes/ChatPrint) are:

* Adds a per-group permission to [ULX](https://ulyssesmod.net/downloads.php): `chatprint`
* Only players on a group with `chatprint` access can use it
* Limits the length of the contents _(300 characters)_
* Limits how quickly players can use it _(500 ms between each print)_
* Prints the author's name to console

### Installation

1. Download the source code `Code > Download Zip`
2. Extract the ZIP contents `chatprint-improved-master` to your Garry's Mod addons folder
3. Enable the extension *(Skip if enabled already, requires admin privileges)*
	* Using the console command `wire_expression2_extension_enable chatprint`
	* Through the Extensions menu on **Spawnlist > Utilities > Admin > E2 Extensions**

### Functions

Cost | Function				| Description
---- | -------------------- | -----------
5    | canChatPrint()		| Returns 1 if you have the permission **and** have waited long enough to print to chat.
50   | chatPrint(...)		| Prints all text, using the colors (as vectors, if provided), on everyone's chat.
50   | chatPrint(e,...)		| Prints all text, using the colors (as vectors, if provided), on E's chat.
50   | chatPrint(r)			| Prints all text and colors (as vectors, if provided) of the array on everyone's chat.
50   | chatPrint(e,r)		| Prints all text and colors (as vectors, if provided) of the array on E's chat.

### Example

```perl
@name ChatPrintTest

# Red 'Hello', green 'world' and blue '!'
chatPrint(vec(255,0,0), "Hello", vec(0,255,0), " world!", vec(0,0,255), "!")

# Print "bingus..." only for the chip owner
chatPrint(owner(), "bingus...")


# You can use a array to store the message contents
Contents = array(vec(255, 255, 0), "Mornin' Dew!")

# Print the array for everyone
chatPrint(Contents)

# Print the array only for the chip owner
chatPrint(owner(), Contents)
```

### For developers

You can override/complement the built-in access check using the `ChatPrintAccess` hook.

```lua
hook.Add("ChatPrintAccess", "override_charprint_access", function(ply, text)
	-- Do your own checks here. Returning anything other than "allow" blocks chatprint.

	-- Example: no more "bingus"!
	if string.find(text, "bingus") then
		return "deny"
	end
end)
```