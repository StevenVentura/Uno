--Author: Soccerbilly aka Gangsthurh (Steven Ventura)
--Date Created: 6/13/17
--purpose: addon template
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


end--end function UnoOnUpdate



function UnoIncoming(ChatFrameSelf, event, message, author, ...)





end--end function UnoIncoming

--this is called after the variables are loaded
function UnoInit()
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",UnoIncoming);

end--end function UnoInit