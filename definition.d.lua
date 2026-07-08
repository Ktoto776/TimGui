---@diagnostic disable: undefined-type
---@meta

---@class Bind : TClass
--[[Bind, that is, a list of functions that are launched in turn and serve to replace functions from external scripts ]]
Bind={}
--[[Adds a function that is skipped and returns nil (i.e., if not nil, the following functions are not run) ]]
---@param callback fun(...) Function
---@return fun(...) callback Function
function Bind:Bind(callback) end
--[[Runs functions with the same parameters as Run(...) and returns what the running function returned ]]
function Bind:Run() end
---@type RBXScriptSignal
--[[Runs with Bind:Bind(...) ]]
OnBinded_RBXScriptSignal = {}
---@param callback fun()
---@return RBXScriptConnection
function OnBinded_RBXScriptSignal:Connect(callback:()->()) end
---@param callback fun()
---@return RBXScriptConnection
function OnBinded_RBXScriptSignal:Once(callback:()->()) end

function OnBinded_RBXScriptSignal:Wait() end
Bind['OnBinded']=OnBinded_RBXScriptSignal
---@type RBXScriptSignal
--[[Runs with Bind:Run(...), with the same parameters as in the function startup ]]
OnRun_RBXScriptSignal = {}
---@param callback fun()
---@return RBXScriptConnection
function OnRun_RBXScriptSignal:Connect(callback:()->()) end
---@param callback fun()
---@return RBXScriptConnection
function OnRun_RBXScriptSignal:Once(callback:()->()) end

function OnRun_RBXScriptSignal:Wait() end
Bind['OnRun']=OnRun_RBXScriptSignal

---@class GUIArchitecture : TClass
--[[This group is global? ]]
---@field GroupFrame Frame
--[[This group is global? ]]
---@field IsGlobal boolean
--[[Group size (Last point received when running :Refresh()) ]]
---@field GroupSize UDim2
--[[A class related to the global Interface Architecture. Children can be retrieved via This.ChildName (just like in Instance, and will throw an error if not found!) ]]
GUIArchitecture={}
--[[Will return the first child with this name ]]
---@param Name string Child name
---@param Title string | table<string,string> | Translator Title, can be Translator | table({'ru'='rus','en'='eng'}) | string?, if not, the object name is taken?
---@return string Name Child name
---@return string | table<string,string> | Translator Title Title, can be Translator | table({'ru'='rus','en'='eng'}) | string?, if not, the object name is taken
function GUIArchitecture:CreateGroup(Name,Title) end
--[[Updates the positions of objects in a group ]]
---@param FromObject TGuiObject Updates after and including this object. If missing, updates from start.?
---@param notParentRefreshing boolean Do I need to update Parent (if parent is a group and not TimGui.Groups)??
---@return TGuiObject FromObject Updates after and including this object. If missing, updates from start.
---@return boolean notParentRefreshing Do I need to update Parent (if parent is a group and not TimGui.Groups)?
function GUIArchitecture:RefreshGroup(FromObject,notParentRefreshing) end
--[[Will return the first child with this name ]]
---@param childName string Child name
---@return string childName Child name
function GUIArchitecture:FindFirstChild(childName) end
---@type RBXScriptSignal
--[[Fires when the architecture has been updated (i.e. when :RefreshGroup() has completed) ]]
GroupRefreshed_RBXScriptSignal = {}
---@param callback fun()
---@return RBXScriptConnection
function GroupRefreshed_RBXScriptSignal:Connect(callback:()->()) end
---@param callback fun()
---@return RBXScriptConnection
function GroupRefreshed_RBXScriptSignal:Once(callback:()->()) end

