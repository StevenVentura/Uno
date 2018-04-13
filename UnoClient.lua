--[[

started writing this file on 9/16/17
]]

--[[
the client is only aware of the name of all of the other players.
just their name.

but he has full contact to the host so he can send messages to the host.
these messages can either happen in battle.net or they can happen in whisper.




]]

CreateFrame("Frame","UnoClientFrameDragFrame",UIParent);
CreateFrame("Frame","UnoClientFrame",UnoClientFrameDragFrame);
CreateFrame("Button","UnoClientFrameCloseButton",UnoClientFrame,"UIPanelButtonTemplate");
UnoClientFrameCloseButton:SetSize(24,24);
UnoClientFrameCloseButton:SetPoint("TOPLEFT");
UnoClientFrameCloseButton:SetScript("OnClick",CloseOutOfUnoGame);
UnoClientFrameCloseButton:SetText("x");
UnoClientFrameCloseButton:Show();
--Uno = UnoClientFrame:CreateFontString("UnoScrollFrameTitle",UnoScreenLobby,"GameFontNormal");
CreateFrame("Frame","UnoClientUpdeckLabelFrame",UnoClientFrame);
UnoClientUpdeckLabelFrame.label = 
	UnoClientUpdeckLabelFrame:CreateFontString(nil,UnoClientUpdeckLabelFrame,"GameFontNormal");
UnoClientUpdeckLabelFrame.label:SetTextColor(1,0.643,0.169,1);
 UnoClientUpdeckLabelFrame.label:SetShadowColor(0,0,0,1);
 UnoClientUpdeckLabelFrame.label:SetShadowOffset(2,-1);
 UnoClientUpdeckLabelFrame.label:SetText("");


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

function RotateUnoClient() 

--increment the rotation value
UnoRotateUnoClientButton.rotationValue = UnoRotateUnoClientButton.rotationValue + 1;

--refresh the stuff
local numPlayers = tablelength(UnoClientPlayers);
local theta = math.pi/2;
local width,height = UnoClientFrame:GetSize();
local centerXArray= {[1]=0,[2]=0,[3]=width/5,[4]=-width/5};
local centerYArray= {[1]=width/5,[2]=-width/5,[3]=0,[4]=0};
local thetaArray = {[1]=0,[2]=math.pi,[3]=math.pi/2,[4]=3*math.pi/2};

for name,player in pairs(UnoClientPlayers) do
local offiIndex = (player.officialIndex + UnoRotateUnoClientButton.rotationValue) % 5;
if (offiIndex == 0) then
UnoRotateUnoClientButton.rotationValue = UnoRotateUnoClientButton.rotationValue + 1;
offiIndex = (player.officialIndex + UnoRotateUnoClientButton.rotationValue) % 5;
end
if (offiIndex == 3 or offiIndex == 4) then
player.vertical = true;
else
player.vertical = false;
end
player.theta = thetaArray[offiIndex];
--relative to the middle of the board
------local px = UnoClientPlayers[cardToPosition.owner].centerX;
player.centerX = centerXArray[offiIndex];
player.centerY = centerYArray[offiIndex];
--position the text label for the player
player.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",player.centerX,player.centerY);
player.title:SetPoint("CENTER",
	player.frame,"CENTER",0,0);
end--end for



end--end function RotateUnoClient


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
return GetUnoCardHeight()/16;
end--end

function UnoGetMaindeckOffset()
return -GetUnoCardWidth(), 0;
end
function UnoGetUpdeckOffset()
return GetUnoCardWidth(), 0;
end

function UnoGetNumberedHandClient(name)
local out = {};
count = 0;
for index,card in pairs(UnoClientCards) do
if (card.owner == name) then out[count] = card 
							 count = count + 1; 
						end
end--end for
return out;
end--end function UnoGetHandClient

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
cardToPosition.frame:SetSize(width/8*0.7142857142857143,width/8);
cardToPosition.frame.texture:SetRotation(0);
end --end updeck

--get the count of how many cards he owns

local playerOwned = cardToPosition.owner ~= "updeck" and cardToPosition.owner ~= "maindeck"
						and cardToPosition.owner ~= "discard";

if (playerOwned == true) then



