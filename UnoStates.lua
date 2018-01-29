UNO_SCREEN_BLANK = 0;
UNO_SCREEN_SLASHUNO = 1;
UNO_SCREEN_LOBBY = 2;
UNO_SCREEN_INVITATION = 3;
UNO_SCREEN_LOBBYGUEST = 4;
UNO_SCREEN_PLAYINGGAME = 5;

UnoCurrentScreen = UNO_SCREEN_BLANK;

UNO_IDENTIFIER = "<Uno>";
UNO_MESSAGE_SEND_INVITATION = "The user is trying to invite you to join his Uno group, but it appears you do not have the Uno addon (or you disabled it). pls download from curse.com/addons/wow/uno"
UNO_MESSAGE_HAS_ADDON = "I have the uno addon";
UNO_MESSAGE_DECLINE = "decline";
UNO_MESSAGE_ACCEPT = "accept";
--partial thngs
UNO_STARTING = "starting";--DONETODO: give the name of all players appended to this string?
UNO_MESSAGE_CARDUPDATE = "CARDUPDATE";--DONETODO: broadcast deck data appended to this string

--
UnoScreenSlashUno = CreateFrame("Frame","UnoScreenSlashUno",UIParent);
UnoScreenSlashUno:SetSize(400,300);
UnoScreenSlashUno:SetPoint("CENTER");
UnoScreenSlashUno.t = UnoScreenSlashUno:CreateTexture();
UnoScreenSlashUno.t:SetAllPoints();
UnoScreenSlashUno.t:SetColorTexture(43/255,15/255,1/255,0.80);
UnoScreenSlashUno:Show();

CreateFrame("Button","UnoScreenSlashUnoCloseButton",UnoScreenSlashUno,"UIPanelButtonTemplate"); 
UnoScreenSlashUnoCloseButton:SetSize(24,24);
UnoScreenSlashUnoCloseButton:SetPoint("TOPRIGHT");
UnoScreenSlashUnoCloseButton:SetScript("OnClick",CloseOutOfUnoGame);
UnoScreenSlashUnoCloseButton:SetText("x");
UnoScreenSlashUnoCloseButton:Show();


UnoSplashFrame = CreateFrame("Frame","UnoSplashFrame",UnoScreenSlashUno);
UnoSplashFrame:SetSize(80*2,60*2);
UnoSplashFrame:SetPoint("TOP");
UnoSplash = UnoSplashFrame:CreateTexture();
UnoSplash:SetTexture("Interface/AddOns/Uno/images/unologo.tga");
UnoSplash:SetAllPoints();
UnoSplashFrame:Show();




CreateFrame("Frame","UnoScreenLobby",UIParent);
UnoScreenLobby:SetSize(800,500);
UnoScreenLobby:SetPoint("CENTER",0,0);
UnoScreenLobby.t = UnoScreenLobby:CreateTexture();
UnoScreenLobby.t:SetAllPoints();
UnoScreenLobby.t:SetColorTexture(43/255,15/255,1/255,0.80);
UnoScreenLobby:Hide();

CreateFrame("Button","UnoScreenLobbyCloseButton",UnoScreenLobby,"UIPanelButtonTemplate");
UnoScreenLobbyCloseButton:SetSize(24,24);
UnoScreenLobbyCloseButton:SetPoint("TOPRIGHT");
UnoScreenLobbyCloseButton:SetScript("OnClick",CloseOutOfUnoGame);
UnoScreenLobbyCloseButton:SetText("x");
UnoScreenLobbyCloseButton:Show();


UnoPlayersInLobbyList = {};

function updateUnoPlayersInLobbyList()
yOffset = 0;
index = 0;
for name,player in pairs(UnoPlayers) do
index = index + 1;
if (player.userJoinedTheLobby == true) then
if (not(UnoPlayersInLobbyList[index])
	or
	UnoPlayersInLobbyList[index].name ~= name) then
	if (UnoPlayersInLobbyList[index]) then UnoPlayersInLobbyList[index]:Hide() end

