---@diagnostic disable: undefined-type
---@meta
---@class ValueBinder : TClass
--[[Id слушаемого ValueBind'а, его значения будут в .Value. По умолчанию 0(если не существует, то стандартное значение) ]]
---@field ListenId number
--[[Значение, можно изменить прям так, но не советуется. ]]
--*[Exception for WriteSameMode]*
---@field Value any
--[[Биндер для значений, используется чтобы значения не наслаивались друг на друга. Создаётся через TClasses:CreateValueBinder(Стандартное значение) ]]
ValueBinder={}
--[[Создаёт ValueBind для установки значения ]]
---@param TurnOnListing? boolean Установить на слушание(если нету, то считается как true)
---@return ValueBind response Класс ValueBind
function ValueBinder:Bind(TurnOnListing) end
---@type RBXScriptSignal
--[[Запускается когда ValueBinder:Bind был запущен ]]
    local OnBin_RB = {}
    ---@param callback fun(Id:number)
    ---@return RBXScriptConnection
    function OnBin_RB:Connect(callback:(Id:number)->()) end
    ---@param callback fun(Id:number)
    ---@return RBXScriptConnection
    function OnBin_RB:Once(callback:(Id:number)->()) end
    ---@return number Id
    function OnBin_RB:Wait() end
ValueBinder['OnBinded']=OnBin_RB