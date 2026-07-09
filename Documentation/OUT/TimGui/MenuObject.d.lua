---@diagnostic disable: undefined-type
---@meta
---@class MenuObject : TClass
--[[Основной Frame с menu items ]]
--*[ReadOnly]*
---@field MenuFrame Frame
--[[Максимальный X размер для всего MenuObject, при смене меняет MaxXSize всем children ]]
---@field MaxXSizeForMenu UDim
--[[Находится ли курсор в этом меню? ]]
---@field MouseOnThisMenu boolean
--[[Открыто ли меню, лучше использовать `:Open(Position: UDim2)`, иначе откроет там где и в прошлый раз ]]
---@field Opened boolean
--[[Размер меню ]]
---@field MenuSize UDim2
--[[Класс MenuObject,часть классов для меню (для создания самого меню или подменю). ]]
MenuObject={}
--[[Возращает детей этого MenuObject ]]
---@return table<number,MenuItem> result Дети
function MenuObject:GetChildren() end
--[[Открывает это меню ]]
---@param Position UDim2 Позиция в которой открыть это меню
function MenuObject:Open(Position) end
--[[Удаляет этот обьект ]]
function MenuObject:Destroy() end
--[[Создаёт MenuButton; С `.Parent` в этом меню ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return MenuButton item Обьект с `.Parent` в этом меню
function MenuObject:CreateMenuButton(Name,Title) end
--[[Ищет первого ребёнка по имени ]]
---@param Name string Имя ребёнка
---@return MenuItem child Первый ребёнок с этим именем
function MenuObject:FindFirstChild(Name) end
--[[Создаёт MenuText; С `.Parent` в этом меню ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return MenuText item Обьект с `.Parent` в этом меню
function MenuObject:CreateMenuText(Name,Title) end
--[[Обновляет позиции в меню ]]
function MenuObject:RefreshMenuPosition() end
--[[Создаёт MenuItem; С `.Parent` в этом меню ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return MenuItem item Обьект с `.Parent` в этом меню
function MenuObject:CreateMenuItem(Name,Title) end
--[[Обновляет размер меню ]]
function MenuObject:RefreshMenuSize() end
--[[Создаёт MenuToggle; С `.Parent` в этом меню ]]
---@param Name string Имя обьекта
---@param Title string | table<string,string> | TTranslator Заголовок обьекта
---@return MenuToggle item Обьект с `.Parent` в этом меню
function MenuObject:CreateMenuToggle(Name,Title) end
---@type RBXScriptSignal
--[[Запускается когда позиции обьектов в меню обновились ]]
    local MenuR_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function MenuR_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function MenuR_RB:Once(callback:()->()) end
    
    function MenuR_RB:Wait() end
MenuObject['MenuRefreshed']=MenuR_RB
---@type TSignal
--[[Запускается когда убран ребёнок ]]
    local Child_TS = {}
    ---@param callback fun(child:MenuItem)
    ---@return RBXScriptConnection
    function Child_TS:Connect(callback:(child:MenuItem)->()) end
    ---@param callback fun(child:MenuItem)
    ---@return RBXScriptConnection
    function Child_TS:Once(callback:(child:MenuItem)->()) end
    ---@return MenuItem child
    function Child_TS:Wait() end
MenuObject['ChildRemoved']=Child_TS
---@type TSignal
--[[Запускается когда добавлен новый ребёнок ]]
    local Child_TS = {}
    ---@param callback fun(child:MenuItem)
    ---@return RBXScriptConnection
    function Child_TS:Connect(callback:(child:MenuItem)->()) end
    ---@param callback fun(child:MenuItem)
    ---@return RBXScriptConnection
    function Child_TS:Once(callback:(child:MenuItem)->()) end
    ---@return MenuItem child
    function Child_TS:Wait() end
MenuObject['ChildAdded']=Child_TS
---@type RBXScriptSignal
--[[Запускается когда меню было отменено, тоесть последний клик был не по меню, из-за чего меню закрылось ]]
    local MenuC_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function MenuC_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function MenuC_RB:Once(callback:()->()) end
    
    function MenuC_RB:Wait() end
MenuObject['MenuCancelled']=MenuC_RB
---@type Bind
--[[Бинд для открытии(:Open(Position: UDim2)) ]]
    local OpenB_Bind = {}
    ---@param callback fun(Position: UDim2)
    ---*return ()*
    function OpenB_Bind:Bind(callback:(Position: UDim2)->()) end
    ---@param Position UDim2
    function OpenB_Bind:Run(Position: UDim2) end

    local OpenB_Bind_OnRun = {}
    ---@param callback fun(Position: UDim2)
    ---@return RBXScriptConnection
    function OpenB_Bind_OnRun:Connect(callback:(Position: UDim2)->()) end
    ---@param callback fun(Position: UDim2)
    ---@return RBXScriptConnection
    function OpenB_Bind_OnRun:Once(callback:(Position: UDim2)->()) end
    ---@return UDim2 Position
    function OpenB_Bind_OnRun:Wait() end
    OpenB_Bind.OnRun = OpenB_Bind_OnRun
    MenuObject['OpenBind']= OpenB_Bind