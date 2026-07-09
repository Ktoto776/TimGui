---@diagnostic disable: undefined-type
---@meta
---@class ConfigObject : TClass
--[[Включено ли сохранение(P.S: загрузка тоже)?[Может не сохраняться изза одинакого имени но всё равно стоять true] ]]
---@field ConfigSavingEnabled boolean
--[[Задержка для сохранения(чтобы убрать спам при сменах свойств), по умолчанию 0.25. Отрицательные значения выключают автосохранения ]]
---@field ConfigSavingDelay number
--[[Имя сохранения в конфиге(если используется уже существующее, просто не сохраняет) ]]
---@field ConfigSaveName string
--[[Сохранение для TClass параметров. При создании класса возможно был выключен параметр otherClassesSaving, и поэтому обьект должен состоять из одинаковых классов при сохранении и загрузке ]]
ConfigObject={}
--[[Для проверки автосохраняется ли свойство ]]
---@param PropertyName string Имя свойства
---@return boolean result Включено ли автосохранение для свойства
function ConfigObject:IsEnabledAutosaveFor(PropertyName) end
--[[Для проверки сохраняется ли свойство ]]
---@param PropertyName string Имя свойства
---@return boolean result Сохраняется ли значение?
function ConfigObject:IsSavingProperty(PropertyName) end
--[[Выдает `false` если имя используется другим обьектом, или вернёт `ConfigSavingEnabled` ]]
---@return boolean result Включено ли сохранение?
function ConfigObject:IsConfigSavingEnabled() end
--[[Для установки автосохранения для свойства ]]
---@param PropertyName string Имя свойства
---@param IsEnabled boolean Включено ли автосохранение для свойства
function ConfigObject:SetEnabledAutosaveFor(PropertyName,IsEnabled) end
--[[Добавляет свойство в сохранение конфигураций, может также использоваться для смены стандартного значения ]]
---@param PropertyName string Имя свойства
---@param defaultValue? any Стандартное значение, если его нет в конфиге, то загружает его. Если `nil`, то не сбрасывает его
---@return boolean success Возвращает true если было установленно впервые(то есть до этого не следилось).
function ConfigObject:AddPropertyToConfigSave(PropertyName,defaultValue) end
--[[Устанавливает свойство по значению сохранённому в конфигурации ]]
---@param PropertyName? string Имя свойства
---@param doResetValueToDefault? boolean Сбрасывать ли для стандартного, если не указано? `nil` будет восприниматься как `true`
function ConfigObject:LoadConfigSave(PropertyName,doResetValueToDefault) end