-- Settings -----
local SupportedLanguages = {
    en="English",
    ru="Русский [Russian]",
    uk="Українська [Ukrainian]"
} -- Configs -------------
local DefaultConfig = {
    Settings={
        AutoSaveKeybinds=true,
        AutoSaveValues=true,
        AutoSaveWindows=true,
        SaveWindows=true,
        SaveKeybinds=true
    },
    Objects={},
    Saves={},
    ScriptSaves={},
    Keybinds={
        Keybinders={},
        Keybinds={}
    }
} local config = table.clone(DefaultConfig)
local onConfigChanged = Instance.new("BindableEvent")
local onLoadConfigEvent = Instance.new("BindableEvent")
local onConfigSettingsChanged = Instance.new("BindableEvent")
-- Removing previous instance
if _G.TimGui~=nil then
    if type(_G.TimGui)=="table" then
        warn("Removing previous instance")
        if type(_G.TimGui.Exit)=="function" then
            _G.TimGui:Exit()
            else if _G.TimGui.ScreenGui then
                _G.TimGui.ScreenGui:Destroy()
            end if _G.TimGui.MenuScreenGui then
                _G.TimGui.MenuScreenGui:Destroy()
            end
        end
    else _G.TimGui = nil
    end
end
-- CODE
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LocalMouse = LocalPlayer:GetMouse()
local TimGuiRaw = {
    CoreVersion="3.0.0",
    CoreBuildCount=1,
} -- #FIND_POINT ClassMetatables --
local function GetClassMetatable(className:string,rawTable:{any},readOnly:{string}?,writeSameMode:boolean?,meta:{any}?,onPropertyChange:(key:any,old:any,new:any)->(),writeSameModeExclude:{any}?)
    if not writeSameModeExclude then writeSameModeExclude = {} end
    if not readOnly then readOnly = {} end
    local resMeta = {
        __type=className,
        __iter=function(t)
            local pair = pairs(rawTable)
            return pair,rawTable,nil
        end, __newindex=function(t,k,v)
            if v==rawTable[k] then return end
            if rawTable[k]~=nil then
                if table.find(readOnly,k) then
                    error("The value '"..k.."' is read only of class: '"..(rawTable.ClassName or className).."'. You can't change it.")
                else if writeSameMode and not table.find(writeSameModeExclude,k) then
                        local neededType = typeof(rawTable[k])
                        if neededType=="function" then
                            error("The value '"..k.."' is a function(Method) of class: '"..(rawTable.ClassName or className).."'. You can't change it.")
                        else
                            local thistype = typeof(v)
                            if thistype~=neededType then
                                error("The value '"..k.."' is a different type("..thistype.." is not "..neededType..") of class: '"..(rawTable.ClassName or className).."'. You can't change it.")
                            end
                        end
                    end
                end
            end local old = rawTable[k]
            rawTable[k] = v
            if type(onPropertyChange)=="function" then
                onPropertyChange(k,old,v)
            end
        end, __index=function(t,k)
            if k=="__type" then return className end
            if k=="__have_timgui_metatable" then return className end
            return rawTable[k]
        end
    } if type(meta)=="table" then
        for k,v in meta do
            resMeta[k] = v
        end
    end return setmetatable({},resMeta),resMeta
end
-- #FIND_POINT MAIN
local OnExitEvent = Instance.new("BindableEvent")
local TimGuiReadOnly = {"SetupData","CoreVersion","CoreBuildCount"}
local onOpenedEvent = Instance.new("BindableEvent")
TimGui = GetClassMetatable("TimGui",TimGuiRaw,TimGuiReadOnly,true,nil,function(key, _, new)
    if key=="Opened" then
        onOpenedEvent:Fire(new)
    end
end) TimGui.OnOpened = onOpenedEvent.Event
table.insert(TimGuiReadOnly,"OnOpened")
TimGui.OnExit = OnExitEvent.Event
table.insert(TimGuiReadOnly,"OnExit")
TimGui.Closed = false
table.insert(TimGuiReadOnly,"Closed")
function TimGui:Exit()
    TimGuiRaw.Closed = true
    OnExitEvent:Fire()
    _G.TimGui = nil
end function TimGui:IsA(class:string)
    return class=="TimGui"
end TimGui.SetupData = _G.Setup or {}
TimGui.Opened = false
_G.Setup = nil
_G.TimGui = TimGui
local onLanguageChanged = Instance.new("BindableEvent")
TimGui.LanguageChanged = onLanguageChanged.Event
table.insert(TimGuiReadOnly,"LanguageChanged")
if type(TimGui.SetupData.LanguagePreferences)=="table" then
    TimGui.LanguagePreferences = TimGui.SetupData.LanguagePreferences
else TimGui.LanguagePreferences = {"en","ru"}
end table.insert(TimGuiReadOnly,"LanguagePreferences")
function TimGui:SetLanguagePreferences(Langs:{string})
    if type(Langs)~="table" then error("LanguagePreference is incorrect! Expected array.") end
    if TimGui.Closed then return end
    local LangsP = {}
    for _,v in Langs do
        if SupportedLanguages[v] then
            table.insert(LangsP,v)
        end
    end for k,_ in SupportedLanguages do
        if not table.find(LangsP,k) then
            table.insert(LangsP,k)
        end
    end TimGuiRaw.LanguagePreferences = LangsP
    onLanguageChanged:Fire(LangsP)
end
-- #FIND_POINT HttpGet
local HttpGet = TimGuiRaw.SetupData.HttpGet
TimGui.httpGet_BaseDir = TimGui.SetupData.linkToDir or "https://raw.githubusercontent.com/Ktoto776/TimGUI/main/"
TimGui.httpGet_BaseDirIsLocal = not (string.find(TimGui.httpGet_BaseDir,"http") and string.find(TimGui.httpGet_BaseDir,"://"))
table.insert(TimGuiReadOnly,"httpGet_BaseDirIsLocal")
table.insert(TimGuiReadOnly,"httpGet_BaseDir")
if type(HttpGet)~="function" then
    function HttpGet(URL:string)
        local isLocal = string.sub(URL,1,2)=="./"
        if isLocal then
            local path = TimGui.httpGet_BaseDir..string.sub(URL,3)
            if TimGui.httpGet_BaseDirIsLocal then
                return readfile(path)
            else return game:HttpGet(path)
            end
        else return game:HttpGet(URL)
        end
    end
end function TimGui:HttpGet(URL:string)
    if type(URL)~="string" then error("URL is incorrect") end
    return HttpGet(URL)
end
-- #FIND_POINT Logger
local LoggersReadOnly = {"Log"}
local LoggerReadOnly = {"Log","Id"}
local Loggers = GetClassMetatable("Loggers",{},LoggersReadOnly,true)
Loggers.Log = {}
local loggersTable = {}
function Loggers:IsA(class:string)
    return class=="Loggers"
end local function ToStringer(data:any)
    local stringData = tostring(data)
    local dataType = typeof(data)
    if dataType~="string" then
        if dataType=="table" then
            if data.__type=="TClass" then
                stringData = "<TClass>:"
                for k,v in data do
                    stringData = stringData.."\n    '"..ToStringer(k).."': "..string.gsub(ToStringer(v),"\n","\n      ")
                end
            else stringData = HttpService:JSONEncode(data)
            end
        elseif dataType=="Instance" then
            stringData = data:GetFullName()
        end
    end return stringData
end
function Loggers.New(self:any?,scriptName:string)
    if not scriptName then
        scriptName=self
    end if type(scriptName)~="string" then
        error("scriptName is incorrect.")
    end
    local logger = GetClassMetatable("TGuiLogger",{},LoggerReadOnly,true)
    function logger:IsA(class:string)
        return class=="TGuiLogger"or class=="Logger"
    end table.insert(loggersTable,logger)
    local currentLoggerId = #loggersTable
    logger.Log = {}
    logger.Id = currentLoggerId
    logger.ScriptName = scriptName
    logger.debugEnabled = false
    function logger:log(type:string,placeName:string?,data:any)
        if data==nil then data=placeName placeName=nil end
        local stringData = ToStringer(data)
        local res = "["..type.."]<"..self.ScriptName
        if placeName then
            res = res..": "..placeName
        end res = res.."> "..stringData
        local log = {
            time=os.time(),
            type=type,
            place=placeName,
            data=data,
            stringData=stringData,
            result=res,
            scriptName=self.ScriptName,
            loggerId=self.Id,
        } table.insert(self.Log,log)
        table.insert(Loggers.Log,log)
        return log
    end function logger:debug(placeName:string?,data:any)
        if self.debugEnabled then 
            local log = self:log("debug",placeName,data)
            print(log.result) return log
        end
    end  function logger:info(placeName:string?,data:any)
        local log = self:log("info",placeName,data)
        print(log.result) return log
    end function logger:warn(placeName:string?,data:any)
        local log = self:log("warn",placeName,data)
        warn(log.result) return log
    end function logger:error(placeName:string?,data:any)
        local log = self:log("error",placeName,data)
        task.spawn(error,log.result)
        return log
    end function logger:critical_error(placeName:string?,data:any)
        local log = self:log("critical_error",placeName,data)
        error(log.result)
    end return logger
end TimGui.Loggers = Loggers
table.insert(TimGuiReadOnly,"Loggers")
local logger = Loggers:New("TimGUI-Core")
logger:info("TimGUI-V3 is starting")
logger:info("Stats","Core-Version: "..TimGui.CoreVersion)
logger:info("Stats","Core-Build: "..TimGui.CoreBuildCount)
logger.debugEnabled = TimGui.SetupData.coreDebugEnabled==true
if logger.debugEnabled then
    logger:info("Debug enabled!")
end -- #FIND_POINT Classes
local ClassesReadOnly = {}
local Classes = GetClassMetatable("TClasses",{},ClassesReadOnly,true)
function Classes:CreateTEvent()
    local event = {}
    event.args = {}
    local argId = 0
    local args:{[number]:{any}} = {}
    event.Args = args
    event.BEvent = Instance.new("BindableEvent")
    event.Event = GetClassMetatable("TEvent",{},{},true)
    event.BEvent.Event:Connect(function(id)
        task.wait(1)
        args[id] = nil
    end) function event:Fire(...)
        argId += 1
        local arg = table.pack(...)
        event.args = arg
        args[argId] = arg
        event.BEvent:Fire(argId)
    end function event.Event:Connect(callback)
        if type(callback)~="function" then logger:critical_error("TEvent:Connect","Callback is incorrect.") end
        return event.BEvent.Event:Connect(function(id)
            callback(table.unpack(args[id]))
        end)
    end function event.Event:Once(callback)
        if type(callback)~="function" then logger:critical_error("TEvent:Connect","Callback is incorrect.") end
        return event.BEvent.Event:Once(function(id)
            callback(table.unpack(args[id]))
        end)
    end function event.Event:Wait()
        local id = event.BEvent.Event:Wait()
        return table.unpack(args[id])
    end return event
end
function Classes:CreateTClass(rawClass:{any?}?,meta:{any}?,writeSameModeExclude:boolean|{string}?)
    if type(rawClass)~="table" then rawClass={} end
    local writeSameMode = true
    if type(writeSameModeExclude)~="table" then writeSameMode=writeSameModeExclude~=true writeSameModeExclude = nil end
    local classReadOnly = {"OnPropertyChanged"}
    local onPropertyChangeEvent = Instance.new("BindableEvent")
    local onPropertyChangeEvents = {}
    local classNames = {"TClass"}
    local class = GetClassMetatable("TClass",rawClass,classReadOnly,writeSameMode,meta,function(k, old, new)
        onPropertyChangeEvent:Fire(k)
        if onPropertyChangeEvents[k] then
            onPropertyChangeEvents[k]:Fire()
        end
    end,writeSameModeExclude) class.ClassName = "TClass"
    table.insert(classReadOnly,"ClassName")
    class.OnPropertyChanged = onPropertyChangeEvent.Event
    function class:SetReadOnly(PropertyName:string)
        if PropertyName==nil then logger:critical_error("TClass:SetReadOnly","Error to set read only for nil") end
        table.insert(classReadOnly,PropertyName)
    end function class:GetReadOnly(PropertyName:string)
        return table.find(classReadOnly,PropertyName)~=nil
    end function class:IsA(className)
        if table.find(classNames,className) then
            return true
        end return false
    end function class:GetClassNames()
        return table.clone(classNames)
    end function class:AddClassName(className:string)
        if type(className)~="string" then logger:critical_error("TClass:AddClassName","Class name cannot be a "..typeof(className)) end
        rawClass.ClassName = className
        table.insert(classNames,className)
    end function class:GetPropertyChangedEvent(PropertyName:string)
        local event = onPropertyChangeEvents[PropertyName]
        if not event then
            event = Instance.new("BindableEvent")
            onPropertyChangeEvents[PropertyName] = event
        end return event.Event
    end return class
end TimGui.Classes = Classes
table.insert(TimGuiReadOnly,"Classes")
-- #FIND_POINT Class Preset
local function RBXValueToTable(v,returnOrigin)
    local type = typeof(v)
    local val
    if type=="Color3" then
        val = {type,v.R,v.G,v.B}
    elseif type=="UDim2" then
        val = {type,v.X.Scale,v.X.Offset,v.Y.Scale,v.Y.Offset}
    elseif type=="UDim" then
        val = {type,v.Scale,v.Offset}
    elseif type=="Vector3" then
        val = {type,v.X,v.Y,v.Z}
    elseif type=="Vector2" then
        val = {type,v.X,v.Y}
    elseif type=="TweenInfo" then
        val = {type,v.Time,v.EasingStyle.Name,v.EasingDirection.Name,v.RepeatCount,v.Reverses,v.DelayTime}
    elseif returnOrigin then
        val = v
    end return val
end local function TableToRBXValue(v,returnOrigin)
    if type(v)~="table" then 
        if returnOrigin then
            return v
        else return
        end
    end
    local val
    if v[1]=="Color3" then
        val = Color3.new(table.unpack(v,2))
    elseif v[1]=="UDim2" then
        val = UDim2.new(table.unpack(v,2))
    elseif v[1]=="UDim" then
        val = UDim.new(table.unpack(v,2))
    elseif v[1]=="Vector3" then
        val = Vector3.new(table.unpack(v,2))
    elseif v[1]=="Vector2" then
        val = Vector2.new(table.unpack(v,2))
    elseif v[1]=="TweenInfo" then
        val = TweenInfo.new(table.unpack(v,2))
    else val = v
    end return val
end
function Classes:CreatePreset(clearOnLoad:boolean,raw:{[any]:any?}?)
    if type(raw)~="table" then raw = {} end
    local Preset = Classes:CreateTClass(raw,nil,clearOnLoad)
    Preset:AddClassName("Preset")
    local PresetRefresh = Instance.new("BindableEvent")
    Preset.Default = {}
    Preset.PresetName = "Default"
    Preset.OnRefresh = PresetRefresh.Event
    Preset:SetReadOnly("OnRefresh")
    function Preset:Load(preset:{[any]:any|{any}})
        if type(preset)~="table" then error("Preset is incorrect.") end
        if clearOnLoad then
            for k,v in Preset do
                if k=="PresetName" then continue end
                if k=="Default" then continue end
                if not Preset:GetReadOnly(k) and type(v)~="function" then
                    raw[k]=nil
                end
            end
        end Preset.PresetName = tostring(preset.PresetName or "Unknown")
        for k,v in preset do
            if k=="PresetName" then continue end
            if k=="Default" then continue end
            if not Preset:GetReadOnly(k) then
                local val
                local type = typeof(v)
                if type=="table" then
                    val = TableToRBXValue(v)
                else val = v
                end if val then
                    Preset[k] = val
                end
            end
        end PresetRefresh:Fire()
    end
    function Preset:Refresh(preset:{any|{any}})
        if type(preset)=="table" then
            Preset:Load(preset)
        else PresetRefresh:Fire()
        end
    end function Preset:GetPreset(dontUseRBXValues:boolean?)
        local preset = {}
        for k,v in Preset do
            if k=="Default" then continue end
            if not Preset:GetReadOnly(k) and type(v)~="function" then
                local val = v
                if dontUseRBXValues then
                    val = RBXValueToTable(v)
                    if val==nil then
                        val = v
                    end
                end preset[k]=val
            end
        end return preset
    end return Preset
end function Classes:CreateBind(raw:{any?}?)
    local bind = Classes:CreateTClass(raw)
    bind:AddClassName("Bind")
    local funcs = {}
    local Event = Classes:CreateTEvent()
    local onBindedEvent = Instance.new("BindableEvent")
    function bind:Bind(func:(any...)->(boolean))
        if type(func)~="function" then logger:critical_error("Bind:Bind function incorrect.") end
        table.insert(funcs,1,func)
        onBindedEvent:Fire()
    end function bind:Run(...)
        Event:Fire(...)
        for _,v in funcs do
            local r = v(...)
            if r~=nil then
                return r
            end
        end return nil
    end bind.OnRun = Event.Event
    bind.OnBinded = onBindedEvent.Event
    bind:SetReadOnly("OnRun")
    return bind
end -- #FIND_POINT Class Translator
function Classes:CreateTranslator(EnglishData:any,raw:{any?}?)
    if EnglishData==nil then logger:critical_error("Classes:CreateTranslator","English/Default data is incorrect(got nil)") end
    local Translator = Classes:CreatePreset(true,raw)
    Translator:AddClassName("TTranslator")
    Translator.en = EnglishData
    function Translator:GetLangCode()
        for _,langCode in TimGui.LanguagePreferences do
            if Translator[langCode]~=nil then
                return langCode
            end
        end
    end local lastLangCode
    function Translator:Translate()
        local lang = Translator:GetLangCode()
        if lang then
            return Translator[lang]
        else return EnglishData
        end
    end local changed = Instance.new("BindableEvent")
    Translator.TranslateValueChanged = changed.Event
    Translator:SetReadOnly("TranslateValueChanged")
    Translator.OnPropertyChanged:Connect(function(k)
        local lang = Translator:GetLangCode()
        if lastLangCode~=lang or (k==lang) then
            lastLangCode = lang
            changed:Fire()
        end
    end) TimGui.LanguageChanged:Connect(function()
        changed:Fire()
    end)
    return Translator
end -- #FIND_POINT IsA()
function Classes:IsA(Object:any,className:string)
    return type(Object)=="table" and Object.__type=="TClass" and Object:IsA(className)
end
-- #FIND_POINT ValueBinder
function Classes:CreateValueBinder(DefaultValue)
    if DefaultValue==nil then logger:critical_error("DefaultValue is incorrect") end
    local VBinder = Classes:CreateTClass(nil,nil,{"Value"})
    VBinder:AddClassName("ValueBinder")
    local binds = {}
    VBinder.ListenId = 0
    VBinder.Value = DefaultValue
    local function refreshBind()
        local Bind = binds[VBinder.ListenId]
        if Bind then
            VBinder.Value = Bind.Value
        else VBinder.Value = DefaultValue
        end
    end VBinder:GetPropertyChangedEvent("ListenId"):Connect(refreshBind)
    local OnBind = Instance.new("BindableEvent")
    VBinder.OnBind = OnBind.Event
    VBinder:SetReadOnly("OnBind")
    function VBinder:Bind(SetToListen:boolean?)
        local Bind = Classes:CreateTClass(nil,nil,{"Value"})
        local OnEnabled = Instance.new("BindableEvent")
        local OnDisabled = Instance.new("BindableEvent")
        Bind.Parent = VBinder
        Bind:SetReadOnly("Parent")
        Bind.OnEnabled = OnEnabled.Event
        Bind.OnDisabled = OnDisabled.Event
        Bind:SetReadOnly("OnEnabled")
        Bind:SetReadOnly("OnDisabled")
        table.insert(binds,Bind)
        Bind:AddClassName("ValueBind")
        Bind.Value = DefaultValue
        Bind.Translator = Classes:CreateTranslator(DefaultValue)
        Bind:SetReadOnly("Translator")
        Bind.Translator.TranslateValueChanged:Connect(function()
            Bind.Value = Bind.Translator:Translate()
        end) Bind.Id = table.find(binds,Bind)
        Bind:SetReadOnly("Id")
        local isEnabled = false
        Bind.Enabled = false
        Bind:GetPropertyChangedEvent("Enabled"):Connect(function()
            if Bind.Enabled~=isEnabled then
                if Bind.Enabled then
                    VBinder.ListenId = Bind.Id
                else VBinder.ListenId = 0
                end
            end
        end) Bind:GetPropertyChangedEvent("Value"):Connect(function()
            if isEnabled then
                VBinder.Value = Bind.Value
            end
        end) VBinder:GetPropertyChangedEvent("ListenId"):Connect(function()
            if VBinder.ListenId==Bind.Id then
                isEnabled = true
                OnEnabled:Fire()
            elseif isEnabled then
                isEnabled = false
                OnDisabled:Fire()
            end Bind.Enabled = isEnabled
        end) if SetToListen~=false or Bind.ListenId==Bind.Id then
            if Bind.ListenId==Bind.Id then
                VBinder.ListenId = 0
            end VBinder.ListenId = Bind.Id
        end refreshBind()
        OnBind:Fire(Bind.Id)
        return Bind
    end
    return VBinder
end
-- #FIND_POINT Binder
local Binder = Classes:CreateTClass()
Binder:AddClassName("Binder")
function Binder:New(raw:{any?})
    return Classes:CreateBind(raw)
end Binder.ArrowAnimation = Binder:New()
Binder:SetReadOnly("ArrowAnimation")
Binder.OpenAnimation = Binder:New()
Binder:SetReadOnly("OpenAnimation")
TimGui.Binder = Binder
table.insert(TimGuiReadOnly,"Binder")
-- #FIND_POINT Colors
local Colors = Classes:CreatePreset()
Colors:AddClassName("Colors")
TimGui.Colors = Colors
table.insert(TimGuiReadOnly,"Colors")
Colors.PresetName = "Default"
Colors.ArrowColor = Color3.new(1,1,1)
Colors.LoadingColor = Color3.new(1,1,1)
Colors.TextColor = Color3.new(1,1,1)
Colors.HeaderSeparatorColor = Color3.new(0,0,0)
Colors.HeaderFirstNameColor = Color3.new(1,1,0)
Colors.HeaderSecondNameColor = Color3.new(1,0,1)
Colors.HeaderTextColor = Color3.new(1,1,1)
Colors.HeaderBackgroundColor = Color3.new(0.15, 0.15, 0.3)
Colors.MainBackgroundColor = Color3.new(0.15, 0.15, 0.3)
Colors.GroupsBackgroundColor = Color3.new(0.15, 0.15, 0.25)
Colors.ButtonBackground = Color3.fromRGB(50,50,100)
Colors.ButtonOnButtonBackground = Color3.fromRGB(65,65,125)
Colors.ButtonOnButtonMain = Color3.new(1,1,1)
Colors.ErrorColor = Color3.new(1,0.3,0.3)
--Types -------------------------
Colors.GroupOpenArrowColor = Color3.new(1,1,1)
Colors.GroupVisibleIndent = Color3.new(1,1,1)
Colors.TTextColor = Color3.new(1,1,1)
Colors.ToggleTrue = Color3.new(0.25,1,0.25)
Colors.ToggleFalse = Color3.new(1,0.25,0.25)
Colors.TextBoxBackgroundColor = Color3.fromRGB(38, 38, 76)
Colors.TextInTextBoxColor = Color3.new(1,1,1)
Colors.AddButtonBackgroundInTextBoxColor = Color3.new(0.3,1,0.3)
Colors.AddButtonTextInTextBoxColor = Color3.new(1,1,1)
Colors.SubtractButtonBackgroundInTextBoxColor = Color3.new(1,0,0.3)
Colors.SubtractButtonTextInTextBoxColor = Color3.new(1,1,1)
Colors.SequenceVisibleIndent = Color3.new(1,1,1)
Colors.SequenceOpenArrowColor = Color3.new(1,1,1)
Colors.SequenceObjectsBackgroundColor = Color3.fromRGB(50,50,100)
Colors.SequenceObjectsTextColor = Color3.new(1,1,1)
--Windows --------------------------
Colors.TWindowBackgroundColor = Color3.new(0.15,0.15,0.3)
Colors.TWindowHeaderBackgroundColor = Color3.new(0.15,0.15,0.25)
Colors.TWindowCloseBackgroundColor = Color3.new(0.8,0.1,0.1)
Colors.TWindowCloseColor = Color3.new(1,1,1)
Colors.TWindowHideBackgroundColor = Color3.new(0.1,0.1,0.8)
Colors.TWindowHideColor = Color3.new(1,1,1)
Colors.TWindowHeaderTextColor = Color3.new(1,1,1)
--OnWindow -------------------------
Colors.OnTWindowTextColor = Color3.new(1,1,1)
Colors.OnTWindowTextBoxBackgroundColor = Color3.fromRGB(27, 27, 56)
Colors.OnTWindowTextBoxTextColor = Color3.new(1,1,1)
Colors.OnTWindowConfirmButtonColor = Color3.new(0.2,0.7,0.3)
Colors.OnTWindowConfirmButtonTextColor = Color3.new(1,1,1)
Colors.OnTWindowCancelButtonColor = Color3.new(0.7,0.2,0.3)
Colors.OnTWindowCancelButtonTextColor = Color3.new(1,1,1)
Colors.OnTWindowHintTextColor = Color3.new(0.75,0.75,0.75)
--Configs --------------------------
Colors.ConfigsSeparationColor = Color3.new(0,0,0)
Colors.ConfigButtonSelectedBackground = Color3.fromRGB(50,75,100)
--Menu------------------------------
Colors.MenuItemBackgroundColor = Color3.new(0.15,0.15,0.25)
Colors.MenuItemTextColor = Color3.new(1,1,1)
Colors.MenuTextTextColor = Color3.new(0.8,0.8,0.8)
Colors.MenuToggleEnabledColor = Color3.new(0.25,1,0.25)
Colors.MenuToggleDisabledColor = Color3.new(1,0.25,0.25)
Colors.Default = Colors:GetPreset()
-- #FIND_POINT GuiSize
local GuiSize = Classes:CreatePreset()
GuiSize:AddClassName("GuiSize")
TimGui.GuiSize = GuiSize
table.insert(TimGuiReadOnly,"GuiSize")
GuiSize.PresetName = "Default"
GuiSize.AnchorPoint = Vector2.new(1,0)
GuiSize.HeaderSize = UDim.new(0,25)
GuiSize.Height = UDim.new(1,0)
GuiSize.Width = UDim.new(0,400)
GuiSize.XPosition = UDim.new(1,0)
GuiSize.YPosition = UDim.new(1,0)
GuiSize.GroupsSize = UDim.new(0,100)
GuiSize.SayingFontSize = UDim.new(0.65,0)
GuiSize.GlobalGroupSize = UDim2.new(1,-5,0,50)
GuiSize.ButtonSize = UDim2.new(1,0,0,50)
GuiSize.ButtonCornerRadius = UDim.new(0.5,0)
-- Not global group -----
GuiSize.GroupOpenImageSize = UDim.new(0,25)
GuiSize.NotGlobalGroupIndent = UDim.new(0,3)
GuiSize.NotGlobalGroupVisibleIndent = UDim.new(0,2)
--Types-------------------
GuiSize.TextSizeInTTextBox = UDim2.new(0.5,0,1,0)
GuiSize.IndentSizeBetweenInTTextBox = UDim2.new(0,0,0,0)
GuiSize.TextBoxSizeInTTextBox = UDim2.new(0.3,0,1,0)
GuiSize.ButtonsSizeInTTextBox = UDim2.new(0.1,0,1,0)
-- Sequence ------------------
GuiSize.SequenceOpenImageSize = UDim.new(0,25)
GuiSize.SequenceIndent = UDim.new(0,3)
GuiSize.SequenceVisibleIndent = UDim.new(0,2)
GuiSize.SequenceObjectSize = UDim2.new(1,0,0,35)
GuiSize.SequenceObjectGrabSize = UDim.new(1,0)
-- Window -------------------
GuiSize.TWindowHeaderSize = UDim.new(0,32)
GuiSize.TWindowHeaderCornerRadius = UDim.new(0,12)
GuiSize.TWindowCornerRadius = UDim.new(0,12)
-- Prompts ------------------
GuiSize.PromptYIndent = UDim.new(0,5)
--TextPrompt
GuiSize.TextBoxPromptSize = UDim2.new(0.8,0,0,50)
GuiSize.TextPromptButtonsSize = UDim2.new(0.8,0,0,50)
GuiSize.TextPromptXAnchor = 0.5
GuiSize.TextPromptDescriptionTextSize = 15
--ConfirmPrompt
GuiSize.ConfirmBoxPromptSize = UDim2.new(0.8,0,0,50)
GuiSize.ConfirmPromptButtonsSize = UDim2.new(0.8,0,0,50)
GuiSize.ConfirmPromptXAnchor = 0.5
GuiSize.ConfirmPromptDescriptionTextSize = 15
--KeyPrompt
GuiSize.TextKeyPromptSize = UDim2.new(0.8,0,0,100)
GuiSize.NotifyKeyPromptSize = UDim2.new(1,0,0,50)
-- ConfigWindow -------------
GuiSize.ConfigsSeparatorSize = UDim.new(0,1)
GuiSize.ConfigsWindowConfigsSize = UDim.new(0,30)
GuiSize.ConfigsWindowConfigsFrameSize = UDim.new(0.3,0)
GuiSize.ConfigsWindowSize = UDim2.new(0.25,100,0.3,200)
GuiSize.ConfigsCfgCornerRadius = UDim.new(0.5,0)
GuiSize.ConfigsTitleSize = UDim2.new(1,0,0.1,0)
-- Menu --------------------------
GuiSize.MenuItemYSize = 25
GuiSize.MenuItemTextSize = 25
GuiSize.MenuTextTextSize = 20
-- Keybinder ---------------------
GuiSize.KeybindYSize = UDim.new(0,35)
GuiSize.KeybindCornerRadius = UDim.new(0.35,0)
GuiSize.KeybindButtonsCornerRadius = UDim.new(0.35,0)
GuiSize.KeybinderScrollBarThickness = 6
GuiSize.KeybinderTitleSize = UDim2.new(1,0,0,40)
GuiSize.KeybinderButtonsYSize = UDim.new(0,30)
GuiSize.Default = GuiSize:GetPreset()
function TimGui:GetFrameGuiPosition(opened:boolean?)
    if opened==nil then opened = TimGui.Opened end
    local position = UDim2.new(GuiSize.XPosition,GuiSize.YPosition)
    if opened then
        position -= UDim2.new(UDim.new(),GuiSize.Height)
    end return position
end
-- #FIND_POINT Assets
local Assets = Classes:CreatePreset()
Assets:AddClassName("Assets")
TimGui.Assets = Assets
table.insert(TimGuiReadOnly,"Assets")
Assets.PresetName = "Default"
Assets.Error = "rbxassetid://75662198735241"
Assets.Arrow = "rbxassetid://16341277046"
Assets.GroupOpenArrow = "rbxassetid://16341277046"
Assets.SequenceOpenArrow = "rbxassetid://122258968574937"
Assets.HideTWindow = "rbxassetid://122258968574937"
Assets.CloseTWindow = "rbxassetid://107936050082953"
Assets.DeleteKeybindObject = "rbxassetid://107936050082953"
Assets.AddKeybind = "rbxassetid://120597765063106"
Assets.Loading = "rbxasset://textures/DarkThemeLoadingCircle.png"
Assets.Default = Assets:GetPreset()
-- #FIND_POINT GuiAnimations
local RawGAnimations = {}
local GuiAnimations = Classes:CreatePreset(RawGAnimations)
GuiAnimations:AddClassName("GuiAnimations")
TimGui.GuiAnimations = GuiAnimations
table.insert(TimGuiReadOnly,"GuiAnimations")
GuiAnimations.PresetName = "Default"
GuiAnimations.ArrowRotateAnimationEnabled = true
GuiAnimations.ArrowRotateTI = TweenInfo.new(0.5)
local LastArrowTween,LastFrameTween
Binder.ArrowAnimation:Bind(function(Arrow:UIBase,isOpen:boolean)
    local rotation
    if isOpen then
        rotation = 180
    else rotation = 360
    end if GuiAnimations.ArrowRotateAnimationEnabled then
        Arrow.Rotation = rotation-180
        if LastArrowTween then LastArrowTween:Cancel() end
        LastArrowTween = TweenService:Create(Arrow,GuiAnimations.ArrowRotateTI,{Rotation=rotation})
        LastArrowTween:Play()
        LastArrowTween.Completed:Once(function()
            LastArrowTween = nil
        end)
    else Arrow.Rotation = rotation
    end return true
end) GuiAnimations.OpenAnimationEnabled = true
GuiAnimations.OpenTI = TweenInfo.new(0.5)
Binder.OpenAnimation:Bind(function(Frame:UIBase,isOpen:boolean)
    local position = TimGui:GetFrameGuiPosition(isOpen)
    if GuiAnimations.OpenAnimationEnabled then
        if LastFrameTween then LastFrameTween:Cancel() end
        LastFrameTween = TweenService:Create(Frame,GuiAnimations.OpenTI,{Position=position})
        LastFrameTween:Play()
        LastFrameTween.Completed:Once(function()
            LastFrameTween = nil
        end)
    else Frame.Position = position
    end return true
end)
GuiAnimations.Default = GuiAnimations:GetPreset()
-- #FIND_POINT GUI + GuiInstances
logger:info("Creating GUI.")
local GuiInstances = Classes:CreateTClass()
GuiInstances:AddClassName("GuiInstances")
local STGui = Instance.new("ScreenGui")
STGui.ResetOnSpawn = false
STGui.DisplayOrder = 1
local STGuiParentIsCoreGUI = pcall(function()
    STGui.Parent = game.CoreGui
end) if not STGuiParentIsCoreGUI then
    STGui.Parent = LocalPlayer.PlayerGui