text = UnoAcceptedPlayersFrame:CreateFontString(nil,nil,"GameFontNormal");
text:SetTextColor(1,1,0,1);
 text:SetShadowColor(0,0,0,1);
 text:SetShadowOffset(2,-1);
 text:SetPoint("TOPLEFT",10,-16*index);
 text:SetText(name);
 text:Show();
 text.name = name;


UnoPlayersInLobbyList[index] = text;
end--end if not added yet or there was a change
end--end if he is in da lobby
end


end--end function updateUnoPlayersInLobbyList

UnoInvitationStatusList = {};

function updateUnoInvitationStatusList()
yOffset = 0;
index = 0;
--parallel array
for name,player in pairs(UnoPlayers) do
index = index + 1;
if (not(UnoInvitationStatusList[index])
	or
	UnoInvitationStatusList[index].name ~= name) then
	if (UnoInvitationStatusList[index]) then UnoInvitationStatusList[index]:Hide() end



iconFrame = CreateFrame("Frame",nil,UnoProcessFrame);
iconFrame:SetSize(16,16);
iconFrame:SetPoint("TOPLEFT",10,-16*index);
icon = iconFrame:CreateTexture();

print("heyo guys");


icon:SetAllPoints();
iconFrame:Show();
	
text = UnoProcessFrame:CreateFontString(nil,iconFrame,"GameFontNormal");
text:SetTextColor(1,1,0,1);
 text:SetShadowColor(0,0,0,1);
 text:SetShadowOffset(2,-1);
 text:SetPoint("LEFT",iconFrame,"RIGHT",10,0);
 text:SetText(name);
 text:Show();
 text.name = name;

text.icon = icon;
text.iconFrame = iconFrame;
UnoInvitationStatusList[index] = text;
end--end if not added yet or there was a change

if (player.userHasUnoOrNot == false and player.userHasUnoOrNotTimer < 5.0) then
UnoInvitationStatusList[index].icon:SetTexture("Interface/AddOns/Uno/images/questionmark.tga");

UnoInvitationStatusList[index].iconFrame:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("checking if " .. player.name .. " has uno");
end);
end
if (player.userHasUnoOrNot == false and player.userHasUnoOrNotTimer > 5.0) then
UnoInvitationStatusList[index].icon:SetTexture("Interface/AddOns/Uno/images/redx.tga");
UnoInvitationStatusList[index].iconFrame:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(player.name .. " does not have the addon");
end);
end
if (player.userJoinedTheLobby == false and player.userHasUnoOrNot == true) then
UnoInvitationStatusList[index].icon:SetTexture("Interface/AddOns/Uno/images/ellipsis.tga");
UnoInvitationStatusList[index].iconFrame:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("waiting for " .. player.name .. "'s choice...");
end);
end
if (player.userJoinedTheLobby == true) then
UnoInvitationStatusList[index].icon:SetTexture("Interface/AddOns/Uno/images/greencheck.tga");
UnoInvitationStatusList[index].iconFrame:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(player.name .. " has joined the lobby");
end);
end
if (player.userDeclinedTheInvite == true) then
UnoInvitationStatusList[index].icon:SetTexture("Interface/AddOns/Uno/images/redx.tga");
UnoInvitationStatusList[index].iconFrame:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(player.name .. " declined your invite");
end);
end

end--end for

end--end function updateUnoInvitationStatusList

CreateFrame("Button", "UnoMakeLobbyButton", UnoScreenSlashUno, "UIPanelButtonTemplate");
UnoMakeLobbyButton:SetSize(150,50);
UnoMakeLobbyButton:SetPoint("CENTER")
UnoMakeLobbyButton:SetScript("OnClick",function()
UnoScreenSlashUno:Hide();
UnoScreenLobby:Show();
UnoMakeLobbyFrames();
UnoCurrentScreen = UNO_SCREEN_LOBBY;
end);
UnoMakeLobbyButton:SetText("Make Lobby")
UnoMakeLobbyButton:Show();

CreateFrame("Button", "UnoExitSlashScreenButton", UnoScreenSlashUno, "UIPanelButtonTemplate");
UnoExitSlashScreenButton:SetSize(150,50);
UnoExitSlashScreenButton:SetPoint("TOP",UnoMakeLobbyButton,"BOTTOM",0,0);
UnoExitSlashScreenButton:SetScript("OnClick",function() 
UnoScreenSlashUno:Hide();
UnoCurrentScreen = UNO_SCREEN_BLANK; 
end);
UnoExitSlashScreenButton:SetText("Exit Uno")
UnoExitSlashScreenButton:Show();






