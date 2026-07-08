---@diagnostic disable: undefined-global
local data = _G.DefinitionSetup
local DocumentationPath = (data and data.DocsPath) or "./TimGUI-V3/Documentation/"

-- create .OUT folder
local outFolder = DocumentationPath.."OUT/"
-- compatibility for roblox and lua
if not makefolder and package then -- creating folder
    function makefolder(name)
        if package.config:sub(1,1) == "\\" then
            os.execute('md "' .. name .. '"')
        else
            os.execute('mkdir -p "' .. name .. '"')
        end
    end
end if not writefile and io then
    function writefile(path,value)
        local file,err = io.open(path, "w")
        if file then
            file:write(value)
            file:close()
        else error("Error to open file: "..err)
        end
    end
end
if not listfiles then
    function listfiles(path)
        local data = ""
        if package.config:sub(1,1) == "\\" then
            data = io.popen('dir "'..path..'" /B')
        else data = io.popen('dir "'..path..'" /B')
        end local files = {}
        for file in data:lines() do
            table.insert(files,file)
        end return files
    end
end if not readfile and io then
    function readfile(path)
        local file,err = io.open(path, "r")
        if file then
            local content = file:read("*all")
            file:close() return content
        else error("Error to open file: err")
        end
    end
end local s,JSONDecode = pcall(function()
    local HttpService = game:GetService("HttpService")
    return function(str)
        return HttpService:JSONDecode(str)
    end
end) if not s then
    local json = require("json")
    function JSONDecode(str)
        return json.decode(str)
    end
end

--GLOBALS
local function savefile(name,val)
    return writefile(outFolder..name..".d.lua",val)
end
makefolder(outFolder)
local russianLang = data and data.russianLang russianLang = true
local packs = (data and data.packages) or {"TimGui"}
local tab = "    "