end STGui.Name = "TimGui-V3"
TimGui.ScreenGui = STGui
GuiInstances.ScreenGui = STGui
GuiInstances:SetReadOnly("ScreenGui")
table.insert(TimGuiReadOnly,"ScreenGui")
local MainFrame = Instance.new("Frame",STGui)
MainFrame.Name = "Main"
GuiInstances.Main = MainFrame
GuiInstances:SetReadOnly("Main")
GuiSize:GetPropertyChangedEvent("AnchorPoint"):Connect(function()
    MainFrame.AnchorPoint = GuiSize.AnchorPoint
end) MainFrame.AnchorPoint = GuiSize.AnchorPoint
local HeaderFrame = Instance.new("Frame",MainFrame)
HeaderFrame.Name = "Header"
GuiInstances.Header = HeaderFrame
GuiInstances:SetReadOnly("Header")
HeaderFrame.AnchorPoint = Vector2.new(0,1)
local StateButton = Instance.new("TextButton",HeaderFrame)
StateButton.Name = "State"
StateButton.BackgroundTransparency = 1
StateButton.TextTransparency = 1
GuiInstances.State = StateButton
GuiInstances:SetReadOnly("State")
local OpenLabel = Instance.new("ImageLabel",StateButton)
OpenLabel.Name = "Open"
OpenLabel.BackgroundTransparency = 1
OpenLabel.Size = UDim2.new(1,0,1,0)
GuiInstances.OpenImage = OpenLabel
GuiInstances:SetReadOnly("OpenButton")
local LoadingStateImage = Instance.new("ImageLabel",StateButton)
LoadingStateImage.Name = "Loading"
LoadingStateImage.BackgroundTransparency = 1
LoadingStateImage.Size = UDim2.new(1,0,1,0)
GuiInstances.LoadingStateImage = LoadingStateImage
GuiInstances:SetReadOnly("LoadingStateImage")
local ErrorStateImage = Instance.new("ImageLabel",StateButton)
ErrorStateImage.Name = "Loading"
ErrorStateImage.BackgroundTransparency = 1
ErrorStateImage.Size = UDim2.new(1,0,1,0)
GuiInstances.ErrorStateImage = ErrorStateImage
GuiInstances:SetReadOnly("ErrorStateImage")
-- #FIND_POINT GUI Position
GuiSize.DefaultPositionEnabled = true
local function RefreshGUI(isOpenChange:boolean)
    if GuiSize.DefaultPositionEnabled then
        if isOpenChange then
        end MainFrame.Position = TimGui:GetFrameGuiPosition()
        HeaderFrame.Size = UDim2.new(GuiSize.Width,GuiSize.HeaderSize)
    end
end
GuiSize:GetPropertyChangedEvent("XPosition"):Connect(function()
    RefreshGUI()
end) GuiSize:GetPropertyChangedEvent("YPosition"):Connect(function()
    RefreshGUI()
end) GuiSize:GetPropertyChangedEvent("Width"):Connect(function()
    RefreshGUI() if GuiSize.DefaultPositionEnabled then
        MainFrame.Size = UDim2.new(GuiSize.Width,GuiSize.Height)
    end
end) GuiSize:GetPropertyChangedEvent("Height"):Connect(function()
    RefreshGUI() if GuiSize.DefaultPositionEnabled then
        MainFrame.Size = UDim2.new(GuiSize.Width,GuiSize.Height)
    end
end) GuiSize:GetPropertyChangedEvent("HeaderSize"):Connect(function()
    RefreshGUI()
    StateButton.Size = UDim2.new(GuiSize.HeaderSize,GuiSize.HeaderSize)
end) RefreshGUI()
MainFrame.Size = UDim2.new(GuiSize.Width,GuiSize.Height)
StateButton.Size = UDim2.new(GuiSize.HeaderSize,GuiSize.HeaderSize)
function GuiAnimations:ArrowRotateAnimation(isOpened:boolean)
    if isOpened==nil then isOpened=TimGui.Opened end
    return Binder.ArrowAnimation:Run(OpenLabel,isOpened)
end function GuiAnimations:OpenAnimation(isOpened:boolean)
    if isOpened==nil then isOpened=TimGui.Opened end
    return Binder.OpenAnimation:Run(MainFrame,isOpened)
end
TimGui.OnOpened:Connect(function(new:boolean)
    GuiAnimations:ArrowRotateAnimation(new)
    GuiAnimations:OpenAnimation(new)
end) OnExitEvent.Event:Connect(function()
    STGui:Destroy()
end)
-- #FIND_POINT Header + GUI Header
local Header = Classes:CreateTClass()
Header:AddClassName("Header")
local HeaderSeparator = Instance.new("Frame",HeaderFrame)
HeaderSeparator.Position = UDim2.new(0.5,0,0,0)
HeaderSeparator.AnchorPoint = Vector2.new(0.5,0)
HeaderSeparator.Name = "Separator"
GuiInstances.HeaderSeparator = HeaderSeparator
GuiInstances:SetReadOnly("HeaderSeparator")
HeaderSeparator.BorderSizePixel = 0
Colors:GetPropertyChangedEvent("HeaderSeparatorColor"):Connect(function()
    HeaderSeparator.BackgroundColor3 = Colors.HeaderSeparatorColor
end) HeaderSeparator.BackgroundColor3 = Colors.HeaderSeparatorColor
local FirstName = Instance.new("TextLabel",HeaderFrame)
FirstName.BackgroundTransparency = 1
FirstName.TextXAlignment = Enum.TextXAlignment.Right
FirstName.Font = Enum.Font.SourceSansBold
FirstName.TextScaled = true
FirstName.Name = "FirstName"
GuiInstances.FirstHeaderName = FirstName
GuiInstances:SetReadOnly("FirstHeaderName")
Colors:GetPropertyChangedEvent("HeaderFirstNameColor"):Connect(function()
    FirstName.TextColor3 = Colors.HeaderFirstNameColor
end) FirstName.TextColor3 = Colors.HeaderFirstNameColor
local TwoName = Instance.new("TextLabel",HeaderFrame)
TwoName.AnchorPoint = Vector2.new(1,0)
TwoName.Position = UDim2.new(1,0,0,0)
TwoName.BackgroundTransparency = 1
TwoName.TextXAlignment = Enum.TextXAlignment.Left
TwoName.Font = Enum.Font.SourceSansBold
TwoName.TextScaled = true
TwoName.Name = "SecondName"
GuiInstances.SecondHeaderName = TwoName
GuiInstances:SetReadOnly("SecondHeaderName")
Colors:GetPropertyChangedEvent("HeaderSecondNameColor"):Connect(function()
    TwoName.TextColor3 = Colors.HeaderSecondNameColor
end) TwoName.TextColor3 = Colors.HeaderSecondNameColor
Header:GetPropertyChangedEvent("SeparatorSize"):Connect(function()
    if Header.SeparatorSize>0 then
        HeaderSeparator.Visible = true
        HeaderSeparator.Size = UDim2.new(0,Header.SeparatorSize,1,0)
    else HeaderSeparator.Visible = false
    end local xoffset = -(Header.SeparatorSize+1)/2
    FirstName.Size = UDim2.new(0.5,xoffset,1,0)
    TwoName.Size = UDim2.new(0.5,xoffset,1,0)
end) Header.SeparatorSize = tonumber(TimGui.SetupData.SeparatorSize) or 3
Header.FirstName = Classes:CreateTranslator("Tim")
if type(TimGui.SetupData["FirstHeaderName"])=="table" then
    Header.FirstName:Load(TimGui.SetupData["FirstHeaderName"])
elseif TimGui.SetupData["FirstHeaderName"]~=nil then
    Header.FirstName.en = TimGui.SetupData["FirstHeaderName"]
end FirstName.Text = Header.FirstName:Translate()
Header.FirstName.TranslateValueChanged:Connect(function()
    FirstName.Text = Header.FirstName:Translate()
end) Header:SetReadOnly("FirstName")
Header.SecondName = Classes:CreateTranslator("Gui")
if type(TimGui.SetupData["SecondHeaderName"])=="table" then
    Header.SecondName:Load(TimGui.SetupData["SecondHeaderName"])
elseif TimGui.SetupData["SecondHeaderName"]~=nil then
    Header.SecondName.en = TimGui.SetupData["SecondHeaderName"]
end TwoName.Text = Header.SecondName:Translate()
Header.SecondName.TranslateValueChanged:Connect(function()
    TwoName.Text = Header.SecondName:Translate()
end) Header:SetReadOnly("SecondName")
TimGui.Header = Header
table.insert(TimGuiReadOnly,"Header")
local HeaderInfo = Instance.new("TextLabel",HeaderFrame)
HeaderInfo.Size = UDim2.new(1,0,1,0)
HeaderInfo.TextXAlignment = Enum.TextXAlignment.Right
HeaderInfo.TextScaled = true
Colors:GetPropertyChangedEvent("HeaderTextColor"):Connect(function()
    HeaderInfo.TextColor3 = Colors.HeaderTextColor
end) HeaderInfo.TextColor3 = Colors.HeaderTextColor
HeaderInfo.BackgroundTransparency = 1
local HeaderInfoValue = Classes:CreateValueBinder("")
Header.InfoValue = HeaderInfoValue
Header:SetReadOnly("InfoValue")
GuiInstances.HeaderInfo = HeaderInfo
GuiInstances:SetReadOnly("HeaderInfo")
HeaderInfo.Text = ""
HeaderInfoValue:GetPropertyChangedEvent("Value"):Connect(function()
    HeaderInfo.Text = tostring(HeaderInfoValue.Value)
end)
-- #FIND-POINT Clock/FPS in HeaderInfo
task.spawn(function()
    local ClockBind = HeaderInfoValue:Bind()
    ClockBind.Translator:Load{ --#LANG_REQUIRED
        ru="Загрузка",
        en="Loading"
    } while task.wait(0.5) do
        ClockBind.Value = os.date("%H:%M:%S",os.time())
    end
end) local FPSInfoBind = HeaderInfoValue:Bind(false)
local FPSConnection: RBXScriptSignal
FPSInfoBind.OnDisabled:Connect(function()
    if FPSConnection then FPSConnection:Disconnect() end
end) FPSInfoBind.OnEnabled:Connect(function()
    if FPSConnection then FPSConnection:Disconnect() end
    local Post2FPS = 0
    local PostFPS = 0
    FPSConnection = RunService.PreRender:Connect(function(deltaTime:number)
        local thisFPS = 1/deltaTime
        local FPS = (Post2FPS+PostFPS+thisFPS)/3
        local CFPS = math.floor(FPS)
        FPSInfoBind.Value = CFPS.."."..math.floor((FPS-CFPS)*10).." FPS"
        Post2FPS = PostFPS
        PostFPS = thisFPS
    end)
end)
-- #FIND-POINT GUI Main
local GroupsSFrame = Instance.new("ScrollingFrame",MainFrame)
GroupsSFrame.ScrollingDirection = Enum.ScrollingDirection.Y
GroupsSFrame.ScrollBarThickness = 5
local ButtonsSFrame = Instance.new("ScrollingFrame",MainFrame)
ButtonsSFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ButtonsSFrame.ScrollBarThickness = 5
GuiSize:GetPropertyChangedEvent("GropsSize"):Connect(function()
    if GuiSize.DefaultPositionEnabled then
        GroupsSFrame.Size = UDim2.new(GuiSize.GroupsSize,UDim.new(1,0))
        ButtonsSFrame.Position = UDim2.new(GuiSize.GroupsSize,UDim.new(0,0))
        ButtonsSFrame.Size = UDim2.new(UDim.new(1,0)-GuiSize.GroupsSize,UDim.new(1,0))
    end
end) GroupsSFrame.Size = UDim2.new(GuiSize.GroupsSize,UDim.new(1,0))
ButtonsSFrame.Position = UDim2.new(GuiSize.GroupsSize,UDim.new(0,0))
ButtonsSFrame.Size = UDim2.new(UDim.new(1,0)-GuiSize.GroupsSize,UDim.new(1,0))
ButtonsSFrame.BackgroundTransparency = 1
-- #FIND_POINT GUI Assets
Assets:GetPropertyChangedEvent("Arrow"):Connect(function()
    OpenLabel.Image = Assets.Arrow
end) OpenLabel.Image = Assets.Arrow
Assets:GetPropertyChangedEvent("Loading"):Connect(function()
    LoadingStateImage.Image = Assets.Loading
end) LoadingStateImage.Image = Assets.Loading
Assets:GetPropertyChangedEvent("Error"):Connect(function()
    ErrorStateImage.Image = Assets.Error
end) ErrorStateImage.Image = Assets.Error
-- #FIND_POINT GUI Colors
Colors:GetPropertyChangedEvent("ArrowColor"):Connect(function()
    OpenLabel.ImageColor3 = Colors.ArrowColor
end) OpenLabel.ImageColor3 = Colors.ArrowColor
Colors:GetPropertyChangedEvent("LoadingColor"):Connect(function()
    LoadingStateImage.ImageColor3 = Colors.LoadingColor
end) LoadingStateImage.ImageColor3 = Colors.LoadingColor
Colors:GetPropertyChangedEvent("ErrorColor"):Connect(function()
    ErrorStateImage.ImageColor3 = Colors.ErrorColor
end) ErrorStateImage.ImageColor3 = Colors.ErrorColor
Colors:GetPropertyChangedEvent("GroupsBackgroundColor"):Connect(function()
    GroupsSFrame.BackgroundColor3 = Colors.GroupsBackgroundColor
end) GroupsSFrame.BackgroundColor3 = Colors.GroupsBackgroundColor
Colors:GetPropertyChangedEvent("MainBackgroundColor"):Connect(function()
    MainFrame.BackgroundColor3 = Colors.MainBackgroundColor
end) MainFrame.BackgroundColor3 = Colors.MainBackgroundColor
Colors:GetPropertyChangedEvent("HeaderBackgroundColor"):Connect(function()
    HeaderFrame.BackgroundColor3 = Colors.HeaderBackgroundColor
end) HeaderFrame.BackgroundColor3 = Colors.HeaderBackgroundColor
-- #FIND_POINT State/GuiState
local State = Classes:CreateTClass()
local onStateChanged = Instance.new("BindableEvent")
State:AddClassName("State")
State.ActiveState = "None" -- or "Loading"
State.OpenEnabled = true
State.onStateChanged = onStateChanged.Event
State.SayEnabled = false
State.Saying = Classes:CreateTranslator("...")
State:SetReadOnly("Saying")
function State:ResetToDefault()
    State.ActiveState = "None"
    State.OpenEnabled = true
    State.SayEnabled = false
    onStateChanged:Fire()
end State.LoadingSpeed = 1
function State:SetLoadingState()
    State.ActiveState = "Loading"
    onStateChanged:Fire()
end function State:SetErrorState()
    State.ActiveState = "Error"
    onStateChanged:Fire()
end State:GetPropertyChangedEvent("ActiveState"):Connect(function()
    OpenLabel.Visible = State.ActiveState=="None"
    LoadingStateImage.Visible = State.ActiveState=="Loading"
    ErrorStateImage.Visible = State.ActiveState=="Error"
end)
StateButton.Activated:Connect(function()
    if State.OpenEnabled then
        TimGui.Opened = not TimGui.Opened
    end
end) 
local sayingFrame = Instance.new("Frame",StateButton)
sayingFrame.Position = UDim2.new(0,2,0,-5)
sayingFrame.AnchorPoint = Vector2.new(0,1)
sayingFrame.Visible = false
sayingFrame.Name = "Saying"
Instance.new("UICorner",sayingFrame).CornerRadius = UDim.new(0.25,0)
local sayingText = Instance.new("TextLabel",sayingFrame)
sayingText.Name = "Text"
sayingText.Size = UDim2.new(1,0,1,0)
sayingText.TextWrapped = true
sayingText.BackgroundTransparency = 1
Colors:GetPropertyChangedEvent("MainBackgroundColor"):Connect(function()
    sayingFrame.BackgroundColor3 = Colors.MainBackgroundColor
end) sayingFrame.BackgroundColor3 = Colors.MainBackgroundColor
Colors:GetPropertyChangedEvent("TextColor"):Connect(function()
    sayingText.TextColor3 = Colors.TextColor
end) sayingText.TextColor3 = Colors.TextColor
local function sayingFrameRefresh()
    sayingText.TextSize = (GuiSize.SayingFontSize.Offset+GuiSize.SayingFontSize.Scale*(HeaderFrame.AbsoluteSize.Y-1))
    sayingText.Text = State.Saying:Translate()--.."\n"
    local GetTextBoundsParams = Instance.new("GetTextBoundsParams")
    GetTextBoundsParams.Width = HeaderFrame.AbsoluteSize.X
    GetTextBoundsParams.Font = sayingText.FontFace
    GetTextBoundsParams.RichText = sayingText.RichText
    GetTextBoundsParams.Text = sayingText.Text
    GetTextBoundsParams.Size = sayingText.TextSize
    local OffsetSize = TextService:GetTextBoundsAsync(GetTextBoundsParams)
    sayingFrame.Size = UDim2.new(0,OffsetSize.X,0,OffsetSize.Y+1)
end sayingFrameRefresh()
GuiSize:GetPropertyChangedEvent("SayingFontSize"):Connect(sayingFrameRefresh)
State.Saying.TranslateValueChanged:Connect(sayingFrameRefresh)
StateButton.MouseEnter:Connect(function()
    sayingFrame.Visible = State.SayEnabled
end) StateButton.MouseLeave:Connect(function()
    sayingFrame.Visible = false
end) function State:SetErrorStateAndClose()
    State.OpenEnabled = false
    TimGui.Opened = false
    State:SetErrorState()
end
TimGui.State = State
table.insert(TimGuiReadOnly,State)
local LoadingConnect = RunService.RenderStepped:Connect(function(deltaTime)
    if LoadingStateImage.Visible then
        LoadingStateImage.Rotation += 360*deltaTime/(tonumber(State.LoadingSpeed)or 1)
    end
end) OnExitEvent.Event:Connect(function()
    LoadingConnect:Disconnect()
end)
State.OpenEnabled = false
State:SetLoadingState()
-- #FIND_POINT SpecialColors
function Classes:CreateSpecialColors()
    local SpecialColors = Classes:CreatePreset(true)
    SpecialColors:AddClassName("Colors")
    SpecialColors:AddClassName("SpecialColors")
    function SpecialColors:GetColor(name:string)
        if SpecialColors[name] then return SpecialColors[name] end
        return Colors[name]
    end function SpecialColors:GetColorChangedSignal(name:string)
        local event = Instance.new("BindableEvent")
        Colors:GetPropertyChangedEvent(name):Connect(function()
            event:Fire()
        end) SpecialColors:GetPropertyChangedEvent(name):Connect(function()
            event:Fire()
        end) return event.Event
    end return SpecialColors
end
-- #FIND_POINT Menu
State.Saying:Load({ -- #LANG_REQUIRED
    ru="Загрузка ядра [Создание меню]...",
    uk="Завантаження ядря [Створення меню]...",
    en="Loading core [Creating menu]..."
}) local MenuGUI = Instance.new("ScreenGui",STGui.Parent)
OnExitEvent.Event:Connect(function() MenuGUI:Destroy() end)
MenuGUI.DisplayOrder = STGui.DisplayOrder+1
MenuGUI.Name = "TimGui_Menu"
TimGui.MenuScreenGui = MenuGUI
table.insert(TimGuiReadOnly,"MenuScreenGui")
local onMenuNewChild,onMenuChildParentChanged = {},{}
-- Arg 1 = onlyNotFocused
local MenuCloseEvent = Instance.new("BindableEvent")
local function CreateMenuObject(Menu)
    if not Classes:IsA(Menu,"TClass") then
        Menu = Classes:CreateTClass()
    end Menu:AddClassName("MenuObject")
    local children = {}
    local Destroyed = false
    function Menu:GetChildren()
        if Destroyed then return {} end
        local res = {}
        for k,v in children do
            res[k] = v
        end return res
    end function Menu:FindFirstChild(Name:string)
        if Destroyed then return end
        for k,v in children do
            if v.Name==Name then
                return v
            end
        end
    end
    local refreshing,nextRefresh = false,false
    local MenuRefreshed = Instance.new("BindableEvent")
    Menu.MenuRefreshed = MenuRefreshed.Event
    Menu:SetReadOnly("MenuRefreshed")
    local function refreshPosition()
        if Destroyed then return end
        if refreshing then
            nextRefresh = true
            return
        end refreshing = true
        logger:debug("Menu","Refreshing Menu Objects Positions")
        table.sort(children,function(a,b)
            if a.Position~=b.Position then
                return a.Position<b.Position
            else return a.Id<b.Id
            end
        end) local yPos = UDim.new(0,0)
        local xMaxOffset = 0
        for k,v in children do
            yPos = v.SpecialRefreshPositionBind:Run(v,yPos,k)
            if (tonumber(v.XSizeOffset)or 0)>xMaxOffset then
                xMaxOffset = v.XSizeOffset
            end
        end Menu.MenuSize = UDim2.new(UDim.new(0,xMaxOffset+1),yPos)
        MenuRefreshed:Fire()
        RunService.RenderStepped:Wait()
        refreshing = false
        if nextRefresh then
            nextRefresh = false 
            refreshPosition()
        end
    end Menu.MenuSize = UDim2.new(0,0,0,0)
    function Menu:RefreshMenuSize()
        logger:debug("Menu","Refreshing Menu size")
        refreshPosition()
    end function Menu:RefreshMenuPosition()
        refreshPosition()
    end local MenuFrame = Instance.new("Frame")
    MenuFrame.BackgroundTransparency = 1
    MenuFrame.Visible = false
    Menu.MenuFrame = MenuFrame
    Menu:SetReadOnly("MenuFrame")
    Menu:GetPropertyChangedEvent("MenuSize"):Connect(function()
        MenuFrame.Size = Menu.MenuSize
    end) Menu.MouseOnThisMenu = false
    MenuFrame.MouseEnter:Connect(function()
        Menu.MouseOnThisMenu = true
    end) MenuFrame.MouseLeave:Connect(function()
        Menu.MouseOnThisMenu = false
    end) Menu.MaxXSizeForMenu = UDim.new(0.5,0)
    Menu:GetPropertyChangedEvent("MaxXSizeForMenu"):Connect(function()
        for k,v in children do
            v.MaxXSize = Menu.MaxXSizeForMenu
        end
    end) local ChildAdded = Classes:CreateTEvent()
    local ChildRemoved = Classes:CreateTEvent()
    Menu.ChildAdded = ChildAdded.Event
    Menu.ChildRemoved = ChildRemoved.Event
    Menu:SetReadOnly("ChildAdded")
    Menu:SetReadOnly("ChildRemoved")
    onMenuNewChild[Menu] = function(child)
        if not child then child = Classes:CreateMenuItem() end
        child.MaxXSize = Menu.MaxXSizeForMenu
        table.insert(children,child) child.Position = #children
        ChildAdded:Fire(child)
    end onMenuChildParentChanged[Menu] = function(child)
        if not child then child = Classes:CreateMenuItem() end
        local pos = table.find(children,child)
        if pos then
            table.remove(children,pos)
            refreshPosition()
            ChildRemoved:Fire(child)
        end
    end Menu.Opened = false
    local openedWithMethod = false
    Menu:GetPropertyChangedEvent("Opened"):Connect(function()
        MenuFrame.Visible = Menu.Opened
        if Menu.Opened~=openedWithMethod then
            if Menu.Opened then
                Menu.OpenBind:Run()
            else Menu.CloseBind:Run()
            end
        end
    end) local OpenBind = Classes:CreateBind()
    Menu.OpenBind = OpenBind
    Menu:SetReadOnly("OpenBind")
    function Menu:Open(Position:UDim2?)
        openedWithMethod = true
        Menu.Opened = true
        OpenBind:Run(Position)
    end local CloseBind = Classes:CreateBind()
    Menu.CloseBind = CloseBind
    Menu:SetReadOnly("CloseBind")
    function Menu:Close()
        openedWithMethod = false
        Menu.Opened = false
        CloseBind:Run()
    end local MenuCancelled = Instance.new("BindableEvent")
    Menu.MenuCancelled = MenuCancelled.Event
    Menu:SetReadOnly("MenuCancelled")
    MenuCloseEvent.Event:Connect(function(ignoreFocus)
        if ignoreFocus or not Menu.MouseOnThisMenu then
            Menu:Close()
            MenuCancelled:Fire()
        end
    end) local OnDestroy = Instance.new("BindableEvent")
    Menu.Destroyed = OnDestroy.Event
    Menu:SetReadOnly("Destroyed")
    function Menu:Destroy()
        if Destroyed then return end
        Destroyed = true
        if Menu.Opened then
            Menu:Close()
            Menu.Opened = false
            MenuCancelled:Fire()
        end Menu:SetReadOnly("Opened")
        OnDestroy:Fire()
        onMenuNewChild[Menu] = nil
        onMenuChildParentChanged[Menu] = nil
        for k,v in children do
            v:Destroy()
        end MenuFrame:Destroy()
    end
    function Menu:CreateMenuItem(Name:string,Title:{[string]: string} | string?)
        local item = Classes:CreateMenuItem(Name,Title)
        item.Parent = Menu
        return item
    end function Menu:CreateMenuButton(Name:string,Title:{[string]: string} | string?)
        local item = Classes:CreateMenuButton(Name,Title)
        item.Parent = Menu
        return item
    end function Menu:CreateMenuText(Name:string,Title:{[string]: string} | string?)
        local item = Classes:CreateMenuText(Name,Title)
        item.Parent = Menu
        return item
    end function Menu:CreateMenuToggle(Name:string,Title:{[string]: string} | string?)
        local item = Classes:CreateMenuToggle(Name,Title)
        item.Parent = Menu
        return item
    end
    return Menu
end
function Classes:CreateMenu()
    local Menu = CreateMenuObject()
    Menu:AddClassName("Menu")
    Menu.MenuFrame.Parent = MenuGUI
    Menu.Position = UDim2.new(0,0,0,0)
    Menu:GetPropertyChangedEvent("Position"):Connect(function()
        local PosWithSize = Menu.Position+Menu.MenuSize
        local ScAbsSize = MenuGUI.AbsoluteSize
        local AbsolutePosWS = Vector2.new(PosWithSize.X.Scale+PosWithSize.X.Offset/ScAbsSize.X,PosWithSize.Y.Scale+PosWithSize.Y.Offset/ScAbsSize.Y)
        local XAnchor,YAnchor = 0,0
        if AbsolutePosWS.X>1 then
            XAnchor = 1
        else XAnchor = 0
        end if AbsolutePosWS.Y>1 then
            YAnchor = 1
        else YAnchor = 0
        end Menu.MenuFrame.AnchorPoint = Vector2.new(XAnchor,YAnchor)
        Menu.MenuFrame.Position = Menu.Position
    end) Menu.OpenBind:Bind(function(Position:UDim2)
        if Position then
            Menu.Position = Position
        end return true
    end)
    return Menu
end local MenuItemId = 0
local MenuItemRefreshSizeBind = Classes:CreateBind()
Binder.MenuItemRefreshSizeBind = MenuItemRefreshSizeBind
Binder:SetReadOnly("MenuItemRefreshSizeBind")
local MenuItemRefreshPositionBind = Classes:CreateBind()
Binder.MenuItemRefreshPositionBind = MenuItemRefreshPositionBind
Binder:SetReadOnly("MenuItemRefreshPositionBind")
function Classes:CreateMenuItem(Name:string,Title:{[string]:string}|string?)
    if type(Name)~="string" then logger:critical_error("Classes:CreateMenuItem","Name is incorrect(expected string)") end
    if type(Title)~="table" then
        Title = Classes:CreateTranslator(Title or Name)
    else if Title.__type~="TClass" then
            local oldTitle = Title
            Title = Classes:CreateTranslator(Name)
            Title:Load(oldTitle)
        elseif not Title:IsA("Translator") then
            Title = Classes:CreateTranslator(Name)
        end
    end local MenuItem = Classes:CreateTClass(nil,nil,{"Parent"})
    MenuItem:AddClassName("MenuItem")
    MenuItem.Name = Name
    MenuItem:SetReadOnly("Name")
    MenuItem.Title = Title
    MenuItem:SetReadOnly("Title")
    MenuItemId += 1
    MenuItem.Id = MenuItemId
    MenuItem:SetReadOnly("Id")
    MenuItem.MaxXSize = UDim.new(0.5,0)
    local SColors = Classes:CreateSpecialColors()
    MenuItem.SpecialColors = SColors
    MenuItem:SetReadOnly("SpecialColors")
    local Frame = Instance.new("Frame")
    MenuItem.Frame = Frame
    MenuItem:SetReadOnly("MenuItem")
    SColors:GetColorChangedSignal("MenuItemBackgroundColor"):Connect(function()
        Frame.BackgroundColor3 = SColors:GetColor("MenuItemBackgroundColor")
    end) Frame.BackgroundColor3 = SColors:GetColor("MenuItemBackgroundColor")
    local oldParent
    MenuItem.Position = 0
    MenuItem:GetPropertyChangedEvent("Position"):Connect(function()
        if oldParent then
            oldParent:RefreshMenuPosition()
        end
    end) local SpecialRefreshPositionBind = Classes:CreateBind()
    MenuItem.SpecialRefreshPositionBind = SpecialRefreshPositionBind
    MenuItem:SetReadOnly("SpecialRefreshPositionBind")
    MenuItem.XSizeOffset = 0
    SpecialRefreshPositionBind:Bind(function(...)
        return MenuItemRefreshPositionBind:Run(...)
    end) function MenuItem:RefreshPosition()
        if oldParent then
            oldParent:RefreshMenuPosition()
        end
    end MenuItem:RefreshPosition()
    SpecialRefreshPositionBind.OnBinded:Connect(function()
        MenuItem:RefreshPosition()
    end) MenuItem.Visible = true
    MenuItem:GetPropertyChangedEvent("Visible"):Connect(function()
        Frame.Visible = MenuItem.Visible
        MenuItem:RefreshPosition()
    end)
    local SpecialRefreshSizeBind = Classes:CreateBind()
    MenuItem.SpecialRefreshSizeBind = SpecialRefreshSizeBind
    MenuItem:SetReadOnly("SpecialRefreshSizeBind")
    MenuItem.XSizeOffset = 0
    SpecialRefreshSizeBind:Bind(function(...)
        return MenuItemRefreshSizeBind:Run(...)
    end) function MenuItem:RefreshSize()
        MenuItem.XSizeOffset = SpecialRefreshSizeBind:Run(MenuItem)
        if oldParent then
            oldParent:RefreshMenuSize()
        end MenuItem:RefreshPosition()
    end MenuItem:RefreshSize()
    SpecialRefreshSizeBind.OnBinded:Connect(function()
        MenuItem:RefreshSize()
    end) GuiSize:GetPropertyChangedEvent("MenuItemYSize"):Connect(function()
        MenuItem:RefreshSize()
    end) MenuItem:GetPropertyChangedEvent("MaxXSize"):Connect(function()
        MenuItem:RefreshSize()
    end)
    MenuItem:GetPropertyChangedEvent("Parent"):Connect(function()
        logger:debug("MenuItem",`Parent of {MenuItem.ClassName} '{Name}' changed!`)
        if oldParent then
            local oldE = onMenuChildParentChanged[oldParent]
            if oldE then
                oldE(MenuItem)
            end
        end if Classes:IsA(MenuItem.Parent,"Menu") then
            Frame.Parent = MenuItem.Parent.MenuFrame
            oldParent = MenuItem.Parent
            local newE = onMenuNewChild[MenuItem.Parent]
            if newE then
                newE(MenuItem)
            end
        else MenuItem.Parent = nil
            Frame.Parent = nil
            oldParent = nil
        end
    end) local OnDestroy = Instance.new("BindableEvent")
    MenuItem.Destroyed = OnDestroy.Event
    MenuItem:SetReadOnly("Destroyed")
    function MenuItem:Destroy()
        MenuItem.Parent = nil
        MenuItem:SetReadOnly("Parent")
        OnDestroy:Fire()
        Frame:Destroy()
    end
    return MenuItem
