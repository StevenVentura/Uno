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
UnoClientCards[cardIndex] = {
color=UNO_COLORS[colorIndex],
label=cardname,
owner="maindeck"
};
end--end for
end--end for
end--end for
----end copy
UnoDrawClient();

end--end function startTheUnoGame()


UnoMaindeckOffsetX = 

function UnoPositionCard(cardToPosition)
local width,height = UnoClientFrame:GetSize();


if (cardToPosition.owner == "maindeck") then
cardToPosition:SetPoint("CENTER",nil,"CENTER",width/8,0);
end--end maindeck

if (cardToPosition.owner == "updeck") then
cardToPosition:SetPoint("CENTER",nil,"CENTER",-width/8,0)
end --end updeck

local ownerCount = 0;
local playerOwned = cardToPosition ~= "updeck" and cardToPosition.owner ~= "maindeck";
for index,card in pairs(UnoClientCards) do
if (card.owner == cardToPosition.owner) then ownerCount = ownerCount + 1 end
end

if (playerOwned == true) then
local count = 0;
local px = UnoClientPlayers[card.owner].centerX;
local py = UnoClientPlayers[card.owner].centerY;
local theta = UnoClientPlayers[card.owner].theta;
for index,card in pairs(UnoClientCards) do
if (card.owner == cardToPosition.owner) then
cardToPosition:SetPoint()
count = count + 1;
end--end if his
end--end for
end--end if playerOwned

end--end function UnoPositionCard

function UnoDrawClient() 
print("|cffff0000calleing drawcleint")
UnoClientFrame:SetPoint("CENTER");
UnoClientFrame:SetSize(800*3/4,600*3/4);
UnoClientFrame.texture = UnoClientFrame:CreateTexture();
UnoClientFrame.texture:SetAllPoints();
UnoClientFrame.texture:SetColorTexture(43/255,15/255,1/255,0.80);

local numPlayers = tablelength(UnoClientPlayers);
local theta = 0;
for name,player in pairs(UnoClientPlayers) do
player.theta = theta;


local width,height = UnoClientFrame:GetSize();
player.centerX = width/2 + width/2 * math.cos(player.theta);
player.centerY = height/2 + height/2 * math.sin(player.theta);

--increment for the next player
theta = theta + 360/numPlayers;
end--end for

for index,card in pairs(UnoClientCards) do
card.frame = CreateFrame("FRAME",nil,UnoClientFrame);
card.frame:SetSize(width/8*0.7142857142857143,width/8);
UnoPositionCard(card);
card.frame.texture = card.frame:CreateTexture();
card.frame.texture:SetAllPoints();
card.frame.texture:SetTexture("Interface/AddOns/Uno/images/red8.tga");
card.frame:Show();
end





UnoClientFrame:Show();
end--end function UnoDrawClient