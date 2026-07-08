---@diagnostic disable: undefined-type
---@meta

---@class Assets : TClass : Preset
--[[rbxassetid:// на значок создания Keybind'а ]]
---@field AddKeybind string
--[[rbxassetid:// на картинку загрузки ]]
---@field Loading string
--[[rbxassetid:// на стрелочку открытия ]]
---@field Arrow string
--[[rbxassetid:// на значок удаления Keybind'а ]]
---@field DeleteKeybindObject string
--[[rbxassetid:// на значок закрывания окна ]]
---@field CloseTWindow string
--[[rbxassetid:// на стрелочку статуса TSequence ]]
---@field SequenceOpenArrow string
--[[rbxassetid:// на картинку ошибки ]]
---@field Error string
--[[rbxassetid:// на значок скрывания/раскрывания окна ]]
---@field HideTWindow string
--[[rbxassetid:// на стрелочку статуса группы ]]
---@field GroupOpenArrow string
--[[Класс для ресурсов, использующий пресеты ]]
Assets={}

---@class BaseKeybind : TClass
--[[Тип бинда, нужен чтобы группировать бинды по действиям(где названия придумываешь ты сам).По умолчанию "" ]]
---@field Type string
--[[Игнорировать ли лишние Специальные ключи(ctrl/shift и др.) ]]
---@field IgnoreExtraSpecialKeys boolean
--[[Статус при котором будет запускаться Event. Может быть: "Begin","Change","End". По умолчанию "End" ]]
---@field State string
--[[Сам ключ, может быть пустым(то есть не выбранным) ]]
---@field Key TKey
--[[Часть для других классов связанных с кейбиндами ]]
BaseKeybind={}
--[[Эмулирует нажатие, то есть запускает .Event ]]
function BaseKeybind:Emulate() end
---@type RBXScriptSignal
--[[Эвент, который запускается при нажатии кнопки установленной в BaseKeybind ]]
    Event_RBXScriptSignal = {}
    ---@param callback fun(Input?:InputObject,GPE?:boolean)
    ---@return RBXScriptConnection
    function Event_RBXScriptSignal:Connect(callback:(Input:InputObject?,GPE:boolean?)->()) end
    ---@param callback fun(Input?:InputObject,GPE?:boolean)
    ---@return RBXScriptConnection
    function Event_RBXScriptSignal:Once(callback:(Input:InputObject?,GPE:boolean?)->()) end
    ---@return InputObject? Input
---@return boolean? GPE
    function Event_RBXScriptSignal:Wait() end
BaseKeybind['Event']=Event_RBXScriptSignal

---@class Bind : TClass
--[[Бинд, тоесть список функций, которые запускаются по очереди и служат для замены функций из внешних скриптов ]]
Bind={}
--[[Добавляет функцию, которая пропускается вернёт nil(тоесть если не nil, то следующие функции не запускаются) ]]
---@param callback fun(...) Функция
---@return fun(...) callback Функция
function Bind:Bind(callback) end
--[[Запускает функции с теме же параметрами с чем и запускался Run(...) и возвращает, то что вернула запущенная функция ]]
function Bind:Run() end
---@type RBXScriptSignal
--[[Запускается при Bind:Bind(...) ]]
    OnBinded_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnBinded_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnBinded_RBXScriptSignal:Once(callback:()->()) end
    
    function OnBinded_RBXScriptSignal:Wait() end
Bind['OnBinded']=OnBinded_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается при Bind:Run(...), с теме же параметрами как и в запуске функции ]]
    OnRun_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRun_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRun_RBXScriptSignal:Once(callback:()->()) end
    
    function OnRun_RBXScriptSignal:Wait() end
Bind['OnRun']=OnRun_RBXScriptSignal

---@class Binder : TClass
--[[Класс для глобальной замены стандартных функций(или же сборник Binds) ]]
Binder={}
--[[Создаёт новый класс Bind ]]
function Binder:New() end
---@type Bind
--[[Бинд для установки размера описанию ConfirmationPrompt'а. ]]
    ConfirmationPromptDescriptionSizeBind_Bind = {}
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function ConfirmationPromptDescriptionSizeBind_Bind:Bind(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@param ConfirmationPrompt ConfirmationPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function ConfirmationPromptDescriptionSizeBind_Bind:Run(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim) end

    ConfirmationPromptDescriptionSizeBind_Bind_OnRun = {}
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function ConfirmationPromptDescriptionSizeBind_Bind_OnRun:Connect(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function ConfirmationPromptDescriptionSizeBind_Bind_OnRun:Once(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@return ConfirmationPrompt ConfirmationPrompt
---@return UDim startYPos
    function ConfirmationPromptDescriptionSizeBind_Bind_OnRun:Wait() end
    ConfirmationPromptDescriptionSizeBind_Bind.OnRun = ConfirmationPromptDescriptionSizeBind_Bind_OnRun
    Binder['ConfirmationPromptDescriptionSizeBind']= ConfirmationPromptDescriptionSizeBind_Bind
---@type Bind
--[[Бинд для установки размера описанию KeyPrompt'а. ]]
    KeyPromptDescriptionSizeBind_Bind = {}
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function KeyPromptDescriptionSizeBind_Bind:Bind(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@param KeyPrompt KeyPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function KeyPromptDescriptionSizeBind_Bind:Run(KeyPrompt: KeyPrompt,startYPos: UDim) end

    KeyPromptDescriptionSizeBind_Bind_OnRun = {}
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function KeyPromptDescriptionSizeBind_Bind_OnRun:Connect(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function KeyPromptDescriptionSizeBind_Bind_OnRun:Once(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@return KeyPrompt KeyPrompt
---@return UDim startYPos
    function KeyPromptDescriptionSizeBind_Bind_OnRun:Wait() end
    KeyPromptDescriptionSizeBind_Bind.OnRun = KeyPromptDescriptionSizeBind_Bind_OnRun
    Binder['KeyPromptDescriptionSizeBind']= KeyPromptDescriptionSizeBind_Bind
---@type Bind
--[[Бинд для запуска обновлений позиций кнопок. ]]
    RefreshingBind_Bind = {}
    ---@param callback fun(children: table,FromObject: TGuiObject)
    ---*return (lastPos: UDim2)*
    function RefreshingBind_Bind:Bind(callback:(children: table,FromObject: TGuiObject)->()) end
    ---@param children table<number,TGuiObject>
---@param FromObject TGuiObject
---@return UDim2 lastPos
    function RefreshingBind_Bind:Run(children: table,FromObject: TGuiObject) end

    RefreshingBind_Bind_OnRun = {}
    ---@param callback fun(children: table,FromObject: TGuiObject)
    ---@return RBXScriptConnection
    function RefreshingBind_Bind_OnRun:Connect(callback:(children: table,FromObject: TGuiObject)->()) end
    ---@param callback fun(children: table,FromObject: TGuiObject)
    ---@return RBXScriptConnection
    function RefreshingBind_Bind_OnRun:Once(callback:(children: table,FromObject: TGuiObject)->()) end
    ---@return table<number,TGuiObject> children
---@return TGuiObject FromObject
    function RefreshingBind_Bind_OnRun:Wait() end
    RefreshingBind_Bind.OnRun = RefreshingBind_Bind_OnRun
    Binder['RefreshingBind']= RefreshingBind_Bind
---@type Bind
--[[Бинд для установки позиции MenuItem. ]]
    MenuItemRefreshPositionBind_Bind = {}
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---*return (lastYPos: UDim)*
    function MenuItemRefreshPositionBind_Bind:Bind(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@param MenuItem MenuItem
---@param YPosition UDim
---@return UDim lastYPos
    function MenuItemRefreshPositionBind_Bind:Run(MenuItem: MenuItem,YPosition: UDim) end

    MenuItemRefreshPositionBind_Bind_OnRun = {}
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---@return RBXScriptConnection
    function MenuItemRefreshPositionBind_Bind_OnRun:Connect(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---@return RBXScriptConnection
    function MenuItemRefreshPositionBind_Bind_OnRun:Once(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@return MenuItem MenuItem
---@return UDim YPosition
    function MenuItemRefreshPositionBind_Bind_OnRun:Wait() end
    MenuItemRefreshPositionBind_Bind.OnRun = MenuItemRefreshPositionBind_Bind_OnRun
    Binder['MenuItemRefreshPositionBind']= MenuItemRefreshPositionBind_Bind
---@type Bind
--[[Бинд для установки позиции глобальным группам.  ]]
    GlobalGroupRefreshPosition_Bind = {}
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---*return (nextPos: UDim2)*
    function GlobalGroupRefreshPosition_Bind:Bind(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@param GlobalGroup TGroup
---@param pos UDim2
---@return UDim2 nextPos
    function GlobalGroupRefreshPosition_Bind:Run(GlobalGroup: TGroup,pos: UDim2) end

    GlobalGroupRefreshPosition_Bind_OnRun = {}
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---@return RBXScriptConnection
    function GlobalGroupRefreshPosition_Bind_OnRun:Connect(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---@return RBXScriptConnection
    function GlobalGroupRefreshPosition_Bind_OnRun:Once(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@return TGroup GlobalGroup
---@return UDim2 pos
    function GlobalGroupRefreshPosition_Bind_OnRun:Wait() end
    GlobalGroupRefreshPosition_Bind.OnRun = GlobalGroupRefreshPosition_Bind_OnRun
    Binder['GlobalGroupRefreshPosition']= GlobalGroupRefreshPosition_Bind
---@type Bind
--[[Бинд для установки размера описанию TextPrompt'а. ]]
    TextPromptDescriptionSizeBind_Bind = {}
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function TextPromptDescriptionSizeBind_Bind:Bind(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@param TextPrompt TextPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function TextPromptDescriptionSizeBind_Bind:Run(TextPrompt: TextPrompt,startYPos: UDim) end

    TextPromptDescriptionSizeBind_Bind_OnRun = {}
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function TextPromptDescriptionSizeBind_Bind_OnRun:Connect(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function TextPromptDescriptionSizeBind_Bind_OnRun:Once(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@return TextPrompt TextPrompt
---@return UDim startYPos
    function TextPromptDescriptionSizeBind_Bind_OnRun:Wait() end
    TextPromptDescriptionSizeBind_Bind.OnRun = TextPromptDescriptionSizeBind_Bind_OnRun
    Binder['TextPromptDescriptionSizeBind']= TextPromptDescriptionSizeBind_Bind
---@type Bind
--[[Бинд для установки позиции объектам(и не глобальным группам) ]]
    ButtonPositionBind_Bind = {}
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---*return (nextPos: UDim2)*
    function ButtonPositionBind_Bind:Bind(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@param child TGuiObject
---@param pos UDim2
---@return UDim2 nextPos
    function ButtonPositionBind_Bind:Run(child: TGuiObject,pos: UDim2) end

    ButtonPositionBind_Bind_OnRun = {}
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---@return RBXScriptConnection
    function ButtonPositionBind_Bind_OnRun:Connect(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---@return RBXScriptConnection
    function ButtonPositionBind_Bind_OnRun:Once(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@return TGuiObject child
---@return UDim2 pos
    function ButtonPositionBind_Bind_OnRun:Wait() end
    ButtonPositionBind_Bind.OnRun = ButtonPositionBind_Bind_OnRun
    Binder['ButtonPositionBind']= ButtonPositionBind_Bind
---@type Bind
--[[Бинд для анимации открытия. Не забывай про TimGui.GuiAnimations.OpenAnimationEnabled(при выкл просто тп)/OpenTI. ]]
    OpenAnimation_Bind = {}
    ---@param callback fun(Frame: UIBase,isOpen: boolean)
    ---*return ()*
    function OpenAnimation_Bind:Bind(callback:(Frame: UIBase,isOpen: boolean)->()) end
    ---@param Frame UIBase
---@param isOpen boolean
    function OpenAnimation_Bind:Run(Frame: UIBase,isOpen: boolean) end

    OpenAnimation_Bind_OnRun = {}
    ---@param callback fun(Frame: UIBase,isOpen: boolean)
    ---@return RBXScriptConnection
    function OpenAnimation_Bind_OnRun:Connect(callback:(Frame: UIBase,isOpen: boolean)->()) end
    ---@param callback fun(Frame: UIBase,isOpen: boolean)
    ---@return RBXScriptConnection
    function OpenAnimation_Bind_OnRun:Once(callback:(Frame: UIBase,isOpen: boolean)->()) end
    ---@return UIBase Frame
---@return boolean isOpen
    function OpenAnimation_Bind_OnRun:Wait() end
    OpenAnimation_Bind.OnRun = OpenAnimation_Bind_OnRun
    Binder['OpenAnimation']= OpenAnimation_Bind
---@type Bind
--[[Бинд для установки позиций названия и поля для ввода. ]]
    RefreshTextBoxSizes_Bind = {}
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---*return ()*
    function RefreshTextBoxSizes_Bind:Bind(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@param TTextBox TTextBox
---@param TextLabel TextLabel
---@param TextBox TextBox
    function RefreshTextBoxSizes_Bind:Run(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox) end

    RefreshTextBoxSizes_Bind_OnRun = {}
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---@return RBXScriptConnection
    function RefreshTextBoxSizes_Bind_OnRun:Connect(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---@return RBXScriptConnection
    function RefreshTextBoxSizes_Bind_OnRun:Once(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@return TTextBox TTextBox
---@return TextLabel TextLabel
---@return TextBox TextBox
    function RefreshTextBoxSizes_Bind_OnRun:Wait() end
    RefreshTextBoxSizes_Bind.OnRun = RefreshTextBoxSizes_Bind_OnRun
    Binder['RefreshTextBoxSizes']= RefreshTextBoxSizes_Bind
---@type Bind
--[[Бинд для установки размера объектам. Не забывай про TimGui.GuiSize.ButtonSize! ]]
    TObjectSize_Bind = {}
    ---@param callback fun(TGuiObject: TGuiObject)
    ---*return ()*
    function TObjectSize_Bind:Bind(callback:(TGuiObject: TGuiObject)->()) end
    ---@param TGuiObject TGuiObject
    function TObjectSize_Bind:Run(TGuiObject: TGuiObject) end

    TObjectSize_Bind_OnRun = {}
    ---@param callback fun(TGuiObject: TGuiObject)
    ---@return RBXScriptConnection
    function TObjectSize_Bind_OnRun:Connect(callback:(TGuiObject: TGuiObject)->()) end
    ---@param callback fun(TGuiObject: TGuiObject)
    ---@return RBXScriptConnection
    function TObjectSize_Bind_OnRun:Once(callback:(TGuiObject: TGuiObject)->()) end
    ---@return TGuiObject TGuiObject
    function TObjectSize_Bind_OnRun:Wait() end
    TObjectSize_Bind.OnRun = TObjectSize_Bind_OnRun
    Binder['TObjectSize']= TObjectSize_Bind
---@type Bind
--[[Бинд для установки размера глобальным группам ]]
    GlobalGroupRefreshSize_Bind = {}
    ---@param callback fun(group: TGroup)
    ---*return ()*
    function GlobalGroupRefreshSize_Bind:Bind(callback:(group: TGroup)->()) end
    ---@param group TGroup
    function GlobalGroupRefreshSize_Bind:Run(group: TGroup) end

    GlobalGroupRefreshSize_Bind_OnRun = {}
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function GlobalGroupRefreshSize_Bind_OnRun:Connect(callback:(group: TGroup)->()) end
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function GlobalGroupRefreshSize_Bind_OnRun:Once(callback:(group: TGroup)->()) end
    ---@return TGroup group
    function GlobalGroupRefreshSize_Bind_OnRun:Wait() end
    GlobalGroupRefreshSize_Bind.OnRun = GlobalGroupRefreshSize_Bind_OnRun
    Binder['GlobalGroupRefreshSize']= GlobalGroupRefreshSize_Bind
---@type Bind
--[[Бинд для анимации стрелочки ]]
    SequenceOpenArrowBind_Bind = {}
    ---@param callback fun(TSequence: TSequence)
    ---*return ()*
    function SequenceOpenArrowBind_Bind:Bind(callback:(TSequence: TSequence)->()) end
    ---@param TSequence TSequence
    function SequenceOpenArrowBind_Bind:Run(TSequence: TSequence) end

    SequenceOpenArrowBind_Bind_OnRun = {}
    ---@param callback fun(TSequence: TSequence)
    ---@return RBXScriptConnection
    function SequenceOpenArrowBind_Bind_OnRun:Connect(callback:(TSequence: TSequence)->()) end
    ---@param callback fun(TSequence: TSequence)
    ---@return RBXScriptConnection
    function SequenceOpenArrowBind_Bind_OnRun:Once(callback:(TSequence: TSequence)->()) end
    ---@return TSequence TSequence
    function SequenceOpenArrowBind_Bind_OnRun:Wait() end
    SequenceOpenArrowBind_Bind.OnRun = SequenceOpenArrowBind_Bind_OnRun
    Binder['SequenceOpenArrowBind']= SequenceOpenArrowBind_Bind
---@type Bind
--[[Бинд для установки размера MenuItem. Не забывай про GuiSize.MenuItemYSize. ]]
    MenuItemRefreshSizeBind_Bind = {}
    ---@param callback fun(MenuItem: MenuItem)
    ---*return (XSizeOffset: number)*
    function MenuItemRefreshSizeBind_Bind:Bind(callback:(MenuItem: MenuItem)->()) end
    ---@param MenuItem MenuItem
---@return number XSizeOffset
    function MenuItemRefreshSizeBind_Bind:Run(MenuItem: MenuItem) end

    MenuItemRefreshSizeBind_Bind_OnRun = {}
    ---@param callback fun(MenuItem: MenuItem)
    ---@return RBXScriptConnection
    function MenuItemRefreshSizeBind_Bind_OnRun:Connect(callback:(MenuItem: MenuItem)->()) end
    ---@param callback fun(MenuItem: MenuItem)
    ---@return RBXScriptConnection
    function MenuItemRefreshSizeBind_Bind_OnRun:Once(callback:(MenuItem: MenuItem)->()) end
    ---@return MenuItem MenuItem
    function MenuItemRefreshSizeBind_Bind_OnRun:Wait() end
    MenuItemRefreshSizeBind_Bind.OnRun = MenuItemRefreshSizeBind_Bind_OnRun
    Binder['MenuItemRefreshSizeBind']= MenuItemRefreshSizeBind_Bind
---@type Bind
--[[Бинд для обновления размера окна. Не забудь про TWindow.Size,TWindow.HeaderSize ]]
    WindowSizeRefresh_Bind = {}
    ---@param callback fun(Window: TWindow)
    ---*return ()*
    function WindowSizeRefresh_Bind:Bind(callback:(Window: TWindow)->()) end
    ---@param Window TWindow
    function WindowSizeRefresh_Bind:Run(Window: TWindow) end

    WindowSizeRefresh_Bind_OnRun = {}
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function WindowSizeRefresh_Bind_OnRun:Connect(callback:(Window: TWindow)->()) end
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function WindowSizeRefresh_Bind_OnRun:Once(callback:(Window: TWindow)->()) end
    ---@return TWindow Window
    function WindowSizeRefresh_Bind_OnRun:Wait() end
    WindowSizeRefresh_Bind.OnRun = WindowSizeRefresh_Bind_OnRun
    Binder['WindowSizeRefresh']= WindowSizeRefresh_Bind
---@type Bind
--[[Бинд для создания обьекта в Sequence. ]]
    SequenceCreateObject_Bind = {}
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---*return (SequenceObject: table)*
    function SequenceCreateObject_Bind:Bind(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@param TSequence TSequence
---@param Name string
---@param Position number
---@return table SequenceObject
    function SequenceCreateObject_Bind:Run(TSequence: TSequence,Name: string,Position: number) end

    SequenceCreateObject_Bind_OnRun = {}
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---@return RBXScriptConnection
    function SequenceCreateObject_Bind_OnRun:Connect(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---@return RBXScriptConnection
    function SequenceCreateObject_Bind_OnRun:Once(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@return TSequence TSequence
---@return string Name
---@return number Position
    function SequenceCreateObject_Bind_OnRun:Wait() end
    SequenceCreateObject_Bind.OnRun = SequenceCreateObject_Bind_OnRun
    Binder['SequenceCreateObject']= SequenceCreateObject_Bind
---@type Bind
--[[Бинд для анимации стрелочки. Не забывай про TimGui.GuiAnimations.ArrowRotateAnimationEnabled(при выкл просто тп)/ArrowRotateTI. ]]
    ArrowAnimation_Bind = {}
    ---@param callback fun(Arrow: UIBase,isOpen: boolean)
    ---*return ()*
    function ArrowAnimation_Bind:Bind(callback:(Arrow: UIBase,isOpen: boolean)->()) end
    ---@param Arrow UIBase
---@param isOpen boolean
    function ArrowAnimation_Bind:Run(Arrow: UIBase,isOpen: boolean) end

    ArrowAnimation_Bind_OnRun = {}
    ---@param callback fun(Arrow: UIBase,isOpen: boolean)
    ---@return RBXScriptConnection
    function ArrowAnimation_Bind_OnRun:Connect(callback:(Arrow: UIBase,isOpen: boolean)->()) end
    ---@param callback fun(Arrow: UIBase,isOpen: boolean)
    ---@return RBXScriptConnection
    function ArrowAnimation_Bind_OnRun:Once(callback:(Arrow: UIBase,isOpen: boolean)->()) end
    ---@return UIBase Arrow
---@return boolean isOpen
    function ArrowAnimation_Bind_OnRun:Wait() end
    ArrowAnimation_Bind.OnRun = ArrowAnimation_Bind_OnRun
    Binder['ArrowAnimation']= ArrowAnimation_Bind
---@type Bind
--[[Бинд для анимации открытия не глобальных групп. Не забудь TimGui.GuiAnimations.EnableGroupAnimation ]]
    GroupOpenArrowBind_Bind = {}
    ---@param callback fun(group: TGroup)
    ---*return ()*
    function GroupOpenArrowBind_Bind:Bind(callback:(group: TGroup)->()) end
    ---@param group TGroup
    function GroupOpenArrowBind_Bind:Run(group: TGroup) end

    GroupOpenArrowBind_Bind_OnRun = {}
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function GroupOpenArrowBind_Bind_OnRun:Connect(callback:(group: TGroup)->()) end
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function GroupOpenArrowBind_Bind_OnRun:Once(callback:(group: TGroup)->()) end
    ---@return TGroup group
    function GroupOpenArrowBind_Bind_OnRun:Wait() end
    GroupOpenArrowBind_Bind.OnRun = GroupOpenArrowBind_Bind_OnRun
    Binder['GroupOpenArrowBind']= GroupOpenArrowBind_Bind
---@type Bind
--[[Бинд для (анимации) смены цвета в Toggle в зависимости от значения. ]]
    TextColorForToggle_Bind = {}
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---*return ()*
    function TextColorForToggle_Bind:Bind(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@param Toggle TToggle
---@param enableAnimation boolean
    function TextColorForToggle_Bind:Run(Toggle: TToggle,enableAnimation: boolean) end

    TextColorForToggle_Bind_OnRun = {}
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---@return RBXScriptConnection
    function TextColorForToggle_Bind_OnRun:Connect(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---@return RBXScriptConnection
    function TextColorForToggle_Bind_OnRun:Once(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@return TToggle Toggle
---@return boolean enableAnimation
    function TextColorForToggle_Bind_OnRun:Wait() end
    TextColorForToggle_Bind.OnRun = TextColorForToggle_Bind_OnRun
    Binder['TextColorForToggle']= TextColorForToggle_Bind
---@type Bind
--[[Бинд для подсчёта видимости обьекта(свойство Visible работает поверх и его подсчитывать не нужно). ]]
    VisibleBind_Bind = {}
    ---@param callback fun(Object: TGuiObject)
    ---*return ()*
    function VisibleBind_Bind:Bind(callback:(Object: TGuiObject)->()) end
    ---@param Object TGuiObject
    function VisibleBind_Bind:Run(Object: TGuiObject) end

    VisibleBind_Bind_OnRun = {}
    ---@param callback fun(Object: TGuiObject)
    ---@return RBXScriptConnection
    function VisibleBind_Bind_OnRun:Connect(callback:(Object: TGuiObject)->()) end
    ---@param callback fun(Object: TGuiObject)
    ---@return RBXScriptConnection
    function VisibleBind_Bind_OnRun:Once(callback:(Object: TGuiObject)->()) end
    ---@return TGuiObject Object
    function VisibleBind_Bind_OnRun:Wait() end
    VisibleBind_Bind.OnRun = VisibleBind_Bind_OnRun
    Binder['VisibleBind']= VisibleBind_Bind
---@type Bind
--[[Анимация стрелочки скрытия ]]
    TWindowHideArrowAnimation_Bind = {}
    ---@param callback fun(Window: TWindow)
    ---*return ()*
    function TWindowHideArrowAnimation_Bind:Bind(callback:(Window: TWindow)->()) end
    ---@param Window TWindow
    function TWindowHideArrowAnimation_Bind:Run(Window: TWindow) end

    TWindowHideArrowAnimation_Bind_OnRun = {}
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function TWindowHideArrowAnimation_Bind_OnRun:Connect(callback:(Window: TWindow)->()) end
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function TWindowHideArrowAnimation_Bind_OnRun:Once(callback:(Window: TWindow)->()) end
    ---@return TWindow Window
    function TWindowHideArrowAnimation_Bind_OnRun:Wait() end
    TWindowHideArrowAnimation_Bind.OnRun = TWindowHideArrowAnimation_Bind_OnRun
    Binder['TWindowHideArrowAnimation']= TWindowHideArrowAnimation_Bind

---@class ButtonObject : TClass : TGuiObject
--[[Включено ли открытие меню через кнопку(ПК - правая кнопка мыши, Телефоны - зажатие) ]]
---@field OpenMenuFromButtonObject boolean
--[[Просто кнопка ]]
--*[ReadOnly]*
---@field Button TextButton
--[[Класс использющийся для создание TGuiObjects с TextButton ]]
ButtonObject={}
--[[Эмулирует нажатие кнопки ]]
function ButtonObject:Activate() end
---@type RBXScriptSignal
--[[Запускается при нажатии/эмуляции нажатия кнопки ]]
    Activated_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Activated_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Activated_RBXScriptSignal:Once(callback:()->()) end
    
    function Activated_RBXScriptSignal:Wait() end
ButtonObject['Activated']=Activated_RBXScriptSignal

---@class Colors : TClass : Preset
--[[Цвет текста кнопок ]]
---@field TextColor Color3
--[[Цвет кнопки отмены на окне(обычно промтах) ]]
---@field OnTWindowCancelButtonColor Color3
--[[Цвет текста для Обьектов без фона, например: TText ]]
---@field TTextColor Color3
--[[Цвет фона в заголовке ]]
---@field HeaderBackgroundColor Color3
--[[Цвет фона у TWindow ]]
---@field TWindowBackgroundColor Color3
--[[Цвет стрелочки для статуса открытия не глобальных групп ]]
---@field GroupOpenArrowColor Color3
--[[Цвет текста кнопки подтверждения на окне(обычно промтах) ]]
---@field OnTWindowConfirmButtonTextColor Color3
--[[Цвет фона TextBox'а на окне ]]
---@field OnTWindowTextBoxBackgroundColor Color3
--[[Цвет кнопки в кнопке ]]
---@field ButtonOnButtonBackground Color3
--[[Основной цвет(текст/картинка или другое) кнопки в кнопки ]]
---@field ButtonOnButtonMain Color3
--[[Цвет фона кнопок ]]
---@field ButtonBackground Color3
--[[Цвет фона в Группах ]]
---@field GroupsBackgroundColor Color3
--[[Цвет фона ]]
---@field MainBackgroundColor Color3
--[[Цвет картинки у кнопки закрытия окна TWindow ]]
---@field TWindowCloseColor Color3
--[[Цвет текста MenuItem в Menu ]]
---@field MenuItemTextColor Color3
--[[Цвет фона у кнопки закрытия TWindow, появляющийся при наводке ]]
---@field TWindowBackgroundCloseColor Color3
--[[Цвет фона MenuItem в Menu ]]
---@field MenuBackgroundTextColor Color3
--[[Цвет ошибки на кнопке статуса(вместо кнопки открытия) ]]
---@field ErrorColor Color3
--[[Цвет кнопки подтверждения на окне(обычно промтах) ]]
---@field OnTWindowConfirmButtonColor Color3
--[[Цвет второй части имени в заголовке ]]
---@field HeaderSecondNameColor Color3
--[[Цвет разделителя в заголовке ]]
---@field HeaderSeparatorColor Color3
--[[Цвет текста MenuText в Menu ]]
---@field MenuTextTextColor Color3
--[[Цвет фона у Header в TWindow ]]
---@field TWindowHeaderBackgroundColor Color3
--[[Цвет текстов на TWindow'ах ]]
---@field OnTWindowTextColor Color3
--[[Цвет стрелочки открытия ]]
---@field ArrowColor Color3
--[[Цвет текста заголовка в TWindow ]]
---@field TWindowHeaderTextColor Color3
--[[Цвет текста кнопки отмены на окне(обычно промтах) ]]
---@field OnTWindowCancelButtonTextColor Color3
--[[Цвет текста TextBox'а на окне ]]
---@field OnTWindowTextBoxTextColor Color3
--[[Цвет первой части имени в заголовке ]]
---@field HeaderFirstNameColor Color3
--[[Цвет видимого отступа не глобальных групп ]]
---@field GroupVisibleIndent Color3
--[[Класс для цветов, использующий пресет ]]
Colors={}

---@class ConfigObject : TClass
--[[Задержка для сохранения(чтобы убрать спам при сменах свойств), по умолчанию 0.25. Отрицательные значения выключают автосохранения ]]
---@field ConfigSavingDelay number
--[[Имя сохранения в конфиге(если используется уже существующее, просто не сохраняет) ]]
---@field ConfigSaveName string
--[[Включено ли сохранение(P.S: загрузка тоже)?[Может не сохраняться изза одинакого имени но всё равно стоять true] ]]
---@field ConfigSavingEnabled boolean
--[[Сохранение для TClass параметров. При создании класса возможно был выключен параметр otherClassesSaving, и поэтому обьект должен состоять из одинаковых классов при сохранении и загрузке ]]
ConfigObject={}
--[[Для проверки сохраняется ли свойство ]]
---@param PropertyName string Имя свойства
---@return string PropertyName Имя свойства
function ConfigObject:IsSavingProperty(PropertyName) end
--[[Устанавливает свойство по значению сохранённому в конфигурации ]]
---@param PropertyName string Имя свойства?
---@param doResetValueToDefault boolean Сбрасывать ли для стандартного, если не указано? `nil` будет восприниматься как `true`?
---@return string PropertyName Имя свойства
---@return boolean doResetValueToDefault Сбрасывать ли для стандартного, если не указано? `nil` будет восприниматься как `true`
function ConfigObject:LoadConfigSave(PropertyName,doResetValueToDefault) end
--[[Выдает `false` если имя используется другим обьектом, или вернёт `ConfigSavingEnabled` ]]
function ConfigObject:IsConfigSavingEnabled() end
--[[Добавляет свойство в сохранение конфигураций, может также использоваться для смены стандартного значения ]]
---@param PropertyName string Имя свойства
---@param defaultValue any Стандартное значение, если его нет в конфиге, то загружает его. Если `nil`, то не сбрасывает его?
---@return string PropertyName Имя свойства
---@return any defaultValue Стандартное значение, если его нет в конфиге, то загружает его. Если `nil`, то не сбрасывает его
function ConfigObject:AddPropertyToConfigSave(PropertyName,defaultValue) end
--[[Для установки автосохранения для свойства ]]
---@param PropertyName string Имя свойства
---@param IsEnabled boolean Включено ли автосохранение для свойства
---@return string PropertyName Имя свойства
---@return boolean IsEnabled Включено ли автосохранение для свойства
function ConfigObject:SetEnabledAutosaveFor(PropertyName,IsEnabled) end
--[[Для проверки автосохраняется ли свойство ]]
---@param PropertyName string Имя свойства
---@return string PropertyName Имя свойства
function ConfigObject:IsEnabledAutosaveFor(PropertyName) end

---@class Configs : TClass
--[[Окно конфигураций ]]
--*[ReadOnly]*
---@field Window TWindow
--[[Класс получения информации о конфигурациях(для действий с конфигурациями см. ControlCfg), чтобы получить или сохранить данные используй Saves/TScript ]]
Configs={}
--[[Возвращает название загруженого конфига ]]
function Configs:LoadedConfig() end
---@type RBXScriptSignal
--[[Запускается если конфигурация была сохранена/изменена ]]
    OnConfigDataChanged_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnConfigDataChanged_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnConfigDataChanged_RBXScriptSignal:Once(callback:()->()) end
    
    function OnConfigDataChanged_RBXScriptSignal:Wait() end
Configs['OnConfigDataChanged']=OnConfigDataChanged_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается если конфигурация была загружена ]]
    OnLoaded_RBXScriptSignal = {}
    ---@param callback fun(Name?:string)
    ---@return RBXScriptConnection
    function OnLoaded_RBXScriptSignal:Connect(callback:(Name:string?)->()) end
    ---@param callback fun(Name?:string)
    ---@return RBXScriptConnection
    function OnLoaded_RBXScriptSignal:Once(callback:(Name:string?)->()) end
    ---@return string? Name
    function OnLoaded_RBXScriptSignal:Wait() end
Configs['OnLoaded']=OnLoaded_RBXScriptSignal

---@class ConfirmationPrompt : TClass : ConfigObject : TWindow : Prompt
--[[Может ли пользователь отменить, через кнопку закрытия окна? ]]
---@field CancelEnabled boolean
--[[Текст для кнопки отклонения ]]
--*[ReadOnly]*
---@field RejectText TTranslator
--[[TextLabel описания ]]
--*[ReadOnly]*
---@field DescriptionLabel TextLabel
--[[Текст для кнопки подтверждения ]]
--*[ReadOnly]*
---@field ConfirmText TTranslator
--[[Размер текста описания ]]
---@field DescriptionTextSize number
--[[Frame в котором находятся кнопки 'Подтвердить' и 'Отклонить' ]]
--*[ReadOnly]*
---@field Buttons Frame
--[[Кнопка подтверждения(берёт текст из `.ConfirmText`) ]]
--*[ReadOnly]*
---@field ConfirmButton TextButton
--[[Кнопка отклонения(берёт текст из `.RejectText`) ]]
--*[ReadOnly]*
---@field RejectButton TextButton
--[[Класс ConfirmationPrompt, для подтверждения действия. Отмена = закрытие окна ]]
ConfirmationPrompt={}
---@type RBXScriptSignal
--[[Запускается когда обновился размер(описания и тд) и позиции ]]
    OnSizeRefreshed_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnSizeRefreshed_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnSizeRefreshed_RBXScriptSignal:Once(callback:()->()) end
    
    function OnSizeRefreshed_RBXScriptSignal:Wait() end
ConfirmationPrompt['OnSizeRefreshed']=OnSizeRefreshed_RBXScriptSignal
---@type Bind
--[[Специальный Bind для установки размера описанию. Работает как в Binder.ConfirmationPromptDescriptionSizeBind ]]
    SpecialDescriptionSizeBind_Bind = {}
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function SpecialDescriptionSizeBind_Bind:Bind(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@param ConfirmationPrompt ConfirmationPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function SpecialDescriptionSizeBind_Bind:Run(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim) end

    SpecialDescriptionSizeBind_Bind_OnRun = {}
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function SpecialDescriptionSizeBind_Bind_OnRun:Connect(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function SpecialDescriptionSizeBind_Bind_OnRun:Once(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@return ConfirmationPrompt ConfirmationPrompt
---@return UDim startYPos
    function SpecialDescriptionSizeBind_Bind_OnRun:Wait() end
    SpecialDescriptionSizeBind_Bind.OnRun = SpecialDescriptionSizeBind_Bind_OnRun
    ConfirmationPrompt['SpecialDescriptionSizeBind']= SpecialDescriptionSizeBind_Bind

---@class GuiAnimations : TClass : Preset
--[[Включена ли анимация открытия/закрытия групп ]]
---@field EnableGroupAnimation boolean
--[[Включена ли анимация смены цвет Toggle ]]
---@field EnableTextColorForToggleAnimation boolean
--[[TweenInfo анимации стрелочки групп ]]
---@field GroupOpenArrowTI TweenInfo
--[[TweenInfo поворота стрелочки ]]
---@field ArrowRotateTI TweenInfo
--[[Включена ли анимация поворота стрелочки ]]
---@field ArrowRotateAnimationEnabled boolean
--[[TweenInfo анимации цвета текста Toggle ]]
---@field TextColorForToggleTI TweenInfo
--[[TweenInfo анимации стрелочки показа/скрытия окна TWindow ]]
---@field TWindowHideArrowTI TweenInfo
--[[Включена ли анимация стрелочки при показе/скрытии окна ]]
---@field EnableArrowTWindowAnimation boolean
--[[Включена ли анимация открытия ]]
---@field OpenAnimationEnabled boolean
--[[TweenInfo открытия ]]
---@field OpenTI TweenInfo
--[[Класс для кастомизации анимаций, использующий пресеты ]]
GuiAnimations={}
--[[Анимировать открытие ]]
---@param isOpened boolean Состояние открытия, если `nil` то возьмёт из `_G.TimGui.Opened`?
---@return boolean isOpened Состояние открытия, если `nil` то возьмёт из `_G.TimGui.Opened`
function GuiAnimations:OpenAnimation(isOpened) end
--[[Анимировать прокрутку стрелочки(как при открытии) ]]
---@param isOpened boolean Состояние стрелки, если `nil` то возьмёт из `_G.TimGui.Opened`?
---@return boolean isOpened Состояние стрелки, если `nil` то возьмёт из `_G.TimGui.Opened`
function GuiAnimations:ArrowRotateAnimation(isOpened) end

---@class GUIArchitecture : TClass
--[[Frame с кнопками в группе,canChange: true, но false в TimGui.Groups ]]
---@field GroupFrame Frame
--[[Глобальная ли группа ]]
---@field IsGlobal boolean
--[[Размер группы(Последняя полученная точка при запуске :Refresh()) ]]
---@field GroupSize UDim2
--[[Класс относящийся к глобальной Архитектуре интерфейса. Можно получать детей через This.ChildName(также как в Instance и выдаст ошибку если не найдено!) ]]
GUIArchitecture={}
--[[Вернёт первого ребёнка с таким именем ]]
---@param childName string Имя ребёнка
---@return string childName Имя ребёнка
function GUIArchitecture:FindFirstChild(childName) end
--[[Обновляет позиции объектов в группе ]]
---@param FromObject TGuiObject Обновляет после и включая этот обьект. Если отсутствует, то обновляет со старта?
---@param notParentRefreshing boolean Нужно ли обновлять Parent(если parent группа и не TimGui.Groups)?
---@return TGuiObject FromObject Обновляет после и включая этот обьект. Если отсутствует, то обновляет со старта
---@return boolean notParentRefreshing Нужно ли обновлять Parent(если parent группа и не TimGui.Groups)
function GUIArchitecture:RefreshGroup(FromObject,notParentRefreshing) end
--[[Создаст группу в этой архитектуре ]]
---@param Name string Имя группы
---@param Title string | table<string,string> | TTranslator Заголовок, может быть TTranslator | table({'ru'='rus','en'='eng'}) | string?, если нету берётся название обьекта?
---@return string Name Имя группы
---@return string | table<string,string> | TTranslator Title Заголовок, может быть TTranslator | table({'ru'='rus','en'='eng'}) | string?, если нету берётся название обьекта
function GUIArchitecture:CreateGroup(Name,Title) end
---@type RBXScriptSignal
--[[Запускается когда архитекртура обновилась(тоесть когда :RefreshGroup() был закончен) ]]
    GroupRefreshed_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function GroupRefreshed_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function GroupRefreshed_RBXScriptSignal:Once(callback:()->()) end
    
    function GroupRefreshed_RBXScriptSignal:Wait() end
GUIArchitecture['GroupRefreshed']=GroupRefreshed_RBXScriptSignal
---@type TSignal
--[[Запускается когда убран ребёнок ]]
    ChildRemoved_TSignal = {}
    ---@param callback fun(name:TGuiObject)
    ---@return RBXScriptConnection
    function ChildRemoved_TSignal:Connect(callback:(name:TGuiObject)->()) end
    ---@param callback fun(name:TGuiObject)
    ---@return RBXScriptConnection
    function ChildRemoved_TSignal:Once(callback:(name:TGuiObject)->()) end
    ---@return TGuiObject name
    function ChildRemoved_TSignal:Wait() end
GUIArchitecture['ChildRemoved']=ChildRemoved_TSignal
---@type TSignal
--[[Запускается когда добавлен новый ребёнок ]]
    ChildAdded_TSignal = {}
    ---@param callback fun(name:TGuiObject)
    ---@return RBXScriptConnection
    function ChildAdded_TSignal:Connect(callback:(name:TGuiObject)->()) end
    ---@param callback fun(name:TGuiObject)
    ---@return RBXScriptConnection
    function ChildAdded_TSignal:Once(callback:(name:TGuiObject)->()) end
    ---@return TGuiObject name
    function ChildAdded_TSignal:Wait() end
GUIArchitecture['ChildAdded']=ChildAdded_TSignal
---@type Bind
--[[Бинд для обновления позиций кнопок в группе. Работает как в Binder.RefreshingBind ]]
    SpecialRefreshingBind_Bind = {}
    ---@param callback fun(Children: table,FromObject: TGuiObject)
    ---*return (EndPoint: UDim2)*
    function SpecialRefreshingBind_Bind:Bind(callback:(Children: table,FromObject: TGuiObject)->()) end
    ---@param Children table<number,TGuiObject>
---@param FromObject TGuiObject
---@return UDim2 EndPoint
    function SpecialRefreshingBind_Bind:Run(Children: table,FromObject: TGuiObject) end

    SpecialRefreshingBind_Bind_OnRun = {}
    ---@param callback fun(Children: table,FromObject: TGuiObject)
    ---@return RBXScriptConnection
    function SpecialRefreshingBind_Bind_OnRun:Connect(callback:(Children: table,FromObject: TGuiObject)->()) end
    ---@param callback fun(Children: table,FromObject: TGuiObject)
    ---@return RBXScriptConnection
    function SpecialRefreshingBind_Bind_OnRun:Once(callback:(Children: table,FromObject: TGuiObject)->()) end
    ---@return table<number,TGuiObject> Children
---@return TGuiObject FromObject
    function SpecialRefreshingBind_Bind_OnRun:Wait() end
    SpecialRefreshingBind_Bind.OnRun = SpecialRefreshingBind_Bind_OnRun
    GUIArchitecture['SpecialRefreshingBind']= SpecialRefreshingBind_Bind

---@class GuiInstances : TClass
--[[Иконка открытия(обычно,стрелочка) ]]
--*[ReadOnly]*
---@field OpenImage ImageLabel
--[[Текст над кнопкой открытия, появляющийся при наводке на эту кнопку ]]
--*[ReadOnly]*
---@field Saying Frame
--[[Главный Frame, на котором расположено само меню со всеми кнопками ]]
--*[ReadOnly]*
---@field Main Frame
--[[Разделитель в заголовке ]]
--*[ReadOnly]*
---@field HeaderSeparator TextLabel
--[[Иконка которая появляется при ошибке вместо кнопки открытия ]]
--*[ReadOnly]*
---@field ErrorStateImage ImageLabel
--[[Заголовок ]]
--*[ReadOnly]*
---@field Header Frame
--[[Frame со статусами и кнопкой открытия ]]
--*[ReadOnly]*
---@field State Frame
--[[Информация в заголовке ]]
--*[ReadOnly]*
---@field HeaderInfo TextLabel
--[[Иконка которая появляется при загрузке вместо кнопки открытия ]]
--*[ReadOnly]*
---@field LoadingStateImage ImageLabel
--[[Вторая часть текста заголовка ]]
--*[ReadOnly]*
---@field SecondHeaderName TextLabel
--[[Первая часть текста заголовка ]]
--*[ReadOnly]*
---@field FirstHeaderName TextLabel
--[[Главный ScreenGui ]]
--*[ReadOnly]*
---@field ScreenGui ScreenGui
--[[Класс с GUI обьектами ]]
GuiInstances={}

---@class GuiKeybindingObject : TClass : TGuiObject
--[[Включены ли кейбинды для этого обьекта? ]]
---@field KeybindingEnabled boolean
--[[Keybinder этого обьекта ]]
--*[ReadOnly]*
---@field Keybinder Keybinder
--[[Пример класса ]]
GuiKeybindingObject={}

---@class GuiObjects : TClass
--[[Класс для создания групп и кнопок. Находится в TimGui.GuiObjects ]]
GuiObjects={}
--[[Создаёт кнопку-последовательность, благодаря которой можно создать последовательность действий ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent GUIArchitecture Parent для этого обьекта?
---@param callback fun(self: TSequence) Функция, для установки на смену значения?
---@param Objects table<string,string> | table<string,table<string,string>> Таблица с обьектами, где ключ - имя кнопки, а значение - либо таблица переводов, либо заголовок?
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
---@return GUIArchitecture Parent Parent для этого обьекта
---@return fun(self: TSequence) callback Функция, для установки на смену значения
---@return table<string,string> | table<string,table<string,string>> Objects Таблица с обьектами, где ключ - имя кнопки, а значение - либо таблица переводов, либо заголовок
function GuiObjects:CreateSequence(Name,Title,Parent,callback,Objects) end
--[[Создаёт кнопку ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent GUIArchitecture Parent для этого обьекта?
---@param callback fun(self: TButton) Функция, для установки на клик, запускается с этой же кнопкой?
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
---@return GUIArchitecture Parent Parent для этого обьекта
---@return fun(self: TButton) callback Функция, для установки на клик, запускается с этой же кнопкой
function GuiObjects:CreateButton(Name,Title,Parent,callback) end
--[[Создаёт переключатель(тумблер) ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent GUIArchitecture Parent для этого обьекта?
---@param callback fun(self: TToggle) Функция, для установки на клик, запускается с этим же переключателем?
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
---@return GUIArchitecture Parent Parent для этого обьекта
---@return fun(self: TToggle) callback Функция, для установки на клик, запускается с этим же переключателем
function GuiObjects:CreateToggle(Name,Title,Parent,callback) end
--[[Создаёт просто текст ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent GUIArchitecture Parent для этого обьекта?
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
---@return GUIArchitecture Parent Parent для этого обьекта
function GuiObjects:CreateText(Name,Title,Parent) end
--[[Создаёт поле для ввода данных(TextBox), данные могут быть не только текстовыми ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent GUIArchitecture Parent для этого обьекта?
---@param callback fun(self: TTextBox) Функция, для установки на смену значения, запускается с этим же TTextBox?
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
---@return GUIArchitecture Parent Parent для этого обьекта
---@return fun(self: TTextBox) callback Функция, для установки на смену значения, запускается с этим же TTextBox
function GuiObjects:CreateTextbox(Name,Title,Parent,callback) end
--[[Создаёт группу ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param Parent GUIArchitecture Parent для этого обьекта?
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
---@return GUIArchitecture Parent Parent для этого обьекта
function GuiObjects:CreateGroup(Name,Title,Parent) end

---@class GuiSize : TClass : Preset
--[[Включена ли стандартная установка размеру и позиции основному Frame ]]
---@field DefaultPositionEnabled boolean
--[[Размер текста MenuItem'а ]]
---@field MenuItemTextSize number
--[[Точка крепления основного Frame ]]
---@field AnchorPoint Vector2
--[[X Позиция основы ]]
---@field XPosition UDim
--[[Высота основы(без заголовка) ]]
---@field Height UDim
--[[Y Позиция основы ]]
---@field YPosition UDim
--[[Толщина ScrollBar'а в Keybinder'е ]]
---@field KeybinderScrollBarThickness number
--[[Радиус скруглённых углов у кнопок ]]
---@field ButtonCornerRadius UDim
--[[Размер Y MenuItem'а ]]
---@field MenuItemYSize number
--[[Размер заголовка в Keybinder'е ]]
---@field KeybinderTitleSize UDim2
--[[Радиус скругления верхних углов(заголовка) TWindow ]]
---@field TWindowHeaderCornerRadius UDim
--[[Y размер Keybind в Keybinder ]]
---@field KeybindYSize UDim
--[[Размер шрифта текста над кнопкой открытия(Scale - размер кнопки) ]]
---@field SayingFontSize UDim
--[[Размер TextBox'а в TextPrompt'е ]]
---@field TextBoxPromptSize UDim2
--[[Размер невидимой части отступа не глобальных групп(только с одной стороны) ]]
---@field NotGlobalGroupIndent UDim
--[[Размер заголовка(названия) выбранного конфига в конфигураторе ]]
---@field ConfigsTitleSize UDim2
--[[Размер текста MenuText'а ]]
---@field MenuTextTextSize number
--[[X Размер разделения окна конфигураций(между списком конфигов и выбранным конфигом) ]]
---@field ConfigsSeparatorSize UDim
--[[Размер невидимой части отступа не TSequence(только с одной стороны) ]]
---@field NotGlobalSequenceIndent UDim
--[[Размер обьектов в TSequence ]]
---@field SequenceObjectSize UDim2
--[[Радиус скругления кнопок внутри Keybind ]]
---@field KeybindButtonsCornerRadius UDim
--[[Y Размер конфигураций в размере конфигуратора ]]
---@field ConfigsWindowConfigsSize UDim
--[[Размер видимой части отступа не глобальных групп ]]
---@field NotGlobalGroupVisibleIndent UDim
--[[Y Размер нижних кнопок в Keybinder'е ]]
---@field KeybinderButtonsYSize UDim
--[[XAlign, к чему прикрепить кнопки и TextBox в TextPrompt(0-лево,0.5-центр,1-право) ]]
---@field TextPromptXAnchor number
--[[Радиус скругления Keybind ]]
---@field KeybindCornerRadius UDim
--[[Размер Frame с кнопками в TextPrompt'е ]]
---@field TextPromptButtonsSize UDim2
--[[Высота заголовка окна ]]
---@field HeaderSize UDim
--[[Размер для иконки статуса открытия не TSequence. Scale - Y размер кнопки ]]
---@field SequenceOpenImageSize UDim
--[[Размер видимой части отступа не TSequence ]]
---@field NotGlobalSequenceVisibleIndent UDim
--[[Ширина скролла глобальных групп ]]
---@field GroupsSize UDim
--[[Радиус скругления нижних углов(заголовка) TWindow ]]
---@field TWindowCornerRadius UDim
--[[Ширина основы ]]
---@field Width UDim
--[[Размер кнопки для перемещения для обьекта TSequence. Scale - Y всего frame ]]
---@field SequenceObjectGrabSize UDim
--[[Размер текста для описания в TextPrompt ]]
---@field TextPromptDescriptionTextSize number
--[[Отступ промта сверху и снизу ]]
---@field PromptYIndent UDim2
--[[X размер списка конфигураций(слево) в конфигураторе ]]
---@field ConfigsWindowConfigsFrameSize UDim
--[[Размер для иконки статуса открытия не глобальных групп. Scale - Y размер кнопки ]]
---@field GroupOpenImageSize UDim
--[[Класс для кастомизации размеров интерфейса ]]
GuiSize={}

---@class GuiState : TClass
--[[Служит для включения/выключения надписи при наводке на кнопку открытия ]]
---@field SayEnabled boolean
--[[Текст из переводчика который будет появляться при наводе если `SayEnabled==true` ]]
---@field Saying TTranslator
--[[Включено ли открытие? ]]
---@field OpenEnabled boolean
--[[Активный статус: Error/Loading/None ]]
---@field ActiveState string
--[[За сколько секунд loading сделает круг. ]]
---@field LoadingSpeed number
--[[Класс для изменения кнопки открытия в статус, например 'загрузка' или 'ошибка'(Блокирует открытие) ]]
GuiState={}
--[[Устанавливает статус на загрузку(ActiveStatus=`Loading`) ]]
function GuiState:SetLoadingState() end
--[[Устанавливает статус на ошибку(ActiveStatus=`Error`) ]]
function GuiState:SetErrorState() end
--[[Сбрасывает на значения по умолчанию(ActiveStatus=`None`,OpenEnabled=`true`) ]]
function GuiState:ResetToDefault() end
---@type RBXScriptSignal
--[[Запускается когда изменился статус через любой метод в классе ]]
    onStateChanged_RBXScriptSignal = {}
    ---@param callback fun(arg:any)
    ---@return RBXScriptConnection
    function onStateChanged_RBXScriptSignal:Connect(callback:(arg:any)->()) end
    ---@param callback fun(arg:any)
    ---@return RBXScriptConnection
    function onStateChanged_RBXScriptSignal:Once(callback:(arg:any)->()) end
    ---@return any arg
    function onStateChanged_RBXScriptSignal:Wait() end
GuiState['onStateChanged']=onStateChanged_RBXScriptSignal

---@class Header : TClass
--[[Ширина разделителя(может быть 0 или меньше) ]]
---@field SeparatorSize number
--[[Информация в заголовке(По умолчанию время).Если не string, то конвертирует в string. Listeners: 1-clock, 2-fps ]]
--*[ReadOnly]*
---@field InfoValue ValueBinder
--[[Вторая часть Имени ]]
--*[ReadOnly]*
---@field SecondName TTranslator
--[[Первая часть Имени ]]
--*[ReadOnly]*
---@field FirstName TTranslator
--[[Класс для кастомизации заголовка ]]
Header={}

---@class Keybinder : TClass
--[[Имя keybinder'а, задаётся только при создании ]]
--*[ReadOnly]*
---@field Name string
--[[Frame с кнопками ]]
--*[ReadOnly]*
---@field Buttons Frame
--[[Основной ScrollingFrame в котором находятся keybind'ы ]]
--*[ReadOnly]*
---@field KeybindsScroll ScrollingFrame
--[[`EventType` по умолчанию ]]
---@field DefaultType string
--[[Включено ли сохранение? если оно выключено через конфиг, а тут `true`, то сохраняться не будет ]]
---@field SaveEnabled boolean
--[[Открыто ли окно? ]]
---@field Opened boolean
--[[Включено ли автосохранение? если оно выключено через конфиг, а тут `true`, то автосохраняться не будет ]]
---@field AutosaveEnabled boolean
--[[Название окна ]]
--*[ReadOnly]*
---@field Title TTranslator
--[[Окно keybinder'а ]]
--*[ReadOnly]*
---@field Window TWindow
--[[Специальные цвета, связаны с специальными цветами у окна ]]
--*[ReadOnly]*
---@field SpecialColors SpecialColors
--[[TextLabel, содержащий Title ]]
--*[ReadOnly]*
---@field TitleLabel TextLabel
--[[Выключено ли сохранение изза того, что имя уже используется? ]]
--*[ReadOnly]*
---@field SavingDisabledByName boolean
--[[Класс Keybinder, нужен для назначения клавиш с разными режимами ]]
Keybinder={}
--[[Возвращает заголовок EventType'а ]]
---@param name string Имя эвента
---@return string name Имя эвента
function Keybinder:GetEventTypeTitle(name) end
--[[Загружает из таблицы Keybind'ов ]]
---@param Keybinds table<number,table> Таблица с данными Keybind'ов
---@return table<number,table> Keybinds Таблица с данными Keybind'ов
function Keybinder:LoadKeybindsTable(Keybinds) end
--[[Возвращает все Keybind'ы этого Keybinder'а ]]
function Keybinder:GetKeybinds() end
--[[Спрашивает у пользователя EventType этого Keybinder'а ]]
---@param Position UDim2 В какой позиции показать меню выбора
---@param selected string Выбранный EventType(чтобы он был в начале списка)?
---@return UDim2 Position В какой позиции показать меню выбора
---@return string selected Выбранный EventType(чтобы он был в начале списка)
function Keybinder:AskEventType(Position,selected) end
--[[Создаёт KeybindObject с `.Parent` в этом binder'е ]]
function Keybinder:CreateKeybind() end
--[[Загружает Keybinds из config ]]
function Keybinder:LoadFromConfig() end
--[[Удаляет Keybinder ]]
function Keybinder:Destroy() end
--[[Обновляет позиции в Keybinder'е ]]
function Keybinder:RefreshPositions() end
--[[Добавляет EventType в Keybinder ]]
---@param name string Имя эвента, которое будет участвоваться в `.Event`
---@param title string | table<string,string> | TTranslator Заголовок для EventType
---@return string name Имя эвента, которое будет участвоваться в `.Event`
---@return string | table<string,string> | TTranslator title Заголовок для EventType
function Keybinder:AddEventType(name,title) end
--[[Сохраняет Keybinds в config, если включено через конфиг и `Keybinder.SaveEnabled==true` ]]
function Keybinder:SaveToConfig() end
--[[Возвращает таблицу с именами эвентов ]]
function Keybinder:GetEventNames() end
--[[Возвращает таблицу Keybind'ов этого Keybinder'а, чтобы сохранять её своими способами ]]
function Keybinder:GetKeybindsTable() end
--[[Спрашивает ключ от лица этого Keybinder ]]
---@param Description table<string,string> Описание,которое видит пользователь, для выбора ключа. Таблица где ключ- код языка, а значение перевод({"en":"English","ru":"Русский"})
---@return table<string,string> Description Описание,которое видит пользователь, для выбора ключа. Таблица где ключ- код языка, а значение перевод({"en":"English","ru":"Русский"})
function Keybinder:AskKey(Description) end
---@type RBXScriptSignal
--[[Эвент, который запускается если изменился перевод заголовка какого либо EventType ]]
    EventTypeTranslateRefresh_RBXScriptSignal = {}
    ---@param callback fun(EventType:string)
    ---@return RBXScriptConnection
    function EventTypeTranslateRefresh_RBXScriptSignal:Connect(callback:(EventType:string)->()) end
    ---@param callback fun(EventType:string)
    ---@return RBXScriptConnection
    function EventTypeTranslateRefresh_RBXScriptSignal:Once(callback:(EventType:string)->()) end
    ---@return string EventType
    function EventTypeTranslateRefresh_RBXScriptSignal:Wait() end
Keybinder['EventTypeTranslateRefresh']=EventTypeTranslateRefresh_RBXScriptSignal
---@type TSignal
--[[Эвент, который запускается при запуске любого `BaseKeybind.Event` в этом Keybinder'е ]]
    Event_TSignal = {}
    ---@param callback fun(EventType:string,Keybind:KeybindObject,Input?:InputObject,GPE?:boolean)
    ---@return RBXScriptConnection
    function Event_TSignal:Connect(callback:(EventType:string,Keybind:KeybindObject,Input:InputObject?,GPE:boolean?)->()) end
    ---@param callback fun(EventType:string,Keybind:KeybindObject,Input?:InputObject,GPE?:boolean)
    ---@return RBXScriptConnection
    function Event_TSignal:Once(callback:(EventType:string,Keybind:KeybindObject,Input:InputObject?,GPE:boolean?)->()) end
    ---@return string EventType
---@return KeybindObject Keybind
---@return InputObject? Input
---@return boolean? GPE
    function Event_TSignal:Wait() end
Keybinder['Event']=Event_TSignal

---@class KeyBinding : TClass
--[[Если `false`, то не реагирует на нажатие кнопки ]]
---@field EventsEnabled boolean
--[[Если `true`, то блокирует следующее нажатие кнопки. Служит, чтобы автокликеры не вызывали KeyBind'ы ]]
---@field NextBlocked boolean
--[[Класс для создания привязок к кнопкам и находится в TimGui.KeyBinding. Кнопка мыши: 1-Левая,2-Правая,3-Колёсико ]]
KeyBinding={}
--[[Возвращает TSignal, запускаемый нажатием этой кнопки ]]
---@param KeyName string Название кнопки
---@return string KeyName Название кнопки
function KeyBinding:GetKeyBeganEvent(KeyName) end
--[[Создаёт KeybindObject ]]
function KeyBinding:CreateKeybindObject() end
--[[Создаёт Keybinder ]]
---@param Name string Название keybinder'у
---@param Title string | table<string,string> | TTranslator Заголовок?
---@param disableDefaultConfigSettingsRefreshForWindow boolean Выключены ли стандартное обновление сохранений при смене настроек конфига для окна?
---@return string Name Название keybinder'у
---@return string | table<string,string> | TTranslator Title Заголовок
---@return boolean disableDefaultConfigSettingsRefreshForWindow Выключены ли стандартное обновление сохранений при смене настроек конфига для окна
function KeyBinding:CreateKeybinder(Name,Title,disableDefaultConfigSettingsRefreshForWindow) end
--[[Возвращает TSignal, запускаемый разжатием этой кнопки ]]
---@param KeyName string Название кнопки
---@return string KeyName Название кнопки
function KeyBinding:GetKeyEndedEvent(KeyName) end
--[[Возвращает имя ключа по KeyCode ]]
---@param KeyCode Enum.KeyCode KeyCode
---@return Enum.KeyCode KeyCode KeyCode
function KeyBinding:GetKeyNameFromKeyCode(KeyCode) end
--[[Возвращает TSignal, запускаемый нажатием или разжатием этой кнопки ]]
---@param KeyName string Название кнопки
---@return string KeyName Название кнопки
function KeyBinding:GetKeyEvent(KeyName) end
--[[Создаёт ключ кнопки клавиатуры(TKey) ]]
---@param MouseCode number Кнопка мыши от 1 до 3(включительно)
---@param Holding table<string,boolean> Таблица нажатых специальные кнопок, где ключ - название, значение - boolean(зажато ли?)?
---@return number MouseCode Кнопка мыши от 1 до 3(включительно)
---@return table<string,boolean> Holding Таблица нажатых специальные кнопок, где ключ - название, значение - boolean(зажато ли?)
function KeyBinding:CreateMouseKey(MouseCode,Holding) end
--[[Создаёт ключ кнопки клавиатуры(TKey) ]]
---@param KeyCode Enum.KeyCode KeyCode
---@param Holding table<string,boolean> Таблица нажатых специальные кнопок, где ключ - название, значение - boolean(зажато ли?)?
---@return Enum.KeyCode KeyCode KeyCode
---@return table<string,boolean> Holding Таблица нажатых специальные кнопок, где ключ - название, значение - boolean(зажато ли?)
function KeyBinding:CreateKeyboardKey(KeyCode,Holding) end
---@type TSignal
--[[Event, запускаемый когда кнопка нажата/отжата (Игнорирует `NextBlocked` и `EventsEnabled`) ]]
    KeyEvent_TSignal = {}
    ---@param callback fun(Key:TKey,GPE:boolean,input:InputObject)
    ---@return RBXScriptConnection
    function KeyEvent_TSignal:Connect(callback:(Key:TKey,GPE:boolean,input:InputObject)->()) end
    ---@param callback fun(Key:TKey,GPE:boolean,input:InputObject)
    ---@return RBXScriptConnection
    function KeyEvent_TSignal:Once(callback:(Key:TKey,GPE:boolean,input:InputObject)->()) end
    ---@return TKey Key
---@return boolean GPE
---@return InputObject input
    function KeyEvent_TSignal:Wait() end
KeyBinding['KeyEvent']=KeyEvent_TSignal
---@type TSignal
--[[Event, запускаемый когда кнопка отжата ]]
    Ended_TSignal = {}
    ---@param callback fun(Key:TKey,GPE:boolean)
    ---@return RBXScriptConnection
    function Ended_TSignal:Connect(callback:(Key:TKey,GPE:boolean)->()) end
    ---@param callback fun(Key:TKey,GPE:boolean)
    ---@return RBXScriptConnection
    function Ended_TSignal:Once(callback:(Key:TKey,GPE:boolean)->()) end
    ---@return TKey Key
---@return boolean GPE
    function Ended_TSignal:Wait() end
KeyBinding['Ended']=Ended_TSignal
---@type TSignal
--[[Event, запускаемый когда кнопка нажата ]]
    Began_TSignal = {}
    ---@param callback fun(Key:TKey,GPE:boolean)
    ---@return RBXScriptConnection
    function Began_TSignal:Connect(callback:(Key:TKey,GPE:boolean)->()) end
    ---@param callback fun(Key:TKey,GPE:boolean)
    ---@return RBXScriptConnection
    function Began_TSignal:Once(callback:(Key:TKey,GPE:boolean)->()) end
    ---@return TKey Key
---@return boolean GPE
    function Began_TSignal:Wait() end
KeyBinding['Began']=Began_TSignal
---@type TSignal
--[[Event, запускаемый когда специальная кнопка нажата/отжата (Игнорирует `NextBlocked` и `EventsEnabled`) ]]
    SpecialKeyEvent_TSignal = {}
    ---@param callback fun(input:InputObject,GPE:boolean)
    ---@return RBXScriptConnection
    function SpecialKeyEvent_TSignal:Connect(callback:(input:InputObject,GPE:boolean)->()) end
    ---@param callback fun(input:InputObject,GPE:boolean)
    ---@return RBXScriptConnection
    function SpecialKeyEvent_TSignal:Once(callback:(input:InputObject,GPE:boolean)->()) end
    ---@return InputObject input
---@return boolean GPE
    function SpecialKeyEvent_TSignal:Wait() end
KeyBinding['SpecialKeyEvent']=SpecialKeyEvent_TSignal

---@class KeybindObject : TClass : BaseKeybind
--[[Уникальный Id KeybindObject'а, ставится при создании ]]
--*[ReadOnly]*
---@field Id number
--[[UICorner, для скругления углов для `.Frame` ]]
--*[ReadOnly]*
---@field UICorner UICorner
--[[Специальные цвета этому обьекту ]]
--*[ReadOnly]*
---@field SpecialColors SpecialColors
--[[Кнопка для удаления этого бинда ]]
--*[ReadOnly]*
---@field DeleteButton ImageButton
--[[Позиция в окне keybinder ]]
---@field Position number
--[[Основной Frame ]]
--*[ReadOnly]*
---@field Frame Frame
--[[Родитель обьекта, может быть `nil` ]]
--*[Exception for WriteSameMode]*
---@field Parent Keybinder?
--[[Кейбинд предназначенный специально для Keybinder ]]
KeybindObject={}
--[[Удаляет этот обьект. ]]
function KeybindObject:Destroy() end
---@type RBXScriptSignal
--[[Запускается когда обьект удалён ]]
    Destroyed_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destroyed_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destroyed_RBXScriptSignal:Once(callback:()->()) end
    
    function Destroyed_RBXScriptSignal:Wait() end
KeybindObject['Destroyed']=Destroyed_RBXScriptSignal

---@class KeyPrompt : TClass : ConfigObject : TWindow : Prompt
--[[Подсказка если выбранная кнопка используется в игре ]]
--*[ReadOnly]*
---@field AlreadyUsingInGameText TTranslator
--[[Текст если кнопка выбрана, заменяет `%KEY%` - на выбранную кнопку ]]
--*[ReadOnly]*
---@field KeyText TTranslator
--[[То что нажал пользователь ]]
---@field Value TKey
--[[Текст для кнопки отмены ]]
--*[ReadOnly]*
---@field CancelText TTranslator
--[[Кнопка подтверждения(берёт текст из `.ConfirmText`) ]]
--*[ReadOnly]*
---@field ConfirmButton TextButton
--[[Frame в котором находятся кнопки 'Подтвердить' и 'Отменить' ]]
--*[ReadOnly]*
---@field Buttons Frame
--[[Включено ли выключение эвентов при клике кнопки, на время пока промпт запущен? ]]
---@field DisableOtherInputsWhenRunning boolean
--[[Основной TextLabel с выводом какая кнопка была нажата ]]
--*[ReadOnly]*
---@field TextLabel TextLabel
--[[TextLabel описания ]]
--*[ReadOnly]*
---@field DescriptionLabel TextLabel
--[[Текст для кнопки подтверждения ]]
--*[ReadOnly]*
---@field ConfirmText TTranslator
--[[Размер текста описания ]]
---@field DescriptionTextSize number
--[[Текст если кнопка не выбрана ]]
--*[ReadOnly]*
---@field NoneKeyText TTranslator
--[[Кнопка отмены(берёт текст из `.CancelText`) ]]
--*[ReadOnly]*
---@field CancelButton TextButton
--[[Может ли пользователь отменить? ]]
---@field CancelEnabled boolean
--[[Класс KeyPrompt, чтобы спрашивать клавишу(клавиатуры/мыши) у пользователя на ПК. ]]
KeyPrompt={}
---@type RBXScriptSignal
--[[Запускается когда обновился размер(описания и тд) и позиции ]]
    OnSizeRefreshed_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnSizeRefreshed_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnSizeRefreshed_RBXScriptSignal:Once(callback:()->()) end
    
    function OnSizeRefreshed_RBXScriptSignal:Wait() end
KeyPrompt['OnSizeRefreshed']=OnSizeRefreshed_RBXScriptSignal
---@type Bind
--[[Специальный Bind для установки размера описанию. Работает как в Binder.KeyPromptDescriptionSizeBind ]]
    SpecialDescriptionSizeBind_Bind = {}
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function SpecialDescriptionSizeBind_Bind:Bind(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@param KeyPrompt KeyPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function SpecialDescriptionSizeBind_Bind:Run(KeyPrompt: KeyPrompt,startYPos: UDim) end

    SpecialDescriptionSizeBind_Bind_OnRun = {}
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function SpecialDescriptionSizeBind_Bind_OnRun:Connect(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function SpecialDescriptionSizeBind_Bind_OnRun:Once(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@return KeyPrompt KeyPrompt
---@return UDim startYPos
    function SpecialDescriptionSizeBind_Bind_OnRun:Wait() end
    SpecialDescriptionSizeBind_Bind.OnRun = SpecialDescriptionSizeBind_Bind_OnRun
    KeyPrompt['SpecialDescriptionSizeBind']= SpecialDescriptionSizeBind_Bind

---@class Loggers
--[[Весь лог всех логгеров ]]
---@field Log table<number,LogMessage>
--[[Класс для создания логгеров и чтения логов ]]
Loggers={}
--[[Создаёт новый логгер ]]
---@param loggerName string Имя логгера
---@return string loggerName Имя логгера
function Loggers:New(loggerName) end
--[[Сравнивает имя класса(Loggers) с 1 параметром и выдаёт результат ]]
---@param className string Имя класса
---@return string className Имя класса
function Loggers:IsA(className) end

---@class LogMessage
--[[Данные ]]
---@field data any
--[[Имя скрипта ]]
---@field scriptName string
--[[Названия места ]]
---@field place string
--[[Результат лога, содержащий всю информацию, который можно использовать в print ]]
---@field result string
--[[Время создания лога ]]
---@field time number
--[[Данные в виде строки ]]
---@field stringData any
--[[Тип лога ]]
---@field type string
--[[Id логгера ]]
---@field loggerId number
--[[Сообщения лога ]]
LogMessage={}

---@class Menu : TClass : MenuObject
--[[Позиция меню ]]
---@field Position UDim2
--[[Просто меню ]]
Menu={}

---@class MenuButton : TClass : MenuItem
--[[Прятать ли меню при активации? ]]
---@field CloseMenuOnActivated boolean
--[[Основная кнопка этого меню обьекта ]]
--*[ReadOnly]*
---@field Button TextButton
--[[Обьект соддержащий текст(здесь - кнопка). Тоже самое что и `.Button`, но для совместимости ]]
--*[ReadOnly]*
---@field TextObject TextButton
--[[Кнопка в меню. ]]
MenuButton={}
--[[Эмулирует нажатие на кнопку ]]
function MenuButton:EmulateActivate() end
---@type RBXScriptSignal
--[[Запускается при нажатии или при запуске `:EmulateActivate()` ]]
    Activated_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Activated_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Activated_RBXScriptSignal:Once(callback:()->()) end
    
    function Activated_RBXScriptSignal:Wait() end
MenuButton['Activated']=Activated_RBXScriptSignal

---@class MenuItem : TClass
--[[Имя обьекта которое ставится при создании, нельзя менять ]]
--*[ReadOnly]*
---@field Name string
--[[Видно ли этот обьект меню ]]
---@field Visible boolean
--[[Id menu элемента, устанавливается при создании и не меняется ]]
--*[ReadOnly]*
---@field Id number
--[[X размер offset этой кнопки ]]
--*[ReadOnly]*
---@field XSizeOffset number
--[[Максимальный размер X ]]
---@field MaxXSize UDim
--[[Текст которое видит пользователь ]]
--*[ReadOnly]*
---@field Title TTranslator
--[[Специальные цвета этого обьекта ]]
--*[ReadOnly]*
---@field SpecialColors SpecialColors
--[[Позиция Y этого обьекта, when changing `.Parent` it goes to the very bottom ]]
---@field Position number
--[[Текст которое видит пользователь ]]
--*[ReadOnly]*
---@field Frame Frame
--[[Меню которому принадлежит, можно менять на nil ]]
--*[Exception for WriteSameMode]*
---@field Parent Menu?
--[[Предмет в Menu, используется в других классах ]]
MenuItem={}
--[[Обновляет размер и позици этого обьекта ]]
function MenuItem:RefreshSize() end
--[[Удаляет этот обьект ]]
function MenuItem:Destroy() end
--[[Обновляет позицию этого обьекта(и всех в `.Parent`) ]]
function MenuItem:RefreshPosition() end
---@type Bind
--[[Bind для установки позиции обьекта. Работает как в Binder.MenuItemRefreshPositionBind ]]
    SpecialRefreshPositionBind_Bind = {}
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---*return (lastYPos: UDim)*
    function SpecialRefreshPositionBind_Bind:Bind(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@param MenuItem MenuItem
---@param YPosition UDim
---@return UDim lastYPos
    function SpecialRefreshPositionBind_Bind:Run(MenuItem: MenuItem,YPosition: UDim) end

    SpecialRefreshPositionBind_Bind_OnRun = {}
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---@return RBXScriptConnection
    function SpecialRefreshPositionBind_Bind_OnRun:Connect(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---@return RBXScriptConnection
    function SpecialRefreshPositionBind_Bind_OnRun:Once(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@return MenuItem MenuItem
---@return UDim YPosition
    function SpecialRefreshPositionBind_Bind_OnRun:Wait() end
    SpecialRefreshPositionBind_Bind.OnRun = SpecialRefreshPositionBind_Bind_OnRun
    MenuItem['SpecialRefreshPositionBind']= SpecialRefreshPositionBind_Bind
---@type Bind
--[[Bind для установки размера обьекта. Работает как в Binder.MenuItemRefreshSizeBind ]]
    SpecialRefreshSizeBind_Bind = {}
    ---@param callback fun(MenuItem: MenuItem)
    ---*return (XSizeOffset: number)*
    function SpecialRefreshSizeBind_Bind:Bind(callback:(MenuItem: MenuItem)->()) end
    ---@param MenuItem MenuItem
---@return number XSizeOffset
    function SpecialRefreshSizeBind_Bind:Run(MenuItem: MenuItem) end

    SpecialRefreshSizeBind_Bind_OnRun = {}
    ---@param callback fun(MenuItem: MenuItem)
    ---@return RBXScriptConnection
    function SpecialRefreshSizeBind_Bind_OnRun:Connect(callback:(MenuItem: MenuItem)->()) end
    ---@param callback fun(MenuItem: MenuItem)
    ---@return RBXScriptConnection
    function SpecialRefreshSizeBind_Bind_OnRun:Once(callback:(MenuItem: MenuItem)->()) end
    ---@return MenuItem MenuItem
    function SpecialRefreshSizeBind_Bind_OnRun:Wait() end
    SpecialRefreshSizeBind_Bind.OnRun = SpecialRefreshSizeBind_Bind_OnRun
    MenuItem['SpecialRefreshSizeBind']= SpecialRefreshSizeBind_Bind

---@class MenuObject : TClass
--[[Открыто ли меню, лучше использовать `:Open(Position: UDim2)`, иначе откроет там где и в прошлый раз ]]
---@field Opened boolean
--[[Максимальный X размер для всего MenuObject, при смене меняет MaxXSize всем children ]]
---@field MaxXSizeForMenu UDim
--[[Находится ли курсор в этом меню? ]]
---@field MouseOnThisMenu boolean
--[[Размер меню ]]
---@field MenuSize UDim2
--[[Основной Frame с menu items ]]
--*[ReadOnly]*
---@field MenuFrame Frame
--[[Класс MenuObject,часть классов для меню (для создания самого меню или подменю). ]]
MenuObject={}
--[[Обновляет размер меню ]]
function MenuObject:RefreshMenuSize() end
--[[Создаёт MenuToggle; С `.Parent` в этом меню ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
function MenuObject:CreateMenuToggle(Name,Title) end
--[[Создаёт MenuItem; С `.Parent` в этом меню ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
function MenuObject:CreateMenuItem(Name,Title) end
--[[Удаляет этот обьект ]]
function MenuObject:Destroy() end
--[[Обновляет позиции в меню ]]
function MenuObject:RefreshMenuPosition() end
--[[Возращает детей этого MenuObject ]]
function MenuObject:GetChildren() end
--[[Открывает это меню ]]
---@param Position UDim2 Позиция в которой открыть это меню
---@return UDim2 Position Позиция в которой открыть это меню
function MenuObject:Open(Position) end
--[[Создаёт MenuText; С `.Parent` в этом меню ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
function MenuObject:CreateMenuText(Name,Title) end
--[[Ищет первого ребёнка по имени ]]
---@param Name string Имя ребёнка
---@return string Name Имя ребёнка
function MenuObject:FindFirstChild(Name) end
--[[Создаёт MenuButton; С `.Parent` в этом меню ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
function MenuObject:CreateMenuButton(Name,Title) end
---@type RBXScriptSignal
--[[Запускается когда меню было отменено, тоесть последний клик был не по меню, из-за чего меню закрылось ]]
    MenuCancelled_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function MenuCancelled_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function MenuCancelled_RBXScriptSignal:Once(callback:()->()) end
    
    function MenuCancelled_RBXScriptSignal:Wait() end
MenuObject['MenuCancelled']=MenuCancelled_RBXScriptSignal
---@type TSignal
--[[Запускается когда убран ребёнок ]]
    ChildRemoved_TSignal = {}
    ---@param callback fun(child:MenuItem)
    ---@return RBXScriptConnection
    function ChildRemoved_TSignal:Connect(callback:(child:MenuItem)->()) end
    ---@param callback fun(child:MenuItem)
    ---@return RBXScriptConnection
    function ChildRemoved_TSignal:Once(callback:(child:MenuItem)->()) end
    ---@return MenuItem child
    function ChildRemoved_TSignal:Wait() end
MenuObject['ChildRemoved']=ChildRemoved_TSignal
---@type TSignal
--[[Запускается когда добавлен новый ребёнок ]]
    ChildAdded_TSignal = {}
    ---@param callback fun(child:MenuItem)
    ---@return RBXScriptConnection
    function ChildAdded_TSignal:Connect(callback:(child:MenuItem)->()) end
    ---@param callback fun(child:MenuItem)
    ---@return RBXScriptConnection
    function ChildAdded_TSignal:Once(callback:(child:MenuItem)->()) end
    ---@return MenuItem child
    function ChildAdded_TSignal:Wait() end
MenuObject['ChildAdded']=ChildAdded_TSignal
---@type RBXScriptSignal
--[[Запускается когда позиции обьектов в меню обновились ]]
    MenuRefreshed_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function MenuRefreshed_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function MenuRefreshed_RBXScriptSignal:Once(callback:()->()) end
    
    function MenuRefreshed_RBXScriptSignal:Wait() end
MenuObject['MenuRefreshed']=MenuRefreshed_RBXScriptSignal
---@type Bind
--[[Бинд для открытии(:Open(Position: UDim2)) ]]
    OpenBind_Bind = {}
    ---@param callback fun(Position: UDim2)
    ---*return ()*
    function OpenBind_Bind:Bind(callback:(Position: UDim2)->()) end
    ---@param Position UDim2
    function OpenBind_Bind:Run(Position: UDim2) end

    OpenBind_Bind_OnRun = {}
    ---@param callback fun(Position: UDim2)
    ---@return RBXScriptConnection
    function OpenBind_Bind_OnRun:Connect(callback:(Position: UDim2)->()) end
    ---@param callback fun(Position: UDim2)
    ---@return RBXScriptConnection
    function OpenBind_Bind_OnRun:Once(callback:(Position: UDim2)->()) end
    ---@return UDim2 Position
    function OpenBind_Bind_OnRun:Wait() end
    OpenBind_Bind.OnRun = OpenBind_Bind_OnRun
    MenuObject['OpenBind']= OpenBind_Bind

---@class MenuText : TClass : MenuItem
--[[Основной TextLabel этого меню обьекта ]]
--*[ReadOnly]*
---@field TextLabel TextLabel
--[[Обьект соддержащий текст(здесь - TextLabel). Тоже самое что и `.TextLabel`, но для совместимости ]]
--*[ReadOnly]*
---@field TextObject TextLabel
--[[Текст в меню ]]
MenuText={}

---@class MenuTogle : TClass : MenuItem : MenuButton
--[[Значение ]]
---@field Value boolean
--[[Кнопка-переключатель в меню ]]
MenuToggle={}

---@class PackageData : TClass
--[[Сырые данные пакета, если это не TPacket то будут '' ]]
--*[ReadOnly]*
---@field RawData string
--[[Это TPacket? ]]
--*[ReadOnly]*
---@field IsPackage string
--[[Сырой код пакета ]]
--*[ReadOnly]*
---@field Code string
--[[Данные пакета ]]
PackageData={}
--[[Возвращает данные пакета ]]
function PackageData:GetData() end

---@class Preset : TClass
--[[Имя пресета, по умолчанию 'Default' ]]
---@field PresetName string
--[[Стандартный пресет, нету отдельных функций в его сохранение. ]]
---@field Default table
--[[Пример класса ]]
Preset={}
--[[Загружает пресет ]]
---@param Preset table Таблица с значениями(значение может быть массивом с [type,...]-альтернатива для сохранения типов из рб), если есть запускает :Load()
---@return table Preset Таблица с значениями(значение может быть массивом с [type,...]-альтернатива для сохранения типов из рб), если есть запускает :Load()
function Preset:Load(Preset) end
--[[Обновляет пресет ]]
---@param Preset table Таблица с значениями(значение может быть массивом с [type,...]-альтернатива для сохранения типов из рб), если есть запускает :Load()?
---@return table Preset Таблица с значениями(значение может быть массивом с [type,...]-альтернатива для сохранения типов из рб), если есть запускает :Load()
function Preset:Refresh(Preset) end
--[[Получает все значения в пресете ]]
---@param dontUseRBXValues boolean Если true, то возвращает таблицу с данными (если тип из роблокса то станет массивом [type,...])
---@return boolean dontUseRBXValues Если true, то возвращает таблицу с данными (если тип из роблокса то станет массивом [type,...])
function Preset:GetPreset(dontUseRBXValues) end
---@type RBXScriptSignal
--[[Запускается при Preset:Refresh() или Preset:Load() ]]
    OnRefresh_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRefresh_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRefresh_RBXScriptSignal:Once(callback:()->()) end
    
    function OnRefresh_RBXScriptSignal:Wait() end
Preset['OnRefresh']=OnRefresh_RBXScriptSignal

---@class Prompt : TClass : ConfigObject : TWindow
--[[Тип промта, устанавливается значение из PromptType при запуске TClasses:CreatePrompt(...). Или назначеное по стандарту в других методах ]]
--*[ReadOnly]*
---@field Type string
--[[Ожидает ли :Run() результата? ]]
---@field Running boolean
--[[Класс Prompt. Часть других промтов. .CanHide обычно false, а также устанавливает DisplayOrder на 2 ]]
Prompt={}
--[[Эмулирует ввод данных от пользователя, если параметров нет - отмена. ]]
function Prompt:EmulateInput() end
--[[Запускает Prompt, спрашивая что либо у пользователя. Выходных данных может и не быть, если запрос отменён. Отменяет предыдущий запрос, если он всё ещё действует ]]
function Prompt:Run() end
---@type TSignal
--[[Запускается после запуска :Run(...) с переданными параметрами. ]]
    OnRunned_TSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRunned_TSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRunned_TSignal:Once(callback:()->()) end
    
    function OnRunned_TSignal:Wait() end
Prompt['OnRunned']=OnRunned_TSignal
---@type TSignal
--[[Запускается если произошёл Input или был запущен :EmulateInput(...). С любыми параметрами, которых может не быть при отмене ]]
    OnInput_TSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnInput_TSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnInput_TSignal:Once(callback:()->()) end
    
    function OnInput_TSignal:Wait() end
Prompt['OnInput']=OnInput_TSignal
---@type TSignal
--[[Запускается после Input сигнала, когда :Run(...) был запущен. И передаёт те же параметры как при запуске :Run(...). ]]
    RunStopped_TSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function RunStopped_TSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function RunStopped_TSignal:Once(callback:()->()) end
    
    function RunStopped_TSignal:Wait() end
Prompt['RunStopped']=RunStopped_TSignal

---@class Prompts : TClass
--[[Класс для создания Prompt. Находится в TimGui.Prompts ]]
Prompts={}
--[[Создаёт промпт-подтверждение ]]
---@param Name string Название промпта
---@param Title string | table<string,string> | TTranslator Заголовок?
---@param Description string | table<string,string> | TTranslator Описания промпта?
---@param disableDefaultConfigSettingsRefresh boolean Выключены ли стандартное обновление сохранений при смене настроек конфига?
---@return string Name Название промпта
---@return string | table<string,string> | TTranslator Title Заголовок
---@return string | table<string,string> | TTranslator Description Описания промпта
---@return boolean disableDefaultConfigSettingsRefresh Выключены ли стандартное обновление сохранений при смене настроек конфига
function Prompts:CreateConfirmationPrompt(Name,Title,Description,disableDefaultConfigSettingsRefresh) end
--[[Создаёт текстовый промпт ]]
---@param Name string Название промпта
---@param Title string | table<string,string> | TTranslator Заголовок?
---@param Description string | table<string,string> | TTranslator Описания промпта?
---@param disableDefaultConfigSettingsRefresh boolean Выключены ли стандартное обновление сохранений при смене настроек конфига?
---@return string Name Название промпта
---@return string | table<string,string> | TTranslator Title Заголовок
---@return string | table<string,string> | TTranslator Description Описания промпта
---@return boolean disableDefaultConfigSettingsRefresh Выключены ли стандартное обновление сохранений при смене настроек конфига
function Prompts:CreateTextPrompt(Name,Title,Description,disableDefaultConfigSettingsRefresh) end
--[[Создаёт промпт для выбора кнопки на клавиатуре ]]
---@param Name string Название промпта
---@param Title string | table<string,string> | TTranslator Заголовок?
---@param Description string | table<string,string> | TTranslator Описания промпта?
---@param disableDefaultConfigSettingsRefresh boolean Выключены ли стандартное обновление сохранений при смене настроек конфига?
---@return string Name Название промпта
---@return string | table<string,string> | TTranslator Title Заголовок
---@return string | table<string,string> | TTranslator Description Описания промпта
---@return boolean disableDefaultConfigSettingsRefresh Выключены ли стандартное обновление сохранений при смене настроек конфига
function Prompts:CreateKeyPrompt(Name,Title,Description,disableDefaultConfigSettingsRefresh) end

---@class Save : TClass
--[[Имя сохранения ]]
--*[ReadOnly]*
---@field Name string
--[[Сохранение, можно записать в конфиг или глобально ]]
Save={}
--[[Записывает данные на конфигурацию ]]
---@param key string Ключ(название) сохранения
---@param value any Значение, string | number | table | boolean типы поддерживаются
---@return string key Ключ(название) сохранения
---@return any value Значение, string | number | table | boolean типы поддерживаются
function Save:SetToConfig(key,value) end
--[[Записывает данные на глобальное сохранение ]]
---@param key string Ключ(название) сохранения
---@param value any Значение, string | number | table | boolean типы поддерживаются
---@return string key Ключ(название) сохранения
---@return any value Значение, string | number | table | boolean типы поддерживаются
function Save:SetToSave(key,value) end
--[[Читает данные с конфигурации ]]
---@param key string Ключ(название) сохранения
---@return string key Ключ(название) сохранения
function Save:GetFromConfig(key) end
--[[Читает данные с глобального сохранения ]]
---@param key string Ключ(название) сохранения
---@return string key Ключ(название) сохранения
function Save:GetFromSave(key) end

---@class Saves : TClass
--[[Локальная директория в которой находятся файлы TGui, используемые для сохранений ]]
--*[ReadOnly]*
---@field BaseDir any
--[[Поддерживаются ли сохранения? ]]
--*[ReadOnly]*
---@field IsSupported boolean
--[[Класс для сохранения значений для перезахода ]]
Saves={}
--[[Возвращает сохранение по названию ]]
---@param SaveName string Название сохранения
---@return string SaveName Название сохранения
function Saves:GetSave(SaveName) end

---@class SpecialColors : TClass : Preset : Colors
--[[Класс для цветов, использующий пресеты. ]]
SpecialColors={}
--[[Получает цвет, если нету здесь то глобальный ]]
---@param colorName string Имя цвета
---@return string colorName Имя цвета
function SpecialColors:GetColor(colorName) end
--[[Возвращает RBXScriptSignal, который запускается при смене цвета ]]
---@param colorName string Имя цвета
---@return string colorName Имя цвета
function SpecialColors:GetColorChangedSignal(colorName) end

---@class TButton : TClass : ConfigObject : TGuiObject : ButtonObject : GuiKeybindingObject
--[[Равен `Button`. Нужен для определения типа обьекта ]]
--*[ReadOnly]*
---@field Type string
--[[Просто кнопка на TGuiObject. P.S: Используй TButton.Activated ]]
TButton={}

---@class TClass
--[[Пример класса ]]
TClass={}
--[[Устанавливает свойство только для чтения ]]
---@param propertyName string Имя свойства
---@return string propertyName Имя свойства
function TClass:SetReadOnly(propertyName) end
--[[Сравнивает имя класса с 1 параметром ]]
---@param className string Имя класса для сравнения
---@return string className Имя класса для сравнения
function TClass:IsA(className) end
--[[Сравнивает имя класса с 1 параметром ]]
function TClass:GetClassNames() end
--[[Возвращает наличия свойства только для чтения ]]
---@param propertyName string Имя свойства
---@return string propertyName Имя свойства
function TClass:GetReadOnly(propertyName) end
--[[Получить эвент, который запускается при изменении значения ]]
---@param propertyName string Имя свойства
---@return string propertyName Имя свойства
function TClass:GetPropertyChangedEvent(propertyName) end
--[[Добавляет имя класса ]]
---@param className string Имя класса
---@return string className Имя класса
function TClass:AddClassName(className) end
---@type RBXScriptSignal
--[[Запускается если значение было изменено ]]
    OnPropertyChanged_RBXScriptSignal = {}
    ---@param callback fun(PropertyName:string)
    ---@return RBXScriptConnection
    function OnPropertyChanged_RBXScriptSignal:Connect(callback:(PropertyName:string)->()) end
    ---@param callback fun(PropertyName:string)
    ---@return RBXScriptConnection
    function OnPropertyChanged_RBXScriptSignal:Once(callback:(PropertyName:string)->()) end
    ---@return string PropertyName
    function OnPropertyChanged_RBXScriptSignal:Wait() end
TClass['OnPropertyChanged']=OnPropertyChanged_RBXScriptSignal

---@class TClasses : TClass
--[[Класс TClasses, предназначен для создания своих классов ]]
TClasses={}
--[[Создаёт Preset класс, помогает кастомизировать всё что угодно ]]
---@param clearAllOnLoad boolean Заменять ли все значения при :Load()??
---@param rawData table Сырая таблица, которая станет основой?
---@return boolean clearAllOnLoad Заменять ли все значения при :Load()?
---@return table rawData Сырая таблица, которая станет основой
function TClasses:CreatePreset(clearAllOnLoad,rawData) end
--[[ ]]
---@param object any Обьект для сравнения
---@param className string Имя класса для сравнения
---@return any object Обьект для сравнения
---@return string className Имя класса для сравнения
function TClasses:IsA(object,className) end
--[[Создаёт MenuToggle ]]
---@param Name string Название
---@param Title string | table<string,string> | TTranslator Заголовок?
---@return string Name Название
---@return string | table<string,string> | TTranslator Title Заголовок
function TClasses:CreateMenuToggle(Name,Title) end
--[[Создаёт пустое окно ]]
---@param Name string Название окна
---@param Title string | table<string,string> | TTranslator Заголовок окна?
---@param disableDefaultConfigSettingsRefresh boolean Выключены ли стандартное обновление сохранений при смене настроек конфига?
---@return string Name Название окна
---@return string | table<string,string> | TTranslator Title Заголовок окна
---@return boolean disableDefaultConfigSettingsRefresh Выключены ли стандартное обновление сохранений при смене настроек конфига
function TClasses:CreateWindow(Name,Title,disableDefaultConfigSettingsRefresh) end
--[[Создаёт пустое меню ]]
function TClasses:CreateMenu() end
--[[Создаёт MenuItem ]]
---@param Name string Название
---@param Title string | table<string,string> | TTranslator Заголовок?
---@param disableTextColorChanged boolean Включено ли изменение цвета текста?
---@return string Name Название
---@return string | table<string,string> | TTranslator Title Заголовок
---@return boolean disableTextColorChanged Включено ли изменение цвета текста
function TClasses:CreateMenuItem(Name,Title,disableTextColorChanged) end
--[[Создаёт пустой TClass ]]
---@param rawData table Сырая таблица, которая станет основой для TClass'а?
---@param metatable table Мета-таблица, ставится поверх стандартной у TClass'ов?
---@param writeSameModeExclude boolean | table Таблица с исключениями для записывания только одинаковых типов, или если true полностью отключает функцию?
---@return table rawData Сырая таблица, которая станет основой для TClass'а
---@return table metatable Мета-таблица, ставится поверх стандартной у TClass'ов
---@return boolean | table writeSameModeExclude Таблица с исключениями для записывания только одинаковых типов, или если true полностью отключает функцию
function TClasses:CreateTClass(rawData,metatable,writeSameModeExclude) end
--[[Создаёт MenuText ]]
---@param Name string Название
---@param Title string | table<string,string> | TTranslator Заголовок?
---@return string Name Название
---@return string | table<string,string> | TTranslator Title Заголовок
function TClasses:CreateMenuText(Name,Title) end
--[[Кастомный Event по типу Bindable Event, чтобы передавать таблицы без ошибок(если ты не сталкиваешься с тупыми ошибками, как при table.clone, то используй встроенный BindableEvent) ]]
function TClasses:CreateTEvent() end
--[[Создаёт Bind класс, помогает заменять функции для кастомизации через дополнения ]]
---@param rawData table Сырая таблица?
---@return table rawData Сырая таблица
function TClasses:CreateBind(rawData) end
--[[Создаёт класс для специальных цветов ]]
function TClasses:CreateSpecialColors() end
--[[Создаёт пустой prompt ]]
---@param PromptType string Тип промта
---@param Name string Название промпта
---@param Title string | table<string,string> | TTranslator Заголовок?
---@param Description string | table<string,string> | TTranslator Описания промпта?
---@param disableDefaultConfigSettingsRefresh boolean Выключены ли стандартное обновление сохранений при смене настроек конфига?
---@return string PromptType Тип промта
---@return string Name Название промпта
---@return string | table<string,string> | TTranslator Title Заголовок
---@return string | table<string,string> | TTranslator Description Описания промпта
---@return boolean disableDefaultConfigSettingsRefresh Выключены ли стандартное обновление сохранений при смене настроек конфига
function TClasses:CreatePrompt(PromptType,Name,Title,Description,disableDefaultConfigSettingsRefresh) end
--[[Создаёт TTranslator класс, помогает переводить всё что угодно на язык пользователя ]]
---@param englishData any Английский вариант(по умолчанию)
---@param rawData table Сырая таблица?
---@return any englishData Английский вариант(по умолчанию)
---@return table rawData Сырая таблица
function TClasses:CreateTranslator(englishData,rawData) end
--[[Создаёт MenuButton ]]
---@param Name string Название
---@param Title string | table<string,string> | TTranslator Заголовок?
---@return string Name Название
---@return string | table<string,string> | TTranslator Title Заголовок
function TClasses:CreateMenuButton(Name,Title) end

---@class TEvent
--[[Массив, с последними args *Новая версия .Args* ]]
---@field args table
--[[BindableEvent с помощью которого работают ожидания :Fire() ]]
---@field BEvent BindableEvent
--[[Таблица с массивами, с последними args {[number]={...}}. Исчезают через 1 секунду после запуска ]]
---@field Args table
--[[Кастомный Event по типу Bindable Event, чтобы передавать timgui типы без ошибок(если ты не сталкиваешься с тупыми ошибками, как при table.clone, то используй встроенный BindableEvent) ]]
TEvent={}
--[[Запускается с любыми параметрами, которые передаются в .Event ]]
function TEvent:Fire() end
---@type TSignal
--[[Основной сигнал этого TEvent, запускаемый через :Fire(...), с параметрами ... взятыми из :Fire ]]
    Event_TSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Event_TSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Event_TSignal:Once(callback:()->()) end
    
    function Event_TSignal:Wait() end
TEvent['Event']=Event_TSignal

---@class TextObject : TClass : TGuiObject
--[[TextLabel ]]
--*[ReadOnly]*
---@field TextLabel TextLabel
--[[Класс использющийся для создание TGuiObjects с TextLabel(не меняет цвета) ]]
TextObject={}

---@class TextPrompt : TClass : ConfigObject : TWindow : Prompt
--[[То что находится в TextBox(если изменить изменится и там) ]]
---@field Value string
--[[Текст для кнопки отмены ]]
--*[ReadOnly]*
---@field CancelText TTranslator
--[[Кнопка подтверждения(берёт текст из `.ConfirmText`) ]]
--*[ReadOnly]*
---@field ConfirmButton TextButton
--[[Основной TextBox ]]
--*[ReadOnly]*
---@field TextBox TextBox
--[[TextLabel описания ]]
--*[ReadOnly]*
---@field DescriptionLabel TextLabel
--[[Текст для кнопки подтверждения ]]
--*[ReadOnly]*
---@field ConfirmText TTranslator
--[[Размер текста описания ]]
---@field DescriptionTextSize number
--[[Frame в котором находятся кнопки 'Подтвердить' и 'Отменить' ]]
--*[ReadOnly]*
---@field Buttons Frame
--[[Кнопка отмены(берёт текст из `.CancelText`) ]]
--*[ReadOnly]*
---@field CancelButton TextButton
--[[Может ли пользователь отменить? ]]
---@field CancelEnabled boolean
--[[Класс TextPrompt, чтобы спрашивать текст у пользователя. ]]
TextPrompt={}
---@type RBXScriptSignal
--[[Запускается когда обновился размер(описания и тд) и позиции ]]
    OnSizeRefreshed_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnSizeRefreshed_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnSizeRefreshed_RBXScriptSignal:Once(callback:()->()) end
    
    function OnSizeRefreshed_RBXScriptSignal:Wait() end
TextPrompt['OnSizeRefreshed']=OnSizeRefreshed_RBXScriptSignal
---@type Bind
--[[Специальный Bind для установки размера описанию. Работает как в Binder.TextPromptDescriptionSizeBind ]]
    SpecialDescriptionSizeBind_Bind = {}
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function SpecialDescriptionSizeBind_Bind:Bind(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@param TextPrompt TextPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function SpecialDescriptionSizeBind_Bind:Run(TextPrompt: TextPrompt,startYPos: UDim) end

    SpecialDescriptionSizeBind_Bind_OnRun = {}
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function SpecialDescriptionSizeBind_Bind_OnRun:Connect(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function SpecialDescriptionSizeBind_Bind_OnRun:Once(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@return TextPrompt TextPrompt
---@return UDim startYPos
    function SpecialDescriptionSizeBind_Bind_OnRun:Wait() end
    SpecialDescriptionSizeBind_Bind.OnRun = SpecialDescriptionSizeBind_Bind_OnRun
    TextPrompt['SpecialDescriptionSizeBind']= SpecialDescriptionSizeBind_Bind

---@class TGroup : TClass : GUIArchitecture : ConfigObject : TGuiObject : ButtonObject
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
--[[Создаёт кнопку-последовательность, благодаря которой можно создать последовательность действий с `.Parent` в этой группе ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param callback fun(self: TSequence) Функция, для установки на смену значения?
---@param Objects table<string,string> | table<string,table<string,string>> Таблица с обьектами, где ключ - имя кнопки, а значение - либо таблица переводов, либо заголовок?
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
---@return fun(self: TSequence) callback Функция, для установки на смену значения
---@return table<string,string> | table<string,table<string,string>> Objects Таблица с обьектами, где ключ - имя кнопки, а значение - либо таблица переводов, либо заголовок
function TGroup:CreateSequence(Name,Title,callback,Objects) end
--[[Создаёт переключатель(тумблер) с `.Parent` в этой группе ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param callback fun(self: TToggle) Функция, для установки на клик, запускается с этим же переключателем?
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
---@return fun(self: TToggle) callback Функция, для установки на клик, запускается с этим же переключателем
function TGroup:CreateToggle(Name,Title,callback) end
--[[Создаёт кнопку с `.Parent` в этой группе ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param callback fun(self: TButton) Функция, для установки на клик, запускается с этой же кнопкой?
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
---@return fun(self: TButton) callback Функция, для установки на клик, запускается с этой же кнопкой
function TGroup:CreateButton(Name,Title,callback) end
--[[Создаёт поле для ввода данных(TextBox), данные могут быть не только текстовыми с `.Parent` в этой группе ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@param callback fun(self: TTextBox) Функция, для установки на смену значения, запускается с этим же TTextBox?
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
---@return fun(self: TTextBox) callback Функция, для установки на смену значения, запускается с этим же TTextBox
function TGroup:CreateTextbox(Name,Title,callback) end
--[[Создаёт просто текст с `.Parent` в этой группе ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return string Name Имя обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
function TGroup:CreateText(Name,Title) end
---@type RBXScriptSignal
--[[При закрытии группы ]]
    OnClose_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClose_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClose_RBXScriptSignal:Once(callback:()->()) end
    
    function OnClose_RBXScriptSignal:Wait() end
TGroup['OnClose']=OnClose_RBXScriptSignal
---@type RBXScriptSignal
--[[При открытии группы ]]
    OnOpen_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpen_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpen_RBXScriptSignal:Once(callback:()->()) end
    
    function OnOpen_RBXScriptSignal:Wait() end
TGroup['OnOpen']=OnOpen_RBXScriptSignal
---@type Bind
--[[Бинд для кастомного отступа не глобальных групп. ]]
    GroupIndentBind_Bind = {}
    ---@param callback fun(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)
    ---*return ()*
    function GroupIndentBind_Bind:Bind(callback:(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)->()) end
    ---@param TGroup TGroup
---@param VisibleIndent Frame
---@param GroupFrame Frame
    function GroupIndentBind_Bind:Run(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame) end

    GroupIndentBind_Bind_OnRun = {}
    ---@param callback fun(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)
    ---@return RBXScriptConnection
    function GroupIndentBind_Bind_OnRun:Connect(callback:(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)->()) end
    ---@param callback fun(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)
    ---@return RBXScriptConnection
    function GroupIndentBind_Bind_OnRun:Once(callback:(TGroup: TGroup,VisibleIndent: Frame,GroupFrame: Frame)->()) end
    ---@return TGroup TGroup
---@return Frame VisibleIndent
---@return Frame GroupFrame
    function GroupIndentBind_Bind_OnRun:Wait() end
    GroupIndentBind_Bind.OnRun = GroupIndentBind_Bind_OnRun
    TGroup['GroupIndentBind']= GroupIndentBind_Bind
---@type Bind
--[[Специальный бинд для анимации стрелочки. Работает как в Binder.GroupOpenArrowBind ]]
    SpecialGroupOpenArrowBind_Bind = {}
    ---@param callback fun(group: TGroup)
    ---*return ()*
    function SpecialGroupOpenArrowBind_Bind:Bind(callback:(group: TGroup)->()) end
    ---@param group TGroup
    function SpecialGroupOpenArrowBind_Bind:Run(group: TGroup) end

    SpecialGroupOpenArrowBind_Bind_OnRun = {}
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function SpecialGroupOpenArrowBind_Bind_OnRun:Connect(callback:(group: TGroup)->()) end
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function SpecialGroupOpenArrowBind_Bind_OnRun:Once(callback:(group: TGroup)->()) end
    ---@return TGroup group
    function SpecialGroupOpenArrowBind_Bind_OnRun:Wait() end
    SpecialGroupOpenArrowBind_Bind.OnRun = SpecialGroupOpenArrowBind_Bind_OnRun
    TGroup['SpecialGroupOpenArrowBind']= SpecialGroupOpenArrowBind_Bind
---@type Bind
--[[Специальный бинд для обновления позиций кнопок в этой группе. Работает как в Binder.GlobalGroupRefreshPosition ]]
    SpecialGlobalGroupRefreshPosition_Bind = {}
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---*return (nextPos: UDim2)*
    function SpecialGlobalGroupRefreshPosition_Bind:Bind(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@param GlobalGroup TGroup
---@param pos UDim2
---@return UDim2 nextPos
    function SpecialGlobalGroupRefreshPosition_Bind:Run(GlobalGroup: TGroup,pos: UDim2) end

    SpecialGlobalGroupRefreshPosition_Bind_OnRun = {}
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---@return RBXScriptConnection
    function SpecialGlobalGroupRefreshPosition_Bind_OnRun:Connect(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---@return RBXScriptConnection
    function SpecialGlobalGroupRefreshPosition_Bind_OnRun:Once(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@return TGroup GlobalGroup
---@return UDim2 pos
    function SpecialGlobalGroupRefreshPosition_Bind_OnRun:Wait() end
    SpecialGlobalGroupRefreshPosition_Bind.OnRun = SpecialGlobalGroupRefreshPosition_Bind_OnRun
    TGroup['SpecialGlobalGroupRefreshPosition']= SpecialGlobalGroupRefreshPosition_Bind
---@type Bind
--[[Специальный бинд для обновления позиций кнопок в группе. Работает как в Binder.GlobalGroupRefreshSize ]]
    SpecialGlobalGroupRefreshSize_Bind = {}
    ---@param callback fun(group: TGroup)
    ---*return ()*
    function SpecialGlobalGroupRefreshSize_Bind:Bind(callback:(group: TGroup)->()) end
    ---@param group TGroup
    function SpecialGlobalGroupRefreshSize_Bind:Run(group: TGroup) end

    SpecialGlobalGroupRefreshSize_Bind_OnRun = {}
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function SpecialGlobalGroupRefreshSize_Bind_OnRun:Connect(callback:(group: TGroup)->()) end
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function SpecialGlobalGroupRefreshSize_Bind_OnRun:Once(callback:(group: TGroup)->()) end
    ---@return TGroup group
    function SpecialGlobalGroupRefreshSize_Bind_OnRun:Wait() end
    SpecialGlobalGroupRefreshSize_Bind.OnRun = SpecialGlobalGroupRefreshSize_Bind_OnRun
    TGroup['SpecialGlobalGroupRefreshSize']= SpecialGlobalGroupRefreshSize_Bind

---@class TGuiLogger
--[[Будет ли выводиться :debug(), по умолчанию false ]]
---@field debugEnabled boolean
--[[Весь лог этого логгера ]]
---@field Log table<number,LogMessage>
--[[Logger класс, для логирования ]]
TGuiLogger={}
--[[Ошибка с этими данными(скрипт не продолжит работу) ]]
---@param placeName string Имя плейса?
---@param data any Данные
---@return string placeName Имя плейса
---@return any data Данные
function TGuiLogger:critical_error(placeName,data) end
--[[Логгирует эти данные ]]
---@param placeName string Имя плейса?
---@param data any Данные
---@return string placeName Имя плейса
---@return any data Данные
function TGuiLogger:info(placeName,data) end
--[[Сравнивает имя класса(TGuiLogger/Logger) с 1 параметром и выдаёт результат ]]
---@param className string Имя класса
---@return string className Имя класса
function TGuiLogger:IsA(className) end
--[[Предупреждение с этими данными ]]
---@param placeName string Имя плейса?
---@param data any Данные
---@return string placeName Имя плейса
---@return any data Данные
function TGuiLogger:warn(placeName,data) end
--[[Ошибка с этими данными(скрипт продолжит работу) ]]
---@param placeName string Имя плейса?
---@param data any Данные
---@return string placeName Имя плейса
---@return any data Данные
function TGuiLogger:error(placeName,data) end
--[[Логгирует эти данные ]]
---@param type string Тип собщения
---@param placeName string Имя плейса?
---@param data any Данные
---@return string type Тип собщения
---@return string placeName Имя плейса
---@return any data Данные
function TGuiLogger:log(type,placeName,data) end
--[[Логгирует эти дебаг данные ]]
---@param placeName string Имя плейса?
---@param data any Данные
---@return string placeName Имя плейса
---@return any data Данные
function TGuiLogger:debug(placeName,data) end

---@class TGuiObject : TClass : ConfigObject
--[[Имя по которому его можно найти ]]
---@field Name string
--[[Если true, то этот обьект видим и с ним можно взаимодейсвовать ]]
---@field Visible boolean
--[[Скругление кнопки ]]
--*[ReadOnly]*
---@field UICorner UICorner
--[[Frame в котором содержимое кнопки ]]
--*[ReadOnly]*
---@field Frame Frame
--[[Можно изменить сразу при создании(после `task.wait`) уже нельзя, по умолчанию ставится также через `task.wait()`, нужно для индефикации этого обьекта после перезахода(например конфигураций) ]]
---@field GlobalName string
--[[Тип обьекта(Здесь `unknown`, изменяется в других классах и становится только для чтения) ]]
---@field Type string
--[[Позиция, становится самой нижней если Parent меняется ]]
---@field Position number
--[[Отступ ]]
---@field Indent UDim2
--[[Название кнопки, которое видит пользователь ]]
--*[ReadOnly]*
---@field Title TTranslator
--[[В какой группе/архитектуре находится, можно менять на nil. При смене появляется в самом низу группы ]]
---@field Parent GUIArchitecture?
--[[Меню этого обьекта ]]
--*[ReadOnly]*
---@field Menu Menu
--[[Специальные цвета для этого обьекта ]]
--*[ReadOnly]*
---@field SpecialColors SpecialColors
--[[Включить ли изменение скругления(при изменении в GuiSize.ButtonCornerRadius). Для специального изменения на этой кнопке ]]
---@field CornerChangingEnabled boolean
--[[Класс обьекта TimGui, например группы/кнопки. Устанавливает ConfigSaveName по GlobalName и ставит только для чтения ]]
TGuiObject={}
--[[Обновляет размер, запуская специальный Bind(SizeBind) ]]
---@param dontRefreshPosition boolean Не запускать ли обновление позиции?
---@return boolean dontRefreshPosition Не запускать ли обновление позиции
function TGuiObject:RefreshSize(dontRefreshPosition) end
--[[Открывает меню этого обьекта ]]
function TGuiObject:OpenMenu() end
--[[Возвращает глобальную группу в которой находится ]]
function TGuiObject:GetGlobalGroup() end
---@type RBXScriptSignal
--[[Удаляет обьект и запускает Destroyed евент ]]
    Destroyed_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destroyed_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destroyed_RBXScriptSignal:Once(callback:()->()) end
    
    function Destroyed_RBXScriptSignal:Wait() end
TGuiObject['Destroyed']=Destroyed_RBXScriptSignal
---@type Bind
--[[Специальный bind, Бинд для установки размера объектам. (работает по принципу из Binder.TObjectSize) ]]
    SpecialSizeBind_Bind = {}
    ---@param callback fun(TGuiObject: TGuiObject)
    ---*return ()*
    function SpecialSizeBind_Bind:Bind(callback:(TGuiObject: TGuiObject)->()) end
    ---@param TGuiObject TGuiObject
    function SpecialSizeBind_Bind:Run(TGuiObject: TGuiObject) end

    SpecialSizeBind_Bind_OnRun = {}
    ---@param callback fun(TGuiObject: TGuiObject)
    ---@return RBXScriptConnection
    function SpecialSizeBind_Bind_OnRun:Connect(callback:(TGuiObject: TGuiObject)->()) end
    ---@param callback fun(TGuiObject: TGuiObject)
    ---@return RBXScriptConnection
    function SpecialSizeBind_Bind_OnRun:Once(callback:(TGuiObject: TGuiObject)->()) end
    ---@return TGuiObject TGuiObject
    function SpecialSizeBind_Bind_OnRun:Wait() end
    SpecialSizeBind_Bind.OnRun = SpecialSizeBind_Bind_OnRun
    TGuiObject['SpecialSizeBind']= SpecialSizeBind_Bind
---@type Bind
--[[Специальный бинд для точной прорисовки видимости кнопки(если группа не открыта, не показывать. свойство Visible считается само), работает как в Binder.VisibleBind ]]
    SpecialVisibleBind_Bind = {}
    ---@param callback fun(Object: TGuiObject)
    ---*return ()*
    function SpecialVisibleBind_Bind:Bind(callback:(Object: TGuiObject)->()) end
    ---@param Object TGuiObject
    function SpecialVisibleBind_Bind:Run(Object: TGuiObject) end

    SpecialVisibleBind_Bind_OnRun = {}
    ---@param callback fun(Object: TGuiObject)
    ---@return RBXScriptConnection
    function SpecialVisibleBind_Bind_OnRun:Connect(callback:(Object: TGuiObject)->()) end
    ---@param callback fun(Object: TGuiObject)
    ---@return RBXScriptConnection
    function SpecialVisibleBind_Bind_OnRun:Once(callback:(Object: TGuiObject)->()) end
    ---@return TGuiObject Object
    function SpecialVisibleBind_Bind_OnRun:Wait() end
    SpecialVisibleBind_Bind.OnRun = SpecialVisibleBind_Bind_OnRun
    TGuiObject['SpecialVisibleBind']= SpecialVisibleBind_Bind
---@type Bind
--[[Специальный бинд для подсчета позиции кнопки, работает как в Binder.ButtonPositionBind ]]
    SpecialButtonPositionBind_Bind = {}
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---*return (nextPos: UDim2)*
    function SpecialButtonPositionBind_Bind:Bind(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@param child TGuiObject
---@param pos UDim2
---@return UDim2 nextPos
    function SpecialButtonPositionBind_Bind:Run(child: TGuiObject,pos: UDim2) end

    SpecialButtonPositionBind_Bind_OnRun = {}
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---@return RBXScriptConnection
    function SpecialButtonPositionBind_Bind_OnRun:Connect(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---@return RBXScriptConnection
    function SpecialButtonPositionBind_Bind_OnRun:Once(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@return TGuiObject child
---@return UDim2 pos
    function SpecialButtonPositionBind_Bind_OnRun:Wait() end
    SpecialButtonPositionBind_Bind.OnRun = SpecialButtonPositionBind_Bind_OnRun
    TGuiObject['SpecialButtonPositionBind']= SpecialButtonPositionBind_Bind
---@type Bind
--[[Бинд для замены :OpenMenu() ]]
    OpenMenuBind_Bind = {}
    ---@param callback fun()
    ---*return ()*
    function OpenMenuBind_Bind:Bind(callback:()->()) end
    
    function OpenMenuBind_Bind:Run() end

    OpenMenuBind_Bind_OnRun = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OpenMenuBind_Bind_OnRun:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OpenMenuBind_Bind_OnRun:Once(callback:()->()) end
    
    function OpenMenuBind_Bind_OnRun:Wait() end
    OpenMenuBind_Bind.OnRun = OpenMenuBind_Bind_OnRun
    TGuiObject['OpenMenuBind']= OpenMenuBind_Bind

---@class TimGui
--[[Данные при старте TimGui, передаются в _G.Setup, подробнее в TimGuiSetupObject ]]
--*[ReadOnly]*
---@field SetupData table
--[[Класс для смены размеров Gui ]]
--*[ReadOnly]*
---@field GuiSize GuiSize
--[[ScreenGui в котором находятся меню(должно быть поверх основного ScreenGui) ]]
--*[ReadOnly]*
---@field MenuScreenGui ScreenGui
--[[Создания prompt окна(для того чтобы, что нибудь спросить у пользователя) ]]
--*[ReadOnly]*
---@field Prompts Prompts
--[[Класс для созадния Привязок к кнопкам, тоесть Key binds ]]
--*[ReadOnly]*
---@field KeyBinding KeyBinding
--[[Класс для получения информации о конфигурациях(но не для изменения, если нужно изменить см. ControlCfg) ]]
--*[ReadOnly]*
---@field Configs Configs
--[[Класс для замены стандартных функций (БОЛЬШЕ КАСТОМИЗАЦИИ) ]]
--*[ReadOnly]*
---@field Binder Binder
--[[Глобально открытая группа(типо та которая в группах слево) ]]
--*[ReadOnly]*
---@field GlobalOpenedGroup TGroup
--[[httpGet_BaseDir локальная или нет? ]]
--*[ReadOnly]*
---@field httpGet_BaseDirIsLocal boolean
--[[Текущая версия ядра TGui. Например 1 ]]
--*[ReadOnly]*
---@field CoreBuildCount number
--[[Класс для созданий обьектов интерфейса ]]
--*[ReadOnly]*
---@field GuiInstances GuiInstances
--[[Главный интерфейс TimGui ]]
--*[ReadOnly]*
---@field ScreenGui ScreenGui
--[[Класс для смены ресурсов ]]
--*[ReadOnly]*
---@field Assets Assets
--[[Класс для кастомизации цветов ]]
--*[ReadOnly]*
---@field Colors Colors
--[[Класс для изменения кнопки открытия в статус, например загрузка или ошибка(Блокирует открытие) ]]
--*[ReadOnly]*
---@field State GuiState
--[[Сохранения, проверка доступности сохранений ]]
--*[ReadOnly]*
---@field Saves Saves
--[[Класс для создания кнопок/групп в основном gui ]]
--*[ReadOnly]*
---@field GuiObjects GuiObjects
--[[Класс для настройки анимаций интерфейса ]]
--*[ReadOnly]*
---@field GuiAnimations GuiAnimations
--[[Массив с языковыми предпочтениями, например: ["ru","uk","en",...] ]]
---@field LanguagesPreference table<number,string>
--[[Был ли :Exit() запущен, тоесть закрыт ли TimGui ]]
--*[ReadOnly]*
---@field Closed boolean
--[[Директория в которой находятся файлы TGui(Ссылка или локально, можно определить через .httpGet_BaseDirIsLocal) ]]
--*[ReadOnly]*
---@field httpGet_BaseDir string
--[[Класс для кастомизации заголовка ]]
--*[ReadOnly]*
---@field Header Header
--[[Класс для создания логгеров и чтения логов ]]
--*[ReadOnly]*
---@field Loggers Loggers
--[[Текущая версия ядра TGui в формате строки. Например 3.0.0 ]]
--*[ReadOnly]*
---@field CoreVersion string
--[[Текущая версия TGui в формате строки. Например 1.0.0 ]]
--*[ReadOnly]*
---@field Version string
--[[Открыто ли gui? Если false, то свёрнуто ]]
---@field Opened boolean
--[[Группы, в которые можно ложить кнопки ]]
--*[ReadOnly]*
---@field Groups GUIArchitecture
--[[Текущая версия TGui. Например 1 ]]
--*[ReadOnly]*
---@field BuildCount number
--[[Главный обьект ВСЕЙ системы TGui. Можно получить с помощью _G.TimGui ]]
TimGui={}
--[[Получает данные из инета. Если начинается на './', то получает из директории скрипта ]]
---@param URL string Ссылка для получение.?
---@return string URL Ссылка для получение.
function TimGui:HttpGet(URL) end
--[[Закрывает TimGui(выходит), и запускает .OnExit event ]]
function TimGui:Exit() end
--[[Сравнивает имя класса с 1 параметром ]]
---@param className string Имя класса для сравнения
---@return string className Имя класса для сравнения
function TimGui:IsA(className) end
--[[Изменяет языковые предпочтения ]]
---@param langCodes table<number,string> Массив с языковыми предпочтениями, например: ["ru","uk","en",...]
---@return table<number,string> langCodes Массив с языковыми предпочтениями, например: ["ru","uk","en",...]
function TimGui:SetLanguagePreferences(langCodes) end
--[[Создаёт TScript или получает уже созданный с этим именем (если можно) ]]
---@param scriptName string Имя скрипта, должно быть уникальным, иначе выдаст ошибку(если нет доступа)
---@param allowToLoadTwice boolean Если `true`, то позволяет загрузить скрипт повторно?
---@return string scriptName Имя скрипта, должно быть уникальным, иначе выдаст ошибку(если нет доступа)
---@return boolean allowToLoadTwice Если `true`, то позволяет загрузить скрипт повторно
function TimGui:GetTScript(scriptName,allowToLoadTwice) end
--[[Возвращает позицию TimGui, для выбранного состояния ]]
---@param Opened boolean Нужное состояние(открыто ли). Если nil, то получает для текущего состояния?
---@return boolean Opened Нужное состояние(открыто ли). Если nil, то получает для текущего состояния
function TimGui:GetFrameGuiPosition(Opened) end
---@type RBXScriptSignal
--[[Запускается если TimGui:Exit() запущен, чтобы закрыть GUI ]]
    OnExit_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnExit_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnExit_RBXScriptSignal:Once(callback:()->()) end
    
    function OnExit_RBXScriptSignal:Wait() end
TimGui['OnExit']=OnExit_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается когда глобально открытая группа изменилась ]]
    GlobalOpenedGroupChanged_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function GlobalOpenedGroupChanged_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function GlobalOpenedGroupChanged_RBXScriptSignal:Once(callback:()->()) end
    
    function GlobalOpenedGroupChanged_RBXScriptSignal:Wait() end
TimGui['GlobalOpenedGroupChanged']=GlobalOpenedGroupChanged_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается если TimGui.Opened изменился ]]
    OnOpened_RBXScriptSignal = {}
    ---@param callback fun(isOpened:boolean)
    ---@return RBXScriptConnection
    function OnOpened_RBXScriptSignal:Connect(callback:(isOpened:boolean)->()) end
    ---@param callback fun(isOpened:boolean)
    ---@return RBXScriptConnection
    function OnOpened_RBXScriptSignal:Once(callback:(isOpened:boolean)->()) end
    ---@return boolean isOpened
    function OnOpened_RBXScriptSignal:Wait() end
TimGui['OnOpened']=OnOpened_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается если языковые предпочтения изменились ]]
    LanguageChanged_RBXScriptSignal = {}
    ---@param callback fun(langCodes:table)
    ---@return RBXScriptConnection
    function LanguageChanged_RBXScriptSignal:Connect(callback:(langCodes:table)->()) end
    ---@param callback fun(langCodes:table)
    ---@return RBXScriptConnection
    function LanguageChanged_RBXScriptSignal:Once(callback:(langCodes:table)->()) end
    ---@return table<number,string> langCodes
    function LanguageChanged_RBXScriptSignal:Wait() end
TimGui['LanguageChanged']=LanguageChanged_RBXScriptSignal

---@class TKey : TClass
--[[Эта кнопка клавиатуры? ]]
--*[ReadOnly]*
---@field IsKeyboardKey boolean
--[[Словарь с зажатыми кнопками, типо {LeftCTRL=true,LeftShift=false} ]]
---@field Holding table
--[[KeyCode этой кнопки клавиатуры ]]
---@field KeyCode Enum.KeyCode
--[[Цифра кнопки на мыши(если это не кнопка мыши = 0), работает как в роблоксе 1-Левая,2-Правая,3-Колёсико ]]
---@field MouseKey number
--[[Эта кнопка мыши? ]]
--*[ReadOnly]*
---@field IsMouseKey boolean
--[[Полное имя кнопки, типо: LeftCTRL + T ]]
---@field Name string
--[[Пустой ли TKey(тоесть, пользователь не может повторить этот TKey?) ]]
--*[ReadOnly]*
---@field IsEmpty boolean
--[[Имя кнопки например A/1/KEnter/K1(K1 - Keypad One)/LeftMB(LeftMB-Left Mouse Button) ]]
---@field KeyName string
--[[Класс - кнопка, нужен для получения нажатой кнопки ]]
TKey={}

---@class TScript : TClass
--[[Имя скрипта ]]
--*[ReadOnly]*
---@field Name string
--[[Logger этого скрипта ]]
--*[ReadOnly]*
---@field Logger TGuiLogger
--[[Скрипт, предназначенный для обработки данных только этого скрипта. Можно получить через TimGui:GetTScript(scriptName) ]]
TScript={}
--[[Записывает данные на конфигурацию скрипта ]]
---@param key string Ключ(название) сохранения
---@param value any Значение, string | number | table | boolean типы поддерживаются
---@return string key Ключ(название) сохранения
---@return any value Значение, string | number | table | boolean типы поддерживаются
function TScript:SetToConfig(key,value) end
--[[Записывает данные на глобальное сохранение скрипта ]]
---@param key string Ключ(название) сохранения
---@param value any Значение, string | number | table | boolean типы поддерживаются
---@return string key Ключ(название) сохранения
---@return any value Значение, string | number | table | boolean типы поддерживаются
function TScript:SetToSave(key,value) end
--[[Читает данные с конфигурации скрипта ]]
---@param key string Ключ(название) сохранения
---@return string key Ключ(название) сохранения
function TScript:GetFromConfig(key) end
--[[Читает данные с глобального сохранения скрипта ]]
---@param key string Ключ(название) сохранения
---@return string key Ключ(название) сохранения
function TScript:GetFromSave(key) end

---@class TSequence : TClass : ConfigObject : TGuiObject : ButtonObject
--[[Открыт ли? ]]
---@field Opened boolean
--[[Размер ]]
--*[ReadOnly]*
---@field Size UDim2
--[[Стрелочка статуса открытия ]]
--*[ReadOnly]*
---@field OpenLabel ImageLabel
--[[Frame со всеми обьектами ]]
--*[ReadOnly]*
---@field SequenceFrame Frame
--[[Равен `Sequence`. Нужен для определения типа обьекта ]]
--*[ReadOnly]*
---@field Type string
--[[Кнопка-последовательность для установки порядка исполнения(например, порядок языков) ]]
TSequence={}
--[[Изменяет позицию для обьекта в TSequence ]]
---@param ObjectName string Имя порядкого обьекта
---@param NewPosition number Новая позиция этого обьекта
---@return string ObjectName Имя порядкого обьекта
---@return number NewPosition Новая позиция этого обьекта
function TSequence:SetObjectPosition(ObjectName,NewPosition) end
--[[Добавляет порядковый обьект ]]
---@param ObjectName string Имя порядкого обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return string ObjectName Имя порядкого обьекта
---@return string | table<string,string> | TTranslator Title Заголовок обьекта
function TSequence:AddObject(ObjectName,Title) end
---@type RBXScriptSignal
--[[При смене порядка обьектов ]]
    SequenceChanged_RBXScriptSignal = {}
    ---@param callback fun(data:table)
    ---@return RBXScriptConnection
    function SequenceChanged_RBXScriptSignal:Connect(callback:(data:table)->()) end
    ---@param callback fun(data:table)
    ---@return RBXScriptConnection
    function SequenceChanged_RBXScriptSignal:Once(callback:(data:table)->()) end
    ---@return table<number,string> data
    function SequenceChanged_RBXScriptSignal:Wait() end
TSequence['SequenceChanged']=SequenceChanged_RBXScriptSignal
---@type RBXScriptSignal
--[[При открытии ]]
    OnOpen_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpen_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpen_RBXScriptSignal:Once(callback:()->()) end
    
    function OnOpen_RBXScriptSignal:Wait() end
TSequence['OnOpen']=OnOpen_RBXScriptSignal
---@type RBXScriptSignal
--[[При закрытии ]]
    OnClose_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClose_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClose_RBXScriptSignal:Once(callback:()->()) end
    
    function OnClose_RBXScriptSignal:Wait() end
TSequence['OnClose']=OnClose_RBXScriptSignal
---@type Bind
--[[Специальный бинд для анимации стрелочки. Работает как в Binder.SequenceOpenArrowBind ]]
    SpecialOpenArrowBind_Bind = {}
    ---@param callback fun(TSequence: TSequence)
    ---*return ()*
    function SpecialOpenArrowBind_Bind:Bind(callback:(TSequence: TSequence)->()) end
    ---@param TSequence TSequence
    function SpecialOpenArrowBind_Bind:Run(TSequence: TSequence) end

    SpecialOpenArrowBind_Bind_OnRun = {}
    ---@param callback fun(TSequence: TSequence)
    ---@return RBXScriptConnection
    function SpecialOpenArrowBind_Bind_OnRun:Connect(callback:(TSequence: TSequence)->()) end
    ---@param callback fun(TSequence: TSequence)
    ---@return RBXScriptConnection
    function SpecialOpenArrowBind_Bind_OnRun:Once(callback:(TSequence: TSequence)->()) end
    ---@return TSequence TSequence
    function SpecialOpenArrowBind_Bind_OnRun:Wait() end
    SpecialOpenArrowBind_Bind.OnRun = SpecialOpenArrowBind_Bind_OnRun
    TSequence['SpecialOpenArrowBind']= SpecialOpenArrowBind_Bind
---@type Bind
--[[Специальный бинд для создания обьектов в TSequence. Работает как в Binder.SequenceCreateObject ]]
    SpecialCreateObject_Bind = {}
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---*return (SequenceObject: table)*
    function SpecialCreateObject_Bind:Bind(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@param TSequence TSequence
---@param Name string
---@param Position number
---@return table SequenceObject
    function SpecialCreateObject_Bind:Run(TSequence: TSequence,Name: string,Position: number) end

    SpecialCreateObject_Bind_OnRun = {}
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---@return RBXScriptConnection
    function SpecialCreateObject_Bind_OnRun:Connect(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---@return RBXScriptConnection
    function SpecialCreateObject_Bind_OnRun:Once(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@return TSequence TSequence
---@return string Name
---@return number Position
    function SpecialCreateObject_Bind_OnRun:Wait() end
    SpecialCreateObject_Bind.OnRun = SpecialCreateObject_Bind_OnRun
    TSequence['SpecialCreateObject']= SpecialCreateObject_Bind
---@type Bind
--[[Бинд для кастомного отступа. ]]
    IndentBind_Bind = {}
    ---@param callback fun(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)
    ---*return ()*
    function IndentBind_Bind:Bind(callback:(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)->()) end
    ---@param TSequence TSequence
---@param VisibleIndent Frame
---@param SequenceFrame Frame
    function IndentBind_Bind:Run(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame) end

    IndentBind_Bind_OnRun = {}
    ---@param callback fun(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)
    ---@return RBXScriptConnection
    function IndentBind_Bind_OnRun:Connect(callback:(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)->()) end
    ---@param callback fun(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)
    ---@return RBXScriptConnection
    function IndentBind_Bind_OnRun:Once(callback:(TSequence: TSequence,VisibleIndent: Frame,SequenceFrame: Frame)->()) end
    ---@return TSequence TSequence
---@return Frame VisibleIndent
---@return Frame SequenceFrame
    function IndentBind_Bind_OnRun:Wait() end
    IndentBind_Bind.OnRun = IndentBind_Bind_OnRun
    TSequence['IndentBind']= IndentBind_Bind

---@class TSignal
--[[Можно создать свой из TEvent(Classes:CreateTEvent()) ]]
TSignal={}
--[[ ]]
function TSignal:Wait() end
--[[ ]]
function TSignal:Once() end
--[[ ]]
function TSignal:Connect() end

---@class TText : TClass : ConfigObject : TGuiObject : TextObject
--[[Равен `Text`. Нужен для определения типа обьекта ]]
--*[ReadOnly]*
---@field Type string
--[[Класс текста(или заголовка) в интерфейсе, просто текст ]]
TText={}

---@class TTextBox : TClass : ConfigObject : TGuiObject : TextObject : TextboxObject
--[[Стандартное значения, изменяется на `.Value` через `task.wait()` ]]
---@field DefaultValue string | number
--[[Тип ввода, может быть `string`(по умолчаню),`number`. Если не поддерживается, то будет восприниматься как `string` ]]
---@field InputType string
--[[Размер изменения через кнопки ]]
---@field ScaleOfButtons number
--[[Значение ]]
--*[Exception for WriteSameMode]*
---@field Value string
--[[Кнопки `+` и `-` ]]
--*[ReadOnly]*
---@field Buttons Frame
--[[Равен `TextBox`. Нужен для определения типа обьекта ]]
--*[ReadOnly]*
---@field Type string
--[[Включены ли кнопки? ]]
---@field ButtonsEnabled boolean
--[[TGuiObject класс с TextBox, позволяющий пользователю вводить текст/цифры ]]
TTextBox={}
--[[Запускает кнопку около ввода ]]
---@param ButtonType string Тип кнопки: "add" или "subtract"
---@return string ButtonType Тип кнопки: "add" или "subtract"
function TTextBox:FireButton(ButtonType) end
---@type RBXScriptSignal
--[[Запускается когда `.Value` изменилось ]]
    Changed_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Changed_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Changed_RBXScriptSignal:Once(callback:()->()) end
    
    function Changed_RBXScriptSignal:Wait() end
TTextBox['Changed']=Changed_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается когда кнопка была нажата(или запущен `:FireButton(...)`) ]]
    ButtonClicked_RBXScriptSignal = {}
    ---@param callback fun(ButtonType:string)
    ---@return RBXScriptConnection
    function ButtonClicked_RBXScriptSignal:Connect(callback:(ButtonType:string)->()) end
    ---@param callback fun(ButtonType:string)
    ---@return RBXScriptConnection
    function ButtonClicked_RBXScriptSignal:Once(callback:(ButtonType:string)->()) end
    ---@return string ButtonType
    function ButtonClicked_RBXScriptSignal:Wait() end
TTextBox['ButtonClicked']=ButtonClicked_RBXScriptSignal
---@type Bind
--[[Специальный бинд для установки позиции названия и поля для ввода, работает как в Binder.RefreshTextBoxSizes ]]
    SpecialRefreshTextBoxSizes_Bind = {}
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---*return ()*
    function SpecialRefreshTextBoxSizes_Bind:Bind(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@param TTextBox TTextBox
---@param TextLabel TextLabel
---@param TextBox TextBox
    function SpecialRefreshTextBoxSizes_Bind:Run(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox) end

    SpecialRefreshTextBoxSizes_Bind_OnRun = {}
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---@return RBXScriptConnection
    function SpecialRefreshTextBoxSizes_Bind_OnRun:Connect(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---@return RBXScriptConnection
    function SpecialRefreshTextBoxSizes_Bind_OnRun:Once(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@return TTextBox TTextBox
---@return TextLabel TextLabel
---@return TextBox TextBox
    function SpecialRefreshTextBoxSizes_Bind_OnRun:Wait() end
    SpecialRefreshTextBoxSizes_Bind.OnRun = SpecialRefreshTextBoxSizes_Bind_OnRun
    TTextBox['SpecialRefreshTextBoxSizes']= SpecialRefreshTextBoxSizes_Bind

---@class TToggle : TClass : ConfigObject : TGuiObject : ButtonObject : GuiKeybindingObject
--[[Значение ]]
---@field Value boolean
--[[Стандартное значение, ставится как в `Value` после `task.wait()` при создании обьекта ]]
---@field DefaultValue boolean
--[[Равен `Toggle`. Нужен для определения типа обьекта ]]
--*[ReadOnly]*
---@field Type string
--[[Кнопка-переключатель в главном интерфейсе ]]
TToggle={}
--[[Обновляет цвет текста ]]
---@param DoNotAnimate boolean Не анимировать?(если `true`, резко установит цвет на нужный)?
---@return boolean DoNotAnimate Не анимировать?(если `true`, резко установит цвет на нужный)
function TToggle:RefreshTextColorFromValue(DoNotAnimate) end
---@type RBXScriptSignal
--[[Запускается когда Value изменилось на `false` ]]
    OnFalse_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFalse_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFalse_RBXScriptSignal:Once(callback:()->()) end
    
    function OnFalse_RBXScriptSignal:Wait() end
TToggle['OnFalse']=OnFalse_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается когда Value изменилось ]]
    Changed_RBXScriptSignal = {}
    ---@param callback fun(Value:boolean)
    ---@return RBXScriptConnection
    function Changed_RBXScriptSignal:Connect(callback:(Value:boolean)->()) end
    ---@param callback fun(Value:boolean)
    ---@return RBXScriptConnection
    function Changed_RBXScriptSignal:Once(callback:(Value:boolean)->()) end
    ---@return boolean Value
    function Changed_RBXScriptSignal:Wait() end
TToggle['Changed']=Changed_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается когда Value изменилось на `true` ]]
    OnTrue_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnTrue_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnTrue_RBXScriptSignal:Once(callback:()->()) end
    
    function OnTrue_RBXScriptSignal:Wait() end
TToggle['OnTrue']=OnTrue_RBXScriptSignal
---@type Bind
--[[Бинд для (анимации) цвета текста в зависимости от значения. Работает как в Binder.TextColorForToggle ]]
    SpecialTextColorForToggle_Bind = {}
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---*return ()*
    function SpecialTextColorForToggle_Bind:Bind(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@param Toggle TToggle
---@param enableAnimation boolean
    function SpecialTextColorForToggle_Bind:Run(Toggle: TToggle,enableAnimation: boolean) end

    SpecialTextColorForToggle_Bind_OnRun = {}
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---@return RBXScriptConnection
    function SpecialTextColorForToggle_Bind_OnRun:Connect(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---@return RBXScriptConnection
    function SpecialTextColorForToggle_Bind_OnRun:Once(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@return TToggle Toggle
---@return boolean enableAnimation
    function SpecialTextColorForToggle_Bind_OnRun:Wait() end
    SpecialTextColorForToggle_Bind.OnRun = SpecialTextColorForToggle_Bind_OnRun
    TToggle['SpecialTextColorForToggle']= SpecialTextColorForToggle_Bind

---@class TTranslator : TClass : Preset
--[[Русский вариант ]]
---@field uk any?
--[[Английский вариант ]]
---@field en any?
--[[Русский вариант ]]
---@field ru any?
--[[Класс для перевода variables, можно создать с помощью TClasses:CreateTranslator() ]]
TTranslator={}
--[[Получить переведённый вариант ]]
function TTranslator:Translate() end
--[[Получает доступный нужный перевод текста ]]
function TTranslator:GetLangCode() end
---@type RBXScriptSignal
--[[Запускается когда изменился нужный перевод текста ]]
    TranslateValueChanged_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function TranslateValueChanged_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function TranslateValueChanged_RBXScriptSignal:Once(callback:()->()) end
    
    function TranslateValueChanged_RBXScriptSignal:Wait() end
TTranslator['TranslateValueChanged']=TranslateValueChanged_RBXScriptSignal

---@class TWindow : TClass : ConfigObject
--[[Размер `.Frame` ]]
---@field Size UDim2
--[[ImageButton для закрытия этого окна ]]
--*[ReadOnly]*
---@field CloseButton ImageButton
--[[ImageButton для сворачивания этого окна ]]
--*[ReadOnly]*
---@field HideButton ImageButton
--[[Включены ли обычные эвенты перемещения окна? ]]
---@field DefaultDragEventsEnabled boolean
--[[Может ли пользователь закрыть это окно. Обычно `true` ]]
---@field UserCanClose boolean
--[[Открыто ли окно? ]]
---@field Opened boolean
--[[Позиция относительно левого верхнего угла окна. [сохраняется в конфиге] ]]
---@field Position UDim2
--[[Специальные цвета ]]
--*[ReadOnly]*
---@field SpecialColors SpecialColors
--[[Frame окна ]]
--*[ReadOnly]*
---@field WindowFrame Frame
--[[DragDetector для перемещения окна ]]
--*[ReadOnly]*
---@field DragDetector DragDetector
--[[Имя окна ]]
--*[ReadOnly]*
---@field Name string
--[[UICorner для заднего фона ]]
--*[ReadOnly]*
---@field BackgroundUICorner UICorner
--[[Свёрнуто(спрятано) ли окно? [сохраняется в конфиге] ]]
---@field Hidden boolean
--[[Название в заголовке. По умолчанию полность закрывает `.Header` ]]
--*[ReadOnly]*
---@field HeaderText TextLabel
--[[Frame заголовка окна ]]
--*[ReadOnly]*
---@field HeaderFrame Frame
--[[+ZOrder для окна, обычно 1, а для Prompt 2 ]]
---@field DisplayOrder number
--[[Свободная и основная часть окна ]]
--*[ReadOnly]*
---@field Frame TextLabel
--[[Верхняя часть фона(чтоб верхние углы фона не были скруглены) ]]
--*[ReadOnly]*
---@field BackgroundUpFrame Frame
--[[Включены ли обычные эвенты перемещения окна? Если изменено на `false`, устанавливает `Hidden` на `false` ]]
---@field CanHide boolean
--[[Свободная часть заголовка, которая обычно занята Названием(`.HeaderText`) ]]
--*[ReadOnly]*
---@field Header Frame
--[[Задний фон окна ]]
--*[ReadOnly]*
---@field BackgroundFrame Frame
--[[UICorner для Заголовка окна ]]
--*[ReadOnly]*
---@field HeaderUICorner UICorner
--[[Заголовок окна ]]
--*[ReadOnly]*
---@field Title TTranslator
--[[Y Размер заголовка ]]
---@field HeaderSize UDim
--[[Есть ли фокус на окне? ]]
---@field Focused boolean
--[[Нижняя часть заголовка(чтоб нижнии углы заголовка не были скруглены) ]]
--*[ReadOnly]*
---@field HeaderDownFrame Frame
--[[Класс для создания окн, по умолчанию пустое окно. Устанавливает `ConfigSaveName` на `Name` через `task.wait()` и делает его только для чтения ]]
TWindow={}
--[[Двигает это окно в заданную позицию ]]
---@param Position UDim2 Позиция
---@param AnchorPoint Vector2 Точка крепления (По умолчанию `Vector2.new(0.5,0.5)`)?
---@return UDim2 Position Позиция
---@return Vector2 AnchorPoint Точка крепления (По умолчанию `Vector2.new(0.5,0.5)`)
function TWindow:Move(Position,AnchorPoint) end
--[[Удаляет окно ]]
---@param Position UDim2 Позиция
---@param AnchorPoint Vector2 Точка крепления (По умолчанию `Vector2.new(0.5,0.5)`)?
---@return UDim2 Position Позиция
---@return Vector2 AnchorPoint Точка крепления (По умолчанию `Vector2.new(0.5,0.5)`)
function TWindow:Destroy(Position,AnchorPoint) end
---@type RBXScriptSignal
--[[Запускается если окно закрыто(`.Opened=false`) ]]
    OnClose_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClose_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClose_RBXScriptSignal:Once(callback:()->()) end
    
    function OnClose_RBXScriptSignal:Wait() end
TWindow['OnClose']=OnClose_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается при фокусе окна(`.Focus=true`) ]]
    OnFocus_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFocus_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFocus_RBXScriptSignal:Once(callback:()->()) end
    
    function OnFocus_RBXScriptSignal:Wait() end
TWindow['OnFocus']=OnFocus_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается когда окно было подвинуто ]]
    OnMoved_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnMoved_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnMoved_RBXScriptSignal:Once(callback:()->()) end
    
    function OnMoved_RBXScriptSignal:Wait() end
TWindow['OnMoved']=OnMoved_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается когда окно удаляется (при `:Destroy()`) ]]
    Destroyed_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destroyed_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destroyed_RBXScriptSignal:Once(callback:()->()) end
    
    function Destroyed_RBXScriptSignal:Wait() end
TWindow['Destroyed']=Destroyed_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается при потере фокуса окна(`.Focus=false`) ]]
    OnFocusLost_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFocusLost_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFocusLost_RBXScriptSignal:Once(callback:()->()) end
    
    function OnFocusLost_RBXScriptSignal:Wait() end
TWindow['OnFocusLost']=OnFocusLost_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается если окно открыто(`.Opened=true`) ]]
    OnOpened_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpened_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpened_RBXScriptSignal:Once(callback:()->()) end
    
    function OnOpened_RBXScriptSignal:Wait() end
TWindow['OnOpened']=OnOpened_RBXScriptSignal
---@type Bind
--[[Специальный бинд для обновления размера окна. Работает как в Binder.WindowSizeRefresh ]]
    SpecialTWindowSizeRefresh_Bind = {}
    ---@param callback fun(Window: TWindow)
    ---*return ()*
    function SpecialTWindowSizeRefresh_Bind:Bind(callback:(Window: TWindow)->()) end
    ---@param Window TWindow
    function SpecialTWindowSizeRefresh_Bind:Run(Window: TWindow) end

    SpecialTWindowSizeRefresh_Bind_OnRun = {}
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function SpecialTWindowSizeRefresh_Bind_OnRun:Connect(callback:(Window: TWindow)->()) end
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function SpecialTWindowSizeRefresh_Bind_OnRun:Once(callback:(Window: TWindow)->()) end
    ---@return TWindow Window
    function SpecialTWindowSizeRefresh_Bind_OnRun:Wait() end
    SpecialTWindowSizeRefresh_Bind.OnRun = SpecialTWindowSizeRefresh_Bind_OnRun
    TWindow['SpecialTWindowSizeRefresh']= SpecialTWindowSizeRefresh_Bind
---@type Bind
--[[Специальный бинд для анимации стрелочки скрытия. Работает как в Binder.TWindowHideArrowAnimation ]]
    SpecialHideArrowAnimation_Bind = {}
    ---@param callback fun(Window: TWindow)
    ---*return ()*
    function SpecialHideArrowAnimation_Bind:Bind(callback:(Window: TWindow)->()) end
    ---@param Window TWindow
    function SpecialHideArrowAnimation_Bind:Run(Window: TWindow) end

    SpecialHideArrowAnimation_Bind_OnRun = {}
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function SpecialHideArrowAnimation_Bind_OnRun:Connect(callback:(Window: TWindow)->()) end
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function SpecialHideArrowAnimation_Bind_OnRun:Once(callback:(Window: TWindow)->()) end
    ---@return TWindow Window
    function SpecialHideArrowAnimation_Bind_OnRun:Wait() end
    SpecialHideArrowAnimation_Bind.OnRun = SpecialHideArrowAnimation_Bind_OnRun
    TWindow['SpecialHideArrowAnimation']= SpecialHideArrowAnimation_Bind

---@class ValueBind : TClass
--[[Включен ли бинд(то есть прослушивается ли) ]]
---@field Enabled boolean
--[[Значение, может быть изменено через .Translator ]]
--*[Exception for WriteSameMode]*
---@field Value any
--[[Id этого бинда ]]
---@field Id number
--[[Значение, но с переводом, изменяет .Value если нужный перевод был изменён ]]
---@field Translator TTranslator
--[[ValueBinder, к которому пренадлежит этот VBind ]]
--*[Exception for WriteSameMode]*
---@field Parent ValueBinder
--[[Бинд для значений, использующийся в ValueBinder ]]
ValueBind={}
---@type RBXScriptSignal
--[[Запускается если Binder больше не слушает этот Bind ]]
    OnDisabled_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnDisabled_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnDisabled_RBXScriptSignal:Once(callback:()->()) end
    
    function OnDisabled_RBXScriptSignal:Wait() end
ValueBind['OnDisabled']=OnDisabled_RBXScriptSignal
---@type RBXScriptSignal
--[[Запускается если ValueBinder слушает этот Bind ]]
    OnEnabled_RBXScriptSignal = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnEnabled_RBXScriptSignal:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnEnabled_RBXScriptSignal:Once(callback:()->()) end
    
    function OnEnabled_RBXScriptSignal:Wait() end
ValueBind['OnEnabled']=OnEnabled_RBXScriptSignal

---@class ValueBinder : TClass
--[[Значение, можно изменить прям так, но не советуется. ]]
--*[Exception for WriteSameMode]*
---@field Value any
--[[Id слушаемого ValueBind'а, его значения будут в .Value. По умолчанию 0(если не существует, то стандартное значение) ]]
---@field ListenId number
--[[Биндер для значений, используется чтобы значения не наслаивались друг на друга. Создаётся через TClasses:CreateValueBinder(Стандартное значение) ]]
ValueBinder={}
--[[Создаёт ValueBind для установки значения ]]
---@param TurnOnListing boolean Установить на слушание(если нету, то считается как true)?
---@return boolean TurnOnListing Установить на слушание(если нету, то считается как true)
function ValueBinder:Bind(TurnOnListing) end
---@type RBXScriptSignal
--[[Запускается когда ValueBinder:Bind был запущен ]]
    OnBinded_RBXScriptSignal = {}
    ---@param callback fun(Id:number)
    ---@return RBXScriptConnection
    function OnBinded_RBXScriptSignal:Connect(callback:(Id:number)->()) end
    ---@param callback fun(Id:number)
    ---@return RBXScriptConnection
    function OnBinded_RBXScriptSignal:Once(callback:(Id:number)->()) end
    ---@return number Id
    function OnBinded_RBXScriptSignal:Wait() end
ValueBinder['OnBinded']=OnBinded_RBXScriptSignal