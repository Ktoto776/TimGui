---@diagnostic disable: undefined-type
---@meta
---@class Prompts : TClass
--[[Класс для создания Prompt. Находится в TimGui.Prompts ]]
Prompts={}
--[[Создаёт промпт-подтверждение ]]
---@param Name string Название промпта
---@param Title? string | table<string,string> | TTranslator Заголовок
---@param Description? string | table<string,string> | TTranslator Описания промпта
---@param disableDefaultConfigSettingsRefresh? boolean Выключены ли стандартное обновление сохранений при смене настроек конфига
---@return ConfirmationPrompt return Промпт-подтверждение
function Prompts:CreateConfirmationPrompt(Name,Title,Description,disableDefaultConfigSettingsRefresh) end
--[[Создаёт текстовый промпт ]]
---@param Name string Название промпта
---@param Title? string | table<string,string> | TTranslator Заголовок
---@param Description? string | table<string,string> | TTranslator Описания промпта
---@param disableDefaultConfigSettingsRefresh? boolean Выключены ли стандартное обновление сохранений при смене настроек конфига
---@return TextPrompt return Класс TextPrompt
function Prompts:CreateTextPrompt(Name,Title,Description,disableDefaultConfigSettingsRefresh) end
--[[Создаёт промпт для выбора кнопки на клавиатуре ]]
---@param Name string Название промпта
---@param Title? string | table<string,string> | TTranslator Заголовок
---@param Description? string | table<string,string> | TTranslator Описания промпта
---@param disableDefaultConfigSettingsRefresh? boolean Выключены ли стандартное обновление сохранений при смене настроек конфига
---@return KeyPrompt return Промпт для выбора кнопки на клавиатуре
function Prompts:CreateKeyPrompt(Name,Title,Description,disableDefaultConfigSettingsRefresh) end