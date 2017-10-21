--[[
Steven Ventura ("Gangsthurh")
9/16/17
UnoCard.lua
all rights reserved
]]


--[[
decks are:
playerID1
playerID2
playerID3
playerID4
maindeck (string)
updeck (string)

]]

--[[
DOCUMENTATION 
TOPIC:	sending card data over the socket:
function UnoAbstractMessageReceived(message, author, pid)
local sarray = UnoSplitString(message);

the UnoServer.lua has a function called UnoBroadcastUpdateDeck(). this 
	sends the update megastring for all card changes from the currently known deck on this client.


structure of the megastring:
needed information on client:
new owner? for a card. i think that is all.

in UnoStates.lua i defined UNO_MESSAGE_CARDUPDATE.

-=-=
1	  2						  3 4
<Uno> UNO_MESSAGE_CARDUPDATE 
-=-=

3 is the index (name?) of the card to be changed
4 is the new owner.

that should be good for now.


]]