--

function UnoMakeLobbyFrames()
UnoScrollFrameTitle = UnoScreenLobby:CreateFontString("UnoScrollFrameTitle",UnoScreenLobby,"GameFontNormal");
UnoScrollFrameTitle:SetTextColor(1,1,0,1);
 UnoScrollFrameTitle:SetShadowColor(0,0,0,1);
 UnoScrollFrameTitle:SetShadowOffset(2,-1);
 UnoScrollFrameTitle:SetPoint("TOPLEFT",10,-10);
 UnoScrollFrameTitle:SetText("Friends to invite");
 UnoScrollFrameTitle:Show();
local frame = CreateFrame("Frame", "UnoScrollFrameParent", UnoScreenLobby) 
frame:SetSize(150, 200) 
frame:SetPoint("TOPLEFT",UnoScrollFrameTitle,"BOTTOMLEFT",0,0);
local texture = frame:CreateTexture() 
texture:SetAllPoints() 
texture:SetColorTexture(1,1,1,0.1) 
frame.background = texture 
local scrollframe = CreateFrame("ScrollFrame","UnoScrollFrame",UnoScrollFrameParent);
scrollframe:SetPoint("CENTER",0,0);
scrollframe:SetSize(150,200);

scrollframe:Show();

scrollbar = CreateFrame("Slider", "UnoScrollBar", UnoScrollFrame, "UIPanelScrollBarTemplate") 
scrollbar:SetPoint("TOPLEFT", frame, "TOPRIGHT", 4, -16) 
scrollbar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 4, 16) 
scrollbar:SetMinMaxValues(1, 16*BNGetNumFriends()) 
scrollbar:SetValueStep(1) 
scrollbar.scrollStep = 1
scrollbar:SetValue(0) 
scrollbar:SetWidth(16) 
scrollbar.buttons = {};
scrollbar:SetScript("OnValueChanged", 
function (self, value) 
self:GetParent():SetVerticalScroll(value) 

for i, butt in ipairs(scrollbar.buttons) do
  if (butt:GetBottom() < UnoScrollFrame:GetBottom() or butt:GetTop() > UnoScrollFrame:GetTop()) then
  butt:Hide();
  else
  butt:Show();
  end
end


end) 

scrollframe:EnableMouseWheel(true);
scrollframe:SetScript("OnMouseWheel", function(self, delta)
      scrollbar:SetValue(scrollbar:GetValue()-delta*8);
end)

local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND") 
scrollbg:SetAllPoints(scrollbar) 
scrollbg:SetColorTexture(0, 0, 0, 0.4) 

local content = CreateFrame("Frame", UnoScrollFrameContent, UnoScrollFrame) 
content:SetSize(128, 128) 
local texture = content:CreateTexture() 
texture:SetAllPoints() 
--texture:SetTexture("Interface\\GLUES\\MainMenu\\Glues-BlizzardLogo") 
texture:SetColorTexture(0,0,0,0);
content.texture = texture 

scrollframe:SetScrollChild(content)

local dummy = CreateFrame("CheckButton","UnoFriendSelectButton0",content,"OptionsCheckButtonTemplate");
dummy:SetPoint("TOPLEFT",0,16);
dummy:Hide();
--check boxes are 26 by 26 pixels. the gap between them is ...

local wowcount = 0;
for index = 1, BNGetNumFriends() do
--http://wowprogramming.com/docs/api/BNGetFriendInfo
local presenceID,glitchyAccountName,bnetNameWithNumber,isJustBNetFriend,characterName,uselessnumber,game = BNGetFriendInfo( index );
if (game == "WoW") then
wowcount = wowcount + 1;
local button = CreateFrame("CheckButton","UnoFriendSelectButton" .. index,content,"OptionsCheckButtonTemplate");
scrollbar.buttons[index] = button;
button:SetPoint("TOPLEFT",_G["UnoFriendSelectButton" .. index-1],"BOTTOMLEFT",0,0);
button.name = bnetNameWithNumber;
button.toonName = characterName;
button.glitchyAccountName = glitchyAccountName;
button.presenceID = presenceID;
button.index = index;
button.disabled = false;
button.setFunc = function(value) 

