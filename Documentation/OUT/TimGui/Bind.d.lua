---@diagnostic disable: undefined-type
---@meta
---@class Bind : TClass
--[[Бинд, тоесть список функций, которые запускаются по очереди и служат для замены функций из внешних скриптов ]]
Bind={}
--[[Добавляет функцию, которая пропускается вернёт nil(тоесть если не nil, то следующие функции не запускаются) ]]
---@param callback fun(...) Функция
function Bind:Bind(callback) end
--[[Запускает функции с теме же параметрами с чем и запускался Run(...) и возвращает, то что вернула запущенная функция ]]
function Bind:Run() end
---@type RBXScriptSignal
--[[Запускается при Bind:Run(...), с теме же параметрами как и в запуске функции ]]
    local OnRun_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRun_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRun_RB:Once(callback:()->()) end
    
    function OnRun_RB:Wait() end
Bind['OnRun']=OnRun_RB
---@type RBXScriptSignal
--[[Запускается при Bind:Bind(...) ]]
    local OnBin_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnBin_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnBin_RB:Once(callback:()->()) end
    
    function OnBin_RB:Wait() end
Bind['OnBinded']=OnBin_RB