end MenuItemRefreshSizeBind:Bind(function(MenuItem)
    if not MenuItem then logger:critical_error("MenuItemRefreshSizeBind","MenuItem is incorrect") MenuItem = Classes:CreateMenuItem() end
    logger:debug("MenuItemRefreshSizeBind",`Updating Size for {MenuItem.Name}[{MenuItem.ClassName}]`)
    local Frame = MenuItem.Frame
    if Frame then
        local TextObject:TextLabel|TextButton? = MenuItem.TextObject
        if TextObject then
            local GetTextBoundsParams = Instance.new("GetTextBoundsParams")
            GetTextBoundsParams.Width = MenuGUI.AbsoluteSize.X*MenuItem.MaxXSize.Scale+MenuItem.MaxXSize.Offset
            GetTextBoundsParams.Font = TextObject.FontFace
            GetTextBoundsParams.RichText = TextObject.RichText
            GetTextBoundsParams.Text = TextObject.Text
            GetTextBoundsParams.Size = TextObject.TextSize
            local offset = TextService:GetTextBoundsAsync(GetTextBoundsParams)
            Frame.Size = UDim2.new(1,0,0,offset.Y+1)
            return offset.X
        else Frame.Size = UDim2.new(1,0,0,GuiSize.MenuItemYSize)
        end
    end return 0
end) MenuItemRefreshPositionBind:Bind(function(MenuItem,pos:UDim,k)
    if not MenuItem then logger:critical_error("MenuItemRefreshPositionBind","MenuItem is incorrect") MenuItem = Classes:CreateMenuItem() end
    if not MenuItem.Visible then return pos end
    logger:debug("MenuItemRefreshPositionBind",`Updating Position for {MenuItem.Name}[{MenuItem.ClassName}]`)
    MenuItem.Frame.Position = UDim2.new(UDim.new(0,0),pos)
    return pos+MenuItem.Frame.Size.Y
end) UIS.InputBegan:Connect(function(event)
    if event.UserInputType==Enum.UserInputType.MouseButton1 then
        MenuCloseEvent:Fire(false)
    elseif event.UserInputType==Enum.UserInputType.MouseButton2 then
        MenuCloseEvent:Fire(false)
    elseif event.UserInputType==Enum.UserInputType.MouseButton3 then
        MenuCloseEvent:Fire(false)
    elseif event.UserInputType==Enum.UserInputType.Touch then
        MenuCloseEvent:Fire(false)
    elseif event.UserInputType==Enum.UserInputType.Keyboard then
        MenuCloseEvent:Fire(true)
    end
end) function Classes:CreateMenuButton(Name:string,Title:{[string]:string}|string?,disableTextColorChanged:boolean?)
    local Item = Classes:CreateMenuItem(Name,Title)
    Item:AddClassName("MenuButton")
    local Button = Instance.new("TextButton",Item.Frame)
    Button.Size = UDim2.new(1,0,1,0)
    Button.TextWrapped = true
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.TextSize = GuiSize.MenuItemTextSize
    GuiSize:GetPropertyChangedEvent("MenuItemTextSize"):Connect(function()
        Button.TextSize = GuiSize.MenuItemTextSize
        Item:RefreshSize()
    end) Item.Frame.BackgroundTransparency = 1
    local SColors = Classes:CreateSpecialColors()
    SColors:GetColorChangedSignal("MenuItemBackgroundColor"):Connect(function()
        Button.BackgroundColor3 = SColors:GetColor("MenuItemBackgroundColor")
    end) Button.BackgroundColor3 = SColors:GetColor("MenuItemBackgroundColor")
    if not disableTextColorChanged then
        SColors:GetColorChangedSignal("MenuItemTextColor"):Connect(function()
            Button.TextColor3 = SColors:GetColor("MenuItemTextColor")
        end) Button.TextColor3 = SColors:GetColor("MenuItemTextColor")
    end Item.Title.TranslateValueChanged:Connect(function()
        Button.Text = Item.Title:Translate()
        Item:RefreshSize()
    end) Button.Text = Item.Title:Translate()
    Item.Button = Button
    Item:SetReadOnly("Button")
    Item.TextObject = Button
    Item:SetReadOnly("TextObject")
    Item:RefreshSize()
    local Activated = Instance.new("BindableEvent")
    Item.Activated = Activated.Event
    Item:SetReadOnly("Activated")
    Item.CloseMenuOnActivated = true
    function Item:EmulateActivate()
        if Item.CloseMenuOnActivated then
            local parent:{Close:(self:any)->()} = Item.Parent
            if parent then
                parent:Close()
            end
        end Activated:Fire()
    end Button.Activated:Connect(function()
        Item:EmulateActivate()
    end) return Item
end function Classes:CreateMenuText(Name:string,Title:{[string]:string}|string?)
    local Item = Classes:CreateMenuItem(Name,Title)
    Item:AddClassName("MenuText")
    local TextLabel = Instance.new("TextLabel",Item.Frame)
    TextLabel.Size = UDim2.new(1,0,1,0)
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextSize = GuiSize.MenuTextTextSize
    GuiSize:GetPropertyChangedEvent("MenuItemTextSize"):Connect(function()
        TextLabel.TextSize = GuiSize.MenuTextTextSize
        Item:RefreshSize()
    end) TextLabel.BackgroundTransparency = 1
    local SColors = Classes:CreateSpecialColors()
    SColors:GetColorChangedSignal("MenuTextTextColor"):Connect(function()
        TextLabel.TextColor3 = SColors:GetColor("MenuTextTextColor")
    end) TextLabel.TextColor3 = SColors:GetColor("MenuTextTextColor")
    Item.Title.TranslateValueChanged:Connect(function()
        TextLabel.Text = Item.Title:Translate()
        Item:RefreshSize()
    end) TextLabel.Text = Item.Title:Translate()
    Item.TextLabel = TextLabel
    Item:SetReadOnly("Button")
    Item.TextObject = TextLabel
    Item:SetReadOnly("TextObject")
    Item:RefreshSize()
    return Item
end function Classes:CreateMenuToggle(Name:string,Title:{[string]:string}|string?)
    local Item = Classes:CreateMenuButton(Name,Title,true)
    Item:AddClassName("MenuToggle")
    local SColors = Item.SpecialColors
    Item.CloseMenuOnActivated = false
    Item.Value = false
    local function UpdateColor()
        if Item.Value then
            Item.Button.TextColor3 = SColors:GetColor("MenuToggleEnabledColor")
        else Item.Button.TextColor3 = SColors:GetColor("MenuToggleDisabledColor")
        end
    end UpdateColor()
    SColors:GetColorChangedSignal("MenuToggleEnabledColor"):Connect(function()
        if Item.Value then UpdateColor() end
    end) SColors:GetColorChangedSignal("MenuToggleDisabledColor"):Connect(function()
        if not Item.Value then UpdateColor() end
    end) Item:GetPropertyChangedEvent("Value"):Connect(function()
        UpdateColor()
    end) Item.Activated:Connect(function()
        Item.Value = not Item.Value
    end) return Item
end

State.SayEnabled = true
State.Saying:Load({ -- #LANG_REQUIRED
    ru="Загрузка ядра [Создание GUI классов]...",
    uk="Завантаження ядра [Створення класів GUI]...",
    en="Loading core [Creating GUI classes]..."
}) State.OpenEnabled = true
logger:info("GUI Created!")
-- #FIND_POINT GuiObjects
local GuiObjects = Classes:CreateTClass()
GuiObjects:AddClassName("GuiObjects")
TimGui.GuiObjects = GuiObjects
table.insert(TimGuiReadOnly,"GuiObjects")
-- #FIND_POINT GUIArchitecture
local onNewChildListeners,onDescendantChangedListeners = {},{}
local writeSameModeExcludeForTGuiObjects = {"Parent"}
local VisibleBind = Classes:CreateBind()
Binder.VisibleBind = VisibleBind
Binder:SetReadOnly("VisibleBind")
-- local fullyRefresh = Instance.new("BindableEvent")
local ButtonPositionBind = Classes:CreateBind()
Binder.ButtonPositionBind = ButtonPositionBind
Binder:SetReadOnly("ButtonPositionBind")
local SizeBind = Classes:CreateBind()
Binder.SizeBind = SizeBind
Binder:SetReadOnly("SizeBind")
local GGPositionsBind = Classes:CreateBind()
Binder.GlobalGroupRefreshPosition = GGPositionsBind
Binder:SetReadOnly("GlobalGroupRefreshPosition")
local GGSizeBind = Classes:CreateBind()
Binder.GlobalGroupRefreshSize = GGSizeBind
Binder:SetReadOnly("GlobalGroupRefreshSize")
local RefreshingBind = Classes:CreateBind()
Binder.RefreshingBind = RefreshingBind
Binder:SetReadOnly("RefreshingBind")
local function MakeGUIArchitectureClass(raw:{any?}?)
    if type(raw)~="table" then raw={} end
    local children = {}
    local function FindFirstChild(childName:string)
        for _,v in children do
            if v.Name==childName then
                return v
            end
        end
    end local GUIArchitecture = Classes:CreateTClass(raw,{
        __index=function(_,k)
            if k=="__type" then return "TClass" end
            if raw[k]~=nil then return raw[k] end
            local child = FindFirstChild(k)
            if child then return child end
            if table.find(writeSameModeExcludeForTGuiObjects,k) then return end
            logger:critical_error(k..' is not valid member of "'..raw.ClassName..'"')
        end
    },writeSameModeExcludeForTGuiObjects) GUIArchitecture:AddClassName("GUIArchitecture")
    local onNewChild = Classes:CreateTEvent()
    local onChildRemoved = Classes:CreateTEvent()
    GUIArchitecture.ChildAdded = onNewChild.Event
    GUIArchitecture:SetReadOnly("ChildAdded")
    GUIArchitecture.ChildRemoved = onChildRemoved.Event
    GUIArchitecture:SetReadOnly("ChildRemoved")
    onNewChildListeners[GUIArchitecture] = function(child)
        child.LastRefreshingPos = UDim2.new(0,0,0,0)
        table.insert(children,child)
        child.Position = #children
        onNewChild:Fire(child)
    end onDescendantChangedListeners[GUIArchitecture] = function(child)
        for k,v in children do
            if v==child then
                table.remove(children,k)
            end
        end GUIArchitecture:RefreshGroup(child)
        onChildRemoved:Fire(child)
    end function GUIArchitecture:FindFirstChild(childName:string)
        return FindFirstChild(childName)
    end function GUIArchitecture:GetChildren()
        local res = {}
        for _,child in children do
            table.insert(res,child)
        end return res
    end function GUIArchitecture:CreateGroup(Name:string?,Title:string|{[string]: string}?)
        return GuiObjects:CreateGroup(Name,Title,GUIArchitecture)
    end GUIArchitecture.IsGlobal = true
    local lastRefreshed,waitRefresh = false,false
    local onRefreshed = Instance.new("BindableEvent")
    GUIArchitecture.GroupRefreshed = onRefreshed.Event
    GUIArchitecture:SetReadOnly("GroupRefreshed")
    local SpecialRefreshingBind = Classes:CreateBind()
    GUIArchitecture.SpecialRefreshingBind = SpecialRefreshingBind
    GUIArchitecture:SetReadOnly("SpecialRefreshingBind")
    GUIArchitecture.GroupFrame = ButtonsSFrame
    SpecialRefreshingBind:Bind(function(...)
        return RefreshingBind:Run(...)
    end) GUIArchitecture.GroupSize = UDim2.new(0,0,0,0)
    function GUIArchitecture:RefreshGroup(FromObject:any?,notParentRefreshing:boolean?)
        logger:debug("GUIArchitecture","running "..GUIArchitecture.ClassName..":RefreshGroup()")
        if waitRefresh then
            if waitRefresh==true or waitRefresh==FromObject then
                return
            elseif waitRefresh.Position<FromObject.Position then
                return
            elseif waitRefresh.Id<FromObject.Id then
                return
            end logger:debug("GUIArchitecture","dropping last refresh request")
        end if lastRefreshed then waitRefresh = FromObject or true
            RunService.RenderStepped:Wait()
            if waitRefresh~=(FromObject or true) then return end
            waitRefresh = false
        end lastRefreshed = true
        logger:debug("GUIArchitecture","Refreshing "..GUIArchitecture.ClassName.."!")
        table.sort(children,function(a,b)
            if a.Position~=b.Position then
                return a.Position<b.Position
            else return a.Id<b.Id
            end
        end) GUIArchitecture.GroupSize = SpecialRefreshingBind:Run(self:GetChildren(),FromObject)
        if Classes:IsA(GUIArchitecture,"TGuiObject") and not notParentRefreshing then
            if Classes:IsA(GUIArchitecture.Parent,"GUIArchitecture") and GUIArchitecture.Parent~=TimGui.Groups then
                GUIArchitecture.Parent:RefreshGroup(GUIArchitecture)
            end
        end onRefreshed:Fire()
        RunService.RenderStepped:Once(function()
            lastRefreshed = false
        end)
    end SpecialRefreshingBind.OnBinded:Connect(function()
        logger:debug("GUIArchitecture","new special refresh bind! Refreshing.")
        GUIArchitecture:RefreshGroup()
    end) RefreshingBind.OnBinded:Connect(function()
        logger:debug("GUIArchitecture","new refresh bind! Refreshing.")
        GUIArchitecture:RefreshGroup()
    end) GUIArchitecture:GetPropertyChangedEvent("GroupFrame"):Connect(function()
        for _,v in children do
            v.Frame.Parent = GUIArchitecture.GroupFrame
        end
    end)
    return GUIArchitecture
end local LastTGuiObjectId = 0
local function TGuiObjectClass(Name:string,Title:string|{string}?,Parent:any?,Object:any?)
    if type(Name)~="string" then logger:critical_error("TGuiObjectClass","Name is incorrect.") end
    if type(Title)~="table" then
        Title = Classes:CreateTranslator(Title or Name)
    else if Title.__type~="TClass" then
            local oldTitle = Title
            Title = Classes:CreateTranslator("...")
            Title:Load(oldTitle)
        elseif not Title:IsA("Translator") then
            Title = Classes:CreateTranslator("...")
        end
    end if type(Object)~="table" then Object = Classes:CreateTClass(nil,nil,writeSameModeExcludeForTGuiObjects) end
    task.spawn(function() task.wait()
        Title.Default = Title:GetPreset()
    end) LastTGuiObjectId += 1
    local currentId = LastTGuiObjectId
    local destroyed = false
    Object.LastRefreshingPos = UDim2.new(0,0,0,0)
    Object.Type = "Unknown"
    Object:AddClassName("TGuiObject")
    Object.Name = Name
    Object.Title = Title
    Object:SetReadOnly("Title")
    Object.Indent = UDim2.new(0,0,0,0)
    Object.Id = currentId
    Object:SetReadOnly("Id")
    Object.Position = 0
    function Object:GetGlobalGroup()
        local obj = Object
        while Classes:IsA(obj.Parent,"GUIArchitecture") do
            if obj.Parent.Parent==TimGui.Groups then
                return obj.Parent,obj
            end obj = obj.Parent
        end
    end local destroyingEvent = Instance.new("BindableEvent")
    Object.Destroying = destroyingEvent.Event
    Object:SetReadOnly("Destroying")
    function Object:Destroy()
        Object.Frame:Destroy()
        Object.Parent = nil
        destroyed = true
        Object:SetReadOnly("Parent")
        destroyingEvent:Fire()
        Object.ConfigSavingEnabled = false
        Object.ConfigSaveName = "Destroyed"
        Object:SetReadOnly("ConfigSavingEnabled")
        Object:SetReadOnly("ConfigSaveName")
        Object.Menu:Destroy()
    end -- TGuiObject Special colors
    local SpecialColors = Classes:CreateSpecialColors()
    Object.SpecialColors = SpecialColors
    Object:SetReadOnly("SpecialColors")
    -- TGuiObject UI: Frame + UICorner
    local Frame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner",Frame)
    GuiSize:GetPropertyChangedEvent("ButtonCornerRadius"):Connect(function()
        if Object.CornerChangingEnabled then
            UICorner.CornerRadius = GuiSize.ButtonCornerRadius
        end
    end) UICorner.CornerRadius = GuiSize.ButtonCornerRadius
    Object.UICorner = UICorner
    Object:SetReadOnly("UICorner")
    Object.CornerChangingEnabled = true
    Object.GlobalName = ""
    task.spawn(function() task.wait()
        if Object.GlobalName=="" then
            local parentName = "NONE/"
            if Classes:IsA(Parent,"GUIArchitecture") then
                local obj = Parent
                parentName = ""
                while obj do
                    if obj:IsA("TGuiObject") then
                        parentName = obj.Name.."/"..parentName
                        obj = obj.Parent
                        continue
                    elseif obj==TimGui.Groups then
                        parentName = "GROUPS/"..parentName
                    else parentName = "UNKNOWN/"..parentName
                    end break
                end
            end Object.GlobalName = parentName..Name
        end Object:SetReadOnly("GlobalName")
    end)
    SpecialColors:GetColorChangedSignal("ButtonBackground"):Connect(function()
        Frame.BackgroundColor3 = SpecialColors:GetColor("ButtonBackground")
    end) Frame.BackgroundColor3 = SpecialColors:GetColor("ButtonBackground")
    Object:GetPropertyChangedEvent("GlobalName"):Connect(function()
        Frame.Name = Object.GlobalName
    end) Frame.Name = Object.GlobalName
    Object.Frame = Frame
    Object:SetReadOnly("Frame")
    local Menu = Classes:CreateMenu()
    Object.Menu = Menu
    Object:SetReadOnly("Menu")
    local OpenMenuBind = Classes:CreateBind()
    OpenMenuBind:Bind(function(...)
        Menu:Open(UDim2.new(0,LocalMouse.X,0,LocalMouse.Y))
        return true
    end) Object.OpenMenuBind = OpenMenuBind
    function Object:OpenMenu()
        OpenMenuBind:Run()
    end
    Object:SetReadOnly("OpenMenuBind")
    local SBind = Classes:CreateBind()
    SBind:Bind(function(...)
        return SizeBind:Run(...)
    end) function Object:RefreshSize(dontRefreshPos:boolean?)
        if destroyed then return end
        logger:debug("TGuiObjectClass","Refreshing size for "..Object.Name.." ["..Object.Type.."]")
        SBind:Run(self)
        if not dontRefreshPos then
            self:RefreshPosition()
        end
    end SBind.OnBinded:Connect(function()
        Object:RefreshSize()
    end) SizeBind.OnBinded:Connect(function()
        Object:RefreshSize()
    end) GuiSize:GetPropertyChangedEvent("ButtonSize"):Connect(function()
        Object:RefreshSize()
    end) Object.SpecialSizeBind = SBind
    Object:SetReadOnly("SpecialSizeBind")
    -- #FIND_POINT Refreshing Positions on TGuiObject
    local SpecialButtonPositionBind = Classes:CreateBind()
    SpecialButtonPositionBind:Bind(function(...)
        return ButtonPositionBind:Run(...)
    end) Object.SpecialButtonPositionBind = SpecialButtonPositionBind
    Object:SetReadOnly("SpecialButtonPositionBind")
    function Object:RefreshPosition() if destroyed then return end
        logger:debug("TGuiObjectClass","Refreshing position for "..Object.Name.." ["..Object.Type.."]")
        if Classes:IsA(Object.Parent,"GUIArchitecture") then
            Object.Parent:RefreshGroup(Object)
        end
    end Object:GetPropertyChangedEvent("Position"):Connect(function()
        logger:debug("TGuiObject.PositionChanged","Property Position of '"..Object.Name.."' ["..Object.Type.."] changed")
        Frame.LayoutOrder = Object.Position
        Object:RefreshPosition()
    end) Object:GetPropertyChangedEvent("Indent"):Connect(function()
        logger:debug("TGuiObject.IndentChanged","Property Indent of '"..Object.Name.."' ["..Object.Type.."] changed")
        Object:RefreshPosition()
    end)
    -- #FIND_POINT visibling
    Object.Visible = true
    local specialVisibleBind = Classes:CreateBind()
    specialVisibleBind:Bind(function(...)
        return VisibleBind:Run(...)
    end) Object.SpecialVisibleBind = specialVisibleBind
    Object:SetReadOnly("SpecialVisibleBind")
    function Object:RefreshVisible()
        if destroyed then return end
        local visible = Object.Visible
        if visible then
            visible = specialVisibleBind:Run(Object)
        end Frame.Visible = visible
        logger:debug("TGuiObject","Refreshing visible for "..Object.Name.." ["..Object.Type.."]")
    end specialVisibleBind.OnBinded:Connect(function()
        Object:RefreshVisible()
    end) VisibleBind.OnBinded:Connect(function()
        Object:RefreshVisible()
    end)
    -- #FIND_POINT PARENT on TGuiObject
    local oldParent
    Object:GetPropertyChangedEvent("Parent"):Connect(function()
        if destroyed then return end
        local newParent = Object.Parent
        Object.Frame.Parent = nil
        if Classes:IsA(newParent,"TClass") then
            if newParent==TimGui.Groups then
                Object.Frame.Parent = GroupsSFrame
            elseif newParent:IsA("GUIArchitecture") then
                Object.Frame.Parent = newParent.GroupFrame
            else Object.Parent = nil
                return
            end
        else Object.Parent = nil
            return
        end logger:debug("TGuiObject.NewParent","New parent "..newParent.ClassName.." of '"..Object.Name.."' ["..Object.Type.."]")
        if oldParent and onDescendantChangedListeners[oldParent] then
            onDescendantChangedListeners[oldParent](Object)
        end if newParent then
            if onNewChildListeners[Object.Parent] then
                oldParent = Object.Parent
                onNewChildListeners[Object.Parent](Object)
            else Object.Position = 0
            end Object:RefreshVisible()
            Object:RefreshSize()
        end oldParent = newParent
    end) task.spawn(function() task.wait()
        if Classes:IsA(Parent,"GUIArchitecture") then
            logger:debug("TGuiObjectClass","Setting new parent for new "..Object.Type.." '"..Object.Name.."'")
            Object.Parent = Parent
        end
    end) Object = Classes:AddConfigObject(Object)
    local defaultSaveDelay = Object.ConfigSavingDelay
    local function updateAutoConfigSave()
        if config.Settings.AutoSaveValues then
            Object.ConfigSavingDelay = defaultSaveDelay
        else Object.ConfigSavingDelay = -1
        end
    end onConfigSettingsChanged.Event:Connect(updateAutoConfigSave)
    updateAutoConfigSave()
    Object:GetPropertyChangedEvent("GlobalName"):Once(function()
        if not Object:GetReadOnly("ConfigSaveName") then
            Object.ConfigSaveName = Object.GlobalName
            Object:SetReadOnly("ConfigSaveName")
        end
    end)
    return Object
end
local function CreateButtonForTGuiObject(TGuiObject,DisableAutoUpdateTextColor:boolean)
    if type(TGuiObject)~="table" or TGuiObject.__type~="TClass" or not TGuiObject:IsA("TGuiObject") then
        logger:critical_error("TGuiObject is incorrect") TGuiObject=TGuiObjectClass() 
    end TGuiObject:AddClassName("ButtonObject")
    TGuiObject.Frame.BackgroundTransparency = 1
    local Button = Instance.new("TextButton",TGuiObject.Frame)
    local destroyed = false
    TGuiObject.Destroying:Connect(function()
        destroyed = true
        Button:Destroy()
    end) Button.Size = UDim2.new(1,0,1,0)
    TGuiObject.Title.TranslateValueChanged:Connect(function()
        Button.Text = TGuiObject.Title:Translate()
    end) Button.Text = TGuiObject.Title:Translate()
    TGuiObject.SpecialColors:GetColorChangedSignal("ButtonBackground"):Connect(function()
        Button.BackgroundColor3 = TGuiObject.SpecialColors:GetColor("ButtonBackground")
    end) Button.BackgroundColor3 = TGuiObject.SpecialColors:GetColor("ButtonBackground")
    if not DisableAutoUpdateTextColor then
        TGuiObject.SpecialColors:GetColorChangedSignal("TextColor"):Connect(function()
            Button.TextColor3 = TGuiObject.SpecialColors:GetColor("TextColor")
        end) Button.TextColor3 = TGuiObject.SpecialColors:GetColor("TextColor")
    end Button.TextScaled = true
    TGuiObject.UICorner.Parent = Button
    TGuiObject.Button = Button
    TGuiObject:SetReadOnly("Button")
    TGuiObject.OpenMenuFromButtonObject = true
    TGuiObject.Menu:CreateMenuText("Just menu",{
        ru="ЭТО МЕНЮ ОБЬЕКТА",
        en="THIS MENU FOR OBJECT"
    }) TGuiObject.Menu:CreateMenuButton("TestButton",{
        ru="А ЭТО КНОПОЧКА",
        en="AND THIS IS BUTTON"
    }) TGuiObject.Menu:CreateMenuToggle("TestToggle",{
        ru="А ЕЩЁ ТУТ ЕСТЬ ПЕРЕКЛЮЧАТЕЛЬ",
        en="AND ALSO THIS IS TOGGLE"
    })
    Button.MouseButton2Click:Connect(function()
        if TGuiObject.OpenMenuFromButtonObject then
            TGuiObject:OpenMenu()
        end
    end)
    local Activated = Instance.new("BindableEvent")
    TGuiObject.Activated = Activated.Event
    Button.Activated:Connect(function()
        Activated:Fire()
    end) function TGuiObject:Activate()
        if destroyed then return end
        logger:debug("ButtonObject: "..TGuiObject.Name.."["..TGuiObject.ClassName.."]","Emulating Activated event.")
        Activated:Fire()
    end TGuiObject:SetReadOnly("Activated")
    return TGuiObject
end local function CopyButtonToTextLabel(Button:TextButton,TextLabel:TextLabel)
    Button:GetPropertyChangedSignal("FontFace"):Connect(function()
        TextLabel.FontFace = Button.FontFace
    end) TextLabel.FontFace = Button.FontFace
    Button:GetPropertyChangedSignal("TextSize"):Connect(function()
        TextLabel.TextSize = Button.TextSize
    end) TextLabel.TextSize = Button.TextSize
    Button:GetPropertyChangedSignal("TextScaled"):Connect(function()
        TextLabel.TextScaled = Button.TextScaled
    end) TextLabel.TextScaled = Button.TextScaled
    Button:GetPropertyChangedSignal("TextWrapped"):Connect(function()
        TextLabel.TextWrapped = Button.TextWrapped
    end) TextLabel.TextWrapped = Button.TextWrapped
    Button:GetPropertyChangedSignal("TextColor3"):Connect(function()
        TextLabel.TextColor3 = Button.TextColor3
    end) TextLabel.TextColor3 = Button.TextColor3
end
-- #FIND_POIND Saving TObjectsToConfig
local TObjectsToConfigs:{[string]:{Object:any,Name:string}} = {}
function Classes:AddConfigObject(TObject,ConfigSaveName:string?,otherClassesSaving:boolean?)
    if not Classes:IsA(TObject,"TClass") then logger:critical_error("Object is incorrect (expected TClass)") TObject = Classes:CreateTClass() end
    TObject:AddClassName("ConfigObject")
    TObject.ConfigSavingEnabled = true
    TObject.ConfigSavingDelay = 0.1
    local savingProperties = {}
    local savingPropertiesDefValues = {}
    local propAutosavingEnabled = {}
    local savingIsNotDouble = false
    local ConfigData = {}
    ConfigData.Object = TObject
    TObject:GetPropertyChangedEvent("ConfigSaveName"):Connect(function()
        if savingIsNotDouble then
            TObjectsToConfigs[ConfigData.Name] = nil
        end ConfigData.Name = TObject.ConfigSaveName
        if not otherClassesSaving then
            ConfigData.Name = table.concat(TObject:GetClassNames(),"/").."/"..ConfigData.Name
        end if TObjectsToConfigs[ConfigData.Name] then
            savingIsNotDouble = false
        else savingIsNotDouble = true
            TObjectsToConfigs[ConfigData.Name] = ConfigData
        end ConfigData.Data = config.Objects[ConfigData.Name] or {}
        TObject:LoadConfigSave()
    end) if type(ConfigSaveName)=="string" then
        TObject.ConfigSaveName = ConfigSaveName
    end onLoadConfigEvent.Event:Connect(function()
        ConfigData.Data = config.Objects[ConfigData.Name] or {}
        TObject:LoadConfigSave()
    end)
    function TObject:IsConfigSavingEnabled()
        return savingIsNotDouble and TObject.ConfigSavingEnabled
    end
    function TObject:IsSavingProperty(PropertyName:string)
        return table.find(savingProperties,PropertyName)~=nil
    end local function Load(PropertyName:string,ResetToDefault:boolean)
        if ResetToDefault==nil then ResetToDefault = true end
        if savingIsNotDouble and TObject.ConfigSavingEnabled then
            local data = TableToRBXValue(ConfigData.Data[PropertyName],true)
            if data==nil and ResetToDefault then
                data = savingPropertiesDefValues[PropertyName]
            end if data~=nil then
                TObject[PropertyName] = data
            end
        end
    end function TObject:LoadConfigSave(PropertyName:string?,ResetToDefault:boolean?)
        if type(PropertyName)=="string" then
            Load(PropertyName,ResetToDefault)
        else for _,prop in savingProperties do
                Load(prop,ResetToDefault)
            end
        end
    end function TObject:IsEnabledAutosaveFor(PropertyName:string)
        if PropertyName==nil then return end
        return propAutosavingEnabled[PropertyName]
    end function TObject:SetEnabledAutosaveFor(PropertyName:string,IsEnabled:boolean)
        if type(PropertyName)~="string" then logger:critical_error("PropertyName is incorrect. String expected") end
        propAutosavingEnabled[PropertyName] = (not IsEnabled)==false
    end local savingFWaiter = false
    local function Save(PropertyName:string,isAuto:boolean)
        local savingE = not TimGui.Closed and savingIsNotDouble and TObject.ConfigSavingEnabled
        if savingE and isAuto then
            savingE = propAutosavingEnabled[PropertyName]
        end if savingE then
            local data = RBXValueToTable(TObject[PropertyName],true)
            if data==savingPropertiesDefValues[PropertyName] then
                data = nil
            end ConfigData.Data[PropertyName] = data
            if savingFWaiter then return end
            savingFWaiter = true
            RunService.RenderStepped:Wait()
            local isEmpty = true
            for _,_ in ConfigData.Data do isEmpty = false break end
            if isEmpty then
                config.Objects[ConfigData.Name] = nil
            else config.Objects[ConfigData.Name] = ConfigData.Data
            end onConfigChanged:Fire()
            savingFWaiter = false
        end
    end
    function TObject:ConfigSave(PropertyName:string)
        if type(PropertyName)=="string" then
            Save(PropertyName,false)
        else for _,prop in savingProperties do
                Save(prop,false)
            end
        end
    end
    function TObject:AddPropertyToConfigSave(PropertyName:string,defaultValue:any?)
        if type(PropertyName)~="string" then logger:critical_error("PropertyName is incorrect. String expected") end
        savingPropertiesDefValues[PropertyName] = defaultValue
        if not table.find(savingProperties,PropertyName) then
            table.insert(savingProperties,PropertyName)
            Load(PropertyName,false)
            propAutosavingEnabled[PropertyName] = true
            local savingPValue = false
            TObject:GetPropertyChangedEvent(PropertyName):Connect(function()
                if TObject.ConfigSavingDelay<0 then return end
                if savingPValue then return end
                savingPValue = true
                task.wait(TObject.ConfigSavingDelay)
                savingPValue = false
                Save(PropertyName,true)
            end)
            return true
        elseif TObject.ConfigSavingDelay>0 then
            Save(PropertyName,true)
        end
    end
    return TObject
end --#FIND_POINT Keybinding in TGuiObjects
local function MakeKeybindingForTGuiObject(Object)
    if not Object then Object = TGuiObjectClass() end
    Object:AddClassName("GuiKeybindingObject")
    Object.Keybinder = TimGui.KeyBinding:CreateKeybinder(Object.Name,Object.Title)
    Object.KeybindingEnabled = true
    Object:SetReadOnly("Keybinder")
    local KButton = Object.Menu:CreateMenuButton("Keybinding",{ --#LANG_REQUIRED
        ru="Привязка к клавише",
        en="Keybinding"
    }) KButton.Activated:Connect(function()
        Object.Keybinder.Opened = true
    end) Object.Destroying:Connect(function()
        Object.Keybinder:Destroy()
    end)
    return Object
