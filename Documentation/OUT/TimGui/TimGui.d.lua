---@diagnostic disable: undefined-type
---@meta
---@class TimGui
--[[Класс для создания других классов👍 ]]
--*[ReadOnly]*
---@field Classes TClasses
--[[Класс для импорта других пакетов ]]
--*[ReadOnly]*
---@field Packages Packages
--[[Данные при старте TimGui, передаются в _G.Setup, подробнее в TimGuiSetupObject ]]
--*[ReadOnly]*
---@field SetupData table
--[[Главный интерфейс TimGui ]]
--*[ReadOnly]*
---@field ScreenGui ScreenGui
--[[Класс для изменения кнопки открытия в статус, например загрузка или ошибка(Блокирует открытие) ]]
--*[ReadOnly]*
---@field State GuiState
--[[Класс для кастомизации цветов ]]
--*[ReadOnly]*
---@field Colors Colors
--[[Открыто ли gui? Если false, то свёрнуто ]]
---@field Opened boolean
--[[Класс для настройки анимаций интерфейса ]]
--*[ReadOnly]*
---@field GuiAnimations GuiAnimations
--[[Класс для создания логгеров и чтения логов ]]
--*[ReadOnly]*
---@field Loggers Loggers
--[[Класс для смены размеров Gui ]]
--*[ReadOnly]*
---@field GuiSize GuiSize
--[[Класс для создания кнопок/групп в основном gui ]]
--*[ReadOnly]*
---@field GuiObjects GuiObjects
--[[Класс для смены ресурсов ]]
--*[ReadOnly]*
---@field Assets Assets
--[[Сохранения, проверка доступности сохранений ]]
--*[ReadOnly]*
---@field Saves Saves
--[[Класс для созадния Привязок к кнопкам, тоесть Key binds ]]
--*[ReadOnly]*
---@field KeyBinding KeyBinding
--[[Класс для замены стандартных функций (БОЛЬШЕ КАСТОМИЗАЦИИ) ]]
--*[ReadOnly]*
---@field Binder Binder
--[[Создания prompt окна(для того чтобы, что нибудь спросить у пользователя) ]]
--*[ReadOnly]*
---@field Prompts Prompts
--[[Группы, в которые можно ложить кнопки ]]
--*[ReadOnly]*
---@field Groups GUIArchitecture
--[[Текущая версия TGui в формате строки. Например 1.0.0 ]]
--*[ReadOnly]*
---@field Version string
--[[Класс для получения информации о конфигурациях(но не для изменения, если нужно изменить см. ControlCfg) ]]
--*[ReadOnly]*
---@field Configs Configs
--[[Директория в которой находятся файлы TGui(Ссылка или локально, можно определить через .httpGet_BaseDirIsLocal) ]]
--*[ReadOnly]*
---@field httpGet_BaseDir string
--[[Класс для созданий обьектов интерфейса ]]
--*[ReadOnly]*
---@field GuiInstances GuiInstances
--[[Массив с языковыми предпочтениями, например: ["ru","uk","en",...] ]]
---@field LanguagesPreference table<number,string>
--[[Глобально открытая группа(типо та которая в группах слево) ]]
--*[ReadOnly]*
---@field GlobalOpenedGroup TGroup
--[[Текущая версия ядра TGui в формате строки. Например 3.0.0 ]]
--*[ReadOnly]*
---@field CoreVersion string
--[[Был ли :Exit() запущен, тоесть закрыт ли TimGui ]]
--*[ReadOnly]*
---@field Closed boolean
--[[Класс для кастомизации заголовка ]]
--*[ReadOnly]*
---@field Header Header
--[[ScreenGui в котором находятся меню(должно быть поверх основного ScreenGui) ]]
--*[ReadOnly]*
---@field MenuScreenGui ScreenGui
--[[Текущая версия TGui. Например 1 ]]
--*[ReadOnly]*
---@field BuildCount number
--[[httpGet_BaseDir локальная или нет? ]]
--*[ReadOnly]*
---@field httpGet_BaseDirIsLocal boolean
--[[Текущая версия ядра TGui. Например 1 ]]
--*[ReadOnly]*
---@field CoreBuildCount number
--[[Главный обьект ВСЕЙ системы TGui. Можно получить с помощью _G.TimGui ]]
TimGui={}
--[[Сравнивает имя класса с 1 параметром ]]
---@param className string Имя класса для сравнения
---@return boolean response Является ли потомком этого класса(или самим классом)
function TimGui:IsA(className) end
--[[Получает данные из инета. Если начинается на './', то получает из директории скрипта ]]
---@param URL string Ссылка для получение.
---@return string? response Результат
function TimGui:HttpGet(URL) end
--[[Возвращает позицию TimGui, для выбранного состояния ]]
---@param Opened? boolean Нужное состояние(открыто ли). Если nil, то получает для текущего состояния
---@return UDim2 Position Позиция
function TimGui:GetFrameGuiPosition(Opened) end
--[[Создаёт TScript или получает уже созданный с этим именем (если можно) ]]
---@param scriptName string Имя скрипта, должно быть уникальным, иначе выдаст ошибку(если нет доступа)
---@param allowToLoadTwice? boolean Если `true`, то позволяет загрузить скрипт повторно
---@return TScript response TScript
function TimGui:GetTScript(scriptName,allowToLoadTwice) end
--[[Изменяет языковые предпочтения ]]
---@param langCodes table<number,string> Массив с языковыми предпочтениями, например: ["ru","uk","en",...]
function TimGui:SetLanguagePreferences(langCodes) end
--[[Закрывает TimGui(выходит), и запускает .OnExit event ]]
function TimGui:Exit() end
--[[Получает данные из инета. Если начинается на './', то получает из директории скрипта. Но с попытками при ошибке ]]
---@param URL string Ссылка для получение.
---@param attemptsCount? number Количество попыток
---@return string? response Результат
function TimGui:BetterHttpGet(URL,attemptsCount) end
---@type RBXScriptSignal
--[[Запускается если TimGui:Exit() запущен, чтобы закрыть GUI ]]
    local OnExi_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnExi_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnExi_RB:Once(callback:()->()) end
    
    function OnExi_RB:Wait() end
