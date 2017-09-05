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


end
if (boolree == "nameserver") then


end
UnoPlayers[name] = {

userHasUnoOrNot=false,
userHasUnoOrNotTimer=0,
userJoinedTheLobby=false

};


end--end function AddUnoPlayer