local playerHand = UnoGetNumberedHandClient(cardToPosition.owner);
local player = UnoClientPlayers[cardToPosition.owner];
local handCount = tablelength(playerHand);
local currentCount = 0;--lay the hand out across the table
local px = UnoClientPlayers[cardToPosition.owner].centerX;
local py = UnoClientPlayers[cardToPosition.owner].centerY;
local theta = UnoClientPlayers[cardToPosition.owner].theta;
local thisCardsCount = UnoClientGetHandCountNumber(cardToPosition);

if (UnoCardDisplayModeButton.displayMode == "Expand") then
local cardSizeScaleFactor = 1;
if (handCount <= 5) then
cardSizeScaleFactor = 1;
else
cardSizeScaleFactor = 5 / handCount;
end
if (UnoClientPlayers[cardToPosition.owner].vertical == false) then
cardToPosition.frame:SetSize(cardSizeScaleFactor*width/8*0.7142857142857143,cardSizeScaleFactor*width/8);
else
cardToPosition.frame:SetSize(cardSizeScaleFactor*width/8,cardSizeScaleFactor*width/8*0.7142857142857143);
end




if (handCount%2 == 0) then
local distFromMiddle = thisCardsCount - handCount/2 + 1;
firstXOffset = -(GetUnoCardWidth()/2+GetUnoCardGap())*cardSizeScaleFactor 
			+ (GetUnoCardWidth()+GetUnoCardGap())*distFromMiddle*cardSizeScaleFactor;
firstYOffset = 0;
else--end even, else odd
--distance from the middle value
local distFromMiddle = thisCardsCount - ceil(handCount/2) + 1;
firstXOffset = distFromMiddle * (GetUnoCardWidth() + GetUnoCardGap()) * cardSizeScaleFactor;
firstYOffset = 0;
end--end odd

cardToPosition.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",
		UnoGetCardRadius() * math.sin(theta-0) 
			+ firstXOffset*math.cos(theta-0),
		UnoGetCardRadius() * math.cos(theta-0)
			+ firstXOffset*math.sin(theta-0) );
			
cardToPosition.frame.texture:SetRotation(theta-0+math.pi);
end--end if displaymode == "Expand"
if (UnoCardDisplayModeButton.displayMode == "Compact") then





end



end--end if playerOwned

end--end function UnoPositionCard


UnoClientErrorDuration = 12.0;


--dummy fontstring btw; starting point for reference
UnoClientFrame:CreateFontString("UnoClientErrorFrame0","DIALOG","GameFontNormal");
UnoClientErrorFrame0:SetPoint("CENTER",UnoClientFrame,"CENTER",0,120);

for unoIndexvar=1,3 do
UnoClientFrame:CreateFontString("UnoClientErrorFrame" .. unoIndexvar,"DIALOG","GameFontNormal");
_G["UnoClientErrorFrame" .. unoIndexvar]:SetFont("Fonts\\FRIZQT__.TTF",
		24, "OUTLINE, MONOCHROME");

_G["UnoClientErrorFrame" .. unoIndexvar].timer = UnoClientErrorDuration + 1;
_G["UnoClientErrorFrame" .. unoIndexvar].positive = true;
_G["UnoClientErrorFrame" .. unoIndexvar]:SetTextColor(0,0,1,1);
_G["UnoClientErrorFrame" .. unoIndexvar]:SetShadowColor(0,0,0,1);
_G["UnoClientErrorFrame" .. unoIndexvar]:SetShadowOffset(2,-1);
_G["UnoClientErrorFrame" .. unoIndexvar]:SetText("");
_G["UnoClientErrorFrame" .. unoIndexvar]:SetPoint("CENTER",
			_G["UnoClientErrorFrame" .. (unoIndexvar-1)],
			0,-25);
_G["UnoClientErrorFrame" .. unoIndexvar]:Hide();
end--




