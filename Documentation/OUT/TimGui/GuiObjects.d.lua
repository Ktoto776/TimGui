---@diagnostic disable: undefined-type
---@meta
---@class GuiObjects : TClass
--[[Класс для создания групп и кнопок. Находится в TimGui.GuiObjects ]]
GuiObjects={}
--[[Создаёт группу ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent? GUIArchitecture Parent для этого обьекта
---@return TGroup return Группа
function GuiObjects:CreateGroup(Name,Title,Parent) end
--[[Создаёт просто текст ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent? GUIArchitecture Parent для этого обьекта
---@return TText return Текст
function GuiObjects:CreateText(Name,Title,Parent) end
--[[Создаёт кнопку ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent? GUIArchitecture Parent для этого обьекта
---@param callback? fun(self: TButton) Функция, для установки на клик, запускается с этой же кнопкой
---@return TButton return Кнопка
function GuiObjects:CreateButton(Name,Title,Parent,callback) end
--[[Создаёт переключатель(тумблер) ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent? GUIArchitecture Parent для этого обьекта
---@param callback? fun(self: TToggle) Функция, для установки на клик, запускается с этим же переключателем
---@return TToggle return Переключатель(тумблер)
function GuiObjects:CreateToggle(Name,Title,Parent,callback) end
--[[Создаёт кнопку-последовательность, благодаря которой можно создать последовательность действий ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent? GUIArchitecture Parent для этого обьекта
---@param callback? fun(self: TSequence) Функция, для установки на смену значения
---@param Objects? table<string,string> | table<string,table<string,string>> Таблица с обьектами, где ключ - имя кнопки, а значение - либо таблица переводов, либо заголовок
---@return TSequence return Кнопка-последовательность
function GuiObjects:CreateSequence(Name,Title,Parent,callback,Objects) end
--[[Создаёт поле для ввода данных(TextBox), данные могут быть не только текстовыми ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent? GUIArchitecture Parent для этого обьекта
---@param callback? fun(self: TTextBox) Функция, для установки на смену значения, запускается с этим же TTextBox
---@return TTextBox return TextBox
function GuiObjects:CreateTextbox(Name,Title,Parent,callback) end