end
-- #FIND_POINT TGroups
local GlobalOpenedGroup
local GlobalOpenedGroupChanged = Instance.new("BindableEvent")
TimGui.GlobalOpenedGroupChanged = GlobalOpenedGroupChanged.Event
table.insert(TimGuiReadOnly,"GlobalOpenedGroupChanged")
local GroupOpenArrowBind = Classes:CreateBind()
Binder.GroupOpenArrowBind = GroupOpenArrowBind
Binder:SetReadOnly("GroupOpenArrowBind")
GuiAnimations.EnableArrowGroupAnimation = true
function GuiObjects:CreateGroup(Name:string,Title:string|{[string]:string}?,Parent:any?)
    if type(Name)~="string" then logger:critical_error("CreateGroup","Name is incorrect") end
    logger:debug("GuiObjects:CreateGroup","Creating new group '"..Name.."'")
    local Group = TGuiObjectClass(Name,Title,Parent,MakeGUIArchitectureClass())
    Group = CreateButtonForTGuiObject(Group)
    if not Group then Group = MakeGUIArchitectureClass() end -- For roblox lsp
    Group:AddClassName("TGroup")
    Group.Opened = false
    Group:AddPropertyToConfigSave("Opened",false)
    Group.Type = "Group"
    Group:SetReadOnly("Type")
    local onOpened = Instance.new("BindableEvent")
    local onClose = Instance.new("BindableEvent")
    Group.OnOpen = onOpened.Event
    Group.OnClose = onClose.Event
    Group:SetReadOnly("OnOpen")
    Group:SetReadOnly("OnClose")
    Group:GetPropertyChangedEvent("Parent"):Connect(function()
        local newParent = Group.Parent
        if Classes:IsA(newParent,"GUIArchitecture") then
            Group.IsGlobal = newParent==TimGui.Groups
        else Group.IsGlobal = true
        end
    end) local SpecialGGPositionsBind = Classes:CreateBind()
    SpecialGGPositionsBind:Bind(function(...)
        return GGPositionsBind:Run(...)
    end) Group.SpecialGlobalGroupRefreshPosition = SpecialGGPositionsBind
    Group:SetReadOnly("SpecialGlobalGroupRefreshPosition")
    Group.SpecialButtonPositionBind:Bind(function(...)
        if Group.IsGlobal then
            return SpecialGGPositionsBind:Run(...)
        end
    end) local SpecialGGSizeBind = Classes:CreateBind()
    SpecialGGSizeBind:Bind(function(...)
        return GGSizeBind:Run(...)
    end) Group.SpecialGlobalGroupRefreshSize = SpecialGGSizeBind
    Group:SetReadOnly("SpecialGlobalGroupRefreshSize")
    Group.SpecialSizeBind:Bind(function(...)
        if Group.IsGlobal then
            return SpecialGGSizeBind:Run(...)
        end
    end) local SpecialGroupOpenArrowBind = Classes:CreateBind()
    SpecialGroupOpenArrowBind:Bind(function(...)
        return GroupOpenArrowBind:Run(...)
    end) Group.SpecialGroupOpenArrowBind = SpecialGroupOpenArrowBind
    Group:SetReadOnly("SpecialGroupOpenArrowBind")
    local Frame = Instance.new("Frame",Group.Frame)
    Frame.Position = UDim2.new(0,0,1,0)
    Frame.BackgroundTransparency = 1
    Group:GetPropertyChangedEvent("GroupSize"):Connect(function()
        Frame.Size = UDim2.new(UDim.new(1,0),Group.GroupSize.Y)
    end) Frame.Size = UDim2.new(UDim.new(1,0),Group.GroupSize.Y)
    local GroupFrame = Instance.new("Frame",Frame)
    GroupFrame.BackgroundTransparency = 1
    GroupFrame.Name = "GroupFrame"
    Group.NotGlobalGroupFrame = GroupFrame
    Group:SetReadOnly("NotGlobalGroupFrame")
    local VisibleIndent = Instance.new("Frame",Frame)
    VisibleIndent.Name = "Indent"
    Group.SpecialColors:GetColorChangedSignal("GroupVisibleIndent"):Connect(function()
        VisibleIndent.BackgroundColor3 = Group.SpecialColors:GetColor("GroupVisibleIndent")
    end) VisibleIndent.BackgroundColor3 = Group.SpecialColors:GetColor("GroupVisibleIndent")
    local GroupIndentBind = Classes:CreateBind()
    GroupIndentBind:Bind(function(BGroup,Indent: Frame,GroupF: Frame)
        Indent.Size = UDim2.new(GuiSize.NotGlobalGroupVisibleIndent,UDim.new(1,0))
        Indent.Position = UDim2.new(GuiSize.NotGlobalGroupIndent,UDim.new(0,0))
        local NGGI2 = UDim.new(GuiSize.NotGlobalGroupIndent.Scale*2,GuiSize.NotGlobalGroupIndent.Offset*2)
        GroupF.Size = UDim2.new(UDim.new(1,0)-NGGI2-GuiSize.NotGlobalGroupVisibleIndent,UDim.new(1,0))
        GroupF.Position = UDim2.new(NGGI2+GuiSize.NotGlobalGroupVisibleIndent,UDim.new(0,0))
        return true
    end) Group.GroupIndentBind = GroupIndentBind
    Group:SetReadOnly("GroupIndentBind")
    local lastAbsoluteX
    local function refreshGroup()
        logger:debug("TGroup: refreshTGroup",`Refreshing Indent for {Group.Name}[{Group.ClassName}]`)
        GroupIndentBind:Run(Group,VisibleIndent,GroupFrame)
        if not Group.IsGlobal and lastAbsoluteX~=GroupFrame.AbsoluteSize.X then 
            task.wait() logger:debug("refreshGroup","Refreshing Size for objects")
            for _,v in Group:GetChildren() do
                v:RefreshSize(true)
            end lastAbsoluteX = GroupFrame.AbsoluteSize.X
        end
    end GroupIndentBind.OnBinded:Connect(function()
        refreshGroup()
    end) SpecialGroupOpenArrowBind.OnBinded:Connect(function()
        SpecialGroupOpenArrowBind:Run(Group)
    end) GroupOpenArrowBind.OnBinded:Connect(function()
        SpecialGroupOpenArrowBind:Run(Group)
    end) GuiSize:GetPropertyChangedEvent("NotGlobalGroupIndent"):Connect(function()
        refreshGroup()
    end) GroupFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        refreshGroup()
    end) refreshGroup()
    Group:GetPropertyChangedEvent("Opened"):Connect(function()
        logger:debug("TGroup",`Property Opened changed for {Group.Name}. Is Opened: {Group.Opened}`)
        if Group.IsGlobal then
            if GlobalOpenedGroup==Group then
                Group.Opened = true
                return
            end if Group.Opened then
                local oldGOG = GlobalOpenedGroup
                TimGuiRaw.OpenedGlobalGroup = Group
                GlobalOpenedGroup = Group
                GlobalOpenedGroupChanged:Fire()
                if oldGOG then
                    oldGOG.Opened = false
                end ButtonsSFrame.CanvasSize = Group.GroupSize
            end Frame.Visible = false
        else Frame.Visible = Group.Opened
        end for _,v:{} in Group:GetChildren() do
            v:RefreshVisible()
        end SpecialGroupOpenArrowBind:Run(Group)
        if not Group.IsGlobal then
            Group:RefreshPosition()
        end
    end) Frame.Visible = (Group.Opened and not Group.IsGlobal)
    Group:GetPropertyChangedEvent("GroupSize"):Connect(function()
        if GlobalOpenedGroup==Group then
            ButtonsSFrame.CanvasSize = Group.GroupSize
        end
    end) local OpenImage = Instance.new("ImageLabel",Group.Button)
    OpenImage.Position = UDim2.new(1,0,0.5,0)
    OpenImage.AnchorPoint = Vector2.new(1,0.5)
    OpenImage.Name = "Open"
    Group.OpenLabel = OpenImage
    Group:SetReadOnly("OpenLabel")
    Assets:GetPropertyChangedEvent("GroupOpenArrow"):Connect(function()
        OpenImage.Image = Assets.GroupOpenArrow
    end) OpenImage.Image = Assets.GroupOpenArrow
    Group.SpecialColors:GetColorChangedSignal("GroupOpenArrowColor"):Connect(function()
        OpenImage.ImageColor3 = Group.SpecialColors:GetColor("GroupOpenArrowColor")
    end) OpenImage.ImageColor3 = Group.SpecialColors:GetColor("GroupOpenArrowColor")
    OpenImage.BackgroundTransparency = 1
    local TextLabel = Instance.new("TextLabel",Group.Button)
    TextLabel.BackgroundTransparency = 1
    Group.Button:GetPropertyChangedSignal("Text"):Connect(function()
        TextLabel.Text = Group.Button.Text
    end) TextLabel.Text = Group.Button.Text
    Group.Button.TextTransparency = 1
    CopyButtonToTextLabel(Group.Button,TextLabel)
    local function refreshIsGlobal()
        OpenImage.Visible = not Group.IsGlobal
        if Group.IsGlobal then
            Group.GroupFrame = ButtonsSFrame
            TextLabel.Size = UDim2.new(1,0,1,0)
            Frame.Visible = false
        else local GroupOpenImageSize = UDim.new(0,GuiSize.GroupOpenImageSize.Offset+GuiSize.GroupOpenImageSize.Scale*Group.Button.AbsoluteSize.Y)
            TextLabel.Size = UDim2.new(UDim.new(1,0)-GroupOpenImageSize,UDim.new(1,0))
            OpenImage.Size = UDim2.new(GroupOpenImageSize,GroupOpenImageSize)
            Frame.Visible = Group.Opened
            Group.GroupFrame = GroupFrame
        end refreshGroup()
    end Group:GetPropertyChangedEvent("IsGlobal"):Connect(function()
        if Group.IsGlobal then
            Group.Opened = false
        end refreshIsGlobal() Group:RefreshSize()
    end) GuiSize:GetPropertyChangedEvent("GroupOpenImageSize"):Connect(function()
        refreshIsGlobal()
    end) refreshIsGlobal()
    Group.Activated:Connect(function()
        if Group.IsGlobal then
            Group.Opened = true
        else Group.Opened = not Group.Opened
        end
    end) Group.ConfigSavingForNewGroupObjects = true
    function Group:CreateButton(Name:string?,Title:string|{[string]: string}?,func:(any)->())
        local obj = GuiObjects:CreateButton(Name,Title,Group,func)
        obj.ConfigSavingEnabled = Group.ConfigSavingForNewGroupObjects return obj
    end function Group:CreateToggle(Name:string?,Title:string|{[string]: string}?,func:(any)->())
        local obj = GuiObjects:CreateToggle(Name,Title,Group,func)
        obj.ConfigSavingEnabled = Group.ConfigSavingForNewGroupObjects return obj
    end function Group:CreateText(Name:string?,Title:string|{[string]: string}?)
        local obj = GuiObjects:CreateText(Name,Title,Group)
        obj.ConfigSavingEnabled = Group.ConfigSavingForNewGroupObjects return obj
    end function Group:CreateTextbox(Name:string?,Title:string|{[string]: string}?,func:(any)->())
        local obj = GuiObjects:CreateTextbox(Name,Title,Group,func)
        obj.ConfigSavingEnabled = Group.ConfigSavingForNewGroupObjects return obj
    end function Group:CreateSequence(Name:string?,Title:string|{[string]: string}?,func:(any,{string})->(),Buttons:{[string]: {[string]: string} | string})
        local obj = GuiObjects:CreateSequence(Name,Title,Group,func,Buttons)
        obj.ConfigSavingEnabled = Group.ConfigSavingForNewGroupObjects return obj
    end
    return Group
end 
-- #FIND_POINT TButton
function GuiObjects:CreateButton(Name:string,Title:string|{[string]:string}?,Parent:any?,func:(any)->()?)
    if type(Name)~="string" then logger:critical_error("CreateButton","Name is incorrect") end
    if type(Title)=="function" then func=Title Title=nil end
    if type(Parent)=="function" then func=Parent Parent=nil end
    logger:debug("GuiObjects:CreateButton","Creating new button '"..Name.."'")
    local Button = TGuiObjectClass(Name,Title,Parent)
    Button = MakeKeybindingForTGuiObject(Button)
    Button = CreateButtonForTGuiObject(Button)
    Button:AddClassName("TButton")
    Button.Type = "Button"
    Button:SetReadOnly("Type")
    if type(func)=="function" then
        Button.Activated:Connect(function()
            func(Button)
        end)
    end Button.Keybinder.Event:Connect(function(event:string)
        if event=="activate" then
            Button:Activate()
        end
    end) Button.Keybinder:AddEventType("activate",{ --#LANG_REQUIRED
        ru="Активировать",
        en="Activate"
    })
    return Button
end
-- #FIND_POINT TToggle
local RefreshColorValueBind = Classes:CreateBind()
Binder.TextColorForToggle = RefreshColorValueBind
Binder:SetReadOnly("TextColorForToggle")
GuiAnimations.TextColorForToggleTI = TweenInfo.new(0.5)
GuiAnimations.EnableTextColorForToggleAnimation = true
function GuiObjects:CreateToggle(Name:string,Title:string|{[string]:string}?,Parent:any?,func:(any)->()?)
    if type(Name)~="string" then logger:critical_error("CreateToggle","Name is incorrect") end
    if type(Title)=="function" then func=Title Title=nil end
    if type(Parent)=="function" then func=Parent Parent=nil end
    logger:debug("GuiObjects:CreateButton","Creating new button '"..Name.."'")
    local Button = TGuiObjectClass(Name,Title,Parent)
    Button = MakeKeybindingForTGuiObject(Button)
    Button = CreateButtonForTGuiObject(Button,true)
    Button:AddClassName("TToggle")
    Button.Type = "Toggle"
    Button:SetReadOnly("Type")
    Button.Value = false
    Button:GetPropertyChangedEvent("DefaultValue"):Connect(function()
        Button:AddPropertyToConfigSave("Value",Button.DefaultValue)
    end) Button.DefaultValue = false
    task.spawn(function()
        task.wait() if not Button:GetReadOnly("DefaultValue") then
            Button.DefaultValue = Button.Value
        end
    end) Button.Keybinder.Event:Connect(function(EventType)
        if EventType=="change" then
            Button.Value = not Button.Value
        elseif EventType=="true" then
            Button.Value = true
        elseif EventType=="false" then
            Button.Value = false
        end
    end) Button.Keybinder:AddEventType("change",{ --#LANG_REQUIRED
        ru="Переключить",
        en="Toggle"
    }) Button.Keybinder:AddEventType("true",{ --#LANG_REQUIRED
        ru="Включить",
        en="Enable"
    }) Button.Keybinder:AddEventType("false",{ --#LANG_REQUIRED
        ru="Выключить",
        en="Disable"
    }) local ChangedEvent = Instance.new("BindableEvent")
    local EnabledEvent = Instance.new("BindableEvent")
    local DisabledEvent = Instance.new("BindableEvent")
    Button.Changed = ChangedEvent.Event
    Button.OnTrue = EnabledEvent.Event
    Button.OnFalse = DisabledEvent.Event
    Button:SetReadOnly("Changed")
    Button:SetReadOnly("OnTrue")
    Button:SetReadOnly("OnFalse")
    local SpecialRefreshColorValueBind = Classes:CreateBind()
    Button.SpecialTextColorForToggle = SpecialRefreshColorValueBind
    Button:SetReadOnly("SpecialTextColorForToggle")
    SpecialRefreshColorValueBind:Bind(function(...)
        return RefreshColorValueBind:Run(...)
    end) local function refreshValueColor(NotAnimate:boolean,async:boolean)
        logger:debug("Toggle","Refresh color for Toggle '"..Button.Name.."'")
        SpecialRefreshColorValueBind:Run(Button,not NotAnimate and GuiAnimations.EnableTextColorForToggleAnimation)
    end SpecialRefreshColorValueBind.OnBinded:Connect(refreshValueColor)
    RefreshColorValueBind.OnBinded:Connect(refreshValueColor)
    Button.SpecialColors:GetColorChangedSignal("ToggleTrue"):Connect(function()
        if Button.Value then refreshValueColor() end
    end) Button.SpecialColors:GetColorChangedSignal("ToggleFalse"):Connect(function()
        if not Button.Value then refreshValueColor() end
    end) refreshValueColor(true)
    function Button:RefreshTextColorFromValue(NotAnimate:boolean)
        return refreshValueColor(NotAnimate,true)
    end Button:GetPropertyChangedEvent("Value"):Connect(function()
        ChangedEvent:Fire(Button.Value)
        if Button.Value then
            EnabledEvent:Fire()
        else DisabledEvent:Fire()
        end refreshValueColor()
    end) if type(func)=="function" then
        Button.Changed:Connect(function()
            func(Button)
        end)
    end Button.Activated:Connect(function()
        Button.Value = not Button.Value
    end) return Button
end
-- #FIND_POINT Text
local function MakeTextObject(Text:any)
    if not Text then error("TGuiObject is incorrect.") Text = TGuiObjectClass() end
    local TextLabel = Instance.new("TextLabel",Text.Frame)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextScaled = true
    TextLabel.Size = UDim2.new(1,0,1,0)
    Text.TextLabel = TextLabel
    Text:AddClassName("TextObject")
    Text:SetReadOnly("TextLabel")
    local destroyed = false
    Text.Destroying:Connect(function()
        destroyed = true
        TextLabel:Destroy()
    end) Text.Title.TranslateValueChanged:Connect(function()
        if destroyed then return end
        TextLabel.Text = Text.Title:Translate()
    end) TextLabel.Text = Text.Title:Translate()
    return Text
end
function GuiObjects:CreateText(Name:string,Title:string|{[string]:string}?,Parent:any?)
    if type(Name)~="string" then logger:critical_error("CreateText","Name is incorrect") end
    local Text = TGuiObjectClass(Name,Title,Parent)
    Text:AddClassName("TText")
    Text.Type = "Text"
    Text:SetReadOnly("Type")
    Text.Frame.BackgroundTransparency = 1
    Text = MakeTextObject(Text)
    Text.SpecialColors:GetColorChangedSignal("TTextColor"):Connect(function()
        Text.TextLabel.TextColor3 = Text.SpecialColors:GetColor("TTextColor")
    end) Text.TextLabel.TextColor3 = Text.SpecialColors:GetColor("TTextColor")
    return Text
end
-- #FIND_POINT TextBox
local function MakeTextBoxObject(Object)
    if not Object then error("TGuiObject is incorrect.") Object = TGuiObjectClass() end
    local TextBox = Instance.new("TextBox",Object.Frame)
    TextBox.TextScaled = true
    TextBox.Size = UDim2.new(1,0,1,0)
    TextBox.Text = ""
    TextBox.ClearTextOnFocus = false
    Object.TextBox = TextBox
    Object:SetReadOnly("TextLabel")
    Object.Destroying:Connect(function()
        TextBox:Destroy()
    end) return Object
end local refreshTextBoxBind = Classes:CreateBind()
Binder.RefreshTextBoxSizes = refreshTextBoxBind
Binder:SetReadOnly("RefreshTextBoxSizes")
local numberAllowed = {"1","2","3","4","5","6","7","8","9","0","."}
local numberOperations = {"-","+","(",")","/","*"}
local function getNumber(str:string)
    local num = tonumber(str)
    if not num then
        for _,v in pairs(numberOperations) do
            str = str:gsub("%"..v,v.."0")
        end local s,r = pcall(function()
            return loadstring("return tonumber("..str..")","gettingNumber[TGui-Core]")()
        end) if s and r then
            return r
        end
    end return num or 0
end
local InputTypes = {
    number=function(str:string,inTextBox:boolean,syntaxOnly:boolean)
        local res = ""
        for v in tostring(str):gmatch(".") do
            if table.find(numberAllowed,v) or table.find(numberOperations,v) then
                res = res..v
            end
        end if syntaxOnly then
            return res
        end if inTextBox==true then
            if str=="" then return "" end
        end str = tostring(str)
        res = getNumber(res)
        if inTextBox=="" and res==0 then
            return ""
        end return res
    end, string=tostring
} local ButtonsEnabledForInpType = {"number"}
local ButtonsInpTypeFuncs = {
    number=function(value,scale,buttonType)
        if buttonType=="add" then
            return value+scale
        else return value-scale
        end
    end
}
function GuiObjects:CreateTextbox(Name:string,Title:string|{[string]:string}?,Parent:any?,func:(any)->()?)
    if type(Name)~="string" then logger:critical_error("CreateTextbox","Name is incorrect") end
    if type(Title)=="function" then func=Title Title=nil end
    if type(Parent)=="function" then func=Parent Parent=nil end
    local Textbox = TGuiObjectClass(Name,Title,Parent,Classes:CreateTClass(nil,nil,{"Value","DefaultValue"}))
    Textbox.Type = "TextBox"
    Textbox:SetReadOnly("Type")
    Textbox = MakeTextObject(Textbox)
    Textbox = MakeTextBoxObject(Textbox)
    Textbox:AddClassName("TTextBox")
    Textbox.Value = ""
    Textbox:GetPropertyChangedEvent("DefaultValue"):Connect(function()
        Textbox:AddPropertyToConfigSave("Value",Textbox.DefaultValue)
    end) Textbox.DefaultValue = ""
    task.spawn(function()
        task.wait() if not Textbox:GetReadOnly("DefaultValue") then
            Textbox.DefaultValue = Textbox.Value
        end
    end) Textbox.InputType = "string"
    Textbox:GetPropertyChangedEvent("InputType"):Connect(function()
        if InputTypes[Textbox.InputType] then
            Textbox.DefaultValue = InputTypes[Textbox.InputType](Textbox.DefaultValue,false)
            Textbox.Value = InputTypes[Textbox.InputType](Textbox.Value,false)
        else Textbox.InputType = "string"
        end Textbox.ButtonsEnabled = table.find(ButtonsEnabledForInpType,Textbox.InputType)~=nil
    end) local changedEvent = Instance.new("BindableEvent")
    Textbox.Changed = changedEvent.Event
    Textbox:SetReadOnly("Changed")
    Textbox.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local val = InputTypes[Textbox.InputType](Textbox.TextBox.Text,false)
        if val~=Textbox.Value then
            Textbox.Value = val
        end if Textbox.TextBox:IsFocused() then
            Textbox.TextBox.Text = InputTypes[Textbox.InputType](Textbox.TextBox.Text,true,true)
        end
    end) Textbox.TextBox.FocusLost:Connect(function(input)
        Textbox.TextBox.Text = InputTypes[Textbox.InputType](Textbox.TextBox.Text,true)
    end) Textbox:GetPropertyChangedEvent("Value"):Connect(function()
        if not Textbox.TextBox:IsFocused() then
            Textbox.TextBox.Text = (InputTypes[Textbox.InputType](Textbox.Value,Textbox.TextBox.Text)) or ""
        end local val = InputTypes[Textbox.InputType](Textbox.Value,false)
        if val==Textbox.Value then
            changedEvent:Fire()
        else Textbox.Value = val
        end
    end) local Buttons = Instance.new("Frame",Textbox.Frame)
    Textbox.Buttons = Buttons
    Textbox:SetReadOnly("Buttons")
    Buttons.Visible = false
    local ButtonClicked = Instance.new("BindableEvent")
    Textbox.ButtonClicked = ButtonClicked
    Textbox:SetReadOnly("ButtonClicked")
    function Textbox:FireButton(ButtonType:string)
        if not Textbox.ButtonsEnabled then return end
        local f = ButtonsInpTypeFuncs[Textbox.InputType]
        if f then
            local val = f(Textbox.Value,Textbox.ScaleOfButtons,ButtonType)
            Textbox.Value = val
        end ButtonClicked:Fire(ButtonType)
    end Textbox.ButtonsEnabled = false
    Textbox.ScaleOfButtons = 1
    local AddButton = Instance.new("TextButton",Buttons)
    AddButton.Size = UDim2.new(1,0,0.5,0)
    AddButton.Name = "add"
    AddButton.Text = "+"
    AddButton.TextScaled = true
    Instance.new("UICorner",AddButton).CornerRadius = UDim.new(1,0)
    AddButton.Activated:Connect(function()
        Textbox:FireButton("add")
    end) Textbox.SpecialColors:GetColorChangedSignal("AddButtonBackgroundInTextBoxColor"):Connect(function()
        AddButton.BackgroundColor3 = Textbox.SpecialColors:GetColor("AddButtonBackgroundInTextBoxColor")
    end) AddButton.BackgroundColor3 = Textbox.SpecialColors:GetColor("AddButtonBackgroundInTextBoxColor")
    Textbox.SpecialColors:GetColorChangedSignal("AddButtonTextInTextBoxColor"):Connect(function()
        AddButton.TextColor3 = Textbox.SpecialColors:GetColor("AddButtonTextInTextBoxColor")
    end) AddButton.TextColor3 = Textbox.SpecialColors:GetColor("AddButtonTextInTextBoxColor")
    local SubtractButton = Instance.new("TextButton",Buttons)
    SubtractButton.Position = UDim2.new(0,0,0.5,0)
    SubtractButton.Size = UDim2.new(1,0,0.5,0)
    SubtractButton.Name = "subtract"
    SubtractButton.Text = "-"
    SubtractButton.TextScaled = true
    Instance.new("UICorner",SubtractButton).CornerRadius = UDim.new(1,0)
    SubtractButton.Activated:Connect(function()
        Textbox:FireButton("subtract")
    end) Textbox.SpecialColors:GetColorChangedSignal("SubtractButtonBackgroundInTextBoxColor"):Connect(function()
        SubtractButton.BackgroundColor3 = Textbox.SpecialColors:GetColor("SubtractButtonBackgroundInTextBoxColor")
    end) SubtractButton.BackgroundColor3 = Textbox.SpecialColors:GetColor("SubtractButtonBackgroundInTextBoxColor")
    Textbox.SpecialColors:GetColorChangedSignal("SubtractButtonTextInTextBoxColor"):Connect(function()
        SubtractButton.TextColor3 = Textbox.SpecialColors:GetColor("SubtractButtonTextInTextBoxColor")
    end) SubtractButton.TextColor3 = Textbox.SpecialColors:GetColor("SubtractButtonTextInTextBoxColor")
    -- Colors -----------------
    Textbox.SpecialColors:GetColorChangedSignal("TextColor"):Connect(function()
        Textbox.TextLabel.TextColor3 = Textbox.SpecialColors:GetColor("TextColor")
    end) Textbox.TextLabel.TextColor3 = Textbox.SpecialColors:GetColor("TextColor")
    Textbox.SpecialColors:GetColorChangedSignal("TextBoxBackgroundColor"):Connect(function()
        Textbox.TextBox.BackgroundColor3 = Textbox.SpecialColors:GetColor("TextBoxBackgroundColor")
        Buttons.BackgroundColor3 = Textbox.SpecialColors:GetColor("TextBoxBackgroundColor")
    end) Textbox.TextBox.BackgroundColor3 = Textbox.SpecialColors:GetColor("TextBoxBackgroundColor")
    Buttons.BackgroundColor3 = Textbox.SpecialColors:GetColor("TextBoxBackgroundColor")
    Textbox.SpecialColors:GetColorChangedSignal("TextInTextBoxColor"):Connect(function()
        Textbox.TextBox.TextColor3 = Textbox.SpecialColors:GetColor("TextInTextBoxColor")
    end) Textbox.TextBox.TextColor3 = Textbox.SpecialColors:GetColor("TextInTextBoxColor")
    local specialRefreshTextBoxBind = Classes:CreateBind()
    Textbox.SpecialRefreshTextBoxSizes = specialRefreshTextBoxBind
    Textbox:SetReadOnly("SpecialRefreshTextBoxSizes")
    specialRefreshTextBoxBind:Bind(function(...)
        return refreshTextBoxBind:Run(...)
    end) local function refresh()
        specialRefreshTextBoxBind:Run(Textbox,Textbox.TextLabel,Textbox.TextBox,Buttons)
    end GuiSize:GetPropertyChangedEvent("IndentSizeBetweenInTTextBox"):Connect(refresh)
    GuiSize:GetPropertyChangedEvent("TextBoxSizeInTTextBox"):Connect(refresh)
    GuiSize:GetPropertyChangedEvent("TextSizeInTTextBox"):Connect(refresh)
    Textbox:GetPropertyChangedEvent("ButtonsEnabled"):Connect(function()
        Buttons.Visible = Textbox.ButtonsEnabled refresh()
    end) if type(func)=="function" then
        Textbox.Changed:Connect(function()
            func(Textbox)
        end)
    end refresh() return Textbox
