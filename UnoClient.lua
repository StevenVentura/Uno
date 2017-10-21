--[[

started writing this file on 9/16/17
]]

CreateFrame("Frame","UnoClientFrame",UIParent);

UnoLooseData = {
["numberOfPlayersInMatch"] = 2};

UnoClientCards = {};
UnoClientPlayers = {};

UnoUpdeckCard = {};



function UnoDrawClient() 
----copied from UnoServer.lua (UnoCreateAndDealCards) changed UnoServerCards to UnoClientCards
--create cards : Give them a default value, instantiate them in our array so they can be updated by index.
cardIndex = 0;
for colorIndex = 1, tablelength(UNO_COLORS) do
for cardname,amount in pairs(UNO_DEFAULT_DECK_AMOUNTS_PER_COLOR) do
for i=1,amount do
cardIndex = cardIndex + 1;--should go up to 108
UnoClientCards[cardIndex] = {
color=UNO_COLORS[colorIndex],
label=cardname,
owner="maindeck"
}
end--end for
end--end for
end--end for
----end copy

UnoClientFrame:Show();
end--end function UnoDrawClient