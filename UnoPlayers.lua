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


--used by the server in the invitation phase
function AddUnoPlayer(boolree, nameX,pid,glitchyAccountName) 


if (boolree == "bnethashtag") then
taipu = UNO_CONTACT_BTAG;
end
if (boolree == "nameserver") then
taipu = UNO_CONTACT_WHISPER;
end

UnoPlayers[nameX] = {
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




end--end function AddUnoPlayer

function UnoMessage(playerdata,message)
print("contacttype is next...")
print(playerdata.contactType)
if (playerdata.contactType == UNO_CONTACT_WHISPER) then

SendChatMessage(message,"WHISPER",nil,playerdata.name);
end
if (playerdata.contactType == UNO_CONTACT_BTAG) then
BNSendWhisper(playerdata.presenceID,message);
end

end--end function UnoMessage


