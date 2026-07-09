---@diagnostic disable: undefined-type
---@meta
---@class MenuButton : MenuItem : TClass
--[[Основная кнопка этого меню обьекта ]]
--*[ReadOnly]*
---@field Button TextButton
--[[Прятать ли меню при активации? ]]
---@field CloseMenuOnActivated boolean
--[[Обьект соддержащий текст(здесь - кнопка). Тоже самое что и `.Button`, но для совместимости ]]
--*[ReadOnly]*
---@field TextObject TextButton
--[[Кнопка в меню. ]]
MenuButton={}
--[[Эмулирует нажатие на кнопку ]]
function MenuButton:EmulateActivate() end
---@type RBXScriptSignal
--[[Запускается при нажатии или при запуске `:EmulateActivate()` ]]
    local Activ_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Activ_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Activ_RB:Once(callback:()->()) end
    
    function Activ_RB:Wait() end
MenuButton['Activated']=Activ_RB