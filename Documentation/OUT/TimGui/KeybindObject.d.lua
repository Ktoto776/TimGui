---@diagnostic disable: undefined-type
---@meta
---@class KeybindObject : BaseKeybind : TClass
--[[Основной Frame ]]
--*[ReadOnly]*
---@field Frame Frame
--[[Родитель обьекта, может быть `nil` ]]
--*[Exception for WriteSameMode]*
---@field Parent Keybinder?
--[[Специальные цвета этому обьекту ]]
--*[ReadOnly]*
---@field SpecialColors SpecialColors
--[[Кнопка для удаления этого бинда ]]
--*[ReadOnly]*
---@field DeleteButton ImageButton
--[[UICorner, для скругления углов для `.Frame` ]]
--*[ReadOnly]*
---@field UICorner UICorner
--[[Позиция в окне keybinder ]]
---@field Position number
--[[Уникальный Id KeybindObject'а, ставится при создании ]]
--*[ReadOnly]*
---@field Id number
--[[Кейбинд предназначенный специально для Keybinder ]]
KeybindObject={}
--[[Удаляет этот обьект. ]]
function KeybindObject:Destroy() end
---@type RBXScriptSignal
--[[Запускается когда обьект удалён ]]
    local Destr_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destr_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destr_RB:Once(callback:()->()) end
    
    function Destr_RB:Wait() end
KeybindObject['Destroyed']=Destr_RB