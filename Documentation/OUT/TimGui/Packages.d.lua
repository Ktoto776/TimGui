---@diagnostic disable: undefined-type
---@meta
---@class Packages : TClass
--[[Класс для импорта других пакетов ]]
Packages={}
--[[Запускает этот пакет, возвращая его данные ]]
---@param Name string Имя пакета
---@return any data Пакет
function Packages:Require(Name) end
--[[Возвращает сырой код пакета ]]
---@param Name string Имя пакета
---@return PackageData data Код пакета
function Packages:GetPackageData(Name) end
--[[Возвращает сырой код пакета ]]
---@param Name string Имя пакета
---@param dontUseCached? boolean Не возвращать кэшированные данные?
---@return string code Код пакета
function Packages:GetPackageRawCode(Name,dontUseCached) end