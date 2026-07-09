---@diagnostic disable: undefined-type
---@meta
---@class Save : TClass
--[[Имя сохранения ]]
--*[ReadOnly]*
---@field Name string
--[[Сохранение, можно записать в конфиг или глобально ]]
Save={}
--[[Читает данные с конфигурации ]]
---@param key string Ключ(название) сохранения
---@return any data Данные
function Save:GetFromConfig(key) end
--[[Записывает данные на конфигурацию ]]
---@param key string Ключ(название) сохранения
---@param value any Значение, string | number | table | boolean типы поддерживаются
---@return boolean success Успешно ли (если `TimGui.Saves.IsSupported == false`, то оно сбросится после перезахода)
function Save:SetToConfig(key,value) end
--[[Читает данные с глобального сохранения ]]
---@param key string Ключ(название) сохранения
---@return any data Данные
function Save:GetFromSave(key) end
--[[Записывает данные на глобальное сохранение ]]
---@param key string Ключ(название) сохранения
---@param value any Значение, string | number | table | boolean типы поддерживаются
---@return boolean success Успешно ли (если `TimGui.Saves.IsSupported == false`, то оно сбросится после перезахода)
function Save:SetToSave(key,value) end