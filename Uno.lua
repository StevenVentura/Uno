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
function UnoOnUpdate(self, elapsed)
updateLobbyPlayers(elapsed);



end--end function UnoOnUpdate


--whispers
function UNO_WHISPER_RECEIVED(ChatFrameSelf, event, message, author, ...)



UnoAbstractMessageReceived(message,author);

end--end function UNO_WHISPER_RECEIVED

function UnoAbstractMessageReceived(message, author, pid)
local sarray = UnoSplitString(message);
local remainder = string.sub(message,strlen(UNO_IDENTIFIER)+2);
print("remainder is " .. remainder)
print("author is " .. author);
--return and do nothing if its not an addon message.
if (sarray[1] ~= UNO_IDENTIFIER) then return end;

if (sarray[2] == UNO_STARTING and UnoCurrentScreen ~= UNO_SCREEN_BLANK) then
if (UnoClientLobbyScreen) then UnoClientLobbyScreen:Hide() end;
--populate the client players array
local numOtherPlayers = tablelength(sarray) - 2;
for i=1,numOtherPlayers do
local playerName = sarray[i+2];
AddUnoPlayerClientPlaying(playerName,i);

print("welcome " .. playerName .. " to your game xd")
end--end for

UnoClientTheHostsIdentification = author;
print("the hosts id is " .. UnoClientTheHostsIdentification)
startTheUnoGame();
end--end UNO_STARTING

--client code
if (sarray[2] == UNO_MESSAGE_CARDUPDATE and UnoCurrentScreen == UNO_SCREEN_PLAYINGGAME) then
local numCardUpdates = (tablelength(sarray) - 2)/2;
for i=1,numCardUpdates,1 do
local cardIndex = tonumber(sarray[((i-1)*2+3)]); 
local newOwner = sarray[((i-1)*2+4)];
UnoClientCards[cardIndex].owner = newOwner;
UnoUpdatePositions();
--UnoPositionCard(UnoClientCards[cardIndex]);
end--end for
end--end if UNO_MESSAGE_CARDUPDATE



if (remainder == UNO_MESSAGE_HAS_ADDON and UnoCurrentScreen == UNO_SCREEN_LOBBY) then
--TODO da name match the table?
UnoPlayers[author].userHasUnoOrNot = true;
updateUnoInvitationStatusList();
end--end if UNO_MESSAGE_HAS_ADDON
if (remainder == UNO_MESSAGE_ACCEPT and UnoCurrentScreen == UNO_SCREEN_LOBBY) then
UnoPlayers[author].userJoinedTheLobby = true;
updateUnoInvitationStatusList();
updateUnoPlayersInLobbyList();
end--end if UNO_MESSAGE_ACCEPT
if (remainder == UNO_MESSAGE_DECLINE and UnoCurrentScreen == UNO_SCREEN_LOBBY) then
UnoPlayers[author].userDeclinedTheInvite = true;
updateUnoInvitationStatusList();

end



if (remainder == UNO_MESSAGE_SEND_INVITATION and (UnoCurrentScreen == UNO_SCREEN_BLANK or 
												  UnoCurrentScreen == UNO_SCREEN_SLASHUNO )) then

print("|cff0088ffauthor is " .. author);
UnoHostContact = { };
if (pid) then
UnoHostContact.contactType = UNO_CONTACT_BTAG;
UnoHostContact.pid = pid;
AddUnoPlayerClientLobby("bnethashtag",author,pid);
else
UnoHostContact.contactType = UNO_CONTACT_WHISPER;
UnoHostContact.whisperName = author;
AddUnoPlayerClientLobby("nameserver",author);
end





--u just got invited! send recognition , also begin da process
UnoMessage(UnoPlayersClientLobby[author],UNO_IDENTIFIER .. " " .. UNO_MESSAGE_HAS_ADDON);
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
--now we are in the lobby waiting
UnoCurrentScreen = UNO_SCREEN_LOBBYGUEST;
UnoClientDisplayLobbyGuestScreen();
UnoMessage(UnoPlayersClientLobby[author], UNO_IDENTIFIER .. " " .. UNO_MESSAGE_ACCEPT);
UnoInvitedToTheGame:Hide();
end);
acceptFrame:SetBackdropBorderColor(0,0,1);--include alpha?
acceptFrame:SetBackdropColor(0,0,1);

acceptFrame:Show();
local declineFrame = CreateFrame("Button", "UnoInvitedToTheGameDecline", UnoInvitedToTheGame, "UIPanelButtonTemplate");
declineFrame:SetText("Decline Invite");
declineFrame:SetPoint("CENTER",108+22,-22);
declineFrame:SetWidth(108);
declineFrame:SetHeight(22);
declineFrame:SetScript("OnClick", function() 
UnoMessage(UnoPlayersClientLobby[author],UNO_IDENTIFIER .. " " .. UNO_MESSAGE_DECLINE);
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
end--end UnoAbstractMessageReceived


function updateLobbyPlayers(elapsed)
for name,boy in pairs(UnoPlayers) do
if (boy.userHasUnoOrNotTimer < 5.0) then
boy.userHasUnoOrNotTimer = boy.userHasUnoOrNotTimer + elapsed;
if (boy.userHasUnoOrNotTimer > 5.0) then
updateUnoInvitationStatusList()
end--end > 5

end--end < 5

end--end for


end--end function updateLobbyPlayers

function UnoFindBtagFromRealID(realID)
for index = 1, BNGetNumFriends() do
local presenceID,glitchyAccountName,bnetNameWithNumber,isJustBNetFriend,characterName,uselessnumber,game = BNGetFriendInfo( index );
if (realID == glitchyAccountName) then return bnetNameWithNumber end--end if
end--end for
end--end function UnoFindBtagFromRealID

function UNO_CHAT_MSG_BN_WHISPER(tableThing,uselessCHAT_MSG_BN_WHISPER
						,message,sender,u3,u4,u5,u6,u7,u8,u9,u10,presenceLie,u11,presenceID,u13)


--use nickname lookup instead of full RealID for privacy reasons
if (UnoPlayers[sender] == nil) then
for name,playerObject in pairs(UnoPlayers) do
if (playerObject.isRealIDNotJustBNet and playerObject.realName == sender) then
sender = playerObject.name;
end--end if
end--end if
end--end for

--[[check if it hasnt been added to players yet -- should only happen 1 time per person.
in order to correspond with <<if (remainder == UNO_MESSAGE_SEND_INVITATION) then>>
]]
if (UnoPlayers[sender] == nil) then
sender = UnoFindBtagFromRealID(sender);
end--end if
UnoAbstractMessageReceived(message,sender,presenceID);
end --end function unochatbnet

--this is called after the variables are loaded
function UnoInit()
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",UNO_WHISPER_RECEIVED);
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER",UNO_CHAT_MSG_BN_WHISPER);
end--end function UnoInit