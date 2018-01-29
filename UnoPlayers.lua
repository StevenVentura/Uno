--[[
9/4/2017 Steven Ventura ("gangsthurh"), all rights reserved

documentation for player object:

player = {

userHasUnoOrNot=false,
userHasUnoOrNotTimer=0,
userJoinedTheLobby=false

}

]]
--[[

10/23/17
players are seen as Soccerbilly-Gorefiend
and
-=-=
AddUnoPlayer("bnethashtag",butt.name,butt.presenceID,butt.glitchyAccountName);

if (remainder == UNO_MESSAGE_HAS_ADDON) then
--TODO da name match the table?
print("|cffffff00author is " .. author);
for i, ii in pairs(UnoPlayers) do
print("i=" .. i)
print("ii=" .. i
-=-=
all players will be identified by their Btag. i will never use their real name.


]]

--[[
10/28/17
the "name" attribute of player is his index in the array.
the server host is handled weird though.

On the server host's side, 
in his array, 
UnoHostContact.contactType = UNO_CONTACT_BTAG;
UnoHostContact.pid = pid;
AddUnoPlayerClientLobby("bnethashtag",author,pid);
else
UnoHostContact.contactType = UNO_CONTACT_WHISPER;
UnoHostContact.whisperName = author;
---------

UnoServerPlayers DOCUMENTATION:
[name] = {name , officialIndex};
used for mapping player indexes to their contact informtation and other data
]]

UNO_CONTACT_WHISPER = 1;
UNO_CONTACT_BTAG = 2;

--[[this is used for screens UNO_SCREEN_SLASHUNO = 1, and UNO_SCREEN_LOBBY = 2;
The UnoPlayers array might be used for the actual game itself ,on the server side.
]]
UnoPlayers = {};

--[[this, UnoPlayersClientLobby, is used for the screen called UNO_SCREEN_LOBBYGUEST
]]

UnoPlayersClientLobby = {};

--used by the client in the invitation phase
function AddUnoPlayerClientLobby(boolree, nameX, pid, glitchyAccountName)

----this section copied from AddUnoPlayer with 1 name change. note not all variables might be used.
if (boolree == "bnethashtag") then
taipu = UNO_CONTACT_BTAG;
end
if (boolree == "nameserver") then
taipu = UNO_CONTACT_WHISPER;
end

UnoPlayersClientLobby[nameX] = {
statusIcon="none",
whisperCategory=boolree,
userHasUnoOrNot=false,
userHasUnoOrNotTimer=0,
userJoinedTheLobby=false,
userDeclinedTheInvite=false,
contactType = taipu,
presenceID = pid,
isRealIDNotJustBNet = (glitchyAccountName ~= name),
realName = glitchyAccountName,
name = nameX
};
----end copy section

end--end function AddUnoPlayerClientLobby

--used during playing the game.
function AddUnoPlayerClientPlaying(playerName, index)
UnoClientPlayers[playerName] = {
		frame = CreateFrame("FRAME",nil,UIParent),
		officialIndex = index, name=playerName,centerX=0,centerY=0};
UnoClientPlayers[playerName].frame:SetSize(100,100);
UnoClientPlayers[playerName].title = 
	UnoClientPlayers[playerName].frame:CreateFontString(nil,nil,"GameFontNormal");
UnoClientPlayers[playerName].title:SetTextColor(1,0.643,0.169,1);
 UnoClientPlayers[playerName].title:SetShadowColor(0,0,0,1);
 UnoClientPlayers[playerName].title:SetShadowOffset(2,-1);
 UnoClientPlayers[playerName].title:SetPoint("CENTER",
	UnoClientPlayers[playerName].frame,"CENTER",0,0);
UnoClientPlayers[playerName].title:SetText(playerName);
UnoClientPlayers[playerName].title:Show(); 
end--end function AddUnoPlayerClientPlaying

--used by the server in the invitation phase
function AddUnoPlayer(boolree, button)--nameX,pid,glitchyAccountName) 

local taipu = "";
if (boolree == "bnethashtag") then
taipu = UNO_CONTACT_BTAG;
end
if (boolree == "nameserver") then
taipu = UNO_CONTACT_WHISPER;
end
local justFirstName = "";
if (string.find(button.toonName,"-") ~= nil) then
justFirstName = string.sub(button.toonName,
				1,
				string.find(button.toonName,"-")-1);
else
justFirstName = button.toonName;
end

--used on the server during lobby time and transferred partially to game time
UnoPlayers[button.name] = {
statusIcon="none",
whisperCategory=boolree,
userHasUnoOrNot=false,
userHasUnoOrNotTimer=0,
userJoinedTheLobby=false,
userDeclinedTheInvite=false,
contactType = taipu,
presenceID = button.presenceID,
isRealIDNotJustBNet = (button.glitchyAccountName ~= button.name),
realName = button.glitchyAccountName,
toonName = justFirstName,
name = button.name
};




end--end function AddUnoPlayer

--used during lobby somewhere, and used by the server to broadcast messages during the game
function UnoMessage(playerdata,message)
if (playerdata.contactType == UNO_CONTACT_WHISPER) then

SendChatMessage(message,"WHISPER",nil,playerdata.name);
end
if (playerdata.contactType == UNO_CONTACT_BTAG) then
BNSendWhisper(playerdata.presenceID,message);
end

end--end function UnoMessage


