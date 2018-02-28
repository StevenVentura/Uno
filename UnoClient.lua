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
CreateFrame("Button","UnoClientFrameCloseButton",UnoClientFrame,"UIPanelButtonTemplate");
UnoClientFrameCloseButton:SetSize(24,24);
UnoClientFrameCloseButton:SetPoint("TOPRIGHT");
UnoClientFrameCloseButton:SetScript("OnClick",CloseOutOfUnoGame);
UnoClientFrameCloseButton:SetText("x");
UnoClientFrameCloseButton:Show();


UnoClientCards = {};
UnoClientPlayers = {};

UnoCurrentUpdeckCardIndex = -1;

function getClientUnoPlayerByOfficialIndex(index) 

for name,player in pairs(UnoClientPlayers) do
if (UnoClientPlayers[name].officialIndex == index) then
return UnoClientPlayers[name];
end--end if
end--end for
return nil;--didnt find anyone with that ID
end--end function getClientUnoPlayerByOfficialIndex

function SetUnoTurnClient(index) 
currentTurnNameClient = getClientUnoPlayerByOfficialIndex(index).name;
print("|cff0000ffit's " .. currentTurnNameClient .. "'s turn.");
--TODO: animation here and stuff
end--end function SetUnoTurnClient

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

CreateFrame("Button","UnoClientLobbyScreenCloseButton",UnoClientLobbyScreen,"UIPanelButtonTemplate"); 
UnoClientLobbyScreenCloseButton:SetSize(24,24);
UnoClientLobbyScreenCloseButton:SetPoint("TOPRIGHT");
UnoClientLobbyScreenCloseButton:SetScript("OnClick",CloseOutOfUnoGame);
UnoClientLobbyScreenCloseButton:SetText("x");
UnoClientLobbyScreenCloseButton:Show();



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
fName = UNO_COLORS[colorIndex] .. cardname;
else
fName = cardname;
end--end if
UnoClientCards[cardIndex] = {
color=UNO_COLORS[colorIndex],
label=tempName,
fileName=fName,
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

cardToPosition.frame.texture:SetTexture("Interface/AddOns/Uno/images/" .. cardToPosition.fileName .. ".tga");
if (cardToPosition.owner == "discard") then
cardToPosition.frame:Hide();
return
else
cardToPosition.frame:Show();
end

if (IsUnoCardFaceDown(cardToPosition)) then

cardToPosition.frame.texture:SetTexture("Interface/AddOns/Uno/images/uno_cardback.tga");
end

if (cardToPosition.owner == "maindeck") then
cardToPosition.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",UnoGetMaindeckOffset());
end--end maindeck

if (cardToPosition.owner == "updeck") then
cardToPosition.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",UnoGetUpdeckOffset())
end --end updeck

--get the count of how many cards he owns

local playerOwned = cardToPosition.owner ~= "updeck" and cardToPosition.owner ~= "maindeck"
						and cardToPosition.owner ~= "discard";

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
		UnoGetCardRadius() * math.sin(theta-math.pi/2) 
			+ firstXOffset*math.cos(theta-math.pi/2),
		UnoGetCardRadius() * math.cos(theta-math.pi/2)
			+ firstXOffset*math.sin(theta-math.pi/2) );
cardToPosition.frame.texture:SetRotation(theta-math.pi/2+math.pi);
--TODO actually rotate the card i forgot how

end--end if playerOwned

end--end function UnoPositionCard

function printUnoError(text) 
--TODO: method stub
print("|cffff0000<UnoError>:" .. text);

end--end function printUnoError

