UNO_SCREEN_BLANK = 0;
UNO_SCREEN_SLASHUNO = 1;
UNO_SCREEN_LOBBY = 2;

UnoCurrentScreen = UNO_SCREEN_BLANK;


--
UnoScreenSlashUno = CreateFrame("Frame","UnoScreenSlashUno",UIParent);
UnoScreenSlashUno:SetSize(400,300);
UnoScreenSlashUno:SetPoint("CENTER");
UnoScreenSlashUno.t = UnoScreenSlashUno:CreateTexture();
UnoScreenSlashUno.t:SetAllPoints();
UnoScreenSlashUno.t:SetColorTexture(43/255,15/255,1/255,0.80);
UnoScreenSlashUno:Show();

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

scrollbar = CreateFrame("Slider", UnoScrollBar, UnoScrollFrame, "UIPanelScrollBarTemplate") 
scrollbar:SetPoint("TOPLEFT", frame, "TOPRIGHT", 4, -16) 
scrollbar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 4, 16) 
scrollbar:SetMinMaxValues(1, 16*BNGetNumFriends()) 
scrollbar:SetValueStep(1) 
scrollbar.scrollStep = 1
scrollbar:SetValue(0) 
scrollbar:SetWidth(16) 
scrollbar:SetScript("OnValueChanged", 
function (self, value) 
self:GetParent():SetVerticalScroll(value) 
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
button:SetPoint("TOPLEFT",_G["UnoFriendSelectButton" .. index-1],"BOTTOMLEFT",0,0);
button.name = bnetNameWithNumber;
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

scrollbar:SetMinMaxValues(1, 19*wowcount) 

end--end for

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
UnoProcessFrame:SetPoint("BOTTOM",UnoScreenLobby,"BOTTOM",0,20);
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
 UnoGuildiesFrameTitle:SetPoint("TOPLEFT",UnoScrollFrame,"BOTTOMLEFT",0,-25);
 UnoGuildiesFrameTitle:SetText("Guildies to invite");
 UnoGuildiesFrameTitle:Show();
 
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




end--end function UnoMakeLobbyFrames