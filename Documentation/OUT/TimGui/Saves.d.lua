---@diagnostic disable: undefined-type
---@meta
---@class Saves : TClass
--[[Поддерживаются ли сохранения? ]]
--*[ReadOnly]*
---@field IsSupported boolean
--[[Локальная директория в которой находятся файлы TGui, используемые для сохранений ]]
--*[ReadOnly]*
---@field BaseDir any
--[[Класс для сохранения значений для перезахода ]]
Saves={}
--[[Возвращает сохранение по названию ]]
---@param SaveName string Название сохранения
---@return Save Save Save класс для сохранения
function Saves:GetSave(SaveName) end