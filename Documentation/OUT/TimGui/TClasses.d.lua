---@diagnostic disable: undefined-type
---@meta
---@class TClasses : TClass
--[[Класс TClasses, предназначен для создания своих классов ]]
TClasses={}
--[[ ]]
---@param object any Обьект для сравнения
---@param className string Имя класса для сравнения
---@return boolean response Является ли потомком этого класса(или самим классом)
function TClasses:IsA(object,className) end
--[[Создаёт MenuToggle ]]
---@param Name string Название
---@param Title? string | table<string,string> | TTranslator Заголовок
---@return MenuToggle response Класс MenuToggle
function TClasses:CreateMenuToggle(Name,Title) end
--[[Создаёт пустое окно ]]
---@param Name string Название окна
---@param Title? string | table<string,string> | TTranslator Заголовок окна
---@param disableDefaultConfigSettingsRefresh? boolean Выключены ли стандартное обновление сохранений при смене настроек конфига
---@return TWindow response Класс TWindow
function TClasses:CreateWindow(Name,Title,disableDefaultConfigSettingsRefresh) end
--[[Создаёт TTranslator класс, помогает переводить всё что угодно на язык пользователя ]]
---@param englishData any Английский вариант(по умолчанию)
---@param rawData? table Сырая таблица
---@return TTranslator response Класс TTranslator
function TClasses:CreateTranslator(englishData,rawData) end
--[[Создаёт MenuButton ]]
---@param Name string Название
---@param Title? string | table<string,string> | TTranslator Заголовок
---@return MenuButton response Класс MenuButton
function TClasses:CreateMenuButton(Name,Title) end
--[[Создаёт класс для специальных цветов ]]
---@return SpecialColors response Класс для специальных цветов
function TClasses:CreateSpecialColors() end
--[[Создаёт Preset класс, помогает кастомизировать всё что угодно ]]
---@param clearAllOnLoad? boolean Заменять ли все значения при :Load()?
---@param rawData? table Сырая таблица, которая станет основой
---@return Preset response Класс Preset
function TClasses:CreatePreset(clearAllOnLoad,rawData) end
--[[Создаёт пустой prompt ]]
---@param PromptType string Тип промта
---@param Name string Название промпта
---@param Title? string | table<string,string> | TTranslator Заголовок
---@param Description? string | table<string,string> | TTranslator Описания промпта
---@param disableDefaultConfigSettingsRefresh? boolean Выключены ли стандартное обновление сохранений при смене настроек конфига
---@return Prompt response Класс Prompt
function TClasses:CreatePrompt(PromptType,Name,Title,Description,disableDefaultConfigSettingsRefresh) end
--[[Создаёт пустое меню ]]
---@return Menu response Класс Menu
function TClasses:CreateMenu() end
--[[Создаёт MenuText ]]
---@param Name string Название
---@param Title? string | table<string,string> | TTranslator Заголовок
---@return MenuText response Класс MenuText
function TClasses:CreateMenuText(Name,Title) end
--[[Создаёт Bind класс, помогает заменять функции для кастомизации через дополнения ]]
---@param rawData? table Сырая таблица
---@return Bind response Класс Bind
function TClasses:CreateBind(rawData) end
--[[Создаёт MenuItem ]]
---@param Name string Название
---@param Title? string | table<string,string> | TTranslator Заголовок
---@param disableTextColorChanged? boolean Включено ли изменение цвета текста
---@return MenuItem response Класс MenuItem
function TClasses:CreateMenuItem(Name,Title,disableTextColorChanged) end
--[[Создаёт пустой TClass ]]
---@param rawData? table Сырая таблица, которая станет основой для TClass'а
---@param metatable? table Мета-таблица, ставится поверх стандартной у TClass'ов
---@param writeSameModeExclude? boolean | table Таблица с исключениями для записывания только одинаковых типов, или если true полностью отключает функцию
---@return TClass response Класс TClass, база других классов
function TClasses:CreateTClass(rawData,metatable,writeSameModeExclude) end
--[[Кастомный Event по типу Bindable Event, чтобы передавать таблицы без ошибок(если ты не сталкиваешься с тупыми ошибками, как при table.clone, то используй встроенный BindableEvent) ]]
---@return TEvent Event TEvent класс
function TClasses:CreateTEvent() end