end
-- #FIND_POINT Sequence
local SequenceOpenArrowBind = Classes:CreateBind()
Binder.SequenceOpenArrowBind = SequenceOpenArrowBind
Binder:SetReadOnly("SequenceOpenArrowBind")
local SequenceCreateObject = Classes:CreateBind()
Binder.SequenceCreateObject = SequenceCreateObject
Binder:SetReadOnly("SequenceCreateObject")
function GuiObjects:CreateSequence(Name:string,Title:string|{[string]:string}?,Parent:any?,func:(any,{string})->()?,Buttons:{[string]:{[string]:string}|string}?)
    local Sequence = TGuiObjectClass(Name,Title,Parent)
    Sequence = CreateButtonForTGuiObject(Sequence)
    Sequence:AddClassName("TSequence")
    Sequence.Opened = false
    Sequence.Type = "Sequence"
    Sequence:SetReadOnly("Type")
    local onOpened = Instance.new("BindableEvent")
    local onClose = Instance.new("BindableEvent")
    Sequence.OnOpen = onOpened.Event
    Sequence.OnClose = onClose.Event
    Sequence:SetReadOnly("OnOpen")
    Sequence:SetReadOnly("OnClose")
    Sequence:GetPropertyChangedEvent("Opened"):Connect(function()
        if Sequence.Opened then
            onOpened:Fire()
        else onClose:Fire()
        end
    end) Sequence.Size = UDim2.new(0,0,0,0)
    local Frame = Instance.new("Frame",Sequence.Frame)
    Frame.Position = UDim2.new(0,0,1,0)
    Frame.BackgroundTransparency = 1
    Sequence:GetPropertyChangedEvent("Size"):Connect(function()
        Frame.Size = UDim2.new(UDim.new(1,0),Sequence.Size.Y)
    end) Frame.Size = UDim2.new(UDim.new(1,0),Sequence.Size.Y)
    local SequenceFrame = Instance.new("Frame",Frame)
    SequenceFrame.BackgroundTransparency = 1
    SequenceFrame.Name = "SequenceFrame"
    Sequence.SequenceFrame = SequenceFrame
    Sequence:SetReadOnly("SequenceFrame")
    local VisibleIndent = Instance.new("Frame",Frame)
    VisibleIndent.Name = "Indent"
    Sequence.SpecialColors:GetColorChangedSignal("SequenceVisibleIndent"):Connect(function()
        VisibleIndent.BackgroundColor3 = Sequence.SpecialColors:GetColor("SequenceVisibleIndent")
    end) VisibleIndent.BackgroundColor3 = Sequence.SpecialColors:GetColor("SequenceVisibleIndent")
    local IndentBind = Classes:CreateBind()
    IndentBind:Bind(function(BSequence,Indent: Frame,SequenceF: Frame)
        Indent.Size = UDim2.new(GuiSize.SequenceVisibleIndent,UDim.new(1,0))
        Indent.Position = UDim2.new(GuiSize.SequenceIndent,UDim.new(0,0))
        local SI2 = UDim.new(GuiSize.SequenceIndent.Scale*2,GuiSize.SequenceIndent.Offset*2)
        SequenceF.Size = UDim2.new(UDim.new(1,0)-SI2-GuiSize.SequenceVisibleIndent,UDim.new(1,0))
        SequenceF.Position = UDim2.new(SI2+GuiSize.SequenceVisibleIndent,UDim.new(0,0))
        return true
    end) Sequence.IndentBind = IndentBind
    Sequence:SetReadOnly("IndentBind")
    local function refresh()
        logger:debug("TSequence: refreshTSequence",`Refreshing Indent for {Sequence.Name}[{Sequence.ClassName}]`)
        IndentBind:Run(Sequence,VisibleIndent,SequenceFrame)
    end IndentBind.OnBinded:Connect(refresh)
    Sequence:GetPropertyChangedEvent("Size"):Connect(refresh)
    refresh()
    -- Open/Title ------------------------
    local SpecialOpenArrowBind = Classes:CreateBind()
    SpecialOpenArrowBind:Bind(function(...)
        return SequenceOpenArrowBind:Run(...)
    end) Sequence.SpecialOpenArrowBind = SpecialOpenArrowBind
    Sequence:SetReadOnly("SpecialOpenArrowBind")
    GuiSize:GetPropertyChangedEvent("SequenceVisibleIndent"):Connect(refresh)
    GuiSize:GetPropertyChangedEvent("SequenceIndent"):Connect(refresh)
    local OpenImage = Instance.new("ImageLabel",Sequence.Button)
    OpenImage.Position = UDim2.new(1,0,0.5,0)
    OpenImage.AnchorPoint = Vector2.new(1,0.5)
    OpenImage.Name = "Open"
    Sequence.OpenLabel = OpenImage
    Sequence:SetReadOnly("OpenLabel")
    Assets:GetPropertyChangedEvent("SequenceOpenArrow"):Connect(function()
        OpenImage.Image = Assets.SequenceOpenArrow
    end) OpenImage.Image = Assets.SequenceOpenArrow
    Sequence.SpecialColors:GetColorChangedSignal("SequenceOpenArrowColor"):Connect(function()
        OpenImage.ImageColor3 = Sequence.SpecialColors:GetColor("SequenceOpenArrowColor")
    end) OpenImage.ImageColor3 = Sequence.SpecialColors:GetColor("SequenceOpenArrowColor")
    OpenImage.BackgroundTransparency = 1
    local TextLabel = Instance.new("TextLabel",Sequence.Button)
    TextLabel.BackgroundTransparency = 1
    Sequence.Button:GetPropertyChangedSignal("Text"):Connect(function()
        TextLabel.Text = Sequence.Button.Text
    end) TextLabel.Text = Sequence.Button.Text
    Sequence.Button.TextTransparency = 1
    CopyButtonToTextLabel(Sequence.Button,TextLabel)
    local function refreshSize()
        local OpenImageSize = UDim.new(0,GuiSize.SequenceOpenImageSize.Offset+GuiSize.SequenceOpenImageSize.Scale*Sequence.Button.AbsoluteSize.Y)
        TextLabel.Size = UDim2.new(UDim.new(1,0)-OpenImageSize,UDim.new(1,0))
        OpenImage.Size = UDim2.new(OpenImageSize,OpenImageSize)
    end refreshSize()
    GuiSize:GetPropertyChangedEvent("SequenceOpenImageSize"):Connect(refreshSize)
    Sequence:GetPropertyChangedEvent("Opened"):Connect(function()
        Frame.Visible = Sequence.Opened
        SpecialOpenArrowBind:Run(Sequence)
        Sequence:RefreshPosition()
    end) Frame.Visible = Sequence.Opened
    Sequence.SpecialButtonPositionBind:Bind(function(Seq,...)
        if Seq.Opened then
            return ButtonPositionBind:Run(Seq,...)+Seq.Size
        end
    end) Sequence.Activated:Connect(function()
        Sequence.Opened = not Sequence.Opened
    end) local SpecialCreateObject = Classes:CreateBind()
    Sequence.SpecialCreateObject = SpecialCreateObject
    Sequence:SetReadOnly("SpecialCreateObject")
    local changedEvent = Instance.new("BindableEvent")
    Sequence.SequenceChanged = changedEvent.Event
    Sequence:SetReadOnly("SequenceChanged")
    if type(func)=="function" then
        changedEvent.Event:Connect(function(...)
            func(Sequence,...)
        end)
    end SpecialCreateObject:Bind(function(...)
        return SequenceCreateObject:Run(...)
    end) local buttons:{[string]:{Position:number,
            Button:{SetTitle:(string)->(),SetPosition:(number)->(),GetNextSize:()->(UDim2),Button:Frame,OnNewPosition:RBXScriptSignal}
        }} = {}
    local function getResult()
        local res = {}
        for k,v in buttons do
            table.insert(res,v.Position,k)
        end return res
    end local function CreateButton(Name:string,Translator)
        if not Translator then Translator=Classes:CreateTranslator("...") end
        local pos = #getResult()+1
        local button:{SetTitle:(string)->(),SetPosition:(number)->(),GetNextPos:()->(UDim2),Button:Frame,OnNewPosition:RBXScriptSignal}
            = SpecialCreateObject:Run(Sequence,Name,pos)
        Translator.TranslateValueChanged:Connect(function()
            button.SetTitle(Translator:Translate())
        end) button.SetTitle(Translator:Translate())
        local data = {
            Position=pos,
            Button=button,
            Translator=Translator
        } data.Connection = button.OnNewPosition:Connect(function(NewPos:number)
            Sequence:SetObjectPosition(Name,NewPos)
        end) buttons[Name] = data
        Sequence.Size = button.GetNextPos()
    end function Sequence:SetObjectPosition(Name:string,Position:number)
        if type(Position)~="number" then logger:critical_error("New position is incorrect! Expected number") end
        logger:debug("Sequence:SetObjectPosition","Set new position for "..tostring(Name))
        local thisButton = buttons[Name]
        if thisButton then
            local oldPos = thisButton.Position
            Position = math.clamp(Position,1,#getResult())
            local magn = (oldPos-Position)
            local mult = magn/math.abs(magn)
            local from = math.min(oldPos,Position)
            local to = math.max(oldPos,Position)
            for _,v in buttons do
                local change
                if v==thisButton then
                    change = true
                    v.Position = Position
                elseif (v.Position>from and v.Position<to)or (v.Position==Position) then
                    change = true
                    v.Position += mult
                end if change then
                    v.Button.SetPosition(v.Position)
                end
            end changedEvent:Fire(getResult())
            return true
        else return false
        end
    end function Sequence:AddObject(Name:string,Title:{[string]:string}|string?)
        if type(Name)~="string" then logger:critical_error("Sequence:AddObject","Name is incorrect. Expected string") end
        if buttons[Name] then return false end
        if type(Title)=="string" then
            Title = Classes:CreateTranslator(Title)
        elseif type(Title)=="table" then
            if Title.__type~="TClass" then
                local new = Classes:CreateTranslator(Name)
                new:Load(Title) Title = new
            elseif not Title:IsA("Translator") then
                logger:critical_error("Sequence:AddObject","Title is incorrect")
            end
        else Title = Classes:CreateTranslator(Name)
        end CreateButton(Name,Title)
        return true
    end if type(Buttons)=="table" then 
        for k,v in Buttons do
            Sequence:AddObject(k,v)
        end 
    end return Sequence
end
-- #FIND_POINT Set Binds for Groups/Buttons
local oldPositions = {}
RefreshingBind:Bind(function(children:{any},FromObject:any?)
    local zeroPos = UDim2.new(0,0,0,0)
    local pos = zeroPos
    local needPos
    if Classes:IsA(FromObject,"TGuiObject") then
        logger:debug("RefreshingBind:Bind",`FromObject: {FromObject.Name}.`)
        local oldPos = oldPositions[FromObject]
        needPos = table.find(children,FromObject)
        if oldPos and needPos then
            if oldPos[1]<needPos and oldPos[2]==FromObject.Parent then
                needPos = oldPos[1]
            end
        end
    end for k,v in children do
        if needPos then
            if needPos>k then
                if v.LastRefreshingPos~=zeroPos then
                    pos = v.LastRefreshingPos
                end continue
            elseif pos==zeroPos then
                logger:debug("RefreshingBind:Bind","Zero pos restart without FromObject")
                return RefreshingBind:Run(children)
            end
        end oldPositions[v] = {k,v.Parent}
        logger:debug("RefreshingBind:Bind",`Set new pos to {v.Name}`)
        pos = v.SpecialButtonPositionBind:Run(v,pos)
        v.LastRefreshingPos = pos
    end return pos
end) SizeBind:Bind(function(TGuiObject)
    if not TGuiObject then logger:critical_error("TGuiObject is incorrect. Expected: TGuiObject") TGuiObject=TGuiObjectClass() end 
    local Frame = TGuiObject.Frame
    if Frame and Frame.Parent then
        local ASizeX:number = Frame.Parent.AbsoluteSize.X
        local ASizeY:number = ButtonsSFrame.AbsoluteSize.X
        local BSize = GuiSize.ButtonSize
        Frame.Size = UDim2.fromOffset(BSize.X.Offset+BSize.X.Scale*ASizeX,BSize.Y.Offset+BSize.Y.Scale*ASizeY)
        return true
    end
end) GGSizeBind:Bind(function(TGuiObject)
    if not TGuiObject then logger:critical_error("TGuiObject is incorrect. Expected: TGuiObject") TGuiObject=TGuiObjectClass() end 
    local Frame = TGuiObject.Frame
    if Frame and Frame.Parent then
        local ASize:number = GroupsSFrame.AbsoluteSize
        local BSize = GuiSize.ButtonSize
        Frame.Size = UDim2.fromOffset(BSize.X.Offset+BSize.X.Scale*ASize.X,BSize.Y.Offset+BSize.Y.Scale*ASize.Y)
        return true
    end
end) VisibleBind:Bind(function(Object:any)
    local visible
    if Classes:IsA(Object.Parent,"TGroup") then
        visible = Object.Parent.Opened
    else if Object.Parent==TimGui.Groups then
            visible = Object:IsA("TGroup")
        else visible = false
        end
    end return visible
end)
local function setNewPosition(TGuiObject,pos:UDim2)
    if not TGuiObject then logger:critical_error("TGuiObject is incorrect. Expected: TGuiObject") TGuiObject=GuiObjects:CreateGroup() end
    local Frame:Frame = TGuiObject.Frame
    if Frame and Frame.Parent then
        local thisPos = UDim2.new(pos.X,UDim.new(0,0))
        local Size = Frame.Size
        local AP = Frame.AnchorPoint
        AP = Vector2.new(1-AP.X,1-AP.Y)
        local posAndSize = pos+UDim2.new(Size.X.Scale*AP.X,Size.X.Offset*AP.X,Size.Y.Scale*AP.Y,Size.Y.Offset*AP.Y)
        if (posAndSize.X.Offset)>1 then
            thisPos = UDim2.new(UDim.new(0,0),pos.Y)
        else local globalX = Frame.Parent.AbsoluteSize.X
            local thisGlobalX = globalX*posAndSize.X.Scale +posAndSize.X.Offset
            if thisGlobalX>globalX then
                thisPos = UDim2.new(UDim.new(0,0),pos.Y)
            end
        end Frame.Position = thisPos
        logger:debug("ButtonPositionBind:Bind",`Position for '{TGuiObject.Name}' [{TGuiObject.Type}]: {thisPos}`)
        local add = Frame.Size
        return pos+add --Сделать если не вмещается в бок то в низ
    else return pos
    end
end
ButtonPositionBind:Bind(function(TGuiObject,pos)
    pos = setNewPosition(TGuiObject,pos)
    if TGuiObject:IsA("TGroup") and TGuiObject.Opened then
        pos += TGuiObject.GroupSize
    end return pos
end)
GGPositionsBind:Bind(setNewPosition)
-- Types -----------
refreshTextBoxBind:Bind(function(Object,TextLabel:TextLabel,TextBox:TextBox,Buttons:Frame)
    TextLabel.Size = GuiSize.TextSizeInTTextBox
    TextBox.Position = UDim2.new(GuiSize.TextSizeInTTextBox.X,UDim.new(0,0))+GuiSize.IndentSizeBetweenInTTextBox
    TextBox.Size = GuiSize.TextBoxSizeInTTextBox
    if not Object.ButtonsEnabled then
        TextBox.Size += UDim2.new(GuiSize.ButtonsSizeInTTextBox.X,UDim.new(0,0))
    end Buttons.Size = GuiSize.ButtonsSizeInTTextBox
    Buttons.Position = UDim2.new((GuiSize.TextSizeInTTextBox+GuiSize.TextBoxSizeInTTextBox).X,UDim.new(0,0))
    return true
end)
GuiAnimations.GroupOpenArrowTI = GuiAnimations.ArrowRotateTI
local LastGroupTweens = {}
GroupOpenArrowBind:Bind(function(Group:table)
    if not Group then Group = GuiObjects:CreateGroup() end
    local rotation
    local Arrow = Group.OpenLabel
    if Group.Opened then
        rotation = 180
    else rotation = 360
    end local LastGArrowTween = LastGroupTweens[Group]
    if GuiAnimations.EnableArrowGroupAnimation then
        Arrow.Rotation = rotation-180
        if LastGArrowTween then LastGArrowTween:Cancel() end
        LastGArrowTween = TweenService:Create(Arrow,GuiAnimations.GroupOpenArrowTI,{Rotation=rotation})
        LastGArrowTween:Play()
        LastGArrowTween.Completed:Once(function()
            LastGroupTweens[Group] = nil
        end) LastGroupTweens[Group] = LastGArrowTween
    else Arrow.Rotation = rotation
    end return true
end)
local LastSequenceTweens = {}
GuiAnimations.SequenceOpenArrowTI = GuiAnimations.GroupOpenArrowTI
GuiAnimations.ArrowSequenceAnimationEnabled = true
SequenceOpenArrowBind:Bind(function(Seq:table)
    if not Seq then Seq = GuiObjects:CreateSequence() end
    local rotation
    local Arrow = Seq.OpenLabel
    if Seq.Opened then
        rotation = 180
    else rotation = 360
    end local LastArrowTween = LastSequenceTweens[Seq]
    if GuiAnimations.ArrowSequenceAnimationEnabled then
        Arrow.Rotation = rotation-180
        if LastArrowTween then LastArrowTween:Cancel() end
        LastArrowTween = TweenService:Create(Arrow,GuiAnimations.SequenceOpenArrowTI,{Rotation=rotation})
        LastArrowTween:Play()
        LastArrowTween.Completed:Once(function()
            LastSequenceTweens[Seq] = nil
        end) LastSequenceTweens[Seq] = LastArrowTween
    else Arrow.Rotation = rotation
    end return true
end)
local LastToggleTweens = {}
RefreshColorValueBind:Bind(function(Toggle,Animate:boolean)
    if not Toggle then error("TToggle is incorrect") Toggle=GuiObjects:CreateToggle() end
    local color if Toggle.Value then
        color = Toggle.SpecialColors:GetColor("ToggleTrue")
    else color = Toggle.SpecialColors:GetColor("ToggleFalse")
    end local LastTween = LastToggleTweens[Toggle]
    if Animate then
        if LastTween then LastTween:Cancel() end
        LastTween = TweenService:Create(Toggle.Button,GuiAnimations.TextColorForToggleTI,{TextColor3=color})
        LastTween:Play()
        LastToggleTweens[Toggle] = LastTween
        LastTween.Completed:Once(function()
            LastToggleTweens[Toggle] = nil
        end)
    else Toggle.Button.TextColor3 = color
    end return true
end)
SequenceCreateObject:Bind(function(Seq,Name:string,Position:number)
    if not Seq then error("Sequence is incorrect!") Seq = GuiObjects:CreateSequence() end
    local buttonResult = {}
    local positionChanged = Instance.new("BindableEvent")
    local button = Instance.new("Frame",Seq.SequenceFrame)
    local TextLabel = Instance.new("TextLabel",button)
    TextLabel.Size = UDim2.new(1,0,1,0)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextScaled = true
    TextLabel.BackgroundTransparency = 1
    local Grab = Instance.new("ImageLabel",button)
    Grab.Position = UDim2.new(1,0,1,0)
    Grab.AnchorPoint = Vector2.new(1,1)
    --Grab.BackgroundTransparency = 1
    local dragging = false
    local dragDetector = Instance.new("UIDragDetector",Grab)
    local notGrabPos = button.Position
    dragDetector.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable
    local startInput
    local ZChanger = 1
    local function addZIndex(add:number)
        button.ZIndex += add
        for _,v:GuiBase2d in button:GetDescendants() do
            if v:IsA("GuiBase2d") then
                v.ZIndex += add
            end
        end
    end
    dragDetector.DragStart:Connect(function(input)
        startInput = input
        dragging = true
        addZIndex(ZChanger)
    end)
    dragDetector.DragContinue:Connect(function(input)
        local delta = input-startInput
        local Y = UDim.new(0,math.clamp(notGrabPos.Y.Offset+delta.Y,0,Seq.SequenceFrame.AbsoluteSize.Y))
        button.Position = UDim2.new(notGrabPos.X,Y)
    end)
    dragDetector.DragEnd:Connect(function()
        dragging = false
        local needPos = GuiSize.SequenceObjectSize.Y.Offset
        positionChanged:Fire(math.ceil(button.Position.Y.Offset/needPos+0.5))
        button.Position = notGrabPos
        addZIndex(-ZChanger)
    end)
    Seq.SpecialColors:GetColorChangedSignal("SequenceObjectsBackgroundColor"):Connect(function()
        button.BackgroundColor3 = Seq.SpecialColors:GetColor("SequenceObjectsBackgroundColor")
    end) button.BackgroundColor3 = Seq.SpecialColors:GetColor("SequenceObjectsBackgroundColor")
    Seq.SpecialColors:GetColorChangedSignal("SequenceObjectsTextColor"):Connect(function()
        TextLabel.TextColor3 = Seq.SpecialColors:GetColor("SequenceObjectsTextColor")
    end) TextLabel.TextColor3 = Seq.SpecialColors:GetColor("SequenceObjectsTextColor")
    local function refresh()
        local SeqObjS = GuiSize.SequenceObjectSize
        local Size = UDim2.new(SeqObjS.X,UDim.new(0,SeqObjS.Y.Offset+(SeqObjS.Y.Scale*ButtonsSFrame.AbsoluteSize.Y)))
        button.Size = Size 
        if not dragging then local pos = Position-1
            button.Position = UDim2.new(0,0,Size.Y.Scale*pos,Size.Y.Offset*pos)
            notGrabPos = button.Position 
            dragDetector.DragUDim2 = UDim2.new(0,0,0,0)
        end local SOGS = GuiSize.SequenceObjectGrabSize
        local grabSize = UDim.new(0,SOGS.Offset+SOGS.Scale*button.AbsoluteSize.Y)
        Grab.Size = UDim2.new(grabSize,grabSize)
        TextLabel.Size = UDim2.new(UDim.new(1,0)-grabSize,UDim.new(1,0))
    end GuiSize:GetPropertyChangedEvent("SequenceObjectSize"):Connect(refresh)
    refresh() buttonResult.Button = button
    GuiSize:GetPropertyChangedEvent("SequenceObjectGrabSize"):Connect(refresh)
    function buttonResult.SetPosition(Pos:number)
        Position = Pos refresh()
    end function buttonResult.SetTitle(Title:string)
        TextLabel.Text = Title
    end function buttonResult.GetNextPos()
        return notGrabPos+button.Size ::UDim2
    end buttonResult.OnNewPosition = positionChanged.Event
    return buttonResult
end)
-- #FIND_POINT Saves --------------------
State.Saying:Load{ -- #LANG_REQUIRED
    ru="Загрузка ядра: Загружаю сохранения/конфигурации",
    en="Loading core: Loading saves/configs",
    uk="Завантаження ядра: Завантажую збереження/конфігурації"
}
local Saves = Classes:CreateTClass()
Saves:AddClassName("Saves")
TimGui.Saves = Saves
table.insert(TimGuiReadOnly,"Saves")
Saves.BaseDir = "TimGuiV3/"
if type(TimGui.SetupData.SavesBaseDir)=="string" then
    Saves.BaseDir = TimGui.SetupData.SavesBaseDir
end if string.sub(Saves.BaseDir,string.len(Saves.BaseDir))~="/" then
    Saves.BaseDir = Saves.BaseDir.."/"
end Saves:SetReadOnly("BaseDir")
local ScriptDataPath = Saves.BaseDir.."ScriptData/"
local GlobalSavesPath = Saves.BaseDir.."Saves/"
local ConfigsPath = Saves.BaseDir.."Configs/"
local PackagesPath = Saves.BaseDir.."Packages/"
local SavesIsSupported,err = pcall(function()
    logger:info("Testing saves")
    makefolder(Saves.BaseDir)
	makefolder(GlobalSavesPath)
	makefolder(ConfigsPath)
    makefolder(PackagesPath)
	writefile(Saves.BaseDir.."Test","If you reading this, it means saves are working!")
	logger:info("Saves test",readfile(Saves.BaseDir.."Test"))
    logger:debug("Saves test","Is file:"..tostring(isfile(Saves.BaseDir.."Test")))
	print("FILES:\n",table.unpack(listfiles(Saves.BaseDir)))
	delfile(Saves.BaseDir.."Test")
end) Saves.IsSupported = SavesIsSupported
Saves:SetReadOnly("IsSupported")
if not SavesIsSupported then
    logger:warn("Error on test saves",err)
else logger:info("Saves working!")
end local function sanitizeFilename(name:string)
    if type(name)~="string" then return end
    local sanitized = name:gsub('[\\/:*?"<>|]', " "):gsub("  "," ")
    sanitized = sanitized:gsub("^%.+", ""):gsub("%.+$", "")
    sanitized = sanitized:match("^%s*(.-)%s*$")
    if sanitized=="" then
        return
    end return sanitized
end local SavesInstances = {}
function Saves:GetSave(Name:string)
    Name = sanitizeFilename(Name)
    if Name then
        if SavesInstances[Name] then return SavesInstances[Name] end
        local save = Classes:CreateTClass()
        save:AddClassName("Save")
        local path = GlobalSavesPath..Name
        local data = {}
        if SavesIsSupported and isfile(path) then
            local s,r = pcall(function()
                return HttpService:JSONDecode(readfile(path))
            end) if s then
                data = r
            else logger:error("Saves:GetGlobalSave","Error to get global save: "..tostring(r).."\n Save path: "..path)
            end
        end function save:GetFromSave(key:string)
            return data[key]
        end function save:SetToSave(key:string,value)
            if type(value)=="table" and value.__have_timgui_metatable then return end
            data[key] = value
            if SavesIsSupported then
                writefile(path,HttpService:JSONEncode(data))
            end
        end save.Name = Name
        save:SetReadOnly("Name")
        local cfgData = config.Saves[Name]or {}
        onLoadConfigEvent.Event:Connect(function()
            cfgData = config.Saves[Name]or {}
        end) function save:GetFromConfig(key:string)
            return cfgData[key]
        end function save:SetToConfig(key:string,value)
            if type(value)=="table" and value.__have_timgui_metatable then return end
            cfgData[key] = value
            local cleared = true for _ in cfgData do cleared = false end
            if cleared then
                config.Saves[Name]=nil
            else config.Saves[Name]=cfgData
            end onConfigChanged:Fire()
        end SavesInstances[Name] = save
        return save
    end
end local SettingsSave = Saves:GetSave("TGuiSettings")
-- #FIND_POINT Configs -------------------------
local Configs = Classes:CreateTClass()
Configs:AddClassName("Configs")
TimGui.Configs = Configs
table.insert(TimGuiReadOnly,"Configs")
local ControlCfg = Classes:CreateTClass()
ControlCfg:AddClassName("ControlCfg")
local loadedConfig
function Configs:GetLoadedName()
    return loadedConfig
end Configs.OnLoaded = onLoadConfigEvent.Event
Configs:SetReadOnly("OnLoaded")
Configs.OnConfigDataChanged = onConfigChanged.Event
Configs:SetReadOnly("OnConfigDataChanged")
local OnConfigListChanged = Instance.new("BindableEvent")
local CFGList = {}
onConfigChanged.Event:Connect(function()
    if SavesIsSupported and loadedConfig then
        local path = ConfigsPath..loadedConfig
        if not table.find(CFGList,loadedConfig) then
            table.insert(CFGList,loadedConfig)
            OnConfigListChanged:Fire()
        end writefile(path,HttpService:JSONEncode(config))
    end
end)
function ControlCfg:GetConfigData(Name:string)
    Name = sanitizeFilename(Name)
    if Name and SavesIsSupported then
        local path = ConfigsPath..Name
        if isfile(path) then local data
            local s,cfg = pcall(function()
                data = readfile(path)
                return HttpService:JSONDecode(data)
            end) 
            if s then
                local function loadNonError(data,def)
                    for k,v in def do
                        if type(data[k])~=type(v) then
                            if type(v)=="table" then
                                data[k] = table.clone(v)
                            else data[k] = v
                            end
                        elseif type(v)=="table" then
                            loadNonError(data[k],v)
                        end
                    end return data
                end return loadNonError(cfg,table.clone(DefaultConfig))
            else logger:error("GetConfigData","Error to load "..Name..":\n"..tostring(cfg))
                print(data)
            end
        end
    end
end if SavesIsSupported then
    for k,v:string in listfiles(ConfigsPath) do
        local vv = v:gsub("\\","/"):split("/")
        CFGList[k] = vv[#vv]
    end
end function ControlCfg:GetList()
    return table.clone(CFGList)
end logger:info("ConfigList",ControlCfg:GetList())
function ControlCfg:GetEmpty()
    local clone
    function clone(tab)
        local res = {}
        for k,v in tab do
            if type(v)=="table" then
                res[k] = clone(v)
            else res[k] = v
            end
        end return res
    end return clone(DefaultConfig)
end
function ControlCfg:Load(Name:string)
    if Name==nil then
        loadedConfig = Name
        config = table.clone(DefaultConfig)
        SettingsSave:SetToSave("LoadedConfig",nil)
        onConfigSettingsChanged:Fire()
        onLoadConfigEvent:Fire(Name)
        logger:info("ControlCfg:Load","Loading default config")
        return
    end Name = sanitizeFilename(Name)
    if Name then
        if SavesIsSupported then
            loadedConfig = Name
            logger:info("ControlCfg:Load","Loading '"..Name.."'")
            config = ControlCfg:GetConfigData(Name) or ControlCfg:GetEmpty()
            SettingsSave:SetToSave("LoadedConfig",Name)
            onConfigSettingsChanged:Fire()
            onLoadConfigEvent:Fire(Name)
        end return true
    end
end ControlCfg.OnConfigListChanged = OnConfigListChanged.Event
ControlCfg:SetReadOnly("OnConfigListChanged")
function ControlCfg:Create(Name:string)
    Name = sanitizeFilename(Name)
    if SavesIsSupported and Name then
        local path = ConfigsPath..Name
        if not isfile(path) then
            local s,err = pcall(function()
                writefile(path,"{}")
            end) if not s then
                logger:error("ControlCfg:Create","Error to create cfg:\n"..tostring(err))
            else table.insert(CFGList,Name)
                OnConfigListChanged:Fire()
            end return s
        end
    end
end local OnConfigDeleted = Instance.new("BindableEvent")
ControlCfg.OnConfigDeleted = OnConfigDeleted.Event
ControlCfg:SetReadOnly("OnConfigDeleted")
function ControlCfg:Delete(Name:string)
    Name = sanitizeFilename(Name)
    if SavesIsSupported and Name then
        local path = ConfigsPath..Name
        if isfile(path) then
            delfile(path)
            local cfgPos = table.find(CFGList,Name)
            if cfgPos then table.remove(CFGList,cfgPos) end
            if loadedConfig==Name then
                ControlCfg:Load("Default")
            end OnConfigListChanged:Fire()
            OnConfigDeleted:Fire(Name)
        end
    end
end
local cfg = SettingsSave:GetFromSave("LoadedConfig")
if not cfg then
    cfg = "Default"
    ControlCfg:Create(cfg)
end
ControlCfg:Load(cfg)
-- #FIND_POINT CLASS TWindow ------------------
local WindowSizeRefresh = Classes:CreateBind()
Binder.TWindowSizeRefresh = WindowSizeRefresh
Binder:SetReadOnly("TWindowSizeRefresh")
local HideArrowAnimation = Classes:CreateBind()
Binder.TWindowHideArrowAnimation = HideArrowAnimation
Binder:SetReadOnly("TWindowHideArrowAnimation")
local WindowsFolder = Instance.new("Folder",STGui)
WindowsFolder.Name = "Windows"
local function addZIndexToFrame(Frame:Frame,add:number)
    Frame.ZIndex += add
    for _,v:GuiBase2d in Frame:GetDescendants() do
        if v:IsA("GuiBase2d") then
            v.ZIndex += add
        end
    end
end local FocusedWindow
function Classes:CreateTWindow(Name:string,Title:string|{[string]:string}?,disableDefaultConfigSettingsRefresh:boolean?)
    if type(Name)~="string" then logger:critical_error("Classes:CreateTWindow","Name is incorrect. Expected string") end
    if type(Title)~="table" then
        Title = Classes:CreateTranslator(Title or Name)
    else if Title.__type~="TClass" then
            local oldTitle = Title
            Title = Classes:CreateTranslator(Name)
            Title:Load(oldTitle)
        elseif not Title:IsA("Translator") then
            Title = Classes:CreateTranslator(Name)
        end
    end logger:debug("Classes:CreateTWindow","Creating window: "..Name)
    local Window = Classes:AddConfigObject(Classes:CreateTClass())
    task.spawn(function()
        task.wait()
        if not Window:GetReadOnly("ConfigSaveName") then
            Window.ConfigSaveName = Name
            Window:SetReadOnly("ConfigSaveName")
            Window:AddPropertyToConfigSave("Position",Window.Position)
        end
    end) if not disableDefaultConfigSettingsRefresh then
        local defaultSaveDelay = Window.ConfigSavingDelay
        local function refreshConfig()
            Window.ConfigSavingEnabled = config.Settings.SaveWindows
            if config.Settings.AutoSaveWindows then
                Window.ConfigSavingDelay = defaultSaveDelay
            else Window.ConfigSavingDelay = -1
            end
        end refreshConfig()
        onConfigSettingsChanged.Event:Connect(refreshConfig) 
    end Window:AddClassName("TWindow")
    Window.Title = Title
    Window:SetReadOnly("Title")
    Window.Name = Name
    Window:SetReadOnly("Name")
    Window.Opened = true
    Window.Hidden = false
    Window.CanHide = true
    Window.UserCanClose = true
    Window:AddPropertyToConfigSave("Hidden", Window.Hidden)
    local SpecialColors = Classes:CreateSpecialColors()
    Window.SpecialColors = SpecialColors
    Window:SetReadOnly("SpecialColors")
    local WindowFrame = Instance.new("Frame",WindowsFolder)
    WindowFrame.Name = Name
    WindowFrame.AnchorPoint = Vector2.new(0.5,0.5)
    WindowFrame.Position = UDim2.new(0.5,0,0.5,0)
    WindowFrame.BackgroundTransparency = 1
    local focusingZIndexEnabled = false
    WindowFrame.DescendantAdded:Connect(function(Inst:GuiObject)
        if Inst:IsA("GuiObject") then
            if Inst.ZIndex~=WindowFrame.ZIndex then
                local order = (Window.DisplayOrder-1)*2
                if FocusedWindow==Window and focusingZIndexEnabled then
                    order += 1
                end Inst.ZIndex += order
            end
        end
    end) task.spawn(function()
        task.wait() focusingZIndexEnabled = true
    end) Window.DisplayOrder = 1
    local oldDisplayOrder = Window.DisplayOrder
    Window:GetPropertyChangedEvent("DisplayOrder"):Connect(function()
        addZIndexToFrame(WindowFrame,(Window.DisplayOrder-oldDisplayOrder)*2)
        oldDisplayOrder = Window.DisplayOrder
    end)
    Window.WindowFrame = WindowFrame
    Window:SetReadOnly("WindowFrame")
    local HeaderFrame = Instance.new("Frame",WindowFrame)
    HeaderFrame.Name = "Header"
    Window.HeaderFrame = HeaderFrame
    Window:SetReadOnly("HeaderFrame")
    local HeaderUICorner = Instance.new("UICorner",HeaderFrame)
    Window.HeaderUICorner = HeaderUICorner
    Window:SetReadOnly("HeaderUICorner")
    local HeaderDownFrame = Instance.new("Frame",HeaderFrame)
    HeaderDownFrame.Name = "Down"
    HeaderDownFrame.Position = UDim2.new(0,0,0.5,0)
    HeaderDownFrame.Size = UDim2.new(1,0,0.5,0)
    HeaderDownFrame.BorderSizePixel = 0
    Window.HeaderDownFrame = HeaderDownFrame
    Window:SetReadOnly("HeaderDownFrame")
    SpecialColors:GetColorChangedSignal("TWindowHeaderBackgroundColor"):Connect(function()
        HeaderFrame.BackgroundColor3 = SpecialColors:GetColor("TWindowHeaderBackgroundColor")
        HeaderDownFrame.BackgroundColor3 = SpecialColors:GetColor("TWindowHeaderBackgroundColor")
    end) HeaderFrame.BackgroundColor3 = SpecialColors:GetColor("TWindowHeaderBackgroundColor")
    HeaderDownFrame.BackgroundColor3 = SpecialColors:GetColor("TWindowHeaderBackgroundColor")
    local CloseButton = Instance.new("ImageButton",HeaderFrame)
    CloseButton.Name = "Close"
    CloseButton.AnchorPoint = Vector2.new(1,0)
    CloseButton.Activated:Connect(function()
        Window.Opened = false
    end)
    Assets:GetPropertyChangedEvent("CloseTWindow"):Connect(function()
        CloseButton.Image = Assets.CloseTWindow
    end) CloseButton.Image = Assets.CloseTWindow
    CloseButton.MouseEnter:Connect(function()
        CloseButton.BackgroundTransparency = 0
    end) CloseButton.MouseLeave:Connect(function()
        CloseButton.BackgroundTransparency = 1
    end) CloseButton.BackgroundTransparency = 1
    SpecialColors:GetColorChangedSignal("TWindowCloseBackgroundColor"):Connect(function()
        CloseButton.BackgroundColor3 = SpecialColors:GetColor("TWindowCloseBackgroundColor")
    end) CloseButton.BackgroundColor3 = SpecialColors:GetColor("TWindowCloseBackgroundColor")
    SpecialColors:GetColorChangedSignal("TWindowCloseColor"):Connect(function()
        CloseButton.ImageColor3 = SpecialColors:GetColor("TWindowCloseColor")
    end) CloseButton.ImageColor3 = SpecialColors:GetColor("TWindowCloseColor")
    local CloseUICorner = Instance.new("UICorner",CloseButton)
    CloseUICorner.CornerRadius = GuiSize.TWindowHeaderCornerRadius
    Window.CloseButton = CloseButton
    Window:SetReadOnly("CloseButton")
    local SpecialHideArrowAnimation = Classes:CreateBind()
    SpecialHideArrowAnimation:Bind(function(...)
        return HideArrowAnimation:Run(...)
    end) Window.SpecialHideArrowAnimation = SpecialHideArrowAnimation
    Window:SetReadOnly("SpecialHideArrowAnimation")
    local HideButton = Instance.new("ImageButton",HeaderFrame)
    HideButton.Name = "Hide"
    HideButton.AnchorPoint = Vector2.new(1,0)
    HideButton.Position = UDim2.new(1,0,0,0)
    HideButton.Rotation = 180
    HideButton.Activated:Connect(function()
        Window.Hidden = not Window.Hidden
    end)
    Assets:GetPropertyChangedEvent("HideTWindow"):Connect(function()
        HideButton.Image = Assets.HideTWindow
    end) HideButton.Image = Assets.HideTWindow
    HideButton.MouseEnter:Connect(function()
        HideButton.BackgroundTransparency = 0
    end) HideButton.MouseLeave:Connect(function()
        HideButton.BackgroundTransparency = 1
    end) HideButton.BackgroundTransparency = 1
    SpecialColors:GetColorChangedSignal("TWindowHideBackgroundColor"):Connect(function()
        HideButton.BackgroundColor3 = SpecialColors:GetColor("TWindowHideBackgroundColor")
    end) HideButton.BackgroundColor3 = SpecialColors:GetColor("TWindowHideBackgroundColor")
    SpecialColors:GetColorChangedSignal("TWindowHideColor"):Connect(function()
        HideButton.ImageColor3 = SpecialColors:GetColor("TWindowHideColor")
    end) HideButton.ImageColor3 = SpecialColors:GetColor("TWindowHideColor")
    local HideUICorner = Instance.new("UICorner",HideButton)
    HideUICorner.CornerRadius = GuiSize.TWindowHeaderCornerRadius
    Window.HideButton = HideButton
    Window:SetReadOnly("HideButton")
    local Header = Instance.new("Frame",HeaderFrame)
    Header.BackgroundTransparency = 1
    Window.Header = Header
    Window:SetReadOnly("Header")
    local HeaderText = Instance.new("TextLabel",Header)
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left
    HeaderText.BackgroundTransparency = 1
    HeaderText.Size = UDim2.new(1,0,1,0)
    HeaderText.TextScaled = true
    Title.TranslateValueChanged:Connect(function()
        HeaderText.Text = Title:Translate()
    end) HeaderText.Text = Title:Translate()
    SpecialColors:GetColorChangedSignal("TWindowHeaderTextColor"):Connect(function()
        HeaderText.TextColor3 = SpecialColors:GetColor("TWindowHeaderTextColor")
    end) HeaderText.TextColor3 = SpecialColors:GetColor("TWindowHeaderTextColor")
    Window.HeaderText = HeaderText
    Window:SetReadOnly("HeaderText")
    local BackgroundFrame = Instance.new("Frame",WindowFrame)
    BackgroundFrame.Name = "Background"
    BackgroundFrame.AnchorPoint = Vector2.new(0,1)
    BackgroundFrame.Position = UDim2.new(0,0,1,0)
    Window.BackgroundFrame = BackgroundFrame
    Window:SetReadOnly("BackgroundFrame")
    local BackgroundUICorner = Instance.new("UICorner",BackgroundFrame)
    GuiSize:GetPropertyChangedEvent("TWindowCornerRadius"):Connect(function()
        BackgroundUICorner.CornerRadius = GuiSize.TWindowCornerRadius
    end) BackgroundUICorner.CornerRadius = GuiSize.TWindowCornerRadius
    GuiSize:GetPropertyChangedEvent("TWindowHeaderCornerRadius"):Connect(function()
        CloseUICorner.CornerRadius = GuiSize.TWindowHeaderCornerRadius
        HideUICorner.CornerRadius = GuiSize.TWindowHeaderCornerRadius
        HeaderUICorner.CornerRadius = GuiSize.TWindowHeaderCornerRadius
    end) HeaderUICorner.CornerRadius = GuiSize.TWindowHeaderCornerRadius
    Window.BackgroundUICorner = BackgroundUICorner
    Window:SetReadOnly("BackgroundUICorner")
    local BackgroundUpFrame = Instance.new("Frame",BackgroundFrame)
    BackgroundUpFrame.Name = "Up"
    BackgroundUpFrame.BorderSizePixel = 0
    BackgroundUpFrame.Size = UDim2.new(1,0,0.5,0)
    Window.BackgroundUpFrame = BackgroundUpFrame
    Window:SetReadOnly("BackgroundUpFrame")
    SpecialColors:GetColorChangedSignal("TWindowBackgroundColor"):Connect(function()
        BackgroundFrame.BackgroundColor3 = SpecialColors:GetColor("TWindowBackgroundColor")
        BackgroundUpFrame.BackgroundColor3 = SpecialColors:GetColor("TWindowBackgroundColor")
    end) BackgroundFrame.BackgroundColor3 = SpecialColors:GetColor("TWindowBackgroundColor")
    BackgroundUpFrame.BackgroundColor3 = SpecialColors:GetColor("TWindowBackgroundColor")
    local Frame = Instance.new("Frame",BackgroundFrame)
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(1,0,1,0)
    Window.Frame = Frame
    Window:SetReadOnly("Frame")
    local SpecialWindowSizeRefresh = Classes:CreateBind()
    SpecialWindowSizeRefresh:Bind(function(...)
        return WindowSizeRefresh:Run(...)
    end) Window.SpecialTWindowSizeRefresh = SpecialWindowSizeRefresh
    Window:SetReadOnly("SpecialTWindowSizeRefresh")
    Window.Size = UDim2.new(0,250,0,250)
    Window.HeaderSize = GuiSize.TWindowHeaderSize
    local function RefreshSize()
        SpecialWindowSizeRefresh:Run(Window)
    end RefreshSize()
    SpecialWindowSizeRefresh.OnBinded:Connect(RefreshSize)
    WindowSizeRefresh.OnBinded:Connect(RefreshSize)
    Window:GetPropertyChangedEvent("Size"):Connect(RefreshSize)
    Window:GetPropertyChangedEvent("HeaderSize"):Connect(RefreshSize)
    Window:GetPropertyChangedEvent("CanHide"):Connect(function()
        if not Window.CanHide then
            Window.Hidden = false
        end HideButton.Visible = Window.CanHide
        RefreshSize()
    end) Window:GetPropertyChangedEvent("UserCanClose"):Connect(function()
        CloseButton.Visible = Window.UserCanClose
        RefreshSize()
    end) CloseButton.Visible = Window.UserCanClose
    local onOpened = Instance.new("BindableEvent")
    local onClosed = Instance.new("BindableEvent")
    Window.OnOpened = onOpened.Event
    Window.OnClosed = onClosed.Event
    Window:SetReadOnly("OnOpened")
    Window:SetReadOnly("OnClosed")
    local OnMoved = Instance.new("BindableEvent")
    Window.OnMoved = OnMoved.Event
    Window:SetReadOnly("OnMoved")
    function Window:Move(Position:UDim2,AnchorPoint:Vector2)
        if typeof(AnchorPoint)~="Vector2" then AnchorPoint=Vector2.new(0.5,0.5) end
        local anchor = -AnchorPoint
        local Size = WindowFrame.Size
        local pos = Position+UDim2.new(Size.X.Scale*anchor.X,Size.X.Offset*anchor.X,Size.Y.Scale*anchor.Y,Size.Y.Offset*anchor.Y)
        Window.Position = pos
    end Window:GetPropertyChangedEvent("Position"):Connect(function()
        local anchor = WindowFrame.AnchorPoint
        local Size = WindowFrame.Size
        local pos = Window.Position+UDim2.new(Size.X.Scale*anchor.X,Size.X.Offset*anchor.X,Size.Y.Scale*anchor.Y,Size.Y.Offset*anchor.Y)
        WindowFrame.Position = pos
        OnMoved:Fire()
    end) Window:GetPropertyChangedEvent("Size"):Connect(function()
        Window:Move(WindowFrame.Position,WindowFrame.AnchorPoint)
    end) Window:Move(UDim2.new(0.5,0,0.5,0),Vector2.new(0.5,0.5))
    Window:AddPropertyToConfigSave("Position",Window.Position)
    Window:GetPropertyChangedEvent("Opened"):Connect(function()
        WindowFrame.Visible = Window.Opened
        if Window.Opened then
            onOpened:Fire()
            Window.Focused = true
        else onClosed:Fire()
        end
    end) Window:GetPropertyChangedEvent("Hidden"):Connect(function()
        if not Window.CanHide then
            Window.Hidden = false
            return
        end BackgroundFrame.Visible = not Window.Hidden
        HeaderDownFrame.Visible = not Window.Hidden
        Window.SpecialHideArrowAnimation:Run(Window)
        if not Window.Hidden then
            Window.Focused = true
        end
    end) local dragDetector = Instance.new("UIDragDetector",HeaderFrame)
    dragDetector.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable
    local lastInput
    Window.DefaultDragEventsEnabled = true
    local fullInputDelta
    dragDetector.DragStart:Connect(function(input)
        if Window.DefaultDragEventsEnabled then
            lastInput = input
            fullInputDelta = UDim2.new(0,0,0,0)
        end Window.Focused = true
    end) dragDetector.DragContinue:Connect(function(input)
        if Window.DefaultDragEventsEnabled and lastInput then
            local delta = (input-lastInput)/game.Workspace.CurrentCamera.ViewportSize
            local UDim2Delta = UDim2.fromScale(delta.X,delta.Y)
            fullInputDelta += UDim2Delta
            WindowFrame.Position += UDim2Delta
            lastInput = input
        end
    end) dragDetector.DragEnd:Connect(function()
        if fullInputDelta then
            Window.Position += fullInputDelta
        end lastInput = nil
    end) Window.DragDetector = dragDetector
    Window:SetReadOnly("DragDetector")
    local Focused = Instance.new("BindableEvent")
    local FocusLost = Instance.new("BindableEvent")
    Window.OnFocused = Focused.Event
    Window.OnFocusLost = FocusLost.Event
    Window:SetReadOnly("OnFocus")
    Window:SetReadOnly("OnFocusLost")
    Window:GetPropertyChangedEvent("Focused"):Connect(function()
        if Window.Focused then
            local lastFocus = FocusedWindow
            FocusedWindow = Window
            if lastFocus then
                lastFocus.Focused = false
            end addZIndexToFrame(WindowFrame,1)
            Focused:Fire()
        else if FocusedWindow==Window then
                FocusedWindow = nil
            end addZIndexToFrame(WindowFrame,-1)
            FocusLost:Fire()
        end
    end)
    Window.Focused = true
    local isDestroyed = false
    local Destroyed = Instance.new("BindableEvent")
    Window.Destroyed = Destroyed.Event
    Window:SetReadOnly("Destroyed")
    function Window:Destroy()
        if isDestroyed then return end
        isDestroyed = true
        Window.Focused = false
        Window:SetReadOnly("Focused")
        Destroyed:Fire()
        Window.ConfigSavingEnabled = false
        Window.ConfigSaveName = "Destroyed"
        Window:SetReadOnly("ConfigSavingEnabled")
        Window:SetReadOnly("ConfigSaveName")
        WindowFrame:Destroy()
    end return Window
end WindowSizeRefresh:Bind(function(TWindow)
    if not TWindow then logger:critical_error("WindowSizeRefresh","Window is incorrect")TWindow=Classes:CreateTWindow() end
    TWindow.WindowFrame.Size = TWindow.Size+UDim2.new(UDim.new(0,0),TWindow.HeaderSize)
    TWindow.HeaderFrame.Size = UDim2.new(UDim.new(1,0),TWindow.HeaderSize)
    TWindow.BackgroundFrame.Size = UDim2.new(UDim.new(1,0),UDim.new(1,0)-TWindow.HeaderSize)
    local HeaderYSize = TWindow.HeaderFrame.AbsoluteSize.Y
    local buttons = 0
    if TWindow.UserCanClose then
        TWindow.CloseButton.Position = UDim2.new(UDim.new(1,-(HeaderYSize+5)*buttons),UDim.new(0,0))
        TWindow.CloseButton.Size = UDim2.new(0,HeaderYSize,1,0)
        buttons += 1
    end if TWindow.CanHide then
        TWindow.HideButton.Size = UDim2.new(0,HeaderYSize,1,0)
        TWindow.HideButton.Position = UDim2.new(UDim.new(1,-(HeaderYSize+5)*buttons),UDim.new(0,0))
        buttons += 1
    end TWindow.Header.Size = UDim2.new(UDim.new(1,-HeaderYSize*buttons-5),UDim.new(1,0))
    return true
end) GuiAnimations.TWindowHideArrowTI = GuiAnimations.ArrowRotateTI
GuiAnimations.EnableArrowTWindowAnimation = true
local LastTWArrowTweens = {}
HideArrowAnimation:Bind(function(Win:table)
    if not Win then logger:critical_error("Error TWindow is incorrect") Win = Classes:CreateTWindow() end
    local rotation
    local Arrow = Win.HideButton
    if not Win.Hidden then
        rotation = 180
    else rotation = 360
    end local LastArrowTween = LastTWArrowTweens[Win]
    if GuiAnimations.EnableArrowTWindowAnimation then
        Arrow.Rotation = rotation-180
        if LastArrowTween then LastArrowTween:Cancel() end
        LastArrowTween = TweenService:Create(Arrow,GuiAnimations.TWindowHideArrowTI,{Rotation=rotation})
        LastArrowTween:Play()
        LastArrowTween.Completed:Once(function()
            LastTWArrowTweens[Win] = nil
        end) LastTWArrowTweens[Win] = LastArrowTween
    else Arrow.Rotation = rotation
    end return true
end)
-- #FIND_POINT Prompts --------------------------
State.Saying:Load{ -- #LANG_REQUIRED
    ru="Загузка ядра: Загрузка Класса запросов",
    en="Loading core: Loading Prompts class"
}
local Prompts = Classes:CreateTClass()
TimGui.Prompts = Prompts
table.insert(TimGuiReadOnly,"Prompts")
function Classes:CreatePrompt(PromptType:string,Name:string,Title: string | {[string]: string}?,Description:string | {[string]: string}?,disableDefaultConfigSettingsRefresh:boolean?)
    if type(PromptType)~="string" then logger:critical_error("Classes:CreatePrompt","PromptType is incorrect(expected string)") end
    if type(Name)~="string" then logger:critical_error("Classes:CreatePrompt","Name is incorrect(expected string)") end
    if type(Description)~="table" then
        Description = Classes:CreateTranslator(Description or "")
    else if Description.__type~="TClass" then
            local oldTitle = Description
            Description = Classes:CreateTranslator("")
            Description:Load(oldTitle)
        elseif not Description:IsA("Translator") then
            Description = Classes:CreateTranslator("")
        end
    end local Prompt = Classes:CreateTWindow(Name,Title,disableDefaultConfigSettingsRefresh)
    Prompt.Opened = false
    Prompt.DisplayOrder = 2
    Prompt.CanHide = false
    Prompt:AddClassName("Prompt")
    Prompt.Description = Description
    Prompt:SetReadOnly("Description")
    Prompt.Type = PromptType
    Prompt:SetReadOnly("Type")
    local Input = Classes:CreateTEvent()
    Prompt.OnInput = Input.Event
    Prompt:SetReadOnly("OnInput")
    Prompt.Running = false
    function Prompt:EmulateInput(...)
        Input:Fire(...)
        Prompt.Running = false
    end local OnRunned = Classes:CreateTEvent()
    Prompt.OnRun = OnRunned.Event
    Prompt:SetReadOnly("OnRun")
    local RunStopped = Classes:CreateTEvent()
    Prompt.RunStopped = RunStopped.Event
    Prompt:SetReadOnly("RunStopped")
    function Prompt:Run(...)
        if Prompt.Opened then Prompt:EmulateInput() end
        Prompt.Opened = true
        Prompt.Running = true
        OnRunned:Fire(...)
        local value = table.pack(Input.Event:Wait())
        Prompt.Opened = false
        RunStopped:Fire(...)
        return table.unpack(value)
    end
    return Prompt
end local TextPromptDescriptionSizeBind = Classes:CreateBind()
Binder.TextPromptDescriptionSizeBind = TextPromptDescriptionSizeBind
Binder:SetReadOnly("TextPromptDescriptionSizeBind")
function Prompts:CreateTextPrompt(Name:string,Title:string | {[string]: string}?,Description:string | {[string]: string}?,disableDefaultConfigSettingsRefresh:boolean?)
    local Prompt = Classes:CreatePrompt("Text",Name,Title,Description,disableDefaultConfigSettingsRefresh)
    Prompt:AddClassName("TextPrompt")
    local TextBox = Instance.new("TextBox",Prompt.Frame)
    TextBox.TextScaled = true
    TextBox.ClearTextOnFocus = false
    TextBox.Text = ""
    Prompt.TextBox = TextBox
    Prompt:SetReadOnly("TextBox")
    Prompt.OnClosed:Connect(function()
        if Prompt.Running then
            Prompt:EmulateInput()
        end
    end) TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        Prompt.Value = TextBox.Text
    end) Prompt:GetPropertyChangedEvent("Value"):Connect(function()
        if Prompt.Value ~= TextBox.Text then
            TextBox.Text = Prompt.Value
        end
    end) Prompt.Value = TextBox.Text
    local Descript = Instance.new("TextLabel",Prompt.Frame)
    Descript.Text = Prompt.Description:Translate()
    Descript.Name = "Description"
    Prompt.DescriptionSize = GuiSize.TextPromptDescriptionTextSize
    Prompt:GetPropertyChangedEvent("DescriptionSize"):Connect(function()
        Descript.TextSize = Prompt.DescriptionSize
    end) Descript.TextSize = Prompt.DescriptionSize
    Descript.BackgroundTransparency = 1
    Descript.TextWrapped = true
    Prompt.DescriptionLabel = Descript
    Prompt:SetReadOnly("DescriptionLabel")
    local SpecDescriptionSizeBind = Classes:CreateBind()
    SpecDescriptionSizeBind:Bind(function(...)
        return TextPromptDescriptionSizeBind:Run(...)
    end) Prompt.SpecialDescriptionSizeBind = SpecDescriptionSizeBind
    Prompt:SetReadOnly("SpecialDescriptionSizeBind")
    local Buttons = Instance.new("Frame",Prompt.Frame)
    Buttons.Name = "Buttons"
    Buttons.BackgroundTransparency = 1
    Prompt.Buttons = Buttons
    Prompt:SetReadOnly("Buttons")
    local confirmButton = Instance.new("TextButton",Buttons)
    confirmButton.Name = "Confirm"
    confirmButton.AnchorPoint = Vector2.new(1,0)
    confirmButton.Position = UDim2.new(1,0,0,0)
    confirmButton.TextScaled = true
    confirmButton.Activated:Connect(function()
        Prompt:EmulateInput(TextBox.Text)
    end) Prompt.ConfirmButton = confirmButton
    Prompt:SetReadOnly("ConfirmButton")
    local confirmTranslator = Classes:CreateTranslator("Confirm")
    confirmTranslator:Load{ --#LANG_REQUIRED
        ru="Подтвердить",
        en="Confirm"
    } confirmTranslator.TranslateValueChanged:Connect(function()
        confirmButton.Text = confirmTranslator:Translate()
    end) confirmButton.Text = confirmTranslator:Translate()
    Prompt.ConfirmText = confirmTranslator
    Prompt:SetReadOnly("ConfirmText")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowConfirmButtonColor"):Connect(function()
        confirmButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonColor")
    end) confirmButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonColor")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowConfirmButtonTextColor"):Connect(function()
        confirmButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonTextColor")
    end) confirmButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonTextColor")
    Prompt.CancelEnabled = true
    local cancelButton = Instance.new("TextButton",Buttons)
    cancelButton.Name = "Cancel"
    cancelButton.Size = UDim2.new(0.5,0,1,0)
    cancelButton.TextScaled = true
    cancelButton.Activated:Connect(function()
        Prompt:EmulateInput()
    end) Prompt.CancelButton = cancelButton
    Prompt:SetReadOnly("CancelButton")
    local cancelTranslator = Classes:CreateTranslator("Cancel")
    cancelTranslator:Load{ --#LANG_REQUIRED
        ru="Отменить",
        en="Cancel"
    } cancelTranslator.TranslateValueChanged:Connect(function()
        cancelButton.Text = cancelTranslator:Translate()
    end) cancelButton.Text = cancelTranslator:Translate()
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowCancelButtonColor"):Connect(function()
        cancelButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonColor")
    end) cancelButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonColor")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowCancelButtonTextColor"):Connect(function()
        cancelButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonTextColor")
    end) cancelButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonTextColor")
    Prompt.CancelText = cancelTranslator
    Prompt:SetReadOnly("CancelText")
    local function cancelRefresh()
        Prompt.UserCanClose = Prompt.CancelEnabled
        if Prompt.CancelEnabled then
            confirmButton.Size = UDim2.new(0.5,0,1,0)
        else confirmButton.Size = UDim2.new(1,0,1,0)
        end
    end cancelRefresh()
    Prompt:GetPropertyChangedEvent("CancelEnabled"):Connect(cancelRefresh)
    Buttons.BackgroundTransparency = 1
    local SizeRefreshed = Instance.new("BindableEvent")
    Prompt.OnSizeRefreshed = SizeRefreshed.Event
    Prompt:SetReadOnly("OnSizeRefreshed")
    local function refreshSize()
        local YPos:UDim = GuiSize.PromptYIndent
        local xAnch = GuiSize.TextPromptXAnchor
        TextBox.Position = UDim2.new(UDim.new(xAnch,0),YPos)
        TextBox.AnchorPoint = Vector2.new(xAnch,0)
        TextBox.Size = GuiSize.TextBoxPromptSize
        YPos += TextBox.Size.Y
        YPos = SpecDescriptionSizeBind:Run(Prompt,YPos)
        if typeof(YPos)=="UDim" then
            Buttons.Position = UDim2.new(UDim.new(xAnch,0),YPos)
            Buttons.Size = GuiSize.TextPromptButtonsSize
            Buttons.AnchorPoint = Vector2.new(xAnch,0)
            YPos += Buttons.Size.Y
            Prompt.Size = UDim2.new(Prompt.Size.X,YPos+GuiSize.PromptYIndent)
        end SizeRefreshed:Fire()
    end refreshSize()
    TextPromptDescriptionSizeBind.OnBinded:Connect(refreshSize)
    SpecDescriptionSizeBind.OnBinded:Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("PromptYIndent"):Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("TextPromptXAnchor"):Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("TextPromptButtonsSize"):Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("TextBoxPromptSize"):Connect(refreshSize)
    Prompt.Description.TranslateValueChanged:Connect(function()
        Descript.Text = Prompt.Description:Translate()
        refreshSize()
    end)
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowTextBoxBackgroundColor"):Connect(function()
        TextBox.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextBoxBackgroundColor")
    end) TextBox.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextBoxBackgroundColor")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowTextBoxTextColor"):Connect(function()
        TextBox.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextBoxTextColor")
    end) TextBox.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextBoxTextColor")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowTextColor"):Connect(function()
        Descript.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextColor")
    end) Descript.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextColor")
    Prompt.OnRun:Connect(function()
        TextBox.Text = ""
    end)
    return Prompt