local temperino = _G["UnoFriendSelectButton" .. button.index];
temperino.titleText:SetTextColor(1/2,0.643/2,0.169/2,1);
temperino.disabled = true;
end--end anonymous function
--now make text labels
local titleText = button:CreateFontString("titleText",button,"GameFontNormal");
 titleText:SetTextColor(1,0.643,0.169,1);
 titleText:SetShadowColor(0,0,0,1);
 titleText:SetShadowOffset(2,-1);
 titleText:SetPoint("LEFT",button,"RIGHT",0,0);
 titleText:SetText(bnetNameWithNumber);
 titleText:Show();

button.titleText = titleText;
button:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("click to invite " .. bnetNameWithNumber);
end);

end--end if game==wow

if (wowcount == 0)
then scrollbar:SetMinMaxValues(1, 1);
else
scrollbar:SetMinMaxValues(1, 19*wowcount)  end


end--end for
for i, butt in ipairs(scrollbar.buttons) do
  if (butt:GetBottom() < UnoScrollFrame:GetBottom() or butt:GetTop() > UnoScrollFrame:GetTop()) then
  butt:Hide();
  else
  butt:Show();
  end
end

-----------------
--now making the middle box: processing users


UnoProcessFrameTitle = UnoScreenLobby:CreateFontString("UnoProcessFrameTitle",UnoScreenLobby,"GameFontNormal");
UnoProcessFrameTitle:SetTextColor(1,1,0,1);
 UnoProcessFrameTitle:SetShadowColor(0,0,0,1);
 UnoProcessFrameTitle:SetShadowOffset(2,-1);
 UnoProcessFrameTitle:SetPoint("TOP",UnoScrollFrameTitle,"TOP");
 UnoProcessFrameTitle:SetPoint("LEFT",UnoScrollFrame,"RIGHT",50,0);
 UnoProcessFrameTitle:SetText("Invitation Status");
 UnoProcessFrameTitle:Show();

CreateFrame("Frame","UnoProcessFrame",UnoScreenLobby);
UnoProcessFrame:SetPoint("TOP",UnoProcessFrameTitle,"BOTTOM");
UnoProcessFrame:SetPoint("LEFT",UnoScrollFrame,"RIGHT",50,0);
UnoProcessFrame:SetWidth(250);
UnoProcessFrame:SetPoint("BOTTOM",UnoScreenLobby,"BOTTOM",0,150);
UnoProcessFrame.t = UnoProcessFrame:CreateTexture();
UnoProcessFrame.t:SetColorTexture(1,1,1,0.1);
UnoProcessFrame.t:SetAllPoints();
UnoProcessFrame:Show();

---------------------
--making the bottomleft box: guildies
UnoGuildiesFrameTitle = UnoScreenLobby:CreateFontString("UnoGuildiesFrameTitle",UnoScreenLobby,"GameFontNormal");
UnoGuildiesFrameTitle:SetTextColor(1,1,0,1);
 UnoGuildiesFrameTitle:SetShadowColor(0,0,0,1);
 UnoGuildiesFrameTitle:SetShadowOffset(2,-1);
 UnoGuildiesFrameTitle:SetPoint("TOPLEFT",UnoScrollFrame,"BOTTOMLEFT",0,-25*2);
 UnoGuildiesFrameTitle:SetText("Guildies to invite");
 UnoGuildiesFrameTitle:Show();
 
 local frame2 = CreateFrame("Frame", nil, UnoScreenLobby) 
frame2:SetSize(150, 200) 
frame2:SetPoint("TOPLEFT",UnoGuildiesFrameTitle,"BOTTOMLEFT",0,0);
local texture2 = frame2:CreateTexture() 
texture2:SetAllPoints() 
texture2:SetColorTexture(1,1,1,0.1) 
frame2.background = texture2;
local scrollframe2 = CreateFrame("ScrollFrame","UnoScrollFrameGuildies",frame2);
scrollframe2:SetPoint("CENTER",0,0);
scrollframe2:SetSize(150,200);
scrollframe2:Show();

