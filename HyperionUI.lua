--[[
    ╦ ╦╦ ╦╔═╗╔═╗╦═╗╦╔═╗╔╗╔
    ╠═╣╚╦╝╠═╝║╣ ╠╦╝║║ ║║║║
    ╩ ╩ ╩ ╩  ╚═╝╩╚═╩╚═╝╝╚╝
    
    Hyperion UI Library v3.0
    Premium Roblox Interface System
    
    Dark Purple Theme | Modern & Clean
    
    License: MIT
--]]

----------------------------------------------------------------
-- ENVIRONMENT COMPATIBILITY
----------------------------------------------------------------
cloneref = cloneref or function(i) return i end
clonefunction = clonefunction or function(...) return ... end
getgenv = getgenv or getfenv
protect_gui = protect_gui or (syn and syn.protect_gui) or function() end
isfile = isfile or function() return false end
readfile = readfile or function() return "" end
writefile = writefile or function() end
makefolder = makefolder or function() end
isfolder = isfolder or function() return false end
listfiles = listfiles or function() return {} end

----------------------------------------------------------------
-- SERVICES
----------------------------------------------------------------
local Players        = cloneref(game:GetService("Players"))
local TweenService   = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService     = cloneref(game:GetService("RunService"))
local TextService    = cloneref(game:GetService("TextService"))
local HttpService    = cloneref(game:GetService("HttpService"))

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

----------------------------------------------------------------
-- LIBRARY ROOT
----------------------------------------------------------------
local Hyperion = {}
Hyperion.Windows      = {}
Hyperion.Flags        = {}
Hyperion.FlagCallbacks = {}
Hyperion.Connections  = {}
Hyperion.ThemeListeners = {}  -- functions called whenever SetTheme fires
Hyperion.Version      = "3.0.0"
Hyperion.Unloaded     = false

----------------------------------------------------------------
-- THEME
----------------------------------------------------------------
Hyperion.Theme = {
    -- Accent
    Accent          = Color3.fromRGB(140, 80, 220),
    AccentDark      = Color3.fromRGB(100, 50, 180),
    AccentLight     = Color3.fromRGB(170, 110, 255),
    AccentGlow      = Color3.fromRGB(160, 90, 240),
    AccentSub       = Color3.fromRGB(90, 45, 160),

    -- Backgrounds
    Background      = Color3.fromRGB(12, 10, 18),
    Surface         = Color3.fromRGB(18, 15, 26),
    SurfaceLight    = Color3.fromRGB(26, 22, 38),
    SurfaceHover    = Color3.fromRGB(34, 28, 50),
    SurfaceActive   = Color3.fromRGB(40, 33, 58),

    -- Sidebar
    Sidebar         = Color3.fromRGB(14, 12, 22),
    SidebarActive   = Color3.fromRGB(28, 23, 44),

    -- Text
    Text            = Color3.fromRGB(230, 225, 245),
    TextDim         = Color3.fromRGB(145, 135, 170),
    TextMuted       = Color3.fromRGB(80, 72, 105),

    -- Borders
    Border          = Color3.fromRGB(38, 32, 56),
    BorderLight     = Color3.fromRGB(52, 44, 75),

    -- States
    Success         = Color3.fromRGB(75, 210, 115),
    Warning         = Color3.fromRGB(245, 185, 55),
    Error           = Color3.fromRGB(225, 65, 75),
    Info            = Color3.fromRGB(100, 160, 255),

    -- Element specific
    ToggleOff       = Color3.fromRGB(40, 35, 58),
    SliderBg        = Color3.fromRGB(28, 24, 42),
    InputBg         = Color3.fromRGB(16, 13, 24),

    -- Radii
    CornerRadius    = UDim.new(0, 6),
    CornerSmall     = UDim.new(0, 4),
    CornerLarge     = UDim.new(0, 8),

    -- Fonts
    Font            = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular,  Enum.FontStyle.Normal),
    FontMedium      = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium,   Enum.FontStyle.Normal),
    FontSemiBold    = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
    FontBold        = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold,     Enum.FontStyle.Normal),
}

Hyperion.Lucide = {
    Save       = "rbxassetid://10734941499",  -- lucide-save
    Download   = "rbxassetid://10723344270",  -- lucide-download
    Upload     = "rbxassetid://10747366434",  -- lucide-upload
    Trash      = "rbxassetid://10747362393",  -- lucide-trash
    Trash2     = "rbxassetid://10747362241",  -- lucide-trash-2
    Plus       = "rbxassetid://10734924532",  -- lucide-plus
    Minus      = "rbxassetid://10734896206",  -- lucide-minus
    Edit       = "rbxassetid://10734883598",  -- lucide-edit
    Edit2      = "rbxassetid://10723344885",  -- lucide-edit-2
    Pencil     = "rbxassetid://10734919691",  -- lucide-pencil
    RefreshCw  = "rbxassetid://10734933222",  -- lucide-refresh-cw
    RefreshCcw = "rbxassetid://10734933056",  -- lucide-refresh-ccw
    List       = "rbxassetid://10723433811",  -- lucide-list
    ListChecks = "rbxassetid://10734884548",  -- lucide-list-checks
    Check      = "rbxassetid://10709790644",  -- lucide-check
    X          = "rbxassetid://10747384394",  -- lucide-x
    XCircle    = "rbxassetid://10747383819",  -- lucide-x-circle
    Search     = "rbxassetid://10734943674",  -- lucide-search
    Settings   = "rbxassetid://10734950309",  -- lucide-settings
    Folder     = "rbxassetid://10723387563",  -- lucide-folder
    FolderOpen = "rbxassetid://10723386277",  -- lucide-folder-open
    FolderPlus = "rbxassetid://10723386531",  -- lucide-folder-plus
    File       = "rbxassetid://10723374641",  -- lucide-file
    FilePlus   = "rbxassetid://10723365877",  -- lucide-file-plus
    FileText   = "rbxassetid://10723367380",  -- lucide-file-text
    Copy       = "rbxassetid://10709812159",  -- lucide-copy
    Clipboard  = "rbxassetid://10709799288",  -- lucide-clipboard
    Eye        = "rbxassetid://10723346959",  -- lucide-eye
    EyeOff     = "rbxassetid://10723346871",  -- lucide-eye-off
    Lock       = "rbxassetid://10723434711",  -- lucide-lock
    Unlock     = "rbxassetid://10747366027",  -- lucide-unlock
    Info       = "rbxassetid://10723415903",  -- lucide-info
    AlertCircle = "rbxassetid://10709752996", -- lucide-alert-circle
    ChevronDown = "rbxassetid://10709790948", -- lucide-chevron-down
    ChevronUp   = "rbxassetid://10709791523", -- lucide-chevron-up
    Home       = "rbxassetid://10723407389",  -- lucide-home
    Star       = "rbxassetid://10734966248",  -- lucide-star
    Heart      = "rbxassetid://10723406885",  -- lucide-heart
    Gamepad    = "rbxassetid://10723395215",  -- lucide-gamepad-2
    Shield     = "rbxassetid://10734951847",  -- lucide-shield
    Zap        = "rbxassetid://10723345749",  -- lucide-electricity
    Target     = "rbxassetid://10734977012",  -- lucide-target
    Globe      = "rbxassetid://10723404337",  -- lucide-globe
    User       = "rbxassetid://10747373176",  -- lucide-user
    Users      = "rbxassetid://10747373426",  -- lucide-users
    Power      = "rbxassetid://10734930466",  -- lucide-power
    Terminal   = "rbxassetid://10734982144",  -- lucide-terminal
    Code       = "rbxassetid://10709810463",  -- lucide-code
    Bug        = "rbxassetid://10709782845",  -- lucide-bug
    Wrench     = "rbxassetid://10747383470",  -- lucide-wrench
    Sliders    = "rbxassetid://10734963400",  -- lucide-sliders
    Palette    = "rbxassetid://10734910430",  -- lucide-palette
}

----------------------------------------------------------------
-- THEME PRESETS
----------------------------------------------------------------
Hyperion.Themes = {
    Purple = {
        Logo         = nil,  -- uses the default/base logo: rbxassetid://74070104523360
        Accent       = Color3.fromRGB(140, 80, 220),
        AccentDark   = Color3.fromRGB(100, 50, 180),
        AccentLight  = Color3.fromRGB(170, 110, 255),
        AccentGlow   = Color3.fromRGB(160, 90, 240),
        AccentSub    = Color3.fromRGB(90, 45, 160),
        Background   = Color3.fromRGB(12, 10, 18),
        Surface      = Color3.fromRGB(18, 15, 26),
        SurfaceLight = Color3.fromRGB(26, 22, 38),
        SurfaceHover = Color3.fromRGB(34, 28, 50),
        SurfaceActive= Color3.fromRGB(40, 33, 58),
        Sidebar      = Color3.fromRGB(14, 12, 22),
        SidebarActive= Color3.fromRGB(28, 23, 44),
        Text         = Color3.fromRGB(230, 225, 245),
        TextDim      = Color3.fromRGB(145, 135, 170),
        TextMuted    = Color3.fromRGB(80, 72, 105),
        Border       = Color3.fromRGB(38, 32, 56),
        BorderLight  = Color3.fromRGB(52, 44, 75),
        ToggleOff    = Color3.fromRGB(40, 35, 58),
        SliderBg     = Color3.fromRGB(28, 24, 42),
        InputBg      = Color3.fromRGB(16, 13, 24),
    },
    Midnight = {
        Logo         = nil, -- uses the default/base logo
        Accent       = Color3.fromRGB(80, 120, 255),
        AccentDark   = Color3.fromRGB(50, 85, 200),
        AccentLight  = Color3.fromRGB(110, 150, 255),
        AccentGlow   = Color3.fromRGB(90, 130, 255),
        AccentSub    = Color3.fromRGB(45, 75, 175),
        Background   = Color3.fromRGB(8, 10, 18),
        Surface      = Color3.fromRGB(13, 16, 28),
        SurfaceLight = Color3.fromRGB(20, 24, 42),
        SurfaceHover = Color3.fromRGB(28, 33, 56),
        SurfaceActive= Color3.fromRGB(34, 40, 66),
        Sidebar      = Color3.fromRGB(10, 13, 22),
        SidebarActive= Color3.fromRGB(22, 28, 48),
        Text         = Color3.fromRGB(220, 228, 255),
        TextDim      = Color3.fromRGB(130, 145, 185),
        TextMuted    = Color3.fromRGB(65, 76, 110),
        Border       = Color3.fromRGB(28, 35, 60),
        BorderLight  = Color3.fromRGB(40, 50, 85),
        ToggleOff    = Color3.fromRGB(30, 37, 62),
        SliderBg     = Color3.fromRGB(20, 26, 48),
        InputBg      = Color3.fromRGB(10, 13, 24),
    },
    Rose = {
        Logo         = nil, -- uses the default/base logo
        Accent       = Color3.fromRGB(220, 80, 120),
        AccentDark   = Color3.fromRGB(175, 50, 90),
        AccentLight  = Color3.fromRGB(245, 110, 150),
        AccentGlow   = Color3.fromRGB(230, 90, 130),
        AccentSub    = Color3.fromRGB(145, 40, 75),
        Background   = Color3.fromRGB(14, 8, 10),
        Surface      = Color3.fromRGB(22, 13, 17),
        SurfaceLight = Color3.fromRGB(32, 20, 26),
        SurfaceHover = Color3.fromRGB(42, 27, 34),
        SurfaceActive= Color3.fromRGB(50, 33, 41),
        Sidebar      = Color3.fromRGB(16, 10, 13),
        SidebarActive= Color3.fromRGB(34, 21, 28),
        Text         = Color3.fromRGB(245, 228, 232),
        TextDim      = Color3.fromRGB(170, 140, 152),
        TextMuted    = Color3.fromRGB(90, 68, 76),
        Border       = Color3.fromRGB(50, 28, 36),
        BorderLight  = Color3.fromRGB(68, 40, 52),
        ToggleOff    = Color3.fromRGB(48, 30, 38),
        SliderBg     = Color3.fromRGB(30, 18, 24),
        InputBg      = Color3.fromRGB(16, 9, 12),
    },
}

-- Apply a named theme or a custom table of color overrides.
function Hyperion:SetTheme(nameOrTable)
    local preset = type(nameOrTable) == "string"
        and Hyperion.Themes[nameOrTable]
        or nameOrTable
    if not preset then
        warn("Hyperion:SetTheme — unknown theme: " .. tostring(nameOrTable))
        return
    end
    -- Store the logo override so windows can read it
    Hyperion._themeLogo = preset.Logo or nil
    for k, v in pairs(preset) do
        if k ~= "Logo" then
            Hyperion.Theme[k] = v
        end
    end
    for _, fn in ipairs(Hyperion.ThemeListeners) do
        pcall(fn, Hyperion.Theme)
    end
end

function Hyperion:OnThemeChanged(fn)
    table.insert(Hyperion.ThemeListeners, fn)
    return function()
        for i, v in ipairs(Hyperion.ThemeListeners) do
            if v == fn then table.remove(Hyperion.ThemeListeners, i); break end
        end
    end
end

----------------------------------------------------------------
-- UTILITY MODULE
----------------------------------------------------------------
local Util = {}

function Util.Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

function Util.Tween(obj, duration, props, style, direction)
    if not obj or not obj.Parent then return end
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

function Util.TweenFast(obj, props)
    return Util.Tween(obj, 0.12, props)
end

function Util.TweenSmooth(obj, props)
    return Util.Tween(obj, 0.28, props, Enum.EasingStyle.Quint)
end

function Util.AddCorner(parent, radius)
    return Util.Create("UICorner", {CornerRadius = radius or Hyperion.Theme.CornerRadius, Parent = parent})
end

function Util.AddStroke(parent, color, thickness, transparency)
    return Util.Create("UIStroke", {
        Color = color or Hyperion.Theme.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

function Util.AddPadding(parent, t, r, b, l)
    return Util.Create("UIPadding", {
        PaddingTop    = UDim.new(0, t or 0),
        PaddingRight  = UDim.new(0, r or t or 0),
        PaddingBottom = UDim.new(0, b or t or 0),
        PaddingLeft   = UDim.new(0, l or r or t or 0),
        Parent = parent
    })
end

function Util.AddList(parent, dir, padding, hAlign, vAlign, sortOrder)
    return Util.Create("UIListLayout", {
        FillDirection       = dir or Enum.FillDirection.Vertical,
        Padding             = UDim.new(0, padding or 4),
        HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Left,
        VerticalAlignment   = vAlign or Enum.VerticalAlignment.Top,
        SortOrder           = sortOrder or Enum.SortOrder.LayoutOrder,
        Parent = parent
    })
end

function Util.Ripple(button, color)
    local ripple = Util.Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = color or Hyperion.Theme.AccentLight,
        BackgroundTransparency = 0.65,
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        ZIndex = button.ZIndex + 1,
        Parent = button
    })
    Util.AddCorner(ripple, UDim.new(1, 0))
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.2
    Util.Tween(ripple, 0.45, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1})
    task.delay(0.5, function()
        if ripple and ripple.Parent then ripple:Destroy() end
    end)
end

-- Safe connection tracking
function Util.Connect(signal, fn)
    local conn = signal:Connect(fn)
    table.insert(Hyperion.Connections, conn)
    return conn
end

----------------------------------------------------------------
-- NOTIFICATION SYSTEM
----------------------------------------------------------------
local NotifHolder

function Hyperion:_InitNotifications(parent)
    NotifHolder = Util.Create("Frame", {
        Name = "HyperionNotifs",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 240, 1, 0),
        Position = UDim2.new(1, -252, 0, 0),
        ZIndex = 100,
        Parent = parent
    })
    Util.AddList(NotifHolder, Enum.FillDirection.Vertical, 6, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
    Util.AddPadding(NotifHolder, 0, 0, 20, 0)
end

function Hyperion:Notify(config)
    config = config or {}
    local title    = config.Title or "Hyperion"
    local content  = config.Content or ""
    local duration = config.Duration or 4
    local nType    = config.Type or "Info"

    if not NotifHolder then return end

    local Theme = Hyperion.Theme
    local accentMap = {
        Info    = Theme.Info,
        Success = Theme.Success,
        Warning = Theme.Warning,
        Error   = Theme.Error,
    }
    local accent = accentMap[nType] or Theme.Accent

    -- Outer card
    local notif = Util.Create("Frame", {
        Name             = "Notif",
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        BorderSizePixel  = 0,
        ClipsDescendants = false,
        Parent           = NotifHolder,
    })
    Util.AddCorner(notif, Theme.CornerSmall)
    Util.AddStroke(notif, Theme.BorderLight, 1, 0.25)

    -- Inner layout row: icon | text stack
    local Row = Util.Create("Frame", {
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        Parent           = notif,
    })
    Util.AddList(Row, Enum.FillDirection.Horizontal, 10)
    Util.AddPadding(Row, 10, 12, 10, 12)

    -- Circular icon badge
    local IconCircle = Util.Create("Frame", {
        BackgroundColor3 = accent,
        BackgroundTransparency = 0.82,
        Size             = UDim2.new(0, 28, 0, 28),
        BorderSizePixel  = 0,
        LayoutOrder      = 1,
        Parent           = Row,
    })
    Util.AddCorner(IconCircle, UDim.new(1, 0))
    Util.AddStroke(IconCircle, accent, 1, 0.6)

    -- Icon inside circle
    Util.Create("ImageLabel", {
        BackgroundTransparency = 1,
        Size             = UDim2.new(0, 14, 0, 14),
        Position         = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Image            = "rbxassetid://10734941499",
        ImageColor3      = accent,
        ScaleType        = Enum.ScaleType.Fit,
        ZIndex           = 2,
        Parent           = IconCircle,
    })

    -- Text stack (title + body)
    local TextStack = Util.Create("Frame", {
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, -(28 + 10 + 24), 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        LayoutOrder      = 2,
        Parent           = Row,
    })
    Util.AddList(TextStack, Enum.FillDirection.Vertical, 2)

    Util.Create("TextLabel", {
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, 0, 0, 16),
        Text             = title,
        TextColor3       = accent,
        FontFace         = Theme.FontBold,
        TextSize         = 13,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = TextStack,
    })

    if content ~= "" then
        Util.Create("TextLabel", {
            BackgroundTransparency = 1,
            Size             = UDim2.new(1, 0, 0, 0),
            AutomaticSize    = Enum.AutomaticSize.Y,
            Text             = content,
            TextColor3       = Theme.TextDim,
            FontFace         = Theme.Font,
            TextSize         = 12,
            TextXAlignment   = Enum.TextXAlignment.Left,
            TextWrapped      = true,
            Parent           = TextStack,
        })
    end

    -- Slide in from right, fade in
    notif.Position = UDim2.new(1, 20, 0, 0)
    task.spawn(function()
        Util.Tween(notif, 0.3, {
            BackgroundTransparency = 0,
            Position = UDim2.new(0, 0, 0, 0),
        }, Enum.EasingStyle.Quint)
        task.wait(duration)
        Util.Tween(notif, 0.25, {
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 20, 0, 0),
        }, Enum.EasingStyle.Quint)
        task.wait(0.3)
        if notif and notif.Parent then notif:Destroy() end
    end)
end

----------------------------------------------------------------
-- CONFIG SYSTEM
----------------------------------------------------------------
local Config = {}

function Config.EnsureFolder()
    if not isfolder("Hyperion") then pcall(makefolder, "Hyperion") end
    if not isfolder("Hyperion/Configs") then pcall(makefolder, "Hyperion/Configs") end
end

function Config.Save(name, flags)
    Config.EnsureFolder()
    local data = {}
    for flag, value in pairs(flags) do
        local t = typeof(value)
        if t == "Color3" then
            data[flag] = {_t = "Color3", R = value.R, G = value.G, B = value.B}
        elseif t == "EnumItem" then
            data[flag] = {_t = "Enum", V = tostring(value)}
        elseif type(value) == "table" then
            data[flag] = {_t = "Table", V = value}
        elseif type(value) == "boolean" or type(value) == "number" or type(value) == "string" then
            data[flag] = {_t = type(value), V = value}
        end
    end
    local ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
    if ok then
        pcall(writefile, "Hyperion/Configs/" .. name .. ".json", encoded)
        return true
    end
    return false
end

function Config.Load(name, flags, callbacks)
    Config.EnsureFolder()
    local path = "Hyperion/Configs/" .. name .. ".json"
    if not isfile(path) then return false end
    local ok, raw = pcall(readfile, path)
    if not ok then return false end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok2 or type(data) ~= "table" then return false end
    for flag, info in pairs(data) do
        if type(info) ~= "table" then continue end
        if info._t == "Color3" then
            flags[flag] = Color3.new(info.R or 1, info.G or 1, info.B or 1)
        elseif info._t == "Enum" and info.V then
            -- Restore EnumItem from its string representation
            local ok3, enumVal = pcall(function()
                local parts = string.split(tostring(info.V), ".")
                if #parts == 3 then
                    return Enum[parts[2]][parts[3]]
                end
            end)
            if ok3 and enumVal then flags[flag] = enumVal end
        elseif info._t == "Table" then
            flags[flag] = info.V
        elseif info._t == "boolean" or info._t == "number" or info._t == "string" then
            flags[flag] = info.V
        end
        -- Fire callbacks to update UI visuals
        if callbacks and callbacks[flag] then
            task.spawn(callbacks[flag], flags[flag])
        end
    end
    return true
end

function Config.List()
    Config.EnsureFolder()
    local out = {}
    local ok, files = pcall(listfiles, "Hyperion/Configs")
    if ok then
        for _, f in ipairs(files) do
            local n = string.match(f, "([^/\\]+)%.json$")
            if n then table.insert(out, n) end
        end
    end
    return out
end

function Config.Delete(name)
    Config.EnsureFolder()
    local path = "Hyperion/Configs/" .. name .. ".json"
    if not isfile(path) then return false end
    local removeFn = (typeof(delfile) == "function" and delfile)
        or (typeof(fremovefile) == "function" and fremovefile)
        or nil
    if removeFn then
        pcall(removeFn, path)
    end
    return true
