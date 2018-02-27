--[[

started writing this file on 9/16/17

10/27/17
what is the name of the server to the other players?
if they added him through battletag, do they see his battletag, or do they see his char name?
how about i just make every single player known by their char name??
and then i give them a contact method?

]]
UnoServerObject = {


};

UnoServerCards = {

};

UNO_ROTATION_FORWARDS = 1; UNO_ROTATION_BACKWARDS = -1;
UnoServerCurrentRotationDirection = UNO_ROTATION_FORWARDS;



--when the host presses the "Start game" button, StartTheUnoGameWithThesePlayers()  is called
function StartTheUnoGameWithThesePlayers() 
UnoServerPlayers = { };
--i am the host
UnoHostContact = {
contactType = UNO_CONTACT_WHISPER,
whisperName = UnitName("player")
}


for name, player in pairs(UnoPlayers) do
if (player.userJoinedTheLobby == true) then
UnoServerPlayers[name] = player;--this is a deep copy (there are no references back)
end--end if
end--end for

--add self to it
--UnoServerPlayers["serverPlayer"] = "serverPlayer";


--let them know we are starting
--DONETODO: send the game information here? like, all the other player's names.

--make players aware of each other
local unoPlayerNameList = "";
UnoServerPlayers["HOST"] = {name=UnitName("player"),officialIndex=nil,contactType=UNO_CONTACT_WHISPER};
local officialIndex = 1;--start the counting at 1.
--unoPlayerNameList = unoPlayerNameList .. " " .. UnitName("player");-- .. "-" .. GetRealmName("player");
for name, player in pairs(UnoServerPlayers) do
unoPlayerNameList = unoPlayerNameList .. " " .. name .. "=" .. officialIndex;
UnoServerPlayers[name].officialIndex = officialIndex;
officialIndex = officialIndex + 1;
end--end for

--broadcast message to all players
for name, player in pairs(UnoServerPlayers) do--       vnote theres no space
UnoMessage(UnoServerPlayers[name],UNO_IDENTIFIER .. " " .. UNO_STARTING 
			.. " " .. UnoServerPlayers[name].officialIndex .. unoPlayerNameList);
end--end for
--send it to myself; 10/28/17 actually sending to myself is done via the HOST keyword index, inside UnoMessage
--SendChatMessage(UNO_IDENTIFIER .. " " .. UNO_STARTING .. unoPlayerNameList,"WHISPER",nil,UnitName("player"));

UnoCreateAndDealCards();

end--end function

function TakeRandomUnoCardFromDeck(deck)


end--end function TakeRandomUnoCardFromDeck

UNO_COLORS = {"red","green","yellow","blue"};
UNO_VALUES = {"0","1","2","3","4","5","6","7","8","9",
			"plus2","skip","reverse",
			"wild","wildplus4"};
UNO_DEFAULT_DECK_AMOUNTS_PER_COLOR = {
			   ["0"]=1,["1"]=2,["2"]=2,["3"]=2,["4"]=2,["5"]=2,["6"]=2,["7"]=2,["8"]=2,["9"]=2,
			   ["plus2"]=2,["skip"]=2,["reverse"]=2,["wild"]=4,["wildplus4"]=4
						};
function getServerUnoPlayerByOfficialIndex(index) 

for name,player in pairs(UnoServerPlayers) do
if (UnoServerPlayers[name].officialIndex == index) then
return UnoServerPlayers[name];
end--end if
end--end for
return nil;--didnt find anyone with that ID
end--end function getServerUnoPlayerByOfficialIndex



function getUnoServerPlayer(name) 
if (name == UnitName("player")) then
return UnoServerPlayers["HOST"];
else
return UnoServerPlayers[name];
end


end--end function getUnoServerPlayer

function getUnoServerPlayerIDArray()
local out = {};

for name,player in pairs(UnoServerPlayers) do
local index = player.officialIndex;
out[index] = index;
end

return out;
end--end function getUnoServerPlayerIDArray

function getHighestIndexFromArray(array) 
local highest = -1;
for a,b in pairs(array) do
if (a > highest) then highest = a end
end
return highest;
end--end function getHighestValueFromArray

function UnoServerGetNextEntry(array,beforeValue,direction)
if (direction == UNO_ROTATION_FORWARDS) then
local flaggy = false;
for a,b in pairs(array) do
print("a is " .. a);
print("beforevalue is " .. beforeValue)
if (flaggy == true) then 
print("returning " .. a);
return a;
end--end if flaggy==true
--nextloopflaggy
if (a == beforeValue) then flaggy = true end
end
--if it gets out with flaggy being true then it means its the first value
for a,b in pairs(array) do
--return the first value
return a;
end--end for
end--end if direction is forwards
if (direction == UNO_ROTATION_BACKWARDS) then
local flaggy2 = false;
--NOTE: this might not work if there's missing player indices
for n = #array, 1, -1 do
if (flaggy2 == true) then return n end
if (array[n] == beforeValue) then flaggy2 = true end
end--end for
--if it gets out with flaggy being true then it means its the last value
for n = #array, 1, -1 do
--return the last value of the array
return n
end--end for
end--end if backwards
end--end function getNextEntry