TimGui['OnExit']=OnExi_RB
---@type RBXScriptSignal
--[[Запускается если языковые предпочтения изменились ]]
    local Langu_RB = {}
    ---@param callback fun(langCodes:table)
    ---@return RBXScriptConnection
    function Langu_RB:Connect(callback:(langCodes:table)->()) end
    ---@param callback fun(langCodes:table)
    ---@return RBXScriptConnection
    function Langu_RB:Once(callback:(langCodes:table)->()) end
    ---@return table<number,string> langCodes
    function Langu_RB:Wait() end
TimGui['LanguageChanged']=Langu_RB
---@type RBXScriptSignal
--[[Запускается если TimGui.Opened изменился ]]
    local OnOpe_RB = {}
    ---@param callback fun(isOpened:boolean)
    ---@return RBXScriptConnection
    function OnOpe_RB:Connect(callback:(isOpened:boolean)->()) end
    ---@param callback fun(isOpened:boolean)
    ---@return RBXScriptConnection
    function OnOpe_RB:Once(callback:(isOpened:boolean)->()) end
    ---@return boolean isOpened
    function OnOpe_RB:Wait() end
TimGui['OnOpened']=OnOpe_RB
---@type RBXScriptSignal
--[[Запускается когда глобально открытая группа изменилась ]]
    local Globa_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Globa_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Globa_RB:Once(callback:()->()) end
    
    function Globa_RB:Wait() end
TimGui['GlobalOpenedGroupChanged']=Globa_RB
---@type RBXScriptSignal
--[[Запускается когда TimGui полностью загружен ]]
    local OnLoa_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnLoa_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnLoa_RB:Once(callback:()->()) end
    
    function OnLoa_RB:Wait() end
TimGui['OnLoaded']=OnLoa_RB