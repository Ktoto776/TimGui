---@diagnostic disable: undefined-type
---@meta
---@class GUIArchitecture : TClass
--[[Frame с кнопками в группе,canChange: true, но false в TimGui.Groups ]]
---@field GroupFrame Frame
--[[Размер группы(Последняя полученная точка при запуске :Refresh()) ]]
---@field GroupSize UDim2
--[[Глобальная ли группа ]]
---@field IsGlobal boolean
--[[Класс относящийся к глобальной Архитектуре интерфейса. Можно получать детей через This.ChildName(также как в Instance и выдаст ошибку если не найдено!) ]]
GUIArchitecture={}
--[[Создаст группу в этой архитектуре ]]
---@param Name string Имя группы
---@param Title? string | table<string,string> | TTranslator Заголовок, может быть TTranslator | table({'ru'='rus','en'='eng'}) | string?, если нету берётся название обьекта
---@return TGroup child Созданная группа, принадлежащая этой архитектуре
function GUIArchitecture:CreateGroup(Name,Title) end
--[[Вернёт первого ребёнка с таким именем ]]
---@param childName string Имя ребёнка
---@return TGuiObject? child Ребёнок, если не найден - nil
function GUIArchitecture:FindFirstChild(childName) end
--[[Обновляет позиции объектов в группе ]]
---@param FromObject? TGuiObject Обновляет после и включая этот обьект. Если отсутствует, то обновляет со старта
---@param notParentRefreshing? boolean Нужно ли обновлять Parent(если parent группа и не TimGui.Groups)
function GUIArchitecture:RefreshGroup(FromObject,notParentRefreshing) end
---@type TSignal
--[[Запускается когда убран ребёнок ]]
    local Child_TS = {}
    ---@param callback fun(name:TGuiObject)
    ---@return RBXScriptConnection
    function Child_TS:Connect(callback:(name:TGuiObject)->()) end
    ---@param callback fun(name:TGuiObject)
    ---@return RBXScriptConnection
    function Child_TS:Once(callback:(name:TGuiObject)->()) end
    ---@return TGuiObject name
    function Child_TS:Wait() end
GUIArchitecture['ChildRemoved']=Child_TS
---@type RBXScriptSignal
--[[Запускается когда архитекртура обновилась(тоесть когда :RefreshGroup() был закончен) ]]
    local Group_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Group_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Group_RB:Once(callback:()->()) end
    
    function Group_RB:Wait() end
GUIArchitecture['GroupRefreshed']=Group_RB
---@type TSignal
--[[Запускается когда добавлен новый ребёнок ]]
    local Child_TS = {}
    ---@param callback fun(name:TGuiObject)
    ---@return RBXScriptConnection
    function Child_TS:Connect(callback:(name:TGuiObject)->()) end
    ---@param callback fun(name:TGuiObject)
    ---@return RBXScriptConnection
    function Child_TS:Once(callback:(name:TGuiObject)->()) end
    ---@return TGuiObject name
    function Child_TS:Wait() end
GUIArchitecture['ChildAdded']=Child_TS
---@type Bind
--[[Бинд для обновления позиций кнопок в группе. Работает как в Binder.RefreshingBind ]]
    local Speci_Bind = {}
    ---@param callback fun(Children: table,FromObject: TGuiObject)
    ---*return (EndPoint: UDim2)*
    function Speci_Bind:Bind(callback:(Children: table,FromObject: TGuiObject)->()) end
    ---@param Children table<number,TGuiObject>
---@param FromObject TGuiObject
---@return UDim2 EndPoint
    function Speci_Bind:Run(Children: table,FromObject: TGuiObject) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(Children: table,FromObject: TGuiObject)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(Children: table,FromObject: TGuiObject)->()) end
    ---@param callback fun(Children: table,FromObject: TGuiObject)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(Children: table,FromObject: TGuiObject)->()) end
    ---@return table<number,TGuiObject> Children
---@return TGuiObject FromObject
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    GUIArchitecture['SpecialRefreshingBind']= Speci_Bind