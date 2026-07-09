---@diagnostic disable: undefined-type
---@meta
---@class ButtonObject : TGuiObject : TClass
--[[Просто кнопка ]]
--*[ReadOnly]*
---@field Button TextButton
--[[Включено ли открытие меню через кнопку(ПК - правая кнопка мыши, Телефоны - зажатие) ]]
---@field OpenMenuFromButtonObject boolean
--[[Класс использющийся для создание TGuiObjects с TextButton ]]
ButtonObject={}
--[[Эмулирует нажатие кнопки ]]
function ButtonObject:Activate() end
---@type RBXScriptSignal
--[[Запускается при нажатии/эмуляции нажатия кнопки ]]
    local Activ_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Activ_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Activ_RB:Once(callback:()->()) end
    
    function Activ_RB:Wait() end
ButtonObject['Activated']=Activ_RB