---@diagnostic disable: undefined-type
---@meta
---@class BetterGUI : TClass
--[[Сборник функций, которые не вошли в основной скрипт ]]
BetterGUI={}
--[[Конвертирует значение в TTranslator ]]
---@param value TTranslator | table<string,string> | any Значение, если TTranslator, менять ничего не будет. Если TClass вернёт TTranslator с '...'. А если таблица загрузит её в новый TTranslator
---@return TTranslator return Переводчик
function BetterGUI:ConvertToTranslator(value) end