scrollbar2 = CreateFrame("Slider", "UnoGuildiesScrollBar", scrollframe2, "UIPanelScrollBarTemplate") 
scrollbar2:SetPoint("TOPLEFT", frame2, "TOPRIGHT", 4, -16) 
scrollbar2:SetPoint("BOTTOMLEFT", frame2, "BOTTOMRIGHT", 4, 16) 
GuildRoster();--updates the info in the UI
local numGuildMembers, numOnline, numOnlineAndMobile = GetNumGuildMembers()
if (numOnline == 0) then numOnline = 1 end
scrollbar2:SetMinMaxValues(1, 19*numOnline) 
scrollbar2:SetValueStep(1) 
scrollbar2.scrollStep = 1
scrollbar2:SetValue(0) 
scrollbar2:SetWidth(16) 
scrollbar2.buttons = {};
scrollbar2:SetScript("OnValueChanged", 
function (self, value) 
self:GetParent():SetVerticalScroll(value) 
for i, butt in ipairs(scrollbar2.buttons) do
  if (butt:GetBottom() < scrollframe2:GetBottom() or butt:GetTop() > scrollframe2:GetTop()) then
  butt:Hide();
  else
  butt:Show();
  end
end
end) 
scrollframe2:EnableMouseWheel(true);
scrollframe2:SetScript("OnMouseWheel", function(self, delta)
      scrollbar2:SetValue(scrollbar2:GetValue()-delta*8);
end)
local scrollbg2 = scrollbar:CreateTexture(nil, "BACKGROUND") 
scrollbg2:SetAllPoints(scrollbar2) 
scrollbg2:SetColorTexture(0, 0, 0, 0.4) 

local content2 = CreateFrame("Frame", "UnoContentFrameGuildies", scrollframe2) 
content2:SetSize(128, 128) 
local texture2 = content2:CreateTexture() 
texture2:SetAllPoints() 

texture2:SetColorTexture(0,0,0,0);
content2.texture = texture2 

scrollframe2:SetScrollChild(content2)
 
--forloopstuffbelow,scrollframestuffabove
 local dummy = CreateFrame("CheckButton","UnoGuildySelectButton0",content2,"OptionsCheckButtonTemplate");
dummy:SetPoint("TOPLEFT",0,16);
dummy:Hide();
 
GuildRoster();--updates the info in the UI

for index=1,numOnline do 

local fullName, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(index) 

local button2 = CreateFrame("CheckButton","UnoGuildySelectButton" .. index,content2,"OptionsCheckButtonTemplate");
button2:SetPoint("TOPLEFT",_G["UnoGuildySelectButton" .. index-1],"BOTTOMLEFT",0,0);
button2.name = fullName;
button2.toonName = fullName;
button2.index = index;
button2.disabled = false;
scrollbar2.buttons[index] = button2;
button2.setFunc = function(value) 

local temperino2 = _G["UnoGuildySelectButton" .. button2.index];
temperino2.titleText2:SetTextColor(1/2,0.643/2,0.169/2,1);
temperino2.disabled = true;
end--end anonymous function
--now make text labels
local titleText2 = button2:CreateFontString("titleText2",button2,"GameFontNormal");
 titleText2:SetTextColor(1,0.643,0.169,1);
 titleText2:SetShadowColor(0,0,0,1);
 titleText2:SetShadowOffset(2,-1);
 titleText2:SetPoint("LEFT",button2,"RIGHT",0,0);
 titleText2:SetText(fullName);
 titleText2:Show();

button2.titleText2 = titleText2;
button2:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("click to invite " .. fullName);
end);



end--end for

for i, butt in ipairs(scrollbar2.buttons) do
  if (butt:GetBottom() < scrollframe2:GetBottom() or butt:GetTop() > scrollframe2:GetTop()) then
  butt:Hide();
  else
  butt:Show();
  end
end

