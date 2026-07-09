---@diagnostic disable: undefined-type
---@meta
---@class Configs : TClass
--[[Окно конфигураций ]]
--*[ReadOnly]*
---@field Window TWindow
--[[Класс получения информации о конфигурациях(для действий с конфигурациями см. ControlCfg), чтобы получить или сохранить данные используй Saves/TScript ]]
Configs={}
--[[Возвращает название загруженого конфига ]]
---@return string name Имя загруженного конфига
function Configs:LoadedConfig() end
---@type RBXScriptSignal
--[[Запускается если конфигурация была сохранена/изменена ]]
    local OnCon_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnCon_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnCon_RB:Once(callback:()->()) end
    
    function OnCon_RB:Wait() end
Configs['OnConfigDataChanged']=OnCon_RB
---@type RBXScriptSignal
--[[Запускается если конфигурация была загружена ]]
    local OnLoa_RB = {}
    ---@param callback fun(Name?:string)
    ---@return RBXScriptConnection
    function OnLoa_RB:Connect(callback:(Name:string?)->()) end
    ---@param callback fun(Name?:string)
    ---@return RBXScriptConnection
    function OnLoa_RB:Once(callback:(Name:string?)->()) end
    ---@return string? Name
    function OnLoa_RB:Wait() end
Configs['OnLoaded']=OnLoa_RB