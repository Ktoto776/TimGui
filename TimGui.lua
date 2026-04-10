local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
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
function TimGui:Exit()
    OnExitEvent:Fire()
    _G.TimGui = nil
end function TimGui:IsA(class:string)
    return class=="TimGui"
end TimGui.SetupData = _G.Setup or {}
TimGui.BaseDir = "TimGui/"
TimGui.Opened = false
_G.Setup = nil
_G.TimGui = TimGui
local onLanguageChanged = Instance.new("BindableEvent")
TimGui.LanguageChanged = onLanguageChanged.Event
table.insert(TimGuiReadOnly,"LanguageChanged")
TimGui.LanguagePreferences = {"uk","en"}
-- #FIND_POINT HttpGet
local HttpGet = TimGuiRaw.SetupData.HttpGet
TimGui.httpGet_BaseDir = TimGui.SetupData.linkToDir or "https://raw.githubusercontent.com/Robloxer228s/TimGUI/main/"
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
local Loggers = GetClassMetatable("TimGui.Loggers",{},LoggersReadOnly,true)
Loggers.Log = {}
local loggersTable = {}
function Loggers:IsA(class:string)
    return class=="TimGui.Loggers"or class=="Loggers"
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
end TimGui.Logger = Loggers
table.insert(TimGuiReadOnly,"Logger")
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
    event.BEvent = Instance.new("BindableEvent")
    event.Event = GetClassMetatable("TEvent",{},{},true)
    function event:Fire(...)
        event.args = table.pack(...)
        event.BEvent:Fire()
    end function event.Event:Connect(callback)
        if type(callback)~="function" then logger:critical_error("TEvent:Connect","Callback is incorrect.") end
        event.BEvent.Event:Connect(function()
            callback(table.unpack(event.args))
        end)
    end function event.Event:Once(callback)
        if type(callback)~="function" then logger:critical_error("TEvent:Connect","Callback is incorrect.") end
        event.BEvent.Event:Once(function()
            callback(table.unpack(event.args))
        end)
    end function event.Event:Wait()
        event.BEvent.Event:Wait()
        return table.unpack(event.args)
    end return event
end
function Classes:CreateTClass(rawClass:{any?}?,meta:{any}?,writeSameModeExclude:{string}?)
    if type(rawClass)~="table" then rawClass={} end
    local classReadOnly = {"OnPropertyChanged"}
    local onPropertyChangeEvent = Instance.new("BindableEvent")
    local onPropertyChangeEvents = {}
    local classNames = {"TClass"}
    local class = GetClassMetatable("TClass",rawClass,classReadOnly,true,meta,function(k, old, new)
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
local function RBXValueToTable(v)
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
    end return val
end local function TableToRBXValue(v)
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
    local Preset = Classes:CreateTClass(raw)
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
        end
        Preset.PresetName = tostring(preset.PresetName or "Unknown")
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
    Translator:AddClassName("Translator")
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
Colors.GroupOpenArrowColor = Color3.new(1,1,1)
Colors.LoadingColor = Color3.new(1,1,1)
Colors.TextColor = Color3.new(1,1,1)
Colors.GroupVisibleIndent = Color3.new(1,1,1)
Colors.HeaderSeparatorColor = Color3.new(0,0,0)
Colors.HeaderFirstNameColor = Color3.new(1,1,0)
Colors.HeaderSecondNameColor = Color3.new(1,0,1)
Colors.HeaderBackgroundColor = Color3.new(0.15, 0.15, 0.3)
Colors.MainBackgroundColor = Color3.new(0.15, 0.15, 0.3)
Colors.GroupsBackgroundColor = Color3.new(0.15, 0.15, 0.25)
Colors.ButtonBackground = Color3.fromRGB(50,50,100)
Colors.ErrorColor = Color3.new(1,0.3,0.3)
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
GuiSize.GroupOpenImageSize = UDim.new(0,25)
GuiSize.ButtonSize = UDim2.new(1,0,0,50)
GuiSize.ButtonCornerRadius = UDim.new(0.5,0)
GuiSize.NotGlobalGroupIndent = UDim.new(0,3)
GuiSize.NotGlobalGroupVisibleIndent = UDim.new(0,2)
GuiSize.Default = GuiSize:GetPreset()
function TimGui:GetFrameGuiPosition(opened:boolean?)
    if opened==nil then opened = TimGui.Opened end
    local position = UDim2.new(GuiSize.XPosition,GuiSize.YPosition)--GuiSize.HeaderSize)
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
end)
-- #FIND_POINT Header + GUI Header
local Header = Classes:CreatePreset()
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
end) Header.SeparatorSize = 3
Header.FirstName = Classes:CreateTranslator("Tim")
if type(TimGui.SetupData["FirstHeaderName"])=="table" then
    Header.FirstName:Load(TimGui.SetupData["FirstHeaderName"])
