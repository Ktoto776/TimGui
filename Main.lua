--[[
Please, use this script(for updates):

loadstring(game:HttpGet("https://raw.githubusercontent.com/Robloxer228s/TimGUI/main/Main.lua"))()

]] local GSetup = _G.Setup or {}
local Setup = {
    linkToDir= GSetup.linkToDir or "https://raw.githubusercontent.com/Robloxer228s/TimGUI/main/"
}
local isLocalDir = not (string.find(Setup.linkToDir,"http") and string.find(Setup.linkToDir,"://"))
local printText = "TimGui starting"
if isLocalDir then
    printText = printText.." from local dir: "..Setup.linkToDir
end--Open function
local function Open()
    local script print(printText)
    if GSetup.HttpGet then
        script = GSetup.HttpGet("./TimGui.lua")
    else if isLocalDir then
            script = readfile(Setup.linkToDir.."TimGUI.lua")
        else script = game:HttpGet(Setup.linkToDir.."TimGui.lua")
        end loadstring(script)()
    end
end
--Start
if not _G.TimGui then
    Open()
else Open()
end