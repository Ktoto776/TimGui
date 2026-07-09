--[[TPackage
    Version: 1.0;
    TimGuiVersion: 3.0.0;
    Description: This is package for EasterEggs in Menu! You can add your custom EasterEgg from addons
]] local EasterSettings = {
    HeaderTitlesChancePerStart=0.002,
    HeaderTitlesChance=0.01
} ---@type TimGui
local TimGui = _G.TimGui
---@type BetterGUI
local BetterGUI = TimGui.Packages:Require("BetterGUI")
local HttpService = game:GetService("HttpService")

local isDebug = true
local script = TimGui:GetTScript("EasterEggs",isDebug)
script.Logger.debugEnabled = isDebug

local EasterClass = TimGui.Classes:CreateTClass()
EasterClass:AddClassName("EasterClass")
---@type table<number,EasterHeaderTitle>
local HeaderTitles = {}
---@type table<string,BindableEvent>
local HeaderSelectedEvents = {}
function EasterClass:CreateHeaderTitle(Id:string,FirstPart:string|{[string]:string}|table,SecondPart:string|{[string]:string}|table)
    if HeaderSelectedEvents[Id] then script.Logger:critical_error("Id is already used. Select other Id","EasterClass:CreateHeaderTitle") end
    local HeaderTitle = TimGui.Classes:CreateTClass()
    HeaderTitle:AddClassName("EasterHeaderTitle")
    HeaderTitle.Id = Id HeaderTitle:SetReadOnly("Id")
    HeaderTitle.FirstPart = BetterGUI:ConvertToTranslator(FirstPart)
    HeaderTitle.SecondPart = BetterGUI:ConvertToTranslator(SecondPart)
    HeaderTitle:SetReadOnly("FirstPart")
    HeaderTitle:SetReadOnly("SecondPart")
    HeaderTitle.Chance = 100
    local selectedEvent = Instance.new("BindableEvent")
    HeaderSelectedEvents[Id] = selectedEvent
    HeaderTitle.OnSelected = selectedEvent.Event
    table.insert(HeaderTitles,HeaderTitle)
    return HeaderTitle
end local titleSelected = false
local function SelectTitle()
    if titleSelected then script.Logger:critical_error("Header title already selected!","SelectTitle") end
    titleSelected = true local maxChance,minChance = 0,0
    for _,HT in HeaderTitles do
        if k==1 then minChance = HT.Chance end
        maxChance += math.max(HT.Chance,1)
    end if maxChance==0 then return script.Logger:debug("0 HeaderTitles founded :<") end
    local chance = math.random(minChance,maxChance)
    local absChance = 0
    local selected print(maxChance,chance)
    for _,HT in HeaderTitles do
        absChance += HT.Chance
        if absChance>=chance then
            selected = HT
            break
        end 
    end TimGui.Header.FirstName:Load(selected.FirstPart:GetPreset())
    TimGui.Header.SecondName:Load(selected.SecondPart:GetPreset())
    HeaderSelectedEvents[selected.Id]:Fire()
end

-- Getting easters
local s,Easters:{
    HeaderTitles:{
        {Id:string,Part1:table,Part2:table,Chance:number}
    },EasterDate:{string}
} = pcall(function()
    return HttpService:JSONDecode(TimGui:BetterHttpGet("./data/eastereggs.json"))
end) EasterClass.DefaultIsLoaded = s
EasterClass:SetReadOnly("DefaultIsLoaded")
if s then
    for _,v in Easters.HeaderTitles do
        script.Logger:debug("Loading: "..v.Id)
        local HT = EasterClass:CreateHeaderTitle(v.Id,v.Part1,v.Part2)
        if v.Chance then HT.Chance = v.Chance end
    end
else script.Logger:warn("Error to load Easters: "..Easters)
end
-- Is easter?
local date = os.date("%d %m %Y")
local isEaster = false
if s then
    for _,v in Easters.EasterDate do
        if v==date then
            isEaster = true
            script.Logger:info("EASTER NOW!!!!!!! (Easter eggs X2)")
            break
        end
    end
end

-- Change Header
local HeaderTitleRunCount:number = (tonumber(script:GetFromSave("HeaderTitleRunCount"))or 0)+1
local HeaderEasterChance = EasterSettings.HeaderTitlesChance+ (HeaderTitleRunCount*EasterSettings.HeaderTitlesChance)
local HeaderEasterSelectedChance = math.random()
if isEaster then HeaderEasterSelectedChance /= 2 end
if isDebug then HeaderEasterSelectedChance /= 10 end
script.Logger:debug("Randomize header")
if HeaderEasterSelectedChance<HeaderEasterChance then
    script.Logger:info("SECRET HEADER TITLE!")
    TimGui.OnLoaded:Once(SelectTitle)
    script:SetToSave("HeaderTitleRunCount",0)
else script:SetToSave("HeaderTitleRunCount",HeaderTitleRunCount)
end

return EasterClass