--[[

started writing this file on 9/16/17
]]

CreateFrame("Frame","UnoClientFrame",UIParent);


UnoClientCards = {};
UnoClientPlayers = {};

UnoUpdeckCard = {};

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

--startTheUnoGame is a client-side function
function startTheUnoGame()
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
owner="maindeck"
};
end--end for
end--end for
end--end for
----end copy
UnoDrawClient();

end--end function startTheUnoGame()

--placeholder variables. TODO: absolute , relative, and scaled values: which domain am i in?
function GetUnoCardWidth()
return 50;
end--end
function GetUnoCardHeight()
return 50;
end--end
function GetUnoCardGap()
return 100;
end--end

function UnoGetMaindeckOffset()
return -GetUnoCardWidth, 0;
end
function UnoGetUpdeckOffset()
return GetUnoCardWidth, 0;
end

function UnoGetHandClient(name)
local out = {};
for index,card in pairs(UnoClientCards) do
if (card.owner == name) then out[index] = card end
end--end for
return out;
end--end function UnoGetHand

function UnoGetCardRadius()
return 100;
end--end function

function UnoPositionCard(cardToPosition)
local width,height = UnoClientFrame:GetSize();

if (cardToPosition.owner == "maindeck") then
cardToPosition.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",width/8,0);
end--end maindeck

if (cardToPosition.owner == "updeck") then
cardToPosition.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",-width/8,0)
end --end updeck

--get the count of how many cards he owns

local playerOwned = cardToPosition.owner ~= "updeck" and cardToPosition.owner ~= "maindeck";

if (playerOwned == true) then
local playerHand = UnoGetHandClient(cardToPosition.owner);
local player = UnoClientPlayers[cardToPosition.owner];
local handCount = tablelength(playerHand);
print("handcount is " .. handCount)
local currentCount = 0;--lay the hand out across the table

local px = UnoClientPlayers[cardToPosition.owner].centerX;

local py = UnoClientPlayers[cardToPosition.owner].centerY;
local theta = UnoClientPlayers[cardToPosition.owner].theta;
local firstXOffset,firstYOffset;
for index,card in pairs(UnoClientCards) do
if (card.owner == cardToPosition.owner) then
currentCount = currentCount + 1;
if (handCount%2 == 0) then
local distFromMiddle = currentCount - handCount/2;
firstXOffset = -(GetUnoCardWidth()/2+GetUnoCardGap()) 
			+ (GetUnoCardWidth()+GetUnoCardGap())*distFromMiddle;
firstYOffset = 0;
else--end even, else odd
--distance from the middle value
local distFromMiddle = currentCount - ceil(handCount/2);
firstXOffset = distFromMiddle * (GetUnoCardWidth() + GetUnoCardGap());
firstYOffset = 0;
end--end odd
end--end if his
end--end for
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
card.frame.texture:SetTexture("Interface/AddOns/Uno/images/" .. card.label .. ".tga");

card.frame:Show();
end





UnoClientFrame:Show();
end--end function UnoDrawClient