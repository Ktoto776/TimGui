---@diagnostic disable: undefined-type
---@meta
---@class TEvent
--[[Таблица с массивами, с последними args {[number]={...}}. Исчезают через 1 секунду после запуска ]]
---@field Args table
--[[BindableEvent с помощью которого работают ожидания :Fire() ]]
---@field BEvent BindableEvent
--[[Массив, с последними args *Новая версия .Args* ]]
---@field args table
--[[Кастомный Event по типу Bindable Event, чтобы передавать timgui типы без ошибок(если ты не сталкиваешься с тупыми ошибками, как при table.clone, то используй встроенный BindableEvent) ]]
TEvent={}
--[[Запускается с любыми параметрами, которые передаются в .Event ]]
function TEvent:Fire() end
---@type TSignal
--[[Основной сигнал этого TEvent, запускаемый через :Fire(...), с параметрами ... взятыми из :Fire ]]
    local Event_TS = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Event_TS:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Event_TS:Once(callback:()->()) end
    
    function Event_TS:Wait() end
TEvent['Event']=Event_TS