---@diagnostic disable: undefined-type
---@meta
---@class MenuItem : TClass
--[[Текст которое видит пользователь ]]
--*[ReadOnly]*
---@field Frame Frame
--[[Специальные цвета этого обьекта ]]
--*[ReadOnly]*
---@field SpecialColors SpecialColors
--[[Id menu элемента, устанавливается при создании и не меняется ]]
--*[ReadOnly]*
---@field Id number
--[[Меню которому принадлежит, можно менять на nil ]]
--*[Exception for WriteSameMode]*
---@field Parent Menu?
--[[Текст которое видит пользователь ]]
--*[ReadOnly]*
---@field Title TTranslator
--[[Видно ли этот обьект меню ]]
---@field Visible boolean
--[[X размер offset этой кнопки ]]
--*[ReadOnly]*
---@field XSizeOffset number
--[[Имя обьекта которое ставится при создании, нельзя менять ]]
--*[ReadOnly]*
---@field Name string
--[[Позиция Y этого обьекта, when changing `.Parent` it goes to the very bottom ]]
---@field Position number
--[[Максимальный размер X ]]
---@field MaxXSize UDim
--[[Предмет в Menu, используется в других классах ]]
MenuItem={}
--[[Обновляет размер и позици этого обьекта ]]
function MenuItem:RefreshSize() end
--[[Обновляет позицию этого обьекта(и всех в `.Parent`) ]]
function MenuItem:RefreshPosition() end
--[[Удаляет этот обьект ]]
function MenuItem:Destroy() end
---@type Bind
--[[Bind для установки размера обьекта. Работает как в Binder.MenuItemRefreshSizeBind ]]
    local Speci_Bind = {}
    ---@param callback fun(MenuItem: MenuItem)
    ---*return (XSizeOffset: number)*
    function Speci_Bind:Bind(callback:(MenuItem: MenuItem)->()) end
    ---@param MenuItem MenuItem
---@return number XSizeOffset
    function Speci_Bind:Run(MenuItem: MenuItem) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(MenuItem: MenuItem)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(MenuItem: MenuItem)->()) end
    ---@param callback fun(MenuItem: MenuItem)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(MenuItem: MenuItem)->()) end
    ---@return MenuItem MenuItem
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    MenuItem['SpecialRefreshSizeBind']= Speci_Bind
---@type Bind
--[[Bind для установки позиции обьекта. Работает как в Binder.MenuItemRefreshPositionBind ]]
    local Speci_Bind = {}
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---*return (lastYPos: UDim)*
    function Speci_Bind:Bind(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@param MenuItem MenuItem
---@param YPosition UDim
---@return UDim lastYPos
    function Speci_Bind:Run(MenuItem: MenuItem,YPosition: UDim) end

    local Speci_Bind_OnRun = {}
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Connect(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@param callback fun(MenuItem: MenuItem,YPosition: UDim)
    ---@return RBXScriptConnection
    function Speci_Bind_OnRun:Once(callback:(MenuItem: MenuItem,YPosition: UDim)->()) end
    ---@return MenuItem MenuItem
---@return UDim YPosition
    function Speci_Bind_OnRun:Wait() end
    Speci_Bind.OnRun = Speci_Bind_OnRun
    MenuItem['SpecialRefreshPositionBind']= Speci_Bind