function GroupRefreshed_RBXScriptSignal:Wait() end
GUIArchitecture['GroupRefreshed']=GroupRefreshed_RBXScriptSignal
---@type TSignal
--[[Fires when the child is removed ]]
ChildRemoved_TSignal = {}
---@param callback fun(name:TGuiObject)
---@return RBXScriptConnection
function ChildRemoved_TSignal:Connect(callback:(name:TGuiObject)->()) end
---@param callback fun(name:TGuiObject)
---@return RBXScriptConnection
function ChildRemoved_TSignal:Once(callback:(name:TGuiObject)->()) end
---@return TGuiObject name
function ChildRemoved_TSignal:Wait() end
GUIArchitecture['ChildRemoved']=ChildRemoved_TSignal
---@type TSignal
--[[Fires when a new child is added. ]]
ChildAdded_TSignal = {}
---@param callback fun(name:TGuiObject)
---@return RBXScriptConnection
function ChildAdded_TSignal:Connect(callback:(name:TGuiObject)->()) end
---@param callback fun(name:TGuiObject)
---@return RBXScriptConnection
function ChildAdded_TSignal:Once(callback:(name:TGuiObject)->()) end
---@return TGuiObject name
function ChildAdded_TSignal:Wait() end
GUIArchitecture['ChildAdded']=ChildAdded_TSignal
---@type Bind
--[[A bind for updating button positions in a group. Works like Binder.RefreshingBind. ]]
SpecialRefreshingBind_Bind = {}
---@param callback fun(Children: table,FromObject: TGuiObject)
---*return (EndPoint: UDim2)*
function SpecialRefreshingBind_Bind:Bind(callback:(Children: table,FromObject: TGuiObject)->()) end
---@param Children table<number,TGuiObject>
---@param FromObject TGuiObject
---@return UDim2 EndPoint
function SpecialRefreshingBind_Bind:Run(Children: table,FromObject: TGuiObject) end

SpecialRefreshingBind_Bind_OnRun = {}
---@param callback fun(Children: table,FromObject: TGuiObject)
---@return RBXScriptConnection
function SpecialRefreshingBind_Bind_OnRun:Connect(callback:(Children: table,FromObject: TGuiObject)->()) end
---@param callback fun(Children: table,FromObject: TGuiObject)
---@return RBXScriptConnection
function SpecialRefreshingBind_Bind_OnRun:Once(callback:(Children: table,FromObject: TGuiObject)->()) end
---@return table<number,TGuiObject> Children
---@return TGuiObject FromObject
function SpecialRefreshingBind_Bind_OnRun:Wait() end
SpecialRefreshingBind_Bind.OnRun = SpecialRefreshingBind_Bind_OnRun
GUIArchitecture['SpecialRefreshingBind']= SpecialRefreshingBind_Bind

---@class Header : TClass
--[[First part of the Name ]]
--*[ReadOnly]*
---@field FirstName Translator
--[[Separator width (can be 0 or less) ]]
---@field SeparatorSize number
--[[Header information (default: time). If not a string, it is converted to a string. Listeners: 1-clock, 2-fps ]]
--*[ReadOnly]*
---@field InfoValue ValueBinder
--[[Second part of the Name ]]
--*[ReadOnly]*
---@field SecondName Translator
--[[Class for customizing the header ]]
Header={}

---@class Example : TClass
--[[Standard preset, no separate functions for saving it. ]]
---@field Default table
--[[Preset name, default 'Default' ]]
---@field PresetName string
--[[Example class ]]
Preset={}
--[[Update preset ]]
---@param Preset table The table with values(the value can be an array with [type,...] - an alternative for preserving types from rb), if any, runs :Load()?
---@return table Preset The table with values(the value can be an array with [type,...] - an alternative for preserving types from rb), if any, runs :Load()
function Preset:Refresh(Preset) end
--[[Load preset ]]
---@param Preset table The table with values(the value can be an array with [type,...] - an alternative for preserving types from rb), if any, runs :Load()
---@return table Preset The table with values(the value can be an array with [type,...] - an alternative for preserving types from rb), if any, runs :Load()
function Preset:Load(Preset) end
--[[Gets all values in a preset ]]
---@param dontUseRBXValues boolean If true, it returns a table with data (if the type is from Roblox, it will become an array [type,...])
---@return boolean dontUseRBXValues If true, it returns a table with data (if the type is from Roblox, it will become an array [type,...])
function Preset:GetPreset(dontUseRBXValues) end
---@type RBXScriptSignal
--[[Fired on Preset:Refresh() or Preset:Load() ]]
OnRefresh_RBXScriptSignal = {}
---@param callback fun()
---@return RBXScriptConnection
function OnRefresh_RBXScriptSignal:Connect(callback:()->()) end
---@param callback fun()
---@return RBXScriptConnection
function OnRefresh_RBXScriptSignal:Once(callback:()->()) end

