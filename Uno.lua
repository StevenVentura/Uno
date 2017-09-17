--Author: Soccerbilly aka Gangsthurh (Steven Ventura)
--Date Created: 6/13/17
--purpose: uno game xd
--[[
9/6/17 2:04PM
current state:
it runs the invite button which opens the accept/decline window on the other screen. goal for today is to get the status icons working, also for bnet.

]]
Uno = CreateFrame("Frame");

--Uno:SetScript("OnEvent",function(self,event,...) self[event](self,event,...);end)
Uno:SetScript("OnUpdate", function(self, elapsed) UnoOnUpdate(self, elapsed) end)
Uno:RegisterEvent("VARIABLES_LOADED");




SLASH_Uno1 = "/Uno"; SLASH_Uno2 = "/cards";
SlashCmdList["Uno"] = slashUno;

function slashUno(msg,editbox)
command, rest = msg:match("^(%S*)%s*(.-)$");

end--end function
--local function taken from http://stackoverflow.com/questions/1426954/split-string-in-lua by user973713 on 11/26/15
function UnoSplitString(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; local i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


lagLess = 0;
UnoTimeDelayThing = 0.50;
function UnoOnUpdate(self, elapsed)
lagLess = lagLess + elapsed;
if (lagLess < UnoTimeDelayThing) then  return end
lagLess = 0;
--do stuff here
updateLobbyPlayers(elapsed);


end--end function UnoOnUpdate
function startTheUnoGame()
UnoScreenLobby:Hide();

UnoDrawClient();

end--end function startTheUnoGame()

--whispers
function unoMessageReceived(ChatFrameSelf, event, message, author, ...)
local sarray = UnoSplitString(message);
local remainder = string.sub(message,strlen(UNO_IDENTIFIER)+2);
print("remainder is " .. remainder)
if (sarray[1] ~= UNO_IDENTIFIER) then return end;

if (sarray[2] == UNO_STARTING) then

startTheUnoGame();
end

if (remainder == UNO_MESSAGE_HAS_ADDON) then
--TODO da name match the table?
UnoPlayers[author].userHasUnoOrNot = true;

end--end if UNO_MESSAGE_HAS_ADDON
if (remainder == UNO_MESSAGE_ACCEPT) then
UnoPlayers[author].userJoinedTheLobby = true;
updateUnoPlayersInLobbyList();
end--end if UNO_MESSAGE_ACCEPT
if (remainder == UNO_MESSAGE_SEND_INVITATION) then
print("ayy tho")
--u just got invited! send recognition , also begin da process
SendChatMessage(UNO_IDENTIFIER .. " " .. UNO_MESSAGE_HAS_ADDON,"WHISPER",nil,author);
UnoCurrentScreen = UNO_SCREEN_INVITATION;
--pop up da window
UnoInvitedToTheGame = CreateFrame("FRAME","UnoInvitedToTheGame",UIParent);
UnoInvitedToTheGame:SetPoint('CENTER',0,125)
local tex = UnoInvitedToTheGame:CreateTexture();
tex:SetAllPoints();
tex:SetTexture('Interface/AddOns/Uno/images/unologo.tga');
 titleText = UnoInvitedToTheGame:CreateFontString("titleText",UnoInvitedToTheGame,"GameFontNormal");
 titleText:SetTextColor(1,0.643,0.169,1);
 titleText:SetShadowColor(0,0,0,1);
 titleText:SetShadowOffset(2,-1);
 titleText:SetPoint("TOP",tex,"TOP",0,-5);
titleText:SetText("Play Uno with " .. author .. "?");
titleText:Show();

local acceptFrame = CreateFrame("Button", "UnoInvitedToTheGameAccept", UnoInvitedToTheGame, "UIPanelButtonTemplate");
acceptFrame:SetText("Accept Invite");
acceptFrame:SetPoint("CENTER",-108-22,-22);
acceptFrame:SetWidth(108);
acceptFrame:SetHeight(22);
acceptFrame:SetScript("OnClick", function() 
SendChatMessage(UNO_IDENTIFIER .. " " .. UNO_MESSAGE_ACCEPT,"WHISPER",nil,author);
UnoInvitedToTheGame:Hide();
end);
acceptFrame:SetBackdropBorderColor(0,0,1);--include alpha?
acceptFrame:SetBackdropColor(0,0,1);
UnoCurrentScreen = UNO_SCREEN_LOBBYGUEST;
--now we are in the lobby waiting
acceptFrame:Show();
local declineFrame = CreateFrame("Button", "UnoInvitedToTheGameDecline", UnoInvitedToTheGame, "UIPanelButtonTemplate");
declineFrame:SetText("Decline Invite");
declineFrame:SetPoint("CENTER",108+22,-22);
declineFrame:SetWidth(108);
declineFrame:SetHeight(22);
declineFrame:SetScript("OnClick", function() 
SendChatMessage(UNO_IDENTIFIER .. " " .. UNO_MESSAGE_DECLINE,"WHISPER",nil,author);
UnoCurrentScreen = UNO_SCREEN_BLANK;
UnoInvitedToTheGame:Hide();
end);
declineFrame:SetBackdropBorderColor(0,0,1);--include alpha?
declineFrame:SetBackdropColor(0,0,1);
declineFrame:Show();
UnoInvitedToTheGame:SetFrameStrata('HIGH');
UnoInvitedToTheGame:SetSize(400,200);
UnoInvitedToTheGame:Show();


end--end UNO_MESSAGE_SEND_INVITATION




end--end function unoMessageReceived



function updateLobbyPlayers(elapsed)
for _,boy in ipairs(UnoPlayers) do
--TODO how do i do dat
print(boy.userHasUnoOrNotTimer);
boy.userHasUnoOrNotTimer = boy.userHasUnoOrNotTimer + elapsed;
if (boy.userHasUnoOrNotTimer < 4.5 ) then
boy.statusIcon="unknown";
end--end if
if (boy.userHasUnoOrNotTimer > 4.5 and boy.userHasUnoOrNot == false) then
boy.statusIcon="download";
print("<Uno>: " .. boy .. " doesn't have the addon.");
end--end if
if (boy.userHasUnoOrNot == true) then
boy.statusIcon="question";
end--end if

end--end for


end--end function updateLobbyPlayers


function UnoIncoming(ChatFrameSelf, event, message, author, ...)





end--end function UnoIncoming

--this is called after the variables are loaded
function UnoInit()
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",unoMessageReceived);

end--end function UnoInit