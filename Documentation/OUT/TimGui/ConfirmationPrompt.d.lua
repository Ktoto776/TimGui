---@diagnostic disable: undefined-type
---@meta
---@class ConfirmationPrompt : Prompt : TWindow : ConfigObject : TClass
--[[Размер текста описания ]]
---@field DescriptionTextSize number
--[[Кнопка отклонения(берёт текст из `.RejectText`) ]]
--*[ReadOnly]*
---@field RejectButton TextButton
--[[TextLabel описания ]]
--*[ReadOnly]*
---@field DescriptionLabel TextLabel
--[[Frame в котором находятся кнопки 'Подтвердить' и 'Отклонить' ]]
--*[ReadOnly]*
---@field Buttons Frame
--[[Может ли пользователь отменить, через кнопку закрытия окна? ]]
---@field CancelEnabled boolean
--[[Кнопка подтверждения(берёт текст из `.ConfirmText`) ]]
--*[ReadOnly]*
---@field ConfirmButton TextButton
--[[Текст для кнопки подтверждения ]]
--*[ReadOnly]*
---@field ConfirmText TTranslator
--[[Текст для кнопки отклонения ]]
--*[ReadOnly]*
---@field RejectText TTranslator
--[[Класс ConfirmationPrompt, для подтверждения действия. Отмена = закрытие окна ]]
ConfirmationPrompt={}
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
ConfirmationPrompt['OnSizeRefreshed']=OnSiz_RB
---@type Bind
--[[Специальный Bind для установки размера описанию. Работает как в Binder.ConfirmationPromptDescriptionSizeBind ]]
    local Speci_Bind = {}
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function Speci_Bind:Bind(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@param ConfirmationPrompt ConfirmationPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function Speci_Bind:Run(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@return ConfirmationPrompt ConfirmationPrompt
---@return UDim startYPos
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    ConfirmationPrompt['SpecialDescriptionSizeBind']= Speci_Bind