function updateUnoErrorText(elapsed)
for i=1,3 do
_G["UnoClientErrorFrame" .. i].timer = _G["UnoClientErrorFrame" .. i].timer + elapsed;
if (_G["UnoClientErrorFrame" .. i].timer > UnoClientErrorDuration) then
_G["UnoClientErrorFrame" .. i]:Hide();
else
--TODO: edit the opacity of the text here
local timerffs = _G["UnoClientErrorFrame" .. i].timer;
--fade only for the latter third
if (timerffs > UnoClientErrorDuration*2/3) then
--fade for latter third
local percentboy = (timerffs - UnoClientErrorDuration*2/3)/(timerffs*1/3);
if (_G["UnoClientErrorFrame" .. i].positive) then
_G["UnoClientErrorFrame" .. i]:SetTextColor(1,1,0,1 - percentboy);
else
_G["UnoClientErrorFrame" .. i]:SetTextColor(0,0,1,1 - percentboy);
end--else not positive
else
--draw opaque otherwise
if (_G["UnoClientErrorFrame" .. i].positive) then
_G["UnoClientErrorFrame" .. i]:SetTextColor(1,1,0,1);
else
_G["UnoClientErrorFrame" .. i]:SetTextColor(0,0,1,1);
end
end
end
end--end for

end--end function updateUnoErrorText



function printUnoError(newText,arg_PertainsToMe) 
--replace the error message on frame 1.
--shift it down to the other 2 frames.
--2 contains 1, 3 contains 2, 1 contains the new info.

--copy shift operations
for i=2,1,-1 do
_G["UnoClientErrorFrame" .. i+1]:SetText( 
	_G["UnoClientErrorFrame" .. i]:GetText());
_G["UnoClientErrorFrame" .. i+1].timer = 
	_G["UnoClientErrorFrame" .. i].timer;
_G["UnoClientErrorFrame" .. i+1].positive = 
	_G["UnoClientErrorFrame" .. i].positive;

end--end for
--overwrite operation
UnoClientErrorFrame1:SetText(newText);
UnoClientErrorFrame1.positive = arg_PertainsToMe;
UnoClientErrorFrame1.timer = 0;

--update the text, show the message
for i=1,3 do
if (_G["UnoClientErrorFrame" .. i].timer < UnoClientErrorDuration) then
_G["UnoClientErrorFrame" .. i]:Show();
end
end--end for


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
CreateFrame("Frame","UnoWildPickerFrame",UnoClientFrame);
UnoWildPickerFrame:SetSize(400,140);
UnoWildPickerFrame:SetPoint("CENTER");
UnoWildPickerFrame.t = UnoWildPickerFrame:CreateTexture();
UnoWildPickerFrame.t:SetAllPoints();
UnoWildPickerFrame.t:SetColorTexture(43/255/2,15/255/2,1/255/2,0.80/4);
UnoWildPickerFrame:Show();

--red,blue,green,yellow
CreateFrame("Button","UnoWildPickerRed",UnoWildPickerFrame,"UIPanelButtonTemplate"); 
CreateFrame("Button","UnoWildPickerBlue",UnoWildPickerFrame,"UIPanelButtonTemplate"); 
CreateFrame("Button","UnoWildPickerGreen",UnoWildPickerFrame,"UIPanelButtonTemplate"); 
CreateFrame("Button","UnoWildPickerYellow",UnoWildPickerFrame,"UIPanelButtonTemplate"); 
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
UnoWildPickerRed:SetSize(100,105);
UnoWildPickerRed:SetPoint("TOPLEFT",0,18);
UnoWildPickerRed:SetText("Red");
UnoWildPickerRed:SetScript("OnClick",function(selfhaha) 
UnoWildPickerFrame:Hide();
UnoMessageTheHost(UNO_IDENTIFIER .. " " .. UNO_CLIENT_CARDPLACED .. " " .. 
			self.cardindex
			.. " " .. 
			"red");
end);
UnoWildPickerRed:Show();
UnoWildPickerBlue:SetSize(100,105);
UnoWildPickerBlue:SetPoint("TOPLEFT",100,18);
UnoWildPickerBlue:SetText("Blue");
UnoWildPickerBlue:SetScript("OnClick",function(selfhaha) 
UnoWildPickerFrame:Hide();
UnoMessageTheHost(UNO_IDENTIFIER .. " " .. UNO_CLIENT_CARDPLACED .. " " .. 
			self.cardindex
			.. " " .. 
			"blue");
end);
UnoWildPickerBlue:Show();
UnoWildPickerGreen:SetSize(100,105);
UnoWildPickerGreen:SetPoint("TOPLEFT",200,18);
UnoWildPickerGreen:SetText("Green");
UnoWildPickerGreen:SetScript("OnClick",function(selfhaha) 
UnoWildPickerFrame:Hide();
UnoMessageTheHost(UNO_IDENTIFIER .. " " .. UNO_CLIENT_CARDPLACED .. " " .. 
			self.cardindex
			.. " " .. 
			"green");
end);
UnoWildPickerGreen:Show();
UnoWildPickerYellow:SetSize(100,105);
UnoWildPickerYellow:SetPoint("TOPLEFT",300,18);
UnoWildPickerYellow:SetText("Yellow");
UnoWildPickerYellow:SetScript("OnClick",function(selfhaha) 
UnoWildPickerFrame:Hide();
UnoMessageTheHost(UNO_IDENTIFIER .. " " .. UNO_CLIENT_CARDPLACED .. " " .. 
			self.cardindex
			.. " " .. 
			"yellow");
end);
UnoWildPickerYellow:Show();




