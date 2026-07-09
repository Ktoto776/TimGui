---@diagnostic disable: undefined-type
---@meta
---@class TWindow : ConfigObject : TClass
--[[Свободная и основная часть окна ]]
--*[ReadOnly]*
---@field Frame TextLabel
--[[Есть ли фокус на окне? ]]
---@field Focused boolean
--[[Включены ли обычные эвенты перемещения окна? Если изменено на `false`, устанавливает `Hidden` на `false` ]]
---@field CanHide boolean
--[[ImageButton для закрытия этого окна ]]
--*[ReadOnly]*
---@field CloseButton ImageButton
--[[Открыто ли окно? ]]
---@field Opened boolean
--[[Заголовок окна ]]
--*[ReadOnly]*
---@field Title TTranslator
--[[UICorner для заднего фона ]]
--*[ReadOnly]*
---@field BackgroundUICorner UICorner
--[[+ZOrder для окна, обычно 1, а для Prompt 2 ]]
---@field DisplayOrder number
--[[UICorner для Заголовка окна ]]
--*[ReadOnly]*
---@field HeaderUICorner UICorner
--[[Имя окна ]]
--*[ReadOnly]*
---@field Name string
--[[Задний фон окна ]]
--*[ReadOnly]*
---@field BackgroundFrame Frame
--[[Y Размер заголовка ]]
---@field HeaderSize UDim
--[[Специальные цвета ]]
--*[ReadOnly]*
---@field SpecialColors SpecialColors
--[[Может ли пользователь закрыть это окно. Обычно `true` ]]
---@field UserCanClose boolean
--[[Название в заголовке. По умолчанию полность закрывает `.Header` ]]
--*[ReadOnly]*
---@field HeaderText TextLabel
--[[Frame заголовка окна ]]
--*[ReadOnly]*
---@field HeaderFrame Frame
--[[Включены ли обычные эвенты перемещения окна? ]]
---@field DefaultDragEventsEnabled boolean
--[[Размер `.Frame` ]]
---@field Size UDim2
--[[Frame окна ]]
--*[ReadOnly]*
---@field WindowFrame Frame
--[[Свёрнуто(спрятано) ли окно? [сохраняется в конфиге] ]]
---@field Hidden boolean
--[[Верхняя часть фона(чтоб верхние углы фона не были скруглены) ]]
--*[ReadOnly]*
---@field BackgroundUpFrame Frame
--[[Свободная часть заголовка, которая обычно занята Названием(`.HeaderText`) ]]
--*[ReadOnly]*
---@field Header Frame
--[[ImageButton для сворачивания этого окна ]]
--*[ReadOnly]*
---@field HideButton ImageButton
--[[DragDetector для перемещения окна ]]
--*[ReadOnly]*
---@field DragDetector DragDetector
--[[Позиция относительно левого верхнего угла окна. [сохраняется в конфиге] ]]
---@field Position UDim2
--[[Нижняя часть заголовка(чтоб нижнии углы заголовка не были скруглены) ]]
--*[ReadOnly]*
---@field HeaderDownFrame Frame
--[[Класс для создания окн, по умолчанию пустое окно. Устанавливает `ConfigSaveName` на `Name` через `task.wait()` и делает его только для чтения ]]
TWindow={}
--[[Двигает это окно в заданную позицию ]]
---@param Position UDim2 Позиция
---@param AnchorPoint? Vector2 Точка крепления (По умолчанию `Vector2.new(0.5,0.5)`)
function TWindow:Move(Position,AnchorPoint) end
--[[Удаляет окно ]]
---@param Position UDim2 Позиция
---@param AnchorPoint? Vector2 Точка крепления (По умолчанию `Vector2.new(0.5,0.5)`)
function TWindow:Destroy(Position,AnchorPoint) end
---@type RBXScriptSignal
--[[Запускается когда окно удаляется (при `:Destroy()`) ]]
    local Destr_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destr_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destr_RB:Once(callback:()->()) end
    
    function Destr_RB:Wait() end
TWindow['Destroyed']=Destr_RB
---@type RBXScriptSignal
--[[Запускается при потере фокуса окна(`.Focus=false`) ]]
    local OnFoc_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFoc_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFoc_RB:Once(callback:()->()) end
    
    function OnFoc_RB:Wait() end
TWindow['OnFocusLost']=OnFoc_RB
---@type RBXScriptSignal
--[[Запускается если окно закрыто(`.Opened=false`) ]]
    local OnClo_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClo_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnClo_RB:Once(callback:()->()) end
    
    function OnClo_RB:Wait() end
TWindow['OnClose']=OnClo_RB
---@type RBXScriptSignal
--[[Запускается если окно открыто(`.Opened=true`) ]]
    local OnOpe_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpe_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnOpe_RB:Once(callback:()->()) end
    
    function OnOpe_RB:Wait() end
TWindow['OnOpened']=OnOpe_RB
---@type RBXScriptSignal
--[[Запускается когда окно было подвинуто ]]
    local OnMov_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnMov_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnMov_RB:Once(callback:()->()) end
    
    function OnMov_RB:Wait() end
TWindow['OnMoved']=OnMov_RB
---@type RBXScriptSignal
--[[Запускается при фокусе окна(`.Focus=true`) ]]
    local OnFoc_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFoc_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFoc_RB:Once(callback:()->()) end
    
    function OnFoc_RB:Wait() end
TWindow['OnFocus']=OnFoc_RB
---@type Bind
--[[Специальный бинд для обновления размера окна. Работает как в Binder.WindowSizeRefresh ]]
    local Speci_Bind = {}
    ---@param callback fun(Window: TWindow)
    ---*return ()*
    function Speci_Bind:Bind(callback:(Window: TWindow)->()) end
    ---@param Window TWindow
    function Speci_Bind:Run(Window: TWindow) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(Window: TWindow)->()) end
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(Window: TWindow)->()) end
    ---@return TWindow Window
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TWindow['SpecialTWindowSizeRefresh']= Speci_Bind
---@type Bind
--[[Специальный бинд для анимации стрелочки скрытия. Работает как в Binder.TWindowHideArrowAnimation ]]
    local Speci_Bind = {}
    ---@param callback fun(Window: TWindow)
    ---*return ()*
    function Speci_Bind:Bind(callback:(Window: TWindow)->()) end
    ---@param Window TWindow
    function Speci_Bind:Run(Window: TWindow) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(Window: TWindow)->()) end
    ---@param callback fun(Window: TWindow)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(Window: TWindow)->()) end
    ---@return TWindow Window
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TWindow['SpecialHideArrowAnimation']= Speci_Bind