end local function DefaultPromptDescSizeF(Prompt,YPos:UDim)
    if not Prompt then logger:critical_error("Prompt is incorrect") Prompt=Prompts:CreateTextPrompt() end
    local desc:TextLabel = Prompt.DescriptionLabel
    local GetTextBoundsParams = Instance.new("GetTextBoundsParams")
    GetTextBoundsParams.Width = desc.AbsoluteSize.X
    GetTextBoundsParams.Font = desc.FontFace
    GetTextBoundsParams.RichText = desc.RichText
    GetTextBoundsParams.Text = desc.Text--.."\n"
    GetTextBoundsParams.Size = desc.TextSize
    local offset = TextService:GetTextBoundsAsync(GetTextBoundsParams)
    local sizeYUdim = UDim.new(0,offset.Y+1)
    if desc.Text=="" then
        sizeYUdim = UDim.new(0,0)
    end desc.Position = UDim2.new(UDim.new(0,0),YPos)
    desc.Size = UDim2.new(UDim.new(1,0),sizeYUdim)
    return desc.Position.Y+sizeYUdim
end TextPromptDescriptionSizeBind:Bind(DefaultPromptDescSizeF)
local ConfirmationPromptDescriptionSizeBind = Classes:CreateBind()
Binder.ConfirmationPromptDescriptionSizeBind = ConfirmationPromptDescriptionSizeBind
Binder:SetReadOnly("ConfirmationPromptDescriptionSizeBind")
function Prompts:CreateConfirmationPrompt(Name:string,Title:string | {[string]: string}?,Description:string | {[string]: string}?,disableDefaultConfigSettingsRefresh:boolean?)
    local Prompt = Classes:CreatePrompt("Confirmation",Name,Title,Description,disableDefaultConfigSettingsRefresh)
    Prompt:AddClassName("ConfirmationPrompt")
    Prompt.OnClosed:Connect(function()
        if Prompt.Running then
            Prompt:EmulateInput()
        end
    end)
    local Descript = Instance.new("TextLabel",Prompt.Frame)
    Descript.Text = Prompt.Description:Translate()
    Descript.Name = "Description"
    Prompt.DescriptionSize = GuiSize.ConfirmPromptDescriptionTextSize
    Prompt:GetPropertyChangedEvent("DescriptionSize"):Connect(function()
        Descript.TextSize = Prompt.DescriptionSize
    end) Descript.TextSize = Prompt.DescriptionSize
    Descript.BackgroundTransparency = 1
    Descript.TextWrapped = true
    Prompt.DescriptionLabel = Descript
    Prompt:SetReadOnly("DescriptionLabel")
    local SpecDescriptionSizeBind = Classes:CreateBind()
    SpecDescriptionSizeBind:Bind(function(...)
        return ConfirmationPromptDescriptionSizeBind:Run(...)
    end) Prompt.SpecialDescriptionSizeBind = SpecDescriptionSizeBind
    Prompt:SetReadOnly("SpecialDescriptionSizeBind")
    local Buttons = Instance.new("Frame",Prompt.Frame)
    Buttons.Name = "Buttons"
    Buttons.BackgroundTransparency = 1
    Prompt.Buttons = Buttons
    Prompt:SetReadOnly("Buttons")
    local confirmButton = Instance.new("TextButton",Buttons)
    confirmButton.Name = "Confirm"
    confirmButton.AnchorPoint = Vector2.new(1,0)
    confirmButton.Position = UDim2.new(1,0,0,0)
    confirmButton.Size = UDim2.new(0.5,0,1,0)
    confirmButton.TextScaled = true
    confirmButton.Activated:Connect(function()
        Prompt:EmulateInput(true)
    end) Prompt.ConfirmButton = confirmButton
    Prompt:SetReadOnly("ConfirmButton")
    local confirmTranslator = Classes:CreateTranslator("Confirm")
    confirmTranslator:Load{ --#LANG_REQUIRED
        ru="Подтвердить",
        en="Confirm"
    } confirmTranslator.TranslateValueChanged:Connect(function()
        confirmButton.Text = confirmTranslator:Translate()
    end) confirmButton.Text = confirmTranslator:Translate()
    Prompt.ConfirmText = confirmTranslator
    Prompt:SetReadOnly("ConfirmText")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowConfirmButtonColor"):Connect(function()
        confirmButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonColor")
    end) confirmButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonColor")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowConfirmButtonTextColor"):Connect(function()
        confirmButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonTextColor")
    end) confirmButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonTextColor")
    Prompt.CancelEnabled = true
    local cancelButton = Instance.new("TextButton",Buttons)
    cancelButton.Name = "Reject"
    cancelButton.Size = UDim2.new(0.5,0,1,0)
    cancelButton.TextScaled = true
    cancelButton.Activated:Connect(function()
        Prompt:EmulateInput(false)
    end) Prompt.RejectButton = cancelButton
    Prompt:SetReadOnly("RejectButton")
    local cancelTranslator = Classes:CreateTranslator("Reject")
    cancelTranslator:Load{ --#LANG_REQUIRED
        ru="Отклонить",
        en="Reject"
    } cancelTranslator.TranslateValueChanged:Connect(function()
        cancelButton.Text = cancelTranslator:Translate()
    end) cancelButton.Text = cancelTranslator:Translate()
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowCancelButtonColor"):Connect(function()
        cancelButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonColor")
    end) cancelButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonColor")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowCancelButtonTextColor"):Connect(function()
        cancelButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonTextColor")
    end) cancelButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonTextColor")
    Prompt.RejectText = cancelTranslator
    Prompt:SetReadOnly("RejectText")
    local function cancelRefresh()
        Prompt.UserCanClose = Prompt.CancelEnabled
    end cancelRefresh()
    Prompt:GetPropertyChangedEvent("CancelEnabled"):Connect(cancelRefresh)
    Buttons.BackgroundTransparency = 1
    local SizeRefreshed = Instance.new("BindableEvent")
    Prompt.OnSizeRefreshed = SizeRefreshed.Event
    Prompt:SetReadOnly("OnSizeRefreshed")
    local function refreshSize()
        local YPos:UDim = GuiSize.PromptYIndent
        local xAnch = GuiSize.ConfirmPromptXAnchor
        YPos = SpecDescriptionSizeBind:Run(Prompt,YPos)
        if typeof(YPos)=="UDim" then
            Buttons.Position = UDim2.new(UDim.new(xAnch,0),YPos)
            Buttons.Size = GuiSize.ConfirmPromptButtonsSize
            Buttons.AnchorPoint = Vector2.new(xAnch,0)
            YPos += Buttons.Size.Y
            Prompt.Size = UDim2.new(Prompt.Size.X,YPos+GuiSize.PromptYIndent)
        end SizeRefreshed:Fire()
    end refreshSize()
    TextPromptDescriptionSizeBind.OnBinded:Connect(refreshSize)
    SpecDescriptionSizeBind.OnBinded:Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("PromptYIndent"):Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("ConfirmPromptXAnchor"):Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("ConfirmPromptButtonsSize"):Connect(refreshSize)
    Prompt.Description.TranslateValueChanged:Connect(function()
        Descript.Text = Prompt.Description:Translate()
        refreshSize()
    end) Prompt.SpecialColors:GetColorChangedSignal("OnTWindowTextColor"):Connect(function()
        Descript.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextColor")
    end) Descript.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextColor")
    return Prompt
end ConfirmationPromptDescriptionSizeBind:Bind(DefaultPromptDescSizeF)
-- KeyBinding ---------------------------------------------
local KeyBinding = Classes:CreateTClass()
KeyBinding:AddClassName("KeyBinding")
TimGui.KeyBinding = KeyBinding
table.insert(TimGuiReadOnly,"KeyBinding")
local KeyEvent = Classes:CreateTEvent()
KeyBinding.KeyEvent = KeyEvent.Event
KeyBinding:SetReadOnly("KeyEvent")
local SpecialKeyEvent = Classes:CreateTEvent()
KeyBinding.SpecialKeyEvent = SpecialKeyEvent.Event
KeyBinding:SetReadOnly("SpecialKeyEvent")
local SpecialKeys = {
    LeftCTRL=Enum.KeyCode.LeftControl,
    RightCTRL=Enum.KeyCode.RightControl,
    LeftShift=Enum.KeyCode.LeftShift,
    RightShift=Enum.KeyCode.RightShift,
    LeftAlt=Enum.KeyCode.LeftAlt,
    RightAlt=Enum.KeyCode.RightAlt,
} ---UIS:IsKeyDown(Enum.KeyCode.LeftControl)
local SpecialKeyName = {
    ["1"]=Enum.KeyCode.One,
    ["2"]=Enum.KeyCode.Two,
    ["3"]=Enum.KeyCode.Three,
    ["4"]=Enum.KeyCode.Four,
    ["5"]=Enum.KeyCode.Five,
    ["6"]=Enum.KeyCode.Six,
    ["7"]=Enum.KeyCode.Seven,
    ["8"]=Enum.KeyCode.Eight,
    ["9"]=Enum.KeyCode.Nine,
    ["0"]=Enum.KeyCode.Zero,
    K1=Enum.KeyCode.KeypadOne,
    K2=Enum.KeyCode.KeypadTwo,
    K3=Enum.KeyCode.KeypadThree,
    K4=Enum.KeyCode.KeypadFour,
    K5=Enum.KeyCode.KeypadFive,
    K6=Enum.KeyCode.KeypadSix,
    K7=Enum.KeyCode.KeypadSeven,
    K8=Enum.KeyCode.KeypadEight,
    K9=Enum.KeyCode.KeypadNine,
    K0=Enum.KeyCode.KeypadZero,
    KEnter=Enum.KeyCode.KeypadEnter,
    KDivide=Enum.KeyCode.KeypadDivide,
    KPeriod=Enum.KeyCode.KeypadPeriod,
    KMultiply=Enum.KeyCode.KeypadMultiply,
    KMinus=Enum.KeyCode.KeypadMinus,
    KPlus=Enum.KeyCode.KeypadPlus,
    KEquals=Enum.KeyCode.KeypadEquals,
} local MouseKeyNames = {"LeftMB","RightMB","MiddleMB"}
local function CreateTKey(KeyCode:Enum.KeyCode,holding:{[string]:boolean},KeyName:string)
    local TKey = Classes:CreateTClass()
    TKey:AddClassName("TKey")
    TKey.IsKeyboardKey = KeyCode~=Enum.KeyCode.Unknown
    TKey.MouseKey = table.find(MouseKeyNames,KeyName) or 0
    TKey.IsMouseKey = TKey.MouseKey~=0
    TKey.KeyName = KeyName
    TKey.KeyCode = KeyCode
    TKey.Holding = holding
    TKey.IsEmpty = not (TKey.IsMouseKey or TKey.IsKeyboardKey)
    TKey:SetReadOnly("IsEmpty")
    TKey:SetReadOnly("IsKeyboardKey")
    TKey:SetReadOnly("IsMouseKey")
    TKey:SetReadOnly("KeyName")
    TKey:SetReadOnly("KeyCode")
    TKey:SetReadOnly("MouseKey")
    TKey:SetReadOnly("Holding")
    local Name = KeyName
    for k,v in holding do
        if v then
            Name = k.." + "..Name
        end
    end TKey.Name = Name
    TKey:SetReadOnly("Name")
    return TKey
end local function tableFind(t,v)
    for k,vv in t do
        if vv==v then
            return k
        end
    end
end function KeyBinding:GetKeyNameFromKeyCode(KeyCode:Enum.KeyCode)
    if typeof(KeyCode)~="EnumItem" then logger:critical_error("KeyBinding:CreateKeyboardKey","KeyCode is incorrect. Expected EnumItem") end
    if KeyCode.EnumType~=Enum.KeyCode then logger:critical_error("KeyBinding:CreateKeyboardKey","KeyCode is incorrect. Expected Enum.KeyCode") end
    local specKeyName = tableFind(SpecialKeyName,KeyCode)
    if specKeyName then
        return specKeyName
    else specKeyName = tableFind(SpecialKeys,KeyCode)
        if specKeyName then
            return specKeyName
        end
    end return KeyCode.Name
end KeyBinding.EventsEnabled = true
KeyBinding.NextBlocked = false
local BeganEvent = Classes:CreateTEvent()
KeyBinding.Began = BeganEvent.Event
KeyBinding:SetReadOnly("Began")
local EndedEvent = Classes:CreateTEvent()
KeyBinding.Ended = EndedEvent.Event
KeyBinding:SetReadOnly("Ended")
local KeyBeganEvent = {}
local KeyEndedEvent = {}
local KeyChangedEvent = {}
local function OnKeyChangedState(Key,gpe)
    if tableFind(SpecialKeys,Key.KeyCode) then
        SpecialKeyEvent:Fire(Key,gpe)
    else local holding = {}
        for k,v in pairs(SpecialKeys) do
            holding[k] = UIS:IsKeyDown(v)
        end local KeyName = KeyBinding:GetKeyNameFromKeyCode(Key.KeyCode)
        if Key.KeyCode==Enum.KeyCode.Unknown then
            if Key.UserInputType==Enum.UserInputType.MouseButton1 then
                KeyName = MouseKeyNames[1]
            elseif Key.UserInputType==Enum.UserInputType.MouseButton2 then
                KeyName = MouseKeyNames[2]
            elseif Key.UserInputType==Enum.UserInputType.MouseButton3 then
                KeyName = MouseKeyNames[3]
            else return
            end
        end local TKey = CreateTKey(Key.KeyCode,holding,KeyName)
        KeyEvent:Fire(TKey,gpe,Key)
        if KeyBinding.NextBlocked then
            KeyBinding.NextBlocked = false
        elseif KeyBinding.EventsEnabled then
            local event
            if Key.UserInputState==Enum.UserInputState.Begin then
                BeganEvent:Fire(TKey,gpe)
                event = KeyBeganEvent[TKey.KeyName]
            elseif Key.UserInputState==Enum.UserInputState.End then
                EndedEvent:Fire(TKey,gpe)
                event = KeyEndedEvent[TKey.KeyName]
            end if event then 
                event:Fire(TKey,gpe)
            end local eventChng = KeyChangedEvent[TKey.KeyName]
            if eventChng then eventChng:Fire(TKey,gpe,Key) end
        end
    end