--PACKAGES
for _,packName in pairs(packs) do
    local packPath = DocumentationPath..packName.."/"
    local result = "---@diagnostic disable: undefined-type\n"
    result = result.."---@meta"

    local function NewProperty(k,v)
        local prop = ""
        -- Set Description
        local desc = v.description
        if not desc or russianLang then
            desc = v["description-ru"]
        end if desc then
            prop = "--[["..desc.." ]]\n"
        end if v.readonly then
            prop = prop.."--*[ReadOnly]*\n"
        end if v.isWriteSameModeException then
            prop = prop.."--*[Exception for WriteSameMode]*\n"
        end -- Set deprecated
        if v.deprecated then
            prop = prop.."--@deprecated\n"
        end -- MAIN + type
        prop = prop.."---@field "..k.." "..(v.dType or v.class or v.type)
        return prop
    end
    local function NewMethod(k,v,ClassName)
        local prop = ""
        -- Set Description
        local desc = v.description
        if not desc or russianLang then
            desc = v["description-ru"]
        end if desc then
            prop = "--[["..desc.." ]]\n"
        end-- Set deprecated
        if v.deprecated then
            prop = prop.."--@deprecated\n"
        end -- Params
        local args = {}
        if v.args then
            for _,arg in pairs(v.args) do
                table.insert(args,arg.name)
                local desc = arg.description
                if not desc or russianLang then
                    desc = arg["description-ru"]
                end if not desc then
                    desc = ""
                end prop = prop.."---@param "..arg.name.." "..(arg.dType or arg.class or arg.type).." "..desc
                if not arg.required then
                    prop = prop.."?"
                end prop = prop.."\n"
            end
        end -- Returns
        if v.returns then
            for _,ret in pairs(v.args) do
                local desc = ret.description
                if not desc or russianLang then
                    desc = ret["description-ru"]
                end if not desc then
                    desc = ""
                end prop = prop.."---@return "..(ret.dType or ret.class or ret.type).." "..ret.name.." "..desc.."\n"
            end
        end
        -- MAIN + type
        prop = prop.."function "..ClassName..":"..k.."("..table.concat(args,",")..") end"
        return prop
    end
    local ScriptSignal = [[
    %Signal% = {}
    ---@param callback fun(%callback2%)
    ---@return RBXScriptConnection
    function %Signal%:Connect(callback:(%callback%)->()) end
    ---@param callback fun(%callback2%)
    ---@return RBXScriptConnection
    function %Signal%:Once(callback:(%callback%)->()) end
    %returnCallback%
    function %Signal%:Wait() end]]
    local function NewEvent(k,v,ClassName)
        local prop = "---@type "..v.type.."\n"
        -- Set Description
        local desc = v.description
        if not desc or russianLang then
            desc = v["description-ru"]
        end if desc then
            prop = prop.."--[["..desc.." ]]\n"
        end -- Set deprecated
        if v.deprecated then
            prop = prop.."--@deprecated\n"
        end -- MAIN
        prop = prop..ScriptSignal
        local signalName = k.."_"..v.type
        prop = string.gsub(prop,"%%Signal%%",signalName)
        local args,args2 = "",""
        local returnArgs = ""
        if v.args then
            for k,v in pairs(v.args) do
                if k~=1 then args = args.."," args2 = args2.."," returnArgs = returnArgs.."\n" end
                local typ = (v.class or v.type)
                args = args..v.name..":"..typ
                args2 = args2..v.name
                if string.find(typ,"?") then args2 = args2.."?" end
                args2 = args2..":"..string.gsub(typ,"%?","")
                returnArgs = returnArgs.."---@return "..(v.dType or v.class or v.type).." "..v.name
            end
        end prop = string.gsub(prop,"%%callback%%",args)
        prop = string.gsub(prop,"%%callback2%%",args2)
        prop = string.gsub(prop,"%%returnCallback%%",returnArgs)
        prop = prop.."\n"..ClassName.."['"..k.."']="..signalName
        return prop
    end
    ---@return TClass name
    -- callback: Arg:any, returnCallback RunF: ---@param, Bind: string
    local BindInstance = [[
    %Bind% = {}
    ---@param callback fun(%callback%)
    ---*return (%returnArgsDesc%)*
    function %Bind%:Bind(callback:(%callback%)->()) end
    %RunF%
    function %Bind%:Run(%callback%) end

    %Bind%_OnRun = {}
    ---@param callback fun(%callback%)
    ---@return RBXScriptConnection
    function %Bind%_OnRun:Connect(callback:(%callback%)->()) end
    ---@param callback fun(%callback%)
    ---@return RBXScriptConnection
    function %Bind%_OnRun:Once(callback:(%callback%)->()) end
    %returnCallback%
    function %Bind%_OnRun:Wait() end
    %Bind%.OnRun = %Bind%_OnRun
    ]]
    local function NewBind(k,v,ClassName)
        local prop = "---@type Bind\n"
        -- Set Description
        local desc = v.description
        if not desc or russianLang then
            desc = v["description-ru"]
        end if desc then
            prop = prop.."--[["..desc.." ]]\n"
        end -- Set deprecated
        if v.deprecated then
            prop = prop.."--@deprecated\n"
        end -- MAIN + type
        prop = prop..BindInstance
        local BindName = k.."_Bind"
        prop = string.gsub(prop,"%%Bind%%",BindName)
        local callback,retCall,RunF = "","",""
        for k,v in pairs(v.args) do
            if k~=1 then callback = callback.."," retCall = retCall.."\n" RunF=RunF.."\n" end
            callback = callback..v.name..": "..(v.class or v.type)
            retCall = retCall.."---@return "..(v.dType or v.class or v.type).." "..v.name
            RunF=RunF.."---@param "..v.name.." "..(v.dType or v.class or v.type)
        end prop = string.gsub(prop,"%%callback%%",callback)
        prop = string.gsub(prop,"%%returnCallback%%",retCall)
        local returnArgsDesc = ""
        for k,v in pairs(v.returns) do
            if k~=1 then returnArgsDesc=returnArgsDesc..", " end
            RunF=RunF.."\n"
            RunF=RunF.."---@return "..(v.dType or v.class or v.type).." "..v.name
            returnArgsDesc = returnArgsDesc..v.name..": "..(v.class or v.type)
        end prop = string.gsub(prop,"%%RunF%%",RunF)
        prop = string.gsub(prop,"%%returnArgsDesc%%",returnArgsDesc)
        prop = prop..ClassName.."['"..k.."']= "..BindName
        return prop
    end

    local function NewObject(ClassName) print(ClassName)
        local data = JSONDecode(readfile(packPath..ClassName))
        local Object = ""
        if data.class then
            -- Set ClassName
            Object = "---@class "..data.class
            -- Set inherited
            if data.inherited then
                Object = Object.." : "..table.concat(data.inherited," : ")
            end
        else --Set type
            Object = "---@type "..data.type
        end -- Fields
            -- Properties(class)
        if data.properties then
            for k,v in pairs(data.properties) do
                print(tab..k.." [property]")
                Object = Object.."\n"..NewProperty(k,v)
            end
        end -- Set deprecated
        if data.deprecated then
            Object = Object.."\n---@deprecated"
        end -- Set description
        local desc = data.description
        if not desc or russianLang then
            desc = data["description-ru"]
        end if desc then
            Object = Object.."\n--[["..desc.." ]]"
        end -- Set main variable
        if data.type~="function" then
            Object = Object.."\n"..ClassName.."={}"
        end -- Methods(class)
        if data.methods then
            for k,v in pairs(data.methods) do
                print(tab..k.." [method]")
                Object = Object.."\n"..NewMethod(k,v,ClassName)
            end
        end -- Events(class)
        if data.events then
            for k,v in pairs(data.events) do
                print(tab..k.." [event]")
                Object = Object.."\n"..NewEvent(k,v,ClassName)
            end
        end -- Binds(class)
        if data.binds then
            for k,v in pairs(data.binds) do
                print(tab..k.." [bind]")
                Object = Object.."\n"..NewBind(k,v,ClassName)
            end
        end
        return Object
    end
    for _,v in pairs(listfiles(packPath)) do 
        local Name 
        if package then
            Name = v
        else Name = string.sub(v,string.len(packPath)+1)
        end
        if string.sub(Name,1,1)~="." then
            result = result.."\n\n"..NewObject(Name)
        end
    end savefile(packName,result)
end