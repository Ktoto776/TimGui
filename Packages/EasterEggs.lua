--[[TPackage
    Version: 1.0;
    TimGuiVersion: 3.0.0;
    Description: This is package for EasterEggs in Menu! You can add your custom EasterEgg from addons
]] ---@type TimGui
local TimGui = _G.TimGui
local logger -- Сделай логгер
local HttpService = game:GetService("HttpService")
TimGui.OnExit.True = 12
local EasterClass = TimGui.Classes:CreateTClass()
EasterClass:AddClassName("EasterEggs")
local s,Easter = pcall(function()
    return HttpService:JSONDecode(TimGui:HttpGet("./data/eastereggs.json"))
end) EasterClass.Success = s
-- Сделай документацию для этого пакета
-- Сделай global'ы пакетам, например global "PacketData": содержащий путь к пакету, имя пакета(то как назвал юзер), данные из начала скрипта
-- Измени систему пакетов, сделай Package один на каждый пакет(а на на каждый запуск :GetPackage()). Добавь в Package:Require() и Package.Required: boolean?
-- Сделай загрузку аддонов через _G.Setup
-- Можно сделать свой стилер(неее, не этот. А тот который ворует кнопки из других скриптов) в читы, который будет загружать меню и воровать от туда кнопки(устанавливать размер и позиции в TGui кнопку, но отказаться от KeyBind'ов)
-- "Зачем делать свои скрипты, если можно в наглую своровать?"

local Loaded = false
local Headers = {}
function EasterClass:GetHeaders()
    local HeadersClone = {}
    for k,v in Headers do
        HeadersClone[k] = v
    end return HeadersClone
end local HeadersMaxChance = 0
function EasterClass:AddHeader(HeaderData)
    if Loaded then logger:error("EasterEggs:AddHeader","Header is loaded!") return end
    HeadersMaxChance += HeaderData.Chance
    local Header = TimGui.Classes:CreateTClass()
    Header:AddClassName("Header")
    Header.AbsoluteChance = HeadersMaxChance
    --- Я НЕ ДОДЕЛАЛ ИЗЗА ГОВНА ДОКУМЕНТАЦИИ ---@type и установка параметра меняет всему классу глобально значение этого параметра!, а без него норм. Просто сделай TClasses
    table.insert(Headers,Header)
end
if s then
    local EasterSave = TimGui.Saves:GetSave("EasterEggs")
    ---@type number
    local HeaderStartCount = (EasterSave:GetFromSave("HeaderStartCount") or -1)+1
    EasterClass.HeaderStartCount = HeaderStartCount
    EasterClass.HeaderTitleChancePercent = Easter.HeaderTitlesPercent+(EasterClass.HeaderStartCount)*Easter.HeaderTitlesPercentPerStart
    EasterClass.HeaderTitleChanged = (EasterClass.HeaderTitleChancePercent/100)<math.random()
    for _,v in pairs(Easter.HeaderTitles) do
        EasterClass:AddHeader(v)
    end 
    if EasterClass.HeaderTitleChanged then
        -- Тут смени заголовок на "Easter | egg...", типо чтоб юзер знал, что грузится пасхалка
        HeaderStartCount = 0
    end
    EasterSave:SetToSave("HeaderStartCount",HeaderStartCount)
end
function EasterClass:Load() -- Запусти в конце всего запуска TimGui(запуска аддонов итд)
    logger:debug("Loading easter")
    Loaded = true
    if s and EasterClass.HeaderTitleChanged then
        logger:info("Load EasterEggs","Header is changed!")
        local HeaderChance = math.random(1,HeadersMaxChance)
        local Header for k,v in Headers do
            if HeaderChance<=v.AbsoluteChance then
                Header = v break
            end
        end -- Header выбранный текст
    end
end

return EasterClass