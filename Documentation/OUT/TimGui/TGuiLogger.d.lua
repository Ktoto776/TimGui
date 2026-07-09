---@diagnostic disable: undefined-type
---@meta
---@class TGuiLogger
--[[Весь лог этого логгера ]]
---@field Log table<number,LogMessage>
--[[Будет ли выводиться :debug(), по умолчанию false ]]
---@field debugEnabled boolean
--[[Logger класс, для логирования ]]
TGuiLogger={}
--[[Сравнивает имя класса(TGuiLogger/Logger) с 1 параметром и выдаёт результат ]]
---@param className string Имя класса
---@return boolean result Является ли потомком этого класса(или самим классом)
function TGuiLogger:IsA(className) end
--[[Предупреждение с этими данными ]]
---@param placeName? string Имя плейса
---@param data any Данные
---@return LogMessage message Сообщение
function TGuiLogger:warn(placeName,data) end
--[[Ошибка с этими данными(скрипт продолжит работу) ]]
---@param placeName? string Имя плейса
---@param data any Данные
---@return LogMessage message Сообщение
function TGuiLogger:error(placeName,data) end
--[[Логгирует эти данные ]]
---@param type string Тип собщения
---@param placeName? string Имя плейса
---@param data any Данные
---@return LogMessage message Сообщение
function TGuiLogger:log(type,placeName,data) end
--[[Ошибка с этими данными(скрипт не продолжит работу) ]]
---@param placeName? string Имя плейса
---@param data any Данные
function TGuiLogger:critical_error(placeName,data) end
--[[Логгирует эти дебаг данные ]]
---@param placeName? string Имя плейса
---@param data any Данные
---@return LogMessage message Сообщение
function TGuiLogger:debug(placeName,data) end
--[[Логгирует эти данные ]]
---@param placeName? string Имя плейса
---@param data any Данные
---@return LogMessage message Сообщение
function TGuiLogger:info(placeName,data) end