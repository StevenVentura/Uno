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


player.frame = CreateFrame("FRAME",nil,UnoClientFrame);
local width,height = UnoClientFrame:GetSize();
player.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",
						width/2/2 * math.cos(theta),
						height/2/2 * math.sin(theta));	
--for the next player
theta = theta + 360/numPlayers;
end--end for

for index,card in pairs(UnoClientCards) do
card.frame = CreateFrame("FRAME",nil,UnoClientFrame);
card.frame:SetSize(40*0.7142857142857143,40);
card.frame:SetPoint("CENTER")
card.frame.texture = card.frame:CreateTexture();
card.frame.texture:SetAllPoints();
card.frame.texture:SetTexture("Interface/AddOns/Uno/images/red8.tga");
card.frame:Show();
end


UnoClientFrame:Show();
end--end function UnoDrawClient