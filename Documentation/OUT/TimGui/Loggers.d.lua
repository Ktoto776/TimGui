---@diagnostic disable: undefined-type
---@meta
---@class Loggers
--[[Весь лог всех логгеров ]]
---@field Log table<number,LogMessage>
--[[Класс для создания логгеров и чтения логов ]]
Loggers={}
--[[Сравнивает имя класса(Loggers) с 1 параметром и выдаёт результат ]]
---@param className string Имя класса
---@return boolean result Является ли потомком этого класса(или самим классом)
function Loggers:IsA(className) end
--[[Создаёт новый логгер ]]
---@param loggerName string Имя логгера
---@return TGuiLogger logger Логгер
function Loggers:New(loggerName) end