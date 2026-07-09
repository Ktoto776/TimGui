---@diagnostic disable: undefined-type
---@meta
---@class ValueBind : TClass
--[[Значение, может быть изменено через .Translator ]]
--*[Exception for WriteSameMode]*
---@field Value any
--[[Включен ли бинд(то есть прослушивается ли) ]]
---@field Enabled boolean
--[[ValueBinder, к которому пренадлежит этот VBind ]]
--*[Exception for WriteSameMode]*
---@field Parent ValueBinder
--[[Id этого бинда ]]
---@field Id number
--[[Значение, но с переводом, изменяет .Value если нужный перевод был изменён ]]
---@field Translator TTranslator
--[[Бинд для значений, использующийся в ValueBinder ]]
ValueBind={}
---@type RBXScriptSignal
--[[Запускается если ValueBinder слушает этот Bind ]]
    local OnEna_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnEna_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnEna_RB:Once(callback:()->()) end
    
    function OnEna_RB:Wait() end
ValueBind['OnEnabled']=OnEna_RB
---@type RBXScriptSignal
--[[Запускается если Binder больше не слушает этот Bind ]]
    local OnDis_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnDis_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnDis_RB:Once(callback:()->()) end
    
    function OnDis_RB:Wait() end
ValueBind['OnDisabled']=OnDis_RB