else
--is not a wild
UnoMessageTheHost(UNO_IDENTIFIER .. " " .. UNO_CLIENT_CARDPLACED .. " " .. 
			self.cardindex);
end--end is not a wild

--unregister for drag lol
self:EnableMouse(false);


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

--returns the position (0,1,2,3,4,...) of the card in the players hand. for Positioning purposes.
function UnoClientGetHandCountNumber(card)

local handplease = UnoGetNumberedHandClient(card.owner);

for a,b in pairs(handplease) do
if (b.index == card.index) then return a; end
end--end for

end--end function UnoClientGetHandCountNumber

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

function UnoReceivedChatboxMessage(author,message)
--replace all underscores with spaces
local spaces = "";
for i=1,string.len(message) do
local character = string.sub(message,i,i);
if (character == "_") then
spaces = spaces .. " ";
else
spaces = spaces .. character;
end--end if
end--end for

--nickname
local nickname = nil;
if (string.len(author) >= 4) then
nickname = string.sub(author,1,4);
else
nickname = author;
end
--put it in the chat box
UnoClientFrameChatboxFrame:Insert("[" .. nickname .. "]:" .. spaces .. "\n");

end--end function UnoReceivedChatboxMessage

function UnoSendChatMessageToUnoChat(message)
--replace all spaces with underscores
local underscores = "";
for i=1,string.len(message) do
local character = string.sub(message,i,i);
if (character == " ") then
underscores = underscores .. "_";
else
underscores = underscores .. character;
end--end if
end--end for
--send signal to server host
UnoMessageTheHost(UNO_IDENTIFIER .. " " .. 
				  UNO_MESSAGE_CHATMESSAGECLIENT .. " " ..
				  UnoGetMe().name .. " " .. 
				  underscores);
end--end function UnoSendChatMessageToUnoChat


--TODO: allow the user to sort his cards.
function UnoCheckIfValidCardPlacement(draggingCard)

if (UnoGetMe().name ~= currentTurnNameClient) then printUnoError("It is " .. currentTurnNameClient .. "'s turn.",false) return false end

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
	printUnoError("You can't put that there!",true);
	end
--check for intersection with updeck card
if (isOnTop == true)
	then
	print("ayyyyyy its on top");
	if (draggingCard.label == "wild"
		or draggingCard.label == "wildplus4")
	then
		return true;
	end--end if special card
	--else check if the suit is right and stuff
	
	if (UnoClientCards[UnoCurrentUpdeckCardIndex].color == draggingCard.color 
		or UnoClientCards[UnoCurrentUpdeckCardIndex].label == draggingCard.label )
		then
		return true;
		else
		printUnoError("Neither the number, nor the color matches.",true);
		end--end if
end--end if

return false
end--end function UnoCheckIfValidCardPlacement

function UnoDrawClient() 

UnoClientFrameDragFrame:SetPoint("CENTER",UIParent,"CENTER",0,200);
UnoClientFrame:SetPoint("TOP",UnoClientFrameDragFrame,"BOTTOM");
UnoClientFrame:SetSize(800*3/4,600*3/4);
UnoClientFrameDragFrame:SetSize(800*3/4,600*3/4*1/32);
UnoClientFrameDragFrame:SetClampedToScreen(true);
UnoClientFrame:SetClampedToScreen(true);
UnoClientFrameDragFrame.label = UnoClientFrameDragFrame:CreateFontString(nil,UnoClientFrameDragFrame,"GameFontNormal");
	UnoClientFrameDragFrame.label:SetTextColor(1,0.643,0.169,1);