function UnoUpdatePositions()
for name,card in pairs(UnoClientCards) do 
UnoPositionCard(card)
card.frame:SetFrameStrata("MEDIUM");
if (IsMyUnoCard(card)) then
card.frame:SetMovable(true);
card.frame:EnableMouse(true);
card.frame:RegisterForDrag("LeftButton");
card.frame.cardplease = card;
card.frame:SetScript("OnDragStart",function(self)
local x, y = (self:GetLeft() + self:GetRight())/2, 
	(self:GetTop() + self:GetBottom()) / 2;


self.beforeDragX = x;
self.beforeDragY = y;

self:StartMoving();
self:SetFrameStrata("HIGH");
end);
card.frame.cardindex = card.index;
card.frame.cardlabel = card.label;
card.frame:SetScript("OnDragStop", function(self)
self:SetFrameStrata("MEDIUM");
self:StopMovingOrSizing();
local x, y = self:GetLeft(), self:GetTop();

self.draggedX = x;
self.draggedY = y;

isValidPlacement = UnoCheckIfValidCardPlacement(self.cardplease);

if (isValidPlacement == true) then
--change middle card?
if (self.cardlabel == "wild" or self.cardlabel == "wildplus4") then
--is a wild

--display the popup


--popup buttons: when you press it, it ends the turn with the extra information

--[[
format:
UnoMessageTheHost(UNO_IDENTIFIER .. " " .. UNO_CLIENT_CARDPLACED .. " " .. 
			self.cardindex
			--
			.. " " .. 
			colorChosen
			
			);
]]

else
--is not a wild
UnoMessageTheHost(UNO_IDENTIFIER .. " " .. UNO_CLIENT_CARDPLACED .. " " .. 
			self.cardindex);
--unregister for drag lol
self:EnableMouse(false);
end--end is not a wild



end--end isValidPlacement == true
if (isValidPlacement == false) then

self:ClearAllPoints();
self:SetPoint("CENTER",self.beforeDragX - (UnoClientFrame:GetLeft()
	+ (UnoClientFrame:GetRight() - UnoClientFrame:GetLeft())/2),
	self.beforeDragY
	- (UnoClientFrame:GetTop() + UnoClientFrame:GetBottom())/2);

end--end isValidPlacement == false

end);--end anonymous function
end--end IsMyUnoCard
end--end for

end--end function UnoUpdatePositions

--TODO: LEFT OFF HERE BTW
function UnoCardIntersection(card1, card2) 

return 
	not(card1.frame.getLeft() > card2.frame.getRight()
	or
	card2.frame.getLeft() > card1.frame.getRight()
	or
	card1.frame.getTop() < card2.frame.getBottom()
	or
	card2.frame.getTop() < UnoCurrentScreen.frame.getBottom())


end--end function UnoCardIntersection


--TODO: allow the user to sort his cards.
function UnoCheckIfValidCardPlacement(draggingCard)

if (UnoGetMe().name ~= currentTurnNameClient) then printUnoError("it is " .. currentTurnNameClient .. "'s turn.") return false end

isOnTop = true;
if (UnoClientCards[UnoCurrentUpdeckCardIndex].frame:GetLeft() > draggingCard.frame:GetRight()
	or
	draggingCard.frame:GetLeft() > UnoClientCards[UnoCurrentUpdeckCardIndex].frame:GetRight()
	or
	UnoClientCards[UnoCurrentUpdeckCardIndex].frame:GetTop() < draggingCard.frame:GetBottom()
	or
	draggingCard.frame:GetTop() < UnoClientCards[UnoCurrentUpdeckCardIndex].frame:GetBottom()
	) then
	isOnTop = false;
	end
--check for intersection with updeck card
if (isOnTop == true)
	then
	print("ayyyyyy its on top");
	if (draggingCard.label == "plus2"
		or draggingCard.label == "skip"
		or draggingCard.label == "reverse"
		or draggingCard.label == "wild"
		or draggingCard.label == "wildplus4")
	then
		return true;
	end--end if special card
	--else check if the suit is right and stuff
	print("|cffffff00updeckcolor=" .. UnoClientCards[UnoCurrentUpdeckCardIndex].color
		.. " & drag=" .. draggingCard.color );
		print("|cffffaa00updecklabel=" .. UnoClientCards[UnoCurrentUpdeckCardIndex].label
		.. " & drag=" .. draggingCard.label );
	if (UnoClientCards[UnoCurrentUpdeckCardIndex].color == draggingCard.color 
		or UnoClientCards[UnoCurrentUpdeckCardIndex].label == draggingCard.label )
		then
		return true;
		end--end if
end--end if

return false
end--end function UnoCheckIfValidCardPlacement

function UnoDrawClient() 

UnoClientFrame:SetPoint("CENTER");
UnoClientFrame:SetSize(800*3/4,600*3/4);
UnoClientFrame.texture = UnoClientFrame:CreateTexture();
UnoClientFrame.texture:SetAllPoints();
UnoClientFrame.texture:SetColorTexture(43/255,15/255,1/255,0.80);

local numPlayers = tablelength(UnoClientPlayers);
local theta = math.pi/2;
local width,height = UnoClientFrame:GetSize();
for name,player in pairs(UnoClientPlayers) do
player.theta = theta;
--relative to the middle of the board
------local px = UnoClientPlayers[cardToPosition.owner].centerX;
player.centerX = width/5 * math.cos(player.theta);
player.centerY = height/5 * math.sin(player.theta);
--position the text label for the player
player.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",player.centerX,player.centerY);


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
if (card.owner == "updeck") then return false end
return card.owner == "maindeck" or (not(card.owner == "updeck") and not(IsMyUnoCard(card)));
end--end function
