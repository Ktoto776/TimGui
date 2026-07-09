---@diagnostic disable: undefined-type
---@meta
---@class Preset : TClass
--[[Имя пресета, по умолчанию 'Default' ]]
---@field PresetName string
--[[Стандартный пресет, нету отдельных функций в его сохранение. ]]
---@field Default table
--[[Пример класса ]]
Preset={}
--[[Загружает пресет ]]
---@param Preset table Таблица с значениями(значение может быть массивом с [type,...]-альтернатива для сохранения типов из рб), если есть запускает :Load()
function Preset:Load(Preset) end
--[[Получает все значения в пресете ]]
---@param dontUseRBXValues boolean Если true, то возвращает таблицу с данными (если тип из роблокса то станет массивом [type,...])
---@return table Preset Загруженный пресет
function Preset:GetPreset(dontUseRBXValues) end
--[[Обновляет пресет ]]
---@param Preset? table Таблица с значениями(значение может быть массивом с [type,...]-альтернатива для сохранения типов из рб), если есть запускает :Load()
function Preset:Refresh(Preset) end
---@type RBXScriptSignal
--[[Запускается при Preset:Refresh() или Preset:Load() ]]
    local OnRef_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRef_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRef_RB:Once(callback:()->()) end
    
    function OnRef_RB:Wait() end
Preset['OnRefresh']=OnRef_RB