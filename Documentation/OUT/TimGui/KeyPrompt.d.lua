---@diagnostic disable: undefined-type
---@meta
---@class KeyPrompt : Prompt : TWindow : ConfigObject : TClass
--[[Текст если кнопка не выбрана ]]
--*[ReadOnly]*
---@field NoneKeyText TTranslator
--[[Frame в котором находятся кнопки 'Подтвердить' и 'Отменить' ]]
--*[ReadOnly]*
---@field Buttons Frame
--[[Текст для кнопки отмены ]]
--*[ReadOnly]*
---@field CancelText TTranslator
--[[Подсказка если выбранная кнопка используется в игре ]]
--*[ReadOnly]*
---@field AlreadyUsingInGameText TTranslator
--[[Текст если кнопка выбрана, заменяет `%KEY%` - на выбранную кнопку ]]
--*[ReadOnly]*
---@field KeyText TTranslator
--[[Кнопка отмены(берёт текст из `.CancelText`) ]]
--*[ReadOnly]*
---@field CancelButton TextButton
--[[Размер текста описания ]]
---@field DescriptionTextSize number
--[[То что нажал пользователь ]]
---@field Value TKey
--[[TextLabel описания ]]
--*[ReadOnly]*
---@field DescriptionLabel TextLabel
--[[Кнопка подтверждения(берёт текст из `.ConfirmText`) ]]
--*[ReadOnly]*
---@field ConfirmButton TextButton
--[[Может ли пользователь отменить? ]]
---@field CancelEnabled boolean
--[[Основной TextLabel с выводом какая кнопка была нажата ]]
--*[ReadOnly]*
---@field TextLabel TextLabel
--[[Текст для кнопки подтверждения ]]
--*[ReadOnly]*
---@field ConfirmText TTranslator
--[[Включено ли выключение эвентов при клике кнопки, на время пока промпт запущен? ]]
---@field DisableOtherInputsWhenRunning boolean
--[[Класс KeyPrompt, чтобы спрашивать клавишу(клавиатуры/мыши) у пользователя на ПК. ]]
KeyPrompt={}
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
KeyPrompt['OnSizeRefreshed']=OnSiz_RB
---@type Bind
--[[Специальный Bind для установки размера описанию. Работает как в Binder.KeyPromptDescriptionSizeBind ]]
    local Speci_Bind = {}
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function Speci_Bind:Bind(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@param KeyPrompt KeyPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function Speci_Bind:Run(KeyPrompt: KeyPrompt,startYPos: UDim) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@return KeyPrompt KeyPrompt
---@return UDim startYPos
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    KeyPrompt['SpecialDescriptionSizeBind']= Speci_Bind