end

----------------------------------------------------------------
-- GLOBAL INPUT POOLING (avoids hundreds of InputChanged connections)
----------------------------------------------------------------

-- AutoLoad: call after all elements are built to restore a config silently
function Hyperion:AutoLoad(name)
    name = name or "default"
    if isfile("Hyperion/Configs/" .. name .. ".json") then
        Config.Load(name, Hyperion.Flags, Hyperion.FlagCallbacks)
        return true
    end
    return false
end

-- AutoSave: saves current flags under the given name (default "default")
function Hyperion:AutoSave(name)
    return Config.Save(name or "default", Hyperion.Flags)
end
local InputPool = {
    SliderCallbacks = {},
    ColorCallbacks  = {},
}

Util.Connect(UserInputService.InputChanged, function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        for _, cb in ipairs(InputPool.SliderCallbacks) do
            cb(input)
        end
        for _, cb in ipairs(InputPool.ColorCallbacks) do
            cb(input)
        end
    end
end)

----------------------------------------------------------------
-- CREATE WINDOW
----------------------------------------------------------------
function Hyperion:CreateWindow(config)
    config = config or {}
    local windowConfig = {
        Title    = config.Title or "Hyperion",
        Logo     = config.Logo or "rbxassetid://74070104523360",
        Size     = config.Size or UDim2.new(0, 760, 0, 540),
        Keybind  = config.Keybind or Enum.KeyCode.RightControl,
        Theme    = config.Theme or {},
        -- Key system
        Key      = config.Key,        -- string or table of valid keys
        KeySave  = config.KeySave ~= false, -- save key to file so user only enters once (default true)
        KeyTitle = config.KeyTitle or "Key Required",
        KeySub   = config.KeySub   or "Enter your access key to continue.",
    }

    -- Apply theme overrides
    for k, v in pairs(windowConfig.Theme) do
        Hyperion.Theme[k] = v
    end
    local Theme = Hyperion.Theme

    -- Window object
    local WindowObj = {}
    WindowObj.Tabs      = {}
    WindowObj.ActiveTab = nil
    WindowObj.Flags     = Hyperion.Flags
    WindowObj.Visible   = true
    WindowObj.MinSize   = config.MinSize or UDim2.new(0, 560, 0, 380)
    WindowObj.CurrentSize = windowConfig.Size

    -- Themed(instance, propMap) — registers an instance so its properties
    -- are updated automatically whenever SetTheme() is called.
    -- propMap: { PropertyName = function(theme) return value end }
    -- Example: Themed(frame, { BackgroundColor3 = function(t) return t.Surface end })
    local function Themed(instance, propMap)
        Hyperion:OnThemeChanged(function(t)
            if not instance or not instance.Parent then return end
            for prop, fn in pairs(propMap) do
                pcall(function() instance[prop] = fn(t) end)
            end
        end)
    end

    local function ApplyThemeNow(instance, propMap)
        if not instance or not instance.Parent then return end
        local t = Hyperion.Theme
        for prop, fn in pairs(propMap) do
            pcall(function() instance[prop] = fn(t) end)
        end
    end

    -- ScreenGui
    local ScreenGui = Util.Create("ScreenGui", {
        Name = "Hyperion_" .. HttpService:GenerateGUID(false):sub(1, 8),
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        DisplayOrder    = 999,
        IgnoreGuiInset  = true,
    })
    pcall(protect_gui, ScreenGui)
    ScreenGui.Parent = CoreGui

    local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local MobileToggleButton = Util.Create("TextButton", {
        Name = "MobileToggleButton",
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 0.08,
        Size = UDim2.new(0, 46, 0, 46),
        Position = UDim2.new(0, 14, 1, -60),
        BorderSizePixel = 0,
        Text = "H",
        TextColor3 = Theme.Text,
        FontFace = Theme.FontBold,
        TextSize = 16,
        AutoButtonColor = false,
        Visible = true,
        ZIndex = 150,
        Parent = ScreenGui
    })
    Util.AddCorner(MobileToggleButton, UDim.new(1, 0))
    local _mobileStroke = Util.AddStroke(MobileToggleButton, Theme.BorderLight, 1, 0.1)
    Themed(MobileToggleButton, {
        BackgroundColor3 = function(t) return t.Surface end,
        TextColor3 = function(t) return t.Text end,
    })
    Themed(_mobileStroke, { Color = function(t) return t.BorderLight end })

    local MobileAccent = Util.Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.15,
        Size = UDim2.new(0, 14, 0, 3),
        Position = UDim2.new(0.5, -7, 1, -9),
        BorderSizePixel = 0,
        ZIndex = 151,
        Parent = MobileToggleButton
    })
    Util.AddCorner(MobileAccent, UDim.new(1, 0))
    Themed(MobileAccent, { BackgroundColor3 = function(t) return t.Accent end })

    -- Notifications
    Hyperion:_InitNotifications(ScreenGui)

    -- Loading screen
    -- ============================================================
    -- LOADING SCREEN
    -- ============================================================
    local LoadingOverlay = Util.Create("Frame", {
        Name             = "LoadingOverlay",
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0,
        Size             = UDim2.new(1, 0, 1, 0),
        BorderSizePixel  = 0,
        ZIndex           = 200,
        Parent           = ScreenGui,
    })
    local LoadingOverlayGradient = Util.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 8, 36)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(42, 16, 70)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 50, 190)),
        }),
        Rotation = 35,
        Parent = LoadingOverlay,
    })

    -- Radial vignette
    local LoadingVignette = Util.Create("Frame", {
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        BorderSizePixel = 0,
        ZIndex = 201,
        Parent = LoadingOverlay,
    })
    Util.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0,0,0)),
            ColorSequenceKeypoint.new(0.6, Color3.new(0,0,0)),
            ColorSequenceKeypoint.new(1, Color3.new(0,0,0)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.55, 0.6),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Rotation = 90,
        Parent = LoadingVignette,
    })

    local hasLogo = windowConfig.Logo ~= nil

    -- Center card
    local LoadingPanel = Util.Create("Frame", {
        BackgroundColor3 = Theme.Surface,
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Position         = UDim2.new(0.5, 0, 0.52, 0),
        Size             = UDim2.new(0, 340, 0, 150),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ZIndex           = 202,
        Parent           = LoadingOverlay,
    })
    Util.AddCorner(LoadingPanel, Theme.CornerLarge)
    Util.AddStroke(LoadingPanel, Theme.BorderLight, 1, 0.15)

    -- Bottom accent gradient line
    local AccentBar = Util.Create("Frame", {
        BackgroundColor3 = Color3.new(1,1,1),
        Size = UDim2.new(0, 0, 0, 1),   -- animates width in
        Position = UDim2.new(0.5, 0, 1, -1),
        AnchorPoint = Vector2.new(0.5, 0),
        BorderSizePixel = 0, ZIndex = 204,
        Parent = LoadingPanel,
    })
    Util.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.AccentDark),
            ColorSequenceKeypoint.new(0.5, Theme.AccentLight),
            ColorSequenceKeypoint.new(1, Theme.AccentDark),
        }),
        Parent = AccentBar,
    })

    -- Logo (large, centered above title)
    local LoadingLogo = Util.Create("ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position    = UDim2.new(0.5, 0, 0.34, 0),
        Size        = UDim2.new(0, 78, 0, 78),
        Image       = windowConfig.Logo or "",
        ImageColor3 = Theme.Accent,
        ImageTransparency = 1,
        ScaleType   = Enum.ScaleType.Fit,
        Visible     = hasLogo,
        ZIndex      = 203,
        Parent      = LoadingPanel,
    })

    local LoadingPulseActive = true
    task.spawn(function()
        if not hasLogo then return end
        while LoadingPulseActive and LoadingLogo and LoadingLogo.Parent do
            Util.Tween(LoadingLogo, 0.9, {
                Size = UDim2.new(0, 84, 0, 84),
                ImageTransparency = 0.08,
            }, Enum.EasingStyle.Sine)
            task.wait(0.95)
            if not LoadingPulseActive then break end
            Util.Tween(LoadingLogo, 0.9, {
                Size = UDim2.new(0, 78, 0, 78),
                ImageTransparency = 0.18,
            }, Enum.EasingStyle.Sine)
            task.wait(0.95)
        end
    end)

    local titleX = 0

    local LoadingTitle = Util.Create("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position  = UDim2.new(0.5, 0, 0, 74),
        Size      = UDim2.new(1, -24, 0, 24),
        Text      = windowConfig.Title,
        TextColor3 = Theme.Text,
        FontFace  = Theme.FontBold,
        TextSize  = 22,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex    = 203,
        Parent    = LoadingPanel,
    })

    local LoadingSub = Util.Create("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position  = UDim2.new(0.5, 0, 0, 100),
        Size      = UDim2.new(1, -24, 0, 14),
        Text      = "Loading interface...",
        TextColor3 = Theme.TextMuted,
        FontFace  = Theme.Font,
        TextSize  = 11,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex    = 203,
        Parent    = LoadingPanel,
    })

    local LoadingTrack = Util.Create("Frame", {
        BackgroundColor3 = Theme.InputBg,
        Position  = UDim2.new(0, 22, 1, -24),
        Size      = UDim2.new(1, -44, 0, 4),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex    = 203,
        Parent    = LoadingPanel,
    })
    Util.AddCorner(LoadingTrack, UDim.new(1, 0))

    local LoadingFill = Util.Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        Size      = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex    = 204,
        Parent    = LoadingTrack,
    })
    Util.AddCorner(LoadingFill, UDim.new(1, 0))
    Util.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.AccentDark),
            ColorSequenceKeypoint.new(1, Theme.AccentLight),
        }),
        Parent = LoadingFill,
    })

    -- ============================================================
    -- KEY SYSTEM (optional)
    -- ============================================================
    -- Validate a key attempt against config.Key (string or table)
    local function IsValidKey(attempt)
        local k = windowConfig.Key
        if type(k) == "string" then
            return attempt == k
        elseif type(k) == "table" then
            for _, v in ipairs(k) do
                if attempt == v then return true end
            end
        end
        return false
    end

    -- Check if key was already saved to disk
    local keyFile = "Hyperion/key.dat"
    local keyAlreadySaved = false
    if windowConfig.Key and windowConfig.KeySave then
        local ok, saved = pcall(readfile, keyFile)
        if ok and saved ~= "" and IsValidKey(saved) then
            keyAlreadySaved = true
        end
    end

    -- Key UI elements (only built when needed)
    local KeyInput, KeyVerifyBtn, KeyStatusLbl, KeyBox
    local keyVerified = (not windowConfig.Key) or keyAlreadySaved
    local keyResolved = false  -- signals the loader to continue

    if windowConfig.Key and not keyAlreadySaved then
        -- Resize panel to fit key input
        LoadingPanel.Size = UDim2.new(0, 340, 0, 200)

        KeyBox = Util.Create("Frame", {
            BackgroundColor3 = Theme.InputBg,
            Position = UDim2.new(0, 18, 1, -80),
            Size = UDim2.new(1, -36, 0, 34),
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 205,
            Visible = false,
            Parent = LoadingPanel,
        })
        Util.AddCorner(KeyBox, Theme.CornerSmall)
        Util.AddStroke(KeyBox, Theme.Border, 1, 0.3)

        KeyInput = Util.Create("TextBox", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -44, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Text = "",
            PlaceholderText = "Enter key...",
            TextColor3 = Theme.Text,
            PlaceholderColor3 = Theme.TextMuted,
            FontFace = Theme.Font,
            TextSize = 12,
            ClearTextOnFocus = false,
            ZIndex = 206,
            Parent = KeyBox,
        })

        KeyVerifyBtn = Util.Create("TextButton", {
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(0, 34, 0, 34),
            Position = UDim2.new(1, 0, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            Text = "→",
            TextColor3 = Color3.new(1,1,1),
            FontFace = Theme.FontBold,
            TextSize = 14,
            AutoButtonColor = false,
            ZIndex = 206,
            Parent = KeyBox,
        })
        Util.AddCorner(KeyVerifyBtn, Theme.CornerSmall)

        KeyStatusLbl = Util.Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 18, 1, -40),
            Size = UDim2.new(1, -36, 0, 14),
            Text = "",
            TextColor3 = Theme.Error,
            FontFace = Theme.Font,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextTransparency = 1,
            ZIndex = 205,
            Parent = LoadingPanel,
        })

        -- Shake animation on wrong key
        local function ShakePanel()
            local orig = LoadingPanel.Position
            for i = 1, 4 do
                local dir = (i % 2 == 0) and 8 or -8
                Util.Tween(LoadingPanel, 0.04, {Position = UDim2.new(orig.X.Scale, orig.X.Offset + dir, orig.Y.Scale, orig.Y.Offset)}, Enum.EasingStyle.Linear)
                task.wait(0.05)
            end
            Util.Tween(LoadingPanel, 0.08, {Position = orig}, Enum.EasingStyle.Linear)
        end

        local function TryKey()
            local attempt = KeyInput.Text
            if IsValidKey(attempt) then
                -- Save to disk if KeySave enabled
                if windowConfig.KeySave then
                    pcall(makefolder, "Hyperion")
                    pcall(writefile, keyFile, attempt)
                end
                keyVerified = true
                keyResolved = true
                -- Green flash
                KeyStatusLbl.Text = "✓ Access granted"
                KeyStatusLbl.TextColor3 = Theme.Success
                Util.Tween(KeyStatusLbl, 0.2, {TextTransparency = 0}, Enum.EasingStyle.Quint)
                Util.Tween(KeyBox, 0.2, {BackgroundColor3 = Color3.fromRGB(30, 60, 35)})
            else
                -- Red flash + shake
                task.spawn(ShakePanel)
                KeyStatusLbl.Text = "✗ Invalid key"
                KeyStatusLbl.TextColor3 = Theme.Error
                Util.Tween(KeyStatusLbl, 0.15, {TextTransparency = 0}, Enum.EasingStyle.Quint)
                task.delay(1.8, function()
                    Util.Tween(KeyStatusLbl, 0.3, {TextTransparency = 1}, Enum.EasingStyle.Quint)
                end)
                Util.Tween(KeyBox, 0.15, {BackgroundColor3 = Color3.fromRGB(50, 20, 22)})
                task.delay(0.6, function()
                    Util.Tween(KeyBox, 0.3, {BackgroundColor3 = Theme.InputBg})
                end)
            end
        end

        KeyVerifyBtn.MouseButton1Click:Connect(TryKey)
        KeyInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then TryKey() end
        end)
    end

    -- ============================================================
    -- LOADING ANIMATION
    -- ============================================================
    task.spawn(function()
        -- Phase 1: card rises and fades in
        Util.Tween(LoadingPanel, 0.5, {
            BackgroundTransparency = 0,
            Position = UDim2.new(0.5, 0, 0.5, 0),
        }, Enum.EasingStyle.Quint)
        task.wait(0.08)
        if hasLogo then
            Util.Tween(LoadingLogo, 0.5, {
                ImageTransparency = 0.12,
                Size = UDim2.new(0, 82, 0, 82)
            }, Enum.EasingStyle.Quint)
        end
        task.wait(0.08)
        Util.Tween(LoadingTitle, 0.4, {TextTransparency = 0}, Enum.EasingStyle.Quint)
        task.wait(0.08)

        if windowConfig.Key and not keyAlreadySaved then
            -- Show key prompt instead of "Loading interface..."
            LoadingSub.Text = windowConfig.KeyTitle
            LoadingSub.TextColor3 = Theme.TextDim
            Util.Tween(LoadingSub, 0.35, {TextTransparency = 0}, Enum.EasingStyle.Quint)
            task.wait(0.25)
            -- Reveal key input box
            if KeyBox then
                KeyBox.Visible = true
                KeyBox.BackgroundTransparency = 1
                Util.Tween(KeyBox, 0.3, {BackgroundTransparency = 0}, Enum.EasingStyle.Quint)
            end
            -- Wait for the player to enter a valid key
            while not keyResolved do
                task.wait(0.05)
            end
            task.wait(0.4)  -- brief pause after success
            -- Hide key UI
            if KeyBox then Util.Tween(KeyBox, 0.2, {BackgroundTransparency = 1}) end
            if KeyStatusLbl then Util.Tween(KeyStatusLbl, 0.2, {TextTransparency = 1}) end
            task.wait(0.15)
            -- Switch sub label to loading
            LoadingSub.Text = "Loading interface..."
            LoadingSub.TextColor3 = Theme.TextMuted
        else
            Util.Tween(LoadingSub, 0.35, {TextTransparency = 0.15}, Enum.EasingStyle.Quint)
        end
        task.wait(0.3)

        -- Phase 2: accent bar + progress
        Util.Tween(AccentBar, 0.75, {Size = UDim2.new(0.92, 0, 0, 1)}, Enum.EasingStyle.Quint)
        task.wait(0.2)
        Util.Tween(LoadingTrack, 0.3, {BackgroundTransparency = 0}, Enum.EasingStyle.Quint)
        Util.Tween(LoadingFill,  0.3, {BackgroundTransparency = 0}, Enum.EasingStyle.Quint)
        task.wait(0.15)
        Util.Tween(LoadingFill, 1.8, {Size = UDim2.new(1, 0, 1, 0)}, Enum.EasingStyle.Quint)
        task.wait(2.0)

        -- Phase 3: smooth exit
        LoadingPulseActive = false
        Util.Tween(LoadingPanel, 0.5, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.46, 0),
        }, Enum.EasingStyle.Quint)
        Util.Tween(LoadingTitle, 0.35, {TextTransparency = 1}, Enum.EasingStyle.Quint)
        Util.Tween(LoadingSub,   0.28, {TextTransparency = 1}, Enum.EasingStyle.Quint)
        Util.Tween(LoadingTrack, 0.28, {BackgroundTransparency = 1}, Enum.EasingStyle.Quint)
        Util.Tween(LoadingFill,  0.28, {BackgroundTransparency = 1}, Enum.EasingStyle.Quint)
        if hasLogo then
            Util.Tween(LoadingLogo, 0.35, {ImageTransparency = 1}, Enum.EasingStyle.Quint)
        end
        task.wait(0.12)
        Util.Tween(LoadingOverlay, 0.5, {BackgroundTransparency = 1}, Enum.EasingStyle.Quint)
        task.wait(0.7)
        if LoadingOverlay and LoadingOverlay.Parent then
            LoadingOverlay:Destroy()
        end
    end)

    -- ============================================================
    -- MAIN FRAME
    -- ============================================================
    local MainFrame = Util.Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Theme.Background,
        Size = windowConfig.Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = false,
        Parent = ScreenGui
    })
    Util.AddCorner(MainFrame, Theme.CornerLarge)
    local _mfStroke = Util.AddStroke(MainFrame, Theme.Border, 1, 0.2)
    Themed(MainFrame, { BackgroundColor3 = function(t) return t.Background end })
    Themed(_mfStroke, { Color = function(t) return t.Border end })

    -- Background image layer (sits behind all content, optional)
    local BgImage = Util.Create("ImageLabel", {
        Name             = "BgImage",
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, 0, 1, 0),
        Image            = "",
        ImageTransparency = 0,
        ScaleType        = Enum.ScaleType.Crop,
        ZIndex           = 0,
        Visible          = false,
        Parent           = MainFrame,
    })
    Util.AddCorner(BgImage, Theme.CornerLarge)

    -- Dark tint over bg image so text stays readable
    local BgTint = Util.Create("Frame", {
        Name             = "BgTint",
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.45,
        Size             = UDim2.new(1, 0, 1, 0),
        BorderSizePixel  = 0,
        ZIndex           = 1,
        Visible          = false,
        Parent           = MainFrame,
    })
    Util.AddCorner(BgTint, Theme.CornerLarge)

    -- Drop shadow (outside via negative offset)
    local Shadow = Util.Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 50, 1, 50),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.45,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = -1,
        Parent = MainFrame
    })

    -- ============================================================
    -- HEADER (48px)
    -- ============================================================
    local HeaderHeight = 52
    local Header = Util.Create("Frame", {
        Name = "Header",
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(1, 0, 0, HeaderHeight),
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = MainFrame
    })
    -- Only round top corners
    Util.AddCorner(Header, Theme.CornerLarge)
    local _headerBottomFix = Util.Create("Frame", {
        Name = "BottomFix",
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = Header
    })
    Themed(Header, { BackgroundColor3 = function(t) return t.Surface end })
    Themed(_headerBottomFix, { BackgroundColor3 = function(t) return t.Surface end })

    -- Accent gradient line at bottom of header
    local AccentLine = Util.Create("Frame", {
        Name = "AccentLine",
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BorderSizePixel = 0,
        ZIndex = 6,
        Parent = Header
    })
    local _accentGradient = Util.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.AccentDark),
            ColorSequenceKeypoint.new(0.5, Theme.Accent),
            ColorSequenceKeypoint.new(1, Theme.AccentDark),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.7),
            NumberSequenceKeypoint.new(0.5, 0.3),
            NumberSequenceKeypoint.new(1, 0.7),
        }),
        Parent = AccentLine
    })
    Themed(_accentGradient, {
        Color = function(t)
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, t.AccentDark),
                ColorSequenceKeypoint.new(0.5, t.Accent),
                ColorSequenceKeypoint.new(1, t.AccentDark),
            })
        end
    })

    -- Logo + Title container
    local LogoContainer = Util.Create("Frame", {
        Name = "LogoContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 360, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        ZIndex = 6,
        Parent = Header
    })

    local hasLogo = windowConfig.Logo ~= nil
    local LogoImage = Util.Create("ImageLabel", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 72, 0, 72),
        Position = UDim2.new(0, 0, 0.5, 2),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = "",
        ImageColor3 = Theme.Accent,
        Visible = false,
        ZIndex = 6,
        Parent = LogoContainer
    })

    local function ApplyWindowLogo(themeObj)
        local activeLogo = Hyperion._themeLogo or windowConfig.Logo

        if typeof(activeLogo) == "number" then
            activeLogo = "rbxassetid://" .. tostring(activeLogo)
        elseif type(activeLogo) == "string" and activeLogo ~= "" and not string.find(activeLogo, "rbxassetid://", 1, true) then
            if string.match(activeLogo, "^%d+$") then
                activeLogo = "rbxassetid://" .. activeLogo
            end
        end

        LogoImage.Image = activeLogo or ""
        LogoImage.ImageColor3 = themeObj.Accent
        LogoImage.Visible = (activeLogo ~= nil and activeLogo ~= "")
    end

    Hyperion:OnThemeChanged(function(t)
        ApplyWindowLogo(t)
    end)

    ApplyWindowLogo(Theme)

    local TitleLabel = Util.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -(hasLogo and 72 or 0), 1, 0),
        Position = UDim2.new(0, hasLogo and 72 or 0, 0, 0),
        Text = windowConfig.Title,
        TextColor3 = Color3.new(1, 1, 1),
        FontFace = Theme.FontBold,
        TextSize = 24,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 6,
        Parent = LogoContainer
    })
    local _titleGradient = Util.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Text),
            ColorSequenceKeypoint.new(0.5, Theme.AccentLight),
            ColorSequenceKeypoint.new(1, Theme.Text),
        }),
        Parent = TitleLabel
    })
    Themed(_titleGradient, {
        Color = function(t)
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, t.Text),
                ColorSequenceKeypoint.new(0.5, t.AccentLight),
                ColorSequenceKeypoint.new(1, t.Text),
            })
        end
    })

    local SubtitleLabel = Util.Create("TextLabel", {
        Name = "Subtitle",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 1, 0, 1),
        Position = UDim2.new(0, 0, 0, 0),
        Text = "",
        TextTransparency = 1,
        ZIndex = 6,
        Parent = LogoContainer
    })

    local TopRightInfo = Util.Create("Frame", {
        Name = "TopRightInfo",
        BackgroundColor3 = Theme.SurfaceLight,
        BackgroundTransparency = 0.18,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -46, 0.5, 0),
        Size = UDim2.new(0, 200, 0, 36),
        BorderSizePixel = 0,
        ZIndex = 6,
        Parent = Header
    })
    Util.AddCorner(TopRightInfo, Theme.CornerSmall)
    local _topInfoStroke = Util.AddStroke(TopRightInfo, Theme.BorderLight, 1, 0.18)
    Themed(TopRightInfo, { BackgroundColor3 = function(t) return t.SurfaceLight end })
    Themed(_topInfoStroke, { Color = function(t) return t.BorderLight end })

    local executorName = "Unknown"
    pcall(function()
        if identifyexecutor then
            executorName = tostring(identifyexecutor())
        elseif getexecutorname then
            executorName = tostring(getexecutorname())
        end
    end)

    local thumb = ""
    pcall(function()
        thumb = Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size48x48
        )
    end)

    local PlayerIcon = Util.Create("ImageLabel", {
        Name = "PlayerIcon",
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 5, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = thumb,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 7,
        Parent = TopRightInfo
    })
    Util.AddCorner(PlayerIcon, UDim.new(1, 0))
    Util.AddStroke(PlayerIcon, Theme.BorderLight, 1, 0.1)

    local UserInfo = Util.Create("TextLabel", {
        Name = "UserInfo",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 38, 0, 3),
        Size = UDim2.new(1, -44, 0, 12),
        Text = "User: " .. LocalPlayer.Name,
        TextColor3 = Theme.Text,
        FontFace = Theme.FontSemiBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
        Parent = TopRightInfo
    })
    Themed(UserInfo, { TextColor3 = function(t) return t.Text end })

    local ExecutorInfo = Util.Create("TextLabel", {
        Name = "ExecutorInfo",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 38, 0, 14),
        Size = UDim2.new(1, -44, 0, 11),
        Text = "Executor: " .. executorName,
        TextColor3 = Theme.TextDim,
        FontFace = Theme.FontMedium,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
        Parent = TopRightInfo
    })
    Themed(ExecutorInfo, { TextColor3 = function(t) return t.TextDim end })

    local ExpiresInfo = Util.Create("TextLabel", {
        Name = "ExpiresInfo",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 38, 0, 24),
        Size = UDim2.new(1, -44, 0, 11),
        Text = "Expires: Never",
        TextColor3 = Theme.TextMuted,
        FontFace = Theme.Font,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
        Parent = TopRightInfo
    })

    -- Minimize button
    local MinBtn = Util.Create("TextButton", {
        Name = "MinBtn",
        BackgroundColor3 = Theme.SurfaceLight,
        BackgroundTransparency = 0.62,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -12, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Text = "—",
        TextColor3 = Theme.TextDim,
        FontFace = Theme.FontSemiBold,
        TextSize = 12,
        AutoButtonColor = false,
        ZIndex = 7,
        Parent = Header
    })
    Util.AddCorner(MinBtn, Theme.CornerSmall)

    MinBtn.MouseEnter:Connect(function()
        Util.TweenFast(MinBtn, {BackgroundTransparency = 0, BackgroundColor3 = Theme.SurfaceHover, TextColor3 = Theme.Text})
    end)
    MinBtn.MouseLeave:Connect(function()
        Util.TweenFast(MinBtn, {BackgroundTransparency = 0.5, BackgroundColor3 = Theme.SurfaceLight, TextColor3 = Theme.TextDim})
    end)
    MinBtn.MouseButton1Click:Connect(function()
        WindowObj:Toggle()
    end)

    -- ============================================================
    -- SIDEBAR
    -- ============================================================
    local SidebarWidth = 144
    local Sidebar = Util.Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, SidebarWidth, 1, -HeaderHeight),
        Position = UDim2.new(0, 0, 0, HeaderHeight),
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = MainFrame
    })
    Themed(Sidebar, { BackgroundColor3 = function(t) return t.Sidebar end })

    -- Right border line
    local _sidebarBorder = Util.Create("Frame", {
        Name = "Border",
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.4,
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = Sidebar
    })
    Themed(_sidebarBorder, { BackgroundColor3 = function(t) return t.Border end })

    -- ── Tabs scroll (leaves 40px at bottom for folder button) ──────────────
    local TabContainer = Util.Create("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -1, 1, -48),
        Position = UDim2.new(0, 0, 0, 5),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 3,
        Parent = Sidebar
    })
    Util.AddList(TabContainer, Enum.FillDirection.Vertical, 2)
    Util.AddPadding(TabContainer, 6, 8, 6, 8)

    -- ================================================================
    -- BOTTOM BAR (Search | Config | Info) — row of 3 icon buttons
    -- ================================================================
    local BottomBar = Util.Create("Frame", {
        Name             = "BottomBar",
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, 0, 0, 32),
        Position         = UDim2.new(0, 0, 1, -36),
        BorderSizePixel  = 0,
        ZIndex           = 6,
        Parent           = Sidebar,
    })
    -- Separator above bar
    local _bottomSep = Util.Create("Frame", {
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, -16, 0, 1),
        Position = UDim2.new(0, 8, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 6,
        Parent = BottomBar,
    })
    Themed(_bottomSep, { BackgroundColor3 = function(t) return t.Border end })

    local BottomRow = Util.Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 5),
        ZIndex = 6,
        Parent = BottomBar,
    })
    Util.AddList(BottomRow, Enum.FillDirection.Horizontal, 3,
        Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
    Util.AddPadding(BottomRow, 0, 0, 0, 6)

    -- Helper to create bottom bar buttons
    local function MakeBottomBtn(icon, name)
        local btn = Util.Create("ImageButton", {
            Name             = "BottomBtn_" .. name,
            BackgroundColor3 = Theme.SurfaceLight,
            BackgroundTransparency = 0.5,
            Size             = UDim2.new(0, 16, 0, 16),
            BorderSizePixel  = 0,
            Image            = icon,
            ImageColor3      = Theme.TextMuted,
            ScaleType        = Enum.ScaleType.Fit,
            AutoButtonColor  = false,
            ZIndex           = 7,
            Parent           = BottomRow,
        })
        Util.AddCorner(btn, UDim.new(0, 3))
        Themed(btn, {
            ImageColor3 = function(t) return t.TextMuted end,
        })

        btn.MouseEnter:Connect(function()
            Util.TweenFast(btn, {
                BackgroundTransparency = 0.1,
                ImageColor3            = Theme.Accent,
            })
        end)
        btn.MouseLeave:Connect(function()
            Util.TweenFast(btn, {
                BackgroundTransparency = 0.5,
                ImageColor3            = Theme.TextMuted,
            })
        end)
        return btn
    end

    local SearchBtn = MakeBottomBtn("rbxassetid://10734943674", "Search")   -- lucide-search
    local FolderOpenBtn = MakeBottomBtn("rbxassetid://10723387563", "Config") -- lucide-folder
    local InfoBtn   = MakeBottomBtn("rbxassetid://10723415903", "Info")      -- lucide-info

    -- ── Search popup ──────────────────────────────────────────────────────
    local searchOpen = false
    local SearchOverlay = Util.Create("Frame", {
        Name             = "SearchOverlay",
        BackgroundColor3 = Theme.Sidebar,
        Size             = UDim2.new(0, SidebarWidth - 16, 0, 34),
        Position         = UDim2.new(0, 8, 1, -72),
        ClipsDescendants = true,
        Visible          = false,
        ZIndex           = 8,
        Parent           = Sidebar,
    })
    Util.AddCorner(SearchOverlay, Theme.CornerSmall)
    Util.AddStroke(SearchOverlay, Theme.BorderLight, 1, 0.2)
    Themed(SearchOverlay, { BackgroundColor3 = function(t) return t.SurfaceLight end })

    local SearchBox = Util.Create("TextBox", {
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, -12, 1, 0),
        Position         = UDim2.new(0, 8, 0, 0),
        Text             = "",
        PlaceholderText  = "Search tabs...",
        TextColor3       = Theme.Text,
        PlaceholderColor3 = Theme.TextMuted,
        FontFace         = Theme.Font,
        TextSize         = 12,
        ClearTextOnFocus = true,
        ZIndex           = 9,
        Parent           = SearchOverlay,
    })
    Themed(SearchBox, {
        TextColor3        = function(t) return t.Text end,
        PlaceholderColor3 = function(t) return t.TextMuted end,
    })

    local function FilterTabs(query)
        query = string.lower(query)
        for _, child in ipairs(TabContainer:GetChildren()) do
            if child:IsA("TextButton") and child.Name:find("^Tab_") then
                if query == "" then
                    child.Visible = true
                else
                    local tabName = string.lower(string.gsub(child.Name, "^Tab_", ""))
                    child.Visible = string.find(tabName, query, 1, true) ~= nil
                end
            elseif child:IsA("Frame") and child.Name:find("^Cat_") then
                if query == "" then
                    child.Visible = true
                else
                    child.Visible = false
                end
            end
        end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        FilterTabs(SearchBox.Text)
    end)
    SearchBox.FocusLost:Connect(function()
        if SearchBox.Text == "" then
            FilterTabs("")
        end
    end)

    SearchBtn.MouseButton1Click:Connect(function()
        searchOpen = not searchOpen
        if searchOpen then
            SearchOverlay.Visible = true
            SearchBox:CaptureFocus()
            Util.TweenFast(SearchBtn, {ImageColor3 = Theme.Accent, BackgroundTransparency = 0})
        else
            SearchOverlay.Visible = false
            SearchBox.Text = ""
            FilterTabs("")
            Util.TweenFast(SearchBtn, {ImageColor3 = Theme.TextDim, BackgroundTransparency = 0.35})
        end
    end)

    -- Click anywhere outside search to close it
    Util.Connect(UserInputService.InputBegan, function(input, processed)
        if not searchOpen then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local pos = input.Position
        local sPos = SearchOverlay.AbsolutePosition
        local sSize = SearchOverlay.AbsoluteSize
        local insideSearch = pos.X >= sPos.X and pos.X <= sPos.X + sSize.X
            and pos.Y >= sPos.Y and pos.Y <= sPos.Y + sSize.Y
        local btnPos = SearchBtn.AbsolutePosition
        local btnSize = SearchBtn.AbsoluteSize
        local insideBtn = pos.X >= btnPos.X and pos.X <= btnPos.X + btnSize.X
            and pos.Y >= btnPos.Y and pos.Y <= btnPos.Y + btnSize.Y
        if not insideSearch and not insideBtn then
            searchOpen = false
            SearchOverlay.Visible = false
            SearchBox.Text = ""
            FilterTabs("")
            Util.TweenFast(SearchBtn, {ImageColor3 = Theme.TextDim, BackgroundTransparency = 0.35})
        end
    end)

    -- ── Info popup ────────────────────────────────────────────────────────
    local infoOpen = false
    local InfoOverlay = Util.Create("Frame", {
        Name             = "InfoOverlay",
        BackgroundColor3 = Theme.Surface,
        Size             = UDim2.new(0, SidebarWidth - 16, 0, 0),
        Position         = UDim2.new(0, 8, 1, -72),
        ClipsDescendants = true,
        Visible          = false,
        ZIndex           = 8,
        Parent           = Sidebar,
    })
    Util.AddCorner(InfoOverlay, Theme.CornerSmall)
    Util.AddStroke(InfoOverlay, Theme.BorderLight, 1, 0.2)
    Themed(InfoOverlay, { BackgroundColor3 = function(t) return t.Surface end })

    local InfoContent = Util.Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 80),
        ZIndex = 9,
        Parent = InfoOverlay,
    })
    Util.AddList(InfoContent, Enum.FillDirection.Vertical, 3)
    Util.AddPadding(InfoContent, 8, 10, 8, 10)

    local function InfoLine(text, color, font)
        return Util.Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 13),
            Text = text,
            TextColor3 = color or Theme.TextDim,
            FontFace = font or Theme.Font,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 10,
            Parent = InfoContent,
        })
    end

    InfoLine("Hyperion UI v" .. Hyperion.Version, Theme.Accent, Theme.FontSemiBold)
    InfoLine("by Phobia", Theme.TextDim, Theme.Font)
    InfoLine("", Theme.TextMuted, Theme.Font) -- spacer
    InfoLine("RightCtrl — Toggle UI", Theme.TextMuted, Theme.Font)
    InfoLine("Folder icon — Configs", Theme.TextMuted, Theme.Font)

    InfoBtn.MouseButton1Click:Connect(function()
        infoOpen = not infoOpen
        if infoOpen then
            InfoOverlay.Visible = true
            Util.TweenSmooth(InfoOverlay, {Size = UDim2.new(0, SidebarWidth - 16, 0, 86)})
            Util.TweenFast(InfoBtn, {ImageColor3 = Theme.Accent, BackgroundTransparency = 0})
        else
            Util.TweenSmooth(InfoOverlay, {Size = UDim2.new(0, SidebarWidth - 16, 0, 0)})
            Util.TweenFast(InfoBtn, {ImageColor3 = Theme.TextDim, BackgroundTransparency = 0.35})
            task.delay(0.28, function()
                if not infoOpen then InfoOverlay.Visible = false end
            end)
        end
    end)

    -- Config folder button uses same logic as before
    local FolderOpenStroke = FolderOpenBtn:FindFirstChildOfClass("UIStroke")
    Themed(FolderOpenBtn, {
        BackgroundColor3 = function(t)
            return _G._HyperionCfgOpen and t.SurfaceActive or t.SurfaceLight
        end,
        ImageColor3 = function(t)
            return _G._HyperionCfgOpen and t.Accent or t.TextDim
        end,
    })
    if FolderOpenStroke then
        Themed(FolderOpenStroke, {
            Color = function(t)
                return _G._HyperionCfgOpen and t.Accent or t.Border
            end
        })
    end

    -- ================================================================
    -- CONFIG PANEL
    -- Opens to the RIGHT of the sidebar, full content-area height.
    -- Slides in/out horizontally.
    -- ================================================================
    local CFG_W         = 260   -- panel width
    local cfgPanelOpen  = false
    local selectedCfgName = nil
    _G._HyperionCfgOpen = false

    -- Parent to MainFrame with negative X offset so it sits flush to the left.
    -- Because MainFrame has ClipsDescendants=false it renders outside the frame.
    -- No absolute position math needed — UDim2 handles it automatically.
    local ConfigOverlay = Util.Create("Frame", {
        Name             = "ConfigOverlay",
        BackgroundColor3 = Theme.Sidebar,
        Size             = UDim2.new(0, CFG_W, 1, -HeaderHeight),
        Position         = UDim2.new(0, -CFG_W, 0, HeaderHeight),
        ClipsDescendants = true,
        BorderSizePixel  = 0,
        Visible          = false,
        ZIndex           = 50,
        Parent           = MainFrame,
    })
    Util.AddCorner(ConfigOverlay, Theme.CornerRadius)
    local _cfgStroke = Util.AddStroke(ConfigOverlay, Theme.BorderLight, 1, 0.12)
    Themed(ConfigOverlay, { BackgroundColor3 = function(t) return t.Sidebar end })
    Themed(_cfgStroke, { Color = function(t) return t.BorderLight end })

    -- Scrollable inner so content never gets clipped vertically
    local CfgScroll = Util.Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, 0, 1, 0),
        BorderSizePixel  = 0,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize       = UDim2.new(0, 0, 0, 0),
        ZIndex           = 31,
        Parent           = ConfigOverlay,
    })
    Util.AddList(CfgScroll, Enum.FillDirection.Vertical, 0)
    Util.AddPadding(CfgScroll, 0, 8, 6, 8)

    -- ── Header strip ─────────────────────────────────────────────────────
    local CfgHeaderStrip = Util.Create("Frame", {
        BackgroundColor3 = Theme.SidebarActive,
        Size             = UDim2.new(1, 0, 0, 42),
        BorderSizePixel  = 0,
        ZIndex           = 32,
        Parent           = CfgScroll,
    })
    Themed(CfgHeaderStrip, { BackgroundColor3 = function(t) return t.SidebarActive end })

    -- top accent gradient line
    do
        local al = Util.Create("Frame", {
            BackgroundColor3 = Color3.new(1,1,1),
            Size = UDim2.new(1,0,0,1),
            BorderSizePixel = 0, ZIndex = 33, Parent = CfgHeaderStrip,
        })
        local _cfgHdrGrad = Util.Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Theme.AccentDark),
                ColorSequenceKeypoint.new(0.5, Theme.Accent),
                ColorSequenceKeypoint.new(1, Theme.AccentDark),
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 0.5),
            }),
            Parent = al,
        })
        Themed(_cfgHdrGrad, { Color = function(t)
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, t.AccentDark),
                ColorSequenceKeypoint.new(0.5, t.Accent),
                ColorSequenceKeypoint.new(1, t.AccentDark),
            })
        end })
    end

    local _cfgTitle = Util.Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 7),
        Size     = UDim2.new(1, -52, 0, 16),
        Text     = "CONFIGS",
        TextColor3 = Theme.Text,
        FontFace = Theme.FontBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex   = 33,
        Parent   = CfgHeaderStrip,
    })
    Themed(_cfgTitle, { TextColor3 = function(t) return t.Text end })

    local CfgStatusLbl = Util.Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 25),
        Size     = UDim2.new(1, -52, 0, 12),
        Text     = "No config selected",
        TextColor3 = Theme.TextMuted,
        FontFace = Theme.Font,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex   = 33,
        Parent   = CfgHeaderStrip,
    })
    Themed(CfgStatusLbl, { TextColor3 = function(t) return t.TextMuted end })

    -- Close × icon button (top-right)
    local CfgCloseBtn = Util.Create("ImageButton", {
        BackgroundColor3 = Theme.SurfaceActive,
        BackgroundTransparency = 0.4,
        Size     = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -32, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Image    = "rbxassetid://10747384394",  -- lucide-x
        ImageColor3 = Theme.TextDim,
        ScaleType = Enum.ScaleType.Fit,
        AutoButtonColor = false,
        ZIndex   = 34,
        Parent   = CfgHeaderStrip,
    })
    Util.AddCorner(CfgCloseBtn, Theme.CornerSmall)
    Themed(CfgCloseBtn, {
        BackgroundColor3 = function(t) return t.SurfaceActive end,
        ImageColor3      = function(t) return t.TextDim end,
    })
    CfgCloseBtn.MouseEnter:Connect(function()
        Util.TweenFast(CfgCloseBtn, {BackgroundTransparency = 0, ImageColor3 = Theme.Error})
    end)
    CfgCloseBtn.MouseLeave:Connect(function()
        Util.TweenFast(CfgCloseBtn, {BackgroundTransparency = 0.4, ImageColor3 = Theme.TextDim})
    end)

    -- ── Name textbox ──────────────────────────────────────────────────────
    local CfgNameWrap = Util.Create("Frame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 0, 42),
        ZIndex   = 32,
        Parent   = CfgScroll,
    })
    local CfgNameBox = Util.Create("TextBox", {
        BackgroundColor3 = Theme.InputBg,
        Size     = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text     = "",
        PlaceholderText = "config name...",
        TextColor3 = Theme.Text,
        PlaceholderColor3 = Theme.TextMuted,
        FontFace = Theme.FontMedium,
        TextSize = 12,
        ClearTextOnFocus = false,
        BorderSizePixel  = 0,
        ZIndex   = 33,
        Parent   = CfgNameWrap,
    })
    Util.AddCorner(CfgNameBox, Theme.CornerSmall)
    local _nameStroke = Util.AddStroke(CfgNameBox, Theme.Border, 1, 0.3)
    Themed(CfgNameBox, {
        BackgroundColor3  = function(t) return t.InputBg end,
        TextColor3        = function(t) return t.Text end,
        PlaceholderColor3 = function(t) return t.TextMuted end,
    })
    Themed(_nameStroke, { Color = function(t) return t.Border end })
    CfgNameBox.Focused:Connect(function()
        Util.TweenFast(CfgNameBox, {BackgroundColor3 = Theme.SurfaceLight})
    end)
    CfgNameBox.FocusLost:Connect(function()
        Util.TweenFast(CfgNameBox, {BackgroundColor3 = Theme.InputBg})
    end)

    -- ── Config list ───────────────────────────────────────────────────────
    local CfgListOuter = Util.Create("Frame", {
        BackgroundColor3 = Theme.Background,
        Size     = UDim2.new(1, 0, 0, 132),
        ZIndex   = 32,
        Parent   = CfgScroll,
    })
    Util.AddPadding(CfgListOuter, 6, 6, 6, 6)
    Util.AddCorner(CfgListOuter, Theme.CornerSmall)
    local _listOuterStroke = Util.AddStroke(CfgListOuter, Theme.Border, 1, 0.3)
    Themed(CfgListOuter, { BackgroundColor3 = function(t) return t.Background end })
    Themed(_listOuterStroke, { Color = function(t) return t.Border end })

    local CfgList = Util.Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.AccentSub,
        ScrollBarImageTransparency = 0.5,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0,0,0,0),
        ZIndex   = 33,
        Parent   = CfgListOuter,
    })
    Util.AddList(CfgList, Enum.FillDirection.Vertical, 3)
    Util.AddPadding(CfgList, 2)
    Themed(CfgList, { ScrollBarImageColor3 = function(t) return t.AccentSub end })

    -- ── Icon action rail ──────────────────────────────────────────────────
    local ICON_IDS = {
        Save    = "rbxassetid://10734941499",  -- lucide-save
        Load    = "rbxassetid://10723344270",  -- lucide-download
        Rename  = "rbxassetid://10734919691",  -- lucide-pencil
        New     = "rbxassetid://10723365877",  -- lucide-file-plus
        Refresh = "rbxassetid://10734933222",  -- lucide-refresh-cw
        Delete  = "rbxassetid://10747362241",  -- lucide-trash-2
    }

    local CfgActionDivider = Util.Create("Frame", {
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.3,
        Size     = UDim2.new(1, 0, 0, 1),
        ZIndex   = 32,
        Parent   = CfgScroll,
    })
    Themed(CfgActionDivider, { BackgroundColor3 = function(t) return t.Border end })

    local CfgRail = Util.Create("Frame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 0, 34),
        ZIndex   = 32,
        Parent   = CfgScroll,
    })
    Util.AddList(CfgRail, Enum.FillDirection.Horizontal, 0,
        Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)

    local function MakeIconBtn(icon, tooltip, danger)
        local wrap = Util.Create("Frame", {
            BackgroundTransparency = 1,
            Size     = UDim2.new(0, 26, 0, 30),
            ZIndex   = 33,
            Parent   = CfgRail,
        })
        local btn = Util.Create("ImageButton", {
            BackgroundColor3 = danger and Color3.fromRGB(55,18,22) or Theme.SurfaceLight,
            BackgroundTransparency = danger and 0 or 0.4,
            Size     = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image    = icon,
            ImageColor3 = danger and Theme.Error or Theme.TextDim,
            ScaleType = Enum.ScaleType.Fit,
            AutoButtonColor = false,
            ZIndex   = 34,
            Parent   = wrap,
        })
        Util.AddCorner(btn, Theme.CornerSmall)
        local _btnStroke = Util.AddStroke(btn, danger and Theme.Error or Theme.Border, 1, danger and 0.5 or 0.4)

        if not danger then
            Themed(btn, {
                BackgroundColor3 = function(t) return t.SurfaceLight end,
                ImageColor3      = function(t) return t.TextDim end,
            })
            Themed(_btnStroke, { Color = function(t) return t.Border end })
        else
            Themed(_btnStroke, { Color = function(t) return t.Error end })
        end

        -- Tooltip fades in above the button on hover
        local tip = Util.Create("TextLabel", {
            BackgroundColor3 = Theme.Background,
            BackgroundTransparency = 1,
            Size     = UDim2.new(0, 0, 0, 14),
            AutomaticSize = Enum.AutomaticSize.X,
            Position = UDim2.new(0.5, 0, 0, -2),
            AnchorPoint = Vector2.new(0.5, 1),
            Text     = tooltip,
            TextColor3 = Theme.TextDim,
            FontFace = Theme.Font,
            TextSize = 10,
            TextTransparency = 1,
            ZIndex   = 42,
            Parent   = wrap,
        })
        Util.AddCorner(tip, Theme.CornerSmall)
        Util.AddPadding(tip, 1, 5, 1, 5)
        Themed(tip, {
            BackgroundColor3 = function(t) return t.Background end,
            TextColor3       = function(t) return t.TextDim end,
        })

        local normalBg = danger and Color3.fromRGB(55,18,22) or Theme.SurfaceLight
        local hoverBg  = danger and Color3.fromRGB(80,25,30)  or Theme.SurfaceHover

        btn.MouseEnter:Connect(function()
            Util.TweenFast(btn, {
                BackgroundColor3 = hoverBg,
                BackgroundTransparency = 0,
                ImageColor3 = danger and Theme.Error or Theme.Accent,
            })
            Util.TweenFast(tip, {TextTransparency = 0, BackgroundTransparency = 0.15})
        end)
        btn.MouseLeave:Connect(function()
            Util.TweenFast(btn, {
                BackgroundColor3 = normalBg,
                BackgroundTransparency = danger and 0 or 0.4,
                ImageColor3 = danger and Theme.Error or Theme.TextDim,
            })
            Util.TweenFast(tip, {TextTransparency = 1, BackgroundTransparency = 1})
        end)
        btn.MouseButton1Click:Connect(function()
            Util.TweenFast(btn, {BackgroundColor3 = danger and Theme.Error or Theme.AccentDark})
            task.delay(0.1, function()
                Util.TweenFast(btn, {BackgroundColor3 = normalBg})
            end)
        end)
        return btn
    end

    local BtnSave    = MakeIconBtn(ICON_IDS.Save,    "Save",    false)
    local BtnLoad    = MakeIconBtn(ICON_IDS.Load,    "Load",    false)
    local BtnRename  = MakeIconBtn(ICON_IDS.Rename,  "Rename",  false)
    local BtnNew     = MakeIconBtn(ICON_IDS.New,     "New",     false)
    local BtnRefresh = MakeIconBtn(ICON_IDS.Refresh, "Refresh", false)
    local BtnDelete  = MakeIconBtn(ICON_IDS.Delete,  "Delete",  true)

    -- ── Delete confirm bar (slides in at bottom) ──────────────────────────
    local DeleteConfirmBar = Util.Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(40, 14, 18),
        Size     = UDim2.new(1, 0, 0, 0),
        ZIndex   = 35,
        ClipsDescendants = true,
        Visible  = false,
        Parent   = CfgScroll,
    })
    Util.AddCorner(DeleteConfirmBar, Theme.CornerSmall)
    Util.AddStroke(DeleteConfirmBar, Theme.Error, 1, 0.5)

    local DeleteConfirmInner = Util.Create("Frame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 0, 64),
        ZIndex   = 36,
        Parent   = DeleteConfirmBar,
    })
    Util.AddList(DeleteConfirmInner, Enum.FillDirection.Vertical, 4)
    Util.AddPadding(DeleteConfirmInner, 8, 10, 8, 10)

    Util.Create("TextLabel", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 0, 14),
        Text     = "Delete this config?",
        TextColor3 = Theme.Error,
        FontFace = Theme.FontSemiBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex   = 37,
        Parent   = DeleteConfirmInner,
    })
    local DeleteConfirmSub = Util.Create("TextLabel", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 0, 11),
        Text     = "",
        TextColor3 = Theme.TextDim,
        FontFace = Theme.Font,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex   = 37,
        Parent   = DeleteConfirmInner,
    })
    local DeleteBtnRow = Util.Create("Frame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 0, 24),
        ZIndex   = 37,
        Parent   = DeleteConfirmInner,
    })
    Util.AddList(DeleteBtnRow, Enum.FillDirection.Horizontal, 6)

    local BtnConfirmDelete = Util.Create("TextButton", {
        BackgroundColor3 = Color3.fromRGB(70, 22, 26),
        Size     = UDim2.new(0.5, -3, 1, 0),
        Text     = "Confirm",
        TextColor3 = Theme.Error,
        FontFace = Theme.FontSemiBold,
        TextSize = 11,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex   = 38,
        Parent   = DeleteBtnRow,
    })
    Util.AddCorner(BtnConfirmDelete, Theme.CornerSmall)
    Util.AddStroke(BtnConfirmDelete, Theme.Error, 1, 0.5)

    local BtnCancelDelete = Util.Create("TextButton", {
        BackgroundColor3 = Theme.SurfaceLight,
        Size     = UDim2.new(0.5, -3, 1, 0),
        Text     = "Cancel",
        TextColor3 = Theme.TextDim,
        FontFace = Theme.FontMedium,
        TextSize = 11,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex   = 38,
        Parent   = DeleteBtnRow,
    })
    Util.AddCorner(BtnCancelDelete, Theme.CornerSmall)
    Util.AddStroke(BtnCancelDelete, Theme.Border, 1, 0.4)

    BtnConfirmDelete.MouseEnter:Connect(function() Util.TweenFast(BtnConfirmDelete, {BackgroundColor3 = Color3.fromRGB(100,28,34)}) end)
    BtnConfirmDelete.MouseLeave:Connect(function() Util.TweenFast(BtnConfirmDelete, {BackgroundColor3 = Color3.fromRGB(70,22,26)}) end)
    BtnCancelDelete.MouseEnter:Connect(function()  Util.TweenFast(BtnCancelDelete,  {BackgroundColor3 = Theme.SurfaceHover}) end)
    BtnCancelDelete.MouseLeave:Connect(function()  Util.TweenFast(BtnCancelDelete,  {BackgroundColor3 = Theme.SurfaceLight}) end)

    -- ── Bottom spacer so scrollable area has breathing room ───────────────
    Util.Create("Frame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 0, 8),
        ZIndex   = 32,
        Parent   = CfgScroll,
    })

    -- ── Padding wrapper for list & divider ────────────────────────────────
    -- (CfgListOuter and CfgActionDivider need horizontal padding since they
    --  are direct children of CfgScroll which uses a UIListLayout)
    -- Apply horizontal offset via Position since UIListLayout doesn't support
    -- per-item padding on the cross-axis.
    CfgListOuter.Position         = UDim2.new(0, 12, 0, 0)
    CfgListOuter.Size             = UDim2.new(1, -24, 0, 150)
    CfgActionDivider.Position     = UDim2.new(0, 12, 0, 0)
    CfgActionDivider.Size         = UDim2.new(1, -24, 0, 1)

    -- ── Helpers ───────────────────────────────────────────────────────────
    local function SetStatus(text, color)
        CfgStatusLbl.Text      = text
        CfgStatusLbl.TextColor3 = color or Theme.TextMuted
    end

    local function ShowDeleteConfirm(name)
        DeleteConfirmSub.Text    = '"' .. name .. '" cannot be recovered.'
        DeleteConfirmBar.Visible = true
        Util.Tween(DeleteConfirmBar, 0.18, {Size = UDim2.new(1, -24, 0, 64 + 8)}, Enum.EasingStyle.Quint)
    end
    local function HideDeleteConfirm()
        Util.Tween(DeleteConfirmBar, 0.14, {Size = UDim2.new(1, -24, 0, 0)}, Enum.EasingStyle.Quint)
        task.delay(0.15, function()
            if DeleteConfirmBar and DeleteConfirmBar.Parent then
                DeleteConfirmBar.Visible = false
            end
        end)
    end

    local function RefreshConfigList()
        for _, ch in ipairs(CfgList:GetChildren()) do
            if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then ch:Destroy() end
        end
        local configs = Config.List()
        table.sort(configs)
        if #configs == 0 then
            Util.Create("TextLabel", {
                BackgroundTransparency = 1,
                Size     = UDim2.new(1, 0, 0, 22),
                Text     = "No configs saved yet",
                TextColor3 = Theme.TextMuted,
                FontFace = Theme.Font,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex   = 34,
                Parent   = CfgList,
            })
            return
        end
        for _, cfgName in ipairs(configs) do
            local isSel = (cfgName == selectedCfgName)
            local Row = Util.Create("TextButton", {
                Name             = "Row_" .. cfgName,
                BackgroundColor3 = isSel and Theme.SidebarActive or Theme.SurfaceLight,
                BackgroundTransparency = isSel and 0 or 0.5,
                Size             = UDim2.new(1, 0, 0, 26),
                Text             = "",
                AutoButtonColor  = false,
                BorderSizePixel  = 0,
                ZIndex           = 34,
                Parent           = CfgList,
            })
            Util.AddCorner(Row, Theme.CornerSmall)
            if isSel then
                Util.AddStroke(Row, Theme.Accent, 1, 0.45)
            end
            -- Accent pip
            local Pip = Util.Create("Frame", {
                BackgroundColor3 = Theme.Accent,
                Size     = UDim2.new(0, 2, 0.55, 0),
                Position = UDim2.new(0, 0, 0.225, 0),
                BorderSizePixel = 0,
                Visible  = isSel,
                ZIndex   = 35,
                Parent   = Row,
            })
            Util.AddCorner(Pip, UDim.new(1, 0))
            Util.Create("TextLabel", {
                BackgroundTransparency = 1,
                Size     = UDim2.new(1, -14, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                Text     = cfgName,
                TextColor3 = isSel and Theme.Text or Theme.TextDim,
                FontFace = isSel and Theme.FontMedium or Theme.Font,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex   = 35,
                Parent   = Row,
            })
            Row.MouseEnter:Connect(function()
                if cfgName ~= selectedCfgName then
                    Util.TweenFast(Row, {BackgroundTransparency = 0.2, BackgroundColor3 = Theme.SurfaceHover})
                end
            end)
            Row.MouseLeave:Connect(function()
                if cfgName ~= selectedCfgName then
                    Util.TweenFast(Row, {BackgroundTransparency = 0.5, BackgroundColor3 = Theme.SurfaceLight})
                end
            end)
            Row.MouseButton1Click:Connect(function()
                selectedCfgName = cfgName
                CfgNameBox.Text = cfgName
                SetStatus("Selected: " .. cfgName, Theme.TextDim)
                RefreshConfigList()
            end)
        end
    end

    -- ── Open / close ──────────────────────────────────────────────────────
    local OPEN_POS   = UDim2.new(0, 0, 0, HeaderHeight)
    local CLOSED_POS = UDim2.new(0, -CFG_W - 14, 0, HeaderHeight)

    local CfgSlideClip = Util.Create("Frame", {
        BackgroundTransparency = 1,
        Size     = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, -20, 0, 0),
        ClipsDescendants = false,
        ZIndex   = 51,
        Parent   = ConfigOverlay,
    })
    CfgScroll.Parent = CfgSlideClip

    local function OpenConfigPanel()
        if cfgPanelOpen then return end
        cfgPanelOpen = true
        _G._HyperionCfgOpen = true
        HideDeleteConfirm()
        RefreshConfigList()

        ConfigOverlay.Position = CLOSED_POS
        ConfigOverlay.BackgroundTransparency = 1
        ConfigOverlay.Visible = true
        CfgSlideClip.Position = UDim2.new(0, -20, 0, 0)

        Util.Tween(ConfigOverlay, 0.30, {
            Position = OPEN_POS,
            BackgroundTransparency = 0,
        }, Enum.EasingStyle.Quint)
        Util.Tween(CfgSlideClip, 0.30, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quint)

        Util.TweenFast(FolderOpenBtn, {
            BackgroundColor3       = Theme.SurfaceActive,
            BackgroundTransparency = 0,
            ImageColor3            = Theme.Accent,
        })
    end

    local function CloseConfigPanel()
        if not cfgPanelOpen then return end
        cfgPanelOpen = false
        _G._HyperionCfgOpen = false
        HideDeleteConfirm()

        Util.Tween(ConfigOverlay, 0.22, {
            Position = CLOSED_POS,
            BackgroundTransparency = 1,
        }, Enum.EasingStyle.Quint)
        Util.Tween(CfgSlideClip, 0.22, {Position = UDim2.new(0, -20, 0, 0)}, Enum.EasingStyle.Quint)

        Util.TweenFast(FolderOpenBtn, {
            BackgroundColor3       = Theme.SurfaceLight,
            BackgroundTransparency = 0.35,
            ImageColor3            = Theme.TextDim,
        })
        task.delay(0.25, function()
            if not cfgPanelOpen and ConfigOverlay and ConfigOverlay.Parent then
                ConfigOverlay.Visible = false
            end
        end)
    end

    FolderOpenBtn.MouseButton1Click:Connect(function()
        if cfgPanelOpen then CloseConfigPanel() else OpenConfigPanel() end
    end)
    CfgCloseBtn.MouseButton1Click:Connect(CloseConfigPanel)

    -- Click anywhere outside config panel to close it
    Util.Connect(UserInputService.InputBegan, function(input, processed)
        if not cfgPanelOpen then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local pos = input.Position
        -- Check if click is inside config overlay
        local cfgPos = ConfigOverlay.AbsolutePosition
        local cfgSize = ConfigOverlay.AbsoluteSize
        local insideCfg = pos.X >= cfgPos.X and pos.X <= cfgPos.X + cfgSize.X
            and pos.Y >= cfgPos.Y and pos.Y <= cfgPos.Y + cfgSize.Y
        -- Check if click is on the folder button
        local btnPos = FolderOpenBtn.AbsolutePosition
        local btnSize = FolderOpenBtn.AbsoluteSize
        local insideBtn = pos.X >= btnPos.X and pos.X <= btnPos.X + btnSize.X
            and pos.Y >= btnPos.Y and pos.Y <= btnPos.Y + btnSize.Y
        if not insideCfg and not insideBtn then
            CloseConfigPanel()
        end
    end)

    -- Click anywhere outside info panel to close it
    Util.Connect(UserInputService.InputBegan, function(input, processed)
        if not infoOpen then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local pos = input.Position
        local infoPos = InfoOverlay.AbsolutePosition
        local infoSize = InfoOverlay.AbsoluteSize
        local insideInfo = pos.X >= infoPos.X and pos.X <= infoPos.X + infoSize.X
            and pos.Y >= infoPos.Y and pos.Y <= infoPos.Y + infoSize.Y
        local btnPos = InfoBtn.AbsolutePosition
        local btnSize = InfoBtn.AbsoluteSize
        local insideBtn = pos.X >= btnPos.X and pos.X <= btnPos.X + btnSize.X
            and pos.Y >= btnPos.Y and pos.Y <= btnPos.Y + btnSize.Y
        if not insideInfo and not insideBtn then
            infoOpen = false
            Util.TweenSmooth(InfoOverlay, {Size = UDim2.new(0, SidebarWidth - 16, 0, 0)})
            Util.TweenFast(InfoBtn, {ImageColor3 = Theme.TextDim, BackgroundTransparency = 0.35})
            task.delay(0.28, function()
                if not infoOpen then InfoOverlay.Visible = false end
            end)
        end
    end)

    -- ── Button logic ──────────────────────────────────────────────────────
    BtnSave.MouseButton1Click:Connect(function()
        local name = (CfgNameBox.Text ~= "" and CfgNameBox.Text) or "default"
        local overwrite = isfile("Hyperion/Configs/" .. name .. ".json")
        local ok = Config.Save(name, Hyperion.Flags)
        if ok then
            selectedCfgName = name
            RefreshConfigList()
            SetStatus((overwrite and "Overwritten: " or "Saved: ") .. name, Theme.Success)
            Hyperion:Notify({Title = "Config", Content = (overwrite and "Overwritten: " or "Saved: ") .. name, Type = "Success", Duration = 3})
        else
            SetStatus("Save failed", Theme.Error)
        end
    end)

    BtnLoad.MouseButton1Click:Connect(function()
        local name = selectedCfgName or (CfgNameBox.Text ~= "" and CfgNameBox.Text) or nil
        if not name then SetStatus("Select a config first", Theme.Warning); return end
        local ok = Config.Load(name, Hyperion.Flags, Hyperion.FlagCallbacks)
        if ok then
            SetStatus("Loaded: " .. name, Theme.Success)
            Hyperion:Notify({Title = "Config", Content = "Loaded: " .. name, Type = "Success", Duration = 3})
        else
            SetStatus("Not found: " .. name, Theme.Error)
            Hyperion:Notify({Title = "Config", Content = "Not found: " .. name, Type = "Warning", Duration = 3})
        end
    end)

    BtnRename.MouseButton1Click:Connect(function()
        local oldName = selectedCfgName
        local newName = CfgNameBox.Text
        if not oldName or newName == "" or oldName == newName then
            SetStatus(not oldName and "Select a config first" or "Enter a new name", Theme.Warning)
            return
        end
        local path = "Hyperion/Configs/" .. oldName .. ".json"
        if not isfile(path) then SetStatus("Config not found", Theme.Error); return end
        local ok, raw = pcall(readfile, path)
        if ok then
            pcall(writefile, "Hyperion/Configs/" .. newName .. ".json", raw)
            Config.Delete(oldName)
            selectedCfgName = newName
            RefreshConfigList()
            SetStatus("Renamed to: " .. newName, Theme.Success)
            Hyperion:Notify({Title = "Config", Content = "Renamed to: " .. newName, Type = "Success", Duration = 3})
        else
            SetStatus("Rename failed", Theme.Error)
        end
    end)

    BtnNew.MouseButton1Click:Connect(function()
        local base, name, i = "new_config", "new_config", 1
        while isfile("Hyperion/Configs/" .. name .. ".json") do
            name = base .. "_" .. i; i = i + 1
        end
        CfgNameBox.Text = name
        SetStatus("Name ready: " .. name, Theme.TextDim)
    end)

    BtnRefresh.MouseButton1Click:Connect(function()
        RefreshConfigList()
        SetStatus("Refreshed", Theme.TextDim)
    end)

    BtnDelete.MouseButton1Click:Connect(function()
        local name = selectedCfgName or (CfgNameBox.Text ~= "" and CfgNameBox.Text) or nil
        if not name then SetStatus("Select a config first", Theme.Warning); return end
        ShowDeleteConfirm(name)
    end)

    BtnConfirmDelete.MouseButton1Click:Connect(function()
        local name = selectedCfgName or (CfgNameBox.Text ~= "" and CfgNameBox.Text) or nil
        if not name then HideDeleteConfirm(); return end
        local ok = Config.Delete(name)
        HideDeleteConfirm()
        if ok then
            if selectedCfgName == name then selectedCfgName = nil; CfgNameBox.Text = "" end
            RefreshConfigList()
            SetStatus("Deleted: " .. name, Theme.TextDim)
            Hyperion:Notify({Title = "Config", Content = "Deleted: " .. name, Type = "Info", Duration = 3})
        else
            SetStatus("Not found: " .. name, Theme.Error)
        end
    end)

    BtnCancelDelete.MouseButton1Click:Connect(HideDeleteConfirm)

    RefreshConfigList()

    -- ============================================================
    -- CONTENT AREA
    -- ============================================================
    local ContentArea = Util.Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -SidebarWidth, 1, -HeaderHeight),
        Position = UDim2.new(0, SidebarWidth, 0, HeaderHeight),
        ClipsDescendants = false,
        ZIndex = 2,
        Parent = MainFrame
    })

    -- ============================================================
    -- RESIZE HELPERS
    -- ============================================================
    local function ClampWindowSize(size)
        local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)

        local minW = WindowObj.MinSize.X.Offset
        local minH = WindowObj.MinSize.Y.Offset

        local maxW = math.max(minW, viewportSize.X - 80)
        local maxH = math.max(minH, viewportSize.Y - 80)

        local width = math.clamp(size.X.Offset, minW, maxW)
        local height = math.clamp(size.Y.Offset, minH, maxH)

        return UDim2.new(0, width, 0, height)
    end

    WindowObj.CurrentSize = ClampWindowSize(WindowObj.CurrentSize)
    MainFrame.Size = WindowObj.CurrentSize

    local function ApplyWindowSize(size)
        local clamped = ClampWindowSize(size)
        WindowObj.CurrentSize = clamped
        MainFrame.Size = clamped
    end

    local ResizeHandle = Util.Create("TextButton", {
        Name = "ResizeHandle",
        BackgroundTransparency = 1,
        Text = "",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -18, 1, -18),
        ZIndex = 25,
        Parent = MainFrame
    })

    local ResizeGrip1 = Util.Create("Frame", {
        Name = "Grip1",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -3, 1, -3),
        Size = UDim2.new(0, 8, 0, 2),
        BackgroundColor3 = Theme.TextMuted,
        BorderSizePixel = 0,
        Rotation = -45,
        ZIndex = 26,
        Parent = ResizeHandle
    })
    local ResizeGrip2 = Util.Create("Frame", {
        Name = "Grip2",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -6, 1, -6),
        Size = UDim2.new(0, 8, 0, 2),
        BackgroundColor3 = Theme.TextMuted,
        BorderSizePixel = 0,
        Rotation = -45,
        ZIndex = 26,
        Parent = ResizeHandle
    })
    Util.AddCorner(ResizeGrip1, UDim.new(0, 1))
    Util.AddCorner(ResizeGrip2, UDim.new(0, 1))

    local Resizing = false
    local ResizeStart = Vector3.new()
    local StartSize = WindowObj.CurrentSize

    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = true
            ResizeStart = input.Position
            StartSize = WindowObj.CurrentSize
        end
    end)
    ResizeHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = false
        end
    end)

    Util.Connect(UserInputService.InputChanged, function(input)
        if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - ResizeStart
            ApplyWindowSize(UDim2.new(
                0, StartSize.X.Offset + delta.X,
                0, StartSize.Y.Offset + delta.Y
            ))
        end
    end)

    function WindowObj:SetSize(size)
        ApplyWindowSize(size)
    end

    -- Set a custom background image. Pass nil or "" to clear.
    -- tintAlpha: 0=no tint, 1=fully opaque tint (default 0.45)
    function WindowObj:SetBackground(imageId, tintAlpha)
        if not imageId or imageId == "" then
            BgImage.Visible = false
            BgTint.Visible  = false
            return
        end
        if type(imageId) == "number" then
            imageId = "rbxassetid://" .. imageId
        end
        BgImage.Image   = imageId
        BgImage.Visible = true
        BgTint.BackgroundTransparency = 1 - (tintAlpha or 0.45)
        BgTint.Visible  = (tintAlpha or 0.45) > 0
    end

    -- Set overall UI transparency (0 = fully opaque, 1 = invisible).
    -- Values around 0.08-0.15 give a nice frosted glass effect.
    function WindowObj:SetTransparency(alpha)
        alpha = math.clamp(alpha or 0, 0, 0.95)
        Util.Tween(MainFrame, 0.22, {BackgroundTransparency = alpha}, Enum.EasingStyle.Quint)
        Util.Tween(Header,    0.22, {BackgroundTransparency = alpha}, Enum.EasingStyle.Quint)
        Util.Tween(Sidebar,   0.22, {BackgroundTransparency = alpha}, Enum.EasingStyle.Quint)
        -- Register new base transparency in Theme so listeners know
        Hyperion.Theme._uiAlpha = alpha
    end

    -- ============================================================
    -- DRAGGING (with viewport bounds clamping)
    -- ============================================================
    local Dragging, DragStart, StartPos = false, Vector3.new(), UDim2.new()

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
        end
    end)
    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    Util.Connect(UserInputService.InputChanged, function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - DragStart
            local viewportSize = workspace.CurrentCamera.ViewportSize
            local winSize = MainFrame.AbsoluteSize

            local newX = StartPos.X.Offset + delta.X
            local newY = StartPos.Y.Offset + delta.Y

            -- Clamp so window stays at least partially on screen
            local halfW = winSize.X * 0.5
            local halfH = winSize.Y * 0.5
            newX = math.clamp(newX, -halfW + 60, viewportSize.X - halfW - 60)
            newY = math.clamp(newY, -halfH + 30, viewportSize.Y - halfH - 30)

            MainFrame.Position = UDim2.new(StartPos.X.Scale, newX, StartPos.Y.Scale, newY)
        end
    end)

    -- ============================================================
    -- KEYBIND TOGGLE
    -- ============================================================
    Util.Connect(UserInputService.InputBegan, function(input, processed)
        if processed then return end
        if input.KeyCode == windowConfig.Keybind then
            WindowObj:Toggle()
        end
    end)

    -- ============================================================
    -- OPEN ANIMATION
    -- ============================================================
    MainFrame.BackgroundTransparency = 1
    MainFrame.Size = UDim2.new(
        0, WindowObj.CurrentSize.X.Offset * 0.92,
        0, WindowObj.CurrentSize.Y.Offset * 0.92
    )
    task.defer(function()
        Util.Tween(MainFrame, 0.5, {
            BackgroundTransparency = 0,
            Size = WindowObj.CurrentSize
        }, Enum.EasingStyle.Quint)
    end)

    -- ============================================================
    -- WINDOW API
    -- ============================================================
    function WindowObj:SetLogo(assetId)
        if assetId == nil or assetId == "" then
            LogoImage.Image = ""
            LogoImage.Visible = false
            TitleLabel.Position = UDim2.new(0, 0, 0, 0)
            TitleLabel.Size = UDim2.new(1, 0, 1, 0)
            SubtitleLabel.Position = UDim2.new(0, 0, 0, 0)
            SubtitleLabel.Size = UDim2.new(0, 1, 0, 1)
            return
        end

        if typeof(assetId) == "number" then
            assetId = "rbxassetid://" .. tostring(assetId)
        elseif type(assetId) == "string" and not string.find(assetId, "rbxassetid://", 1, true) then
            if string.match(assetId, "^%d+$") then
                assetId = "rbxassetid://" .. assetId
            end
        end

        LogoImage.Image = assetId
        LogoImage.Visible = true
        TitleLabel.Position = UDim2.new(0, 72, 0, 0)
        TitleLabel.Size = UDim2.new(1, -72, 1, 0)
        SubtitleLabel.Position = UDim2.new(0, 46, 0, 0)
        SubtitleLabel.Size = UDim2.new(0, 1, 0, 1)
    end

    function WindowObj:SetTitle(text)
        TitleLabel.Text = text
    end

    function WindowObj:SetSubtitle(text)
        SubtitleLabel.Text = text
    end

    function WindowObj:Toggle()
        WindowObj.Visible = not WindowObj.Visible
        if WindowObj.Visible then
            ScreenGui.Enabled = true
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(
                0, math.floor(WindowObj.CurrentSize.X.Offset * 0.97),
                0, math.floor(WindowObj.CurrentSize.Y.Offset * 0.97)
            )
            MainFrame.BackgroundTransparency = 0.25
            MainFrame.Position = UDim2.new(0.5, 0, 0.5, 8)
            Util.Tween(MainFrame, 0.28, {
                BackgroundTransparency = 0,
                Size = WindowObj.CurrentSize,
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }, Enum.EasingStyle.Quint)
            if MobileToggleButton then
                Util.TweenFast(MobileToggleButton, {BackgroundColor3 = Theme.Surface})
            end
        else
            Util.Tween(MainFrame, 0.22, {
                BackgroundTransparency = 0.4,
                Size = UDim2.new(
                    0, math.floor(WindowObj.CurrentSize.X.Offset * 0.985),
                    0, math.floor(WindowObj.CurrentSize.Y.Offset * 0.985)
                ),
                Position = UDim2.new(0.5, 0, 0.5, 6)
            }, Enum.EasingStyle.Quint)
            if MobileToggleButton then
                Util.TweenFast(MobileToggleButton, {BackgroundColor3 = Theme.SidebarActive})
            end
            task.delay(0.22, function()
                if not WindowObj.Visible then
                    MainFrame.Visible = false
                end
            end)
        end
    end

    if MobileToggleButton then
        MobileToggleButton.MouseButton1Click:Connect(function()
            WindowObj:Toggle()
        end)
    end

    function WindowObj:Destroy()
        Hyperion.Unloaded = true
        for _, conn in pairs(Hyperion.Connections) do
            pcall(function() conn:Disconnect() end)
        end
        Hyperion.Connections = {}
        InputPool.SliderCallbacks = {}
        InputPool.ColorCallbacks = {}
        ScreenGui:Destroy()
    end

    function WindowObj:SaveConfig(name)
        local ok = Config.Save(name or "default", Hyperion.Flags)
        RefreshConfigList()
        return ok
    end

    function WindowObj:LoadConfig(name)
        return Config.Load(name or "default", Hyperion.Flags, Hyperion.FlagCallbacks)
    end

    function WindowObj:ListConfigs()
        return Config.List()
    end

    function WindowObj:DeleteConfig(name)
        local ok = Config.Delete(name or "default")
        RefreshConfigList()
        return ok
    end

    function WindowObj:OpenConfigPanel()
        OpenConfigPanel()
    end

    function WindowObj:CloseConfigPanel()
        CloseConfigPanel()
    end

    function WindowObj:RefreshConfigList()
        RefreshConfigList()
    end

    -- ============================================================
    -- THEME PICKER  (call from any section: Section:AddThemePicker())
    -- Adds a grid of theme swatches. Clicking one applies the theme live.
    -- Because Theme is a shared reference, UI elements already using
    -- Theme.X will not auto-update — but newly opened dropdowns/sections
    -- will. For a full live-reload call Window:Destroy() and rebuild.
    -- ============================================================
    function WindowObj:AddThemePicker(section, callback)
        -- section must be a SectionObj returned by Tab:AddSection()
        local cb = callback or function() end
        local themeOrder = {"Purple", "Midnight", "Rose"}
        local themeColors = {
            Purple   = Color3.fromRGB(140, 80, 220),
            Midnight = Color3.fromRGB(80, 120, 255),
                        Rose     = Color3.fromRGB(220, 80, 120),
        }

        -- Find the Elements frame inside the section's frame
        local sectionFrame = nil
        for _, child in ipairs(MainFrame:GetDescendants()) do
            if child:IsA("Frame") and child.Name:find("^Sec_") then
                local elemFrame = child:FindFirstChild("Elements")
                if elemFrame then
                    sectionFrame = elemFrame
                end
            end
        end

        -- Better: expose Elements via section object if possible,
        -- otherwise build directly as a standalone widget returned to caller
        local container = Util.Create("Frame", {
            Name = "ThemePicker",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 2,
        })
        Util.AddList(container, Enum.FillDirection.Vertical, 6)
        Util.AddPadding(container, 4, 0, 4, 0)

        local currentTheme = "Purple"
        local swatches = {}

        for _, name in ipairs(themeOrder) do
            local accent = themeColors[name]
            local row = Util.Create("TextButton", {
                BackgroundColor3 = Theme.SurfaceLight,
                BackgroundTransparency = 0.4,
                Size = UDim2.new(1, 0, 0, 38),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = container,
            })
            Util.AddCorner(row, Theme.CornerSmall)
            local stroke = Util.AddStroke(row, Theme.Border, 1, 0.5)

            -- Color swatch circle
            local swatch = Util.Create("Frame", {
                BackgroundColor3 = accent,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 8, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = row,
            })
            Util.AddCorner(swatch, UDim.new(1, 0))

            -- Inner glow ring
            Util.AddStroke(swatch, accent, 1, 0.5)

            -- Theme name label
            local lbl = Util.Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 34, 0, 0),
                Text = name,
                TextColor3 = Theme.Text,
                FontFace = Theme.FontMedium,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = row,
            })

            -- Active checkmark
            local check = Util.Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -26, 0, 0),
                Text = "✓",
                TextColor3 = accent,
                FontFace = Theme.FontBold,
                TextSize = 14,
                TextTransparency = name == currentTheme and 0 or 1,
                ZIndex = 3,
                Parent = row,
            })

            Themed(row, {
                BackgroundColor3 = function(t)
                    return (currentTheme == name) and t.SurfaceActive or t.SurfaceLight
                end
            })
            Themed(stroke, {
                Color = function(t)
                    return (currentTheme == name) and accent or t.Border
                end
            })
            for _, child in ipairs(row:GetChildren()) do
                if child:IsA("TextLabel") and child ~= check then
                    Themed(child, { TextColor3 = function(t) return t.Text end })
                end
            end
            Themed(check, { TextColor3 = function(_) return accent end })

            
            swatches[name] = {row = row, check = check, stroke = stroke, accent = accent}

            row.MouseEnter:Connect(function()
                if currentTheme ~= name then
                    Util.TweenFast(row, {BackgroundTransparency = 0.2, BackgroundColor3 = Theme.SurfaceHover})
                end
            end)
            row.MouseLeave:Connect(function()
                if currentTheme ~= name then
                    Util.TweenFast(row, {BackgroundTransparency = 0.4, BackgroundColor3 = Theme.SurfaceLight})
                end
            end)

            row.MouseButton1Click:Connect(function()
                if currentTheme == name then return end
                -- Deselect old
                local old = swatches[currentTheme]
                if old then
                    Util.TweenFast(old.row, {BackgroundTransparency = 0.4, BackgroundColor3 = Theme.SurfaceLight})
                    Util.TweenFast(old.stroke, {Color = Theme.Border, Transparency = 0.5})
                    Util.TweenFast(old.check, {TextTransparency = 1})
                end
                -- Select new
                currentTheme = name
                Hyperion:SetTheme(name)
                Util.TweenFast(row, {BackgroundTransparency = 0.1, BackgroundColor3 = Theme.SurfaceActive})
                Util.TweenFast(stroke, {Color = accent, Transparency = 0.3})
                Util.TweenFast(check, {TextTransparency = 0})
                -- Refresh config list rows so they pick up new theme colors
                RefreshConfigList()
                Hyperion:Notify({
                    Title   = "Theme",
                    Content = name .. " theme applied.",
                    Type    = "Info",
                    Duration = 2,
                })
                cb(name)
            end)
        end

        -- Mark initial selection
        local initSwatch = swatches["Purple"]
        if initSwatch then
            Util.TweenFast(initSwatch.row, {BackgroundTransparency = 0.1, BackgroundColor3 = Theme.SurfaceActive})
            Util.TweenFast(initSwatch.stroke, {Color = themeColors["Purple"], Transparency = 0.3})
        end

        -- Return the container so the caller can parent it wherever needed
        return container
    end
    -- ============================================================
    -- ADD CATEGORY (sidebar section label like "MAIN", "COMBAT")
    -- ============================================================
    function WindowObj:AddCategory(name)
        local catOrder = #WindowObj.Tabs + 1

        local CatLabel = Util.Create("Frame", {
            Name = "Cat_" .. name,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 22),
            LayoutOrder = catOrder * 100 - 1,
            ZIndex = 3,
            Parent = TabContainer
        })

        Util.Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -8, 1, 0),
            Position = UDim2.new(0, 4, 0, 0),
            Text = string.upper(name),
            TextColor3 = Theme.TextMuted,
            FontFace = Theme.FontSemiBold,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Bottom,
            ZIndex = 4,
            Parent = CatLabel
        })

        -- Thin separator line at top (skip for first category)
        if #TabContainer:GetChildren() > 3 then -- list + padding + this
            local sep = Util.Create("Frame", {
                Name = "Sep",
                BackgroundColor3 = Theme.Border,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, -16, 0, 1),
                Position = UDim2.new(0, 8, 0, 0),
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = CatLabel
            })
            Themed(sep, { BackgroundColor3 = function(t) return t.Border end })
        end

        return CatLabel
    end

    -- ============================================================
    function WindowObj:AddTab(tabCfg)
        tabCfg = tabCfg or {}
        local tabName  = tabCfg.Name or "Tab"
        local tabIcon  = tabCfg.Icon or nil
        local tabOrder = #WindowObj.Tabs + 1

        local TabObj = {}
        TabObj.Sections = {}
        TabObj.Name = tabName

        -- Tab button in sidebar
        local TabButton = Util.Create("TextButton", {
            Name = "Tab_" .. tabName,
            BackgroundColor3 = Theme.Sidebar,
            BackgroundTransparency = 0,
            Size = UDim2.new(1, 0, 0, 36),
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = tabOrder,
            ZIndex = 3,
            Parent = TabContainer
        })
        Util.AddCorner(TabButton, Theme.CornerSmall)
        local _tabStroke = Util.AddStroke(TabButton, Theme.Border, 1, 0.35)
        Themed(TabButton, { BackgroundColor3 = function(t) return t.Sidebar end })
        Themed(_tabStroke, { Color = function(t) return t.Border end })

        -- Active indicator bar (left edge)
        local ActiveBar = Util.Create("Frame", {
            Name = "Bar",
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(0, 3, 0, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BorderSizePixel = 0,
            ZIndex = 4,
            Parent = TabButton
        })
        Util.AddCorner(ActiveBar, UDim.new(0, 2))
        Themed(ActiveBar, { BackgroundColor3 = function(t) return t.Accent end })

        local iconOffset = 0
        local IconLabel = nil
        if tabIcon then
            IconLabel = Util.Create("ImageLabel", {
                Name = "Icon",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 12, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = tabIcon,
                ImageColor3 = Theme.TextDim,
                ZIndex = 4,
                Parent = TabButton
            })
            Themed(IconLabel, { ImageColor3 = function(t) return t.TextDim end })
            iconOffset = 22
        end

        local TabLabel = Util.Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -(18 + iconOffset), 1, 0),
            Position = UDim2.new(0, 12 + iconOffset, 0, 0),
            Text = tabName,
            TextColor3 = Theme.TextDim,
            FontFace = Theme.FontMedium,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 4,
            Parent = TabButton
        })
        Themed(TabLabel, { TextColor3 = function(t) return t.TextDim end })

        -- Content page
        local TabPage = Util.Create("ScrollingFrame", {
            Name = "Page_" .. tabName,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.AccentSub,
            ScrollBarImageTransparency = 0.4,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            ClipsDescendants = true,
            ZIndex = 2,
            Parent = ContentArea
        })
        Util.AddPadding(TabPage, 0, 0, 12, 0)

        local GroupBar = Util.Create("Frame", {
            Name = "GroupBar",
            BackgroundColor3 = Theme.Surface,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 0, 40),
            Visible = false,
            ZIndex = 3,
            Parent = TabPage
        })
        Util.AddCorner(GroupBar, Theme.CornerSmall)
        local GroupBarStroke = Util.AddStroke(GroupBar, Theme.BorderLight, 1.2, 0.08)
        Themed(GroupBar, { BackgroundColor3 = function(t) return t.Surface end })
        Themed(GroupBarStroke, { Color = function(t) return t.BorderLight end })

        local GroupList = Util.AddList(GroupBar, Enum.FillDirection.Horizontal, 8)
        GroupList.VerticalAlignment = Enum.VerticalAlignment.Center
        Util.AddPadding(GroupBar, 6, 10, 6, 10)

        local GroupPages = Util.Create("Frame", {
            Name = "GroupPages",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 2,
            Parent = TabPage
        })

        TabObj.Groups = {}
        TabObj.GroupOrder = {}
        TabObj.ActiveGroup = nil

        local function UpdateGroupPagesPosition()
            if GroupBar.Visible then
                GroupPages.Position = UDim2.new(0, 0, 0, 44)
            else
                GroupPages.Position = UDim2.new(0, 0, 0, 0)
            end
        end

        local function CreateGroup(groupName)
            local GroupPage = Util.Create("Frame", {
                Name = "Group_" .. tostring(groupName),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Visible = false,
                ZIndex = 2,
                Parent = GroupPages
            })

            local Columns = Util.Create("Frame", {
                Name = "Columns",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2,
                Parent = GroupPage
            })

            local LeftColumn = Util.Create("Frame", {
                Name = "Left",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 100, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Position = UDim2.new(0, 0, 0, 0),
                ZIndex = 2,
                Parent = Columns
            })
            Util.AddList(LeftColumn, Enum.FillDirection.Vertical, 8)

            local RightColumn = Util.Create("Frame", {
                Name = "Right",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 100, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Position = UDim2.new(0, 112, 0, 0),
                ZIndex = 2,
                Parent = Columns
            })
            Util.AddList(RightColumn, Enum.FillDirection.Vertical, 8)

            local GroupButton = nil
            if groupName ~= "__default" then
                GroupBar.Visible = true
                UpdateGroupPagesPosition()

                GroupButton = Util.Create("TextButton", {
                    Name = "GroupBtn_" .. tostring(groupName),
                    BackgroundColor3 = Theme.SurfaceLight,
                    BackgroundTransparency = 0.12,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2.new(0, 0, 0, 28),
                    Text = tostring(groupName),
                    TextColor3 = Theme.Text,
                    FontFace = Theme.FontBold,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false,
                    ZIndex = 4,
                    Parent = GroupBar
                })
                Util.AddCorner(GroupButton, Theme.CornerSmall)
                Util.AddPadding(GroupButton, 0, 14, 0, 14)
                local GroupButtonStroke = Util.AddStroke(GroupButton, Theme.BorderLight, 1, 0.28)
                Themed(GroupButton, {
                    BackgroundColor3 = function(t)
                        if TabObj.ActiveGroup and TabObj.ActiveGroup.Button == GroupButton then
                            return t.SurfaceHover
                        end
                        return t.SurfaceLight
                    end,
                    TextColor3 = function(t)
                        if TabObj.ActiveGroup and TabObj.ActiveGroup.Button == GroupButton then
                            return t.Text
                        end
                        return t.TextDim
                    end,
                })
                Themed(GroupButtonStroke, {
                    Color = function(t)
                        if TabObj.ActiveGroup and TabObj.ActiveGroup.Button == GroupButton then
                            return t.Accent
                        end
                        return t.BorderLight
                    end
                })

            end

            local function UpdateColumns()
                local width = GroupPages.AbsoluteSize.X
                if width <= 0 then
                    return
                end

                local function CountSections(column)
                    local total = 0
                    for _, child in ipairs(column:GetChildren()) do
                        if child:IsA("Frame") and child.Name:find("^Sec_") then
                            total = total + 1
                        end
                    end
                    return total
                end

                local gap = 12
                local usable = math.max(220, width - 28)
                local leftCount = CountSections(LeftColumn)
                local rightCount = CountSections(RightColumn)

                if leftCount > 0 and rightCount == 0 then
                    LeftColumn.Size = UDim2.new(1, 0, 0, 0)
                    RightColumn.Visible = false
                    RightColumn.Size = UDim2.new(0, 0, 0, 0)
                    return
                elseif rightCount > 0 and leftCount == 0 then
                    LeftColumn.Size = UDim2.new(0, 0, 0, 0)
                    RightColumn.Visible = true
                    RightColumn.Position = UDim2.new(0, 0, 0, 0)
                    RightColumn.Size = UDim2.new(1, 0, 0, 0)
                    return
                end

                RightColumn.Visible = true
                local colWidth = math.floor((usable - gap) / 2)
                LeftColumn.Size = UDim2.new(0, colWidth, 0, 0)
                RightColumn.Position = UDim2.new(0, colWidth + gap, 0, 0)
                RightColumn.Size = UDim2.new(0, colWidth, 0, 0)
            end

            UpdateColumns()
            Util.Connect(GroupPages:GetPropertyChangedSignal("AbsoluteSize"), UpdateColumns)

            local groupData = {
                Name = groupName,
                Page = GroupPage,
                Columns = Columns,
                Left = LeftColumn,
                Right = RightColumn,
                Button = GroupButton,
                UpdateColumns = UpdateColumns,
            }

            table.insert(TabObj.GroupOrder, groupData)
            TabObj.Groups[groupName] = groupData

            if GroupButton then
                GroupButton.MouseEnter:Connect(function()
                    if TabObj.ActiveGroup ~= groupData then
                        Util.TweenFast(GroupButton, {TextColor3 = Theme.Text, BackgroundTransparency = 0, BackgroundColor3 = Theme.SurfaceHover})
                    end
                end)
                GroupButton.MouseLeave:Connect(function()
                    if TabObj.ActiveGroup ~= groupData then
                        Util.TweenFast(GroupButton, {TextColor3 = Theme.TextDim, BackgroundTransparency = 0.08, BackgroundColor3 = Theme.SurfaceLight})
                    end
                end)
            end

            return groupData
        end

        local function EnsureGroup(groupName)
            return TabObj.Groups[groupName] or CreateGroup(groupName)
        end

        local function ActivateGroup(groupData)
            TabObj.ActiveGroup = groupData

            for _, grp in ipairs(TabObj.GroupOrder) do
                grp.Page.Visible = false
                if grp.Button then
                    local isActive = (grp == groupData)
                    Util.TweenFast(grp.Button, {
                        BackgroundColor3 = isActive and Theme.SurfaceHover or Theme.SurfaceLight,
                        TextColor3 = isActive and Theme.Text or Theme.TextDim
                    })
                    if grp.Button:FindFirstChild("Underline") then
                        grp.Button.Underline.Visible = false
                    end
                    local grpStroke = grp.Button:FindFirstChildOfClass("UIStroke")
                    if grpStroke then
                        Util.TweenFast(grpStroke, {
                            Color = isActive and Theme.Accent or Theme.BorderLight,
                            Transparency = isActive and 0.08 or 0.28
                        })
                    end
                end
            end

            groupData.Page.Visible = true
        end

        TabObj.ActivateGroup = ActivateGroup

        -- Tab switching
        local function ActivateTab()
            for _, tab in ipairs(WindowObj.Tabs) do
                tab.Page.Visible = false
                Util.TweenFast(tab.Button, {BackgroundColor3 = Theme.Sidebar})
                Util.TweenFast(tab.Label, {TextColor3 = Theme.TextDim})
                Util.TweenSmooth(tab.ActiveBar, {Size = UDim2.new(0, 3, 0, 0)})
                if tab.IconLabel then
                    Util.TweenFast(tab.IconLabel, {ImageColor3 = Theme.TextDim})
                end
            end

            TabPage.Visible = true
            TabPage.CanvasPosition = Vector2.new(0, 0)
            if TabObj.ActiveGroup then
                ActivateGroup(TabObj.ActiveGroup)
            elseif TabObj.Groups["__default"] then
                ActivateGroup(TabObj.Groups["__default"])
            elseif TabObj.GroupOrder[1] then
                ActivateGroup(TabObj.GroupOrder[1])
            end
            Util.TweenFast(TabButton, {BackgroundColor3 = Theme.SidebarActive})
            Util.TweenFast(TabLabel, {TextColor3 = Theme.Text})
            Util.TweenSmooth(ActiveBar, {Size = UDim2.new(0, 3, 0, 22)})
            if IconLabel then
                Util.TweenFast(IconLabel, {ImageColor3 = Theme.Accent})
            end
            WindowObj.ActiveTab = TabObj
        end

        -- Hover
        TabButton.MouseEnter:Connect(function()
            if WindowObj.ActiveTab ~= TabObj then
                Util.TweenFast(TabButton, {BackgroundColor3 = Theme.SurfaceHover})
            end
        end)
        TabButton.MouseLeave:Connect(function()
            if WindowObj.ActiveTab ~= TabObj then
                Util.TweenFast(TabButton, {BackgroundColor3 = Theme.Sidebar})
            end
        end)
        TabButton.MouseButton1Click:Connect(ActivateTab)

        -- Store
        local tabData = {
            Object    = TabObj,
            Button    = TabButton,
            Label     = TabLabel,
            Page      = TabPage,
            ActiveBar = ActiveBar,
            IconLabel = IconLabel,
        }
        table.insert(WindowObj.Tabs, tabData)

        -- Activate first
        if #WindowObj.Tabs == 1 then
            ActivateTab()
        end

        -- ============================================================
        -- ADD SECTION
        -- ============================================================
        function TabObj:AddSection(secCfg)
            secCfg = secCfg or {}
            local secName = secCfg.Name or "Section"
            local side    = string.lower(secCfg.Side or secCfg.Position or "Left")
            local groupName = secCfg.Group or "__default"
            local groupData = EnsureGroup(groupName)
            local parentCol = (side == "right") and groupData.Right or groupData.Left

            if not TabObj.ActiveGroup then
                if groupName == "__default" then
                    ActivateGroup(groupData)
                elseif TabObj.Groups["__default"] then
                    ActivateGroup(TabObj.Groups["__default"])
                else
                    ActivateGroup(groupData)
                end
            end

            if groupData.Button then
                groupData.Button.MouseButton1Click:Connect(function()
                    ActivateGroup(groupData)
                end)
            end

            local SectionObj = {}

            local SectionFrame = Util.Create("Frame", {
                Name = "Sec_" .. secName,
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2,
                Parent = parentCol
            })
            task.defer(function()
                if groupData.UpdateColumns then
                    groupData.UpdateColumns()
                end
            end)
            Util.AddCorner(SectionFrame, Theme.CornerRadius)
            local _secStroke = Util.AddStroke(SectionFrame, Theme.BorderLight, 1, 0.35)
            Themed(SectionFrame, { BackgroundColor3 = function(t) return t.Surface end })
            Themed(_secStroke, { Color = function(t) return t.BorderLight end })

            -- Section header
            local SecHeader = Util.Create("Frame", {
                Name = "SecHeader",
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 34),
                ClipsDescendants = true,
                ZIndex = 2,
                Parent = SectionFrame
            })
            Util.AddCorner(SecHeader, Theme.CornerRadius)
            Themed(SecHeader, { BackgroundColor3 = function(t) return t.Surface end })

            local _secBottomFix = Util.Create("Frame", {
                Name = "BottomFix",
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 10),
                Position = UDim2.new(0, 0, 1, -10),
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = SecHeader
            })
            Themed(_secBottomFix, { BackgroundColor3 = function(t) return t.Surface end })

            local _secTitle = Util.Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -24, 1, 0),
                Position = UDim2.new(0, 12, 0, 1),
                Text = string.upper(secName),
                TextColor3 = Theme.Text,
                FontFace = Theme.FontBold,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = SecHeader
            })
            Themed(_secTitle, { TextColor3 = function(t) return t.Text end })

            local _secDivider = Util.Create("Frame", {
                Name = "Divider",
                BackgroundColor3 = Theme.Border,
                BackgroundTransparency = 0.35,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, -1),
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = SecHeader
            })
            Themed(_secDivider, { BackgroundColor3 = function(t) return t.Border end })

            -- Element container
            local Elements = Util.Create("Frame", {
                Name = "Elements",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Position = UDim2.new(0, 0, 0, 31),
                ZIndex = 2,
                Parent = SectionFrame
            })
            Util.AddList(Elements, Enum.FillDirection.Vertical, 2)
            Util.AddPadding(Elements, 6, 10, 10, 10)

            -- ==============================================
            -- TOGGLE
            -- ==============================================
            function SectionObj:AddToggle(cfg)
                cfg = cfg or {}
                local name     = cfg.Name or "Toggle"
                local default  = cfg.Default or false
                local callback = cfg.Callback or function() end
                local flag     = cfg.Flag
                local value    = default

                if flag then
                    Hyperion.Flags[flag] = value
                end

                local Frame = Util.Create("Frame", {
                    Name = "Toggle_" .. name,
                    BackgroundColor3 = Theme.SurfaceLight,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    ZIndex = 2,
                    Parent = Elements
                })
                Util.AddCorner(Frame, Theme.CornerSmall)

                local ToggleLabel = Util.Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -52, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    Text = name,
                    TextColor3 = Theme.Text,
                    FontFace = Theme.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2,
                    Parent = Frame
                })
                Themed(ToggleLabel, { TextColor3 = function(t) return t.Text end })

                -- Toggle track
                local Track = Util.Create("Frame", {
                    Name = "Track",
                    BackgroundColor3 = value and Theme.Accent or Theme.ToggleOff,
                    Size = UDim2.new(0, 38, 0, 20),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    ZIndex = 3,
                    Parent = Frame
                })
                Util.AddCorner(Track, UDim.new(1, 0))
                Themed(Track, { BackgroundColor3 = function(t) return value and t.Accent or t.ToggleOff end })

                -- Glow behind track when active
                local TrackGlow = Util.Create("UIStroke", {
                    Color = Theme.AccentGlow,
                    Thickness = value and 1 or 0,
                    Transparency = 0.6,
                    Parent = Track
                })
                Themed(TrackGlow, { Color = function(t) return t.AccentGlow end })

                local Knob = Util.Create("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = value and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    AnchorPoint = value and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
                    ZIndex = 4,
                    Parent = Track
                })
                Util.AddCorner(Knob, UDim.new(1, 0))

                local Hitbox = Util.Create("TextButton", {
                    Name = "Hit",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    ZIndex = 5,
                    Parent = Frame
                })

                local function UpdateVisual(state)
                    Util.TweenSmooth(Track, {BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff})
                    Util.TweenSmooth(TrackGlow, {Thickness = state and 1 or 0})
                    Util.TweenSmooth(Knob, {
                        Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                        AnchorPoint = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
                    })
                end

                -- Register callback for config loading
                if flag then
                    Hyperion.FlagCallbacks[flag] = function(v)
                        value = v
                        Hyperion.Flags[flag] = v
                        UpdateVisual(v)
                        task.spawn(callback, v)
                    end
                end

                Hitbox.MouseButton1Click:Connect(function()
                    value = not value
                    if flag then Hyperion.Flags[flag] = value end
                    UpdateVisual(value)
                    task.spawn(callback, value)
                end)

                -- Hover effect on row
                Hitbox.MouseEnter:Connect(function()
                    Util.TweenFast(Frame, {BackgroundTransparency = 0.5})
                end)
                Hitbox.MouseLeave:Connect(function()
                    Util.TweenFast(Frame, {BackgroundTransparency = 1})
                end)

                local API = {}
                function API:Set(v) value = v; if flag then Hyperion.Flags[flag] = v end; UpdateVisual(v); task.spawn(callback, v) end
                function API:Get() return value end
                return API
            end

            -- ==============================================
            -- SLIDER
            -- ==============================================
            function SectionObj:AddSlider(cfg)
                cfg = cfg or {}
                local name     = cfg.Name or "Slider"
                local min      = cfg.Min or 0
                local max      = cfg.Max or 100
                local default  = math.clamp(cfg.Default or min, min, max)
                local round    = cfg.Round or 1
                local suffix   = cfg.Suffix or ""
                local callback = cfg.Callback or function() end
                local flag     = cfg.Flag
                local value    = default

                if flag then Hyperion.Flags[flag] = value end

                local Frame = Util.Create("Frame", {
                    Name = "Slider_" .. name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 44),
                    ZIndex = 2,
                    Parent = Elements
                })

                -- Label + Value row
                local Row = Util.Create("Frame", {
                    Name = "Row",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    ZIndex = 2,
                    Parent = Frame
                })

                local SliderLabel = Util.Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.65, 0, 1, 0),
                    Text = name,
                    TextColor3 = Theme.Text,
                    FontFace = Theme.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2,
                    Parent = Row
                })
                Themed(SliderLabel, { TextColor3 = function(t) return t.Text end })

                local ValLabel = Util.Create("TextLabel", {
                    Name = "Val",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.35, 0, 1, 0),
                    Position = UDim2.new(0.65, 0, 0, 0),
                    Text = tostring(value) .. suffix,
                    TextColor3 = Theme.Accent,
                    FontFace = Theme.FontMedium,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 2,
                    Parent = Row
                })
                Themed(ValLabel, { TextColor3 = function(t) return t.Accent end })

                -- Track
                local Track = Util.Create("Frame", {
                    Name = "Track",
                    BackgroundColor3 = Theme.SliderBg,
                    Size = UDim2.new(1, 0, 0, 6),
                    Position = UDim2.new(0, 0, 0, 26),
                    ZIndex = 2,
                    Parent = Frame
                })
                Util.AddCorner(Track, UDim.new(1, 0))
                Themed(Track, { BackgroundColor3 = function(t) return t.SliderBg end })

                local ratio = (value - min) / math.max(max - min, 0.001)

                local Fill = Util.Create("Frame", {
                    Name = "Fill",
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new(ratio, 0, 1, 0),
                    ZIndex = 3,
                    Parent = Track
                })
                Util.AddCorner(Fill, UDim.new(1, 0))
                Themed(Fill, { BackgroundColor3 = function(t) return t.Accent end })

                -- Fill glow gradient
                local _fillGrad = Util.Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Theme.AccentDark),
                        ColorSequenceKeypoint.new(1, Theme.Accent),
                    }),
                    Parent = Fill
                })
                Themed(_fillGrad, {
                    Color = function(t)
                        return ColorSequence.new({
                            ColorSequenceKeypoint.new(0, t.AccentDark),
                            ColorSequenceKeypoint.new(1, t.Accent),
                        })
                    end
                })

                local KnobObj = Util.Create("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(ratio, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 5,
                    Parent = Track
                })
                Util.AddCorner(KnobObj, UDim.new(1, 0))

                local KnobGlow = Util.Create("UIStroke", {
                    Color = Theme.Accent,
                    Thickness = 0,
                    Transparency = 0.4,
                    Parent = KnobObj
                })
                Themed(KnobGlow, { Color = function(t) return t.Accent end })

                -- Hitbox
                local Hitbox = Util.Create("TextButton", {
                    Name = "Hit",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 10, 0, 22),
                    Position = UDim2.new(0, -5, 0, 18),
                    Text = "",
                    ZIndex = 6,
                    Parent = Frame
                })

                local dragging = false

                local function UpdateSlider(input)
                    local pos = math.clamp(
                        (input.Position.X - Track.AbsolutePosition.X) / math.max(Track.AbsoluteSize.X, 1),
                        0, 1
                    )
                    local rawVal = min + (max - min) * pos
                    value = math.clamp(math.floor(rawVal / round + 0.5) * round, min, max)
                    if flag then Hyperion.Flags[flag] = value end
                    ValLabel.Text = tostring(value) .. suffix
                    local r = (value - min) / math.max(max - min, 0.001)
                    Fill.Size = UDim2.new(r, 0, 1, 0)
                    KnobObj.Position = UDim2.new(r, 0, 0.5, 0)
                    task.spawn(callback, value)
                end

                Hitbox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        Util.TweenFast(KnobGlow, {Thickness = 3})
                        Util.TweenFast(KnobObj, {Size = UDim2.new(0, 16, 0, 16)})
                        UpdateSlider(input)
                    end
                end)
                Hitbox.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                        Util.TweenFast(KnobGlow, {Thickness = 0})
                        Util.TweenFast(KnobObj, {Size = UDim2.new(0, 14, 0, 14)})
                    end
                end)

                -- Pooled input
                table.insert(InputPool.SliderCallbacks, function(input)
                    if dragging then UpdateSlider(input) end
                end)

                if flag then
                    Hyperion.FlagCallbacks[flag] = function(v)
                        value = math.clamp(v, min, max)
                        Hyperion.Flags[flag] = value
                        ValLabel.Text = tostring(value) .. suffix
                        local r = (value - min) / math.max(max - min, 0.001)
                        Fill.Size = UDim2.new(r, 0, 1, 0)
                        KnobObj.Position = UDim2.new(r, 0, 0.5, 0)
                        task.spawn(callback, value)
                    end
                end

                local API = {}
                function API:Set(v) value = math.clamp(v, min, max); if flag then Hyperion.Flags[flag] = value end; ValLabel.Text = tostring(value) .. suffix; local r = (value - min) / math.max(max - min, 0.001); Fill.Size = UDim2.new(r, 0, 1, 0); KnobObj.Position = UDim2.new(r, 0, 0.5, 0); task.spawn(callback, value) end
                function API:Get() return value end
                return API
            end

            -- ==============================================
            -- BUTTON
            -- ==============================================
            function SectionObj:AddButton(cfg)
                cfg = cfg or {}
                local name     = cfg.Name or "Button"
                local callback = cfg.Callback or function() end
                local icon     = cfg.Icon or nil

                local Btn = Util.Create("TextButton", {
                    Name = "Btn_" .. name,
                    BackgroundColor3 = Theme.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 30),
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 2,
                    Parent = Elements
                })
                Util.AddCorner(Btn, Theme.CornerSmall)
                local _btnStroke = Util.AddStroke(Btn, Theme.Border, 1, 0.45)
                Themed(Btn, { BackgroundColor3 = function(t) return t.SurfaceLight end })
                Themed(_btnStroke, { Color = function(t) return t.Border end })

                -- Left accent bar
                local BtnAccent = Util.Create("Frame", {
                    Name = "Accent",
                    BackgroundColor3 = Theme.Accent,
                    BackgroundTransparency = 0.55,
                    Size = UDim2.new(0, 2, 0.6, 0),
                    Position = UDim2.new(0, 0, 0.2, 0),
                    BorderSizePixel = 0,
                    ZIndex = 3,
                    Parent = Btn
                })
                Util.AddCorner(BtnAccent, UDim.new(1, 0))
                Themed(BtnAccent, { BackgroundColor3 = function(t) return t.Accent end })

                local xOffset = 10
                if icon then
                    local BtnIcon = Util.Create("ImageLabel", {
                        Name = "Icon",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 14, 0, 14),
                        Position = UDim2.new(0, 10, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Image = icon,
                        ImageColor3 = Theme.TextDim,
                        ZIndex = 3,
                        Parent = Btn
                    })
                    Themed(BtnIcon, { ImageColor3 = function(t) return t.TextDim end })
                    xOffset = 28
                end

                local BtnLabel = Util.Create("TextLabel", {
                    Name = "Lbl",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -(xOffset + 8), 1, 0),
                    Position = UDim2.new(0, xOffset, 0, 0),
                    Text = name,
                    TextColor3 = Theme.Text,
                    FontFace = Theme.FontMedium,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 3,
                    Parent = Btn
                })
                Themed(BtnLabel, { TextColor3 = function(t) return t.Text end })

                Btn.MouseEnter:Connect(function()
                    Util.TweenFast(Btn, {BackgroundColor3 = Theme.SurfaceHover})
                    Util.TweenFast(BtnAccent, {BackgroundTransparency = 0.2})
                end)
                Btn.MouseLeave:Connect(function()
                    Util.TweenFast(Btn, {BackgroundColor3 = Theme.SurfaceLight})
                    Util.TweenFast(BtnAccent, {BackgroundTransparency = 0.55})
                end)
                Btn.MouseButton1Click:Connect(function()
                    Util.Ripple(Btn, Theme.Accent)
                    Util.TweenFast(Btn, {BackgroundColor3 = Theme.AccentDark})
                    task.delay(0.12, function()
                        Util.TweenFast(Btn, {BackgroundColor3 = Theme.SurfaceLight})
                    end)
                    task.spawn(callback)
                end)

                local API = {}
                function API:SetLabel(t)
                    local lbl = Btn:FindFirstChild("Lbl")
                    if lbl then lbl.Text = t end
                end
                return API
            end

            -- ==============================================
            -- DROPDOWN
            -- ==============================================
            function SectionObj:AddDropdown(cfg)
                cfg = cfg or {}
                local name     = cfg.Name or "Dropdown"
                local values   = cfg.Values or {}
                local default  = cfg.Default or (cfg.Multi and {} or values[1])
                local multi    = cfg.Multi or false
                local callback = cfg.Callback or function() end
                local flag     = cfg.Flag
                local selected = default
                local opened   = false

                if flag then Hyperion.Flags[flag] = selected end

                local Frame = Util.Create("Frame", {
                    Name = "Drop_" .. name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 58),
                    ClipsDescendants = false,
                    ZIndex = 2,
                    Parent = Elements
                })

                local DropLabel = Util.Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    Text = name,
                    TextColor3 = Theme.Text,
                    FontFace = Theme.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2,
                    Parent = Frame
                })
                Themed(DropLabel, { TextColor3 = function(t) return t.Text end })

                local function GetDisplay()
                    if multi then
                        if type(selected) == "table" and #selected > 0 then
                            local display = table.concat(selected, ", ")
                            return #display > 30 and (string.sub(display, 1, 28) .. "...") or display
                        end
                        return "None"
                    end
                    return tostring(selected or "Select...")
                end

                local DropBtn = Util.Create("TextButton", {
                    Name = "DropBtn",
                    BackgroundColor3 = Theme.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 30),
                    Position = UDim2.new(0, 0, 0, 22),
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 3,
                    Parent = Frame
                })
                Util.AddCorner(DropBtn, Theme.CornerSmall)
                local dropStroke = Util.AddStroke(DropBtn, Theme.BorderLight, 1, 0.25)
                Themed(DropBtn, { BackgroundColor3 = function(t) return t.SurfaceLight end })
                Themed(dropStroke, { Color = function(t) return opened and t.Accent or t.BorderLight end })

                local DropText = Util.Create("TextLabel", {
                    Name = "Text",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -32, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Text = GetDisplay(),
                    TextColor3 = Theme.TextDim,
                    FontFace = Theme.Font,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 3,
                    Parent = DropBtn
                })
                Themed(DropText, { TextColor3 = function(t) return t.TextDim end })

                local Arrow = Util.Create("TextLabel", {
                    Name = "Arrow",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -24, 0, 0),
                    Text = "▾",
                    TextColor3 = Theme.TextMuted,
                    FontFace = Theme.Font,
                    TextSize = 14,
                    ZIndex = 3,
                    Parent = DropBtn
                })
                Themed(Arrow, { TextColor3 = function(t) return opened and t.Accent or t.TextMuted end })

                -- Options panel
                local OptsFrame = Util.Create("ScrollingFrame", {
                    Name = "Opts",
                    BackgroundColor3 = Theme.Surface,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 54),
                    ClipsDescendants = true,
                    Visible = false,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Theme.AccentSub,
                    ScrollBarImageTransparency = 0.5,
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ZIndex = 20,
                    Parent = Frame
                })
                Util.AddCorner(OptsFrame, Theme.CornerSmall)
                local OptsStroke = Util.AddStroke(OptsFrame, Theme.Border, 1, 0.3)
                Util.AddPadding(OptsFrame, 3, 3, 3, 3)
                Themed(OptsFrame, {
                    BackgroundColor3 = function(t) return t.Surface end,
                    ScrollBarImageColor3 = function(t) return t.AccentSub end,
                })
                Themed(OptsStroke, { Color = function(t) return t.Border end })

                local OptsList = Util.AddList(OptsFrame, Enum.FillDirection.Vertical, 1)

                local function RefreshOptions()
                    for _, ch in ipairs(OptsFrame:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end

                    for i, val in ipairs(values) do
                        local isSel = false
                        if multi then
                            for _, s in ipairs(selected) do
                                if s == val then isSel = true; break end
                            end
                        else
                            isSel = (selected == val)
                        end

                        local OptBtn = Util.Create("TextButton", {
                            Name = "O_" .. tostring(val),
                            BackgroundColor3 = isSel and Theme.SurfaceActive or Theme.Surface,
                            Size = UDim2.new(1, 0, 0, 26),
                            Text = "",
                            AutoButtonColor = false,
                            LayoutOrder = i,
                            ZIndex = 21,
                            Parent = OptsFrame
                        })
                        Util.AddCorner(OptBtn, Theme.CornerSmall)

                        -- Check indicator for multi
                        if multi then
                            Util.Create("Frame", {
                                Name = "Check",
                                BackgroundColor3 = isSel and Theme.Accent or Theme.ToggleOff,
                                Size = UDim2.new(0, 12, 0, 12),
                                Position = UDim2.new(0, 6, 0.5, 0),
                                AnchorPoint = Vector2.new(0, 0.5),
                                ZIndex = 22,
                                Parent = OptBtn
                            })
                            Util.AddCorner(OptBtn:FindFirstChild("Check"), Theme.CornerSmall)
                        end

                        Util.Create("TextLabel", {
                            Name = "Lbl",
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, -(multi and 28 or 12), 1, 0),
                            Position = UDim2.new(0, multi and 24 or 8, 0, 0),
                            Text = tostring(val),
                            TextColor3 = isSel and Theme.Text or Theme.TextDim,
                            FontFace = isSel and Theme.FontMedium or Theme.Font,
                            TextSize = 12,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 22,
                            Parent = OptBtn
                        })

                        OptBtn.MouseEnter:Connect(function()
                            Util.TweenFast(OptBtn, {BackgroundColor3 = Theme.SurfaceHover})
                        end)
                        OptBtn.MouseLeave:Connect(function()
                            local s = false
                            if multi then
                                for _, x in ipairs(selected) do if x == val then s = true; break end end
                            else s = (selected == val) end
                            Util.TweenFast(OptBtn, {BackgroundColor3 = s and Theme.SurfaceActive or Theme.Surface})
                        end)

                        OptBtn.MouseButton1Click:Connect(function()
                            if multi then
                                local idx = table.find(selected, val)
                                if idx then table.remove(selected, idx) else table.insert(selected, val) end
                            else
                                selected = val
                                opened = false
                                OptsFrame.Visible = false
                                Util.TweenSmooth(Frame, {Size = UDim2.new(1, 0, 0, 58)})
                                Util.TweenFast(dropStroke, {Color = Theme.Border})
                                Arrow.Text = "▾"
                            end
                            if flag then Hyperion.Flags[flag] = selected end
                            DropText.Text = GetDisplay()
                            RefreshOptions()
                            task.spawn(callback, selected)
                        end)
                    end
                end
                RefreshOptions()
                Hyperion:OnThemeChanged(function()
                    if Frame and Frame.Parent then
                        RefreshOptions()
                    end
                end)

                DropBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        OptsFrame.Visible = true
                        local optH = math.min(#values, 6) * 27 + 8
                        Util.TweenSmooth(OptsFrame, {Size = UDim2.new(1, 0, 0, optH)})
                        Util.TweenSmooth(Frame, {Size = UDim2.new(1, 0, 0, 58 + optH + 4)})
                        Util.TweenFast(dropStroke, {Color = Theme.Accent})
                        Arrow.Text = "▴"
                    else
                        Util.TweenSmooth(OptsFrame, {Size = UDim2.new(1, 0, 0, 0)})
                        Util.TweenSmooth(Frame, {Size = UDim2.new(1, 0, 0, 58)})
                        Util.TweenFast(dropStroke, {Color = Theme.Border})
                        Arrow.Text = "▾"
                        task.delay(0.3, function()
                            if not opened then OptsFrame.Visible = false end
                        end)
                    end
                end)

                if flag then
                    Hyperion.FlagCallbacks[flag] = function(v)
                        selected = v; Hyperion.Flags[flag] = v
                        DropText.Text = GetDisplay(); RefreshOptions()
                        task.spawn(callback, v)
                    end
                end

                local API = {}
                function API:Set(v) selected = v; if flag then Hyperion.Flags[flag] = v end; DropText.Text = GetDisplay(); RefreshOptions(); task.spawn(callback, v) end
                function API:Get() return selected end
                function API:Refresh(newVals) values = newVals; RefreshOptions() end
                return API
            end

            -- ==============================================
            -- MULTI-DROPDOWN (alias)
            -- ==============================================
            function SectionObj:AddMultiDropdown(cfg)
                cfg = cfg or {}; cfg.Multi = true
                return SectionObj:AddDropdown(cfg)
            end

            -- ==============================================
            -- TEXTBOX
            -- ==============================================
            function SectionObj:AddTextbox(cfg)
                cfg = cfg or {}
                local name     = cfg.Name or "Textbox"
                local default  = cfg.Default or ""
                local placeholder = cfg.Placeholder or "Type here..."
                local callback = cfg.Callback or function() end
                local flag     = cfg.Flag
                local value    = default

                if flag then Hyperion.Flags[flag] = value end

                local Frame = Util.Create("Frame", {
                    Name = "Tb_" .. name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 52),
                    ZIndex = 2,
                    Parent = Elements
                })

                local TbLabel = Util.Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    Text = name,
                    TextColor3 = Theme.Text,
                    FontFace = Theme.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2,
                    Parent = Frame
                })
                Themed(TbLabel, { TextColor3 = function(t) return t.Text end })

                local Input = Util.Create("TextBox", {
                    Name = "Input",
                    BackgroundColor3 = Theme.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 28),
                    Position = UDim2.new(0, 0, 0, 22),
                    Text = default,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = Theme.TextMuted,
                    TextColor3 = Theme.Text,
                    FontFace = Theme.Font,
                    TextSize = 12,
                    ClearTextOnFocus = false,
                    ZIndex = 3,
                    Parent = Frame
                })
                Util.AddCorner(Input, Theme.CornerSmall)
                local inputStroke = Util.AddStroke(Input, Theme.BorderLight, 1, 0.25)
                Util.AddPadding(Input, 0, 8, 0, 8)
                Themed(Input, {
                    BackgroundColor3 = function(t) return t.SurfaceLight end,
                    PlaceholderColor3 = function(t) return t.TextMuted end,
                    TextColor3 = function(t) return t.Text end,
                })
                Themed(inputStroke, { Color = function(t) return t.BorderLight end })

                Input.Focused:Connect(function()
                    Util.TweenFast(inputStroke, {Color = Theme.Accent, Transparency = 0})
                end)
                Input.FocusLost:Connect(function(enter)
                    Util.TweenFast(inputStroke, {Color = Theme.Border, Transparency = 0.4})
                    value = Input.Text
                    if flag then Hyperion.Flags[flag] = value end
                    task.spawn(callback, value, enter)
                end)

                local API = {}
                function API:Set(v) Input.Text = v; value = v; if flag then Hyperion.Flags[flag] = v end end
                function API:Get() return value end
                return API
            end

            -- ==============================================
            -- KEYBIND
            -- ==============================================
            function SectionObj:AddKeybind(cfg)
                cfg = cfg or {}
                local name     = cfg.Name or "Keybind"
                local default  = cfg.Default or Enum.KeyCode.Unknown
                local callback = cfg.Callback or function() end
                local flag     = cfg.Flag
                local value    = default
                local listening = false

                if flag then Hyperion.Flags[flag] = value end

                local Frame = Util.Create("Frame", {
                    Name = "Kb_" .. name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    ZIndex = 2,
                    Parent = Elements
                })

                local KbLabel = Util.Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -80, 1, 0),
                    Text = name,
                    TextColor3 = Theme.Text,
                    FontFace = Theme.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2,
                    Parent = Frame
                })
                Themed(KbLabel, { TextColor3 = function(t) return t.Text end })

                local function KeyName(key)
                    if key == Enum.KeyCode.Unknown then return "None" end
                    return string.gsub(tostring(key), "Enum.KeyCode.", "")
                end

                local KbBtn = Util.Create("TextButton", {
                    Name = "KbBtn",
                    BackgroundColor3 = Theme.SurfaceLight,
                    Size = UDim2.new(0, 72, 0, 24),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Text = KeyName(value),
                    TextColor3 = Theme.TextDim,
                    FontFace = Theme.FontMedium,
                    TextSize = 11,
                    AutoButtonColor = false,
                    ZIndex = 3,
                    Parent = Frame
                })
                Util.AddCorner(KbBtn, Theme.CornerSmall)
                local kbStroke = Util.AddStroke(KbBtn, Theme.BorderLight, 1, 0.25)
                Themed(KbBtn, {
                    BackgroundColor3 = function(t) return t.SurfaceLight end,
                    TextColor3 = function(t) return listening and t.Accent or t.TextDim end,
                })
                Themed(kbStroke, { Color = function(t) return listening and t.Accent or t.BorderLight end })

                KbBtn.MouseButton1Click:Connect(function()
                    listening = true
                    KbBtn.Text = "..."
                    Util.TweenFast(kbStroke, {Color = Theme.Accent, Transparency = 0})
                end)

                Util.Connect(UserInputService.InputBegan, function(input, processed)
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            listening = false
                            value = (input.KeyCode == Enum.KeyCode.Escape) and Enum.KeyCode.Unknown or input.KeyCode
                            if flag then Hyperion.Flags[flag] = value end
                            KbBtn.Text = KeyName(value)
                            Util.TweenFast(kbStroke, {Color = Theme.Border, Transparency = 0.4})
                        end
                    else
                        if not processed and input.KeyCode == value and value ~= Enum.KeyCode.Unknown then
                            task.spawn(callback, value)
                        end
                    end
                end)

                if flag then
                    Hyperion.FlagCallbacks[flag] = function(v)
                        value = v
                        Hyperion.Flags[flag] = v
                        KbBtn.Text = KeyName(v)
                    end
                end

                local API = {}
                function API:Set(v) value = v; if flag then Hyperion.Flags[flag] = v end; KbBtn.Text = KeyName(v) end
                function API:Get() return value end
                return API
            end

            -- ==============================================
            -- COLOR PICKER
            -- ==============================================
            function SectionObj:AddColorPicker(cfg)
                cfg = cfg or {}
                local name     = cfg.Name or "Color"
                local default  = cfg.Default or Theme.Accent
                local hasTrans = cfg.Transparency ~= nil
                local callback = cfg.Callback or function() end
                local flag     = cfg.Flag

                local color = default
                local alpha = cfg.Transparency or 0
                local opened = false
                local h, s, v = Color3.toHSV(color)

                if flag then Hyperion.Flags[flag] = color end

                local Frame = Util.Create("Frame", {
                    Name = "Cp_" .. name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    ClipsDescendants = false,
                    ZIndex = 2,
                    Parent = Elements
                })

                Util.Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -36, 1, 0),
                    Text = name,
                    TextColor3 = Theme.Text,
                    FontFace = Theme.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2,
                    Parent = Frame
                })

                local Preview = Util.Create("Frame", {
                    Name = "Preview",
                    BackgroundColor3 = color,
                    Size = UDim2.new(0, 26, 0, 26),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    ZIndex = 3,
                    Parent = Frame
                })
                Util.AddCorner(Preview, Theme.CornerSmall)
                Util.AddStroke(Preview, Theme.BorderLight, 1, 0.1)

                local PreviewGlow = Util.Create("UIStroke", {
                    Color = Theme.Accent,
                    Thickness = 0,
                    Transparency = 0.35,
                    Parent = Preview
                })

                local PreviewBtn = Util.Create("TextButton", {
                    Name = "Hit",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 26, 0, 26),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Text = "",
                    ZIndex = 4,
                    Parent = Frame
                })

                PreviewBtn.MouseEnter:Connect(function()
                    Util.TweenFast(PreviewGlow, {Thickness = 2})
                end)
                PreviewBtn.MouseLeave:Connect(function()
                    if not opened then
                        Util.TweenFast(PreviewGlow, {Thickness = 0})
                    end
                end)

                local pickerH = hasTrans and 175 or 148
                local PickerPanel = Util.Create("Frame", {
                    Name = "Picker",
                    BackgroundColor3 = Theme.Surface,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 34),
                    ClipsDescendants = true,
                    Visible = false,
                    ZIndex = 20,
                    Parent = Frame
                })
                Util.AddCorner(PickerPanel, Theme.CornerSmall)
                Util.AddStroke(PickerPanel, Theme.Border, 1, 0.3)

                -- SV Box
                local SVBox = Util.Create("ImageLabel", {
                    Name = "SV",
                    BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                    Size = UDim2.new(1, -36, 0, 100),
                    Position = UDim2.new(0, 8, 0, 8),
                    Image = "rbxassetid://4155801252",
                    ZIndex = 21,
                    Parent = PickerPanel
                })
                Util.AddCorner(SVBox, Theme.CornerSmall)

                local SVCursor = Util.Create("Frame", {
                    Name = "Cur",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 0.15,
                    Size = UDim2.new(0, 10, 0, 10),
                    Position = UDim2.new(s, 0, 1 - v, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 22,
                    Parent = SVBox
                })
                Util.AddCorner(SVCursor, UDim.new(1, 0))
                Util.AddStroke(SVCursor, Color3.new(0, 0, 0), 1, 0.4)

                -- Hue bar
                local HueBar = Util.Create("Frame", {
                    Name = "Hue",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.new(0, 16, 0, 100),
                    Position = UDim2.new(1, -24, 0, 8),
                    ZIndex = 21,
                    Parent = PickerPanel
                })
                Util.AddCorner(HueBar, Theme.CornerSmall)

                Util.Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
                        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255,255,0)),
                        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0,255,0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
                        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0,0,255)),
                        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255,0,255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0)),
                    }),
                    Rotation = 90,
                    Parent = HueBar
                })

                local HueCur = Util.Create("Frame", {
                    Name = "Cur",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.new(1, 4, 0, 4),
                    Position = UDim2.new(0.5, 0, h, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 22,
                    Parent = HueBar
                })
                Util.AddCorner(HueCur, UDim.new(1, 0))

                -- Alpha bar
                local AlphaBar, AlphaCur
                if hasTrans then
                    AlphaBar = Util.Create("Frame", {
                        Name = "Alpha",
                        BackgroundColor3 = color,
                        Size = UDim2.new(1, -16, 0, 14),
                        Position = UDim2.new(0, 8, 0, 116),
                        ZIndex = 21,
                        Parent = PickerPanel
                    })
                    Util.AddCorner(AlphaBar, Theme.CornerSmall)
                    Util.Create("UIGradient", {
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(1, 1),
                        }),
                        Parent = AlphaBar
                    })
                    AlphaCur = Util.Create("Frame", {
                        Name = "Cur",
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        Size = UDim2.new(0, 4, 1, 4),
                        Position = UDim2.new(alpha, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ZIndex = 22,
                        Parent = AlphaBar
                    })
                    Util.AddCorner(AlphaCur, UDim.new(1, 0))
                end

                -- Hex display
                local function ToHex(c)
                    return string.format("#%02X%02X%02X", math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
                end

                local HexLabel = Util.Create("TextLabel", {
                    Name = "Hex",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -16, 0, 14),
                    Position = UDim2.new(0, 8, 1, hasTrans and -20 or -18),
                    Text = ToHex(color),
                    TextColor3 = Theme.TextMuted,
                    FontFace = Theme.Font,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 21,
                    Parent = PickerPanel
                })

                local function UpdateColor()
                    color = Color3.fromHSV(h, s, v)
                    Preview.BackgroundColor3 = color
                    SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                    HueCur.Position = UDim2.new(0.5, 0, h, 0)
                    HexLabel.Text = ToHex(color)
                    if AlphaBar then AlphaBar.BackgroundColor3 = color end
                    if flag then Hyperion.Flags[flag] = color end
                    task.spawn(callback, color, alpha)
                end

                -- Drag states
                local svDrag, hueDrag, alphaDrag = false, false, false

                SVBox.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = true end end)
                SVBox.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = false end end)
                HueBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = true end end)
                HueBar.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = false end end)
                if AlphaBar then
                    AlphaBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then alphaDrag = true end end)
                    AlphaBar.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then alphaDrag = false end end)
                end

                table.insert(InputPool.ColorCallbacks, function(input)
                    if svDrag then
                        s = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / math.max(SVBox.AbsoluteSize.X, 1), 0, 1)
                        v = 1 - math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / math.max(SVBox.AbsoluteSize.Y, 1), 0, 1)
                        UpdateColor()
                    end
                    if hueDrag then
                        h = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / math.max(HueBar.AbsoluteSize.Y, 1), 0, 1)
                        UpdateColor()
                    end
                    if alphaDrag and AlphaBar then
                        alpha = math.clamp((input.Position.X - AlphaBar.AbsolutePosition.X) / math.max(AlphaBar.AbsoluteSize.X, 1), 0, 1)
                        AlphaCur.Position = UDim2.new(alpha, 0, 0.5, 0)
                        task.spawn(callback, color, alpha)
                    end
                end)

                local function ClosePicker()
                    if not opened then return end
                    opened = false
                    svDrag, hueDrag, alphaDrag = false, false, false
                    Util.TweenSmooth(PickerPanel, {Size = UDim2.new(1, 0, 0, 0)})
                    Util.TweenSmooth(Frame, {Size = UDim2.new(1, 0, 0, 32)})
                    task.delay(0.3, function()
                        if not opened and PickerPanel and PickerPanel.Parent then
                            PickerPanel.Visible = false
                            Util.TweenFast(PreviewGlow, {Thickness = 0})
                        end
                    end)
                end

                local function OpenPicker()
                    opened = true
                    PickerPanel.Visible = true
                    Util.TweenSmooth(PickerPanel, {Size = UDim2.new(1, 0, 0, pickerH)})
                    Util.TweenSmooth(Frame, {Size = UDim2.new(1, 0, 0, 34 + pickerH + 4)})
                end

                PreviewBtn.MouseButton1Click:Connect(function()
                    if opened then
                        ClosePicker()
                    else
                        OpenPicker()
                        Util.TweenFast(PreviewGlow, {Thickness = 2})
                    end
                end)

                Util.Connect(UserInputService.InputBegan, function(input, processed)
                    if processed or not opened then return end
                    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end

                    local mousePos = input.Position
                    local framePos = Frame.AbsolutePosition
                    local frameSize = Frame.AbsoluteSize

                    local insideFrame = mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X
                        and mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y

                    if not insideFrame then
                        ClosePicker()
                    end
                end)

                local API = {}
                function API:Set(c, a) color = c; alpha = a or alpha; h, s, v = Color3.toHSV(c); UpdateColor() end
                function API:Get() return color, alpha end
                return API
            end

            -- ==============================================
            -- LABEL
            -- ==============================================
            function SectionObj:AddLabel(cfg)
                cfg = cfg or {}
                local text = cfg.Text or cfg.Name or "Label"
                local Lbl = Util.Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Text = text,
                    TextColor3 = Theme.TextDim,
                    FontFace = Theme.Font,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2,
                    Parent = Elements
                })
                local API = {}
                function API:Set(t) Lbl.Text = t end
                return API
            end

            -- ==============================================
            -- DIVIDER
            -- ==============================================
            function SectionObj:AddDivider(cfg)
                cfg = cfg or {}
                local title = cfg.Title or cfg.Name or nil
                local DivFrame = Util.Create("Frame", {
                    Name = "Div",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, title and 24 or 10),
                    ZIndex = 2,
                    Parent = Elements
                })
                if title then
                    Util.Create("TextLabel", {
                        Name = "T",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 14),
                        Text = string.upper(title),
                        TextColor3 = Theme.TextMuted,
                        FontFace = Theme.FontSemiBold,
                        TextSize = 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 2,
                        Parent = DivFrame
                    })
                end
                Util.Create("Frame", {
                    Name = "Line",
                    BackgroundColor3 = Theme.Border,
                    BackgroundTransparency = 0.4,
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 1, -1),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    Parent = DivFrame
                })
            end

            -- ==============================================
            -- THEME PICKER
            -- ==============================================
            function SectionObj:AddThemePicker(cfg)
                cfg = cfg or {}
                local callback = cfg.Callback or function() end

                local themeOrder  = {"Purple", "Midnight", "Rose"}
                local themeAccents = {
                    Purple   = Color3.fromRGB(140, 80, 220),
                    Midnight = Color3.fromRGB(80, 120, 255),
                                        Rose     = Color3.fromRGB(220, 80, 120),
                }

                local currentTheme = "Purple"
                local swatches = {}

                for _, name in ipairs(themeOrder) do
                    local accent = themeAccents[name]

                    local Row = Util.Create("TextButton", {
                        Name = "Theme_" .. name,
                        BackgroundColor3 = Theme.SurfaceLight,
                        BackgroundTransparency = 0.4,
                        Size = UDim2.new(1, 0, 0, 32),
                        Text = "",
                        AutoButtonColor = false,
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        Parent = Elements,
                    })
                    Util.AddCorner(Row, Theme.CornerSmall)
                    local RowStroke = Util.AddStroke(Row, Theme.Border, 1, 0.5)

                    -- Color dot
                    local Dot = Util.Create("Frame", {
                        BackgroundColor3 = accent,
                        Size = UDim2.new(0, 14, 0, 14),
                        Position = UDim2.new(0, 8, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BorderSizePixel = 0,
                        ZIndex = 3,
                        Parent = Row,
                    })
                    Util.AddCorner(Dot, UDim.new(1, 0))
                    Util.AddStroke(Dot, accent, 1, 0.55)

                    Util.Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -50, 1, 0),
                        Position = UDim2.new(0, 30, 0, 0),
                        Text = name,
                        TextColor3 = Theme.Text,
                        FontFace = Theme.FontMedium,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 3,
                        Parent = Row,
                    })

                    local Check = Util.Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 20, 1, 0),
                        Position = UDim2.new(1, -24, 0, 0),
                        Text = "✓",
                        TextColor3 = accent,
                        FontFace = Theme.FontBold,
                        TextSize = 13,
                        TextTransparency = (name == currentTheme) and 0 or 1,
                        ZIndex = 3,
                        Parent = Row,
                    })

                    Themed(Row, {
                        BackgroundColor3 = function(t)
                            return (currentTheme == name) and t.SurfaceActive or t.SurfaceLight
                        end
                    })
                    Themed(RowStroke, {
                        Color = function(t)
                            return (currentTheme == name) and accent or t.Border
                        end
                    })
                    for _, child in ipairs(Row:GetChildren()) do
                        if child:IsA("TextLabel") and child ~= Check then
                            Themed(child, { TextColor3 = function(t) return t.Text end })
                        end
                    end
                    Themed(Check, { TextColor3 = function(_) return accent end })

                    
                    swatches[name] = {Row = Row, Stroke = RowStroke, Check = Check, Accent = accent}

                    Row.MouseEnter:Connect(function()
                        if currentTheme ~= name then
                            Util.TweenFast(Row, {BackgroundTransparency = 0.2})
                        end
                    end)
                    Row.MouseLeave:Connect(function()
                        if currentTheme ~= name then
                            Util.TweenFast(Row, {BackgroundTransparency = 0.4})
                        end
                    end)

                    Row.MouseButton1Click:Connect(function()
                        if currentTheme == name then return end
                        -- Deselect previous
                        local prev = swatches[currentTheme]
                        if prev then
                            Util.TweenFast(prev.Row, {BackgroundTransparency = 0.4})
                            Util.TweenFast(prev.Stroke, {Color = Theme.Border, Transparency = 0.5})
                            Util.TweenFast(prev.Check, {TextTransparency = 1})
                        end
                        currentTheme = name
                        Hyperion:SetTheme(name)
                        -- Select new
                        Util.TweenFast(Row, {BackgroundTransparency = 0.1})
                        Util.TweenFast(RowStroke, {Color = accent, Transparency = 0.3})
                        Util.TweenFast(Check, {TextTransparency = 0})
                        -- Refresh config list rows
                        RefreshConfigList()
                        Hyperion:Notify({
                            Title   = "Theme",
                            Content = name .. " theme applied.",
                            Type    = "Info",
                            Duration = 2,
                        })
                        callback(name)
                    end)
                end

                -- Highlight default
                local init = swatches["Purple"]
                if init then
                    Util.TweenFast(init.Row, {BackgroundTransparency = 0.1})
                    Util.TweenFast(init.Stroke, {Color = themeAccents["Purple"], Transparency = 0.3})
                end

                -- ── Transparency slider ───────────────────────────────────
                local _transDivider = Util.Create("Frame", {
                    BackgroundColor3 = Theme.Border,
                    BackgroundTransparency = 0.4,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0, ZIndex = 2,
                    Parent = Elements,
                })
                Themed(_transDivider, { BackgroundColor3 = function(t) return t.Border end })

                Util.Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 14),
                    Text = "UI TRANSPARENCY",
                    TextColor3 = Theme.TextMuted,
                    FontFace = Theme.FontSemiBold,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2, Parent = Elements,
                })

                -- Slider track
                local transValue = 0
                local TransTrack = Util.Create("Frame", {
                    BackgroundColor3 = Theme.SliderBg,
                    Size = UDim2.new(1, 0, 0, 6),
                    ZIndex = 2, Parent = Elements,
                })
                Util.AddCorner(TransTrack, UDim.new(1, 0))
                Themed(TransTrack, { BackgroundColor3 = function(t) return t.SliderBg end })

                local TransFill = Util.Create("Frame", {
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new(0, 0, 1, 0),
                    ZIndex = 3, Parent = TransTrack,
                })
                Util.AddCorner(TransFill, UDim.new(1, 0))
                Themed(TransFill, { BackgroundColor3 = function(t) return t.Accent end })

                local TransKnob = Util.Create("Frame", {
                    BackgroundColor3 = Color3.new(1,1,1),
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 4, Parent = TransTrack,
                })
                Util.AddCorner(TransKnob, UDim.new(1, 0))

                local TransHit = Util.Create("TextButton", {
                    BackgroundTransparency = 1, Text = "",
                    Size = UDim2.new(1, 10, 0, 20),
                    Position = UDim2.new(0, -5, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    ZIndex = 5, Parent = TransTrack,
                })

                local transDragging = false
                TransHit.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        transDragging = true
                    end
                end)
                TransHit.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        transDragging = false
                    end
                end)
                table.insert(InputPool.SliderCallbacks, function(input)
                    if transDragging then
                        local ratio = math.clamp(
                            (input.Position.X - TransTrack.AbsolutePosition.X) / math.max(TransTrack.AbsoluteSize.X, 1),
                            0, 1
                        )
                        transValue = math.floor(ratio * 95 + 0.5) / 100
                        TransFill.Size = UDim2.new(ratio, 0, 1, 0)
                        TransKnob.Position = UDim2.new(ratio, 0, 0.5, 0)
                        WindowObj:SetTransparency(transValue)
                    end
                end)

                -- ── Background image textbox ──────────────────────────────
                Util.Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 14),
                    Text = "BACKGROUND IMAGE",
                    TextColor3 = Theme.TextMuted,
                    FontFace = Theme.FontSemiBold,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2, Parent = Elements,
                })

                local BgRow = Util.Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28),
                    ZIndex = 2, Parent = Elements,
                })

                local BgBox = Util.Create("TextBox", {
                    BackgroundColor3 = Theme.InputBg,
                    Size = UDim2.new(1, -36, 1, 0),
                    Text = "",
                    PlaceholderText = "rbxassetid://...",
                    TextColor3 = Theme.Text,
                    PlaceholderColor3 = Theme.TextMuted,
                    FontFace = Theme.Font,
                    TextSize = 11,
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0,
                    ZIndex = 3, Parent = BgRow,
                })
                Util.AddCorner(BgBox, Theme.CornerSmall)
                Util.AddStroke(BgBox, Theme.Border, 1, 0.3)
                Themed(BgBox, {
                    BackgroundColor3  = function(t) return t.InputBg end,
                    TextColor3        = function(t) return t.Text end,
                    PlaceholderColor3 = function(t) return t.TextMuted end,
                })

                local BgApplyBtn = Util.Create("TextButton", {
                    BackgroundColor3 = Theme.SurfaceLight,
                    Size = UDim2.new(0, 28, 1, 0),
                    Position = UDim2.new(1, -28, 0, 0),
                    Text = "→",
                    TextColor3 = Theme.Accent,
                    FontFace = Theme.FontBold,
                    TextSize = 14,
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    ZIndex = 3, Parent = BgRow,
                })
                Util.AddCorner(BgApplyBtn, Theme.CornerSmall)
                Util.AddStroke(BgApplyBtn, Theme.Border, 1, 0.4)
                Themed(BgApplyBtn, {
                    BackgroundColor3 = function(t) return t.SurfaceLight end,
                    TextColor3       = function(t) return t.Accent end,
                })

                BgApplyBtn.MouseButton1Click:Connect(function()
                    local id = BgBox.Text ~= "" and BgBox.Text or nil
                    WindowObj:SetBackground(id)
                end)

                -- Clear bg button
                local BgClearBtn = Util.Create("TextButton", {
                    BackgroundColor3 = Theme.SurfaceLight,
                    BackgroundTransparency = 0.4,
                    Size = UDim2.new(1, 0, 0, 24),
                    Text = "Clear Background",
                    TextColor3 = Theme.TextDim,
                    FontFace = Theme.Font,
                    TextSize = 11,
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    ZIndex = 2, Parent = Elements,
                })
                Util.AddCorner(BgClearBtn, Theme.CornerSmall)
                Themed(BgClearBtn, {
                    BackgroundColor3 = function(t) return t.SurfaceLight end,
                    TextColor3       = function(t) return t.TextDim end,
                })
                BgClearBtn.MouseEnter:Connect(function()
                    Util.TweenFast(BgClearBtn, {BackgroundTransparency = 0.1})
                end)
                BgClearBtn.MouseLeave:Connect(function()
                    Util.TweenFast(BgClearBtn, {BackgroundTransparency = 0.4})
                end)
                BgClearBtn.MouseButton1Click:Connect(function()
                    BgBox.Text = ""
                    WindowObj:SetBackground(nil)
                end)
            end

            return SectionObj
        end -- AddSection

        return TabObj
    end -- AddTab

    table.insert(Hyperion.Windows, WindowObj)
    return WindowObj