function UnoServerDetermineNextTurn() 
if (UnoServerCards[UnoServerCurrentUpdeckCardIndex].label == "reverse") then 
print("|cffff0000" .. "did it reverse before or after the card was placed?");
if (UnoServerCurrentRotationDirection == UNO_ROTATION_FORWARDS) then
UnoServerCurrentRotationDirection = UNO_ROTATION_BACKWARDS;
else
UnoServerCurrentRotationDirection = UNO_ROTATION_FORWARDS;
end--end else

end--end if reverse

local currentTurnboy = getUnoServerPlayer(currentTurnNameServer); 
local nextboy = -1;
local arrayIndices = getUnoServerPlayerIDArray();

if (UnoServerCards[UnoServerCurrentUpdeckCardIndex].label == "reverse") then
--SPECIAL RULE: if there are 2 players, then reverse acts like a skip, and he keeps turn.
if (#arrayIndices == 2) then return getUnoServerPlayer(currentTurnNameServer).officialIndex end
end--end reverse special case part 2

nextboy = UnoServerGetNextEntry(arrayIndices,currentTurnboy.officialIndex,
		UnoServerCurrentRotationDirection);
		
if (UnoServerCards[UnoServerCurrentUpdeckCardIndex].label == "skip") then
print("|cffff0000" .. "did it skip before or after the card was placed?");
nextboy = UnoServerGetNextEntry(arrayIndices,nextboy,
		UnoServerCurrentRotationDirection);
end


print("|cff0000ffnextboy is " .. nextboy);
currentTurnNameServer = getServerUnoPlayerByOfficialIndex(nextboy).name;
end--end function UnoServerDetermineNextTurn
--note: you have to set the turn variable currentTurnNameServer before calling this
function UnoBroadcastTurnUpdate() 
--broadcast turn update
for name, player in pairs(UnoServerPlayers) do
UnoMessage(getUnoServerPlayer(name),UNO_IDENTIFIER .. " " .. UNO_MESSAGE_TURNUPDATE
			.. " " .. getUnoServerPlayer(currentTurnNameServer).officialIndex);
end--end for

end--end function UnoBroadcastTurnUpdate
currentTurnNameServer = nil;
function UnoCreateAndDealCards()
--also set the current turn
currentTurnNameServer = getServerUnoPlayerByOfficialIndex(1).name;

UnoBroadcastTurnUpdate();


--[[
There are 108 cards in a Uno deck. 
There are four suits, Red, Green, Yellow
 and Blue, each consisting of one 0 card,
 two 1 cards, two 2s, 3s, 4s, 5s, 6s, 7s,
 8s and 9s; two Draw Two cards; two Skip 
 cards; and two Reverse cards. In addition
 there are four Wild cards and four Wild Draw Four cards.]]

 --amount = UnoServerCards["green"]."0"
--create cards
cardIndex = 0;
for colorIndex = 1, tablelength(UNO_COLORS) do
for cardname,amount in pairs(UNO_DEFAULT_DECK_AMOUNTS_PER_COLOR) do
for i=1,amount do
cardIndex = cardIndex + 1;--should go up to 108
UnoServerCards[cardIndex] = {
color=UNO_COLORS[colorIndex],
label=cardname,
owner="maindeck"
}
end--end for
end--end for
end--end for

--deal cards
for name, player in pairs(UnoServerPlayers) do
for i = 1, 5 do
--give random cards to each player
ServerDealUnoCardToPlayer(name);
end--end for
end--end for

--put random card face up
ServerDealUnoCardToPlayer("updeck");

UnoBroadcastUpdateDeck();

end--end function UnoCreateAndDealCards


UnoServerCardsChanged = {};

function UnoBroadcastMessage(message) 
for name, player in pairs(UnoServerPlayers) do
UnoMessage(player, message);
end
end--end function UnoBroadcastMessage

--[[
documentation for UnoBroadcastUpdateDeck is in UnoCard.lua
]]
function UnoBroadcastUpdateDeck()
--using the UnoServerCardsChanged event stack, create cardsMessage
local cardsMessage = UNO_IDENTIFIER .. " " .. UNO_MESSAGE_CARDUPDATE;
for masterIndex, newOwner in pairs(UnoServerCardsChanged) do
cardsMessage = cardsMessage .. " " .. masterIndex .. " " .. newOwner;
end--end for

--now broadcast message to all players
for name, player in pairs(UnoServerPlayers) do
UnoMessage(player, cardsMessage);
end
--and to myself too
SendChatMessage(cardsMessage, "WHISPER",nil,UnitName("player"));

--find which card was the updeck card

--broadcast it as UPDECK_UPDATE




--now clear the event stack
for x,_ in pairs(UnoServerCardsChanged) do
UnoServerCardsChanged[x] = nil;
end--end for

end--end function UnoBroadcastUpdateDeck



function ServerDealUnoCardToPlayer(dealToMe)


index = random(1,128);
outOfCards = false;atLeastOne = true;
while(UnoServerCards[index].owner ~= "maindeck" and atLeastOne == true) do
index = random(1,128);
atLeastOne = false;
for i=1,128 do 
if (UnoServerCards[i].owner == "maindeck") then
atLeastOne = true;
end--end if
end--end for
end--end while

UnoServerCards[index].owner = dealToMe;

--populate the event stack

UnoServerCardsChanged[index] = dealToMe;



end--end function GetIndexUnoCardFromDeck