----------------------
--making the right box: lobbyparty
UnoAcceptedPlayersFrameTitle = UnoScreenLobby:CreateFontString("UnoAcceptedPlayersFrameTitle",UnoScreenLobby,"GameFontNormal");
UnoAcceptedPlayersFrameTitle:SetTextColor(1,1,0,1);
 UnoAcceptedPlayersFrameTitle:SetShadowColor(0,0,0,1);
 UnoAcceptedPlayersFrameTitle:SetShadowOffset(2,-1);
 UnoAcceptedPlayersFrameTitle:SetPoint("TOP",UnoScrollFrameTitle,"TOP");
 UnoAcceptedPlayersFrameTitle:SetPoint("LEFT",UnoProcessFrame,"RIGHT",25,0);
 UnoAcceptedPlayersFrameTitle:SetText("Players in lobby");
 UnoAcceptedPlayersFrameTitle:Show();

CreateFrame("FRAME","UnoAcceptedPlayersFrame",UnoScreenLobby);
UnoAcceptedPlayersFrame:SetSize(UnoScrollFrame:GetWidth(),UnoScrollFrame:GetHeight());
UnoAcceptedPlayersFrame:SetPoint("TOP",UnoAcceptedPlayersFrameTitle,"BOTTOM",0,0);
UnoAcceptedPlayersFrame:SetPoint("LEFT",UnoAcceptedPlayersFrameTitle,"LEFT",0,0);
UnoAcceptedPlayersFrame.t = UnoAcceptedPlayersFrame:CreateTexture();
UnoAcceptedPlayersFrame.t:SetColorTexture(1,1,1,0.1);
UnoAcceptedPlayersFrame.t:SetAllPoints();
UnoAcceptedPlayersFrame:Show();
--------------------------
--make the editbox for manual invite
UnoManualInviteEditBoxTitle = UnoScreenLobby:CreateFontString("UnoManualInviteEditBoxTitle",UnoScreenLobby,"GameFontNormal");
UnoManualInviteEditBoxTitle:SetTextColor(1,1,0,1);
UnoManualInviteEditBoxTitle:SetShadowColor(0,0,0,1);
UnoManualInviteEditBoxTitle:SetShadowOffset(2,-1);
UnoManualInviteEditBoxTitle:SetText("Manual (type name-realm and press enter)");
UnoManualInviteEditBoxTitle:SetPoint("TOP",UnoProcessFrame,"BOTTOM",0,0);
UnoManualInviteEditBoxTitle:SetPoint("LEFT",UnoProcessFrame);
UnoManualInviteEditBoxTitle:Show();

CreateFrame("EditBox","UnoManualInviteEditBox",UnoScreenLobby,"InputBoxTemplate");
UnoManualInviteEditBox:SetSize(UnoProcessFrame:GetWidth(),50);
UnoManualInviteEditBox:SetPoint("TOP",UnoManualInviteEditBoxTitle,"BOTTOM",0,10);
UnoManualInviteEditBox:SetPoint("LEFT",UnoManualInviteEditBoxTitle)
UnoManualInviteEditBox:SetAutoFocus(false);
UnoManualInviteEditBox:SetScript("OnEnterPressed",function() 
UnoManualInviteEditBox:SetText("");
updateUnoInvitationStatusList();
end);
UnoManualInviteEditBox:Show();