elseif TimGui.SetupData["FirstHeaderName"]~=nil then
    Header.FirstName.en = TimGui.SetupData["FirstHeaderName"]
end FirstName.Text = Header.FirstName:Translate()
Header.FirstName.TranslateValueChanged:Connect(function()
    FirstName.Text = Header.FirstName:Translate()
end)
Header.SecondName = Classes:CreateTranslator("Gui")
if type(TimGui.SetupData["SecondHeaderName"])=="table" then
    Header.SecondName:Load(TimGui.SetupData["SecondHeaderName"])
elseif TimGui.SetupData["SecondHeaderName"]~=nil then
    Header.SecondName.en = TimGui.SetupData["SecondHeaderName"]
end TwoName.Text = Header.SecondName:Translate()
Header.SecondName.TranslateValueChanged:Connect(function()
    TwoName.Text = Header.SecondName:Translate()
end)
TimGui.Header = Header
table.insert(TimGuiReadOnly,"Header")
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
local onNewChildListeners,onDescendantChangedListeners,onAncestorChanged = {},{},{}
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
    end) GUIArchitecture:GetPropertyChangedEvent("GroupFrame"):COnnect(function()
        for _,v in children do
            v.Frame.Parent = GUIArchitecture.GroupFrame
        end
    end)
    return GUIArchitecture
end
local LastTGuiObjectId = 0
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
    end -- TGuiObject Special colors
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
    end Object.SpecialColors = SpecialColors
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
    Object.Menu = {}
    Object:SetReadOnly("Menu")
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
    end) return Object
end
local function CreateButtonForTGuiObject(TGuiObject)
    if type(TGuiObject)~="table" or TGuiObject.__type~="TClass" or not TGuiObject:IsA("TGuiObject") then
        logger:critical_error("TGuiObject is incorrect") TGuiObject=TGuiObjectClass() 
    end TGuiObject:AddClassName("ButtonObject")
    TGuiObject.Frame.BackgroundTransparency = 1
    local Button = Instance.new("TextButton",TGuiObject.Frame)
    local destroyed = false
    TGuiObject.Destroying:Connect(function()
        destroyed = true
    end) Button.Size = UDim2.new(1,0,1,0)
    TGuiObject.Title.TranslateValueChanged:Connect(function()
        Button.Text = TGuiObject.Title:Translate()
    end) Button.Text = TGuiObject.Title:Translate()
    TGuiObject.SpecialColors:GetColorChangedSignal("ButtonBackground"):Connect(function()
        Button.BackgroundColor3 = TGuiObject.SpecialColors:GetColor("ButtonBackground")
    end) Button.BackgroundColor3 = TGuiObject.SpecialColors:GetColor("ButtonBackground")
    TGuiObject.SpecialColors:GetColorChangedSignal("ButtonBackground"):Connect(function()
        Button.TextColor3 = TGuiObject.SpecialColors:GetColor("TextColor")
    end) Button.TextColor3 = TGuiObject.SpecialColors:GetColor("TextColor")
    Button.TextScaled = true
    TGuiObject.UICorner.Parent = Button
    TGuiObject.Button = Button
    TGuiObject:SetReadOnly("Button")
    local Activated = Instance.new("BindableEvent")
    TGuiObject.Activated = Activated.Event
    Button.Activated:Connect(function()
        Activated:Fire()
    end) function TGuiObject:Activate()
        if destroyed then return end
        logger:info("ButtonObject: "..TGuiObject.Name.."["..TGuiObject.ClassName.."]","Emulating Activated event.")
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
-- #FIND_POINT TGroups
local GlobalOpenedGroup
local GlobalOpenedGroupChanged = Instance.new("BindableEvent")
TimGui.GlobalOpenedGroupChanged = GlobalOpenedGroupChanged.Event
table.insert(TimGuiReadOnly,"GlobalOpenedGroupChanged")
local GroupOpenArrowBind = Classes:CreateBind()
Binder.GroupOpenArrowBind = GroupOpenArrowBind
Binder:SetReadOnly("GroupOpenArrowBind")
GuiAnimations.EnableGroupAnimation = true
function GuiObjects:CreateGroup(Name:string,Title:string|{[string]:string}?,Parent:any?)
    logger:debug("GuiObjects:CreateGroup","Creating new group '"..Name.."'")
    local Group = TGuiObjectClass(Name,Title,Parent,MakeGUIArchitectureClass())
    Group = CreateButtonForTGuiObject(Group)
    if not Group then Group = MakeGUIArchitectureClass() end -- For roblox lsp
    Group:AddClassName("TGroup")
    Group.Opened = false
    Group.Type = "Group"
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
    Frame.Size = UDim2.new(0,100,1,0)
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
    local function refreshGroup()
        logger:debug("TGroup: refreshTGroup",`Refreshing Indent for {Group.Name}[{Group.ClassName}]`)
        GroupIndentBind:Run(Group,VisibleIndent,GroupFrame)
        for _,v in Group:GetChildren() do
            v:RefreshSize(true)
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
        end
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
    end) function Group:CreateButton(Name:string?,Title:string|{[string]: string}?,func:(any)->())
        return GuiObjects:CreateButton(Name,Title,Group,func)
    end
    return Group
