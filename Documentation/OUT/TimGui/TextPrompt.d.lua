---@diagnostic disable: undefined-type
---@meta
---@class TextPrompt : Prompt : TWindow : ConfigObject : TClass
--[[Frame в котором находятся кнопки 'Подтвердить' и 'Отменить' ]]
--*[ReadOnly]*
---@field Buttons Frame
--[[Текст для кнопки отмены ]]
--*[ReadOnly]*
---@field CancelText TTranslator
--[[Кнопка отмены(берёт текст из `.CancelText`) ]]
--*[ReadOnly]*
---@field CancelButton TextButton
--[[Размер текста описания ]]
---@field DescriptionTextSize number
--[[То что находится в TextBox(если изменить изменится и там) ]]
---@field Value string
--[[TextLabel описания ]]
--*[ReadOnly]*
---@field DescriptionLabel TextLabel
--[[Может ли пользователь отменить? ]]
---@field CancelEnabled boolean
--[[Основной TextBox ]]
--*[ReadOnly]*
---@field TextBox TextBox
--[[Текст для кнопки подтверждения ]]
--*[ReadOnly]*
---@field ConfirmText TTranslator
--[[Кнопка подтверждения(берёт текст из `.ConfirmText`) ]]
--*[ReadOnly]*
---@field ConfirmButton TextButton
--[[Класс TextPrompt, чтобы спрашивать текст у пользователя. ]]
TextPrompt={}
---@type RBXScriptSignal
--[[Запускается когда обновился размер(описания и тд) и позиции ]]
    local OnSiz_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnSiz_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnSiz_RB:Once(callback:()->()) end
    
    function OnSiz_RB:Wait() end
TextPrompt['OnSizeRefreshed']=OnSiz_RB
---@type Bind
--[[Специальный Bind для установки размера описанию. Работает как в Binder.TextPromptDescriptionSizeBind ]]
    local Speci_Bind = {}
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function Speci_Bind:Bind(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@param TextPrompt TextPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function Speci_Bind:Run(TextPrompt: TextPrompt,startYPos: UDim) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@return TextPrompt TextPrompt
---@return UDim startYPos
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TextPrompt['SpecialDescriptionSizeBind']= Speci_Bind