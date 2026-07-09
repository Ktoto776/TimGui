---@diagnostic disable: undefined-type
---@meta
---@class TSequence : ButtonObject : TGuiObject : ConfigObject : TClass
--[[Открыт ли? ]]
---@field Opened boolean
--[[Стрелочка статуса открытия ]]
--*[ReadOnly]*
---@field OpenLabel ImageLabel
--[[Размер ]]
--*[ReadOnly]*
---@field Size UDim2
--[[Равен `Sequence`. Нужен для определения типа обьекта ]]
--*[ReadOnly]*
---@field Type string
--[[Frame со всеми обьектами ]]
--*[ReadOnly]*
---@field SequenceFrame Frame
--[[Кнопка-последовательность для установки порядка исполнения(например, порядок языков) ]]
TSequence={}
--[[Добавляет порядковый обьект ]]
---@param ObjectName string Имя порядкого обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return boolean success Успешно ли(обычно возвращает `false`, если обьекта уже существует)
function TSequence:AddObject(ObjectName,Title) end
--[[Изменяет позицию для обьекта в TSequence ]]
---@param ObjectName string Имя порядкого обьекта
---@param NewPosition number Новая позиция этого обьекта
---@return boolean success Успешно ли(обычно возвращает `false`, если обьекта не существует)
function TSequence:SetObjectPosition(ObjectName,NewPosition) end
---@type RBXScriptSignal
--[[При открытии ]]
    local OnOpe_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpe_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpe_RB:Once(callback:()->()) end
    
    function OnOpe_RB:Wait() end
TSequence['OnOpen']=OnOpe_RB
---@type RBXScriptSignal
--[[При смене порядка обьектов ]]
    local Seque_RB = {}
    ---@param callback fun(data:table)
    ---@return RBXScriptConnection
    function Seque_RB:Connect(callback:(data:table)->()) end
    ---@param callback fun(data:table)
    ---@return RBXScriptConnection
    function Seque_RB:Once(callback:(data:table)->()) end
    ---@return table<number,string> data
    function Seque_RB:Wait() end
TSequence['SequenceChanged']=Seque_RB
---@type RBXScriptSignal
--[[При закрытии ]]
    local OnClo_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClo_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClo_RB:Once(callback:()->()) end
    
    function OnClo_RB:Wait() end
TSequence['OnClose']=OnClo_RB
---@type Bind
--[[Специальный бинд для создания обьектов в TSequence. Работает как в Binder.SequenceCreateObject ]]
    local Speci_Bind = {}
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---*return (SequenceObject: table)*
    function Speci_Bind:Bind(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@param TSequence TSequence
---@param Name string
---@param Position number
---@return table SequenceObject
    function Speci_Bind:Run(TSequence: TSequence,Name: string,Position: number) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@return TSequence TSequence
---@return string Name
---@return number Position
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TSequence['SpecialCreateObject']= Speci_Bind
---@type Bind
--[[Бинд для кастомного отступа. ]]
    local Inden_Bind = {}
    ---@param callback fun(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)
    ---*return ()*
    function Inden_Bind:Bind(callback:(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)->()) end
    ---@param TSequence TSequence
---@param VisibleIndent Frame
---@param SequenceFrame Frame
    function Inden_Bind:Run(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame) end

    local Inden_Bind_OnRun = {}
    ---@param callback fun(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)
    ---@return RBXScriptConnection
    function Inden_Bind_OnRun:Connect(callback:(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)->()) end
    ---@param callback fun(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)
    ---@return RBXScriptConnection
    function Inden_Bind_OnRun:Once(callback:(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)->()) end
    ---@return TSequence TSequence
---@return Frame VisibleIndent
---@return Frame SequenceFrame
    function Inden_Bind_OnRun:Wait() end
    Inden_Bind.OnRun = Inden_Bind_OnRun
    TSequence['IndentBind']= Inden_Bind
---@type Bind
--[[Специальный бинд для анимации стрелочки. Работает как в Binder.SequenceOpenArrowBind ]]
    local Speci_Bind = {}
    ---@param callback fun(TSequence: TSequence)
    ---*return ()*
    function Speci_Bind:Bind(callback:(TSequence: TSequence)->()) end
    ---@param TSequence TSequence
    function Speci_Bind:Run(TSequence: TSequence) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(TSequence: TSequence)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(TSequence: TSequence)->()) end
    ---@param callback fun(TSequence: TSequence)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(TSequence: TSequence)->()) end
    ---@return TSequence TSequence
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TSequence['SpecialOpenArrowBind']= Speci_Bind