UnoClientFrameDragFrame.label:SetShadowColor(0,0,0,1);
 UnoClientFrameDragFrame.label:SetShadowOffset(2,-1);
 UnoClientFrameDragFrame.label:SetText("Click To Drag");
 UnoClientFrameDragFrame.label:SetAllPoints();
 UnoClientFrameDragFrame.label:Hide();
UnoClientFrameDragFrame.texture = UnoClientFrameDragFrame:CreateTexture();
UnoClientFrameDragFrame.texture:SetAllPoints();
UnoClientFrameDragFrame.texture:SetColorTexture(0,0,0,0);
UnoClientFrameDragFrame:SetMovable(true);
UnoClientFrameDragFrame:EnableMouse();
UnoClientFrameDragFrame:SetScript("OnEnter", function() 
if (UnoClientFrame:IsShown()) then
UnoClientFrameDragFrame.texture:SetColorTexture(0,0,0,1);
UnoClientFrameDragFrame.label:Show();
end
end);
UnoClientFrameDragFrame:SetScript("OnLeave", function() 
UnoClientFrameDragFrame.texture:SetColorTexture(0,0,0,0);
UnoClientFrameDragFrame.label:Hide();

end);


UnoClientFrameDragFrame:RegisterForDrag("LeftButton");
UnoClientFrameDragFrame:SetScript("OnDragStart",function(self)
self:StartMoving();
end);
UnoClientFrameDragFrame:SetScript("OnDragStop", function(self)

self:StopMovingOrSizing();
--[[if (self:GetBottom() < UnoClientFrame:GetTop()) then
self:SetPoint("CENTER",UIParent,"CENTER",(self:GetLeft()+self:GetRight())/2,UnoClientFrame:GetTop());
end--]]
if (self:GetBottom() < UnoClientFrame:GetTop()) then
self:ClearAllPoints();
self:SetPoint("BOTTOMLEFT",self:GetLeft(),UnoClientFrame:GetTop());
end



end);

UnoClientFrame.texture = UnoClientFrame:CreateTexture();
UnoClientFrame.texture:SetAllPoints();
UnoClientFrame.texture:SetColorTexture(43/255,15/255,1/255,0.80);

--add the text button
CreateFrame("BUTTON","UnoClientFrameToggleChatButton",UnoClientFrame,"UIPanelButtonTemplate");
UnoClientFrameToggleChatButton:SetPoint("TOPRIGHT");
UnoClientFrameToggleChatButton:SetSize(60,24);
UnoClientFrameToggleChatButton:SetText("Chat");
UnoClientFrameToggleChatButton:SetScript("OnClick",function(self)
if (UnoClientFrameChatboxFrame:IsShown()) then
UnoClientFrameChatboxFrame:Hide();
UnoClientFrameChatboxFrame.editbox:Hide();
else
UnoClientFrameChatboxFrame:Show();
UnoClientFrameChatboxFrame.editbox:Show();
end
end);

UnoClientFrameToggleChatButton:Show();



--add the DisplayMode Button
CreateFrame("BUTTON","UnoCardDisplayModeButton",UnoClientFrame,"UIPanelButtonTemplate");
UnoCardDisplayModeButton:SetPoint("TOPRIGHT",UnoClientFrameToggleChatButton,"TOPLEFT");
UnoCardDisplayModeButton:SetSize(80,24);
UnoCardDisplayModeButton:SetText("Expand");
UnoCardDisplayModeButton.displayMode = "Compact";
UnoCardDisplayModeButton:Show();
UnoCardDisplayModeButton:SetScript("OnClick",function(self)

--TODO: when you click the button :3c
if (UnoCardDisplayModeButton.displayMode == "Compact") then
UnoCardDisplayModeButton.displayMode = "Expand";
UnoCardDisplayModeButton:SetText("Compact");
else
UnoCardDisplayModeButton.displayMode = "Compact";
UnoCardDisplayModeButton:SetText("Expand");
end

UnoUpdatePositions();



end);

