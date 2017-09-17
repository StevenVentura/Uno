--[[
9/4/2017 Steven Ventura ("gangsthurh"), all rights reserved

documentation for player object:

player = {

userHasUnoOrNot=false,
userHasUnoOrNotTimer=0,
userJoinedTheLobby=false

}

]]


UnoPlayers = {};

function AddUnoPlayer(boolree, name) 
if (boolree == "bnethashtag") then
--TODO check for name instead of presenceID?
BNSendWhisper(name,UNO_IDENTIFIER .. " " .. UNO_MESSAGE_SEND_INVITATION);

end
if (boolree == "nameserver") then
SendChatMessage(UNO_IDENTIFIER .. " " .. UNO_MESSAGE_SEND_INVITATION,"WHISPER",nil,name);

end

UnoPlayers[name] = {
statusIcon="none",
whisperCategory=boolree,
userHasUnoOrNot=false,
userHasUnoOrNotTimer=0,
userJoinedTheLobby=false,
userDeclinedTheInvite=false

};


end--end function AddUnoPlayer