end UIS.InputBegan:Connect(OnKeyChangedState)
UIS.InputEnded:Connect(OnKeyChangedState)
function KeyBinding:GetKeyBeganEvent(KeyName:string)
    local event = KeyBeganEvent[KeyName]
    if not event then
        event = Classes:CreateTEvent()
        KeyBeganEvent[KeyName] = event
    end return event.Event
end function KeyBinding:GetKeyEndedEvent(KeyName:string)
    local event = KeyEndedEvent[KeyName]
    if not event then
        event = Classes:CreateTEvent()
        KeyEndedEvent[KeyName] = event
    end return event.Event
end function KeyBinding:GetKeyEvent(KeyName:string)
    if type(KeyName)~="string" then logger:critical_error("KeyBinding:GetKeyEvent","KeyName is incorrect. expected string") end
    local event = KeyChangedEvent[KeyName]
    if not event then
        event = Classes:CreateTEvent()
        KeyChangedEvent[KeyName] = event
    end return event.Event
end function KeyBinding:CreateEmptyTKey()
    return CreateTKey(Enum.KeyCode.Unknown,{},"Unknown")
end
function KeyBinding:CreateKeyboardKey(KeyCode:Enum.KeyCode,holding:{[string]:boolean}?)
    if typeof(KeyCode)~="EnumItem" then logger:critical_error("KeyBinding:CreateKeyboardKey","KeyCode is incorrect. Expected EnumItem") end
    if KeyCode.EnumType~=Enum.KeyCode then logger:critical_error("KeyBinding:CreateKeyboardKey","KeyCode is incorrect. Expected Enum.KeyCode") end
    if type(holding)~="table" then holding = {} end
    return CreateTKey(KeyCode,holding,KeyBinding:GetKeyNameFromKeyCode(KeyCode))
end  function KeyBinding:CreateMouseKey(MouseCode:number,holding:{[string]:boolean}?)
    if type(MouseCode)~="number" then logger:critical_error("KeyBinding:CreateMouseKey","MouseCode is incorrect. Expected number") end
    if MouseCode<1 or MouseCode>#MouseKeyNames then logger:critical_error("KeyBinding:CreateMouseKey","MouseCode is incorrect. Expected number range(need be 1-"..#MouseKeyNames..")") end
    if type(holding)~="table" then holding = {} end
    return CreateTKey(Enum.KeyCode.Unknown,holding,table.find(MouseKeyNames,MouseCode))
end
local KeyPromptDescriptionSizeBind = Classes:CreateBind()
Binder.KeyPromptDescriptionSizeBind = KeyPromptDescriptionSizeBind
Binder:SetReadOnly("KeyPromptDescriptionSizeBind")
function Prompts:CreateKeyPrompt(Name:string,Title:string | {[string]: string}?,Description:string | {[string]: string}?,disableDefaultConfigSettingsRefresh:boolean?)
    local Prompt = Classes:CreatePrompt("Key",Name,Title,Description,disableDefaultConfigSettingsRefresh)
    Prompt:AddClassName("KeyPrompt")
    local TextLabel = Instance.new("TextLabel",Prompt.Frame)
    TextLabel.TextScaled = true
    TextLabel.Text = ""
    Prompt.TextLabel = TextLabel
    Prompt:SetReadOnly("TextLabel")
    Prompt.OnClosed:Connect(function()
        if Prompt.Running then
            Prompt:EmulateInput()
        end
    end) local inputed = false
    local noneKeyTranslator = Classes:CreateTranslator("Confirm")
    noneKeyTranslator:Load{ --#LANG_REQUIRED
        ru="Нажми любую кнопку",
        en="Press any key"
    }  Prompt.NoneKeyText = noneKeyTranslator
    Prompt:SetReadOnly("NoneKeyText")
    local KeyTranslator = Classes:CreateTranslator("Confirm")
    KeyTranslator:Load{ --#LANG_REQUIRED
        ru="Выбранная кнопка: %KEY%",
        en="Selected key: %KEY%"
    }  Prompt.KeyText = KeyTranslator
    Prompt:SetReadOnly("KeyText")
    local function updateText()
        if not inputed then
            TextLabel.Text = noneKeyTranslator:Translate()
        else TextLabel.Text = string.gsub(KeyTranslator:Translate(),"%%KEY%%",Prompt.Value.Name)
        end
    end noneKeyTranslator.TranslateValueChanged:Connect(function()
        if not inputed then updateText() end
    end) noneKeyTranslator.TranslateValueChanged:Connect(function()
        if inputed then updateText() end
    end) Prompt.Value = KeyBinding:CreateEmptyTKey()
    Prompt:GetPropertyChangedEvent("Value"):Connect(function()
        inputed = true updateText()
    end)
    local Descript = Instance.new("TextLabel",Prompt.Frame)
    Descript.Text = Prompt.Description:Translate()
    Descript.Name = "Description"
    Prompt.DescriptionSize = GuiSize.TextPromptDescriptionTextSize
    Prompt:GetPropertyChangedEvent("DescriptionSize"):Connect(function()
        Descript.TextSize = Prompt.DescriptionSize
    end) Descript.TextSize = Prompt.DescriptionSize
    Descript.BackgroundTransparency = 1
    Descript.TextWrapped = true
    Prompt.DescriptionLabel = Descript
    Prompt:SetReadOnly("DescriptionLabel")
    local SpecDescriptionSizeBind = Classes:CreateBind()
    SpecDescriptionSizeBind:Bind(function(...)
        return KeyPromptDescriptionSizeBind:Run(...)
    end) Prompt.SpecialDescriptionSizeBind = SpecDescriptionSizeBind
    Prompt:SetReadOnly("SpecialDescriptionSizeBind")
    local Buttons = Instance.new("Frame",Prompt.Frame)
    Buttons.Name = "Buttons"
    Buttons.BackgroundTransparency = 1
    Prompt.Buttons = Buttons
    Prompt:SetReadOnly("Buttons")
    local confirmButton = Instance.new("TextButton",Buttons)
    confirmButton.Name = "Confirm"
    confirmButton.AnchorPoint = Vector2.new(1,0)
    confirmButton.Position = UDim2.new(1,0,0,0)
    confirmButton.Size = UDim2.new(0.5,0,1,0)
    confirmButton.TextScaled = true
    confirmButton.Activated:Connect(function()
        Prompt:EmulateInput(Prompt.Value)
    end) Prompt.ConfirmButton = confirmButton
    Prompt:SetReadOnly("ConfirmButton")
    local confirmTranslator = Classes:CreateTranslator("Confirm")
    confirmTranslator:Load{ --#LANG_REQUIRED
        ru="Подтвердить",
        en="Confirm"
    } confirmTranslator.TranslateValueChanged:Connect(function()
        confirmButton.Text = confirmTranslator:Translate()
    end) confirmButton.Text = confirmTranslator:Translate()
    Prompt.ConfirmText = confirmTranslator
    Prompt:SetReadOnly("ConfirmText")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowConfirmButtonColor"):Connect(function()
        confirmButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonColor")
    end) confirmButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonColor")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowConfirmButtonTextColor"):Connect(function()
        confirmButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonTextColor")
    end) confirmButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowConfirmButtonTextColor")
    local cancelButton = Instance.new("TextButton",Buttons)
    cancelButton.Name = "Cancel"
    cancelButton.Size = UDim2.new(0.5,0,1,0)
    cancelButton.TextScaled = true
    cancelButton.Activated:Connect(function()
        Prompt:EmulateInput()
    end) Prompt.CancelButton = cancelButton
    Prompt:SetReadOnly("CancelButton")
    local cancelTranslator = Classes:CreateTranslator("Cancel")
    cancelTranslator:Load{ --#LANG_REQUIRED
        ru="Отменить",
        en="Cancel"
    } cancelTranslator.TranslateValueChanged:Connect(function()
        cancelButton.Text = cancelTranslator:Translate()
    end) cancelButton.Text = cancelTranslator:Translate()
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowCancelButtonColor"):Connect(function()
        cancelButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonColor")
    end) cancelButton.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonColor")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowCancelButtonTextColor"):Connect(function()
        cancelButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonTextColor")
    end) cancelButton.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowCancelButtonTextColor")
    Prompt.CancelText = cancelTranslator
    Prompt:SetReadOnly("CancelText")
    Buttons.BackgroundTransparency = 1
    local Notify = Instance.new("TextLabel",Prompt.Frame)
    Notify.TextScaled = true
    Notify.Text = ""
    Notify.BackgroundTransparency = 1
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowHintTextColor"):Connect(function()
        Notify.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowHintTextColor")
    end) Notify.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowHintTextColor")
    local SizeRefreshed = Instance.new("BindableEvent")
    Prompt.OnSizeRefreshed = SizeRefreshed.Event
    Prompt:SetReadOnly("OnSizeRefreshed")
    local function refreshSize()
        local YPos:UDim = GuiSize.PromptYIndent
        local xAnch = GuiSize.TextPromptXAnchor
        TextLabel.Position = UDim2.new(UDim.new(xAnch,0),YPos)
        TextLabel.AnchorPoint = Vector2.new(xAnch,0)
        TextLabel.Size = GuiSize.TextKeyPromptSize
        YPos += TextLabel.Size.Y
        Notify.Position = UDim2.new(UDim.new(xAnch,0),YPos)
        Notify.AnchorPoint = Vector2.new(xAnch,0)
        Notify.Size = GuiSize.NotifyKeyPromptSize
        YPos += Notify.Size.Y
        YPos = SpecDescriptionSizeBind:Run(Prompt,YPos)
        if typeof(YPos)=="UDim" then
            Buttons.Position = UDim2.new(UDim.new(xAnch,0),YPos)
            Buttons.Size = GuiSize.TextPromptButtonsSize
            Buttons.AnchorPoint = Vector2.new(xAnch,0)
            YPos += Buttons.Size.Y
            Prompt.Size = UDim2.new(Prompt.Size.X,YPos+GuiSize.PromptYIndent)
        end SizeRefreshed:Fire()
    end refreshSize()
    KeyPromptDescriptionSizeBind.OnBinded:Connect(refreshSize)
    SpecDescriptionSizeBind.OnBinded:Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("NotifyKeyPromptSize"):Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("PromptYIndent"):Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("TextPromptXAnchor"):Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("TextPromptButtonsSize"):Connect(refreshSize)
    GuiSize:GetPropertyChangedEvent("TextBoxPromptSize"):Connect(refreshSize)
    Prompt.Description.TranslateValueChanged:Connect(function()
        Descript.Text = Prompt.Description:Translate()
        refreshSize()
    end)
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowTextBoxBackgroundColor"):Connect(function()
        TextLabel.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextBoxBackgroundColor")
    end) TextLabel.BackgroundColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextBoxBackgroundColor")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowTextBoxTextColor"):Connect(function()
        TextLabel.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextBoxTextColor")
    end) TextLabel.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextBoxTextColor")
    Prompt.SpecialColors:GetColorChangedSignal("OnTWindowTextColor"):Connect(function()
        Descript.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextColor")
    end) Descript.TextColor3 = Prompt.SpecialColors:GetColor("OnTWindowTextColor")
    local MouseTwiceTranslator = Classes:CreateTranslator("Confirm")
    MouseTwiceTranslator:Load{ --#LANG_REQUIRED
        ru="Нажми на эту же кнопку мыши, чтобы подтвердить",
        en="Click the same mouse button to confirm"
    }  Prompt.ClickMouseTwiceText = MouseTwiceTranslator
    Prompt:SetReadOnly("ClickMouseTwiceText")
    local GPE = false
    local GPETranslator = Classes:CreateTranslator("Confirm")
    GPETranslator:Load{ --#LANG_REQUIRED
        ru="Выбранная кнопка используется в игре",
        en="Selected key is already using in game"
    }  Prompt.AlreadyUsingInGameText = GPETranslator
    Prompt:SetReadOnly("AlreadyUsingInGameText")
    GPETranslator.TranslateValueChanged:Connect(function()
        if GPE then
            Notify.Text = GPETranslator:Translate()
        end
    end) local KeyEvent
    local EventsHasBeenDisabled = false
    Prompt.DisableOtherInputsWhenRunning = true
    Prompt.OnRun:Connect(function()
        Prompt.Value = KeyBinding:CreateEmptyTKey()
        GPE = false Notify.Text = ""
        task.wait()
        inputed = false
        updateText()
        local lastMouse
        if Prompt.DisableOtherInputsWhenRunning then
            EventsHasBeenDisabled = KeyBinding.EventsEnabled
            KeyBinding.EventsEnabled = false
        end KeyEvent = KeyBinding.KeyEvent:Connect(function(TKey,gpe,Input:InputObject)
            if TKey.IsMouseKey then
                if Input.UserInputState~=Enum.UserInputState.End then return end
                gpe = false
                if lastMouse and lastMouse.Name==TKey.Name then
                    task.wait()
                    Prompt.Value = TKey 
                    Notify.Text = ""
                    lastMouse = nil
                else lastMouse = TKey
                    Notify.Text = MouseTwiceTranslator:Translate()
                    task.delay(1.5,function()
                        if lastMouse==TKey then
                            Notify.Text = ""
                            lastMouse = nil
                        end
                    end)
                end
            else if lastMouse then
                    Notify.Text = ""
                    lastMouse = nil
                end Prompt.Value = TKey 
            end GPE = gpe
            if gpe then
                Notify.Text = GPETranslator:Translate()
            elseif not TKey.IsMouseKey then
                Notify.Text = ""
            end
        end)
    end) Prompt.RunStopped:Connect(function()
        if KeyEvent then KeyEvent:Disconnect() end
        if EventsHasBeenDisabled then
            KeyBinding.EventsEnabled = true
        end
    end)
    return Prompt
end KeyPromptDescriptionSizeBind:Bind(DefaultPromptDescSizeF)
local KeybindStatesAndTranslate = { --#LANG_REQUIRED
    Change={
        ru="При нажатии или отпуске",
        en="On pressed or released"
    },Begin={
        ru="При нажатии",
        en="On pressed"
    },End={
        ru="При отпуске",
        en="On released"
    }
}
local function CreateKeybindBase(writeSameModeExclude:{string})
    local Keybind = Classes:CreateTClass(nil,nil,writeSameModeExclude)
    Keybind:AddClassName("BaseKeybind")
    Keybind.Key = KeyBinding:CreateEmptyTKey()
    local Event = Instance.new("BindableEvent")
    Keybind.Event = Event.Event
    function Keybind:Emulate()
        Event:Fire()
    end local connect
    Keybind.IgnoreExtraSpecialKeys = true
    function Keybind:CompareWithOtherTKey(TKey)
        if not Classes:IsA(TKey,"TKey") then logger:critical_error("BaseKeybind:CompareWithOtherTKey","TKey is incorrect. Expected TKey") end
        local Names = TKey.Name==Keybind.Key.Name
        if not Names then
            local KeyNames = TKey.KeyName==Keybind.Key.KeyName
            if KeyNames and Keybind.IgnoreExtraSpecialKeys then
                for k,v in Keybind.Key.Holding do
                    if not(v and TKey.Holding[k]) then
                        return false
                    end
                end return true
            end return false
        else return true
        end
    end Keybind.State = "End"
    Keybind:GetPropertyChangedEvent("Key"):Connect(function()
        if connect then connect:Disconnect() end
        connect = KeyBinding:GetKeyEvent(Keybind.Key.KeyName):Connect(function(TKey,gpe,Input:InputObject)
            local StateCompare = Keybind.State=="Change"
            if Keybind.State=="End" then StateCompare=Input.UserInputState==Enum.UserInputState.End end
            if Keybind.State=="Begin" then StateCompare=Input.UserInputState==Enum.UserInputState.Begin end
            if StateCompare and Keybind:CompareWithOtherTKey(TKey) then
                Event:Fire(Input,gpe)
            end
        end)
    end) Keybind.Type = ""
    return Keybind
end
local OnNewChildInKeybinder,OnChildRemovedInKeybinder = {},{}
local KeybindObjectID = 0
function KeyBinding:CreateKeybindObject()
    local KObject = CreateKeybindBase({"Parent"})
    KObject:AddClassName("KeybindObject")
    KObject.Position = 0
    KeybindObjectID += 1
    KObject.Id = KeybindObjectID
    KObject:SetReadOnly("Id")
    local oldParent
    local SColors = Classes:CreateSpecialColors()
    KObject.SpecialColors = SColors
    KObject:SetReadOnly("SpecialColors")
    local Frame = Instance.new("Frame")
    SColors:GetColorChangedSignal("ButtonBackground"):Connect(function()
        Frame.BackgroundColor3 = SColors:GetColor("ButtonBackground")
    end) Frame.BackgroundColor3 = SColors:GetColor("ButtonBackground")
    local UICorner = Instance.new("UICorner",Frame)
    KObject.UICorner = UICorner
    KObject:SetReadOnly("UICorner")
    local DeleteButton = Instance.new("ImageButton",Frame)
    DeleteButton.Name = "Delete"
    DeleteButton.AnchorPoint = Vector2.new(1,0.5)
    Assets:GetPropertyChangedEvent("DeleteKeybindObject"):Connect(function()
        DeleteButton.Image = Assets.DeleteKeybindObject
    end) DeleteButton.Image = Assets.DeleteKeybindObject
    SColors:GetColorChangedSignal("ButtonOnButtonBackground"):Connect(function()
        DeleteButton.BackgroundColor3 = SColors:GetColor("ButtonOnButtonBackground")
    end) DeleteButton.BackgroundColor3 = SColors:GetColor("ButtonOnButtonBackground")
    SColors:GetColorChangedSignal("ButtonOnButtonMain"):Connect(function()
        DeleteButton.ImageColor3 = SColors:GetColor("ButtonOnButtonMain")
    end) DeleteButton.ImageColor3 = SColors:GetColor("ButtonOnButtonMain")
    DeleteButton.Activated:Connect(function()
        KObject:Destroy()
    end) local Destroyed = Instance.new("BindableEvent")
    KObject.Destroyed = Destroyed.Event
    KObject:SetReadOnly("Destroyed")
    function KObject:Destroy()
        KObject.Parent = nil
        KObject:SetReadOnly("Parent")
        Frame:Destroy()
        Destroyed:Fire()
    end KObject.DeleteButton = DeleteButton
    KObject:SetReadOnly("DeleteButton")
    local DeleteCorner = Instance.new("UICorner",DeleteButton)
    GuiSize:GetPropertyChangedEvent("KeybindCornerRadius"):Connect(function()
        UICorner.CornerRadius = GuiSize.KeybindCornerRadius
    end) UICorner.CornerRadius = GuiSize.KeybindCornerRadius
    KObject:GetPropertyChangedEvent("Parent"):Connect(function()
        if oldParent then
            local f = OnChildRemovedInKeybinder[oldParent]
            if f then f(KObject) end
        end if Classes:IsA(KObject.Parent,"Keybinder") then
            oldParent = KObject.Parent
            local f = OnNewChildInKeybinder[KObject.Parent]
            if f then f(KObject) end
            Frame.Parent = KObject.Parent.KeybindsScroll
        else oldParent = nil
            Frame.Parent = nil
        end
    end) local yScale = 0.875
    local ValuesScale = 0.32
    local ValuesFrame = Instance.new("Frame",Frame)
    ValuesFrame.Name = "ValuesFrame"
    ValuesFrame.BackgroundTransparency = 1
    ValuesFrame.AnchorPoint = Vector2.new(0,0.5)
    local ValueButtons = {}
    local function CreateButton(DefTranslator)
        local HoverTranslator = Classes:CreateTranslator("...")
        local Button = Instance.new("TextButton",ValuesFrame)
        Button.Size = UDim2.new(ValuesScale,0,1,0)
        Button.TextScaled = true
        local focused = false
        local function refreshText()
            if focused then
                Button.Text = HoverTranslator:Translate()
            else Button.Text = HoverTranslator.Selected or HoverTranslator:Translate().."?"
            end
        end Button.MouseEnter:Connect(function()
            focused = true refreshText()
        end) Button.MouseLeave:Connect(function()
            focused = false refreshText()
        end) HoverTranslator.TranslateValueChanged:Connect(refreshText)
        HoverTranslator:GetPropertyChangedEvent("Selected"):Connect(refreshText)
        if DefTranslator then
            DefTranslator.TranslateValueChanged:Connect(function()
                HoverTranslator.Selected = DefTranslator:Translate()
            end)
        end refreshText() 
        table.insert(ValueButtons,{Button,Instance.new("UICorner",Button)})
        return Button,HoverTranslator
    end local SetKey,SetKeyHoverTranslator = CreateButton()
    SetKey.Name = "SetKey"
    SetKey.Activated:Connect(function()
        if oldParent then
            local Key = oldParent:AskKey({
                ru="Выбери новую клавишу.",
                en="Select new key."
            }) if Key then 
                KObject.Key = Key
            end
        end
    end) KObject:GetPropertyChangedEvent("Key"):Connect(function()
        local Key = KObject.Key
        if not Key.IsEmpty then
            SetKeyHoverTranslator.Selected = Key.Name
        else SetKeyHoverTranslator.Selected = nil
        end
    end)
    SetKeyHoverTranslator:Load{ --#LANG_REQUIRED
        ru="Клавиша",
        en="Key"
    } local StateTranslator = Classes:CreateTranslator("")
    local StateButton,StateHoverTranslator = CreateButton(StateTranslator)
    StateButton.Name = "State"
    StateButton.Position = UDim2.new(0.5,0,0,0)
    StateButton.AnchorPoint = Vector2.new(0.5,0)
    local StateMenu = Classes:CreateMenu()
    local Objects = {}
    local selectedStateButton
    local selectedState = StateMenu:CreateMenuButton("Selected",StateTranslator)
    selectedState.Position = 0
    for k,v in KeybindStatesAndTranslate do
        local menuButton = StateMenu:CreateMenuButton(k,v)
        Objects[k] = menuButton
        if KObject.State==k then
            selectedStateButton = menuButton
            menuButton.Visible = false
            StateTranslator:Load(v)
        end menuButton.Activated:Connect(function()
            selectedStateButton.Visible = true
            KObject.State = k
            selectedStateButton = menuButton
            menuButton.Visible = false
            StateTranslator:Load(v)
        end)
    end StateButton.Activated:Connect(function()
        local Abs = StateButton.AbsolutePosition
        StateMenu:Open(UDim2.new(0,Abs.X,0,Abs.Y))
    end) StateHoverTranslator:Load{ --#LANG_REQUIRED
        ru="Состояние нажатия",
        en="Click state"
    } KObject:GetPropertyChangedEvent("State"):Connect(function()
        local stateB = Objects[KObject.State]
        if stateB then
            selectedStateButton.Visible = true
            selectedStateButton = stateB
            stateB.Visible = false
            StateTranslator:Load(stateB.Title:GetPreset())
        end
    end) local TypeButton,TypeTranslator = CreateButton()
    TypeButton.Name = "Type"
    TypeButton.Position = UDim2.new(1,0,0,0)
    TypeButton.AnchorPoint = Vector2.new(1,0)
    TypeButton.Activated:Connect(function()
        if oldParent then
            local Abs = TypeButton.AbsolutePosition
            local eventType = oldParent:AskEventType(UDim2.new(0,Abs.X,0,Abs.Y),KObject.Type)
            if eventType then
                KObject.Type = eventType
            end
        end
    end) local updaterLangEvent
    local function updateEventType()
        if Classes:IsA(KObject.Parent,"Keybinder") then
            local Translator = KObject.Parent:GetEventTypeTitle(KObject.Type)
            if Translator then
                TypeTranslator.Selected = Translator:Translate()
            else TypeTranslator.Selected = nil
            end
        end
    end KObject:GetPropertyChangedEvent("Parent"):Connect(function()
        if updaterLangEvent then updaterLangEvent:Disconnect() end
        if Classes:IsA(KObject.Parent,"Keybinder") then
            updateEventType()
            updaterLangEvent = KObject.Parent.EventTypeTranslateRefresh:Connect(function(name)
                if name==KObject.Type then
                    updateEventType()
                end
            end)
        end
    end) KObject:GetPropertyChangedEvent("Type"):Connect(updateEventType)
    TypeTranslator:Load{ --#LANG_REQUIRED
        ru="Тип запуск",
        en="Run type"
    }
    local function refreshValuesColors()
        for k,v in ValueButtons do
            v[1].BackgroundColor3 = SColors:GetColor("ButtonOnButtonBackground")
            v[1].TextColor3 = SColors:GetColor("ButtonOnButtonMain")
        end
    end refreshValuesColors()
    SColors:GetColorChangedSignal("ButtonOnButtonBackground"):Connect(refreshValuesColors)
    SColors:GetColorChangedSignal("ButtonOnButtonMain"):Connect(refreshValuesColors)
    local function cornerRefresh()
        DeleteCorner.CornerRadius = GuiSize.KeybindButtonsCornerRadius
        for k,v in ValueButtons do
            v[2].CornerRadius = GuiSize.KeybindButtonsCornerRadius
        end
    end cornerRefresh()
    GuiSize:GetPropertyChangedEvent("KeybindButtonsCornerRadius"):Connect(cornerRefresh)
    local function refreshSize()
        Frame.Size = UDim2.new(UDim.new(1,0),GuiSize.KeybindYSize)
        local AbsFSize = Frame.AbsoluteSize.Y
        local ButtonAbsSize = AbsFSize*yScale
        local AbsIndent = AbsFSize-ButtonAbsSize
        DeleteButton.Size = UDim2.new(0,ButtonAbsSize,0,ButtonAbsSize)
        DeleteButton.Position = UDim2.new(1,-AbsIndent/2,0.5,0)
        ValuesFrame.Size = UDim2.new(1,-AbsFSize-AbsIndent,yScale,0)
        ValuesFrame.Position = UDim2.new(0,AbsIndent,0.5,0)
    end refreshSize()
    GuiSize:GetPropertyChangedEvent("KeybindYSize"):Connect(refreshSize)
    KObject.Frame = Frame
    KObject:SetReadOnly("Frame")
    return KObject
