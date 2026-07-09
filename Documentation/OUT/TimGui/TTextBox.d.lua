---@diagnostic disable: undefined-type
---@meta
---@class TTextBox : TextboxObject : TextObject : TGuiObject : ConfigObject : TClass
--[[Тип ввода, может быть `string`(по умолчаню),`number`. Если не поддерживается, то будет восприниматься как `string` ]]
---@field InputType string
--[[Значение ]]
--*[Exception for WriteSameMode]*
---@field Value string
--[[Кнопки `+` и `-` ]]
--*[ReadOnly]*
---@field Buttons Frame
--[[Размер изменения через кнопки ]]
---@field ScaleOfButtons number
--[[Равен `TextBox`. Нужен для определения типа обьекта ]]
--*[ReadOnly]*
---@field Type string
--[[Стандартное значения, изменяется на `.Value` через `task.wait()` ]]
---@field DefaultValue string | number
--[[Включены ли кнопки? ]]
---@field ButtonsEnabled boolean
--[[TGuiObject класс с TextBox, позволяющий пользователю вводить текст/цифры ]]
TTextBox={}
--[[Запускает кнопку около ввода ]]
---@param ButtonType string Тип кнопки: "add" или "subtract"
function TTextBox:FireButton(ButtonType) end
---@type RBXScriptSignal
--[[Запускается когда кнопка была нажата(или запущен `:FireButton(...)`) ]]
    local Butto_RB = {}
    ---@param callback fun(ButtonType:string)
    ---@return RBXScriptConnection
    function Butto_RB:Connect(callback:(ButtonType:string)->()) end
    ---@param callback fun(ButtonType:string)
    ---@return RBXScriptConnection
    function Butto_RB:Once(callback:(ButtonType:string)->()) end
    ---@return string ButtonType
    function Butto_RB:Wait() end
TTextBox['ButtonClicked']=Butto_RB
---@type RBXScriptSignal
--[[Запускается когда `.Value` изменилось ]]
    local Chang_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Chang_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Chang_RB:Once(callback:()->()) end
    
    function Chang_RB:Wait() end
TTextBox['Changed']=Chang_RB
---@type Bind
--[[Специальный бинд для установки позиции названия и поля для ввода, работает как в Binder.RefreshTextBoxSizes ]]
    local Speci_Bind = {}
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---*return ()*
    function Speci_Bind:Bind(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@param TTextBox TTextBox
---@param TextLabel TextLabel
---@param TextBox TextBox
    function Speci_Bind:Run(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@return TTextBox TTextBox
---@return TextLabel TextLabel
---@return TextBox TextBox
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TTextBox['SpecialRefreshTextBoxSizes']= Speci_Bind