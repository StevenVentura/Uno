--[[

started writing this file on 9/16/17
]]
UnoServerObject = {


};

UnoServerCards = {

};



--when the host presses the "Start game" button, StartTheUnoGameWithThesePlayers()  is called
function StartTheUnoGameWithThesePlayers() 

UnoServerPlayers = {

};

for name, player in pairs(UnoPlayers) do
if (player.userJoinedTheLobby == true) then
UnoServerPlayers[name] = player;--this is a deep copy (there are no references back)
end--end if
end--end for

--add self to it
--UnoServerPlayers["serverPlayer"] = "serverPlayer";


--let them know we are starting
--TODO: send the game information here? like, all the other player's names.
for name, player in pairs(UnoServerPlayers) do
SendChatMessage(UNO_IDENTIFIER .. " " .. UNO_STARTING,"WHISPER",nil,name);
end
--send it to myself
SendChatMessage(UNO_IDENTIFIER .. " " .. UNO_STARTING,"WHISPER",nil,UnitName("player"));
UnoCreateAndDealCards();

startTheUnoGame();--for my client
end--end function

function TakeRandomUnoCardFromDeck(deck)


end--end function TakeRandomUnoCardFromDeck

UNO_COLORS = {"red","green","yellow","blue"};
UNO_VALUES = {"0","1","2","3","4","5","6","7","8","9",
			"drawTwo","skip","reverse",
			"wild","wildDraw4"};
UNO_DEFAULT_DECK_AMOUNTS_PER_COLOR = {
			   ["0"]=1,["1"]=2,["2"]=2,["3"]=2,["4"]=2,["5"]=2,["6"]=2,["7"]=2,["8"]=2,["9"]=2,
			   ["drawTwo"]=2,["skip"]=2,["reverse"]=2,["wild"]=4,["wildDraw4"]=4
						};
function UnoCreateAndDealCards()

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


--now clear the event stack
for x,_ in pairs(UnoServerCardsChanged) do
UnoServerCardsChanged[x] = nil;
end--end for

end--end function UnoBroadcastUpdateDeck

UnoServerCardsChanged = {};

function ServerDealUnoCardToPlayer(dealToMe)


index = random(1,128);
outOfCards = false;atLeastOne = false;
while(UnoServerCards[index].owner ~= "maindeck" and atLeastOne == false) do
index = random(1,128);
atLeastOne = false;
for i=1,128 do 
if (UnoServerCards[i].owner == "maindeck") then
atLeastOne = true;
print("RAN OUT OF CARDS");
end--end if
end--end for
end--end while

UnoServerCards[index].owner = dealToMe;

--populate the event stack
UnoServerCardsChanged[index] = owner;

end--end function GetIndexUnoCardFromDeck