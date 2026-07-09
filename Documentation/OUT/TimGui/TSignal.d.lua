---@diagnostic disable: undefined-type
---@meta
---@class TSignal
--[[Можно создать свой из TEvent(Classes:CreateTEvent()) ]]
TSignal={}
--[[ ]]
---@return RBXScriptConnection Connection 
function TSignal:Once() end
--[[ ]]
---@return RBXScriptConnection Connection 
function TSignal:Connect() end
--[[ ]]
function TSignal:Wait() end