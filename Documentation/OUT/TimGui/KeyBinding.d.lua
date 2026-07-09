---@diagnostic disable: undefined-type
---@meta
---@class KeyBinding : TClass
--[[Если `true`, то блокирует следующее нажатие кнопки. Служит, чтобы автокликеры не вызывали KeyBind'ы ]]
---@field NextBlocked boolean
--[[Если `false`, то не реагирует на нажатие кнопки ]]
---@field EventsEnabled boolean
--[[Класс для создания привязок к кнопкам и находится в TimGui.KeyBinding. Кнопка мыши: 1-Левая,2-Правая,3-Колёсико ]]
KeyBinding={}
--[[Создаёт KeybindObject ]]
---@return KeybindObject result KeybindObject класс, должен использоваться в Keybinder для назначения ключа к функции
function KeyBinding:CreateKeybindObject() end
--[[Создаёт Keybinder ]]
---@param Name string Название keybinder'у
---@param Title? string | table<string,string> | TTranslator Заголовок
---@param disableDefaultConfigSettingsRefreshForWindow? boolean Выключены ли стандартное обновление сохранений при смене настроек конфига для окна
---@return Keybinder result Keybinder класс, нужен для назначения разных типов функций к разным кнопкам
function KeyBinding:CreateKeybinder(Name,Title,disableDefaultConfigSettingsRefreshForWindow) end
--[[Возвращает TSignal, запускаемый нажатием или разжатием этой кнопки ]]
---@param KeyName string Название кнопки
---@return TKey Key Запускается если эта кнопка нажата или отжата. Запускает с параметрами как в `KeyBinding.KeyEvent`
function KeyBinding:GetKeyEvent(KeyName) end
--[[Возвращает TSignal, запускаемый разжатием этой кнопки ]]
---@param KeyName string Название кнопки
---@return TKey Key Запускается если эта кнопка отжата. Запускает с параметрами как в `KeyBinding.Ended`
function KeyBinding:GetKeyEndedEvent(KeyName) end
--[[Создаёт ключ кнопки клавиатуры(TKey) ]]
---@param KeyCode Enum.KeyCode KeyCode
---@param Holding? table<string,boolean> Таблица нажатых специальные кнопок, где ключ - название, значение - boolean(зажато ли?)
---@return TKey Key результат
function KeyBinding:CreateKeyboardKey(KeyCode,Holding) end
--[[Создаёт ключ кнопки клавиатуры(TKey) ]]
---@param MouseCode number Кнопка мыши от 1 до 3(включительно)
---@param Holding? table<string,boolean> Таблица нажатых специальные кнопок, где ключ - название, значение - boolean(зажато ли?)
---@return TKey Key результат
function KeyBinding:CreateMouseKey(MouseCode,Holding) end
--[[Возвращает имя ключа по KeyCode ]]
---@param KeyCode Enum.KeyCode KeyCode
---@return string KeyName Имя ключа
function KeyBinding:GetKeyNameFromKeyCode(KeyCode) end
--[[Возвращает TSignal, запускаемый нажатием этой кнопки ]]
---@param KeyName string Название кнопки
---@return TKey Key Запускается если эта кнопка нажата. Запускает с параметрами как в `KeyBinded.Began`
function KeyBinding:GetKeyBeganEvent(KeyName) end
---@type TSignal
--[[Event, запускаемый когда кнопка нажата ]]
    local Began_TS = {}
    ---@param callback fun(Key:TKey,GPE:boolean)
    ---@return RBXScriptConnection
    function Began_TS:Connect(callback:(Key:TKey,GPE:boolean)->()) end
    ---@param callback fun(Key:TKey,GPE:boolean)
    ---@return RBXScriptConnection
    function Began_TS:Once(callback:(Key:TKey,GPE:boolean)->()) end
    ---@return TKey Key
---@return boolean GPE
    function Began_TS:Wait() end
KeyBinding['Began']=Began_TS
---@type TSignal
--[[Event, запускаемый когда специальная кнопка нажата/отжата (Игнорирует `NextBlocked` и `EventsEnabled`) ]]
    local Speci_TS = {}
    ---@param callback fun(input:InputObject,GPE:boolean)
    ---@return RBXScriptConnection
    function Speci_TS:Connect(callback:(input:InputObject,GPE:boolean)->()) end
    ---@param callback fun(input:InputObject,GPE:boolean)
    ---@return RBXScriptConnection
    function Speci_TS:Once(callback:(input:InputObject,GPE:boolean)->()) end
    ---@return InputObject input
---@return boolean GPE
    function Speci_TS:Wait() end
KeyBinding['SpecialKeyEvent']=Speci_TS
---@type TSignal
--[[Event, запускаемый когда кнопка отжата ]]
    local Ended_TS = {}
    ---@param callback fun(Key:TKey,GPE:boolean)
    ---@return RBXScriptConnection
    function Ended_TS:Connect(callback:(Key:TKey,GPE:boolean)->()) end
    ---@param callback fun(Key:TKey,GPE:boolean)
    ---@return RBXScriptConnection
    function Ended_TS:Once(callback:(Key:TKey,GPE:boolean)->()) end
    ---@return TKey Key
---@return boolean GPE
    function Ended_TS:Wait() end
KeyBinding['Ended']=Ended_TS
---@type TSignal
--[[Event, запускаемый когда кнопка нажата/отжата (Игнорирует `NextBlocked` и `EventsEnabled`) ]]
    local KeyEv_TS = {}
    ---@param callback fun(Key:TKey,GPE:boolean,input:InputObject)
    ---@return RBXScriptConnection
    function KeyEv_TS:Connect(callback:(Key:TKey,GPE:boolean,input:InputObject)->()) end
    ---@param callback fun(Key:TKey,GPE:boolean,input:InputObject)
    ---@return RBXScriptConnection
    function KeyEv_TS:Once(callback:(Key:TKey,GPE:boolean,input:InputObject)->()) end
    ---@return TKey Key
---@return boolean GPE
---@return InputObject input
    function KeyEv_TS:Wait() end
KeyBinding['KeyEvent']=KeyEv_TS