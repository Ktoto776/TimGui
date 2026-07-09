---@diagnostic disable: undefined-type
---@meta
---@class Binder : TClass
--[[Класс для глобальной замены стандартных функций(или же сборник Binds) ]]
Binder={}
--[[Создаёт новый класс Bind ]]
---@return Bind Bind Класс Bind
function Binder:New() end
---@type Bind
--[[Анимация стрелочки скрытия ]]
    local TWind_Bind = {}
    ---@param callback fun(Window: TWindow)
    ---*return ()*
    function TWind_Bind:Bind(callback:(Window: TWindow)->()) end
    ---@param Window TWindow
    function TWind_Bind:Run(Window: TWindow) end

    local TWind_Bind_OnRun = {}
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function TWind_Bind_OnRun:Connect(callback:(Window: TWindow)->()) end
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function TWind_Bind_OnRun:Once(callback:(Window: TWindow)->()) end
    ---@return TWindow Window
    function TWind_Bind_OnRun:Wait() end
    TWind_Bind.OnRun = TWind_Bind_OnRun
    Binder['TWindowHideArrowAnimation']= TWind_Bind
---@type Bind
--[[Бинд для установки позиции объектам(и не глобальным группам) ]]
    local Butto_Bind = {}
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---*return (nextPos: UDim2)*
    function Butto_Bind:Bind(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@param child TGuiObject
---@param pos UDim2
---@return UDim2 nextPos
    function Butto_Bind:Run(child: TGuiObject,pos: UDim2) end

    local Butto_Bind_OnRun = {}
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---@return RBXScriptConnection
    function Butto_Bind_OnRun:Connect(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---@return RBXScriptConnection
    function Butto_Bind_OnRun:Once(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@return TGuiObject child
---@return UDim2 pos
    function Butto_Bind_OnRun:Wait() end
    Butto_Bind.OnRun = Butto_Bind_OnRun
    Binder['ButtonPositionBind']= Butto_Bind
---@type Bind
--[[Бинд для установки размера описанию KeyPrompt'а. ]]
    local KeyPr_Bind = {}
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function KeyPr_Bind:Bind(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@param KeyPrompt KeyPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function KeyPr_Bind:Run(KeyPrompt: KeyPrompt,startYPos: UDim) end

    local KeyPr_Bind_OnRun = {}
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function KeyPr_Bind_OnRun:Connect(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@param callback fun(KeyPrompt: KeyPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function KeyPr_Bind_OnRun:Once(callback:(KeyPrompt: KeyPrompt,startYPos: UDim)->()) end
    ---@return KeyPrompt KeyPrompt
---@return UDim startYPos
    function KeyPr_Bind_OnRun:Wait() end
    KeyPr_Bind.OnRun = KeyPr_Bind_OnRun
    Binder['KeyPromptDescriptionSizeBind']= KeyPr_Bind
---@type Bind
--[[Бинд для установки позиции MenuItem. ]]
    local MenuI_Bind = {}
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---*return (lastYPos: UDim)*
    function MenuI_Bind:Bind(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@param MenuItem MenuItem
---@param YPosition UDim
---@return UDim lastYPos
    function MenuI_Bind:Run(MenuItem: MenuItem,YPosition: UDim) end

    local MenuI_Bind_OnRun = {}
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---@return RBXScriptConnection
    function MenuI_Bind_OnRun:Connect(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---@return RBXScriptConnection
    function MenuI_Bind_OnRun:Once(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@return MenuItem MenuItem
---@return UDim YPosition
    function MenuI_Bind_OnRun:Wait() end
    MenuI_Bind.OnRun = MenuI_Bind_OnRun
    Binder['MenuItemRefreshPositionBind']= MenuI_Bind
---@type Bind
--[[Бинд для (анимации) смены цвета в Toggle в зависимости от значения. ]]
    local TextC_Bind = {}
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---*return ()*
    function TextC_Bind:Bind(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@param Toggle TToggle
---@param enableAnimation boolean
    function TextC_Bind:Run(Toggle: TToggle,enableAnimation: boolean) end

    local TextC_Bind_OnRun = {}
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---@return RBXScriptConnection
    function TextC_Bind_OnRun:Connect(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---@return RBXScriptConnection
    function TextC_Bind_OnRun:Once(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@return TToggle Toggle
---@return boolean enableAnimation
    function TextC_Bind_OnRun:Wait() end
    TextC_Bind.OnRun = TextC_Bind_OnRun
    Binder['TextColorForToggle']= TextC_Bind
---@type Bind
--[[Бинд для установки размера описанию ConfirmationPrompt'а. ]]
    local Confi_Bind = {}
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function Confi_Bind:Bind(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@param ConfirmationPrompt ConfirmationPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function Confi_Bind:Run(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim) end

    local Confi_Bind_OnRun = {}
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function Confi_Bind_OnRun:Connect(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@param callback fun(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function Confi_Bind_OnRun:Once(callback:(ConfirmationPrompt: ConfirmationPrompt,startYPos: UDim)->()) end
    ---@return ConfirmationPrompt ConfirmationPrompt
---@return UDim startYPos
    function Confi_Bind_OnRun:Wait() end
    Confi_Bind.OnRun = Confi_Bind_OnRun
    Binder['ConfirmationPromptDescriptionSizeBind']= Confi_Bind
---@type Bind
--[[Бинд для анимации стрелочки. Не забывай про TimGui.GuiAnimations.ArrowRotateAnimationEnabled(при выкл просто тп)/ArrowRotateTI. ]]
    local Arrow_Bind = {}
    ---@param callback fun(Arrow: UIBase,isOpen: boolean)
    ---*return ()*
    function Arrow_Bind:Bind(callback:(Arrow: UIBase,isOpen: boolean)->()) end
    ---@param Arrow UIBase
---@param isOpen boolean
    function Arrow_Bind:Run(Arrow: UIBase,isOpen: boolean) end

    local Arrow_Bind_OnRun = {}
    ---@param callback fun(Arrow: UIBase,isOpen: boolean)
    ---@return RBXScriptConnection
    function Arrow_Bind_OnRun:Connect(callback:(Arrow: UIBase,isOpen: boolean)->()) end
    ---@param callback fun(Arrow: UIBase,isOpen: boolean)
    ---@return RBXScriptConnection
    function Arrow_Bind_OnRun:Once(callback:(Arrow: UIBase,isOpen: boolean)->()) end
    ---@return UIBase Arrow
---@return boolean isOpen
    function Arrow_Bind_OnRun:Wait() end
    Arrow_Bind.OnRun = Arrow_Bind_OnRun
    Binder['ArrowAnimation']= Arrow_Bind
---@type Bind
--[[Бинд для установки размера MenuItem. Не забывай про GuiSize.MenuItemYSize. ]]
    local MenuI_Bind = {}
    ---@param callback fun(MenuItem: MenuItem)
    ---*return (XSizeOffset: number)*
    function MenuI_Bind:Bind(callback:(MenuItem: MenuItem)->()) end
    ---@param MenuItem MenuItem
---@return number XSizeOffset
    function MenuI_Bind:Run(MenuItem: MenuItem) end

    local MenuI_Bind_OnRun = {}
    ---@param callback fun(MenuItem: MenuItem)
    ---@return RBXScriptConnection
    function MenuI_Bind_OnRun:Connect(callback:(MenuItem: MenuItem)->()) end
    ---@param callback fun(MenuItem: MenuItem)
    ---@return RBXScriptConnection
    function MenuI_Bind_OnRun:Once(callback:(MenuItem: MenuItem)->()) end
    ---@return MenuItem MenuItem
    function MenuI_Bind_OnRun:Wait() end
    MenuI_Bind.OnRun = MenuI_Bind_OnRun
    Binder['MenuItemRefreshSizeBind']= MenuI_Bind
---@type Bind
--[[Бинд для анимации открытия. Не забывай про TimGui.GuiAnimations.OpenAnimationEnabled(при выкл просто тп)/OpenTI. ]]
    local OpenA_Bind = {}
    ---@param callback fun(Frame: UIBase,isOpen: boolean)
    ---*return ()*
    function OpenA_Bind:Bind(callback:(Frame: UIBase,isOpen: boolean)->()) end
    ---@param Frame UIBase
---@param isOpen boolean
    function OpenA_Bind:Run(Frame: UIBase,isOpen: boolean) end

    local OpenA_Bind_OnRun = {}
    ---@param callback fun(Frame: UIBase,isOpen: boolean)
    ---@return RBXScriptConnection
    function OpenA_Bind_OnRun:Connect(callback:(Frame: UIBase,isOpen: boolean)->()) end
    ---@param callback fun(Frame: UIBase,isOpen: boolean)
    ---@return RBXScriptConnection
    function OpenA_Bind_OnRun:Once(callback:(Frame: UIBase,isOpen: boolean)->()) end
    ---@return UIBase Frame
---@return boolean isOpen
    function OpenA_Bind_OnRun:Wait() end
    OpenA_Bind.OnRun = OpenA_Bind_OnRun
    Binder['OpenAnimation']= OpenA_Bind
---@type Bind
--[[Бинд для создания обьекта в Sequence. ]]
    local Seque_Bind = {}
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---*return (SequenceObject: table)*
    function Seque_Bind:Bind(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@param TSequence TSequence
---@param Name string
---@param Position number
---@return table SequenceObject
    function Seque_Bind:Run(TSequence: TSequence,Name: string,Position: number) end

    local Seque_Bind_OnRun = {}
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---@return RBXScriptConnection
    function Seque_Bind_OnRun:Connect(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@param callback fun(TSequence: TSequence,Name: string,Position: number)
    ---@return RBXScriptConnection
    function Seque_Bind_OnRun:Once(callback:(TSequence: TSequence,Name: string,Position: number)->()) end
    ---@return TSequence TSequence
---@return string Name
---@return number Position
    function Seque_Bind_OnRun:Wait() end
    Seque_Bind.OnRun = Seque_Bind_OnRun
    Binder['SequenceCreateObject']= Seque_Bind
---@type Bind
--[[Бинд для установки позиции глобальным группам.  ]]
    local Globa_Bind = {}
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---*return (nextPos: UDim2)*
    function Globa_Bind:Bind(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@param GlobalGroup TGroup
---@param pos UDim2
---@return UDim2 nextPos
    function Globa_Bind:Run(GlobalGroup: TGroup,pos: UDim2) end

    local Globa_Bind_OnRun = {}
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---@return RBXScriptConnection
    function Globa_Bind_OnRun:Connect(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@param callback fun(GlobalGroup: TGroup,pos: UDim2)
    ---@return RBXScriptConnection
    function Globa_Bind_OnRun:Once(callback:(GlobalGroup: TGroup,pos: UDim2)->()) end
    ---@return TGroup GlobalGroup
---@return UDim2 pos
    function Globa_Bind_OnRun:Wait() end
    Globa_Bind.OnRun = Globa_Bind_OnRun
    Binder['GlobalGroupRefreshPosition']= Globa_Bind
---@type Bind
--[[Бинд для подсчёта видимости обьекта(свойство Visible работает поверх и его подсчитывать не нужно). ]]
    local Visib_Bind = {}
    ---@param callback fun(Object: TGuiObject)
    ---*return ()*
    function Visib_Bind:Bind(callback:(Object: TGuiObject)->()) end
    ---@param Object TGuiObject
    function Visib_Bind:Run(Object: TGuiObject) end

    local Visib_Bind_OnRun = {}
    ---@param callback fun(Object: TGuiObject)
    ---@return RBXScriptConnection
    function Visib_Bind_OnRun:Connect(callback:(Object: TGuiObject)->()) end
    ---@param callback fun(Object: TGuiObject)
    ---@return RBXScriptConnection
    function Visib_Bind_OnRun:Once(callback:(Object: TGuiObject)->()) end
    ---@return TGuiObject Object
    function Visib_Bind_OnRun:Wait() end
    Visib_Bind.OnRun = Visib_Bind_OnRun
    Binder['VisibleBind']= Visib_Bind
---@type Bind
--[[Бинд для установки позиций названия и поля для ввода. ]]
    local Refre_Bind = {}
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---*return ()*
    function Refre_Bind:Bind(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@param TTextBox TTextBox
---@param TextLabel TextLabel
---@param TextBox TextBox
    function Refre_Bind:Run(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox) end

    local Refre_Bind_OnRun = {}
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---@return RBXScriptConnection
    function Refre_Bind_OnRun:Connect(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@param callback fun(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)
    ---@return RBXScriptConnection
    function Refre_Bind_OnRun:Once(callback:(TTextBox: TTextBox,TextLabel: TextLabel,TextBox: TextBox)->()) end
    ---@return TTextBox TTextBox
---@return TextLabel TextLabel
---@return TextBox TextBox
    function Refre_Bind_OnRun:Wait() end
    Refre_Bind.OnRun = Refre_Bind_OnRun
    Binder['RefreshTextBoxSizes']= Refre_Bind
---@type Bind
--[[Бинд для анимации открытия не глобальных групп. Не забудь TimGui.GuiAnimations.EnableGroupAnimation ]]
    local Group_Bind = {}
    ---@param callback fun(group: TGroup)
    ---*return ()*
    function Group_Bind:Bind(callback:(group: TGroup)->()) end
    ---@param group TGroup
    function Group_Bind:Run(group: TGroup) end

    local Group_Bind_OnRun = {}
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function Group_Bind_OnRun:Connect(callback:(group: TGroup)->()) end
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function Group_Bind_OnRun:Once(callback:(group: TGroup)->()) end
    ---@return TGroup group
    function Group_Bind_OnRun:Wait() end
    Group_Bind.OnRun = Group_Bind_OnRun
    Binder['GroupOpenArrowBind']= Group_Bind
---@type Bind
--[[Бинд для анимации стрелочки ]]
    local Seque_Bind = {}
    ---@param callback fun(TSequence: TSequence)
    ---*return ()*
    function Seque_Bind:Bind(callback:(TSequence: TSequence)->()) end
    ---@param TSequence TSequence
    function Seque_Bind:Run(TSequence: TSequence) end

    local Seque_Bind_OnRun = {}
    ---@param callback fun(TSequence: TSequence)
    ---@return RBXScriptConnection
    function Seque_Bind_OnRun:Connect(callback:(TSequence: TSequence)->()) end
    ---@param callback fun(TSequence: TSequence)
    ---@return RBXScriptConnection
    function Seque_Bind_OnRun:Once(callback:(TSequence: TSequence)->()) end
    ---@return TSequence TSequence
    function Seque_Bind_OnRun:Wait() end
    Seque_Bind.OnRun = Seque_Bind_OnRun
    Binder['SequenceOpenArrowBind']= Seque_Bind
---@type Bind
--[[Бинд для установки размера глобальным группам ]]
    local Globa_Bind = {}
    ---@param callback fun(group: TGroup)
    ---*return ()*
    function Globa_Bind:Bind(callback:(group: TGroup)->()) end
    ---@param group TGroup
    function Globa_Bind:Run(group: TGroup) end

    local Globa_Bind_OnRun = {}
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function Globa_Bind_OnRun:Connect(callback:(group: TGroup)->()) end
    ---@param callback fun(group: TGroup)
    ---@return RBXScriptConnection
    function Globa_Bind_OnRun:Once(callback:(group: TGroup)->()) end
    ---@return TGroup group
    function Globa_Bind_OnRun:Wait() end
    Globa_Bind.OnRun = Globa_Bind_OnRun
    Binder['GlobalGroupRefreshSize']= Globa_Bind
---@type Bind
--[[Бинд для установки размера объектам. Не забывай про TimGui.GuiSize.ButtonSize! ]]
    local TObje_Bind = {}
    ---@param callback fun(TGuiObject: TGuiObject)
    ---*return ()*
    function TObje_Bind:Bind(callback:(TGuiObject: TGuiObject)->()) end
    ---@param TGuiObject TGuiObject
    function TObje_Bind:Run(TGuiObject: TGuiObject) end

    local TObje_Bind_OnRun = {}
    ---@param callback fun(TGuiObject: TGuiObject)
    ---@return RBXScriptConnection
    function TObje_Bind_OnRun:Connect(callback:(TGuiObject: TGuiObject)->()) end
    ---@param callback fun(TGuiObject: TGuiObject)
    ---@return RBXScriptConnection
    function TObje_Bind_OnRun:Once(callback:(TGuiObject: TGuiObject)->()) end
    ---@return TGuiObject TGuiObject
    function TObje_Bind_OnRun:Wait() end
    TObje_Bind.OnRun = TObje_Bind_OnRun
    Binder['TObjectSize']= TObje_Bind
---@type Bind
--[[Бинд для установки размера описанию TextPrompt'а. ]]
    local TextP_Bind = {}
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---*return (lastYPos: UDim)*
    function TextP_Bind:Bind(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@param TextPrompt TextPrompt
---@param startYPos UDim
---@return UDim lastYPos
    function TextP_Bind:Run(TextPrompt: TextPrompt,startYPos: UDim) end

    local TextP_Bind_OnRun = {}
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function TextP_Bind_OnRun:Connect(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@param callback fun(TextPrompt: TextPrompt,startYPos: UDim)
    ---@return RBXScriptConnection
    function TextP_Bind_OnRun:Once(callback:(TextPrompt: TextPrompt,startYPos: UDim)->()) end
    ---@return TextPrompt TextPrompt
---@return UDim startYPos
    function TextP_Bind_OnRun:Wait() end
    TextP_Bind.OnRun = TextP_Bind_OnRun
    Binder['TextPromptDescriptionSizeBind']= TextP_Bind
---@type Bind
--[[Бинд для запуска обновлений позиций кнопок. ]]
    local Refre_Bind = {}
    ---@param callback fun(children: table,FromObject: TGuiObject)
    ---*return (lastPos: UDim2)*
    function Refre_Bind:Bind(callback:(children: table,FromObject: TGuiObject)->()) end
    ---@param children table<number,TGuiObject>
---@param FromObject TGuiObject
---@return UDim2 lastPos
    function Refre_Bind:Run(children: table,FromObject: TGuiObject) end

    local Refre_Bind_OnRun = {}
    ---@param callback fun(children: table,FromObject: TGuiObject)
    ---@return RBXScriptConnection
    function Refre_Bind_OnRun:Connect(callback:(children: table,FromObject: TGuiObject)->()) end
    ---@param callback fun(children: table,FromObject: TGuiObject)
    ---@return RBXScriptConnection
    function Refre_Bind_OnRun:Once(callback:(children: table,FromObject: TGuiObject)->()) end
    ---@return table<number,TGuiObject> children
---@return TGuiObject FromObject
    function Refre_Bind_OnRun:Wait() end
    Refre_Bind.OnRun = Refre_Bind_OnRun
    Binder['RefreshingBind']= Refre_Bind
---@type Bind
--[[Бинд для обновления размера окна. Не забудь про TWindow.Size,TWindow.HeaderSize ]]
    local Windo_Bind = {}
    ---@param callback fun(Window: TWindow)
    ---*return ()*
    function Windo_Bind:Bind(callback:(Window: TWindow)->()) end
    ---@param Window TWindow
    function Windo_Bind:Run(Window: TWindow) end

    local Windo_Bind_OnRun = {}
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function Windo_Bind_OnRun:Connect(callback:(Window: TWindow)->()) end
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function Windo_Bind_OnRun:Once(callback:(Window: TWindow)->()) end
    ---@return TWindow Window
    function Windo_Bind_OnRun:Wait() end
    Windo_Bind.OnRun = Windo_Bind_OnRun
    Binder['WindowSizeRefresh']= Windo_Bind