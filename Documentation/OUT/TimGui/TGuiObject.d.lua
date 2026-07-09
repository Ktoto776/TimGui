---@diagnostic disable: undefined-type
---@meta
---@class TGuiObject : ConfigObject : TClass
--[[Frame в котором содержимое кнопки ]]
--*[ReadOnly]*
---@field Frame Frame
--[[Специальные цвета для этого обьекта ]]
--*[ReadOnly]*
---@field SpecialColors SpecialColors
--[[Отступ ]]
---@field Indent UDim2
--[[Скругление кнопки ]]
--*[ReadOnly]*
---@field UICorner UICorner
--[[Можно изменить сразу при создании(после `task.wait`) уже нельзя, по умолчанию ставится также через `task.wait()`, нужно для индефикации этого обьекта после перезахода(например конфигураций) ]]
---@field GlobalName string
--[[Если true, то этот обьект видим и с ним можно взаимодейсвовать ]]
---@field Visible boolean
--[[В какой группе/архитектуре находится, можно менять на nil. При смене появляется в самом низу группы ]]
---@field Parent GUIArchitecture?
--[[Включить ли изменение скругления(при изменении в GuiSize.ButtonCornerRadius). Для специального изменения на этой кнопке ]]
---@field CornerChangingEnabled boolean
--[[Позиция, становится самой нижней если Parent меняется ]]
---@field Position number
--[[Название кнопки, которое видит пользователь ]]
--*[ReadOnly]*
---@field Title TTranslator
--[[Тип обьекта(Здесь `unknown`, изменяется в других классах и становится только для чтения) ]]
---@field Type string
--[[Имя по которому его можно найти ]]
---@field Name string
--[[Меню этого обьекта ]]
--*[ReadOnly]*
---@field Menu Menu
--[[Класс обьекта TimGui, например группы/кнопки. Устанавливает ConfigSaveName по GlobalName и ставит только для чтения ]]
TGuiObject={}
--[[Открывает меню этого обьекта ]]
function TGuiObject:OpenMenu() end
--[[Обновляет размер, запуская специальный Bind(SizeBind) ]]
---@param dontRefreshPosition? boolean Не запускать ли обновление позиции
function TGuiObject:RefreshSize(dontRefreshPosition) end
--[[Возвращает глобальную группу в которой находится ]]
---@return GUIArchitecture? group Глобальная группа, если есть
function TGuiObject:GetGlobalGroup() end
---@type RBXScriptSignal
--[[Удаляет обьект и запускает Destroyed евент ]]
    local Destr_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destr_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Destr_RB:Once(callback:()->()) end
    
    function Destr_RB:Wait() end
TGuiObject['Destroyed']=Destr_RB
---@type Bind
--[[Специальный bind, Бинд для установки размера объектам. (работает по принципу из Binder.TObjectSize) ]]
    local Speci_Bind = {}
    ---@param callback fun(TGuiObject: TGuiObject)
    ---*return ()*
    function Speci_Bind:Bind(callback:(TGuiObject: TGuiObject)->()) end
    ---@param TGuiObject TGuiObject
    function Speci_Bind:Run(TGuiObject: TGuiObject) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(TGuiObject: TGuiObject)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(TGuiObject: TGuiObject)->()) end
    ---@param callback fun(TGuiObject: TGuiObject)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(TGuiObject: TGuiObject)->()) end
    ---@return TGuiObject TGuiObject
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TGuiObject['SpecialSizeBind']= Speci_Bind
---@type Bind
--[[Бинд для замены :OpenMenu() ]]
    local OpenM_Bind = {}
    ---@param callback fun()
    ---*return ()*
    function OpenM_Bind:Bind(callback:()->()) end
    
    function OpenM_Bind:Run() end

    local OpenM_Bind_OnRun = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OpenM_Bind_OnRun:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OpenM_Bind_OnRun:Once(callback:()->()) end
    
    function OpenM_Bind_OnRun:Wait() end
    OpenM_Bind.OnRun = OpenM_Bind_OnRun
    TGuiObject['OpenMenuBind']= OpenM_Bind
---@type Bind
--[[Специальный бинд для точной прорисовки видимости кнопки(если группа не открыта, не показывать. свойство Visible считается само), работает как в Binder.VisibleBind ]]
    local Speci_Bind = {}
    ---@param callback fun(Object: TGuiObject)
    ---*return ()*
    function Speci_Bind:Bind(callback:(Object: TGuiObject)->()) end
    ---@param Object TGuiObject
    function Speci_Bind:Run(Object: TGuiObject) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(Object: TGuiObject)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(Object: TGuiObject)->()) end
    ---@param callback fun(Object: TGuiObject)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(Object: TGuiObject)->()) end
    ---@return TGuiObject Object
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TGuiObject['SpecialVisibleBind']= Speci_Bind
---@type Bind
--[[Специальный бинд для подсчета позиции кнопки, работает как в Binder.ButtonPositionBind ]]
    local Speci_Bind = {}
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---*return (nextPos: UDim2)*
    function Speci_Bind:Bind(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@param child TGuiObject
---@param pos UDim2
---@return UDim2 nextPos
    function Speci_Bind:Run(child: TGuiObject,pos: UDim2) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@param callback fun(child: TGuiObject,pos: UDim2)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(child: TGuiObject,pos: UDim2)->()) end
    ---@return TGuiObject child
---@return UDim2 pos
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    TGuiObject['SpecialButtonPositionBind']= Speci_Bind