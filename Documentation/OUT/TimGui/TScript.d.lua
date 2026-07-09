---@diagnostic disable: undefined-type
---@meta
---@class TScript : TClass
--[[Имя скрипта ]]
--*[ReadOnly]*
---@field Name string
--[[Logger этого скрипта ]]
--*[ReadOnly]*
---@field Logger TGuiLogger
--[[Скрипт, предназначенный для обработки данных только этого скрипта. Можно получить через TimGui:GetTScript(scriptName) ]]
TScript={}
--[[Читает данные с конфигурации скрипта ]]
---@param key string Ключ(название) сохранения
---@return any data Данные
function TScript:GetFromConfig(key) end
--[[Записывает данные на конфигурацию скрипта ]]
---@param key string Ключ(название) сохранения
---@param value any Значение, string | number | table | boolean типы поддерживаются
---@return boolean success Успешно ли (если `TimGui.Saves.IsSupported == false`, то оно сбросится после перезахода)
function TScript:SetToConfig(key,value) end
--[[Читает данные с глобального сохранения скрипта ]]
---@param key string Ключ(название) сохранения
---@return any data Данные
function TScript:GetFromSave(key) end
--[[Записывает данные на глобальное сохранение скрипта ]]
---@param key string Ключ(название) сохранения
---@param value any Значение, string | number | table | boolean типы поддерживаются
---@return boolean success Успешно ли (если `TimGui.Saves.IsSupported == false`, то оно сбросится после перезахода)
function TScript:SetToSave(key,value) end