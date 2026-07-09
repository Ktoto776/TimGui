---@diagnostic disable: undefined-type
---@meta
---@class Prompt : TWindow : ConfigObject : TClass
--[[Ожидает ли :Run() результата? ]]
---@field Running boolean
--[[Тип промта, устанавливается значение из PromptType при запуске TClasses:CreatePrompt(...). Или назначеное по стандарту в других методах ]]
--*[ReadOnly]*
---@field Type string
--[[Класс Prompt. Часть других промтов. .CanHide обычно false, а также устанавливает DisplayOrder на 2 ]]
Prompt={}
--[[Запускает Prompt, спрашивая что либо у пользователя. Выходных данных может и не быть, если запрос отменён. Отменяет предыдущий запрос, если он всё ещё действует ]]
function Prompt:Run() end
--[[Эмулирует ввод данных от пользователя, если параметров нет - отмена. ]]
function Prompt:EmulateInput() end
---@type TSignal
--[[Запускается после Input сигнала, когда :Run(...) был запущен. И передаёт те же параметры как при запуске :Run(...). ]]
    local RunSt_TS = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function RunSt_TS:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function RunSt_TS:Once(callback:()->()) end
    
    function RunSt_TS:Wait() end
Prompt['RunStopped']=RunSt_TS
---@type TSignal
--[[Запускается после запуска :Run(...) с переданными параметрами. ]]
    local OnRun_TS = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRun_TS:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnRun_TS:Once(callback:()->()) end
    
    function OnRun_TS:Wait() end
Prompt['OnRunned']=OnRun_TS
---@type TSignal
--[[Запускается если произошёл Input или был запущен :EmulateInput(...). С любыми параметрами, которых может не быть при отмене ]]
    local OnInp_TS = {}
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnInp_TS:Connect(callback:()->()) end
    ---@param callback fun()
    ---@return RBXScriptConnection
    function OnInp_TS:Once(callback:()->()) end
    
    function OnInp_TS:Wait() end
Prompt['OnInput']=OnInp_TS