---О! Ты чтоле новые пасхалки решил сделать? XD
---@diagnostic disable: undefined-type
---@meta
---@class EasterEggs : TClass
--[[Загружены ли стандартные пасхалки? ]]
---@field DefaultIsLoaded boolean
--[[Класс для создания пасхалок ]]
EasterEggs={}
--[[Создаёт пасхалку заголовка ]]
---@param Id string Id этой пасхалки
---@return EasterHeaderTitle EHT Пасхалка-заголовок
function EasterEggs:CreateHeaderTitle(Id) end