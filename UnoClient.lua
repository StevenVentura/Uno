--[[

started writing this file on 9/16/17
]]

--[[
the client is only aware of the name of all of the other players.
just their name.

but he has full contact to the host so he can send messages to the host.
these messages can either happen in battle.net or they can happen in whisper.




]]

CreateFrame("Frame","UnoClientFrame",UIParent);


UnoClientCards = {};
UnoClientPlayers = {};

UnoUpdeckCard = {};

function UnoMessageTheHost(message)
if (UnoHostContact == nil) then --then this means i am the host
UnoHostContact = {
contactType = UNO_CONTACT_WHISPER,
whisperName = UnitName("player")
};
end
if (UnoHostContact.contactType == UNO_CONTACT_BTAG) then
BNSendWhisper(UnoHostContact.pid,message);
else
SendChatMessage(message,"WHISPER",nil,UnoHostContact.whisperName);
end

end--end function UnoMessageTheHost

function UnoClientDisplayLobbyGuestScreen()
CreateFrame("FRAME","UnoClientLobbyScreen",UIParent);
UnoClientLobbyScreen:SetSize(150,40);
UnoClientLobbyScreen:SetPoint("CENTER");
UnoClientLobbyScreen.t = UnoClientLobbyScreen:CreateTexture();
UnoClientLobbyScreen.t:SetAllPoints();
UnoClientLobbyScreen.t:SetColorTexture(43/255,15/255,1/255,0.80);
UnoClientLobbyScreen.title = UnoClientLobbyScreen:CreateFontString(nil,UnoClientLobbyScreen,"GameFontNormal");
UnoClientLobbyScreen.title:SetTextColor(1,1,0,1);
 UnoClientLobbyScreen.title:SetShadowColor(0,0,0,1);
 UnoClientLobbyScreen.title:SetShadowOffset(2,-1);
 UnoClientLobbyScreen.title:SetPoint("TOPLEFT",10,-10);
 UnoClientLobbyScreen.title:SetText("UNO: Waiting for host...");
 UnoClientLobbyScreen.title:Show();





end--end functin UnoClientDisplayLobbyGuestScreen
UnoClientTheHostsIdentification = "nobodyyet"
--startTheUnoGame is a client-side function
function startTheUnoGame()
UnoCurrentScreen = UNO_SCREEN_PLAYINGGAME
UnoScreenLobby:Hide();
----copied from UnoServer.lua (UnoCreateAndDealCards) changed UnoServerCards to UnoClientCards
--create cards : Give them a default value, instantiate them in our array so they can be updated by index.
cardIndex = 0;
for colorIndex = 1, tablelength(UNO_COLORS) do
for cardname,amount in pairs(UNO_DEFAULT_DECK_AMOUNTS_PER_COLOR) do
for i=1,amount do
cardIndex = cardIndex + 1;--should go up to 108
local tempName = cardname;
if (cardname ~= "wild" and cardname ~= "wildplus4") then
tempName = UNO_COLORS[colorIndex] .. cardname;
end--end if
UnoClientCards[cardIndex] = {
color=UNO_COLORS[colorIndex],
label=tempName,
owner="maindeck",
index=cardIndex
};
end--end for
end--end for
end--end for
----end copy
UnoDrawClient();

end--end function startTheUnoGame()

--placeholder variables. TODO: absolute , relative, and scaled values: which domain am i in?
function GetUnoCardWidth()
local width,height = UnoClientFrame:GetSize();
return width/8*0.7142857142857143;
end--end
function GetUnoCardHeight()
local width,height = UnoClientFrame:GetSize();
return width/8;
end--end
function GetUnoCardGap()
local width,height = UnoClientFrame:GetSize();
return GetUnoCardHeight()/3;
end--end

function UnoGetMaindeckOffset()
return -GetUnoCardWidth(), 0;
end
function UnoGetUpdeckOffset()
return GetUnoCardWidth(), 0;
end

function UnoGetHandClient(name)
local out = {};
for index,card in pairs(UnoClientCards) do
if (card.owner == name) then out[index] = card end
end--end for
return out;
end--end function UnoGetHand

function UnoGetCardRadius()
local width,height = UnoClientFrame:GetSize();
return GetUnoCardHeight()*2;
end--end function

function UnoPositionCard(cardToPosition)
local width,height = UnoClientFrame:GetSize();

cardToPosition.frame.texture:SetTexture("Interface/AddOns/Uno/images/" .. cardToPosition.label .. ".tga");
cardToPosition.frame:Show();
if (IsUnoCardFaceDown(cardToPosition)) then
cardToPosition.frame.texture:SetTexture("Interface/AddOns/Uno/images/uno_cardback.tga");
end

