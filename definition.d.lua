---@meta

---@class TClass
--[[Example class ]]
TClass={}
--[[Compares the class name with 1 parameter ]]
function TClass:GetClassNames() end
--[[Returns whether the property is read-only. ]]
---@param propertyName string Property name
---@return string propertyName Property name
function TClass:GetReadOnly(propertyName) end
--[[Sets the property to read-only. ]]
---@param propertyName string Property name
---@return string propertyName Property name
function TClass:SetReadOnly(propertyName) end
--[[Add class name ]]
---@param className string Class name
---@return string className Class name
function TClass:AddClassName(className) end
--[[Compares the class name with 1 parameter ]]
---@param className string Name of the class to compare
---@return string className Name of the class to compare
function TClass:IsA(className) end
--[[An event that is triggered when a property changes ]]
---@param propertyName string Property name
---@return string propertyName Property name
function TClass:GetPropertyChangedEvent(propertyName) end
---@type RBXScriptSignal
--[[Fired if the value has been changed ]]
OnPropertyChanged_RBXScriptSignal = {}
---@param callback fun(PropertyName: string)
---@return RBXScriptConnection
function OnPropertyChanged_RBXScriptSignal:Connect(callback:(PropertyName: string)->()) end
---@param callback fun(PropertyName: string)
---@return RBXScriptConnection
function OnPropertyChanged_RBXScriptSignal:Once(callback:(PropertyName: string)->()) end
---@return string PropertyName
function OnPropertyChanged_RBXScriptSignal:Wait() end
TClass.OnPropertyChanged=OnPropertyChanged_RBXScriptSignal

---@class TimGui
--[[The current version of TGui. For example, 1 ]]
--*[ReadOnly]*
---@field BuildCount number
--[[The current TGui core version in string format. For example, 3.0.0 ]]
--*[ReadOnly]*
---@field CoreVersion string
--[[ScreenGui containing the menu (must be on top of the main ScreenGui) ]]
--*[ReadOnly]*
---@field MenuScreenGui ScreenGui
--[[Was :Exit() run, i.e. was TimGui closed? ]]
--*[ReadOnly]*
---@field Closed boolean
--[[The current TGui version in string format. For example, 1.0.0 ]]
--*[ReadOnly]*
---@field Version string
--[[When TimGui starts, the data is transferred to _G.Setup, more details in TimGuiSetupObject ]]
--*[ReadOnly]*
---@field SetupData table
--[[TimGui main gui ]]
--*[ReadOnly]*
---@field ScreenGui ScreenGui
--[[Is the GUI open? If false, it's collapsed. ]]
---@field Opened boolean
--[[The current version of TGui core. For example, 1 ]]
--*[ReadOnly]*
---@field CoreBuildCount number
--[[Is httpGet_BaseDir local or not? ]]
--*[ReadOnly]*
---@field httpGet_BaseDirIsLocal boolean
--[[The directory where the TGui files are located (https Link or locally, can be determined via httpGet_BaseDirIsLocal) ]]
--*[ReadOnly]*
---@field httpGet_BaseDir string
--[[An array of language preferences, for example: ["en","uk","ru",...] ]]
---@field LanguagesPreference table
--[[The main object of the ENTIRE TGui system. Can be accessed using _G.TimGui ]]
TimGui={}
--[[Gets data from the internet. If it starts with './', it gets it from the script directory. ]]
---@param URL string Link to receive.?
---@return string URL Link to receive.
function TimGui:HttpGet(URL) end
--[[Changes language preferences ]]
---@param langCodes table An array of language preferences, for example: ["en","uk","ru",...]
---@return table langCodes An array of language preferences, for example: ["en","uk","ru",...]
function TimGui:SetLanguagePreferences(langCodes) end
--[[Returns the TimGui position for the selected state ]]
---@param Opened boolean The desired state (whether it is open). If nil, then gets the value for the current state.?
---@return boolean Opened The desired state (whether it is open). If nil, then gets the value for the current state.
function TimGui:GetFrameGuiPosition(Opened) end
--[[Compares the class name with 1 parameter ]]
---@param className string Name of the class to compare
---@return string className Name of the class to compare
function TimGui:IsA(className) end
--[[Closes TimGui (exits) and runs the .OnExit event ]]
function TimGui:Exit() end
---@type RBXScriptSignal
--[[Runs if TimGui.Opened has changed ]]
OnOpened_RBXScriptSignal = {}
---@param callback fun(isOpened: boolean)
---@return RBXScriptConnection
function OnOpened_RBXScriptSignal:Connect(callback:(isOpened: boolean)->()) end
---@param callback fun(isOpened: boolean)
---@return RBXScriptConnection
function OnOpened_RBXScriptSignal:Once(callback:(isOpened: boolean)->()) end
---@return boolean isOpened
function OnOpened_RBXScriptSignal:Wait() end
TimGui.OnOpened=OnOpened_RBXScriptSignal
---@type RBXScriptSignal
--[[Runs if TimGui:Exit() is running to close the GUI. ]]
OnExit_RBXScriptSignal = {}
---@param callback fun()
---@return RBXScriptConnection
function OnExit_RBXScriptSignal:Connect(callback:()->()) end
---@param callback fun()
---@return RBXScriptConnection
function OnExit_RBXScriptSignal:Once(callback:()->()) end

function OnExit_RBXScriptSignal:Wait() end
TimGui.OnExit=OnExit_RBXScriptSignal
---@type RBXScriptSignal
--[[Runs if language preferences have changed ]]
LanguageChanged_RBXScriptSignal = {}
---@param callback fun(langCodes: table)
---@return RBXScriptConnection
function LanguageChanged_RBXScriptSignal:Connect(callback:(langCodes: table)->()) end
---@param callback fun(langCodes: table)
---@return RBXScriptConnection
function LanguageChanged_RBXScriptSignal:Once(callback:(langCodes: table)->()) end
---@return table langCodes
function LanguageChanged_RBXScriptSignal:Wait() end
TimGui.LanguageChanged=LanguageChanged_RBXScriptSignal

---@class TSignal
--[[You can create your own from TEvent(Classes:CreateTEvent()) ]]
TSignal={}
--[[ ]]
function TSignal:Once() end
--[[ ]]
function TSignal:Wait() end
--[[ ]]
function TSignal:Connect() end