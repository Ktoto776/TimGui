---@diagnostic disable: undefined-type
---@meta
---@class TGroup : ButtonObject : TGuiObject : ConfigObject : GUIArchitecture : TClass
--[[Открыта ли группа? ]]
---@field Opened boolean
--[[Стрелочка статуса открытия для не глобальных групп ]]
--*[ReadOnly]*
---@field OpenLabel ImageLabel
--[[Frame с кнопками для не глобальных групп ]]
--*[ReadOnly]*
---@field NotGlobalGroupFrame Frame
--[[Равен `Group`. Нужен для определения типа обьекта ]]
--*[ReadOnly]*
---@field Type string
--[[Включено ли сохранение в конфиг для новых обьектов созданных через методы в этой группе.(Устанавливает `.ConfigSavingEnabled` на это значение). По умолчанию `true` ]]
---@field ConfigSavingForNewGroupObjects boolean
--[[Класс группа, может находится в `TimGui.Groups` или группа в группе. ]]
TGroup={}
--[[Создаёт просто текст с `.Parent` в этой группе ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return TText return Текст
function TGroup:CreateText(Name,Title) end
--[[Создаёт кнопку с `.Parent` в этой группе ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param callback? fun(self: TButton) Функция, для установки на клик, запускается с этой же кнопкой
---@return TButton return Кнопка
function TGroup:CreateButton(Name,Title,callback) end
--[[Создаёт переключатель(тумблер) с `.Parent` в этой группе ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param callback? fun(self: TToggle) Функция, для установки на клик, запускается с этим же переключателем
---@return TToggle return Переключатель(тумблер)
function TGroup:CreateToggle(Name,Title,callback) end
--[[Создаёт кнопку-последовательность, благодаря которой можно создать последовательность действий с `.Parent` в этой группе ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param callback? fun(self: TSequence) Функция, для установки на смену значения
---@param Objects? table<string,string> | table<string,table<string,string>> Таблица с обьектами, где ключ - имя кнопки, а значение - либо таблица переводов, либо заголовок
---@return TSequence return Кнопка-последовательность
function TGroup:CreateSequence(Name,Title,callback,Objects) end
--[[Создаёт поле для ввода данных(TextBox), данные могут быть не только текстовыми с `.Parent` в этой группе ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param callback? fun(self: TTextBox) Функция, для установки на смену значения, запускается с этим же TTextBox
---@return TTextBox return TextBox
function TGroup:CreateTextbox(Name,Title,callback) end
---@type RBXScriptSignal
--[[При открытии группы ]]
    local OnOpe_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpe_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpe_RB:Once(callback:()->()) end
    
    function OnOpe_RB:Wait() end
TGroup['OnOpen']=OnOpe_RB
---@type RBXScriptSignal
--[[При закрытии группы ]]
    local OnClo_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClo_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClo_RB:Once(callback:()->()) end
    
    function OnClo_RB:Wait() end
TGroup['OnClose']=OnClo_RB
---@type Bind
--[[Специальный бинд для анимации стрелочки. Работает как в Binder.GroupOpenArrowBind ]]
    local Speci_Bind = {}
    ---@param callback fun(group: TGroup)
    ---*return ()*
    function Speci_Bind:Bind(callback:(group: TGroup)->()) end
    ---@param group TGroup
    function Speci_Bind:Run(group: TGroup) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(group: TGroup)->()) end
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(group: TGroup)->()) end
    ---@return TGroup group
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TGroup['SpecialGroupOpenArrowBind']= Speci_Bind
---@type Bind
--[[Специальный бинд для обновления позиций кнопок в этой группе. Работает как в Binder.GlobalGroupRefreshPosition ]]
    local Speci_Bind = {}
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---*return (nextPos: UDim2)*
    function Speci_Bind:Bind(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@param GlobalGroup TGroup
---@param pos UDim2
---@return UDim2 nextPos
    function Speci_Bind:Run(GlobalGroup: TGroup,pos: UDim2) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@return TGroup GlobalGroup
---@return UDim2 pos
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TGroup['SpecialGlobalGroupRefreshPosition']= Speci_Bind
---@type Bind
--[[Бинд для кастомного отступа не глобальных групп. ]]
    local Group_Bind = {}
    ---@param callback fun(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)
    ---*return ()*
    function Group_Bind:Bind(callback:(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)->()) end
    ---@param TGroup TGroup
---@param VisibleIndent Frame
---@param GroupFrame Frame
    function Group_Bind:Run(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame) end

    local Group_Bind_OnRun = {}
    ---@param callback fun(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)
    ---@return RBXScriptConnection
    function Group_Bind_OnRun:Connect(callback:(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)->()) end
    ---@param callback fun(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)
    ---@return RBXScriptConnection
    function Group_Bind_OnRun:Once(callback:(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)->()) end
    ---@return TGroup TGroup
---@return Frame VisibleIndent
---@return Frame GroupFrame
    function Group_Bind_OnRun:Wait() end
    Group_Bind.OnRun = Group_Bind_OnRun
    TGroup['GroupIndentBind']= Group_Bind
---@type Bind
--[[Специальный бинд для обновления позиций кнопок в группе. Работает как в Binder.GlobalGroupRefreshSize ]]
    local Speci_Bind = {}
    ---@param callback fun(group: TGroup)
    ---*return ()*
    function Speci_Bind:Bind(callback:(group: TGroup)->()) end
    ---@param group TGroup
    function Speci_Bind:Run(group: TGroup) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(group: TGroup)->()) end
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(group: TGroup)->()) end
    ---@return TGroup group
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TGroup['SpecialGlobalGroupRefreshSize']= Speci_Bind