function OnRefresh_RBXScriptSignal:Wait() end
Preset['OnRefresh']=OnRefresh_RBXScriptSignal

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
---@param callback fun(PropertyName:string)
---@return RBXScriptConnection
function OnPropertyChanged_RBXScriptSignal:Connect(callback:(PropertyName:string)->()) end
---@param callback fun(PropertyName:string)
---@return RBXScriptConnection
function OnPropertyChanged_RBXScriptSignal:Once(callback:(PropertyName:string)->()) end
---@return string PropertyName
function OnPropertyChanged_RBXScriptSignal:Wait() end
TClass['OnPropertyChanged']=OnPropertyChanged_RBXScriptSignal

---@class TEvent
--[[BindableEvent, which is used to implement :Fire() waits ]]
---@field BEvent BindableEvent
--[[Array with latest args *New version .Args* ]]
---@field args table
--[[A table with arrays, with the last args {[number]={...}}. Disappears 1 second after launch. ]]
---@field Args table
--[[A custom Event like Bindable Event to pass timgui types without errors (if you don't encounter stupid errors like with table.clone, then use the built-in BindableEvent) ]]
TEvent={}
--[[Runs with any parameters passed to .Event ]]
function TEvent:Fire() end
---@type TSignal
--[[The main signal of this TEvent, triggered via :Fire(...), with parameters ... taken from :Fire ]]
Event_TSignal = {}
---@param callback fun()
---@return RBXScriptConnection
function Event_TSignal:Connect(callback:()->()) end
---@param callback fun()
---@return RBXScriptConnection
function Event_TSignal:Once(callback:()->()) end

function Event_TSignal:Wait() end
TEvent['Event']=Event_TSignal

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
---@field LanguagesPreference table<number,string>
--[[The main object of the ENTIRE TGui system. Can be accessed using _G.TimGui ]]
TimGui={}
--[[Gets data from the internet. If it starts with './', it gets it from the script directory. ]]
---@param URL string Link to receive.?
---@return string URL Link to receive.
function TimGui:HttpGet(URL) end
--[[Changes language preferences ]]
---@param langCodes table<number,string> An array of language preferences, for example: ["en","uk","ru",...]
---@return table<number,string> langCodes An array of language preferences, for example: ["en","uk","ru",...]
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
---@param callback fun(isOpened:boolean)
---@return RBXScriptConnection
function OnOpened_RBXScriptSignal:Connect(callback:(isOpened:boolean)->()) end
---@param callback fun(isOpened:boolean)
---@return RBXScriptConnection
function OnOpened_RBXScriptSignal:Once(callback:(isOpened:boolean)->()) end
---@return boolean isOpened
function OnOpened_RBXScriptSignal:Wait() end
TimGui['OnOpened']=OnOpened_RBXScriptSignal
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
TimGui['OnExit']=OnExit_RBXScriptSignal
---@type RBXScriptSignal
--[[Runs if language preferences have changed ]]
LanguageChanged_RBXScriptSignal = {}
---@param callback fun(langCodes:table)
---@return RBXScriptConnection
function LanguageChanged_RBXScriptSignal:Connect(callback:(langCodes:table)->()) end
---@param callback fun(langCodes:table)
---@return RBXScriptConnection
function LanguageChanged_RBXScriptSignal:Once(callback:(langCodes:table)->()) end
---@return table<number,string> langCodes
function LanguageChanged_RBXScriptSignal:Wait() end
TimGui['LanguageChanged']=LanguageChanged_RBXScriptSignal

---@class TKey : TClass
--[[It's keyboard key? ]]
--*[ReadOnly]*
---@field IsKeyboardKey boolean
--[[It's mouse button? ]]
--*[ReadOnly]*
---@field IsMouseKey boolean
--[[Full key name, for example: LeftCTRL + T ]]
---@field Name string
--[[KeyCode for this keyboard key ]]
---@field KeyCode Enum.KeyCode
--[[Table with holding keys, for example {LeftCTRL=true,LeftShift=false} ]]
---@field Holding table
--[[TKey is empty?(if true, this tkey is not keyboard key and not mouse button) ]]
--*[ReadOnly]*
---@field IsEmpty boolean
--[[Number of mouse button(if this is not mouse button = 0), working also how roblox. 1-Left, 2-Right, 3-Middle ]]
---@field MouseKey number
--[[Key name, for example: A/1/KEnter/K1(K1 - Keypad One)/LeftMB(LeftMB-Left Mouse Button) ]]
---@field KeyName string
--[[Class - key, and need for getting pressed button ]]
TKey={}

---@class Translator : TClass : Preset
--[[English version ]]
---@field en any?
--[[Ukrainian version ]]
---@field uk any?
--[[Russian version ]]
---@field ru any?
--[[A class for translating variables, can be created using TClasses:CreateTranslator() ]]
Translator={}
--[[Get a translated version ]]
function Translator:Translate() end
--[[Gets the required translation of the text available ]]
function Translator:GetLangCode() end
---@type RBXScriptSignal
--[[Launched when the required text translation has changed ]]
TranslateValueChanged_RBXScriptSignal = {}
---@param callback fun()
---@return RBXScriptConnection
function TranslateValueChanged_RBXScriptSignal:Connect(callback:()->()) end
---@param callback fun()
---@return RBXScriptConnection
function TranslateValueChanged_RBXScriptSignal:Once(callback:()->()) end

function TranslateValueChanged_RBXScriptSignal:Wait() end
Translator['TranslateValueChanged']=TranslateValueChanged_RBXScriptSignal

---@class TSignal
--[[You can create your own from TEvent(Classes:CreateTEvent()) ]]
TSignal={}
--[[ ]]
function TSignal:Once() end
--[[ ]]
function TSignal:Wait() end
--[[ ]]
function TSignal:Connect() end

---@class ValueBind : TClass
--[[Value, but with translation, changes .Value if the desired translation has been changed ]]
---@field Translator Translator
--[[Id of this ValueBind ]]
---@field Id number
--[[ValueBinder to which this VBind belongs ]]
--*[Exception for WriteSameMode]*
---@field Parent ValueBinder
--[[Value, can be changed from .Translator ]]
--*[Exception for WriteSameMode]*
---@field Value any
--[[Is the bind enabled (that is, is it being listened)? ]]
---@field Enabled boolean
--[[A value binder used in ValueBinder ]]
ValueBind={}
---@type RBXScriptSignal
--[[Fires if Binder is no longer listening to this Bind ]]
OnDisabled_RBXScriptSignal = {}
---@param callback fun()
---@return RBXScriptConnection
function OnDisabled_RBXScriptSignal:Connect(callback:()->()) end
---@param callback fun()
---@return RBXScriptConnection
function OnDisabled_RBXScriptSignal:Once(callback:()->()) end

function OnDisabled_RBXScriptSignal:Wait() end
ValueBind['OnDisabled']=OnDisabled_RBXScriptSignal
---@type RBXScriptSignal
--[[Fires if ValueBinder is listening to this Bind ]]
OnEnabled_RBXScriptSignal = {}
---@param callback fun()
---@return RBXScriptConnection
function OnEnabled_RBXScriptSignal:Connect(callback:()->()) end
---@param callback fun()
---@return RBXScriptConnection
function OnEnabled_RBXScriptSignal:Once(callback:()->()) end

function OnEnabled_RBXScriptSignal:Wait() end
ValueBind['OnEnabled']=OnEnabled_RBXScriptSignal

---@class ValueBinder : TClass
--[[The value can be changed directly, but it is not recommended. ]]
--*[Exception for WriteSameMode]*
---@field Value any
--[[The Id of the ValueBind being listened to; its values will be in .Value. Defaults to 0 (if it doesn't exist, then the default value). ]]
---@field ListenId number
--[[A value binder used to prevent values from overlapping. Created via TClasses:CreateValueBinder(Default Value) ]]
ValueBinder={}
--[[Creates a ValueBind to set a value ]]
---@param TurnOnListing boolean Set to listening (if none, then it is considered true)?
---@return boolean TurnOnListing Set to listening (if none, then it is considered true)
function ValueBinder:Bind(TurnOnListing) end
---@type RBXScriptSignal
--[[Runs when ValueBinder:Bind is started. ]]
OnBinded_RBXScriptSignal = {}
---@param callback fun(Id:number)
---@return RBXScriptConnection
function OnBinded_RBXScriptSignal:Connect(callback:(Id:number)->()) end
---@param callback fun(Id:number)
---@return RBXScriptConnection
function OnBinded_RBXScriptSignal:Once(callback:(Id:number)->()) end
---@return number Id
function OnBinded_RBXScriptSignal:Wait() end
ValueBinder['OnBinded']=OnBinded_RBXScriptSignal