-----------------------
--make da invite and refresh buttons
CreateFrame("Button","UnoRefreshListButton",UnoScreenLobby,"UIPanelButtonTemplate");
UnoRefreshListButton:SetSize(150,25);
UnoRefreshListButton:SetPoint("TOP",UnoScrollFrame,"BOTTOM");
UnoRefreshListButton:SetPoint("LEFT",UnoScrollFrame);
UnoRefreshListButton:SetText("Refresh");
UnoRefreshListButton:SetScript("OnClick",function()
--refresh the bnet list. you have to reuse the old frames.
---=-==-=begin copy paste with some changes here

dummy = UnoFriendSelectButton0;
--check boxes are 26 by 26 pixels. the gap between them is ...
--make them all invisible now 10/27/17
for i=1,100 do
if (_G["UnoFriendSelectButton" .. i]) then
_G["UnoFriendSelectButton" .. i]:Hide();
_G["UnoFriendSelectButton" .. i]:SetChecked(false);
_G["UnoFriendSelectButton" .. i].stevenDisable = true;
end
end

local wowcount = 0;

for index = 1, BNGetNumFriends() do
--http://wowprogramming.com/docs/api/BNGetFriendInfo
local presenceID,glitchyAccountName,bnetNameWithNumber,isJustBNetFriend,characterName,uselessnumber,game = BNGetFriendInfo( index );
if (game == "WoW") then
wowcount = wowcount + 1;
local button = "";
local content = UnoScrollFrameContent;
local scrollbar = UnoScrollBar;
local scrollframe = UnoScrollFrame;
--reuse the old buttons on refresh
local already = false;
if (_G["UnoFriendSelectButton" .. index]) then
already = true;
button = _G["UnoFriendSelectButton" .. index];
else
button = CreateFrame("CheckButton","UnoFriendSelectButton" .. index,content,"OptionsCheckButtonTemplate");
end
button.stevenDisable = false;

scrollbar.buttons[index] = button;
button:SetPoint("TOPLEFT",_G["UnoFriendSelectButton" .. index-1],"BOTTOMLEFT",0,0);
--write the new data
button.name = bnetNameWithNumber;
button.toonName = characterName;
button.glitchyAccountName = glitchyAccountName;
button.presenceID = presenceID;
button.index = index;
button.disabled = false;
button.setFunc = function(value) 

local temperino = _G["UnoFriendSelectButton" .. button.index];
temperino.titleText:SetTextColor(1/2,0.643/2,0.169/2,1);
temperino.disabled = true;
end--end anonymous function
--now make text labels
if (already == false) then
local titleText = button:CreateFontString("titleText",button,"GameFontNormal");
 titleText:SetTextColor(1,0.643,0.169,1);
 titleText:SetShadowColor(0,0,0,1);
 titleText:SetShadowOffset(2,-1);
 titleText:SetPoint("LEFT",button,"RIGHT",0,0);
 titleText:SetText(bnetNameWithNumber);
 titleText:Show();

button.titleText = titleText;

else--else if already
button.titleText:SetText(bnetNameWithNumber);
end--end if already-block
--either way
button:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("click to invite " .. bnetNameWithNumber);
end);
end--end if game==wow

if (wowcount == 0)
then scrollbar:SetMinMaxValues(1, 1);
else
scrollbar:SetMinMaxValues(1, 19*wowcount)  end
end--end for
for i, butt in ipairs(scrollbar.buttons) do
if (butt.stevenDisable == false) then
  if (butt:GetBottom() < UnoScrollFrame:GetBottom() or butt:GetTop() > UnoScrollFrame:GetTop()) then
  butt:Hide();
  else
  butt:Show();
  end
end
end
--=-=-=-=-end copy paste
---=-=-=begin copy paste other thing and some other copy pastes too
--make them all invisible now 10/27/17
for i=1,100 do
if (_G["UnoGuildySelectButton" .. i]) then
_G["UnoGuildySelectButton" .. i]:Hide();
_G["UnoGuildySelectButton" .. i]:SetChecked(false);
_G["UnoGuildySelectButton" .. i].stevenDisable = true;
end
end

local dummy = UnoGuildySelectButton0;
GuildRoster();--updates the info in the UI
local numGuildMembers, numOnline, numOnlineAndMobile = GetNumGuildMembers()
if (numOnline == 0) then numOnline = 1 end 
GuildRoster();--updates the info in the UI

for index=1,numOnline do 

local fullName, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(index) 
local already = false;
local button2 = "";
local content2 = UnoContentFrameGuildies;
local scrollbar2 = UnoGuildiesScrollBar;
local scrollframe2 = UnoScrollFrameGuildies;
if (_G["UnoGuildySelectButton" .. index]) then
already = true;
button2 = _G["UnoGuildySelectButton" .. index];
else
button2 = CreateFrame("CheckButton","UnoGuildySelectButton" .. index,content2,"OptionsCheckButtonTemplate");
end--end if button
button2.stevenDisable = false;

