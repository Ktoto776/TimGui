--[[TPackage
    Version: 1.0;
    TimGuiVersion: 3.0.0;
    Description: A collection of functions that were not included in the main script.
]] ---@type TimGui
local TimGui = _G.TimGui
local BetterGUI = TimGui.Classes:CreateTClass()

-- Конвертирует значение в TTranslator
function BetterGUI:ConvertToTranslator(data)
    if data.__type~="TClass" then
        if type(data)=="table" then
            local Translator = TimGui.Classes:CreateTranslator(data.en or "...")
            Translator:Load(data) return Translator
        else return TimGui.Classes:CreateTranslator(tostring(data))
        end
    elseif data:IsA("TTranslator") then
        return data
    else return TimGui.Classes:CreateTranslator("...")
    end
end

return BetterGUI