end local KeybinderUsingNames = {}
function KeyBinding:CreateKeybinder(Name:string,Title:string|{[string]:string}?,disableDefaultConfigSettingsForWindow:boolean)
    if type(Name)~="string" then logger:critical_error("KeyBinding:CreateKeybinder","Name is incorrect, expected string") end
    if type(Title)~="table" then
        Title = Classes:CreateTranslator(Title or "")
    else if Title.__type~="TClass" then
            local oldTitle = Title
            Title = Classes:CreateTranslator("")
            Title:Load(oldTitle)
        elseif not Title:IsA("Translator") then
            Title = Classes:CreateTranslator("")
        end
    end
    local Keybinder = Classes:CreateTClass()
    Keybinder:AddClassName("Keybinder")
    Keybinder.Name = Name
    Keybinder:SetReadOnly("Name")
    local SavingDisabledByName = KeybinderUsingNames[Name] or false
    if SavingDisabledByName then logger:warn("KeyBinding:CreateKeybinder",`Name "{Name}" is already using. Saving disabled`) end
    KeybinderUsingNames[Name] = true
    local Window = Classes:CreateTWindow(Name..".KeyBinder",{ --#LANG_REQUIRED
        ru="Привязывание к клавишам",
        en="Key binder"
    },disableDefaultConfigSettingsForWindow)
    local SColors = Window.SpecialColors
    Keybinder.SpecialColors = SColors
    Keybinder:SetReadOnly("SpecialColors")
    Keybinder.Title = Title
    Keybinder:SetReadOnly("Title")
    Keybinder.Window = Window
    Keybinder:SetReadOnly("Window")
    local TitleText = Instance.new("TextLabel",Window.Frame)
    TitleText.Name = "Title"
    TitleText.TextScaled = true
    TitleText.BackgroundTransparency = 1
    Window.SpecialColors:GetColorChangedSignal("OnTWindowTextColor"):Connect(function()
        TitleText.TextColor3 = Window.SpecialColors:GetColor("OnTWindowTextColor")
    end) TitleText.TextColor3 = Window.SpecialColors:GetColor("OnTWindowTextColor")
    Keybinder.TitleLabel = Title.Text
    Keybinder:SetReadOnly("Keybinder")
    local KeybindsScroll = Instance.new("ScrollingFrame",Window.Frame)
    KeybindsScroll.Name = "Keybinds"
    Instance.new("UIListLayout",KeybindsScroll).Name = "This will changed in future updates!"
    KeybindsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    KeybindsScroll.CanvasSize = UDim2.new(0,0,0,0)
    KeybindsScroll.BackgroundTransparency = 1
    GuiSize:GetPropertyChangedEvent("KeybinderScrollBarThickness"):Connect(function()
        KeybindsScroll.ScrollBarThickness = GuiSize.KeybinderScrollBarThickness
    end) KeybindsScroll.ScrollBarThickness = GuiSize.KeybinderScrollBarThickness
    Keybinder.KeybindsScroll = KeybindsScroll
    Keybinder:SetReadOnly("KeybindsScroll")
    local selectedEventType = Instance.new("BindableEvent")
    local EventTypeTranslateRefresh = Instance.new("BindableEvent")
    Keybinder.EventTypeTranslateRefresh = EventTypeTranslateRefresh.Event
    Keybinder:SetReadOnly("EventTypeTranslateRefresh")
    local EventTypesMenu = Classes:CreateMenu()
    local SelectedEventTypeName
    local EventTypesMenuSelected = EventTypesMenu:CreateMenuButton("_selected_","...")
    EventTypesMenuSelected.Activated:Connect(function()
        selectedEventType:Fire()
    end) EventTypesMenu:GetPropertyChangedEvent("Opened"):Connect(function()
        if not EventTypesMenu.Opened then
            task.wait() --CANCEL selecting, hah 1st comment
            selectedEventType:Fire()
        end
    end)
    local EventTypes:{{
        Name:string,Translator:{[string]:string},MenuObject:any
    }} = {} local EventTypesFromName = {}
    Keybinder.DefaultType = ""
    function Keybinder:AddEventType(name:string,Title:{[string]:string}|string?)
        if type(name)~="string" then logger:critical_error("Keybinder:AddEventType","Name is incorrect, expected string") end
        if EventTypesFromName[name] or name=="_selected_" then logger:critical_error("Keybinder:AddEventType",`Event "{name}" is already exists.`) end
        if type(Title)~="table" then
            Title = Classes:CreateTranslator(Title or name)
        else if Title.__type~="TClass" then
                local oldTitle = Title
                Title = Classes:CreateTranslator(name)
                Title:Load(oldTitle)
            elseif not Title:IsA("Translator") then
                Title = Classes:CreateTranslator(name)
            end
        end local EventType = {}
        EventType.Name = name
        EventType.Translator = Title
        local MenuButton = EventTypesMenu:CreateMenuButton(name,Title)
        EventType.MenuButton = MenuButton
        EventTypesFromName[name]=EventType
        if #EventTypes==0 then
            Keybinder.DefaultType = name
        end table.insert(EventTypes,EventType)
        MenuButton.Activated:Connect(function()
            selectedEventType:Fire(name)
        end) EventType.TranslateListener = Title.TranslateValueChanged:Connect(function()
            if SelectedEventTypeName==name then
                EventTypesMenuSelected.Title:Load(Title:GetPreset())
            end EventTypeTranslateRefresh:Fire(name)
        end)
    end function Keybinder:GetEventTypeTitle(name:string)
        if type(name)~="string" then logger:critical_error("Keybinder:GetEventTypeTitle","Name is incorrect, expected string") end
        if EventTypesFromName[name] then
            return EventTypesFromName[name].Translator
        end
    end function Keybinder:GetEventNames()
        local names = {}
        for k,v in EventTypes do
            names[k] = v.Name
        end return names
    end local selectedTypeMenuButton
    function Keybinder:AskEventType(Position:UDim2,selected:string)
        if EventTypesMenu.Opened then
            selectedEventType:Fire()
            EventTypesMenu:Close()
            task.wait()
        end SelectedEventTypeName = selected
        local selectedType = EventTypesFromName[selected]
        if selectedTypeMenuButton then
            selectedTypeMenuButton.Visible = true
        end if selectedType then
            selectedTypeMenuButton = selectedType.MenuButton
            selectedTypeMenuButton.Visible = false
            EventTypesMenuSelected.Title:Load(selectedType.Translator:GetPreset())
        else EventTypesMenuSelected.Visible = false
        end EventTypesMenu:Open(Position)
        return selectedEventType.Event:Wait()
    end local Event = Classes:CreateTEvent()
    Keybinder.Event = Event.Event
    Keybinder:SetReadOnly("Event")
    local SavedEvent = Classes:CreateTEvent()
    Keybinder.Saved = SavedEvent.Event
    Keybinder:SetReadOnly("Saved")
    local Keybinds = {}
    Keybinder.AutosaveEnabled = true
    Keybinder.SaveEnabled = true
    local loading = false
    function Keybinder:GetKeybindsTable()
        local Save = {}
        for k,v in Keybinds do
            local key = v.Key
            local SavingTKey = {}
            if key.IsKeyboardKey then
                SavingTKey.Key = key.KeyCode.Name
            elseif key.IsMouseKey then
                SavingTKey.Mouse = key.MouseKey
            end local Holding = {}
            for kk,vv in key.Holding do
                if vv then
                    Holding[kk] = true
                end
            end SavingTKey.Hold = Holding
            Save[k] = {
                Key=SavingTKey,
                Type=v.Type,
                State=v.State,
                IESK=v.IgnoreExtraSpecialKeys
            }
        end return Save
    end local function SaveBinds(isAutosave:boolean)
        if SavingDisabledByName or not (Keybinder.SaveEnabled and config.Settings.SaveKeybinds) then return false end
        if isAutosave and loading and not (Keybinder.AutosaveEnabled and config.Settings.AutoSaveKeybinds) then return false end
        config.Keybinds.Keybinders[Name] = Keybinder:GetKeybindsTable()
        onConfigChanged:Fire()
        return true
    end local twoLoad
    local function LoadBinds(isCfgLoad:boolean,Binds:{{Key:any,Type:string,State:string,IESK:boolean}})
        if isCfgLoad and (SavingDisabledByName or (not (Keybinder.SaveEnabled and config.Settings.SaveKeybinds))) then return false end
        if type(Binds)~="table" then return false end
        if loading then twoLoad=Binds end
        loading = true
        for k,v in Keybinds do
            v:Destroy()
        end task.wait()
        for k,v in Binds do
            local bind = Keybinder:CreateKeybind()
            bind.State = v.State
            task.spawn(function() task.wait()
                bind.Type = v.Type
            end) bind.IgnoreExtraSpecialKeys = v.IESK
            local TKey
            if v.Key.Key then
                local s,KeyCode = pcall(function()
                    return Enum.KeyCode[v.Key.Key]
                end) if s and KeyCode then
                    TKey = KeyBinding:CreateKeyboardKey(KeyCode,v.Key.Hold)
                end
            elseif v.Key.Mouse then
                TKey = KeyBinding:CreateMouseKey(v.Key.Mouse,v.Key.Hold)
            end if not TKey then
                TKey = KeyBinding:CreateEmptyTKey()
            end bind.Key = TKey
        end loading = false
        if twoLoad then 
            task.spawn(function()
                local load = twoLoad twoLoad = nil
                LoadBinds(false,load)
            end)
        end return true
    end function Keybinder:LoadFromConfig()
        return LoadBinds(true,config.Keybinds.Keybinders[Name] or {})
    end function Keybinder:SaveToConfig()
        return SaveBinds(false)
    end task.spawn(function()
        if SavingDisabledByName then return end
        Keybinder:LoadFromConfig()
        onLoadConfigEvent.Event:Connect(function()
            Keybinder:LoadFromConfig()
        end)
    end) Keybinder.SavingDisabledByName = SavingDisabledByName
    Keybinder:SetReadOnly("SavingDisabledByName")
    function Keybinder:LoadKeybindsTable(Keybinds:any)
        return LoadBinds(false,Keybinds)
    end local KeybindsConnects = {}
    OnNewChildInKeybinder[Keybinder] = function(KObject)
        table.insert(Keybinds,KObject)
        KObject.Position = #Keybinds
        KObject.Type = Keybinder.DefaultType
        local events = {}
        KeybindsConnects[KObject] = events
        table.insert(events,KObject.Event:Connect(function(InputObject,GPE)
            Event:Fire(KObject.Type,KObject,InputObject,GPE)
        end)) table.insert(events,KObject.OnPropertyChanged:Connect(function()
            if not loading then
                SaveBinds(true)
            end
        end)) if not loading then
            SaveBinds(true)
        end Keybinder:RefreshPositions()
    end OnChildRemovedInKeybinder[Keybinder] = function(KObject)
        table.remove(Keybinds,table.find(Keybinds,KObject))
        local events = KeybindsConnects[KObject]
        if events then for k,v in events do v:Disconnect() end end
        Keybinder:RefreshPositions() SaveBinds(true)
    end local Buttons = Instance.new("Frame",Window.Frame)
    Buttons.Name = "Buttons"
    Buttons.BackgroundTransparency = 1
    Buttons.AnchorPoint = Vector2.new(0,1)
    Buttons.Position = UDim2.new(0,0,1,0)
    Keybinder.Buttons = Buttons
    Keybinder:SetReadOnly("Buttons")
    local NewKeybindButton = Instance.new("ImageButton",Buttons)
    NewKeybindButton.Name = "NewKeybind"
    NewKeybindButton.Position = UDim2.new(1,0,0,0)
    NewKeybindButton.AnchorPoint = Vector2.new(1,0)
    SColors:GetColorChangedSignal("ButtonBackground"):Connect(function()
        NewKeybindButton.BackgroundColor3 = SColors:GetColor("ButtonBackground")
    end) NewKeybindButton.BackgroundColor3 = SColors:GetColor("ButtonBackground")
    SColors:GetColorChangedSignal("TextColor"):Connect(function()
        NewKeybindButton.ImageColor3 = SColors:GetColor("TextColor")
    end) NewKeybindButton.ImageColor3 = SColors:GetColor("TextColor")
    Assets:GetPropertyChangedEvent("AddKeybind"):Connect(function()
        NewKeybindButton.Image = Assets.AddKeybind
    end) NewKeybindButton.Image = Assets.AddKeybind
    local NewKCorner = Instance.new("UICorner",NewKeybindButton)
    NewKeybindButton.Activated:Connect(function()
        Keybinder:CreateKeybind()
    end) function Keybinder:CreateKeybind()
        local KObject = KeyBinding:CreateKeybindObject()
        KObject.Parent = Keybinder
        return KObject
    end function Keybinder:GetKeybinds()
        local ResKeybinds = {}
        for k,v in Keybinds do
            ResKeybinds[k] = v
        end return ResKeybinds
    end
    local function refreshCorners()
        NewKCorner.CornerRadius = GuiSize.KeybindButtonsCornerRadius
    end refreshCorners()
    GuiSize:GetPropertyChangedEvent("KeybindButtonsCornerRadius"):Connect(refreshCorners)
    local function RefreshPosition()
        local YPos = UDim.new(0,0)
        TitleText.Visible = Title:Translate()~=""
        if TitleText.Visible then
            TitleText.Size = GuiSize.KeybinderTitleSize
            YPos += TitleText.Size.Y
        end KeybindsScroll.Size = UDim2.new(UDim.new(1,0),UDim.new(1,0)-YPos-GuiSize.KeybinderButtonsYSize)
        KeybindsScroll.Position = UDim2.new(UDim.new(0,0),YPos)
        Buttons.Size = UDim2.new(UDim.new(1,0),GuiSize.KeybinderButtonsYSize)
        Window.Size = UDim2.new(0.25,100,0.5,0)
        local AbsFSize = Buttons.AbsoluteSize.Y
        NewKeybindButton.Size = UDim2.new(0,AbsFSize,0,AbsFSize)
    end RefreshPosition()
    STGui:GetAttributeChangedSignal("AbsoluteSize"):Connect(RefreshPosition)
    GuiSize:GetPropertyChangedEvent("KeybindYSize"):Connect(RefreshPosition)
    GuiSize:GetPropertyChangedEvent("KeybinderTitleSize"):Connect(RefreshPosition)
    Title.TranslateValueChanged:Connect(function()
        TitleText.Text = Title:Translate()
        RefreshPosition()
    end) TitleText.Text = Title:Translate()
    function Keybinder:RefreshPositions()
        table.sort(Keybinds,function(a,b)
            if a.Position~=b.Position then
                return a.Position<b.Position
            else return a.Id<b.Id
            end
        end) for k,v in Keybinds do
            v.Frame.LayoutOrder = k
        end
    end Keybinder.Opened = false
    Keybinder:GetPropertyChangedEvent("Opened"):Connect(function()
        Window.Opened = Keybinder.Opened
    end) local Prompt = Prompts:CreateKeyPrompt("Keybinder."..Name,Title,"...",true)
    Prompt.ConfigSavingEnabled = false
    function Keybinder:AskKey(Desc:{[string]:string})
        if type(Desc)~="table" then logger:critical_error("Keybinder:AskKey","Description is incorrect(expected table)") end
        Prompt:Move(Window.WindowFrame.Position, Vector2.new(0.5,0.5))
        Prompt.Description:Load(Desc)
        return Prompt:Run()
    end Window.Opened = false
    Window:GetPropertyChangedEvent("Opened"):Connect(function()
        Keybinder.Opened = Window.Opened
    end) function Keybinder:Destroy()
        Window:Destroy()
        EventTypesMenu:Destroy()
    end
    return Keybinder
end
-- #FIND_POINT Configs Window ------------------
State.Saying:Load{ -- #LANG_REQUIRED
    ru="Загузка ядра: Загрузка конфигураций",
    en="Loading core: Loading Configurations"
}
local ConfigsWindow = Classes:CreateTWindow("Configs",{ --LANG_REQUIRED
    ru="Конфигурации",
    en="Configurations",
    uk="Конфігурації"
}) Configs.Window = ConfigsWindow
ConfigsWindow.Opened = false
local ConfigsFrame = Instance.new("Frame",ConfigsWindow.Frame)
ConfigsFrame.Name = "Configs"
ConfigsFrame.BackgroundTransparency = 1
local ConfigsScF = Instance.new("ScrollingFrame",ConfigsFrame)
ConfigsScF.BackgroundTransparency = 1
ConfigsScF.ScrollBarThickness = 6
ConfigsScF.CanvasSize = UDim2.new(0,0,0,0)
ConfigsScF.AutomaticCanvasSize = Enum.AutomaticSize.Y
local ConfigsButtons = Instance.new("Frame",ConfigsFrame)
ConfigsButtons.BackgroundTransparency = 1
ConfigsButtons.AnchorPoint = Vector2.new(0,1)
ConfigsButtons.Position = UDim2.new(0,0,1,0)
local CreateConfigButton = Instance.new("TextButton",ConfigsButtons)
CreateConfigButton.Name = "Create"
CreateConfigButton.Text = "+"
CreateConfigButton.TextScaled = true
Instance.new("UICorner",CreateConfigButton).CornerRadius = UDim.new(1,0)
ConfigsWindow.SpecialColors:GetColorChangedSignal("ButtonBackground"):Connect(function()
    CreateConfigButton.BackgroundColor3 = ConfigsWindow.SpecialColors:GetColor("ButtonBackground")
end) CreateConfigButton.BackgroundColor3 = ConfigsWindow.SpecialColors:GetColor("ButtonBackground")
ConfigsWindow.SpecialColors:GetColorChangedSignal("TextColor"):Connect(function()
    CreateConfigButton.TextColor3 = ConfigsWindow.SpecialColors:GetColor("TextColor")
end) CreateConfigButton.TextColor3 = ConfigsWindow.SpecialColors:GetColor("TextColor")
local CreateConfigNamePrompt = Prompts:CreateTextPrompt("NewConfigName",{ --#LANG_REQUIRED
    ru="Создание конфига",
    en="Config creating"
},{ --#LANG_REQUIRED
    ru="Введи имя для новой конфигурации",
    en="Enter name for a new configuration"
},true) CreateConfigNamePrompt.ConfigSavingEnabled = false
CreateConfigNamePrompt:SetReadOnly("ConfigSavingEnabled")
CreateConfigButton.Activated:Connect(function()
    if not SavesIsSupported or CreateConfigNamePrompt.Running then return end
    CreateConfigNamePrompt:Move(ConfigsWindow.WindowFrame.Position)
    local name = CreateConfigNamePrompt:Run()
    if name then
        local res = ControlCfg:Create(name)
    end
end) local ConfigsSelectedFrame = Instance.new("Frame",ConfigsWindow.Frame)
ConfigsSelectedFrame.Position = UDim2.new(1,0,0,0)
ConfigsSelectedFrame.AnchorPoint = Vector2.new(1,0)
ConfigsSelectedFrame.BackgroundTransparency = 1
local ConfigsSeparationFrame = Instance.new("Frame",ConfigsWindow.Frame)
ConfigsSeparationFrame.AnchorPoint = Vector2.new(0.5,0)
ConfigsSeparationFrame.Size = UDim2.new(GuiSize.ConfigsSeparatorSize,UDim.new(1,0))
ConfigsWindow.SpecialColors:GetColorChangedSignal("ConfigsSeparationColor"):Connect(function()
    ConfigsSeparationFrame.BackgroundColor3 = ConfigsWindow.SpecialColors:GetColor("ConfigsSeparationColor")
end) ConfigsSeparationFrame.BackgroundColor3 = ConfigsWindow.SpecialColors:GetColor("ConfigsSeparationColor")
local function CfgWindowRefresh()
    ConfigsScF.Size = UDim2.new(UDim.new(1,0),UDim.new(1,0)-GuiSize.ConfigsWindowConfigsSize)
    ConfigsButtons.Size = UDim2.new(UDim.new(1,0),GuiSize.ConfigsWindowConfigsSize)
    for k,v:ImageButton in ConfigsButtons:GetChildren() do
        if v:IsA("ImageButton") or v:IsA("TextButton") then
            v.Size = UDim2.new(0,ConfigsButtons.AbsoluteSize.Y,1,0)
            v.Position = UDim2.new(0,(ConfigsButtons.AbsoluteSize.Y+3)*(k-1),0,0)
        end
    end ConfigsFrame.Size = UDim2.new(GuiSize.ConfigsWindowConfigsFrameSize,UDim.new(1,0))
    ConfigsSeparationFrame.Position = UDim2.new(GuiSize.ConfigsWindowConfigsFrameSize,UDim.new(0,0))
    ConfigsSelectedFrame.Size = UDim2.new(UDim.new(1,0)-GuiSize.ConfigsWindowConfigsFrameSize,UDim.new(1,0))
    ConfigsWindow.Size = GuiSize.ConfigsWindowSize
end CfgWindowRefresh()
GuiSize:GetPropertyChangedEvent("ConfigsWindowConfigsSize"):Connect(CfgWindowRefresh)
GuiSize:GetPropertyChangedEvent("ConfigsWindowConfigsFrameSize"):Connect(CfgWindowRefresh)
GuiSize:GetPropertyChangedEvent("ConfigsWindowSize"):Connect(CfgWindowRefresh)
local cfglistrefreshing = false
Instance.new("UIListLayout",ConfigsScF)
local function ConfigsListRefresh()
    if cfglistrefreshing then return end
    cfglistrefreshing = true
    RunService.PreRender:Wait()
    --ConfigsScF:ClearAllChildren()
    for k,v in ConfigsScF:GetChildren() do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
    for _,name:string in ControlCfg:GetList() do
        local Button = Instance.new("TextButton",ConfigsScF)
        local Corner = Instance.new("UICorner",Button)
        Corner.CornerRadius = GuiSize.ConfigsCfgCornerRadius
        Button.Name = name
        Button.Size = UDim2.new(UDim.new(1,0),GuiSize.ConfigsWindowConfigsSize)
        Button.TextTransparency = 1
        local Text = Instance.new("TextLabel",Button)
        Text.Size = UDim2.new(1,0,1,0)
        Text.TextScaled = true
        Text.Text = name
        Text.BackgroundTransparency = 1
        Button.Activated:Connect(function()
            ControlCfg:Open(name)
        end) if loadedConfig==name then
            Button.BackgroundColor3 = ConfigsWindow.SpecialColors:GetColor("ConfigButtonSelectedBackground")
        else Button.BackgroundColor3 = ConfigsWindow.SpecialColors:GetColor("ButtonBackground")
        end
        Text.TextColor3 = ConfigsWindow.SpecialColors:GetColor("TextColor")
    end cfglistrefreshing = false
end ConfigsListRefresh()
ConfigsFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ConfigsListRefresh)
GuiSize:GetPropertyChangedEvent("ConfigsCfgCornerRadius"):Connect(ConfigsListRefresh)
GuiSize:GetPropertyChangedEvent("ConfigsWindowConfigsSize"):Connect(ConfigsListRefresh)
ConfigsWindow.SpecialColors:GetColorChangedSignal("ButtonBackground"):Connect(ConfigsListRefresh)
ConfigsWindow.SpecialColors:GetColorChangedSignal("ConfigButtonSelectedBackground"):Connect(ConfigsListRefresh)
ConfigsWindow.SpecialColors:GetColorChangedSignal("TextColor"):Connect(ConfigsListRefresh)
OnConfigListChanged.Event:Connect(ConfigsListRefresh)
local STitleConfig = Instance.new("TextLabel",ConfigsSelectedFrame)
STitleConfig.TextScaled = true
STitleConfig.BackgroundTransparency = 1
local ConfigSFrame = Instance.new("ScrollingFrame",ConfigsSelectedFrame)
Instance.new("UIListLayout",ConfigSFrame)
ConfigSFrame.BackgroundTransparency = 0.7
ConfigSFrame.Position = UDim2.new(0,0,1,0)
ConfigSFrame.AnchorPoint = Vector2.new(0,1)
ConfigSFrame.ScrollBarThickness = 6
ConfigSFrame.CanvasSize = UDim2.new(0,0,0,0)
ConfigSFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ConfigsWindow.SpecialColors:GetColorChangedSignal("OnTWindowTextColor"):Connect(function()
    STitleConfig.TextColor3 = ConfigsWindow.SpecialColors:GetColor("OnTWindowTextColor")
end) STitleConfig.TextColor3 = ConfigsWindow.SpecialColors:GetColor("OnTWindowTextColor")
local function RefreshConfigsSFrameSize()
    STitleConfig.Size = GuiSize.ConfigsTitleSize
    ConfigSFrame.Size = UDim2.new(UDim.new(1,0),UDim.new(1,-5)-GuiSize.ConfigsTitleSize.Y)
end RefreshConfigsSFrameSize()
GuiSize:GetPropertyChangedEvent("ConfigsTitleSize"):Connect(RefreshConfigsSFrameSize)
local function ConfigsCreateSettingsButton(dontchangetextcolor)
    local Translator = Classes:CreateTranslator("...")
    local Button = Instance.new("TextButton",ConfigSFrame)
    local UICorner = Instance.new("UICorner",Button)
    Button.TextScaled = true
    Translator.TranslateValueChanged:Connect(function()
        Button.Text = Translator:Translate()
    end)
    GuiSize:GetPropertyChangedEvent("ButtonCornerRadius"):Connect(function()
        UICorner.CornerRadius = GuiSize.ButtonCornerRadius
    end) UICorner.CornerRadius = GuiSize.ButtonCornerRadius
    GuiSize:GetPropertyChangedEvent("ButtonSize"):Connect(function()
        Button.Size = GuiSize.ButtonSize
    end) Button.Size = GuiSize.ButtonSize
    if not dontchangetextcolor then
        ConfigsWindow.SpecialColors:GetColorChangedSignal("TextColor"):Connect(function()
            Button.TextColor3 = ConfigsWindow.SpecialColors:GetColor("TextColor")
        end) Button.TextColor3 = ConfigsWindow.SpecialColors:GetColor("TextColor")
    end ConfigsWindow.SpecialColors:GetColorChangedSignal("ButtonBackground"):Connect(function()
        Button.BackgroundColor3 = ConfigsWindow.SpecialColors:GetColor("ButtonBackground")
    end) Button.BackgroundColor3 = ConfigsWindow.SpecialColors:GetColor("ButtonBackground")
    return Button,Translator
end
local openedCfgName,openedCfg:{Settings:{}}?
local function saveOpenedCfg()
    local name = sanitizeFilename(openedCfgName)
    if name then
        writefile(ConfigsPath..name,HttpService:JSONEncode(openedCfg))
    end
end local onOpenedConfigChange = Instance.new("BindableEvent")
local function ConfigToggle(Name,Lang)
    local CFGButton,Translator = ConfigsCreateSettingsButton(true)
    Translator:Load(Lang) local function refresh()
        if openedCfg and openedCfg.Settings[Name] then
            CFGButton.TextColor3 = ConfigsWindow.SpecialColors:GetColor("ToggleTrue")
        else CFGButton.TextColor3 = ConfigsWindow.SpecialColors:GetColor("ToggleFalse")
        end
    end refresh()
    ConfigsWindow.SpecialColors:GetColorChangedSignal("ToggleTrue"):Connect(refresh)
    ConfigsWindow.SpecialColors:GetColorChangedSignal("ToggleFalse"):Connect(refresh)
    onOpenedConfigChange.Event:Connect(refresh)
    CFGButton.Activated:Connect(function()
        openedCfg.Settings[Name] = not openedCfg.Settings[Name]
        saveOpenedCfg() if openedCfg==config then
            onConfigSettingsChanged:Fire()
        end refresh()
    end) 
end
local OpenCFGButton,OpenCFGTranslator = ConfigsCreateSettingsButton()
OpenCFGButton.Activated:Connect(function()
    ControlCfg:Load(openedCfgName)
    ControlCfg:Open(openedCfgName)
end)
local function refreshOpenCFGTranslate()
    if loadedConfig==openedCfgName then
        OpenCFGTranslator:Load{ --#LANG_REQUIRED
            ru="Перезагрузить",
            en="Reload",
        }
    else OpenCFGTranslator:Load{ --#LANG_REQUIRED
            ru="Загрузить",
            en="Load",
        }
    end
end Configs.OnLoaded:Connect(function()
    refreshOpenCFGTranslate()
    ConfigsListRefresh()
end) local DeleteConfigConfirmPrompt = Prompts:CreateConfirmationPrompt("DeleteConfigConfirm",{ --#LANG_REQUIRED
    ru="Подтверждение для удаление конфига",
    en="Confirmation config delete"
},"",true)
DeleteConfigConfirmPrompt.ConfigSavingEnabled = false
DeleteConfigConfirmPrompt:SetReadOnly("ConfigSavingEnabled")
local DeleteCFGButton,DeleteCFGTranslator = ConfigsCreateSettingsButton()
DeleteCFGButton.Activated:Connect(function()
    DeleteConfigConfirmPrompt:Move(ConfigsWindow.WindowFrame.Position)
    DeleteConfigConfirmPrompt.Description:Load{ --#LANG_REQUIRED + Minecraft Bugrock reference
        ru=`Удалить ли конфигурацию "{openedCfgName}"? Её больше НИКОГДА нельзя будет восстановить((очень) долго)`,
        en=`Should I delete the configuration "{openedCfgName}"? You won't be able to restore it.`
    } local isDel = DeleteConfigConfirmPrompt:Run()
    if isDel then
        ControlCfg:Delete(openedCfgName)
    end
end)
DeleteCFGTranslator:Load{ --#LANG_REQUIRED
    ru="Удалить",
    en="Delete",
}

ConfigToggle("AutoSaveValues",{ --#LANG_REQUIRED
    ru="Автоматически сохранять значения",
    en="Auto save values",
})
-- ConfigToggle("AutoSaveKeybinds",{ --#LANG_REQUIRED
--     ru="Автоматически сохранять назначения клавиш(ПК)",
--     en="Auto save Keybinds(PC)",
-- }) 
ConfigToggle("AutoSaveWindows",{ --#LANG_REQUIRED
    ru="Автоматически сохранять окна",
    en="Auto save windows",
}) ConfigToggle("SaveWindows",{ --#LANG_REQUIRED
    ru="Сохранять окна",
    en="Save windows",
})
function ControlCfg:Open(name:string)
    openedCfgName = name
    STitleConfig.Text = tostring(name)
    refreshOpenCFGTranslate()
    SettingsSave:SetToSave("lastOpenedConfigName",name)
    if name==loadedConfig then
        openedCfg = config
    else openedCfg = ControlCfg:GetConfigData(name)
    end ConfigsSelectedFrame.Visible = openedCfg~=nil
    onOpenedConfigChange:Fire()
end ControlCfg:Open(SettingsSave:GetFromSave("lastOpenedConfigName"))
OnConfigDeleted.Event:Connect(function(Name)
    if openedCfgName == Name then
        ControlCfg:Open()
    end
end)
-- #FIND_POINT Scripts ------------------
local TScripts = {}
local CreatedTScriptsSanitize = {}
function TimGui:GetTScript(ScriptName:string,allowLoadTwice:boolean?)
    local SanName = sanitizeFilename(ScriptName)
    if CreatedTScriptsSanitize[SanName] then error(`Script {ScriptName} already created`) end
    if TScripts[ScriptName] then return TScripts[ScriptName] end
    local TScript = Classes:CreateTClass()
    TScript:AddClassName("TScript")
    TScript.Name = ScriptName
    TScript:SetReadOnly("Name")
    TScripts[ScriptName] = TScript
    TScript.Logger = Loggers:New(ScriptName)
    TScript:SetReadOnly("Logger")
    local scriptGlobalSave = {}
    local scriptGlobalPath = ScriptDataPath..SanName
    if SavesIsSupported and isfile(scriptGlobalPath) then
        local s,res = pcall(function()
            return HttpService:JSONDecode(readfile(scriptGlobalPath))
        end) if s then
            scriptGlobalSave = res
        else logger:error("Load script save","Error to load script save: "..tostring(res))
        end
    end function TScript:GetFromSave(key:string)
        return scriptGlobalSave[key]
    end function TScript:SetToSave(key:string,value)
        if type(value)=="table" and value.__have_timgui_metatable then return end
        scriptGlobalSave[key] = value
        if SavesIsSupported then
            writefile(scriptGlobalPath,HttpService:JSONEncode(scriptGlobalSave))
        end
    end local cfgData = config.ScriptSaves[ScriptName]or {}
    onLoadConfigEvent.Event:Connect(function()
        cfgData = config.ScriptSaves[ScriptName]or {}
    end) function TScript:GetFromConfig(key:string)
        return cfgData[key]
    end function TScript:SetToConfig(key:string,value)
        if type(value)=="table" and value.__have_timgui_metatable then return end
        cfgData[key] = value
        local cleared = true for _ in cfgData do cleared = false end
        if cleared then
            config.ScriptSaves[ScriptName]=nil
        else config.ScriptSaves[ScriptName]=cfgData
        end onConfigChanged:Fire()
    end
    CreatedTScriptsSanitize[SanName] = not allowLoadTwice
    TScripts[ScriptName] = TScript
    return TScript
end
-- #FIND_POINT PACKAGES
local Packages = Classes:CreateTClass()
local RawCodes = {}
local function GetPackageCode(Name:string)
    Name = Name..".lua"
    local LocalPath = PackagesPath..Name
    local isLocalPackage = SavesIsSupported and isfile(LocalPath)
    if isLocalPackage then
        return readfile(LocalPath)
    else return TimGui:HttpGet("./Packages/"..Name)
    end
end
function Packages:GetPackageRawCode(Name:string,dontUseCached:boolean)
    local code = RawCodes[Name]
    if dontUseCached or not code then
        code = GetPackageCode(Name)
        RawCodes[Name] = code
    end return code
end local PackageFirstLine = "--[[TPackage"
function Packages:GetPackageData(Name:string)
    local code = Packages:GetPackageRawCode(Name)
    local FirstLine = string.gsub(string.split(code,"\n")[1]," ","")
    local data = Classes:CreateTClass()
    data:AddClassName("PackageData")
    data.Name = Name
    data:SetReadOnly("Name")
    data.Code = code
    data:SetReadOnly("Code")
    data.IsPackage = string.sub(FirstLine,1,string.len(PackageFirstLine))==PackageFirstLine
    data:SetReadOnly("IsPackage")
    if data.IsPackage then
        local InCodeData = string.split(code,PackageFirstLine)
        InCodeData = string.split(InCodeData[2],"]]")[1]
        data.RawData = InCodeData
        local CompilatedData = {}
        local CompData = string.split(InCodeData,";")
        local VData:{Name:string,Data:string}
        for _,v in CompData do
            local split = string.split(v,":")
            if #split>1 then
                if VData then
                    CompilatedData[VData.Name] = string.match(VData.Data,"^%s*(.-)%s*$")
                end local Data = ""
                for k,v in split do
                    if k==1 then continue end
                    if k==2 then
                        Data = Data..v
                    else
                        Data = Data..":"..v
                    end
                end VData = {
                    Name=string.match(split[1],"^%s*(.-)%s*$"),
                    Data=Data
                } 
            else local Data = ";"
                if split[1] then
                    Data = Data..split[1]
                end VData.Data = VData.Data..Data
            end
        end CompilatedData[VData.Name] = string.match(VData.Data,"^%s*(.-)%s*$")
        function data:GetData()
            return table.clone(CompilatedData) :: {[string]:string}
        end
    else data.RawData = ""
        function data:GetData()
            return {}
        end
    end data:SetReadOnly("RawData")
    return data
end local requiredPackages = {}
function Packages:Require(Name:string)
    if not requiredPackages[Name] then
        requiredPackages[Name] = table.pack(pcall(function()
            return loadstring(Packages:GetPackageRawCode(Name))()
        end))
    end local pack = requiredPackages[Name]
    if pack[1] then
        return requiredPackages[Name][2]
    else logger:critical_error("Error to load package",pack[2])
    end
end

local s,Groups = pcall(function()
    local Groups = MakeGUIArchitectureClass()
    Groups:AddClassName("Groups")
    Groups.IsGlobal = true
    Groups:SetReadOnly("IsGlobal")
    Groups.GroupRefreshed:Connect(function()
        logger:debug("Updating Groups canvas size")
        GroupsSFrame.CanvasSize = Groups.GroupSize
    end)
    TimGui.Groups = Groups
    table.insert(TimGuiReadOnly,"Groups")
    Groups.GroupFrame = GroupsSFrame
    Groups:SetReadOnly("GroupFrame")
    return Groups
end) if not s then
    State.Saying:Load{ -- #LANG_REQUIRED
        ru="Произошла ошибка при создании класса Groups. См в консоли",
        en="There was an error creating the class Groups. See console.",
        uk="Виникла помилка при створенні класу Groups. Див у консолі"
    } State:SetErrorStateAndClose()
    logger:critical_error("MAIN","Error to create Settings group: \n"..tostring(Groups))
end
--MAIN --------
local s,Settings = pcall(function()
    local Settings = TimGui.Groups:CreateGroup("Settings")
    TimGui.GlobalOpenedGroup = Settings
    Settings.Opened = true
    --Settings:CreateGroup("Типо группа"):CreateGroup("Group2","Группа в группе")
    Settings.Title:Load{ -- #LANG_REQUIRED
        ru="Настройки",
        en="Settings",
        uk="Налаштування"
    }
    table.insert(TimGuiReadOnly,"GlobalOpenedGroup")
    return Settings
end) if not s then
    State.Saying:Load{ -- #LANG_REQUIRED
        ru="Произошла ошибка при создании группы. См в консоли",
        en="There was an error creating the group. See console.",
        uk="Виникла помилка при створенні групи. Див у консолі"
    } State:SetErrorStateAndClose()
    logger:critical_error("MAIN","Error to create Settings group: \n"..tostring(Settings))
end
State.Saying:Load{ -- #LANG_REQUIRED
    ru="Загрузка ядра: Загрузка группы Настроек",
    en="Loading core: Loading Settings group",
    --uk=""
}
local refreshingLang = false
local refreshingButtonPos = true
local Languages = Settings:CreateSequence("LanguagePreferences","Language (Язык/Мова)",function(_,langs)
    if not refreshingButtonPos then
        refreshingLang = true
        TimGui:SetLanguagePreferences(langs)
        SettingsSave:SetToSave("LangPreferences",langs)
    end
end,SupportedLanguages) Languages.ConfigSavingEnabled = false
local loadedLangPrefs = SettingsSave:GetFromSave("LangPreferences")
if type(loadedLangPrefs)=="table" then
    TimGui:SetLanguagePreferences(loadedLangPrefs)
end for k,v in TimGui.LanguagePreferences do
    Languages:SetObjectPosition(v,k)
end
task.wait()
refreshingButtonPos = false
onLanguageChanged.Event:Connect(function()
    if not refreshingLang then
        refreshingButtonPos = true
        for k,v in TimGui.LanguagePreferences do
            Languages:SetObjectPosition(v,k)
        end refreshingButtonPos = false
    else refreshingLang = false
    end
end)
local configuratorButton = Settings:CreateButton("Configurator",nil,function()
    ConfigsWindow.Opened = not ConfigsWindow.Opened
end) local configuratorTitle = { --#LANG_REQUIRED
    Closed = {
        en="Open configurator",
        ru="Открыть конфигуратор"
    }, Opened = {
        en="Close configurator",
        ru="Закрыть конфигуратор"
    }
}
configuratorButton.Title:Load(configuratorTitle.Closed)
ConfigsWindow:GetPropertyChangedEvent("Opened"):Connect(function()
    if ConfigsWindow.Opened then
        configuratorButton.Title:Load(configuratorTitle.Opened)
    else configuratorButton.Title:Load(configuratorTitle.Closed)
    end
end) configuratorButton.Visible = SavesIsSupported

testG = Groups:CreateGroup("Te",{
    en="Test",
    ru="Тест"
})
testG:CreateText("Title",{
    en="Testing saving objects in config:",
    ru="Тест сохранения в конфиг:"
})
testG:CreateToggle("TESTING CFG",{
    en="Toggle",
    ru="Переключатель"
})
testG:CreateTextbox("Test cfg on Textbox",{
    en="Textbox",
    ru="Текст коробка"
})
testG:CreateTextbox("Test cfg on number box",{
    en="Number box",
    ru="Число ящик"
}).InputType = "number"
task.wait(2.5)
State:ResetToDefault()
return TimGui
--[[
План:
    Сделать старые функции:
        Нормальные плавающие кнопки на бабафонах
        систему тем, таблицы с темами, которые могут добавлять другие скрипты
        Обширный Setup, со своей цветовой политрой размерами и тд
        choose(было askYN),свои кнопки(на Translator если не дали то Да или Нет) можно добавить :Run() или :Ask() или :Choose()
            и классы чтоб можно было менять уже запущенный
        notify(было print), также на Translator и с классами
    Новое:
        Как Dev Инструмент смотреть иерархию, тоесть проводник, и показывать ошибки(например когда кнопка в глобальных группах и из-за этого не отображается)
        NumberPrompt промпт где спросить юзера написать цифры
        Сделать NumberRange TGuiObject
        Сделать Color3 TGuiObject
        Чтобы сами читы можно было двигать
        Систему обновлений(уведомит что нового)
        Систему дополнений, и конфиги с сайта
        Интеграция сайта прям в читы, например скачивание дополнений/конфигов на прямую
        Попытаться интегрировать ДС канал
    Сделать Players:
        И тут получить игроков с пощадой
        ПОлучить без пощады
]]