--add the rotate button
CreateFrame("BUTTON","UnoRotateUnoClientButton",UnoClientFrame,"UIPanelButtonTemplate");
UnoRotateUnoClientButton:SetPoint("TOPRIGHT",UnoCardDisplayModeButton,"TOPLEFT");
UnoRotateUnoClientButton:SetSize(80,24);
UnoRotateUnoClientButton:SetText("Rotate");
UnoRotateUnoClientButton.rotationValue = 0;
UnoRotateUnoClientButton:Show();
UnoRotateUnoClientButton:SetScript("OnClick",function(self)

RotateUnoClient();
UnoUpdatePositions();

end);


CreateFrame("EditBox","UnoClientFrameChatboxFrame",UnoClientFrame,"InputBoxTemplate");
--dimensions of other frame
UnoClientFrameChatboxFrame:SetPoint("TOPLEFT",UnoClientFrame,"TOPRIGHT");
UnoClientFrameChatboxFrame:SetMultiLine(true);
UnoClientFrameChatboxFrame:SetAutoFocus(false);
UnoClientFrameChatboxFrame:SetSize(800*3/4*1/4,600*3/4*15/16);
UnoClientFrameChatboxFrame:SetPoint("BOTTOM",UnoClientFrame,"BOTTOM",0,600*3/4*1/16)
UnoClientFrameChatboxFrame.texture = UnoClientFrameChatboxFrame:CreateTexture();
UnoClientFrameChatboxFrame.texture:SetAllPoints();
UnoClientFrameChatboxFrame.texture:SetColorTexture(43/255/2,15/255/2,1/255/2,.80);



---------------------------
--now make da edit box
--CreateFrame("EditBox","UnoManualInviteUsernameEditBox",UnoScreenLobby,"InputBoxTemplate");
UnoClientFrameChatboxFrame.editbox = 
		CreateFrame("EditBox",nil,UnoClientFrame,"InputBoxTemplate");
UnoClientFrameChatboxFrame.editbox:SetPoint("TOP",UnoClientFrameChatboxFrame,"BOTTOM",10,0);
UnoClientFrameChatboxFrame.editbox:SetAutoFocus(false);
UnoClientFrameChatboxFrame.editbox:SetSize(800*3/4*1/4,600*3/4*1/16)
UnoClientFrameChatboxFrame.editbox:Show();

UnoClientFrameChatboxFrame:Hide();
UnoClientFrameChatboxFrame.editbox:Hide();

UnoClientFrameChatboxFrame.editbox:SetScript("OnEnterPressed", function(self)
UnoSendChatMessageToUnoChat(self:GetText());
self:SetText("");
end);

UnoClientFrameChatboxFrame:SetScript("OnEditFocusGained", function(self) 
UnoClientFrameChatboxFrame.editbox:SetFocus();
end

);

--

local numPlayers = tablelength(UnoClientPlayers);
local theta = math.pi/2;
local width,height = UnoClientFrame:GetSize();
local centerXArray= {[1]=0,[2]=0,[3]=width/5,[4]=-width/5};
local centerYArray= {[1]=width/5,[2]=-width/5,[3]=0,[4]=0};
local thetaArray = {[1]=0,[2]=math.pi,[3]=math.pi/2,[4]=3*math.pi/2};

for name,player in pairs(UnoClientPlayers) do
if (player.officialIndex == 3 or player.officialIndex == 4) then
player.vertical = true;
else
player.vertical = false;
end
player.theta = thetaArray[player.officialIndex];
--relative to the middle of the board
------local px = UnoClientPlayers[cardToPosition.owner].centerX;
player.centerX = centerXArray[player.officialIndex];
player.centerY = centerYArray[player.officialIndex];
--position the text label for the player
player.frame:SetPoint("CENTER",UnoClientFrame,"CENTER",player.centerX,player.centerY);
player.title:SetPoint("CENTER",
	player.frame,"CENTER",0,0);
end--end for





for index,card in pairs(UnoClientCards) do
card.frame = CreateFrame("FRAME",nil,UnoClientFrame);

card.frame:SetSize(width/8*0.7142857142857143,width/8);

--UnoPositionCard(card);
card.frame.texture = card.frame:CreateTexture();
card.frame.texture:SetAllPoints();
card.frame:Hide();
end




UnoClientFrameDragFrame:Show();
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