button2:SetPoint("TOPLEFT",_G["UnoGuildySelectButton" .. index-1],"BOTTOMLEFT",0,0);
button2.name = fullName;
button2.toonName = fullName;
button2.index = index;
button2.disabled = false;
scrollbar2.buttons[index] = button2;
button2.setFunc = function(value) 

local temperino2 = _G["UnoGuildySelectButton" .. button2.index];
temperino2.titleText2:SetTextColor(1/2,0.643/2,0.169/2,1);
temperino2.disabled = true;
end--end anonymous function
--now make text labels
if (already == false) then
local titleText2 = button2:CreateFontString("titleText2",button2,"GameFontNormal");
 titleText2:SetTextColor(1,0.643,0.169,1);
 titleText2:SetShadowColor(0,0,0,1);
 titleText2:SetShadowOffset(2,-1);
 titleText2:SetPoint("LEFT",button2,"RIGHT",0,0);
 titleText2:SetText(fullName);
 titleText2:Show();

button2.titleText2 = titleText2;

else--else if already
button2.titleText2:SetText(fullName);
end
--either way
button2:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("click to invite " .. fullName);
end);

end--end for

for i, butt in ipairs(scrollbar2.buttons) do
if (butt.stevenDisable == false) then
  if (butt:GetBottom() < scrollframe2:GetBottom() or butt:GetTop() > scrollframe2:GetTop()) then
  butt:Hide();
  else
  butt:Show();
  end
end
end
---=-=-=end copy paste other thing


end);--end function OnClick for refresh button
UnoRefreshListButton:Show();

CreateFrame("Button","UnoInviteListButton",UnoScreenLobby,"UIPanelButtonTemplate");
UnoInviteListButton:SetSize(150,25);
UnoInviteListButton:SetPoint("TOP",UnoRefreshListButton,"BOTTOM");
UnoInviteListButton:SetPoint("LEFT",UnoScrollFrame);
UnoInviteListButton:SetText("Invite");
UnoInviteListButton:SetScript("OnClick",function()

for i, butt in ipairs(UnoScrollBar.buttons) do
  if (butt:GetChecked()) then
  --AddUnoPlayer("bnethashtag",butt.name,butt.presenceID,butt.glitchyAccountName);
  AddUnoPlayer("bnethashtag",butt);
  UnoMessage(UnoPlayers[butt.name],UNO_IDENTIFIER .. " " .. UNO_MESSAGE_SEND_INVITATION);
  end--end if
end--end for

for i, butt in ipairs(UnoGuildiesScrollBar.buttons) do
  if (butt:GetChecked()) then
  --AddUnoPlayer("nameserver",butt.name);
  AddUnoPlayer("nameserver",butt);
  UnoMessage(UnoPlayers[butt.name],UNO_IDENTIFIER .. " " .. UNO_MESSAGE_SEND_INVITATION);
  end--end if
end--end for

updateUnoInvitationStatusList();
end);
UnoInviteListButton:Show();
-----------------------
--now make the ready and start buttons
CreateFrame("Button","UnoReadyUpButton",UnoScreenLobby,"UIPanelButtonTemplate");
UnoReadyUpButton:SetSize(150,50);
UnoReadyUpButton:SetPoint("TOP",UnoAcceptedPlayersFrame,"BOTTOM");
UnoReadyUpButton:SetPoint("LEFT",UnoAcceptedPlayersFrame);
UnoReadyUpButton:SetText("Ready?");
UnoReadyUpButton:SetScript("OnClick",function()
print("clicked da ready button");
end);
UnoReadyUpButton:Show();

CreateFrame("Button","UnoStartGameButton",UnoScreenLobby,"UIPanelButtonTemplate");
UnoStartGameButton:SetSize(150,50);
UnoStartGameButton:SetPoint("TOP",UnoReadyUpButton,"BOTTOM");
UnoStartGameButton:SetPoint("LEFT",UnoAcceptedPlayersFrame);
UnoStartGameButton:SetText("Start Game");
UnoStartGameButton:SetScript("OnClick",function()
print("clicked da start button")
StartTheUnoGameWithThesePlayers();--server command
end);
UnoStartGameButton:Show();

end--end function UnoMakeLobbyFrames