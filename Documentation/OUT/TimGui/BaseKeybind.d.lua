---@diagnostic disable: undefined-type
---@meta
---@class BaseKeybind : TClass
--[[Статус при котором будет запускаться Event. Может быть: "Begin","Change","End". По умолчанию "End" ]]
---@field State string
--[[Тип бинда, нужен чтобы группировать бинды по действиям(где названия придумываешь ты сам).По умолчанию "" ]]
---@field Type string
--[[Игнорировать ли лишние Специальные ключи(ctrl/shift и др.) ]]
---@field IgnoreExtraSpecialKeys boolean
--[[Сам ключ, может быть пустым(то есть не выбранным) ]]
---@field Key TKey
--[[Часть для других классов связанных с кейбиндами ]]
BaseKeybind={}
--[[Эмулирует нажатие, то есть запускает .Event ]]
function BaseKeybind:Emulate() end
---@type RBXScriptSignal
--[[Эвент, который запускается при нажатии кнопки установленной в BaseKeybind ]]
    local Event_RB = {}
    ---@param callback fun(Input?:InputObject,GPE?:boolean)
    ---@return RBXScriptConnection
    function Event_RB:Connect(callback:(Input:InputObject?,GPE:boolean?)->()) end
    ---@param callback fun(Input?:InputObject,GPE?:boolean)
    ---@return RBXScriptConnection
    function Event_RB:Once(callback:(Input:InputObject?,GPE:boolean?)->()) end
    ---@return InputObject? Input
---@return boolean? GPE
    function Event_RB:Wait() end
BaseKeybind['Event']=Event_RB