end 
-- #FIND_POINT TButton
function GuiObjects:CreateButton(Name:string,Title:string|{[string]:string}?,Parent:any?,func:(any)->()?)
    logger:debug("GuiObjects:CreateButton","Creating new button '"..Name.."'")
    local Button = TGuiObjectClass(Name,Title,Parent)
    Button = CreateButtonForTGuiObject(Button)
    Button:AddClassName("TButton")
    Button.Type = "Button"
    Button.Activated:Connect(function()
        func(Button)
    end) return Button
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
                print(111,v.LastRefreshingPos)
                if v.LastRefreshingPos~=zeroPos then
                    pos = v.LastRefreshingPos
                end continue
            elseif pos==zeroPos then
                print(needPos,k,pos==zeroPos)
                logger:debug("RefreshingBind:Bind","Zero pos restart without FromObject")
                return RefreshingBind:Run(children)
            end
        end oldPositions[v] = {k,v.Parent}
        logger:debug("RefreshingBind:Bind",`Set new pos to {v.Name}`)
        pos = v.SpecialButtonPositionBind:Run(v,pos)
        print(v.LastRefreshingPos,pos)
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
    if GuiAnimations.ArrowRotateAnimationEnabled then
        Arrow.Rotation = rotation-180
        if LastGArrowTween then LastGArrowTween:Cancel() end
        LastGArrowTween = TweenService:Create(Arrow,GuiAnimations.GroupOpenArrowTI,{Rotation=rotation})
        LastGArrowTween:Play()
        LastGArrowTween.Completed:Once(function()
            LastGArrowTween = nil
        end) LastGroupTweens[Group] = LastGArrowTween
    else Arrow.Rotation = rotation
    end return true
end)

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
task.wait(1)
local s,Settings = pcall(function() 
    local Settings = TimGui.Groups:CreateGroup("Settings")
    TimGui.GlobalOpenedGroup = Settings
    Settings.Opened = true
    Settings:CreateGroup("Типо группа"):CreateGroup("Group2","Группа в группе")
    --Settings:CreateGroup("Tester")
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
local s2 = TimGui.Groups:CreateGroup("Settings2","Settings2")
State:ResetToDefault()
s2:CreateButton("TestingRefreshin")
s2:CreateButton("Testing",{
    ru="Переместить настройки",
    en="Move 'Settings' group",
    uk="Перемістити налаштування"
},function(Button)
    Settings.Parent = s2
end)
--GuiSize.GlobalGroupSize и GuiSize.ButtonSize
--Сделать: кнопки, binder для их позиций, и скролл который будет брать самую нижнюю для y и правую для x(учитывай AnchorPoint)
--Сделай систему для авто Y кнопкам и переменную ypos, а также присваивай id каждому уникальный
--[[
План:
    Сделать старые функции:
        Нормальные плавающие кнопки на бабафонах
        Добавить размер разделителя в Setup
        Обширный Setup, со своей цветовой политрой размерами и тд
        языки, теперь с возможностью на другой язык
        choose(было askYN),свои кнопки(на Translator если не дали то Да или Нет) можно добавить :Run() или :Ask() или :Choose()
            и классы чтоб можно было менять уже запущенный
        notify(было print), также на Translator и с классами
        конфиги
        часы, и чтоб можно было кастомить
    Новое:
        TextBoxPrompt, промпт где спросить юзера написать текста
        NumberPrompt тоже что и выше, только с цифрами
        Сделать Number TGuiObject
        Сделать Color3 TGuiObject
        Чтобы промты или сами читы можно было двигать
        Систему обновлений(уведомит что нового)
        Систему дополнений, и конфиги с сайта
        Интеграция сайта прям в читы, например скачивание дополнений/конфигов на прямую
        Попытаться интегрировать ДС канал 
    Сделать Players:
        И тут получить игроков с пощадой
        ПОлучить без пощады
]]