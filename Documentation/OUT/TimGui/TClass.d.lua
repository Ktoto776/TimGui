---@diagnostic disable: undefined-type
---@meta
---@class TClass
--[[Пример класса ]]
TClass={}
--[[Сравнивает имя класса с 1 параметром ]]
---@param className string Имя класса для сравнения
---@return boolean response Является ли потомком этого класса(или самим классом)
function TClass:IsA(className) end
--[[Получить эвент, который запускается при изменении значения ]]
---@param propertyName string Имя свойства
---@return RBXScriptSignal event Эвент, который запускается при изменении значения
function TClass:GetPropertyChangedEvent(propertyName) end
--[[Возвращает наличия свойства только для чтения ]]
---@param propertyName string Имя свойства
---@return boolean event Установлено ли свойство только для чтения?
function TClass:GetReadOnly(propertyName) end
--[[Сравнивает имя класса с 1 параметром ]]
---@return table<number,string> response Массив {string,...}
function TClass:GetClassNames() end
--[[Устанавливает свойство только для чтения ]]
---@param propertyName string Имя свойства
function TClass:SetReadOnly(propertyName) end
--[[Добавляет имя класса ]]
---@param className string Имя класса
function TClass:AddClassName(className) end
---@type RBXScriptSignal
--[[Запускается если значение было изменено ]]
    local OnPro_RB = {}
    ---@param callback fun(PropertyName:string)
    ---@return RBXScriptConnection
    function OnPro_RB:Connect(callback:(PropertyName:string)->()) end
    ---@param callback fun(PropertyName:string)
    ---@return RBXScriptConnection
    function OnPro_RB:Once(callback:(PropertyName:string)->()) end
    ---@return string PropertyName
    function OnPro_RB:Wait() end
TClass['OnPropertyChanged']=OnPro_RB