end -- CreateWindow

----------------------------------------------------------------
-- WATERMARK OVERLAY
----------------------------------------------------------------
--[[
    Hyperion:CreateWatermark({
        Title    = "Hyperion",       -- script name shown on left
        Game     = "The Armory",     -- game name (optional)
        Position = UDim2.new(...),   -- default: top-right
        Keybind  = Enum.KeyCode.X,   -- hide/show keybind (optional)
    })
    Returns a WatermarkAPI with :SetTitle(s), :SetGame(s), :SetVisible(bool), :Destroy()
--]]
function Hyperion:CreateWatermark(cfg)
    cfg = cfg or {}
    local wmTitle   = cfg.Title or "Hyperion"
    local wmGame    = cfg.Game or game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown"
    local wmKeybind = cfg.Keybind or nil
    local Theme     = Hyperion.Theme

    -- Find or create a ScreenGui to host the watermark
    local WmGui = Util.Create("ScreenGui", {
        Name           = "HyperionWatermark",
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 1000,
        IgnoreGuiInset = true,
    })
    pcall(protect_gui, WmGui)
    WmGui.Parent = CoreGui

    local visible = true

    -- Outer pill frame
    local WmFrame = Util.Create("Frame", {
        Name              = "Watermark",
        BackgroundColor3  = Theme.Surface,
        BackgroundTransparency = 0.08,
        AnchorPoint       = Vector2.new(1, 0),
        Position          = cfg.Position or UDim2.new(1, -16, 0, 16),
        Size              = UDim2.new(0, 10, 0, 28), -- auto-expands
        AutomaticSize     = Enum.AutomaticSize.X,
        BorderSizePixel   = 0,
        ZIndex            = 10,
        Parent            = WmGui,
    })
    Util.AddCorner(WmFrame, UDim.new(0, 7))
    local WmStroke = Util.AddStroke(WmFrame, Theme.BorderLight, 1, 0.15)

    -- Subtle top gradient accent
    local WmGrad = Util.Create("Frame", {
        Name             = "Grad",
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.82,
        Size             = UDim2.new(1, 0, 0, 1),
        BorderSizePixel  = 0,
        ZIndex           = 11,
        Parent           = WmFrame,
    })

    -- Layout
    local WmRow = Util.Create("Frame", {
        Name              = "Row",
        BackgroundTransparency = 1,
        Size              = UDim2.new(0, 0, 1, 0),
        AutomaticSize     = Enum.AutomaticSize.X,
        ZIndex            = 11,
        Parent            = WmFrame,
    })
    Util.AddList(WmRow, Enum.FillDirection.Horizontal, 0, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
    Util.AddPadding(WmRow, 0, 10, 0, 10)

    -- Accent dot
    local WmDot = Util.Create("Frame", {
        Name             = "Dot",
        BackgroundColor3 = Theme.Accent,
        Size             = UDim2.new(0, 5, 0, 5),
        LayoutOrder      = 1,
        BorderSizePixel  = 0,
        ZIndex           = 12,
        Parent           = WmRow,
    })
    Util.AddCorner(WmDot, UDim.new(1, 0))

    local fpsColorOverride = nil
    Hyperion:OnThemeChanged(function(t)
        if not WmFrame or not WmFrame.Parent then return end
        WmFrame.BackgroundColor3 = t.Surface
        WmStroke.Color = t.BorderLight
        WmGrad.BackgroundColor3 = t.Accent
        WmDot.BackgroundColor3 = t.Accent
        WmTitleLbl.TextColor3 = t.Text
        WmSep1.TextColor3 = t.TextMuted
        WmGameLbl.TextColor3 = t.TextDim
        local sep2 = WmRow:FindFirstChild("Sep2")
        if sep2 then
            sep2.TextColor3 = t.TextMuted
        end
        if fpsColorOverride then
            WmFpsLbl.TextColor3 = fpsColorOverride
        else
            WmFpsLbl.TextColor3 = t.Accent
        end
    end)

    -- Spacer after dot
    Util.Create("Frame", {
        BackgroundTransparency = 1,
        Size        = UDim2.new(0, 6, 0, 1),
        LayoutOrder = 2,
        Parent      = WmRow,
    })

    -- Title label
    local WmTitleLbl = Util.Create("TextLabel", {
        Name              = "Title",
        BackgroundTransparency = 1,
        Size              = UDim2.new(0, 0, 1, 0),
        AutomaticSize     = Enum.AutomaticSize.X,
        Text              = wmTitle,
        TextColor3        = Theme.Text,
        FontFace          = Theme.FontSemiBold,
        TextSize          = 12,
        TextXAlignment    = Enum.TextXAlignment.Left,
        LayoutOrder       = 3,
        ZIndex            = 12,
        Parent            = WmRow,
    })

    -- Separator " | "
    local WmSep1 = Util.Create("TextLabel", {
        Name              = "Sep1",
        BackgroundTransparency = 1,
        Size              = UDim2.new(0, 0, 1, 0),
        AutomaticSize     = Enum.AutomaticSize.X,
        Text              = "  |  ",
        TextColor3        = Theme.TextMuted,
        FontFace          = Theme.Font,
        TextSize          = 12,
        LayoutOrder       = 4,
        ZIndex            = 12,
        Parent            = WmRow,
    })

    -- Game label
    local WmGameLbl = Util.Create("TextLabel", {
        Name              = "Game",
        BackgroundTransparency = 1,
        Size              = UDim2.new(0, 0, 1, 0),
        AutomaticSize     = Enum.AutomaticSize.X,
        Text              = wmGame,
        TextColor3        = Theme.TextDim,
        FontFace          = Theme.Font,
        TextSize          = 12,
        TextXAlignment    = Enum.TextXAlignment.Left,
        LayoutOrder       = 5,
        ZIndex            = 12,
        Parent            = WmRow,
    })

    -- Separator
    Util.Create("TextLabel", {
        Name              = "Sep2",
        BackgroundTransparency = 1,
        Size              = UDim2.new(0, 0, 1, 0),
        AutomaticSize     = Enum.AutomaticSize.X,
        Text              = "  |  ",
        TextColor3        = Theme.TextMuted,
        FontFace          = Theme.Font,
        TextSize          = 12,
        LayoutOrder       = 6,
        ZIndex            = 12,
        Parent            = WmRow,
    })

    -- FPS label
    local WmFpsLbl = Util.Create("TextLabel", {
        Name              = "FPS",
        BackgroundTransparency = 1,
        Size              = UDim2.new(0, 0, 1, 0),
        AutomaticSize     = Enum.AutomaticSize.X,
        Text              = "-- fps",
        TextColor3        = Theme.Accent,
        FontFace          = Theme.FontMedium,
        TextSize          = 12,
        TextXAlignment    = Enum.TextXAlignment.Left,
        LayoutOrder       = 7,
        ZIndex            = 12,
        Parent            = WmRow,
    })

    -- FPS counter using RunService
    local fpsBuffer = {}
    local fpsConn = RunService.RenderStepped:Connect(function(dt)
        table.insert(fpsBuffer, dt)
        if #fpsBuffer > 15 then table.remove(fpsBuffer, 1) end
        local avg = 0
        for _, v in ipairs(fpsBuffer) do avg = avg + v end
        avg = avg / #fpsBuffer
        local fps = math.round(1 / math.max(avg, 0.001))
        local t = Hyperion.Theme
        local color = fps >= 55 and t.Success or (fps >= 30 and t.Warning or t.Error)
        fpsColorOverride = color
        WmFpsLbl.Text = fps .. " fps"
        WmFpsLbl.TextColor3 = color
    end)
    table.insert(Hyperion.Connections, fpsConn)

    -- Dragging
    local wmDrag, wmDragStart, wmStartPos = false, Vector3.new(), UDim2.new()
    WmFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            wmDrag = true
            wmDragStart = input.Position
            wmStartPos  = WmFrame.Position
        end
    end)
    WmFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            wmDrag = false
        end
    end)
    Util.Connect(UserInputService.InputChanged, function(input)
        if wmDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - wmDragStart
            WmFrame.Position = UDim2.new(
                wmStartPos.X.Scale,
                wmStartPos.X.Offset + delta.X,
                wmStartPos.Y.Scale,
                wmStartPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Optional keybind toggle
    if wmKeybind then
        Util.Connect(UserInputService.InputBegan, function(input, gp)
            if gp then return end
            if input.KeyCode == wmKeybind then
                visible = not visible
                WmFrame.Visible = visible
            end
        end)
    end

    -- Public API
    local WatermarkAPI = {}

    function WatermarkAPI:SetTitle(t)
        WmTitleLbl.Text = t
    end

    function WatermarkAPI:SetGame(t)
        WmGameLbl.Text = t
    end

    function WatermarkAPI:SetVisible(v)
        visible = v
        WmFrame.Visible = v
    end

    function WatermarkAPI:Destroy()
        fpsConn:Disconnect()
        WmGui:Destroy()
    end

    return WatermarkAPI
end

----------------------------------------------------------------

return Hyperion
