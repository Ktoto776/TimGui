---@diagnostic disable: undefined-type
---@meta
---@class TTranslator : Preset : TClass
--[[Русский вариант ]]
---@field ru any?
--[[Русский вариант ]]
---@field uk any?
--[[Английский вариант ]]
---@field en any?
--[[Класс для перевода variables, можно создать с помощью TClasses:CreateTranslator() ]]
TTranslator={}
--[[Получить переведённый вариант ]]
---@return any? response Переведённый вариант self[selectedLangCode]
function TTranslator:Translate() end
--[[Получает доступный нужный перевод текста ]]
---@return string langCode Код языка, например: ru; en; uk
function TTranslator:GetLangCode() end
---@type RBXScriptSignal
--[[Запускается когда изменился нужный перевод текста ]]
    local Trans_RB = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Trans_RB:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function Trans_RB:Once(callback:()->()) end
    
    function Trans_RB:Wait() end
TTranslator['TranslateValueChanged']=Trans_RB