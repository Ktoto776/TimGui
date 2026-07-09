---@diagnostic disable: undefined-type
---@meta
---@class TToggle : GuiKeybindingObject : ButtonObject : TGuiObject : ConfigObject : TClass
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
---@param DoNotAnimate? boolean Не анимировать?(если `true`, резко установит цвет на нужный)
function TToggle:RefreshTextColorFromValue(DoNotAnimate) end
---@type RBXScriptSignal
--[[Запускается когда Value изменилось на `false` ]]
    local OnFal_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFal_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnFal_RB:Once(callback:()->()) end
    
    function OnFal_RB:Wait() end
TToggle['OnFalse']=OnFal_RB
---@type RBXScriptSignal
--[[Запускается когда Value изменилось на `true` ]]
    local OnTru_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnTru_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnTru_RB:Once(callback:()->()) end
    
    function OnTru_RB:Wait() end
TToggle['OnTrue']=OnTru_RB
---@type RBXScriptSignal
--[[Запускается когда Value изменилось ]]
    local Chang_RB = {}
    ---@param callback fun(Value:boolean)
    ---@return RBXScriptConnection
    function Chang_RB:Connect(callback:(Value:boolean)->()) end
    ---@param callback fun(Value:boolean)
    ---@return RBXScriptConnection
    function Chang_RB:Once(callback:(Value:boolean)->()) end
    ---@return boolean Value
    function Chang_RB:Wait() end
TToggle['Changed']=Chang_RB
---@type Bind
--[[Бинд для (анимации) цвета текста в зависимости от значения. Работает как в Binder.TextColorForToggle ]]
    local Speci_Bind = {}
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---*return ()*
    function Speci_Bind:Bind(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@param Toggle TToggle
---@param enableAnimation boolean
    function Speci_Bind:Run(Toggle: TToggle,enableAnimation: boolean) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@param callback fun(Toggle: TToggle,enableAnimation: boolean)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(Toggle: TToggle,enableAnimation: boolean)->()) end
    ---@return TToggle Toggle
---@return boolean enableAnimation
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TToggle['SpecialTextColorForToggle']= Speci_Bind