if (cardToPosition.owner == "maindeck") then
cardToPosition.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",UnoGetMaindeckOffset());
end--end maindeck

if (cardToPosition.owner == "updeck") then
--TODO: only show the topmost card on updeck., or at least show it on the highest so they can peak what was under it.
cardToPosition.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",UnoGetUpdeckOffset())
end --end updeck

--get the count of how many cards he owns

local playerOwned = cardToPosition.owner ~= "updeck" and cardToPosition.owner ~= "maindeck";

if (playerOwned == true) then
local playerHand = UnoGetHandClient(cardToPosition.owner);
local player = UnoClientPlayers[cardToPosition.owner];
local handCount = tablelength(playerHand);
local currentCount = 0;--lay the hand out across the table
local thisCardsCount = 0;

local px = UnoClientPlayers[cardToPosition.owner].centerX;

local py = UnoClientPlayers[cardToPosition.owner].centerY;
local theta = UnoClientPlayers[cardToPosition.owner].theta;
local firstXOffset,firstYOffset;
for index,card in pairs(UnoClientCards) do
if (card.owner == cardToPosition.owner) then
currentCount = currentCount + 1;
if (index == cardToPosition.index) then thisCardsCount = currentCount; end
end--end if his hand
end--end for
if (handCount%2 == 0) then
local distFromMiddle = thisCardsCount - handCount/2;
firstXOffset = -(GetUnoCardWidth()/2+GetUnoCardGap()) 
			+ (GetUnoCardWidth()+GetUnoCardGap())*distFromMiddle;
firstYOffset = 0;
else--end even, else odd
--distance from the middle value
local distFromMiddle = thisCardsCount - ceil(handCount/2);
firstXOffset = distFromMiddle * (GetUnoCardWidth() + GetUnoCardGap());
firstYOffset = 0;
end--end odd
--calculated firstX and firstY , now need to rotate and give parent and stuff
cardToPosition.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",
		UnoGetCardRadius() * math.sin(theta) 
			+ firstXOffset*math.cos(theta),
		UnoGetCardRadius() * math.cos(theta)
			+ firstXOffset*math.sin(theta) );
--TODO actually rotate the card i forgot how

end--end if playerOwned

end--end function UnoPositionCard

function UnoUpdatePositions()
for name,card in pairs(UnoClientCards) do 
UnoPositionCard(card)
end--end for
end--end function UnoUpdatePositions
function UnoDrawClient() 
print("|cffff0000calleing drawcleint")
UnoClientFrame:SetPoint("CENTER");
UnoClientFrame:SetSize(800*3/4,600*3/4);
UnoClientFrame.texture = UnoClientFrame:CreateTexture();
UnoClientFrame.texture:SetAllPoints();
UnoClientFrame.texture:SetColorTexture(43/255,15/255,1/255,0.80);

local numPlayers = tablelength(UnoClientPlayers);
local theta = 0;
local width,height = UnoClientFrame:GetSize();
for name,player in pairs(UnoClientPlayers) do
player.theta = theta;
--relative to the middle of the board
------local px = UnoClientPlayers[cardToPosition.owner].centerX;
player.centerX = width/4 * math.cos(player.theta);
player.centerY = height/4 * math.sin(player.theta);
--increment for the next player
theta = theta + 360*math.pi/180/numPlayers;
end--end for





for index,card in pairs(UnoClientCards) do
card.frame = CreateFrame("FRAME",nil,UnoClientFrame);
card.frame:SetSize(width/8*0.7142857142857143,width/8);
--UnoPositionCard(card);
card.frame.texture = card.frame:CreateTexture();
card.frame.texture:SetAllPoints();
card.frame:Hide();
end





UnoClientFrame:Show();
end--end function UnoDrawClient
function UnoIAmTheHost()
return UnoHostContact.whisperName and UnoHostContact.whisperName == UnitName("player");
end--end function UnoIAmTheHost

function UnoGetMe()
if (UnoIAmTheHost()) then
return UnoClientPlayers["HOST"];
else
return UnoGetPlayerByIndexClient(UnoClientMyOfficialIndex);
end
end--end function UnoGetMe

function UnoGetPlayerByIndexClient(index)
for name,player in pairs(UnoClientPlayers) do
if (player.officialIndex == index) then return player end
end
end--end function UnoGetPlayerByIndexClient

function IsMyUnoCard(card)
return card.owner == UnoGetMe().name;
end--end function IsMyUnoCard

function IsUnoCardFaceDown(card)
return card.owner == "maindeck" or not(IsMyUnoCard(card));
end--end function
