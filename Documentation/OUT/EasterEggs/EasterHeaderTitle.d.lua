---О! Ты чтоле новые пасхалки решил сделать? XD
---@diagnostic disable: undefined-type
---@meta
---@class EasterHeaderTitle : TClass
--[[Шанс на выпадение именно этого заголовка, где 100 - обычный. ]]
---@field Chance number
--[[Вторая часть заголовка ]]
--*[ReadOnly]*
---@field SecondPart TTranslator
--[[Название этой пасхалки, которое должно быть уникально ]]
--*[ReadOnly]*
---@field Id string
--[[Первая часть заголовка ]]
--*[ReadOnly]*
---@field FirstPart TTranslator
--[[Пасхалка-заголовок ]]
EasterHeaderTitle={}
---@type RBXScriptSignal
--[[Запускается если была выбрана эта пасхалка ]]
    local OnSel_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnSel_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnSel_RB:Once(callback:()->()) end
    
    function OnSel_RB:Wait() end
EasterHeaderTitle['OnSelected']=OnSel_RB