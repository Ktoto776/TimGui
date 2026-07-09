---@diagnostic disable: undefined-type
---@meta
---@class Keybinder : TClass
--[[Включено ли сохранение? если оно выключено через конфиг, а тут `true`, то сохраняться не будет ]]
---@field SaveEnabled boolean
--[[Специальные цвета, связаны с специальными цветами у окна ]]
--*[ReadOnly]*
---@field SpecialColors SpecialColors
--[[Открыто ли окно? ]]
---@field Opened boolean
--[[`EventType` по умолчанию ]]
---@field DefaultType string
--[[Основной ScrollingFrame в котором находятся keybind'ы ]]
--*[ReadOnly]*
---@field KeybindsScroll ScrollingFrame
--[[Включено ли автосохранение? если оно выключено через конфиг, а тут `true`, то автосохраняться не будет ]]
---@field AutosaveEnabled boolean
--[[Название окна ]]
--*[ReadOnly]*
---@field Title TTranslator
--[[TextLabel, содержащий Title ]]
--*[ReadOnly]*
---@field TitleLabel TextLabel
--[[Frame с кнопками ]]
--*[ReadOnly]*
---@field Buttons Frame
--[[Выключено ли сохранение изза того, что имя уже используется? ]]
--*[ReadOnly]*
---@field SavingDisabledByName boolean
--[[Имя keybinder'а, задаётся только при создании ]]
--*[ReadOnly]*
---@field Name string
--[[Окно keybinder'а ]]
--*[ReadOnly]*
---@field Window TWindow
--[[Класс Keybinder, нужен для назначения клавиш с разными режимами ]]
Keybinder={}
--[[Возвращает все Keybind'ы этого Keybinder'а ]]
---@return table<number,KeybindObject> Keybinds Таблица с Keybind'ами
function Keybinder:GetKeybinds() end
--[[Создаёт KeybindObject с `.Parent` в этом binder'е ]]
---@return KeybindObject result KeybindObject
function Keybinder:CreateKeybind() end
--[[Возвращает таблицу с именами эвентов ]]
---@return table<number,string> Keybinds Таблица с именами эвентов
function Keybinder:GetEventNames() end
--[[Добавляет EventType в Keybinder ]]
---@param name string Имя эвента, которое будет участвоваться в `.Event`
---@param title string | table<string,string> | TTranslator Заголовок для EventType
function Keybinder:AddEventType(name,title) end
--[[Удаляет Keybinder ]]
function Keybinder:Destroy() end
--[[Загружает Keybinds из config ]]
---@return boolean success Успешно ли загружено?
function Keybinder:LoadFromConfig() end
--[[Возвращает таблицу Keybind'ов этого Keybinder'а, чтобы сохранять её своими способами ]]
---@return table<number,table> Keybinds Таблица с данными всех Keybind'ов
function Keybinder:GetKeybindsTable() end
--[[Обновляет позиции в Keybinder'е ]]
function Keybinder:RefreshPositions() end
--[[Спрашивает у пользователя EventType этого Keybinder'а ]]
---@param Position UDim2 В какой позиции показать меню выбора
---@param selected? string Выбранный EventType(чтобы он был в начале списка)
---@return string? EventType EventType, которое выбрал пользователь. nil-если пользователь отменил или выбрал, то что уже стоит
function Keybinder:AskEventType(Position,selected) end
--[[Возвращает заголовок EventType'а ]]
---@param name string Имя эвента
---@return TTranslator Title Заголовок этого эвента
function Keybinder:GetEventTypeTitle(name) end
--[[Сохраняет Keybinds в config, если включено через конфиг и `Keybinder.SaveEnabled==true` ]]
---@return boolean success Успешно ли сохранено?
function Keybinder:SaveToConfig() end
--[[Загружает из таблицы Keybind'ов ]]
---@param Keybinds table<number,table> Таблица с данными Keybind'ов
---@return boolean success Успешно ли загружено?
function Keybinder:LoadKeybindsTable(Keybinds) end
--[[Спрашивает ключ от лица этого Keybinder ]]
---@param Description table<string,string> Описание,которое видит пользователь, для выбора ключа. Таблица где ключ- код языка, а значение перевод({"en":"English","ru":"Русский"})
---@return TKey result Ключ(кнопка), которую выбрал пользователь
function Keybinder:AskKey(Description) end
---@type RBXScriptSignal
--[[Эвент, который запускается если изменился перевод заголовка какого либо EventType ]]
    local Event_RB = {}
    ---@param callback fun(EventType:string)
    ---@return RBXScriptConnection
    function Event_RB:Connect(callback:(EventType:string)->()) end
    ---@param callback fun(EventType:string)
    ---@return RBXScriptConnection
    function Event_RB:Once(callback:(EventType:string)->()) end
    ---@return string EventType
    function Event_RB:Wait() end
Keybinder['EventTypeTranslateRefresh']=Event_RB
---@type TSignal
--[[Эвент, который запускается при запуске любого `BaseKeybind.Event` в этом Keybinder'е ]]
    local Event_TS = {}
    ---@param callback fun(EventType:string,Keybind:KeybindObject,Input?:InputObject,GPE?:boolean)
    ---@return RBXScriptConnection
    function Event_TS:Connect(callback:(EventType:string,Keybind:KeybindObject,Input:InputObject?,GPE:boolean?)->()) end
    ---@param callback fun(EventType:string,Keybind:KeybindObject,Input?:InputObject,GPE?:boolean)
    ---@return RBXScriptConnection
    function Event_TS:Once(callback:(EventType:string,Keybind:KeybindObject,Input:InputObject?,GPE:boolean?)->()) end
    ---@return string EventType
---@return KeybindObject Keybind
---@return InputObject? Input
---@return boolean? GPE
    function Event_TS:Wait() end
Keybinder['Event']=Event_TS