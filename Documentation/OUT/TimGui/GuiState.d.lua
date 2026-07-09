---@diagnostic disable: undefined-type
---@meta
---@class GuiState : TClass
--[[Служит для включения/выключения надписи при наводке на кнопку открытия ]]
---@field SayEnabled boolean
--[[За сколько секунд loading сделает круг. ]]
---@field LoadingSpeed number
--[[Активный статус: Error/Loading/None ]]
---@field ActiveState string
--[[Текст из переводчика который будет появляться при наводе если `SayEnabled==true` ]]
---@field Saying TTranslator
--[[Включено ли открытие? ]]
---@field OpenEnabled boolean
--[[Класс для изменения кнопки открытия в статус, например 'загрузка' или 'ошибка'(Блокирует открытие) ]]
GuiState={}
--[[Устанавливает статус на ошибку(ActiveStatus=`Error`) ]]
function GuiState:SetErrorState() end
--[[Устанавливает статус на загрузку(ActiveStatus=`Loading`) ]]
function GuiState:SetLoadingState() end
--[[Сбрасывает на значения по умолчанию(ActiveStatus=`None`,OpenEnabled=`true`) ]]
function GuiState:ResetToDefault() end
---@type RBXScriptSignal
--[[Запускается когда изменился статус через любой метод в классе ]]
    local onSta_RB = {}
    ---@param callback fun(arg:any)
    ---@return RBXScriptConnection
    function onSta_RB:Connect(callback:(arg:any)->()) end
    ---@param callback fun(arg:any)
    ---@return RBXScriptConnection
    function onSta_RB:Once(callback:(arg:any)->()) end
    ---@return any arg
    function onSta_RB:Wait() end
GuiState['onStateChanged']=onSta_RB