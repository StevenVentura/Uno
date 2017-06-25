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

UnoSplash = UnoScreenSlashUno:CreateTexture();
UnoSplash:SetTexture("Interface/AddOns/Uno/images/unologo.tga")
UnoSplash:SetPoint("TOP");
UnoSplash:SetSize(80*2,60*2);
UnoSplash:Show();

CreateFrame("Button", "UnoMakeLobbyButton", UnoScreenSlashUno, "UIPanelButtonTemplate");
UnoMakeLobbyButton:SetSize(150,50);
UnoMakeLobbyButton:SetPoint("CENTER")
UnoMakeLobbyButton:SetScript("OnClick",function()
UnoScreenSlashUno:Hide();
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