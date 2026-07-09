---@diagnostic disable: undefined-type
---@meta
---@class SpecialColors : Colors : Preset : TClass
--[[Класс для цветов, использующий пресеты. ]]
SpecialColors={}
--[[Получает цвет, если нету здесь то глобальный ]]
---@param colorName string Имя цвета
---@return Color3? response Цвет
function SpecialColors:GetColor(colorName) end
--[[Возвращает RBXScriptSignal, который запускается при смене цвета ]]
---@param colorName string Имя цвета
---@return RBXScriptSignal event Эвент, запускаемый при смене выбранного цвета
function SpecialColors:GetColorChangedSignal(colorName) end