---@diagnostic disable: undefined-type
---@meta
---@class PackageData : TClass
--[[Сырые данные пакета, если это не TPacket то будут '' ]]
--*[ReadOnly]*
---@field RawData string
--[[Это TPacket? ]]
--*[ReadOnly]*
---@field IsPackage string
--[[Сырой код пакета ]]
--*[ReadOnly]*
---@field Code string
--[[Данные пакета ]]
PackageData={}
--[[Возвращает данные пакета ]]
---@return table<number,string> Data Таблица с данными из пакета
function PackageData:GetData() end