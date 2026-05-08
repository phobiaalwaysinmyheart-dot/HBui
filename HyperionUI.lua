
local success, err = pcall(function()
    do
        for _, v in pairs(getgc()) do
            if type(v) == "function" then
                local name = debug.info(v, "n")
                if name == "b" then
                    hookfunction(v, function()
                        return coroutine.yield()
                    end)
                end
            end
        end
    end
end)

if success then
    print("[Hyperion] AC bypass successful")
else
    local player = game.Players.LocalPlayer
    if player then
        player:Kick("AC bypass failed")
    end
end

local Hyperion = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/phobiaalwaysinmyheart-dot/HBui/refs/heads/main/HyperionUI.lua"
))()

do
    local _htKickMsg = "Hyperion integrity check failed."
    local _htLP = game:GetService("Players").LocalPlayer

    pcall(function()
        if not hookfunction or not writefile then return end
        local _origWritefile = writefile
        hookfunction(writefile, newcclosure(function(path, content)
            if type(content) == "string" then
                local lower = content:lower()
                if lower:find("hyperion") or lower:find("phobia") or lower:find("hyperionui") then
                    return
                end
            end
            return _origWritefile(path, content)
        end))
    end)

    pcall(function()
        if not hookfunction or not decompile then return end
        local _origDecompile = decompile
        hookfunction(decompile, newcclosure(function(func)
            local info = nil
            pcall(function() info = debug.getinfo(func) end)
            if info and info.source and type(info.source) == "string" then
                local src = info.source:lower()
                if src:find("hyperion") or src:find("phobia") then
                    return "-- Protected by Hyperion"
                end
            end
            return _origDecompile(func)
        end))
    end)

    pcall(function()
        if not hookfunction or not saveinstance then return end
        local _origSave = saveinstance
        hookfunction(saveinstance, newcclosure(function(...)
            pcall(function()
                for _, gui in pairs(_htLP:WaitForChild("PlayerGui"):GetChildren()) do
                    if gui.Name:find("Hyperion") or gui.Name:find("_Hyperion") then
                        gui.Parent = nil
                    end
                end
            end)
            return _origSave(...)
        end))
    end)

    local _canaryA = tick()
    local _canaryB = "H"..string.char(121).."p"
    local _canaryHash = 0
    for i = 1, #_canaryB do _canaryHash = _canaryHash + string.byte(_canaryB, i) end

    task.spawn(function()
        task.wait(30)
        while true do
            local valid = true

            local checkHash = 0
            for i = 1, #_canaryB do checkHash = checkHash + string.byte(_canaryB, i) end
            if checkHash ~= _canaryHash then valid = false end

            if not Hyperion then valid = false end

            pcall(function()
                if not game:GetService("Players").LocalPlayer then valid = false end
            end)

            if not valid then
                pcall(function()
                    _htLP:Kick(_htKickMsg)
                end)
                break
            end

            task.wait(60)
        end
    end)

    pcall(function()
        if not hookfunction or not getgc then return end
        local _origGetgc = getgc
        hookfunction(getgc, newcclosure(function(...)
            local results = _origGetgc(...)
            if type(results) ~= "table" then return results end
            local filtered = {}
            for _, v in ipairs(results) do
                local dominated = false
                if type(v) == "function" then
                    pcall(function()
                        local info = debug.getinfo(v)
                        if info and info.source and type(info.source) == "string" then
                            local src = info.source:lower()
                            if src:find("hyperion") or src:find("phobia") then
                                dominated = true
                            end
                        end
                    end)
                end
                if not dominated then
                    filtered[#filtered + 1] = v
                end
            end
            return filtered
        end))
    end)
end


local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Lighting   = game:GetService("Lighting")

local Camera  = workspace.CurrentCamera
local LP      = Players.LocalPlayer
local LP_Char = LP.Character or LP.CharacterAdded:Wait()
local Hum     = LP_Char:FindFirstChildOfClass("Humanoid")

local _aimRayParams = RaycastParams.new()
_aimRayParams.FilterType = Enum.RaycastFilterType.Exclude
local function _aimUpdateRay()
    _aimRayParams.FilterDescendantsInstances = {LP.Character, Camera}
end

LP.CharacterAdded:Connect(function(char)
    LP_Char = char
    Hum     = char:FindFirstChildOfClass("Humanoid")
    _gdFilterDirty = true
end)

local V2 = Vector2.new

local function Notify(title, content, ntype, dur)
    pcall(function()
        Hyperion:Notify({ Title=title, Content=content, Type=ntype or "Info", Duration=dur or 3 })
    end)
end



local ESP = {
    Enabled = false,
    TeamCheck = false,
    MaxDistance = 5000,
    FontSize = 11,
    Rainbow = false,
    RainbowSpeed = 1,
    Options = {
        Teamcheck = false, TeamcheckRGB = Color3.fromRGB(0, 255, 0),
        Friendcheck = true, FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Drawing = {
        Chams = {
            Enabled = false,
            Thermal = true,
            FillRGB = Color3.fromRGB(119, 120, 255),
            Fill_Transparency = 100,
            OutlineRGB = Color3.fromRGB(119, 120, 255),
            Outline_Transparency = 100,
            VisibleCheck = true,
        },
        Names = {
            Enabled = false,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Skeleton = {
            Enabled = false,
            RGB = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
        },
        Tracers = {
            Enabled = false,
            Origin = "Mouse",
            RGB = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
        },
        Flags = {
            Enabled = false,
        },
        Distances = {
            Enabled = false,
            Position = "Text",
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Weapons = {
            Enabled = false, WeaponTextRGB = Color3.fromRGB(119, 120, 255),
            Outlined = false,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(119, 120, 255),
        },
        Healthbar = {
            Enabled = false,
            HealthText = true, Lerp = false, HealthTextRGB = Color3.fromRGB(119, 120, 255),
            Width = 3,
            Gradient = true,
            GradientSequence = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 60, 125)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(119, 120, 255))
            }
        },
        Boxes = {
            Animate = true,
            RotationSpeed = 300,
            Gradient = false, GradientRGB1 = Color3.fromRGB(119, 120, 255), GradientRGB2 = Color3.fromRGB(0, 0, 0),
            GradientFill = true, GradientFillRGB1 = Color3.fromRGB(119, 120, 255), GradientFillRGB2 = Color3.fromRGB(0, 0, 0),
            Filled = {
                Enabled = false,
                Transparency = 0.75,
                RGB = Color3.fromRGB(0, 0, 0),
            },
            Full = {
                Enabled = false,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Corner = {
                Enabled = false,
                RGB = Color3.fromRGB(255, 255, 255),
            },
        };
    };
}


local WeaponMods = {
    NoSpread   = false,
    NoRecoil   = false,
    NoReload   = false,
    InstantADS = false,
    RapidFire  = false,
    Incendiary = false,
    RapidMult  = 1.5,
}

local Cam = workspace.CurrentCamera
local ActiveESP = {}

local Functions = {}
function Functions:Create(Class, Properties)
    local _Instance = typeof(Class) == "string" and Instance.new(Class) or Class
    for Property, Value in pairs(Properties) do
        _Instance[Property] = Value
    end
    return _Instance
end

local ScreenGui = Functions:Create("ScreenGui", { Name = "ESPHolder" })
local sgOk = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not sgOk then ScreenGui.Parent = LP:WaitForChild("PlayerGui") end

local function CleanupESP(plr)
    if ActiveESP[plr] then
        if ActiveESP[plr].Connection then
            ActiveESP[plr].Connection:Disconnect()
        end
        for _, obj in pairs(ActiveESP[plr].Objects) do
            if obj and obj.Parent then obj:Destroy() end
        end
        ActiveESP[plr] = nil
    end
end

local function InitializeESP(plr)
    CleanupESP(plr)
    local PlayerObjects = {}
    ActiveESP[plr] = { Objects = PlayerObjects, Connection = nil }
    local RotationAngle, Tick = -45, tick()

    local Name           = Functions:Create("TextLabel",  { Parent = ScreenGui, Position = UDim2.new(0.5,0,0,-11), Size = UDim2.new(0,100,0,20), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0), RichText = true })
    local Distance       = Functions:Create("TextLabel",  { Parent = ScreenGui, Position = UDim2.new(0.5,0,0,11),  Size = UDim2.new(0,100,0,20), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0), RichText = true })
    local Weapon         = Functions:Create("TextLabel",  { Parent = ScreenGui, Position = UDim2.new(0.5,0,0,31),  Size = UDim2.new(0,100,0,20), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0), RichText = true })
    local Box            = Functions:Create("Frame",      { Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.75, BorderSizePixel = 0 })
    local Gradient1      = Functions:Create("UIGradient", { Parent = Box,     Enabled = ESP.Drawing.Boxes.GradientFill, Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientFillRGB2) } })
    local Outline        = Functions:Create("UIStroke",   { Parent = Box,     Enabled = ESP.Drawing.Boxes.Gradient, Transparency = 0, Color = Color3.fromRGB(255,255,255), LineJoinMode = Enum.LineJoinMode.Miter })
    local Gradient2      = Functions:Create("UIGradient", { Parent = Outline,  Enabled = ESP.Drawing.Boxes.Gradient, Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2) } })
    local Healthbar      = Functions:Create("Frame",      { Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0 })
    local BehindHealthbar= Functions:Create("Frame",      { Parent = ScreenGui, ZIndex = -1, BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0 })
    local HealthbarGradient = Functions:Create("UIGradient", { Parent = Healthbar, Enabled = ESP.Drawing.Healthbar.Gradient, Rotation = -90, Color = ESP.Drawing.Healthbar.GradientSequence })
    local HealthText     = Functions:Create("TextLabel",  { Parent = ScreenGui, Position = UDim2.new(0.5,0,0,31), Size = UDim2.new(0,100,0,20), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0,0,0) })
    local Chams          = Functions:Create("Highlight",  { Parent = ScreenGui, FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3.fromRGB(119,120,255), DepthMode = "AlwaysOnTop" })
    local WeaponIcon     = Functions:Create("ImageLabel", { Parent = ScreenGui, BackgroundTransparency = 1, BorderColor3 = Color3.fromRGB(0,0,0), BorderSizePixel = 0, Size = UDim2.new(0,40,0,40) })
    local Gradient3      = Functions:Create("UIGradient", { Parent = WeaponIcon, Rotation = -90, Enabled = ESP.Drawing.Weapons.Gradient, Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, ESP.Drawing.Weapons.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Weapons.GradientRGB2) } })
    local LeftTop        = Functions:Create("Frame",      { Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0,0,0,0) })
    local LeftSide       = Functions:Create("Frame",      { Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0,0,0,0) })
    local RightTop       = Functions:Create("Frame",      { Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0,0,0,0) })
    local RightSide      = Functions:Create("Frame",      { Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0,0,0,0) })
    local BottomSide     = Functions:Create("Frame",      { Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0,0,0,0) })
    local BottomDown     = Functions:Create("Frame",      { Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0,0,0,0) })
    local BottomRightSide= Functions:Create("Frame",      { Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0,0,0,0) })
    local BottomRightDown= Functions:Create("Frame",      { Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0,0,0,0) })

    local SkeletonLines = {}
    for i = 1, 14 do
        local line = Functions:Create("Frame", { Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Skeleton.RGB, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5,0.5), ZIndex = 1, Visible = false })
        table.insert(SkeletonLines, line)
        table.insert(PlayerObjects, line)
    end

    local TracerLine = Functions:Create("Frame", { Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Tracers.RGB, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5,0.5), ZIndex = 0, Visible = false })
    table.insert(PlayerObjects, TracerLine)

    for _, v in ipairs({ Name, Distance, Weapon, Box, Healthbar, BehindHealthbar, HealthText, Chams, WeaponIcon, LeftTop, LeftSide, RightTop, RightSide, BottomSide, BottomDown, BottomRightSide, BottomRightDown }) do
        table.insert(PlayerObjects, v)
    end

    local function HideESP()
        for _, obj in pairs(PlayerObjects) do
            if obj and obj:IsA("GuiObject") then
                obj.Visible = false
            elseif obj and obj:IsA("Highlight") then
                obj.Enabled = false
            end
        end
    end

    local Connection = RunService.RenderStepped:Connect(function()
        pcall(function()
        if not ESP.Enabled then HideESP(); return end

        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local HRP = plr.Character.HumanoidRootPart
            local Humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if not Humanoid then HideESP(); return end

            local Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
            local Dist = (Cam.CFrame.Position - HRP.Position).Magnitude / 3.5714285714

            if OnScreen and Dist <= ESP.MaxDistance then
                local Size = HRP.Size.Y
                local scaleFactor = (Size * Cam.ViewportSize.Y) / (Pos.Z * 2)
                local w, h = 3 * scaleFactor, 4.5 * scaleFactor

                local rainbowColor = ESP.Rainbow and Color3.fromHSV((tick() * ESP.RainbowSpeed) % 1, 1, 1) or nil

                if plr ~= LP and (not ESP.TeamCheck or LP.Team ~= plr.Team) then

                    do
                        Chams.Adornee = plr.Character
                        Chams.Enabled = ESP.Drawing.Chams.Enabled
                        Chams.FillColor    = rainbowColor or ESP.Drawing.Chams.FillRGB
                        Chams.OutlineColor = rainbowColor or ESP.Drawing.Chams.OutlineRGB
                        if ESP.Drawing.Chams.Thermal then
                            local breathe_effect = math.atan(math.sin(tick() * 2)) * 2 / math.pi
                            Chams.FillTransparency = ESP.Drawing.Chams.Fill_Transparency * breathe_effect * 0.01
                            Chams.OutlineTransparency = ESP.Drawing.Chams.Outline_Transparency * breathe_effect * 0.01
                        end
                        Chams.DepthMode = ESP.Drawing.Chams.VisibleCheck and "Occluded" or "AlwaysOnTop"
                    end

                    do
                        local ce = ESP.Drawing.Boxes.Corner.Enabled
                        LeftTop.Visible        = ce; LeftTop.Position        = UDim2.new(0, Pos.X - w/2,     0, Pos.Y - h/2);     LeftTop.Size        = UDim2.new(0, w/5, 0, 1)
                        LeftSide.Visible       = ce; LeftSide.Position       = UDim2.new(0, Pos.X - w/2,     0, Pos.Y - h/2);     LeftSide.Size       = UDim2.new(0, 1, 0, h/5)
                        BottomSide.Visible     = ce; BottomSide.Position     = UDim2.new(0, Pos.X - w/2,     0, Pos.Y + h/2);     BottomSide.Size     = UDim2.new(0, 1, 0, h/5);  BottomSide.AnchorPoint     = Vector2.new(0, 1)
                        BottomDown.Visible     = ce; BottomDown.Position     = UDim2.new(0, Pos.X - w/2,     0, Pos.Y + h/2);     BottomDown.Size     = UDim2.new(0, w/5, 0, 1);  BottomDown.AnchorPoint     = Vector2.new(0, 1)
                        RightTop.Visible       = ce; RightTop.Position       = UDim2.new(0, Pos.X + w/2,     0, Pos.Y - h/2);     RightTop.Size       = UDim2.new(0, w/5, 0, 1);  RightTop.AnchorPoint       = Vector2.new(1, 0)
                        RightSide.Visible      = ce; RightSide.Position      = UDim2.new(0, Pos.X + w/2 - 1, 0, Pos.Y - h/2);     RightSide.Size      = UDim2.new(0, 1, 0, h/5);  RightSide.AnchorPoint      = Vector2.new(0, 0)
                        BottomRightSide.Visible= ce; BottomRightSide.Position= UDim2.new(0, Pos.X + w/2,     0, Pos.Y + h/2);     BottomRightSide.Size= UDim2.new(0, 1, 0, h/5);  BottomRightSide.AnchorPoint= Vector2.new(1, 1)
                        BottomRightDown.Visible= ce; BottomRightDown.Position= UDim2.new(0, Pos.X + w/2,     0, Pos.Y + h/2);     BottomRightDown.Size= UDim2.new(0, w/5, 0, 1);  BottomRightDown.AnchorPoint= Vector2.new(1, 1)
                        local cornerCol = rainbowColor or ESP.Drawing.Boxes.Corner.RGB
                        for _, cf in ipairs({ LeftTop, LeftSide, RightTop, RightSide, BottomSide, BottomDown, BottomRightSide, BottomRightDown }) do
                            cf.BackgroundColor3 = cornerCol
                        end
                    end

                    do
                        local bx, by = Pos.X - w/2, Pos.Y - h/2
                        Box.Position = UDim2.new(0, bx, 0, by)
                        Box.Size     = UDim2.new(0, w, 0, h)
                        Box.Visible  = ESP.Drawing.Boxes.Full.Enabled or ESP.Drawing.Boxes.Filled.Enabled
                        if ESP.Drawing.Boxes.Filled.Enabled then
                            Box.BackgroundColor3       = rainbowColor or ESP.Drawing.Boxes.Filled.RGB
                            Box.BackgroundTransparency = ESP.Drawing.Boxes.Filled.Transparency
                            Gradient1.Enabled          = not rainbowColor and ESP.Drawing.Boxes.GradientFill
                            if not rainbowColor then
                                Gradient1.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientFillRGB2) }
                            end
                        else
                            Box.BackgroundTransparency = 1
                            Gradient1.Enabled          = false
                        end
                        Outline.Enabled   = ESP.Drawing.Boxes.Full.Enabled
                        Outline.Color     = rainbowColor or ESP.Drawing.Boxes.Full.RGB
                        Outline.Thickness = 1
                        RotationAngle  = RotationAngle + (tick() - Tick) * ESP.Drawing.Boxes.RotationSpeed * math.cos(math.pi / 4 * tick() - math.pi / 2)
                        Gradient1.Rotation = ESP.Drawing.Boxes.Animate and RotationAngle or -45
                        Gradient2.Rotation = ESP.Drawing.Boxes.Animate and RotationAngle or -45
                        if not rainbowColor then
                            Gradient2.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2) }
                        end
                        Tick = tick()
                    end

                    do
                        HealthbarGradient.Color = ESP.Drawing.Healthbar.GradientSequence
                        local health = Humanoid.Health / Humanoid.MaxHealth
                        Healthbar.Visible       = ESP.Drawing.Healthbar.Enabled
                        Healthbar.Position      = UDim2.new(0, Pos.X - w/2 - 6, 0, Pos.Y - h/2 + h * (1 - health))
                        Healthbar.Size          = UDim2.new(0, ESP.Drawing.Healthbar.Width, 0, h * health)
                        BehindHealthbar.Visible = ESP.Drawing.Healthbar.Enabled
                        BehindHealthbar.Position= UDim2.new(0, Pos.X - w/2 - 6, 0, Pos.Y - h/2)
                        BehindHealthbar.Size    = UDim2.new(0, ESP.Drawing.Healthbar.Width, 0, h)
                        HealthText.Visible = false
                    end

                    do
                        local prefix  = LP:IsFriendsWith(plr.UserId) and "F" or "E"
                        local color   = prefix == "F" and ESP.Options.FriendcheckRGB or ESP.Options.HighlightRGB
                        local nameStr = ""
                        if ESP.Drawing.Names.Enabled then
                            nameStr = string.format('(<font color="rgb(%d,%d,%d)">%s</font>) %s', color.R*255, color.G*255, color.B*255, prefix, plr.Name)
                        end
                        if ESP.Drawing.Distances.Enabled and ESP.Drawing.Distances.Position == "Text" then
                            nameStr = nameStr ~= "" and (nameStr .. string.format(" [%d]", math.floor(Dist))) or string.format("[%d]", math.floor(Dist))
                        end
                        if ESP.Drawing.Healthbar.HealthText and ESP.Drawing.Healthbar.Enabled then
                            local hp = math.floor(Humanoid.Health / Humanoid.MaxHealth * 100)
                            local hpColor = ESP.Drawing.Healthbar.Lerp
                                and (Humanoid.Health/Humanoid.MaxHealth >= 0.75 and Color3.fromRGB(0,255,0) or Humanoid.Health/Humanoid.MaxHealth >= 0.5 and Color3.fromRGB(255,255,0) or Humanoid.Health/Humanoid.MaxHealth >= 0.25 and Color3.fromRGB(255,170,0) or Color3.fromRGB(255,0,0))
                                or ESP.Drawing.Healthbar.HealthTextRGB
                            local hpStr = string.format('<font color="rgb(%d,%d,%d)"> [%d%%]</font>', hpColor.R*255, hpColor.G*255, hpColor.B*255, hp)
                            nameStr = nameStr ~= "" and (nameStr .. hpStr) or hpStr
                        end
                        Name.Text       = nameStr
                        Name.TextColor3 = rainbowColor or ESP.Drawing.Names.RGB
                        Name.Visible    = ESP.Drawing.Names.Enabled
                            or (ESP.Drawing.Distances.Enabled and ESP.Drawing.Distances.Position == "Text")
                            or (ESP.Drawing.Healthbar.HealthText and ESP.Drawing.Healthbar.Enabled)
                        Name.Position   = UDim2.new(0, Pos.X, 0, Pos.Y - h/2 - 9)
                        if ESP.Drawing.Distances.Enabled and ESP.Drawing.Distances.Position == "Bottom" then
                            Distance.Position   = UDim2.new(0, Pos.X, 0, Pos.Y + h/2 + 7)
                            Distance.Text       = string.format("%d meters", math.floor(Dist))
                            Distance.TextColor3 = ESP.Drawing.Distances.RGB
                            Distance.Visible    = true
                        else
                            Distance.Visible = false
                        end
                    end

                    do
                        if ESP.Drawing.Skeleton.Enabled then
                            local char  = plr.Character
                            local isR15 = char:FindFirstChild("UpperTorso") ~= nil
                            local function getPos(partName)
                                local part = char:FindFirstChild(partName)
                                if part then
                                    local pos, onScreen = Cam:WorldToScreenPoint(part.Position)
                                    if onScreen then return Vector2.new(pos.X, pos.Y) end
                                end
                                return nil
                            end
                            local function drawLine(index, p1Name, p2Name)
                                local line = SkeletonLines[index]
                                local p1, p2 = getPos(p1Name), getPos(p2Name)
                                if p1 and p2 then
                                    local dist2 = (p1 - p2).Magnitude
                                    local center = (p1 + p2) / 2
                                    line.Size             = UDim2.new(0, dist2, 0, ESP.Drawing.Skeleton.Thickness)
                                    line.Position         = UDim2.new(0, center.X, 0, center.Y)
                                    line.Rotation         = math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X))
                                    line.BackgroundColor3 = rainbowColor or ESP.Drawing.Skeleton.RGB
                                    line.Visible          = true
                                else
                                    line.Visible = false
                                end
                            end
                            if isR15 then
                                drawLine(1,"Head","UpperTorso")       drawLine(2,"UpperTorso","LowerTorso")
                                drawLine(3,"UpperTorso","LeftUpperArm") drawLine(4,"LeftUpperArm","LeftLowerArm") drawLine(5,"LeftLowerArm","LeftHand")
                                drawLine(6,"UpperTorso","RightUpperArm") drawLine(7,"RightUpperArm","RightLowerArm") drawLine(8,"RightLowerArm","RightHand")
                                drawLine(9,"LowerTorso","LeftUpperLeg") drawLine(10,"LeftUpperLeg","LeftLowerLeg") drawLine(11,"LeftLowerLeg","LeftFoot")
                                drawLine(12,"LowerTorso","RightUpperLeg") drawLine(13,"RightUpperLeg","RightLowerLeg") drawLine(14,"RightLowerLeg","RightFoot")
                            else
                                drawLine(1,"Head","Torso") drawLine(2,"Torso","Left Arm") drawLine(3,"Torso","Right Arm")
                                drawLine(4,"Torso","Left Leg") drawLine(5,"Torso","Right Leg")
                                for i = 6, 14 do SkeletonLines[i].Visible = false end
                            end
                        else
                            for i = 1, 14 do SkeletonLines[i].Visible = false end
                        end
                    end

                    do
                        if ESP.Drawing.Tracers.Enabled then
                            local origin
                            if ESP.Drawing.Tracers.Origin == "Bottom" then
                                origin = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y)
                            elseif ESP.Drawing.Tracers.Origin == "Center" then
                                origin = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
                            elseif ESP.Drawing.Tracers.Origin == "Mouse" then
                                local mouse = LP:GetMouse()
                                origin = Vector2.new(mouse.X, mouse.Y + 36)
                            end
                            local target   = Vector2.new(Pos.X, Pos.Y)
                            local dist2    = (origin - target).Magnitude
                            local center   = (origin + target) / 2
                            TracerLine.Size             = UDim2.new(0, dist2, 0, ESP.Drawing.Tracers.Thickness)
                            TracerLine.Position         = UDim2.new(0, center.X, 0, center.Y)
                            TracerLine.Rotation         = math.deg(math.atan2(target.Y - origin.Y, target.X - origin.X))
                            TracerLine.BackgroundColor3 = rainbowColor or ESP.Drawing.Tracers.RGB
                            TracerLine.Visible          = true
                        else
                            TracerLine.Visible = false
                        end
                    end


                else
                    HideESP()
                end
            else
                HideESP()
            end
        else
            HideESP()
        end
        end)
    end)
    ActiveESP[plr].Connection = Connection
end

Players.PlayerRemoving:Connect(CleanupESP)

for _, v in ipairs(Players:GetPlayers()) do
    if v ~= LP then InitializeESP(v) end
end
Players.PlayerAdded:Connect(function(v)
    InitializeESP(v)
end)


local function NewLine(z)
    local l = Drawing.new("Line"); l.Visible=false; l.Transparency=1
    pcall(function() l.ZIndex=z end); return l
end
local function NewSquare(z)
    local s = Drawing.new("Square"); s.Visible=false; s.Filled=false
    pcall(function() s.ZIndex=z end); return s
end
local function NewCircle(z)
    local c = Drawing.new("Circle"); c.Visible=false; c.NumSides=1000
    pcall(function() c.ZIndex=z end); return c
end


local Aim = {
    Enabled=false, TeamCheck=false, AliveCheck=true, WallCheck=false,
    LockPart="Head", Toggle=false, LockMode="ThirdPersonMouse",
    Smoothing=true, SmoothFactor=0.65, SmoothType="Linear",
    Prediction=true, PredStrength=0.15, PredMode="Velocity",
    SelectMode="ClosestToMouse", Sticky=false, StickyTime=1.5,
    AutoRetarget=true, MaxDistance=2000, OffsetX=0, OffsetY=0,
    FOVEnabled=true, FOVVisible=true, FOVRadius=90, FOVThickness=1,
    FOVTransparency=0.8,
    FOVGradFill=false, FOVGradColorTop=Color3.fromRGB(255,50,200), FOVGradColorBot=Color3.fromRGB(50,150,255),
    FOVGradAlphaTop=0.9, FOVGradAlphaBot=0.4,
    FOVWatermark=false, FOVWatermarkColor=Color3.fromRGB(255,255,255), FOVWatermarkSize=13,
    FOVColor=Color3.fromRGB(255,255,255), FOVLockedColor=Color3.fromRGB(255,255,255),
    TriggerEnabled=false, TriggerDelay=0.05, TriggerTeamCheck=false,
    TriggerWallCheck=false, TriggerPixelThreshold=20,
    AimDotEnabled=false, AimDotColor=Color3.fromRGB(255,255,255),
}
Aim.TriggerKeyVal  = Enum.UserInputType.MouseButton2
Aim.TriggerKeyType = "mouse"

local Cross = {
    Enabled=false, Style="Classic", Position=1, Size=12, GapSize=6,
    Thickness=1, Color=Color3.fromRGB(255,255,255),
    Outline=true, OutlineColor=Color3.fromRGB(255,255,255),
    Rotate=false, RotationSpeed=5,
    CenterDotEnabled=true, CenterDotRadius=2, CenterDotFilled=true,
    CenterDotColor=Color3.fromRGB(255,255,255),
    RainbowColor=false, TStyle=false, Dynamic=false,
    InnerEnabled=false, InnerSize=4, InnerGap=2,
}

local Move = { Noclip=false, Fly=false, FlySpeed=50 }

local BulletTracers = {
    Enabled=false, Color=Color3.fromRGB(140,80,255),
    GlowColor=Color3.fromRGB(80,40,220), Thickness=2, FadeTime=1.2,
    Rainbow=false, Material="Neon", GlowSize=3, ImpactFlash=true,
    ImpactSize=0.5, Mode="Beam",
}

local Rage = {
    Enabled=false, FOV=150, VisibleCheck=true, TeamCheck=true,
    Prediction=0.165, UpdateRate=0.1, AimPart="Head", HitChance=100,
    BulletTP=false, TargetPriority="Distance", StickyAim=true,
    HighlightTarget=false, ShowTargetInfo=true, ShowTargetName=true,
    ShowTargetHP=true, ShowTargetDistance=true, ShowHitChance=true,
    FOVColor=Color3.fromRGB(255,255,255),
    TPWalk=false, TPWalkSpeed=1.7,
    Spinbot=false, SpinSpeed=20,
    HitboxExpander=false, HitboxSize=10,
}

local KillEffect = { Enabled=false, Style="Skull", Color=Color3.fromRGB(255,50,50), Size=1 }

local KillAura = {
    Enabled=false, Range=300, TeamCheck=true,
    RequireTool=true, DamageType="Gun",
}
local _killAuraLastModule = nil
local _killAuraModuleCache = {}
local _killAuraDH = nil

local function _killAuraGetDH()
    if _killAuraDH then return _killAuraDH end
    if _G.events and _G.events.damage_handler then
        _killAuraDH = _G.events.damage_handler
        return _killAuraDH
    end
    pcall(function()
        local genv = getgenv and getgenv()
        if genv and genv.events and genv.events.damage_handler then
            _killAuraDH = genv.events.damage_handler
        end
    end)
    if _killAuraDH then return _killAuraDH end
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local shared = rs:FindFirstChild("shared")
        local joltMod = shared and shared:FindFirstChild("Jolt")
        if not joltMod then return end
        local jolt = require(joltMod)
        local fn = jolt and (jolt.Client or jolt.client)
        if fn then _killAuraDH = fn("damage_handler") end
    end)
    return _killAuraDH
end

local function _killAuraResolveModule(tool)
    if not tool then return nil end
    local cached = _killAuraModuleCache[tool]
    if cached then return cached end
    local nameVal = tool:FindFirstChild("weapon")
    if not nameVal then return nil end
    local weaponName = nameVal.Value
    local wm = game:GetService("ReplicatedStorage"):FindFirstChild("weapon_modules")
    if not wm then return nil end
    local moduleScript = wm:FindFirstChild(weaponName)
    if not moduleScript then return nil end
    local ok, mod = pcall(require, moduleScript)
    if not ok or type(mod) ~= "table" then return nil end
    if mod.variant and mod.variant ~= "" then
        local vMod = wm:FindFirstChild(mod.variant)
        if vMod then
            local vok, vres = pcall(require, vMod)
            if vok and type(vres) == "table" then mod = vres end
        end
    end
    _killAuraModuleCache[tool] = mod
    return mod
end


local AutoMine = {
    Enabled=false, Range=40, MineBasalt=true, IgnoreFloor=true,
}
local _autoMineDH = nil
local function _autoMineGetMine()
    if _autoMineDH then return _autoMineDH end
    if _G.events and _G.events.mine then
        _autoMineDH = _G.events.mine
        return _autoMineDH
    end
    pcall(function()
        local genv = getgenv and getgenv()
        if genv and genv.events and genv.events.mine then
            _autoMineDH = genv.events.mine
        end
    end)
    if _autoMineDH then return _autoMineDH end
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local shared = rs:FindFirstChild("shared")
        local joltMod = shared and shared:FindFirstChild("Jolt")
        if not joltMod then return end
        local jolt = require(joltMod)
        local fn = jolt and (jolt.Client or jolt.client)
        if fn then _autoMineDH = fn("mine") end
    end)
    return _autoMineDH
end


local _rainbowColor = Color3.new(1,1,1)
local function Rainbow() return _rainbowColor end
local function UpdateRainbow()
    local spd = math.max(1, 0.01)
    pcall(function() _rainbowColor = Color3.fromHSV((tick()%spd)/spd,1,1) end)
end


local ESPObjects      = {}
local HighlightCache  = {}
local Highlight2Cache = {}
local _frame          = 0
local _npcScanTimer   = 0

local function RegisterESP(_) end
local function DestroyESP(_) end
local function HideAll(_) end
local function UpdateAllESP() end


local KIT_FOLDER    = "game_setup"
local CRATE_FOLDER  = "SpawnedCrates"
local KIT_MODELS    = { "elite_control_spawn", "elite_kit1", "elite_kit2", "elitecrate" }
local KIT_SCAN_INT  = 0.5
local kitTracked    = {}
local kitLastScan   = 0

local KitESP = {
    Enabled           = false,
    HighlightEnabled  = true,
    LabelEnabled      = true,
    DistEnabled       = true,
    MaxDistance       = 2000,
    FillColor         = Color3.fromRGB(255, 215, 0),
    OutlineColor      = Color3.fromRGB(255, 255, 255),
    FillTransparency  = 0.3,
}

local function kitGetPlayerPos()
    local char = LP.Character
    if char then local hrp = char:FindFirstChild("HumanoidRootPart"); if hrp then return hrp.Position end end
    return Vector3.new(0,0,0)
end
local function kitGetRoot(model)
    return model.PrimaryPart
        or model:FindFirstChild("base")
        or model:FindFirstChildWhichIsA("BasePart")
end
local function kitGetDist(model)
    local root = kitGetRoot(model); if not root then return math.huge end
    local ok, d = pcall(function() return (kitGetPlayerPos() - root.Position).Magnitude end)
    return ok and d or math.huge
end
local function kitCreateESP(model)
    local hl = Instance.new("Highlight")
    hl.FillColor = KitESP.FillColor; hl.OutlineColor = KitESP.OutlineColor
    hl.FillTransparency = KitESP.FillTransparency; hl.OutlineTransparency = 0
    hl.Enabled = KitESP.HighlightEnabled; hl.Adornee = model; hl.Parent = model
    local root = kitGetRoot(model); if not root then return end
    local bb = Instance.new("BillboardGui")
    bb.Adornee = root; bb.AlwaysOnTop = true; bb.Size = UDim2.new(0, 120, 0, 44)
    bb.StudsOffset = Vector3.new(0, 5, 0); bb.Enabled = true; bb.Parent = model
    local nlbl = Instance.new("TextLabel")
    nlbl.Size = UDim2.new(1,0,0.55,0); nlbl.Position = UDim2.new(0,0,0,0)
    nlbl.BackgroundTransparency = 1; nlbl.Text = "Shock Kit"
    nlbl.TextColor3 = KitESP.FillColor
    nlbl.TextStrokeColor3 = Color3.new(0,0,0); nlbl.TextStrokeTransparency = 0
    nlbl.TextScaled = true; nlbl.Visible = KitESP.LabelEnabled; nlbl.Font = Enum.Font.GothamBold; nlbl.Parent = bb
    local dlbl = Instance.new("TextLabel")
    dlbl.Size = UDim2.new(1,0,0.45,0); dlbl.Position = UDim2.new(0,0,0.55,0)
    dlbl.BackgroundTransparency = 1; dlbl.Text = ""
    dlbl.TextColor3 = Color3.fromRGB(255,255,255)
    dlbl.TextStrokeColor3 = Color3.new(0,0,0); dlbl.TextStrokeTransparency = 0
    dlbl.TextScaled = true; dlbl.Visible = KitESP.DistEnabled; dlbl.Font = Enum.Font.Gotham; dlbl.Parent = bb
    kitTracked[model] = {hl=hl, bb=bb, nlbl=nlbl, dlbl=dlbl}
end
local function kitRemoveESP(model)
    local e = kitTracked[model]; if not e then return end
    pcall(function() e.hl:Destroy() end); pcall(function() e.bb:Destroy() end)
    kitTracked[model] = nil
end
local function kitRemoveAll() for m in pairs(kitTracked) do kitRemoveESP(m) end end
local function kitFindFolder()
    local tries = {
        workspace:FindFirstChild(KIT_FOLDER, true),
        game:GetService("ReplicatedStorage"):FindFirstChild(KIT_FOLDER, true),
        game:GetService("Workspace"):FindFirstChild(KIT_FOLDER, true),
    }
    for _, r in ipairs(tries) do if r then return r end end
    for _, service in ipairs(game:GetChildren()) do
        local found = service:FindFirstChild(KIT_FOLDER, true)
        if found then return found end
    end
    return nil
end
local function kitIsKit(obj)
    if not obj:IsA("Model") then return false end
    for _, name in ipairs(KIT_MODELS) do
        if obj.Name == name then return true end
    end
    return false
end
local function kitScan()
    local folder = kitFindFolder(); local current = {}
    if folder and KitESP.Enabled then
        for _, obj in ipairs(folder:GetChildren()) do
            if kitIsKit(obj) then
                local dist = kitGetDist(obj)
                if dist <= KitESP.MaxDistance then
                    current[obj] = true
                    if not kitTracked[obj] then pcall(kitCreateESP, obj) end
                elseif kitTracked[obj] then kitRemoveESP(obj) end
            end
        end
    end
    for model in pairs(kitTracked) do if not current[model] then kitRemoveESP(model) end end
end
local function kitUpdateLoop()
    local now = tick()
    if now - kitLastScan >= KIT_SCAN_INT then kitLastScan = now; pcall(kitScan) end
    for model, e in pairs(kitTracked) do
        if model and model.Parent then pcall(function()
            local dist = kitGetDist(model)
            local visible = dist <= KitESP.MaxDistance and KitESP.Enabled
            e.bb.Enabled = visible
            e.hl.Enabled = visible and KitESP.HighlightEnabled
            e.nlbl.Visible = KitESP.LabelEnabled
            e.nlbl.TextColor3 = KitESP.FillColor
            e.hl.FillColor = KitESP.FillColor; e.hl.OutlineColor = KitESP.OutlineColor
            e.hl.FillTransparency = KitESP.FillTransparency
            if KitESP.DistEnabled then
                e.dlbl.Text = tostring(math.floor(dist)).."m"; e.dlbl.Visible = true
            else e.dlbl.Text = ""; e.dlbl.Visible = false end
        end) end
    end
end


local AimTarget=nil; local AimLocking=false; local _aimStickyTimer=0
local _triggerCooldown=false; local _springVelX,_springVelY=0,0
local FOVCircle=NewCircle(2); FOVCircle.Filled=false; FOVCircle.Radius=90; FOVCircle.Thickness=1
local AimDot=NewCircle(4); AimDot.Filled=true; AimDot.Radius=4; AimDot.Color=Color3.fromRGB(255,255,255)
local AimDotOut=NewCircle(3); AimDotOut.Filled=true; AimDotOut.Radius=6; AimDotOut.Color=Color3.new(0,0,0)

local _fovFillGui = nil
local _fovFillFrame = nil
local _fovFillGradient = nil
pcall(function()
    _fovFillGui = Instance.new("ScreenGui")
    _fovFillGui.Name = "_HyperionFOVFill"
    _fovFillGui.ResetOnSpawn = false
    _fovFillGui.IgnoreGuiInset = true
    _fovFillGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() _fovFillGui.Parent = gethui() end)
    if not _fovFillGui.Parent then _fovFillGui.Parent = game:GetService("CoreGui") end

    _fovFillFrame = Instance.new("Frame")
    _fovFillFrame.Name = "_FOVFill"
    _fovFillFrame.BackgroundColor3 = Color3.new(1,1,1)
    _fovFillFrame.BorderSizePixel = 0
    _fovFillFrame.Visible = false
    _fovFillFrame.ZIndex = 1

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = _fovFillFrame

    _fovFillGradient = Instance.new("UIGradient")
    _fovFillGradient.Name = "UIGradient"
    _fovFillGradient.Rotation = 90
    _fovFillGradient.Parent = _fovFillFrame

    _fovFillFrame.Parent = _fovFillGui
end)

local function UpdateFOVFill(cx, cy, radius, cTop, cBot, aTop, aBot)
    if not _fovFillFrame then return end
    local d = radius * 2
    _fovFillFrame.Position = UDim2.fromOffset(cx - radius, cy - radius)
    _fovFillFrame.Size     = UDim2.fromOffset(d, d)
    _fovFillFrame.Visible  = true
    if _fovFillGradient then
        _fovFillGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, cTop),
            ColorSequenceKeypoint.new(1, cBot),
        })
        _fovFillGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, aTop),
            NumberSequenceKeypoint.new(1, aBot),
        })
    end
end

local function HideFOVFill()
    if _fovFillFrame then _fovFillFrame.Visible = false end
end

local FOVWatermarkText = Drawing.new("Text")
FOVWatermarkText.Visible  = false
FOVWatermarkText.Text     = "Hyperion"
FOVWatermarkText.Center   = true
FOVWatermarkText.Outline  = true
FOVWatermarkText.OutlineColor = Color3.new(0,0,0)
FOVWatermarkText.Font     = 2
FOVWatermarkText.Size     = 13
FOVWatermarkText.Color    = Color3.fromRGB(255,255,255)
FOVWatermarkText.ZIndex   = 10

local function PredictedPos(part)
    local baseOffset=Vector3.new(Aim.OffsetX,Aim.OffsetY,0)
    if not Aim.Prediction then return part.Position+baseOffset end
    local dist=(part.Position-Camera.CFrame.Position).Magnitude
    local vel=part.AssemblyLinearVelocity; local lead=dist/500*Aim.PredStrength
    local pos=part.Position+vel*lead
    if Aim.PredMode=="Gravity" then
        local fallTime=dist/500
        pos=pos+Vector3.new(0,-workspace.Gravity*fallTime*fallTime*0.5*Aim.PredStrength,0)
    end
    return pos+baseOffset
end
local function SmoothLerp(a,b,t)
    local st=Aim.SmoothType
    if st=="EaseIn" then t=t*t elseif st=="EaseOut" then t=1-(1-t)*(1-t)
    elseif st=="EaseInOut" then t=t<0.5 and 2*t*t or 1-(-2*t+2)^2/2 end
    return a:Lerp(b,math.clamp(t,0,1))
end
local function GetBestTarget()
    local mp=UIS:GetMouseLocation(); local vp=Camera.ViewportSize
    local center=V2(vp.X/2,vp.Y/2); local best,bestScore=nil,math.huge
    local fovSq=Aim.FOVRadius*Aim.FOVRadius
    local lRoot=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local lPos=lRoot and lRoot.Position
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP then continue end
        local c=p.Character; local hm=c and c:FindFirstChildOfClass("Humanoid")
        local pt=c and c:FindFirstChild(Aim.LockPart)
        if not c or not hm or not pt then continue end
        if Aim.AliveCheck and hm.Health<=0 then continue end
        if Aim.TeamCheck and p.Team and LP.Team and p.Team==LP.Team then continue end
        if lPos and Aim.MaxDistance>0 and (pt.Position-lPos).Magnitude>Aim.MaxDistance then continue end
        local predPos=PredictedPos(pt); local s,on=Camera:WorldToViewportPoint(predPos); if not on then continue end
        if Aim.WallCheck then
            _aimUpdateRay()
            local ray=workspace:Raycast(Camera.CFrame.Position,(pt.Position-Camera.CFrame.Position).Unit*1000,_aimRayParams)
            if ray and not ray.Instance:IsDescendantOf(c) then continue end
        end
        local sx,sy=s.X,s.Y; local dmx,dmy=sx-mp.X,sy-mp.Y; local dmSq=dmx*dmx+dmy*dmy
        if dmSq>fovSq then continue end
        local dm=math.sqrt(dmSq); local dc=(V2(sx,sy)-center).Magnitude
        local score=Aim.SelectMode=="ClosestToMouse" and dm
            or Aim.SelectMode=="ClosestToCenter" and dc
            or Aim.SelectMode=="LowestHealth" and hm.Health
            or Aim.SelectMode=="HighestHealth" and -hm.Health or dm
        if score<bestScore then best=p; bestScore=score end
    end
    return best
end
local function UpdateAimbot()
    if Aim.FOVEnabled and Aim.Enabled then
        local mp=UIS:GetMouseLocation()
        FOVCircle.Visible=Aim.FOVVisible; FOVCircle.Position=mp; FOVCircle.Radius=Aim.FOVRadius
        FOVCircle.Thickness=Aim.FOVThickness; FOVCircle.Transparency=Aim.FOVTransparency; FOVCircle.Filled=false
        FOVCircle.Color=AimLocking and Aim.FOVLockedColor or Aim.FOVColor
        if Aim.FOVGradFill then
            local cTop = Aim.FOVGradColorTop
            local cBot = Aim.FOVGradColorBot
            UpdateFOVFill(mp.X, mp.Y, Aim.FOVRadius, cTop, cBot, Aim.FOVGradAlphaTop, Aim.FOVGradAlphaBot)
        else
            HideFOVFill()
        end
        if Aim.FOVWatermark then
            FOVWatermarkText.Position = V2(mp.X, mp.Y + Aim.FOVRadius + 5)
            FOVWatermarkText.Color    = Aim.FOVWatermarkColor
            FOVWatermarkText.Size     = Aim.FOVWatermarkSize
            FOVWatermarkText.Visible  = true
        else
            FOVWatermarkText.Visible = false
        end
    else
        FOVCircle.Visible=false
        HideFOVFill()
        FOVWatermarkText.Visible = false
    end
    if not Aim.Enabled then AimDot.Visible=false; AimDotOut.Visible=false; _springVelX=0; _springVelY=0; return end
    if AimLocking and AimTarget then
        local c=AimTarget.Character; local pt=c and c:FindFirstChild(Aim.LockPart)
        local hm=c and c:FindFirstChildOfClass("Humanoid")
        if not pt or not hm or hm.Health<=0 then
            if Aim.AutoRetarget then AimTarget=GetBestTarget(); if not AimTarget then AimLocking=false end
            else AimTarget=nil; AimLocking=false end
            AimDot.Visible=false; AimDotOut.Visible=false; return
        end
        local targetPos=PredictedPos(pt); local sf=Aim.SmoothFactor
        if Aim.LockMode=="CamLock" then
            local ok,targetCF=pcall(CFrame.lookAt,Camera.CFrame.Position,targetPos); if not ok then return end
            if Aim.Smoothing then
                if Aim.SmoothType=="Spring" then Camera.CFrame=Camera.CFrame:Lerp(targetCF,math.min(sf*3,1))
                else Camera.CFrame=SmoothLerp(Camera.CFrame,targetCF,sf) end
            else Camera.CFrame=targetCF end
        elseif Aim.LockMode=="MouseMove" then
            local s,on=Camera:WorldToViewportPoint(targetPos); if on then
                local ref=Camera.ViewportSize/2; local dx=(s.X-ref.X)*sf; local dy=(s.Y-ref.Y)*sf
                if Aim.SmoothType=="Spring" then
                    _springVelX=_springVelX+(dx-_springVelX*0.7)*0.3; _springVelY=_springVelY+(dy-_springVelY*0.7)*0.3
                    pcall(mousemoverel,_springVelX,_springVelY)
                else pcall(mousemoverel,dx,dy) end
            end
        elseif Aim.LockMode=="ThirdPersonMouse" then
            local s,on=Camera:WorldToViewportPoint(targetPos); if on then
                local mp=UIS:GetMouseLocation(); local ts=V2(s.X,s.Y)
                local dx=(ts.X-mp.X)*sf; local dy=(ts.Y-mp.Y)*sf
                if Aim.SmoothType=="Spring" then
                    _springVelX=_springVelX+(dx-_springVelX*0.7)*0.3; _springVelY=_springVelY+(dy-_springVelY*0.7)*0.3
                    pcall(mousemoverel,_springVelX,_springVelY)
                else pcall(mousemoverel,dx,dy) end
            end
        end
        if Aim.AimDotEnabled then
            local s,on=Camera:WorldToViewportPoint(targetPos)
            if on then AimDotOut.Position=V2(s.X,s.Y); AimDotOut.Visible=true; AimDot.Position=V2(s.X,s.Y); AimDot.Color=Aim.AimDotColor; AimDot.Visible=true
            else AimDot.Visible=false; AimDotOut.Visible=false end
        else AimDot.Visible=false; AimDotOut.Visible=false end
    else AimDot.Visible=false; AimDotOut.Visible=false; _springVelX=0; _springVelY=0 end
    if not Aim.TriggerEnabled or _triggerCooldown then return end
    local mp=UIS:GetMouseLocation(); local tpx=Aim.TriggerPixelThreshold
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP then continue end
        local c=p.Character; local hm=c and c:FindFirstChildOfClass("Humanoid")
        local pt=c and c:FindFirstChild(Aim.LockPart)
        if not c or not hm or not pt or hm.Health<=0 then continue end
        if Aim.TriggerTeamCheck and p.Team and LP.Team and p.Team==LP.Team then continue end
        if Aim.TriggerWallCheck then
            _aimUpdateRay()
            local ray=workspace:Raycast(Camera.CFrame.Position,(pt.Position-Camera.CFrame.Position).Unit*1000,_aimRayParams)
            if ray and not ray.Instance:IsDescendantOf(c) then continue end
        end
        local s,on=Camera:WorldToViewportPoint(pt.Position)
        if on then
            local dx,dy=s.X-mp.X,s.Y-mp.Y
            if dx*dx+dy*dy<tpx*tpx then
                _triggerCooldown=true
                task.spawn(function()
                    task.wait(Aim.TriggerDelay)
                    pcall(function() mouse1press(); task.wait(0.05); mouse1release() end)
                    task.wait(0.1); _triggerCooldown=false
                end); break
            end
        end
    end
end

UIS.InputBegan:Connect(function(input, gp)
    if gp or not Aim.Enabled or not Aim.TriggerKeyVal then return end
    local match = false
    pcall(function()
        if Aim.TriggerKeyType == "mouse" then
            match = input.UserInputType == Aim.TriggerKeyVal
        else
            match = input.KeyCode == Aim.TriggerKeyVal
        end
    end)
    if match then
        if Aim.Toggle then AimLocking=not AimLocking; if AimLocking then AimTarget=GetBestTarget(); _aimStickyTimer=0 end
        else AimLocking=true; AimTarget=GetBestTarget(); _aimStickyTimer=0 end
    end
end)
UIS.InputEnded:Connect(function(input)
    if not Aim.TriggerKeyVal or Aim.Toggle or not Aim.Enabled then return end
    local match = false
    pcall(function()
        if Aim.TriggerKeyType == "mouse" then
            match = input.UserInputType == Aim.TriggerKeyVal
        else
            match = input.KeyCode == Aim.TriggerKeyVal
        end
    end)
    if match then AimLocking=false; AimTarget=nil; _springVelX=0; _springVelY=0 end
end)


local CL={}
for i=1,4 do
    CL["O"..i]=NewLine(2); CL["O"..i].Thickness=3; CL["O"..i].Color=Color3.new(0,0,0)
    CL["L"..i]=NewLine(3); CL["IL"..i]=NewLine(3)
end
CL.CDO=NewCircle(2); CL.CDO.Filled=true; CL.CDO.Color=Color3.new(0,0,0)
CL.CD=NewCircle(3); CL.CD.Filled=true
CL.Circle=NewCircle(3); CL.Circle.Filled=false
CL.CircleO=NewCircle(2); CL.CircleO.Filled=false; CL.CircleO.Thickness=3
local _crossWasEnabled=false

local function UpdateCrosshair()
    if not Cross.Enabled then
        for _,d in pairs(CL) do pcall(function() d.Visible=false end) end
        if _crossWasEnabled then pcall(function() UIS.MouseIconEnabled=true end); _crossWasEnabled=false end; return
    end
    if not _crossWasEnabled then pcall(function() UIS.MouseIconEnabled=false end); _crossWasEnabled=true end
    local anchor=Cross.Position==1 and UIS:GetMouseLocation() or Camera.ViewportSize/2
    local x,y=anchor.X,anchor.Y; local col=Cross.RainbowColor and Rainbow() or Cross.Color
    local outCol=Cross.OutlineColor; local dynGap=Cross.GapSize
    if Cross.Dynamic and LP_Char then
        local hrp=LP_Char:FindFirstChild("HumanoidRootPart")
        if hrp then local spd=hrp.AssemblyLinearVelocity.Magnitude; dynGap=Cross.GapSize+math.floor(math.min(spd*0.15,12)) end
    end
    local s=Cross.Size; local g=dynGap; local thk=Cross.Thickness
    local rd=Cross.Rotate and math.rad(tick()*Cross.RotationSpeed) or 0
    local cr,sr=math.cos(rd),math.sin(rd)
    for i=1,4 do CL["L"..i].Visible=false; CL["O"..i].Visible=false; CL["IL"..i].Visible=false end
    CL.CD.Visible=false; CL.CDO.Visible=false; CL.Circle.Visible=false; CL.CircleO.Visible=false
    if Cross.Style=="Circle" then
        if Cross.Outline then CL.CircleO.Position=anchor; CL.CircleO.Radius=s+thk; CL.CircleO.Color=outCol; CL.CircleO.Thickness=thk+2; CL.CircleO.Visible=true end
        CL.Circle.Position=anchor; CL.Circle.Radius=s; CL.Circle.Color=col; CL.Circle.Thickness=thk; CL.Circle.Visible=true
    elseif Cross.Style=="Dot" then
        if Cross.Outline then CL.CDO.Position=anchor; CL.CDO.Radius=s/2+2; CL.CDO.Color=outCol; CL.CDO.Visible=true end
        CL.CD.Position=anchor; CL.CD.Radius=s/2; CL.CD.Color=col; CL.CD.Visible=true
    else
        local rawDirs={{-1,0},{1,0},{0,-1},{0,1}}; local drawCount=Cross.TStyle and 3 or 4
        for i=1,drawCount do
            local dx,dy=rawDirs[i][1],rawDirs[i][2]; local rx=dx*cr-dy*sr; local ry=dx*sr+dy*cr
            local fromX=x+rx*g; local fromY=y+ry*g; local toX=x+rx*(g+s); local toY=y+ry*(g+s)
            if Cross.Outline then CL["O"..i].From=V2(fromX,fromY); CL["O"..i].To=V2(toX,toY); CL["O"..i].Color=outCol; CL["O"..i].Thickness=thk+2; CL["O"..i].Visible=true end
            CL["L"..i].From=V2(fromX,fromY); CL["L"..i].To=V2(toX,toY); CL["L"..i].Color=col; CL["L"..i].Thickness=thk; CL["L"..i].Visible=true
        end
        if Cross.InnerEnabled then
            local ig=Cross.InnerGap; local is2=Cross.InnerSize
            for i=1,drawCount do
                local dx,dy=rawDirs[i][1],rawDirs[i][2]; local rx=dx*cr-dy*sr; local ry=dx*sr+dy*cr
                CL["IL"..i].From=V2(x+rx*ig,y+ry*ig); CL["IL"..i].To=V2(x+rx*(ig+is2),y+ry*(ig+is2))
                CL["IL"..i].Color=col; CL["IL"..i].Thickness=thk; CL["IL"..i].Visible=true
            end
        end
        if Cross.CenterDotEnabled then
            if Cross.Outline then CL.CDO.Position=anchor; CL.CDO.Radius=Cross.CenterDotRadius+1.5; CL.CDO.Color=outCol; CL.CDO.Filled=true; CL.CDO.Visible=true end
            CL.CD.Position=anchor; CL.CD.Radius=Cross.CenterDotRadius
            CL.CD.Color=Cross.RainbowColor and Rainbow() or Cross.CenterDotColor
            CL.CD.Filled=Cross.CenterDotFilled; CL.CD.Visible=true
        end
    end
end


local FlyConnection=nil; local _flyBV=nil; local _flyBG=nil; local _flyAtt=nil
local function DisableFly()
    Move.Fly=false
    if FlyConnection then FlyConnection:Disconnect(); FlyConnection=nil end
    if _flyBV  then pcall(function() _flyBV:Destroy()  end); _flyBV=nil  end
    if _flyBG  then pcall(function() _flyBG:Destroy()  end); _flyBG=nil  end
    if _flyAtt then pcall(function() _flyAtt:Destroy() end); _flyAtt=nil end
end
local function EnableFly()
    DisableFly(); Move.Fly=true
    local char=LP_Char or LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end

    local att=Instance.new("Attachment"); att.Parent=root; _flyAtt=att

    local vf=Instance.new("VectorForce")
    vf.Attachment0=att; vf.RelativeTo=Enum.ActuatorRelativeTo.World
    vf.Force=Vector3.zero; vf.Parent=root; _flyBV=vf

    local ao=Instance.new("AlignOrientation")
    ao.Attachment0=att; ao.RigidityEnabled=false
    ao.MaxTorque=4e5; ao.Responsiveness=200
    ao.CFrame=Camera.CFrame; ao.Parent=root; _flyBG=ao

    local mass=0
    pcall(function()
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then mass=mass+p.AssemblyMass end
        end
    end)
    local gravity=workspace.Gravity
    local antiGrav=Vector3.new(0, mass*gravity, 0)

    FlyConnection=RunService.RenderStepped:Connect(function()
        if not Move.Fly or not vf or not vf.Parent then DisableFly(); return end
        local cf=Camera.CFrame; local dir=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W)         then dir=dir+cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S)         then dir=dir-cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A)         then dir=dir-cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D)         then dir=dir+cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space)     then dir=dir+Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.yAxis end
        local moveForce = dir.Magnitude>0 and dir.Unit*(Move.FlySpeed*60) or Vector3.zero
        vf.Force = moveForce + antiGrav
        ao.CFrame = cf
    end)
end
RunService.Stepped:Connect(function()
    if Move.Noclip and LP_Char then
        for _,part in ipairs(LP_Char:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide=false end
            for _,sub in ipairs(part:GetChildren()) do if sub:IsA("BasePart") then sub.CanCollide=false end end
        end
    end
end)


local function MakeBeamPart(name,from3D,to3D,thickness,color,material,transparency)
    local dist=(to3D-from3D).Magnitude
    local p=Instance.new("Part"); p.Name=name; p.Anchored=true
    p.CanCollide=false; p.CanQuery=false; p.CanTouch=false
    p.Material=material; p.Color=color; p.Transparency=transparency or 0
    p.Size=Vector3.new(thickness,thickness,dist)
    p.CFrame=CFrame.lookAt(from3D,to3D)*CFrame.new(0,0,-dist/2); p.Parent=workspace; return p
end
local function MakeImpactPart(pos,size,color,transparency)
    local p=Instance.new("Part"); p.Name="_HTImpact"; p.Anchored=true
    p.CanCollide=false; p.CanQuery=false; p.CanTouch=false
    p.Material=Enum.Material.Neon; p.Color=color; p.Transparency=transparency or 0
    p.Shape=Enum.PartType.Ball; p.Size=Vector3.new(size,size,size)
    p.CFrame=CFrame.new(pos); p.Parent=workspace; return p
end
local function FadeParts(parts,fadeTime,customFade)
    task.spawn(function()
        local steps=18; local dt=fadeTime/steps
        for i=steps,0,-1 do
            local a=i/steps
            for _,info in ipairs(parts) do
                pcall(function()
                    if customFade then customFade(info,a)
                    else info.part.Transparency=1-a*(1-(info.baseTransp or 0)) end
                end)
            end
            task.wait(dt)
        end
        for _,info in ipairs(parts) do pcall(info.part.Destroy,info.part) end
    end)
end
local function SpawnBeamTracer(from3D,to3D)
    task.spawn(function()
        local dist=(to3D-from3D).Magnitude; if dist<1 then return end
        local col=BulletTracers.Rainbow and Color3.fromHSV(tick()%2/2,1,1) or BulletTracers.Color
        local glowCol=BulletTracers.Rainbow and Color3.fromHSV((tick()%2/2+0.15)%1,1,1) or BulletTracers.GlowColor
        local thk=BulletTracers.Thickness*0.02
        local mat=Enum.Material[BulletTracers.Material] or Enum.Material.Neon
        local mode=BulletTracers.Mode; local allParts={}
        if mode=="Lightning" then
            local segments=math.clamp(math.floor(dist/8),5,20)
            local direction=(to3D-from3D).Unit; local segLen=dist/segments
            local right=direction:Cross(Vector3.yAxis)
            if right.Magnitude<0.01 then right=direction:Cross(Vector3.xAxis) end
            right=right.Unit; local up=direction:Cross(right).Unit
            local jitter=math.clamp(dist*0.012,0.2,2.5); local segParts={}
            for i=1,segments do
                local g=Instance.new("Part"); g.Name="_HTLg"; g.Anchored=true; g.CanCollide=false; g.CanQuery=false; g.CanTouch=false
                g.Material=mat; g.Color=glowCol; g.Transparency=0.5; g.Size=Vector3.new(thk*BulletTracers.GlowSize,thk*BulletTracers.GlowSize,segLen*1.1); g.Parent=workspace
                local c=Instance.new("Part"); c.Name="_HTLc"; c.Anchored=true; c.CanCollide=false; c.CanQuery=false; c.CanTouch=false
                c.Material=mat; c.Color=col; c.Transparency=0; c.Size=Vector3.new(thk,thk,segLen*1.1); c.Parent=workspace
                local w=Instance.new("Part"); w.Name="_HTLw"; w.Anchored=true; w.CanCollide=false; w.CanQuery=false; w.CanTouch=false
                w.Material=Enum.Material.Neon; w.Color=Color3.new(1,1,1); w.Transparency=0.15; w.Size=Vector3.new(thk*0.35,thk*0.35,segLen*1.1); w.Parent=workspace
                table.insert(segParts,{glow=g,core=c,white=w})
            end
            local currentOffsets,targetOffsets={},{}
            for i=1,segments-1 do currentOffsets[i]=Vector3.zero; targetOffsets[i]=right*(math.random()-0.5)*2*jitter+up*(math.random()-0.5)*2*jitter end
            local totalTime=BulletTracers.FadeTime+0.3; local startTick=tick(); local retargetTimer=0; local retargetInterval=0.12
            while (tick()-startTick)<totalTime do
                local dt2=RunService.RenderStepped:Wait(); local elapsed=tick()-startTick; local alpha=math.clamp(1-(elapsed/totalTime),0,1)
                retargetTimer=retargetTimer+dt2
                if retargetTimer>=retargetInterval then retargetTimer=0; for i=1,segments-1 do targetOffsets[i]=(right*(math.random()-0.5)*2+up*(math.random()-0.5)*2)*jitter*alpha end end
                local lerpSpeed=math.min(dt2*8,1)
                for i=1,segments-1 do currentOffsets[i]=currentOffsets[i]:Lerp(targetOffsets[i],lerpSpeed) end
                local points={from3D}
                for i=1,segments-1 do table.insert(points,from3D+direction*segLen*i+currentOffsets[i]) end
                table.insert(points,to3D)
                for i=1,segments do
                    local p1,p2=points[i],points[i+1]
                    local cf=CFrame.lookAt(p1,p2)*CFrame.new(0,0,-(p2-p1).Magnitude/2); local sDist=(p2-p1).Magnitude
                    local info=segParts[i]
                    pcall(function()
                        if BulletTracers.Rainbow then local h=(tick()*0.8+i*0.08)%1; info.core.Color=Color3.fromHSV(h,1,1); info.glow.Color=Color3.fromHSV((h+0.15)%1,1,1) end
                        info.glow.CFrame=cf; info.glow.Size=Vector3.new(thk*BulletTracers.GlowSize*alpha,thk*BulletTracers.GlowSize*alpha,sDist); info.glow.Transparency=1-alpha*0.5
                        info.core.CFrame=cf; info.core.Size=Vector3.new(thk*alpha,thk*alpha,sDist); info.core.Transparency=1-alpha
                        info.white.CFrame=cf; info.white.Size=Vector3.new(thk*0.35*alpha,thk*0.35*alpha,sDist); info.white.Transparency=1-alpha*0.85
                    end)
                end
            end
            for _,info in ipairs(segParts) do pcall(info.glow.Destroy,info.glow); pcall(info.core.Destroy,info.core); pcall(info.white.Destroy,info.white) end
            if BulletTracers.ImpactFlash then
                local iSize=BulletTracers.ImpactSize
                local imp=MakeImpactPart(to3D,iSize,Color3.new(1,1,1),0)
                local impG=MakeImpactPart(to3D,iSize*3,col,0.4)
                FadeParts({{part=imp,baseTransp=0,isImpact=true},{part=impG,baseTransp=0.4,isImpact=true}},BulletTracers.FadeTime,function(info,a)
                    info.part.Transparency=1-a*(1-info.baseTransp)
                    if info.isImpact then local expand=info.part.Size.X*(1+(1-a)*0.15); info.part.Size=Vector3.new(expand,expand,expand) end
                end)
            end
            return
        elseif mode=="Helix" then
            local segments=math.clamp(math.floor(dist/4),8,40); local dir=(to3D-from3D).Unit; local segLen=dist/segments
            local right=dir:Cross(Vector3.yAxis); if right.Magnitude<0.01 then right=dir:Cross(Vector3.xAxis) end; right=right.Unit
            local up2=dir:Cross(right).Unit; local radius=thk*8; local path1,path2={},{}
            for i=0,segments do
                local t=i/segments; local angle=t*math.pi*6; local basePoint=from3D+dir*segLen*i
                table.insert(path1,basePoint+right*math.cos(angle)*radius+up2*math.sin(angle)*radius)
                table.insert(path2,basePoint+right*math.cos(angle+math.pi)*radius+up2*math.sin(angle+math.pi)*radius)
            end
            for i=1,#path1-1 do
                table.insert(allParts,{part=MakeBeamPart("_HTHelix1",path1[i],path1[i+1],thk,col,mat,0),baseTransp=0})
                table.insert(allParts,{part=MakeBeamPart("_HTHelix2",path2[i],path2[i+1],thk,glowCol,mat,0),baseTransp=0})
            end
            table.insert(allParts,{part=MakeBeamPart("_HTHelixC",from3D,to3D,thk*0.3,Color3.new(1,1,1),Enum.Material.Neon,0.3),baseTransp=0.3})
        else
            table.insert(allParts,{part=MakeBeamPart("_HTGlow",from3D,to3D,thk*BulletTracers.GlowSize,glowCol,mat,0.55),baseTransp=0.55})
            table.insert(allParts,{part=MakeBeamPart("_HTBeam",from3D,to3D,thk,col,mat,0),baseTransp=0})
            table.insert(allParts,{part=MakeBeamPart("_HTCore",from3D,to3D,thk*0.4,Color3.new(1,1,1),Enum.Material.Neon,0.2),baseTransp=0.2})
        end
        if BulletTracers.ImpactFlash then
            local iSize=BulletTracers.ImpactSize
            table.insert(allParts,{part=MakeImpactPart(to3D,iSize,Color3.new(1,1,1),0),baseTransp=0,isImpact=true})
            table.insert(allParts,{part=MakeImpactPart(to3D,iSize*3,col,0.4),baseTransp=0.4,isImpact=true})
        end
        FadeParts(allParts,BulletTracers.FadeTime,function(info,a)
            info.part.Transparency=1-a*(1-info.baseTransp)
            if info.isImpact then local expand=info.part.Size.X*(1+(1-a)*0.15); info.part.Size=Vector3.new(expand,expand,expand) end
        end)
    end)
end



local function ShowKillEffect(position)
    if not KillEffect.Enabled then return end
    task.spawn(function()
        local col=KillEffect.Color; local style=KillEffect.Style; local sz=KillEffect.Size
        if style=="Skull" or style=="Cross" then
            local parts={}
            local arms=style=="Cross" and {Vector3.new(1,0,0),Vector3.new(0,1,0),Vector3.new(0,0,1)} or {Vector3.new(1,0,1),Vector3.new(1,0,-1),Vector3.new(0,1,0)}
            for _,dir in ipairs(arms) do
                local p=Instance.new("Part"); p.Name="_HTKill"; p.Anchored=true; p.CanCollide=false; p.CanQuery=false; p.CanTouch=false
                p.Material=Enum.Material.Neon; p.Color=col; p.Transparency=0
                p.Size=Vector3.new(dir.X>0 and sz*2 or sz*0.15,dir.Y>0 and sz*2 or sz*0.15,dir.Z>0 and sz*2 or sz*0.15)
                p.CFrame=CFrame.new(position); p.Parent=workspace; table.insert(parts,p)
            end
            local sphere=Instance.new("Part"); sphere.Name="_HTKillSphere"; sphere.Anchored=true; sphere.CanCollide=false; sphere.CanQuery=false; sphere.CanTouch=false
            sphere.Material=Enum.Material.Neon; sphere.Color=col; sphere.Transparency=0.3; sphere.Shape=Enum.PartType.Ball
            sphere.Size=Vector3.new(sz,sz,sz); sphere.CFrame=CFrame.new(position); sphere.Parent=workspace; table.insert(parts,sphere)
            local steps=20; local dt=0.6/steps
            for i=steps,0,-1 do local a=i/steps; for _,p in ipairs(parts) do pcall(function() p.Transparency=1-a; p.Size=p.Size*(1+0.03) end) end; task.wait(dt) end
            for _,p in ipairs(parts) do pcall(p.Destroy,p) end
        elseif style=="Expand" then
            local ring=Instance.new("Part"); ring.Name="_HTKillRing"; ring.Anchored=true; ring.CanCollide=false; ring.CanQuery=false; ring.CanTouch=false
            ring.Material=Enum.Material.Neon; ring.Color=col; ring.Transparency=0; ring.Shape=Enum.PartType.Cylinder
            ring.Size=Vector3.new(0.05,sz,sz); ring.CFrame=CFrame.new(position)*CFrame.Angles(0,0,math.rad(90)); ring.Parent=workspace
            local steps=20; local dt=0.7/steps
            for i=0,steps do local t=i/steps; pcall(function() local expand=sz+t*sz*6; ring.Size=Vector3.new(0.05,expand,expand); ring.Transparency=t end); task.wait(dt) end
            pcall(ring.Destroy,ring)
        elseif style=="Dissolve" then
            local cubes={}
            for _=1,12 do
                local c=Instance.new("Part"); c.Name="_HTKillCube"; c.Anchored=false; c.CanCollide=false; c.CanQuery=false; c.CanTouch=false
                c.Material=Enum.Material.Neon; c.Color=col; c.Transparency=0; c.Size=Vector3.new(sz*0.3,sz*0.3,sz*0.3)
                c.CFrame=CFrame.new(position+Vector3.new((math.random()-0.5)*sz,(math.random()-0.5)*sz,(math.random()-0.5)*sz)); c.Parent=workspace
                local bv=Instance.new("BodyVelocity"); bv.Velocity=Vector3.new((math.random()-0.5)*30,math.random()*20+10,(math.random()-0.5)*30)
                bv.MaxForce=Vector3.new(1e4,1e4,1e4); bv.Parent=c; table.insert(cubes,c)
            end
            task.wait(0.5); local steps=10
            for i=steps,0,-1 do local a=i/steps; for _,c in ipairs(cubes) do pcall(function() c.Transparency=1-a end) end; task.wait(0.05) end
            for _,c in ipairs(cubes) do pcall(c.Destroy,c) end
        end
    end)
end
local _playerHealthCache={}
local function MonitorPlayerHealth(player)
    if player==LP then return end
    task.spawn(function()
        while player.Parent do
            local char=player.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                local prevHP=_playerHealthCache[player]; local curHP=hum.Health
                if prevHP and curHP<prevHP and curHP<=0 and prevHP>0 then
                    local rp=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
                    if rp then ShowKillEffect(rp.Position) end
                end
                _playerHealthCache[player]=curHP
            end
            task.wait(0.1)
        end
        _playerHealthCache[player]=nil
    end)
end
for _,p in ipairs(Players:GetPlayers()) do MonitorPlayerHealth(p) end
Players.PlayerAdded:Connect(function(p) MonitorPlayerHealth(p) end)
Players.PlayerRemoving:Connect(function(p) _playerHealthCache[p]=nil end)


local RageFOV=Drawing.new("Circle")
RageFOV.Thickness=2; RageFOV.Visible=false; RageFOV.Radius=150
RageFOV.Transparency=0.7; RageFOV.Filled=false; RageFOV.Color=Rage.FOVColor

local RageTargetInfo=Drawing.new("Text")
RageTargetInfo.Visible=false; RageTargetInfo.Size=18; RageTargetInfo.Font=2
RageTargetInfo.Outline=true; RageTargetInfo.OutlineColor=Color3.fromRGB(0,0,0)
RageTargetInfo.Color=Color3.fromRGB(255,255,255); RageTargetInfo.Text=""

local RageHighlight,RageHighlightConn=nil,nil
local RageCurrentTarget,RageTargetPart=nil,nil
local RageTargetOffset=false
local RageTargetInRange=false
local _bfuncsOldRaycastline=nil

local _gdRS       = game:GetService("ReplicatedStorage")
local _gdNT       = workspace:FindFirstChild("notarget")
local _gdBodies   = workspace:FindFirstChild("bodies")
local _gdThrow    = workspace:FindFirstChild("throwables")
local _gdObj      = workspace:FindFirstChild("serverStuff") and workspace.serverStuff:FindFirstChild("objectives")
local _gdCM       = workspace:FindFirstChild("serverStuff") and workspace.serverStuff:FindFirstChild("conscriptmode")
local _gdNationT  = workspace:FindFirstChild("nation_team")
local _gdEmpireT  = workspace:FindFirstChild("empire_team")

local _gdStats = nil
pcall(function()
    _gdStats = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/sneekygoober/Grave-Digger-Silent-Aim-Script/refs/heads/main/stats.luau"
    ))()
end)

local _bfuncs = nil
pcall(function()
    local s,r = pcall(require, _gdRS.shared.bFunctions)
    if s then _bfuncs = r end
end)

local _gdRayParams = RaycastParams.new()
_gdRayParams.FilterType  = Enum.RaycastFilterType.Exclude
_gdRayParams.IgnoreWater = true

local _gdBodyparts = {"Right Arm", "Left Arm", "Right Leg", "Left Leg"}

local _gdFilterBase   = {}
local _gdFilterDirty  = true
local _gdFilterLastChar = nil
local _gdFilterLastObjCount = 0

local function _gdRebuildBaseFilter(char)
    local f = {char, char.Parent, _gdNT, _gdBodies, _gdThrow}
    if _gdObj then
        for _, v in next, _gdObj:GetChildren() do
            local cap = v:FindFirstChild("capture")
            if cap then f[#f+1] = cap end
        end
    end
    _gdFilterBase    = f
    _gdFilterLastChar = char
    _gdFilterDirty   = false
end

local _gdFilterWork = {}

local function GDIsVisible(part, origin, enemyChar)
    if not part then return false, nil, false end

    local base = _gdFilterBase
    local bn   = #base
    for i = 1, bn do _gdFilterWork[i] = base[i] end
    local bw = enemyChar:FindFirstChild("bullet_whizz")
    if bw then _gdFilterWork[bn+1] = bw; _gdFilterWork[bn+2] = nil
    else        _gdFilterWork[bn+1] = nil end
    _gdRayParams.FilterDescendantsInstances = _gdFilterWork

    local result = workspace:Raycast(origin, part.Position - origin, _gdRayParams)
    if not result then return true, nil, false end

    if result.Instance:IsDescendantOf(enemyChar) then
        local rp, rpp = result.Instance.Parent, result.Instance.Parent.Parent
        local ins = (rp.Name == "vanguardshield1" and rp:FindFirstChild("hitbox") and rp)
                 or (rpp.Name == "vanguardshield1" and rpp:FindFirstChild("hitbox") and rpp)
        if ins then
            local sh = ins:FindFirstChild("special") and ins.special:FindFirstChild("topshield")
            if sh and sh:FindFirstChild("health") and sh.health.Value > 0 then
                return true, sh:FindFirstChild("damagepart"), false
            else
                return true, enemyChar:FindFirstChild("HeadHitbox"), true
            end
        end
        return true, result.Instance, false
    end

    return false, result.Instance, false
end

local function RageShouldHit()
    local hc = Rage.HitChance
    if hc >= 100 then return true elseif hc <= 0 then return false end
    return math.random(1, 100) <= hc
end

local function GDGetTarget(origin)
    origin = origin or Camera.CFrame.Position
    local char = LP.Character
    if not char or not (_gdNationT and _gdEmpireT) then return nil, false end

    local eFolder = char.Parent == _gdEmpireT and _gdNationT or _gdEmpireT
    if not eFolder then return nil, false end

    if _gdFilterDirty or char ~= _gdFilterLastChar then
        _gdRebuildBaseFilter(char)
    end

    local gun = char:FindFirstChildOfClass("Tool")
    local conscriptMode = _gdCM and _gdCM.Value
    local gunPL = (_gdStats and gun and _gdStats[gun.Name]) or 2

    local cPart, cDist, cOffset = nil, Rage.FOV, false
    local mousePos = UIS:GetMouseLocation()
    local wallCheck = Rage.VisibleCheck

    for _, eChar in next, eFolder:GetChildren() do
        local hum = eChar:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local root = eChar:FindFirstChild("Torso") or eChar.PrimaryPart
        if not root then continue end
        local head = eChar:FindFirstChild("HeadHitbox") or root

        local rootScreen, onScreen = Camera:WorldToViewportPoint(root.Position)
        if not onScreen then continue end
        local screenDist = (V2(rootScreen.X, rootScreen.Y) - mousePos).Magnitude
        if screenDist > Rage.FOV * 1.5 then continue end

        local tPart
        if conscriptMode or not eChar:FindFirstChild("helmet") or eChar:FindFirstChild("helmetgone") then
            tPart = head
        else
            local class = eChar:FindFirstChild("class") and eChar.class.Value
            if not gunPL or not class then
                tPart = root
            elseif class == "lancer" then
                tPart = (gunPL == 5) and head or root
            elseif class == "vanguard" then
                tPart = (gunPL >= 3) and head or root
            else
                tPart = (gunPL >= 2) and head or root
            end
        end
        if not tPart then continue end

        local tScreen, tOnScreen = Camera:WorldToViewportPoint(tPart.Position)
        if not tOnScreen then continue end
        local dist = (V2(tScreen.X, tScreen.Y) - mousePos).Magnitude
        if dist >= cDist then continue end

        local offset = false
        if wallCheck then
            local scanOrder = {tPart}
            if root ~= tPart then scanOrder[#scanOrder+1] = root end
            for _, bpName in ipairs(_gdBodyparts) do
                local bp = eChar:FindFirstChild(bpName)
                if bp then scanOrder[#scanOrder+1] = bp end
            end

            local foundVisible = false
            for _, scanPart in ipairs(scanOrder) do
                local sv, snPart, sOff = GDIsVisible(scanPart, origin, eChar)
                if sv then
                    tPart  = snPart or scanPart
                    offset = sOff
                    foundVisible = true
                    break
                end
            end
            if not foundVisible then continue end
        end

        cPart   = tPart
        cOffset = offset
        cDist   = dist
    end

    return cPart, cOffset
end

local _rageLastFOVVisible = false
local function RageUpdateVisuals()
    if not Rage.Enabled then
        if _rageLastFOVVisible then RageFOV.Visible=false; _rageLastFOVVisible=false end
        if RageTargetInfo.Visible then RageTargetInfo.Visible=false end
        if RageHighlight then pcall(RageHighlight.Destroy,RageHighlight); RageHighlight=nil end
        return
    end
    local mp = UIS:GetMouseLocation()
    RageFOV.Position = mp; RageFOV.Radius = Rage.FOV
    if not _rageLastFOVVisible then RageFOV.Visible=true; _rageLastFOVVisible=true end
    RageFOV.Color = RageCurrentTarget and Color3.fromRGB(0,150,255)
        or RageTargetInRange and Color3.fromRGB(255,255,0)
        or Color3.fromRGB(255,50,0)

    if not Rage.ShowTargetInfo or not RageCurrentTarget then
        if RageTargetInfo.Visible then RageTargetInfo.Visible=false end
    else
        local sp,on = Camera:WorldToViewportPoint(RageCurrentTarget.Position)
        if on then
            RageTargetInfo.Visible=true; RageTargetInfo.Position=V2(sp.X,sp.Y+20)
            local t=""
            if Rage.ShowTargetName then
                local plr=Players:GetPlayerFromCharacter(RageCurrentTarget.Parent)
                t="[Player] "..(plr and plr.Name or "?")
            end
            if Rage.ShowTargetHP then
                local h=RageCurrentTarget.Parent and RageCurrentTarget.Parent:FindFirstChildOfClass("Humanoid")
                if h then t=t.."\n"..string.format("HP: %.0f/%.0f",h.Health,h.MaxHealth) end
            end
            if Rage.ShowTargetDistance and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                t=t.."\n"..string.format("Dist: %.1f",(RageCurrentTarget.Position-LP.Character.HumanoidRootPart.Position).Magnitude)
            end
            if Rage.ShowHitChance then
                t=t.."\n"..string.format("Chance: %d%%",math.clamp(Rage.HitChance+math.random(-5,5),1,100))
            end
            RageTargetInfo.Text=t
        elseif RageTargetInfo.Visible then RageTargetInfo.Visible=false end
    end

    local targetChar = RageCurrentTarget and RageCurrentTarget.Parent
    if Rage.HighlightTarget and targetChar and targetChar:IsA("Model") then
        if not RageHighlight or RageHighlight.Adornee ~= targetChar then
            if RageHighlight then pcall(RageHighlight.Destroy,RageHighlight) end
            if RageHighlightConn then RageHighlightConn:Disconnect() end
            local h=Instance.new("Highlight"); h.Name="RageHL"; h.Adornee=targetChar
            h.FillColor=Color3.fromRGB(255,50,50); h.FillTransparency=0.7
            h.OutlineColor=Color3.new(1,1,1); h.OutlineTransparency=0
            pcall(function() h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop end)
            h.Parent=game:GetService("CoreGui"); RageHighlight=h
            RageHighlightConn=targetChar.Destroying:Connect(function()
                if RageHighlight then pcall(RageHighlight.Destroy,RageHighlight); RageHighlight=nil end
            end)
        end
    elseif RageHighlight then
        pcall(RageHighlight.Destroy,RageHighlight); RageHighlight=nil
        if RageHighlightConn then RageHighlightConn:Disconnect(); RageHighlightConn=nil end
    end
end


local function _isTargetStillValid(part)
    if not part or not part.Parent then return false end
    local hum = part.Parent:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen then return false end
    return (V2(screen.X, screen.Y) - UIS:GetMouseLocation()).Magnitude <= Rage.FOV
end

task.spawn(function()
    while true do
        task.wait(Rage.UpdateRate)
        if not Rage.Enabled then
            RageCurrentTarget = nil; RageTargetOffset = false; RageTargetInRange = false
            pcall(RageUpdateVisuals); continue
        end

        if RageCurrentTarget and _isTargetStillValid(RageCurrentTarget) then
            local newPart, newOffset = GDGetTarget(Camera.CFrame.Position)
            if newPart and newPart ~= RageCurrentTarget then
                local oldSc = Camera:WorldToViewportPoint(RageCurrentTarget.Position)
                local newSc = Camera:WorldToViewportPoint(newPart.Position)
                local mouse = UIS:GetMouseLocation()
                local oldD = (V2(oldSc.X, oldSc.Y) - mouse).Magnitude
                local newD = (V2(newSc.X, newSc.Y) - mouse).Magnitude
                if newD < oldD - 15 then
                    RageCurrentTarget = newPart; RageTargetOffset = newOffset
                end
            end
            RageTargetInRange = true
        else
            local newPart, newOffset = GDGetTarget(Camera.CFrame.Position)
            RageCurrentTarget = newPart; RageTargetOffset = newOffset or false
            RageTargetInRange = newPart ~= nil
        end

        pcall(RageUpdateVisuals)
    end
end)

pcall(function()
    if not (_bfuncs and hookfunction and rawget) then return end
    local origFn = rawget(_bfuncs, "raycastline")
    if not origFn then return end
    _bfuncsOldRaycastline = clonefunction(origFn)
    hookfunction(origFn, newcclosure(function(self, args)
        local isBullet = rawget(args,"bullet")
        local origin   = rawget(args,"point")
        local dest     = rawget(args,"destination")

        if isBullet and origin and dest then
            local c = RageCurrentTarget
            if Rage.Enabled and c and RageShouldHit() then
                local aimPos = RageTargetOffset
                    and c.CFrame:PointToWorldSpace(Vector3.new(0, c.Size.Y/2, 0))
                    or  c.CFrame.Position
                local _args = args
                _args.destination = aimPos - origin
                if BulletTracers.Enabled then
                    task.spawn(SpawnBeamTracer, origin, aimPos)
                end
                return _bfuncsOldRaycastline(self, _args)
            end
            if WeaponMods.NoSpread then
                local _args = args
                _args.destination = Camera.CFrame.LookVector * dest.Magnitude
                if BulletTracers.Enabled then
                    task.spawn(SpawnBeamTracer, origin, origin + _args.destination)
                end
                return _bfuncsOldRaycastline(self, _args)
            end
            if BulletTracers.Enabled then
                task.spawn(function()
                    local result = workspace:Raycast(origin, dest, _gdRayParams)
                    SpawnBeamTracer(origin, result and result.Position or (origin + dest))
                end)
            end
        end
        return _bfuncsOldRaycastline(self, args)
    end))
end)

-- ── Weapon Mods logic ──────────────────────────────────────────────────────
-- u18 = deep-copied weapon stat table (fire_rate, accuracy, reload_*, etc.)

local _wmOriginals = {}

-- Collect every reachable table from GC + function upvalues
-- Tries all known executor debug APIs so it works across executors
local function WM_GC()
    local seen   = {}
    local result = {}
    local function add(v)
        if type(v) == "table" and not seen[v] then
            seen[v] = true; result[#result + 1] = v
        end
    end

    -- 1) getgc(true) – some executors include tables
    pcall(function()
        local r = getgc(true)
        if type(r) == "table" then for _, v in ipairs(r) do add(v) end end
    end)

    -- 2) getgc() for functions, then drain every upvalue
    pcall(function()
        local funcs = getgc()
        if type(funcs) ~= "table" then return end
        for _, fn in ipairs(funcs) do
            if type(fn) == "function" then
                -- method A: debug.getupvalues (UNC dict: {name=value})
                pcall(function()
                    local ups = debug.getupvalues(fn)
                    if type(ups) == "table" then
                        for _, v in pairs(ups) do add(v) end
                    end
                end)
                -- method B: debug.getupvalue(fn, n) numeric loop (standard Lua)
                pcall(function()
                    for n = 1, 200 do
                        local name, v = debug.getupvalue(fn, n)
                        if name == nil then break end
                        add(v)
                    end
                end)
            end
        end
    end)

    return result
end

-- u18 identifier: has fire_rate, accuracy, capacity, ammo_give, reload_full
local function WM_IsStatTable(t)
    return type(t) == "table"
        and rawget(t, "fire_rate")   ~= nil
        and rawget(t, "accuracy")    ~= nil
        and rawget(t, "capacity")    ~= nil
        and rawget(t, "ammo_give")   ~= nil
        and rawget(t, "reload_full") ~= nil
end


local function WM_ApplyToStat(tbl)
    pcall(function()
        if not _wmOriginals[tbl] then
            _wmOriginals[tbl] = {
                accuracy          = tbl.accuracy,
                moving_accuracy   = tbl.moving_accuracy,
                recoil            = tbl.recoil,
                recoil_count      = tbl.recoil_count,
                reload_start      = tbl.reload_start,
                reload_empty      = tbl.reload_empty,
                reload_loop       = tbl.reload_loop,
                reload_loop_after = tbl.reload_loop_after,
                reload_end        = tbl.reload_end,
                reload_full       = tbl.reload_full,
                aim_speed         = tbl.aim_speed,
                fire_rate          = tbl.fire_rate,
                cycle              = tbl.cycle,
                cycle_rest         = tbl.cycle_rest,
                special_incendiary = type(tbl.special) == "table" and tbl.special.incendiary or nil,
            }
        end
        local o = _wmOriginals[tbl]
        for k, v in pairs(o) do
            if k ~= "special_incendiary" then tbl[k] = v end
        end
        if type(tbl.special) == "table" then
            tbl.special.incendiary = o.special_incendiary
        end

        if WeaponMods.NoSpread then
            tbl.accuracy        = 0
            tbl.moving_accuracy = 0
        end
        if WeaponMods.NoRecoil then
            tbl.recoil       = 0
            tbl.recoil_count = 0
        end
        if WeaponMods.NoReload then
            tbl.reload_start      = 0
            tbl.reload_empty      = 0
            tbl.reload_loop       = 0
            tbl.reload_loop_after = 0
            tbl.reload_end        = 0
            tbl.reload_full       = 0
        end
        if WeaponMods.InstantADS then
            tbl.aim_speed = 0
        end
        if WeaponMods.RapidFire then
            local m = WeaponMods.RapidMult
            if (tbl.fire_rate  or 0) > 0 then tbl.fire_rate  = tbl.fire_rate  / m end
            if (tbl.cycle      or 0) > 0 then tbl.cycle      = tbl.cycle      / m end
            if (tbl.cycle_rest or 0) > 0 then tbl.cycle_rest = tbl.cycle_rest / m end
        end
        if WeaponMods.Incendiary then
            if type(tbl.special) ~= "table" then tbl.special = {} end
            tbl.special.incendiary = true
        end
    end)
end

-- Hook bFunctions.deepCopy so every newly-equipped weapon is auto-patched on reset
pcall(function()
    local bFuncs = require(game.ReplicatedStorage.shared.bFunctions)
    if type(bFuncs) ~= "table" or type(bFuncs.deepCopy) ~= "function" then return end
    local _origDC = bFuncs.deepCopy
    bFuncs.deepCopy = function(self, tbl, ...)
        local result = _origDC(self, tbl, ...)
        pcall(function()
            if WM_IsStatTable(result) then
                WM_ApplyToStat(result)
                _killAuraLastModule = result
            end
        end)
        return result
    end
end)

-- Patch all u18 stat tables found in gc
local function WM_PatchAll()
    local count = 0
    for _, v in pairs(WM_GC()) do
        if WM_IsStatTable(v) then
            WM_ApplyToStat(v)
            count = count + 1
        end
    end
    return count
end


-- ──────────────────────────────────────────────────────────────────────────


local _spinBAV=nil; local _hitboxOriginals={}; local _hitboxOutlines={}; local _hitboxLastUpdate=0; local _lastSpinSpeed=20
local function SpinbotStop()
    if _spinBAV then pcall(_spinBAV.Destroy,_spinBAV); _spinBAV=nil end
    pcall(function()
        local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then for _,c in pairs(hrp:GetChildren()) do if c.Name=="_RageSpinBAV" then c:Destroy() end end end
    end)
end
local function SpinbotStart()
    SpinbotStop()
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local bav=Instance.new("BodyAngularVelocity"); bav.Name="_RageSpinBAV"
    bav.AngularVelocity=Vector3.new(0,Rage.SpinSpeed,0); bav.MaxTorque=Vector3.new(0,math.huge,0); bav.P=1e6; bav.Parent=hrp
    _spinBAV=bav; _lastSpinSpeed=Rage.SpinSpeed
end
local function HitboxRestore()
    for part,origSize in pairs(_hitboxOriginals) do
        pcall(function() if part and part.Parent then part.Size=origSize; part.Transparency=0
            for _,child in pairs(part:GetChildren()) do if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceGui") then child.Transparency=0 end end
        end end)
    end
    _hitboxOriginals={}; for _,box in pairs(_hitboxOutlines) do pcall(box.Destroy,box) end; _hitboxOutlines={}
end
local function HitboxExpand()
    local expandSize=Rage.HitboxSize; local target=Vector3.new(expandSize,expandSize,expandSize)
    for _,player in pairs(Players:GetPlayers()) do
        if player==LP then continue end
        if Rage.TeamCheck and player.Team and LP.Team and player.Team==LP.Team then continue end
        local pChar=player.Character; if not pChar then continue end
        local hum=pChar:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health<=0 then continue end
        for _,partName in pairs({"Head","HumanoidRootPart"}) do
            local part=pChar:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                if not _hitboxOriginals[part] then _hitboxOriginals[part]=part.Size end
                if part.Size~=target then part.Size=target; part.Transparency=1 end
                for _,child in pairs(part:GetChildren()) do if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceGui") then child.Transparency=1 end end
                if not _hitboxOutlines[part] or not _hitboxOutlines[part].Parent then
                    local box=Instance.new("SelectionBox"); box.Name="_RageHB"; box.Adornee=part
                    box.Color3=Color3.fromRGB(255,0,0); box.LineThickness=0.03; box.Transparency=0.3; box.Parent=part
                    _hitboxOutlines[part]=box
                end
            end
        end
    end
    for part,box in pairs(_hitboxOutlines) do
        if not part or not part.Parent then pcall(box.Destroy,box); _hitboxOutlines[part]=nil; _hitboxOriginals[part]=nil end
    end
end
local function RageCleanup()
    if RageFOV.Visible then RageFOV.Visible=false end; _rageLastFOVVisible=false
    if RageTargetInfo.Visible then RageTargetInfo.Visible=false; RageTargetInfo.Text="" end
    if RageHighlight then pcall(RageHighlight.Destroy,RageHighlight); RageHighlight=nil end
    if RageHighlightConn then RageHighlightConn:Disconnect(); RageHighlightConn=nil end
    RageCurrentTarget=nil; RageTargetOffset=false; RageTargetInRange=false; SpinbotStop(); HitboxRestore()
end

RunService.Heartbeat:Connect(function(dt)
    if Rage.TPWalk then
        local char=LP.Character; if char then
            local hum2=char:FindFirstChildOfClass("Humanoid"); local hrp=char:FindFirstChild("HumanoidRootPart")
            if hum2 and hrp and hum2.MoveDirection.Magnitude>0.1 then hrp.CFrame=hrp.CFrame+(hum2.MoveDirection.Unit*Rage.TPWalkSpeed*dt*10) end
        end
    end
    if Rage.Spinbot then
        if not _spinBAV or not _spinBAV.Parent then SpinbotStart()
        elseif Rage.SpinSpeed~=_lastSpinSpeed then _spinBAV.AngularVelocity=Vector3.new(0,Rage.SpinSpeed,0); _lastSpinSpeed=Rage.SpinSpeed end
    elseif _spinBAV then SpinbotStop() end
    if Rage.HitboxExpander then
        local now=tick(); if now-_hitboxLastUpdate>=0.5 then _hitboxLastUpdate=now; pcall(HitboxExpand) end
    end
end)
LP.CharacterAdded:Connect(function()
    _rageRayParamsLastChar=nil
    if Rage.Spinbot then task.wait(0.5); SpinbotStart() end
end)


local _killAuraLastError = nil
local _killAuraStats = { ticks=0, attempts=0, errors=0 }

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if not KillAura.Enabled then continue end
        local dh = _killAuraGetDH()
        if not dh then
            _killAuraLastError = "no damage_handler (events / Jolt unavailable)"; continue
        end
        local char = LP.Character; if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then continue end
        local tool = char:FindFirstChildOfClass("Tool")
        if KillAura.RequireTool and not tool then
            _killAuraLastError = "no tool equipped"; continue
        end
        local mod = _killAuraResolveModule(tool) or _killAuraLastModule
        if not mod then
            _killAuraLastError = "no weapon module resolved"; continue
        end

        local dtype = (KillAura.DamageType == "Melee") and "melee" or "gun"

        local enemyFolder = (char.Parent == _gdEmpireT) and _gdNationT or _gdEmpireT
        if not enemyFolder then
            _killAuraLastError = "no enemy team folder"; continue
        end

        _killAuraStats.ticks = _killAuraStats.ticks + 1
        local maxR2 = KillAura.Range * KillAura.Range

        for _, eChar in ipairs(enemyFolder:GetChildren()) do
            local hum = eChar:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then continue end
            local head = eChar:FindFirstChild("HeadHitbox") or eChar:FindFirstChild("Head")
            local torso = eChar:FindFirstChild("Torso") or eChar:FindFirstChild("UpperTorso") or eChar:FindFirstChild("HumanoidRootPart")
            local refPart = head or torso
            if not refPart then continue end
            if (refPart.Position - hrp.Position).Magnitude*(refPart.Position - hrp.Position).Magnitude > maxR2 then continue end

            local function fire(hitbox)
                if not hitbox then return end
                _killAuraStats.attempts = _killAuraStats.attempts + 1
                local ok, err = pcall(function()
                    if dtype == "melee" then
                        dh:Fire(hitbox, tool, "melee", mod, nil)
                    else
                        dh:Fire(hitbox, tool, "gun", mod, "", false, 1)
                    end
                end)
                if not ok then
                    _killAuraStats.errors = _killAuraStats.errors + 1
                    _killAuraLastError = tostring(err)
                end
            end

            if dtype == "melee" then
                fire(torso)
            else
                fire(head)
                if torso and torso ~= head then fire(torso) end
            end
        end
    end
end)


local _autoMineRayParams = RaycastParams.new()
_autoMineRayParams.FilterType = Enum.RaycastFilterType.Exclude
_autoMineRayParams.IgnoreWater = true

task.spawn(function()
    local SCAN_DIRS = {}
    local steps = 6
    for i = 0, steps - 1 do
        local yaw = (i / steps) * math.pi * 2
        for j = -2, 2 do
            local pitch = (j / 4) * (math.pi * 0.45)
            local cy, sy = math.cos(yaw), math.sin(yaw)
            local cp, sp = math.cos(pitch), math.sin(pitch)
            table.insert(SCAN_DIRS, Vector3.new(cy * cp, sp, sy * cp))
        end
    end
    table.insert(SCAN_DIRS, Vector3.new(0, -1, 0))

    while true do
        RunService.Heartbeat:Wait()
        if not AutoMine.Enabled then continue end
        local mineEv = _autoMineGetMine()
        if not mineEv then continue end
        local char = LP.Character; if not char then continue end
        local head = char:FindFirstChild("Head")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not head or not hrp then continue end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then continue end
        local weaponVal = tool:FindFirstChild("weapon")
        local wname = weaponVal and weaponVal.Value
        if wname ~= "pick" and wname ~= "pickaxe" then continue end

        _autoMineRayParams.FilterDescendantsInstances = {char}

        local origin = head.Position
        local range = AutoMine.Range
        for _, dir in ipairs(SCAN_DIRS) do
            local result = workspace:Raycast(origin, dir * range, _autoMineRayParams)
            if not result then continue end
            if result.Instance ~= workspace.Terrain then continue end
            local mat = result.Material
            local hitPos = result.Position
            local ok = false
            if AutoMine.MineBasalt and mat == Enum.Material.Basalt then ok = true end
            if AutoMine.IgnoreFloor and (mat == Enum.Material.Rock or mat == Enum.Material.Mud or mat == Enum.Material.Slate or mat == Enum.Material.Limestone or mat == Enum.Material.Sandstone or mat == Enum.Material.Basalt) then ok = true end
            if not ok then continue end
            pcall(function()
                local cf = CFrame.new(hitPos, head.Position)
                mineEv:Fire(cf, tool, false, workspace.Terrain)
            end)
        end
    end
end)


local SkyPresets={
    {name="Galaxy",id="159454299"},{name="Clouds",id="570557514"},{name="Dark",id="6285719338"},
    {name="Red",id="401664839"},{name="Purple Nebula",id="433274085"},{name="Blue Sky",id="7018684000"},
    {name="Space",id="159248188"},{name="Sunset",id="600830446"},{name="Pink Sky",id="271042516"},{name="Storm",id="161919806"},
}
local autoCycle=false
local presetNames={}; for _,p in ipairs(SkyPresets) do table.insert(presetNames,p.name) end
local function ChangeSky(id)
    for _,v in pairs(Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end
    local sky=Instance.new("Sky")
    for _,side in pairs({"Bk","Dn","Ft","Lf","Rt","Up"}) do pcall(function() sky["Skybox"..side]="rbxassetid://"..id end) end
    sky.Parent=Lighting
end
local function RemoveSky() for _,v in pairs(Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end end



local _renderFrame = 0
local RenderConnection = RunService.RenderStepped:Connect(function()
    _renderFrame = _renderFrame + 1
    pcall(function()
        UpdateAimbot(); UpdateCrosshair(); RageUpdateVisuals()
    end)
end)

local _kitFrame = 0
RunService.Heartbeat:Connect(function()
    _kitFrame = _kitFrame + 1
    if _kitFrame % 3 == 0 then pcall(kitUpdateLoop) end
end)

local _configLoading = false



local Window = Hyperion:CreateWindow({
    Title   = "Hyperion",
    Logo    = "rbxassetid://134963728913547",
    Size    = UDim2.new(0, 880, 0, 600),
})

local _menuKeybind = Enum.KeyCode.RightShift
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == _menuKeybind then
        pcall(function() Window:Toggle() end)
    end
end)




local AutoFarm = {
    Enabled = false, FarmRunning = false,
    SkipLocked = true,
    StandOffset = 3, TpSettle = 0.05,
    OpenWait = 1, CollectWait = 0.05, CollectTrips = 4,
    EPressWait = 0.02, OpenAttempts = 2, StuckTimeout = 15,
    WaypointInterval = 120,
    _thread = nil, _waypoint = nil, _blacklist = {}, _crateCount = 0,
    _rarityEnabled = {true,true,true,true,true,true,true,true},
}

local _cratesFolder = workspace:FindFirstChild(CRATE_FOLDER) or workspace:WaitForChild(CRATE_FOLDER, 5)

if _cratesFolder then
    _cratesFolder.ChildRemoved:Connect(function(child)
        AutoFarm._blacklist[child] = nil
    end)
end

local function _farmIsCrateAllowed(crate)
    if crate:GetAttribute("Open") == true then return false end
    if AutoFarm.SkipLocked then
        local locked = false
        pcall(function() locked = crate:GetAttribute("Locked") end)
        if locked then return false end
    end
    if AutoFarm._blacklist[crate] then return false end
    if crate:GetAttribute("PinkVault") or crate:GetAttribute("GreenVault") then return false end
    local rarity = crate:GetAttribute("Rarity")
    if rarity == nil then return true end
    local checkId = rarity >= 8 and 8 or rarity
    return AutoFarm._rarityEnabled[checkId] == true
end

local function _farmSpamE(times)
    local VIM = game:GetService("VirtualInputManager")
    for i = 1, times do
        VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(AutoFarm.EPressWait)
        VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        task.wait(AutoFarm.EPressWait)
    end
end

local function _farmStartESpam(duration)
    task.spawn(function()
        local VIM = game:GetService("VirtualInputManager")
        local endTime = tick() + duration
        while tick() < endTime do
            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.03)
            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(0.03)
        end
    end)
end

local function _farmTeleportToCrate(root)
    local char = LP.Character; if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    local frontCFrame = CFrame.new(
        root.CFrame.Position + root.CFrame.LookVector * AutoFarm.StandOffset,
        root.CFrame.Position
    )
    hrp.CFrame = frontCFrame
    RunService.RenderStepped:Wait()
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, root.CFrame.Position)
    return frontCFrame
end

local function _farmWalkToWaypoint()
    if not AutoFarm._waypoint then return end
    local char = LP.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local path = game:GetService("PathfindingService"):CreatePath({AgentRadius=2, AgentHeight=5, AgentCanJump=true})
    local ok = pcall(function() path:ComputeAsync(hrp.Position, AutoFarm._waypoint) end)
    if ok and path.Status == Enum.PathStatus.Success then
        for _, wp in ipairs(path:GetWaypoints()) do
            if not AutoFarm.Enabled then return end
            if wp.Action == Enum.PathWaypointAction.Jump then hum.Jump = true end
            hum:MoveTo(wp.Position)
            hum.MoveToFinished:Wait()
        end
    end
end

task.spawn(function()
    local PPS = game:GetService("ProximityPromptService")
    while true do
        local prompt = PPS.PromptShown:Wait()
        if AutoFarm.Enabled and AutoFarm.FarmRunning then
            pcall(fireproximityprompt, prompt)
        end
        task.wait()
    end
end)

local function StopAutoFarm()
    AutoFarm.Enabled = false
    AutoFarm.FarmRunning = false
    if AutoFarm._thread then pcall(task.cancel, AutoFarm._thread); AutoFarm._thread = nil end
    if AutoFarm._waypoint and LP.Character then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(AutoFarm._waypoint)
            Notify("Crate Farm","Teleported back to waypoint.","Info")
        end
    end
end

local function StartAutoFarm()
    if AutoFarm.FarmRunning then return end
    AutoFarm.FarmRunning = true
    AutoFarm._blacklist = {}
    AutoFarm._crateCount = 0
    local lastWaypointTime = tick()

    AutoFarm._thread = task.spawn(function()
        local lastFrontCFrame = nil
        local lastRoot = nil

        while AutoFarm.Enabled do
            local foundAny = false

            if AutoFarm._waypoint and tick() - lastWaypointTime >= AutoFarm.WaypointInterval then
                _farmWalkToWaypoint()
                lastWaypointTime = tick()
            end

            local folder = _cratesFolder
            if folder then
                for _, v in ipairs(folder:GetChildren()) do
                    if not AutoFarm.Enabled then break end
                    if _farmIsCrateAllowed(v) then
                        local root = v:FindFirstChild("Root") or crateGetRoot(v)
                        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                        if root and hrp then
                            if not _farmIsCrateAllowed(v) then continue end
                            foundAny = true
                            local startTime = tick()
                            local opened = false
                            local attempts = 0

                            while AutoFarm.Enabled and not opened and attempts < AutoFarm.OpenAttempts do
                                if tick() - startTime >= AutoFarm.StuckTimeout then break end
                                attempts = attempts + 1

                                local frontCFrame = _farmTeleportToCrate(root)
                                if not frontCFrame then break end
                                task.wait(AutoFarm.TpSettle)

                                local prompt = root:FindFirstChild("Prompt")
                                    or root:FindFirstChildOfClass("ProximityPrompt")
                                if prompt then pcall(fireproximityprompt, prompt) end

                                _farmStartESpam(AutoFarm.OpenWait)
                                _farmSpamE(5)
                                task.wait(AutoFarm.OpenWait)
                                _farmSpamE(5)

                                if v:GetAttribute("Open") == true then
                                    opened = true
                                    AutoFarm._crateCount = AutoFarm._crateCount + 1

                                    if lastFrontCFrame and lastRoot and lastRoot.Parent then
                                        for i = 1, AutoFarm.CollectTrips do
                                            if not AutoFarm.Enabled then break end
                                            local hrp2 = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                                            if not hrp2 then break end
                                            hrp2.CFrame = lastFrontCFrame
                                            RunService.RenderStepped:Wait()
                                            pcall(function() Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, lastRoot.CFrame.Position) end)
                                            _farmSpamE(3)
                                            task.wait(AutoFarm.CollectWait)
                                            hrp2.CFrame = frontCFrame
                                            RunService.RenderStepped:Wait()
                                            pcall(function() Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, root.CFrame.Position) end)
                                            _farmSpamE(3)
                                            task.wait(AutoFarm.CollectWait)
                                        end
                                    end

                                    lastFrontCFrame = frontCFrame
                                    lastRoot = root

                                    if AutoFarm._waypoint and tick() - lastWaypointTime >= AutoFarm.WaypointInterval then
                                        _farmWalkToWaypoint()
                                        lastWaypointTime = tick()
                                    end
                                end
                            end

                            if not opened then
                                AutoFarm._blacklist[v] = tick()
                            end
                        end
                    end
                end
            end

            if not foundAny and AutoFarm._waypoint then
                _farmWalkToWaypoint()
                lastWaypointTime = tick()
            end

            task.wait(0.05)
        end

        AutoFarm.FarmRunning = false
        if AutoFarm._waypoint and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(AutoFarm._waypoint) end
        end
        Notify("Crate Farm","Stopped. Opened "..AutoFarm._crateCount.." crates.","Info")
    end)
end

local AutoShop = {
    buyEnabled = false, buyThread = nil,
    buyRarity = {true,true,true,true,true},
    sellEnabled = false, sellThread = nil,
    sellInterval = 3, sellMaxSlots = 25,
    sellWhenFull = false, sellFullThread = nil,
    remote = nil, sellRemote = nil,
}
pcall(function()
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remotes then
        AutoShop.remote = remotes:FindFirstChild("ShopPurchaseRequest")
        AutoShop.sellRemote = remotes:FindFirstChild("ClientSellRequest")
    end
end)



do


local AimbotTab = Window:AddTab({ Name="Aimbot", Icon=Hyperion.Lucide.Target })

local AimCoreL = AimbotTab:AddSection({ Name="Core Settings", Side="Left", Group="Aimbot" })
local AimCoreR = AimbotTab:AddSection({ Name="Targeting",     Side="Right", Group="Aimbot" })

local FOVSec   = AimbotTab:AddSection({ Name="FOV Circle",  Side="Left",  Group="FOV & Trigger" })
local TrigSec  = AimbotTab:AddSection({ Name="Triggerbot",  Side="Right", Group="FOV & Trigger" })

AimCoreL:AddToggle({ Name="Enable Aimbot",   Default=false, Flag="aim_on",  Callback=function(v) Aim.Enabled=v end })
AimCoreL:AddToggle({ Name="Toggle Mode",     Default=false, Flag="aim_tg",  Callback=function(v) Aim.Toggle=v end })
AimCoreL:AddToggle({ Name="Auto Retarget",   Default=true,  Flag="aim_ar",  Callback=function(v) Aim.AutoRetarget=v end })

AimCoreL:AddToggle({ Name="Team Check",      Default=false, Flag="aim_tc",  Callback=function(v) Aim.TeamCheck=v end })
AimCoreL:AddToggle({ Name="Alive Check",     Default=true,  Flag="aim_ac",  Callback=function(v) Aim.AliveCheck=v end })
AimCoreL:AddToggle({ Name="Wall Check",      Default=false, Flag="aim_wc",  Callback=function(v) Aim.WallCheck=v end })

AimCoreL:AddToggle({ Name="Smoothing",       Default=true,  Flag="aim_sm",  Callback=function(v) Aim.Smoothing=v end })
AimCoreL:AddDropdown({ Name="Smooth Type", Values={"Linear","EaseIn","EaseOut","EaseInOut","Spring"}, Default="Linear", Flag="aim_smt",
    Callback=function(v) Aim.SmoothType=v end })
AimCoreL:AddSlider({ Name="Smooth Factor", Min=1, Max=100, Default=65, Decimals=0, Suffix="%", Flag="aim_smf",
    Callback=function(v) Aim.SmoothFactor=v/100 end })

AimCoreL:AddToggle({ Name="Prediction",     Default=true, Flag="aim_pr",  Callback=function(v) Aim.Prediction=v end })
AimCoreL:AddDropdown({ Name="Pred Mode",   Values={"Velocity","Gravity"}, Default="Velocity", Flag="aim_predm",
    Callback=function(v) Aim.PredMode=v end })
AimCoreL:AddSlider({ Name="Pred Strength", Min=0, Max=100, Default=15, Decimals=0, Suffix="%", Flag="aim_prs",
    Callback=function(v) Aim.PredStrength=v/100 end })

AimCoreR:AddDropdown({ Name="Lock Part",   Values={"Head","HumanoidRootPart","UpperTorso","Torso","LowerTorso"}, Default="Head",             Flag="aim_part", Callback=function(v) Aim.LockPart=v end })
AimCoreR:AddDropdown({ Name="Lock Mode",   Values={"CamLock","MouseMove","ThirdPersonMouse"},                    Default="ThirdPersonMouse", Flag="aim_mode", Callback=function(v) Aim.LockMode=v end })
AimCoreR:AddDropdown({ Name="Select Mode", Values={"ClosestToMouse","ClosestToCenter","LowestHealth","HighestHealth"}, Default="ClosestToMouse", Flag="aim_sel", Callback=function(v) Aim.SelectMode=v end })

AimCoreR:AddSlider({ Name="Max Distance", Min=100, Max=5000, Default=2000, Decimals=0, Suffix=" studs", Flag="aim_md",
    Callback=function(v) Aim.MaxDistance=v end })
AimCoreR:AddSlider({ Name="Sticky Time",  Min=1, Max=50, Default=15, Decimals=0, Suffix="x0.1s", Flag="aim_stkt",
    Callback=function(v) Aim.StickyTime=v/10 end })
AimCoreR:AddSlider({ Name="Offset X",     Min=-50, Max=50, Default=0, Decimals=0, Flag="aim_ox",
    Callback=function(v) Aim.OffsetX=v end })
AimCoreR:AddSlider({ Name="Offset Y",     Min=-50, Max=50, Default=0, Decimals=0, Flag="aim_oy",
    Callback=function(v) Aim.OffsetY=v end })

local _aimKeyOptions = {
    "Mouse1", "Mouse2", "Mouse3",
    "E", "F", "G", "H", "Q", "R", "T", "X", "Z",
    "LeftAlt", "RightAlt", "LeftControl", "RightControl",
    "CapsLock", "Tab",
}
local _aimKeyMap = {
    Mouse1       = Enum.UserInputType.MouseButton1,
    Mouse2       = Enum.UserInputType.MouseButton2,
    Mouse3       = Enum.UserInputType.MouseButton3,
    E            = Enum.KeyCode.E,
    F            = Enum.KeyCode.F,
    G            = Enum.KeyCode.G,
    H            = Enum.KeyCode.H,
    Q            = Enum.KeyCode.Q,
    R            = Enum.KeyCode.R,
    T            = Enum.KeyCode.T,
    X            = Enum.KeyCode.X,
    Z            = Enum.KeyCode.Z,
    LeftAlt      = Enum.KeyCode.LeftAlt,
    RightAlt     = Enum.KeyCode.RightAlt,
    LeftControl  = Enum.KeyCode.LeftControl,
    RightControl = Enum.KeyCode.RightControl,
    CapsLock     = Enum.KeyCode.CapsLock,
    Tab          = Enum.KeyCode.Tab,
}
Aim.TriggerKey     = Enum.UserInputType.MouseButton2
Aim.TriggerKeyType = "mouse"
Aim.TriggerKeyVal  = Enum.UserInputType.MouseButton2

AimCoreR:AddDropdown({ Name="Aim Key", Values=_aimKeyOptions, Default="Mouse2", Flag="aim_key_sel",
    Callback=function(v)
        local mapped = _aimKeyMap[v]
        if not mapped then return end
        if v == "Mouse1" or v == "Mouse2" or v == "Mouse3" then
            Aim.TriggerKeyType = "mouse"
        else
            Aim.TriggerKeyType = "key"
        end
        Aim.TriggerKeyVal = mapped
        Notify("Aimbot","Aim key set to: "..v,"Info",2)
    end })

FOVSec:AddToggle({ Name="Show FOV",   Default=true,  Flag="fov_show", Callback=function(v) Aim.FOVEnabled=v; Aim.FOVVisible=v end })
FOVSec:AddToggle({ Name="Aim Dot",    Default=false, Flag="fov_dot",  Callback=function(v) Aim.AimDotEnabled=v end })

FOVSec:AddSlider({ Name="FOV Radius",       Min=10,  Max=600, Default=90,  Decimals=0, Suffix="px", Flag="fov_r",  Callback=function(v) Aim.FOVRadius=v end })
FOVSec:AddSlider({ Name="FOV Transparency", Min=0,   Max=100, Default=80,  Decimals=0, Suffix="%",  Flag="fov_tr", Callback=function(v) Aim.FOVTransparency=v/100 end })
FOVSec:AddSlider({ Name="FOV Thickness",    Min=1,   Max=4,   Default=1,   Decimals=0,              Flag="fov_th", Callback=function(v) Aim.FOVThickness=v end })

FOVSec:AddColorPicker({ Name="FOV Color",    Default=Color3.fromRGB(255,255,255), Flag="fov_col", Callback=function(c) Aim.FOVColor=c end })
FOVSec:AddColorPicker({ Name="Locked Color", Default=Color3.fromRGB(255,100,100), Flag="fov_lc",  Callback=function(c) Aim.FOVLockedColor=c end })
FOVSec:AddColorPicker({ Name="Dot Color",    Default=Color3.fromRGB(255,255,255), Flag="fov_dc",  Callback=function(c) Aim.AimDotColor=c end })

FOVSec:AddToggle({ Name="Gradient Fill FOV", Default=false, Flag="fov_gfill",
    Callback=function(v) Aim.FOVGradFill=v end })
FOVSec:AddColorPicker({ Name="Fill Color Top",    Default=Color3.fromRGB(255,50,200),  Flag="fov_gct", Callback=function(c) Aim.FOVGradColorTop=c end })
FOVSec:AddColorPicker({ Name="Fill Color Bottom", Default=Color3.fromRGB(50,150,255),  Flag="fov_gcb", Callback=function(c) Aim.FOVGradColorBot=c end })
FOVSec:AddSlider({ Name="Fill Opacity Top",    Min=0, Max=100, Default=10, Decimals=0, Suffix="%", Flag="fov_gat",
    Callback=function(v) Aim.FOVGradAlphaTop=1-v/100 end })
FOVSec:AddSlider({ Name="Fill Opacity Bottom", Min=0, Max=100, Default=60, Decimals=0, Suffix="%", Flag="fov_gab",
    Callback=function(v) Aim.FOVGradAlphaBot=1-v/100 end })

FOVSec:AddToggle({ Name="FOV Watermark", Default=false, Flag="fov_wm",
    Callback=function(v) Aim.FOVWatermark=v end })
FOVSec:AddColorPicker({ Name="Watermark Color", Default=Color3.fromRGB(255,255,255), Flag="fov_wmc",
    Callback=function(c) Aim.FOVWatermarkColor=c end })
FOVSec:AddSlider({ Name="Watermark Size", Min=8, Max=24, Default=13, Decimals=0, Flag="fov_wms",
    Callback=function(v) Aim.FOVWatermarkSize=v end })

TrigSec:AddToggle({ Name="Enable Triggerbot", Default=false, Flag="trig_on", Callback=function(v) Aim.TriggerEnabled=v end })
TrigSec:AddToggle({ Name="Team Check",        Default=false, Flag="trig_tc", Callback=function(v) Aim.TriggerTeamCheck=v end })
TrigSec:AddToggle({ Name="Wall Check",        Default=false, Flag="trig_wc", Callback=function(v) Aim.TriggerWallCheck=v end })

TrigSec:AddSlider({ Name="Delay",           Min=0, Max=500, Default=50, Decimals=0, Suffix="ms", Flag="trig_del", Callback=function(v) Aim.TriggerDelay=v/1000 end })
TrigSec:AddSlider({ Name="Pixel Threshold", Min=5, Max=80,  Default=20, Decimals=0, Suffix="px", Flag="trig_px",  Callback=function(v) Aim.TriggerPixelThreshold=v end })

end

do

local RageTab = Window:AddTab({ Name="Rage", Icon=Hyperion.Lucide.Zap })

local RageSilentL = RageTab:AddSection({ Name="Silent Aim",  Side="Left",  Group="Silent Aim" })
local RageSilentR = RageTab:AddSection({ Name="Target Info", Side="Right", Group="Silent Aim" })
RageSilentL:AddToggle({ Name="Enable Silent Aim", Default=false, Flag="rage_on",
    Callback=function(v)
        Rage.Enabled=v
        if not _configLoading then
            Notify("Rage", v and "Silent Aim ON" or "Silent Aim OFF", v and "Success" or "Warning")
        end
    end })
RageSilentL:AddToggle({ Name="Wall Check", Default=true, Flag="rage_wc",
    Callback=function(v) Rage.VisibleCheck=v end })
RageSilentL:AddSlider({ Name="FOV Radius",  Min=50, Max=600, Default=150, Decimals=0, Suffix="px", Flag="rage_fov",
    Callback=function(v) Rage.FOV=v; RageFOV.Radius=v end })
RageSilentL:AddSlider({ Name="Hit Chance",  Min=0,  Max=100, Default=100, Decimals=0, Suffix="%",  Flag="rage_hc",
    Callback=function(v) Rage.HitChance=v end })
RageSilentL:AddSlider({ Name="Update Rate", Min=50, Max=500, Default=100, Decimals=0, Suffix="ms", Flag="rage_ur",
    Callback=function(v) Rage.UpdateRate=v/1000 end })
RageSilentL:AddColorPicker({ Name="FOV Color", Default=Color3.fromRGB(255,255,255), Flag="rage_fc",
    Callback=function(c) Rage.FOVColor=c; RageFOV.Color=c end })

RageSilentR:AddToggle({ Name="Show Target Info", Default=true, Flag="rage_si",  Callback=function(v) Rage.ShowTargetInfo=v end })
RageSilentR:AddToggle({ Name="Show Name",        Default=true, Flag="rage_sn",  Callback=function(v) Rage.ShowTargetName=v end })
RageSilentR:AddToggle({ Name="Show HP",          Default=true, Flag="rage_shp", Callback=function(v) Rage.ShowTargetHP=v end })
RageSilentR:AddToggle({ Name="Show Distance",    Default=true, Flag="rage_sd",  Callback=function(v) Rage.ShowTargetDistance=v end })
RageSilentR:AddToggle({ Name="Show Hit Chance",  Default=true, Flag="rage_shc", Callback=function(v) Rage.ShowHitChance=v end })
RageSilentR:AddToggle({ Name="Highlight Target", Default=false,Flag="rage_hl",  Callback=function(v) Rage.HighlightTarget=v end })

local WepModL = RageTab:AddSection({ Name="Weapon Mods", Side="Left",  Group="Weapon Mods" })
local WepModR = RageTab:AddSection({ Name="Info",        Side="Right", Group="Weapon Mods" })

WepModL:AddToggle({ Name="No Spread", Default=false, Flag="wm_ns",
    Callback=function(v)
        WeaponMods.NoSpread = v
        if not _configLoading then WM_PatchAll(); Notify("Weapons", v and "No Spread ON" or "No Spread OFF", v and "Success" or "Warning") end
    end })

WepModL:AddToggle({ Name="No Recoil", Default=false, Flag="wm_nrc",
    Callback=function(v)
        WeaponMods.NoRecoil = v
        if not _configLoading then WM_PatchAll(); Notify("Weapons", v and "No Recoil ON" or "No Recoil OFF", v and "Success" or "Warning") end
    end })

WepModL:AddToggle({ Name="Instant Reload", Default=false, Flag="wm_nr",
    Callback=function(v)
        WeaponMods.NoReload = v
        if not _configLoading then WM_PatchAll(); Notify("Weapons", v and "Instant Reload ON" or "Instant Reload OFF", v and "Success" or "Warning") end
    end })

WepModL:AddToggle({ Name="Instant ADS", Default=false, Flag="wm_ias",
    Callback=function(v)
        WeaponMods.InstantADS = v
        if not _configLoading then WM_PatchAll(); Notify("Weapons", v and "Instant ADS ON" or "Instant ADS OFF", v and "Success" or "Warning") end
    end })

WepModL:AddToggle({ Name="Rapid Fire", Default=false, Flag="wm_rf",
    Callback=function(v)
        WeaponMods.RapidFire = v
        if not _configLoading then WM_PatchAll(); Notify("Weapons", v and "Rapid Fire ON" or "Rapid Fire OFF", v and "Success" or "Warning") end
    end })

WepModL:AddSlider({ Name="Rapid Fire Multiplier", Min=1, Max=10, Default=1.5, Decimals=1, Suffix="x", Flag="wm_rfm",
    Callback=function(v)
        WeaponMods.RapidMult = v
        if not _configLoading and WeaponMods.RapidFire then WM_PatchAll() end
    end })

WepModL:AddToggle({ Name="Incendiary Bullets", Default=false, Flag="wm_inc",
    Callback=function(v)
        WeaponMods.Incendiary = v
        if not _configLoading then WM_PatchAll(); Notify("Weapons", v and "Incendiary ON" or "Incendiary OFF", v and "Success" or "Warning") end
    end })

WepModR:AddInfobox({ Title="Note", Text="You must reset your character to apply weapon mods.", Type="Warning" })

local KillAuraSec = RageTab:AddSection({ Name="Kill Aura", Side="Left", Group="Kill Aura" })
local KillAuraInfo = RageTab:AddSection({ Name="Info", Side="Right", Group="Kill Aura" })

local _kaToggle = KillAuraSec:AddToggle({ Name="Enable Kill Aura", Default=false, Flag="ka_on",
    Callback=function(v)
        KillAura.Enabled = v
        if not _configLoading then
            if v and not _killAuraLastModule then
                Notify("Kill Aura","Equip a weapon first so the script can capture stats.","Warning",4)
            else
                Notify("Kill Aura", v and "ON" or "OFF", v and "Success" or "Warning")
            end
        end
    end })
KillAuraSec:AddToggle({ Name="Require Tool Equipped", Default=true, Flag="ka_rt",
    Callback=function(v) KillAura.RequireTool = v end })
KillAuraSec:AddSlider({ Name="Range", Min=10, Max=2000, Default=300, Decimals=0, Suffix=" studs", Flag="ka_rng",
    Callback=function(v) KillAura.Range = v end })
KillAuraSec:AddDropdown({ Name="Damage Type", Values={"Gun","Melee"}, Default="Gun", Flag="ka_dt",
    Callback=function(v) KillAura.DamageType = v end })
KillAuraSec:AddKeybind({ Name="Kill Aura Keybind", Default=Enum.KeyCode.K, Flag="ka_kb",
    Callback=function()
        local newVal = not KillAura.Enabled
        local ok = pcall(function() _kaToggle:Set(newVal) end)
        if not ok then
            KillAura.Enabled = newVal
            Notify("Kill Aura", newVal and "ON" or "OFF", newVal and "Success" or "Warning")
        end
    end })

KillAuraInfo:AddInfobox({ Title="Note", Text="You must hold out a weapon.", Type="Warning" })

end


local _uiRefs = {}
do

local VisualsTab = Window:AddTab({ Name="Visuals", Icon=Hyperion.Lucide.Eye })

local ESPLeft      = VisualsTab:AddSection({ Name="ESP Toggles",  Side="Left",  Group="Player ESP" })
local ESPRight     = VisualsTab:AddSection({ Name="ESP Settings", Side="Right", Group="Player ESP" })
local KitESPLeft   = VisualsTab:AddSection({ Name="Kit ESP",        Side="Left",  Group="Kit ESP" })
local KitESPRight  = VisualsTab:AddSection({ Name="Kit ESP Colors", Side="Right", Group="Kit ESP" })

ESPLeft:AddToggle({ Name="Enable ESP",      Default=ESP.Enabled,                     Flag="esp_on",   Callback=function(v) ESP.Enabled=v end })
ESPLeft:AddToggle({ Name="Team Check",      Default=ESP.TeamCheck,                   Flag="esp_tc2",  Callback=function(v) ESP.TeamCheck=v end })

_uiRefs.Names    = ESPLeft:AddToggle({ Name="Names",           Default=ESP.Drawing.Names.Enabled,        Flag="esp_names",Callback=function(v) ESP.Drawing.Names.Enabled=v end })
ESPLeft:AddToggle({ Name="Skeleton",        Default=ESP.Drawing.Skeleton.Enabled,    Flag="esp_skel", Callback=function(v) ESP.Drawing.Skeleton.Enabled=v end })
ESPLeft:AddToggle({ Name="Tracers",         Default=ESP.Drawing.Tracers.Enabled,     Flag="esp_trac", Callback=function(v) ESP.Drawing.Tracers.Enabled=v end })
_uiRefs.BoxFill  = ESPLeft:AddToggle({ Name="Box Fill",        Default=ESP.Drawing.Boxes.Filled.Enabled,  Flag="esp_fill", Callback=function(v) ESP.Drawing.Boxes.Filled.Enabled=v end })
_uiRefs.Healthbar= ESPLeft:AddToggle({ Name="Healthbar",       Default=ESP.Drawing.Healthbar.Enabled,     Flag="esp_hbar", Callback=function(v) ESP.Drawing.Healthbar.Enabled=v end })
_uiRefs.HealthText=ESPLeft:AddToggle({ Name="Health Text",     Default=ESP.Drawing.Healthbar.HealthText,  Flag="esp_ht",   Callback=function(v) ESP.Drawing.Healthbar.HealthText=v end })
_uiRefs.Distances= ESPLeft:AddToggle({ Name="Distances",       Default=ESP.Drawing.Distances.Enabled,     Flag="esp_dist", Callback=function(v) ESP.Drawing.Distances.Enabled=v end })
_uiRefs.Chams    = ESPLeft:AddToggle({ Name="Chams",           Default=ESP.Drawing.Chams.Enabled,         Flag="esp_cham", Callback=function(v) ESP.Drawing.Chams.Enabled=v end })

ESPLeft:AddToggle({ Name="Rainbow Mode",    Default=ESP.Rainbow,                      Flag="esp_rb",   Callback=function(v) ESP.Rainbow=v end })
ESPLeft:AddSlider({ Name="Rainbow Speed",   Min=1, Max=10, Default=ESP.RainbowSpeed, Decimals=0,      Flag="esp_rbs",  Callback=function(v) ESP.RainbowSpeed=v end })

ESPLeft:AddToggle({ Name="Thermal Breathing",  Default=ESP.Drawing.Chams.Thermal,       Flag="esp_ct",  Callback=function(v) ESP.Drawing.Chams.Thermal=v end })
ESPLeft:AddToggle({ Name="Chams Visible Check",Default=ESP.Drawing.Chams.VisibleCheck,  Flag="esp_cv",  Callback=function(v) ESP.Drawing.Chams.VisibleCheck=v end })
ESPLeft:AddToggle({ Name="Animate Fill",       Default=ESP.Drawing.Boxes.Animate,       Flag="esp_ag",  Callback=function(v) ESP.Drawing.Boxes.Animate=v end })

ESPLeft:AddButton({ Name="Refresh ESP", Icon=Hyperion.Lucide.RefreshCw,
    Callback=function()
        local toClean = {}
        for plr in pairs(ActiveESP) do table.insert(toClean, plr) end
        for _, plr in ipairs(toClean) do CleanupESP(plr) end
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then InitializeESP(p) end end
        Notify("ESP","Refreshed.","Success")
    end })

ESPRight:AddSlider({ Name="Max Distance",    Min=0, Max=10000, Default=ESP.MaxDistance, Decimals=0,    Flag="esp_md",   Callback=function(v) ESP.MaxDistance=v end })

_uiRefs.BoxType = ESPRight:AddDropdown({ Name="Box Type",          Values={"None","Box","Corner"},    Default="None",   Flag="esp_bm",
    Callback=function(v)
        ESP.Drawing.Boxes.Full.Enabled   = (v == "Box")
        ESP.Drawing.Boxes.Corner.Enabled = (v == "Corner")
    end })
ESPRight:AddDropdown({ Name="Distance Position", Values={"Text","Bottom"},           Default=ESP.Drawing.Distances.Position, Flag="esp_dp",
    Callback=function(v) ESP.Drawing.Distances.Position=v end })
ESPRight:AddDropdown({ Name="Tracer Origin",     Values={"Bottom","Center","Mouse"}, Default="Mouse",                        Flag="esp_to",
    Callback=function(v) ESP.Drawing.Tracers.Origin=v end })
ESPRight:AddDropdown({ Name="Health Gradient",
    Values={"Default","Viper","Miami","Monochrome","Sunset","Ocean","Toxic","Blood","Ice","Gold","Candy","Neon"},
    Default="Default", Flag="esp_hg",
    Callback=function(v)
        local gradients = {
            ["Default"]     = {Color3.fromRGB(200,0,0),    Color3.fromRGB(60,60,125),    Color3.fromRGB(119,120,255)},
            ["Viper"]       = {Color3.fromRGB(255,0,0),    Color3.fromRGB(255,255,0),    Color3.fromRGB(0,255,0)},
            ["Miami"]       = {Color3.fromRGB(255,0,150),   Color3.fromRGB(150,50,200),   Color3.fromRGB(0,200,255)},
            ["Monochrome"]  = {Color3.fromRGB(50,50,50),    Color3.fromRGB(150,150,150),  Color3.fromRGB(255,255,255)},
            ["Sunset"]      = {Color3.fromRGB(20,0,80),     Color3.fromRGB(200,50,0),     Color3.fromRGB(255,200,0)},
            ["Ocean"]       = {Color3.fromRGB(0,0,80),      Color3.fromRGB(0,100,200),    Color3.fromRGB(0,220,255)},
            ["Toxic"]       = {Color3.fromRGB(10,40,0),     Color3.fromRGB(80,200,0),     Color3.fromRGB(180,255,50)},
            ["Blood"]       = {Color3.fromRGB(20,0,0),      Color3.fromRGB(120,0,0),      Color3.fromRGB(220,20,20)},
            ["Ice"]         = {Color3.fromRGB(0,30,80),     Color3.fromRGB(100,180,255),  Color3.fromRGB(220,245,255)},
            ["Gold"]        = {Color3.fromRGB(80,30,0),     Color3.fromRGB(200,130,0),    Color3.fromRGB(255,220,50)},
            ["Candy"]       = {Color3.fromRGB(180,0,100),   Color3.fromRGB(255,100,150),  Color3.fromRGB(255,200,230)},
            ["Neon"]        = {Color3.fromRGB(150,0,255),   Color3.fromRGB(0,255,150),    Color3.fromRGB(255,255,0)},
        }
        local g = gradients[v]
        if g then
            ESP.Drawing.Healthbar.GradientSequence = ColorSequence.new{
                ColorSequenceKeypoint.new(0, g[1]), ColorSequenceKeypoint.new(0.5, g[2]), ColorSequenceKeypoint.new(1, g[3])
            }
        end
    end })

ESPRight:AddSlider({ Name="Healthbar Width",   Min=1, Max=10,   Default=ESP.Drawing.Healthbar.Width,      Decimals=0, Flag="esp_hw",  Callback=function(v) ESP.Drawing.Healthbar.Width=v end })
ESPRight:AddSlider({ Name="Skeleton Thickness",Min=1, Max=5,    Default=ESP.Drawing.Skeleton.Thickness,   Decimals=0, Flag="esp_st",  Callback=function(v) ESP.Drawing.Skeleton.Thickness=v end })
ESPRight:AddSlider({ Name="Tracer Thickness",  Min=1, Max=5,    Default=ESP.Drawing.Tracers.Thickness,    Decimals=0, Flag="esp_tt",  Callback=function(v) ESP.Drawing.Tracers.Thickness=v end })
ESPRight:AddSlider({ Name="Rotation Speed",    Min=0, Max=1000, Default=ESP.Drawing.Boxes.RotationSpeed,  Decimals=0, Flag="esp_rs",  Callback=function(v) ESP.Drawing.Boxes.RotationSpeed=v end })
ESPRight:AddSlider({ Name="Fill Transparency", Min=0, Max=100,  Default=ESP.Drawing.Boxes.Filled.Transparency*100, Decimals=0, Flag="esp_ft",
    Callback=function(v) ESP.Drawing.Boxes.Filled.Transparency=v/100 end })

local _espPresets = {
    ["Default"]     = { c1=Color3.fromRGB(200,0,0),   c2=Color3.fromRGB(60,60,125),  c3=Color3.fromRGB(119,120,255) },
    ["Viper"]       = { c1=Color3.fromRGB(255,0,0),   c2=Color3.fromRGB(255,255,0),  c3=Color3.fromRGB(0,255,0) },
    ["Miami"]       = { c1=Color3.fromRGB(255,0,150),  c2=Color3.fromRGB(150,50,200), c3=Color3.fromRGB(0,200,255) },
    ["Monochrome"]  = { c1=Color3.fromRGB(50,50,50),   c2=Color3.fromRGB(150,150,150),c3=Color3.fromRGB(255,255,255) },
    ["Sunset"]      = { c1=Color3.fromRGB(20,0,80),    c2=Color3.fromRGB(200,50,0),   c3=Color3.fromRGB(255,200,0) },
    ["Ocean"]       = { c1=Color3.fromRGB(0,0,80),     c2=Color3.fromRGB(0,100,200),  c3=Color3.fromRGB(0,220,255) },
    ["Toxic"]       = { c1=Color3.fromRGB(10,40,0),    c2=Color3.fromRGB(80,200,0),   c3=Color3.fromRGB(180,255,50) },
    ["Blood"]       = { c1=Color3.fromRGB(20,0,0),     c2=Color3.fromRGB(120,0,0),    c3=Color3.fromRGB(220,20,20) },
    ["Ice"]         = { c1=Color3.fromRGB(0,30,80),    c2=Color3.fromRGB(100,180,255),c3=Color3.fromRGB(220,245,255) },
    ["Gold"]        = { c1=Color3.fromRGB(80,30,0),    c2=Color3.fromRGB(200,130,0),  c3=Color3.fromRGB(255,220,50) },
    ["Candy"]       = { c1=Color3.fromRGB(180,0,100),  c2=Color3.fromRGB(255,100,150),c3=Color3.fromRGB(255,200,230) },
    ["Neon"]        = { c1=Color3.fromRGB(150,0,255),  c2=Color3.fromRGB(0,255,150),  c3=Color3.fromRGB(255,255,0) },
}
local _selectedPreset = "Default"
local _presetNames = {"Default","Viper","Miami","Monochrome","Sunset","Ocean","Toxic","Blood","Ice","Gold","Candy","Neon"}


local function ApplyESPPreset(name)
    local p = _espPresets[name]; if not p then return end
    ESP.Drawing.Names.Enabled          = true
    ESP.Drawing.Boxes.Filled.Enabled   = true
    ESP.Drawing.Healthbar.Enabled      = true
    ESP.Drawing.Healthbar.HealthText   = true
    ESP.Drawing.Distances.Enabled      = true
    ESP.Drawing.Chams.Enabled          = true
    ESP.Drawing.Boxes.Full.Enabled     = true
    ESP.Drawing.Boxes.Corner.Enabled   = false
    ESP.Drawing.Boxes.Full.RGB          = p.c3
    ESP.Drawing.Boxes.Corner.RGB        = p.c3
    ESP.Drawing.Boxes.GradientFillRGB1  = p.c1
    ESP.Drawing.Boxes.GradientFillRGB2  = p.c3
    ESP.Drawing.Boxes.GradientRGB1      = p.c1
    ESP.Drawing.Boxes.GradientRGB2      = p.c3
    ESP.Drawing.Boxes.Filled.RGB        = p.c2
    ESP.Drawing.Names.RGB               = p.c3
    ESP.Drawing.Distances.RGB           = p.c3
    ESP.Drawing.Healthbar.HealthTextRGB = p.c3
    ESP.Drawing.Skeleton.RGB            = p.c3
    ESP.Drawing.Tracers.RGB             = p.c3
    ESP.Drawing.Chams.FillRGB           = p.c1
    ESP.Drawing.Chams.OutlineRGB        = p.c3
    ESP.Drawing.Healthbar.GradientSequence = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   p.c1),
        ColorSequenceKeypoint.new(0.5, p.c2),
        ColorSequenceKeypoint.new(1,   p.c3),
    }
    pcall(function() _uiRefs.Names:Set(true) end)
    pcall(function() _uiRefs.BoxFill:Set(true) end)
    pcall(function() _uiRefs.Healthbar:Set(true) end)
    pcall(function() _uiRefs.HealthText:Set(true) end)
    pcall(function() _uiRefs.Distances:Set(true) end)
    pcall(function() _uiRefs.Chams:Set(true) end)
    pcall(function() _uiRefs.BoxType:Set("Box") end)
    pcall(function() _uiRefs.BoxColor:Set(p.c3) end)
    pcall(function() _uiRefs.BoxFillColor:Set(p.c2) end)
    pcall(function() _uiRefs.GradFill1:Set(p.c1) end)
    pcall(function() _uiRefs.GradFill2:Set(p.c3) end)
    pcall(function() _uiRefs.OutlineGrad1:Set(p.c1) end)
    pcall(function() _uiRefs.OutlineGrad2:Set(p.c3) end)
    pcall(function() _uiRefs.NameColor:Set(p.c3) end)
    pcall(function() _uiRefs.DistColor:Set(p.c3) end)
    pcall(function() _uiRefs.HealthTextColor:Set(p.c3) end)
    pcall(function() _uiRefs.SkelColor:Set(p.c3) end)
    pcall(function() _uiRefs.TracerColor:Set(p.c3) end)
    pcall(function() _uiRefs.ChamsFill:Set(p.c1) end)
    pcall(function() _uiRefs.ChamsOutline:Set(p.c3) end)
    Notify("ESP Preset", name .. " applied.", "Success", 2)
end

ESPRight:AddDropdown({ Name="ESP Preset", Values=_presetNames, Default="Default", Flag="esp_preset",
    Callback=function(v) _selectedPreset=v end })
ESPRight:AddButton({ Name="Apply Preset", Icon=Hyperion.Lucide.Palette,
    Callback=function() ApplyESPPreset(_selectedPreset) end })

ESPRight:AddColorPicker({ Name="Friend Color",        Default=ESP.Options.FriendcheckRGB,          Flag="esp_fc",  Callback=function(c) ESP.Options.FriendcheckRGB=c end })
ESPRight:AddColorPicker({ Name="Enemy Color",         Default=ESP.Options.HighlightRGB,            Flag="esp_ec",  Callback=function(c) ESP.Options.HighlightRGB=c end })
_uiRefs.NameColor        = ESPRight:AddColorPicker({ Name="Name Text Color",     Default=ESP.Drawing.Names.RGB,               Flag="esp_nc",  Callback=function(c) ESP.Drawing.Names.RGB=c end })
_uiRefs.DistColor        = ESPRight:AddColorPicker({ Name="Distance Text Color", Default=ESP.Drawing.Distances.RGB,           Flag="esp_dc",  Callback=function(c) ESP.Drawing.Distances.RGB=c end })
_uiRefs.HealthTextColor  = ESPRight:AddColorPicker({ Name="Health Text Color",   Default=ESP.Drawing.Healthbar.HealthTextRGB, Flag="esp_htc", Callback=function(c) ESP.Drawing.Healthbar.HealthTextRGB=c end })
_uiRefs.BoxColor         = ESPRight:AddColorPicker({ Name="Box Color",           Default=ESP.Drawing.Boxes.Full.RGB,          Flag="esp_bc",  Callback=function(c) ESP.Drawing.Boxes.Full.RGB=c; ESP.Drawing.Boxes.Corner.RGB=c end })
_uiRefs.BoxFillColor     = ESPRight:AddColorPicker({ Name="Box Fill Color",      Default=ESP.Drawing.Boxes.Filled.RGB,        Flag="esp_bfc", Callback=function(c) ESP.Drawing.Boxes.Filled.RGB=c end })
_uiRefs.GradFill1        = ESPRight:AddColorPicker({ Name="Gradient Fill 1",     Default=ESP.Drawing.Boxes.GradientFillRGB1,  Flag="esp_gf1", Callback=function(c) ESP.Drawing.Boxes.GradientFillRGB1=c end })
_uiRefs.GradFill2        = ESPRight:AddColorPicker({ Name="Gradient Fill 2",     Default=ESP.Drawing.Boxes.GradientFillRGB2,  Flag="esp_gf2", Callback=function(c) ESP.Drawing.Boxes.GradientFillRGB2=c end })
_uiRefs.OutlineGrad1     = ESPRight:AddColorPicker({ Name="Outline Gradient 1",  Default=ESP.Drawing.Boxes.GradientRGB1,      Flag="esp_og1", Callback=function(c) ESP.Drawing.Boxes.GradientRGB1=c end })
_uiRefs.OutlineGrad2     = ESPRight:AddColorPicker({ Name="Outline Gradient 2",  Default=ESP.Drawing.Boxes.GradientRGB2,      Flag="esp_og2", Callback=function(c) ESP.Drawing.Boxes.GradientRGB2=c end })
_uiRefs.SkelColor        = ESPRight:AddColorPicker({ Name="Skeleton Color",      Default=ESP.Drawing.Skeleton.RGB,            Flag="esp_sc",  Callback=function(c) ESP.Drawing.Skeleton.RGB=c end })
_uiRefs.TracerColor      = ESPRight:AddColorPicker({ Name="Tracer Color",        Default=ESP.Drawing.Tracers.RGB,             Flag="esp_tc",  Callback=function(c) ESP.Drawing.Tracers.RGB=c end })

KitESPLeft:AddToggle({ Name="Enable Kit ESP",     Default=false, Flag="kit_on",
    Callback=function(v) KitESP.Enabled=v; if not v then kitRemoveAll() end; Notify("Kit ESP",v and "ON" or "OFF","Info") end })
KitESPLeft:AddToggle({ Name="Highlight",          Default=true,  Flag="kit_hl",  Callback=function(v) KitESP.HighlightEnabled=v end })
KitESPLeft:AddToggle({ Name="Label",              Default=true,  Flag="kit_lbl", Callback=function(v) KitESP.LabelEnabled=v end })
KitESPLeft:AddToggle({ Name="Distance",           Default=true,  Flag="kit_dst", Callback=function(v) KitESP.DistEnabled=v end })
KitESPLeft:AddSlider({ Name="Max Distance", Min=100, Max=5000, Default=2000, Decimals=0, Suffix=" studs", Flag="kit_md",
    Callback=function(v) KitESP.MaxDistance=v end })
KitESPLeft:AddSlider({ Name="Fill Transparency", Min=0, Max=90, Default=30, Decimals=0, Suffix="%", Flag="kit_tr",
    Callback=function(v) KitESP.FillTransparency=v/100 end })

KitESPRight:AddColorPicker({ Name="Fill Color",    Default=Color3.fromRGB(255,215,0),   Flag="kit_fc",  Callback=function(c) KitESP.FillColor=c end })
KitESPRight:AddColorPicker({ Name="Outline Color", Default=Color3.fromRGB(255,255,255), Flag="kit_oc",  Callback=function(c) KitESP.OutlineColor=c end })
KitESPRight:AddButton({ Name="Debug Scan", Icon=Hyperion.Lucide.Search,
    Callback=function()
        local folder = kitFindFolder()
        if not folder then
            Notify("Kit ESP","game_setup NOT FOUND anywhere in game","Error",5); return
        end
        local count = 0
        for _, obj in ipairs(folder:GetChildren()) do
            if kitIsKit(obj) then count = count + 1 end
        end
        Notify("Kit ESP","Found @ "..folder:GetFullName().." | kits: "..count, count>0 and "Success" or "Error", 6)
    end })

end

do

local MiscTab = Window:AddTab({ Name="Misc", Icon=Hyperion.Lucide.Sliders })

local MiscMoveL    = MiscTab:AddSection({ Name="Movement",       Side="Left",  Group="Player" })
local MiscCrossR   = MiscTab:AddSection({ Name="Crosshair",      Side="Right", Group="Player" })
local MiscTracersL = MiscTab:AddSection({ Name="Bullet Tracers", Side="Left",  Group="Tracers" })
local MiscMineL    = MiscTab:AddSection({ Name="Auto Mine",      Side="Right", Group="Auto Mine" })
local MiscMineR    = MiscTab:AddSection({ Name="Info",           Side="Right", Group="Auto Mine" })

local _amToggle = MiscMineL:AddToggle({ Name="Enable Auto Mine", Default=false, Flag="am_on",
    Callback=function(v)
        AutoMine.Enabled = v
        if not _configLoading then Notify("Auto Mine", v and "ON" or "OFF", v and "Success" or "Warning") end
    end })
MiscMineL:AddToggle({ Name="Mine Basalt", Default=true, Flag="am_basalt",
    Callback=function(v) AutoMine.MineBasalt = v end })
MiscMineL:AddToggle({ Name="Ignore Mining Floor", Default=true, Flag="am_floor",
    Callback=function(v) AutoMine.IgnoreFloor = v end })
MiscMineL:AddSlider({ Name="Range", Min=5, Max=200, Default=40, Decimals=0, Suffix=" studs", Flag="am_rng",
    Callback=function(v) AutoMine.Range = v end })
MiscMineL:AddKeybind({ Name="Auto Mine Keybind", Default=Enum.KeyCode.M, Flag="am_kb",
    Callback=function()
        local newVal = not AutoMine.Enabled
        local ok = pcall(function() _amToggle:Set(newVal) end)
        if not ok then
            AutoMine.Enabled = newVal
            Notify("Auto Mine", newVal and "ON" or "OFF", newVal and "Success" or "Warning")
        end
    end })

MiscMineR:AddInfobox({ Title="Note", Text="You must be holding a pick or pickaxe for auto mine to work.", Type="Info" })

MiscMoveL:AddToggle({ Name="Fly",    Default=false, Flag="fly_on",
    Callback=function(v) Move.Fly=v; if not _configLoading then if v then EnableFly() else DisableFly() end; Notify("Fly",v and "ON" or "OFF","Info") end end })
MiscMoveL:AddToggle({ Name="Noclip", Default=false, Flag="nc_on",
    Callback=function(v) Move.Noclip=v; if not _configLoading then Notify("Noclip",v and "ON" or "OFF","Info") end end })

MiscMoveL:AddSlider({ Name="Fly Speed",  Min=10, Max=300, Default=50, Decimals=0, Flag="fly_spd", Callback=function(v) Move.FlySpeed=v end })
MiscMoveL:AddSlider({ Name="Walk Speed", Min=16, Max=250, Default=16, Decimals=0, Flag="ws",      Callback=function(v) if Hum then Hum.WalkSpeed=v end end })

MiscMoveL:AddKeybind({ Name="Fly Keybind",    Default=Enum.KeyCode.H, Flag="fly_kb",
    Callback=function() if Move.Fly then DisableFly(); Notify("Fly","OFF","Info") else EnableFly(); Notify("Fly","ON","Info") end end })
MiscMoveL:AddKeybind({ Name="Noclip Keybind", Default=Enum.KeyCode.V, Flag="nc_kb",
    Callback=function() Move.Noclip=not Move.Noclip; Notify("Noclip",Move.Noclip and "ON" or "OFF","Info") end })

MiscMoveL:AddToggle({ Name="Spinbot", Default=false, Flag="spin_on",
    Callback=function(v) Rage.Spinbot=v; if not _configLoading then if v then SpinbotStart() else SpinbotStop() end; Notify("Movement","Spinbot "..(v and "ON" or "OFF"),"Info") end end })
MiscMoveL:AddSlider({ Name="Spin Speed", Min=1, Max=100, Default=20, Decimals=0, Flag="spin_spd",
    Callback=function(v) Rage.SpinSpeed=v; if _spinBAV then _spinBAV.AngularVelocity=Vector3.new(0,v,0) end end })

MiscMoveL:AddToggle({ Name="TP Walk", Default=false, Flag="tpw_on",
    Callback=function(v) Rage.TPWalk=v; if not _configLoading then Notify("Movement","TP Walk "..(v and "ON" or "OFF"),"Info") end end })
MiscMoveL:AddSlider({ Name="TP Walk Speed", Min=5, Max=100, Default=17, Decimals=0, Flag="tpw_spd",
    Callback=function(v) Rage.TPWalkSpeed=v/10 end })

MiscCrossR:AddToggle({ Name="Enabled",        Default=false, Flag="cross_on",  Callback=function(v) Cross.Enabled=v end })
MiscCrossR:AddToggle({ Name="Dynamic Spread", Default=false, Flag="cross_dyn", Callback=function(v) Cross.Dynamic=v end })
MiscCrossR:AddToggle({ Name="Rotate",         Default=false, Flag="cross_rot", Callback=function(v) Cross.Rotate=v end })
MiscCrossR:AddToggle({ Name="Rainbow",        Default=false, Flag="cross_rb",  Callback=function(v) Cross.RainbowColor=v end })

MiscCrossR:AddDropdown({ Name="Style",    Values={"Classic","T-Style","Circle","Dot"}, Default="Classic", Flag="cross_sty",
    Callback=function(v) Cross.Style=v; Cross.TStyle=(v=="T-Style") end })
MiscCrossR:AddDropdown({ Name="Position", Values={"Mouse","Center"},                   Default="Mouse",   Flag="cross_pos",
    Callback=function(v) Cross.Position=v=="Mouse" and 1 or 2 end })
MiscCrossR:AddSlider({ Name="Size",           Min=2,  Max=40, Default=12, Decimals=0, Flag="cross_sz",  Callback=function(v) Cross.Size=v end })
MiscCrossR:AddSlider({ Name="Gap",            Min=0,  Max=24, Default=6,  Decimals=0, Flag="cross_gap", Callback=function(v) Cross.GapSize=v end })
MiscCrossR:AddSlider({ Name="Thickness",      Min=1,  Max=6,  Default=1,  Decimals=0, Flag="cross_thk", Callback=function(v) Cross.Thickness=v end })
MiscCrossR:AddSlider({ Name="Rotation Speed", Min=1,  Max=20, Default=5,  Decimals=0, Flag="cross_rs",  Callback=function(v) Cross.RotationSpeed=v end })

MiscCrossR:AddToggle({ Name="Center Dot",  Default=true, Flag="cross_cd", Callback=function(v) Cross.CenterDotEnabled=v end })
MiscCrossR:AddToggle({ Name="Dot Filled",  Default=true, Flag="cross_df", Callback=function(v) Cross.CenterDotFilled=v end })
MiscCrossR:AddToggle({ Name="Inner Lines", Default=false,Flag="cross_il", Callback=function(v) Cross.InnerEnabled=v end })
MiscCrossR:AddSlider({ Name="Dot Radius",  Min=1, Max=10, Default=2, Decimals=0, Flag="cross_dr", Callback=function(v) Cross.CenterDotRadius=v end })
MiscCrossR:AddSlider({ Name="Inner Size",  Min=1, Max=16, Default=4, Decimals=0, Flag="cross_is", Callback=function(v) Cross.InnerSize=v end })
MiscCrossR:AddSlider({ Name="Inner Gap",   Min=0, Max=10, Default=2, Decimals=0, Flag="cross_ig", Callback=function(v) Cross.InnerGap=v end })

MiscCrossR:AddToggle({ Name="Outline",       Default=true, Flag="cross_ol", Callback=function(v) Cross.Outline=v end })
MiscCrossR:AddColorPicker({ Name="Color",         Default=Color3.fromRGB(255,255,255), Flag="cross_col", Callback=function(c) Cross.Color=c end })
MiscCrossR:AddColorPicker({ Name="Outline Color", Default=Color3.fromRGB(255,255,255), Flag="cross_oc",  Callback=function(c) Cross.OutlineColor=c end })
MiscCrossR:AddColorPicker({ Name="Dot Color",     Default=Color3.fromRGB(255,255,255), Flag="cross_dc",  Callback=function(c) Cross.CenterDotColor=c end })

MiscTracersL:AddToggle({ Name="Enable Tracers", Default=false, Flag="bt_on",
    Callback=function(v)
        BulletTracers.Enabled=v
        if v and not _configLoading then task.spawn(function()
            task.wait(0.2); local cf=Camera.CFrame
            SpawnBeamTracer(cf.Position+cf.LookVector*3, cf.Position+cf.LookVector*100)
            Notify("Tracers","Test tracer fired!","Info")
        end) end
    end })
MiscTracersL:AddToggle({ Name="Rainbow",      Default=false, Flag="bt_rb", Callback=function(v) BulletTracers.Rainbow=v end })
MiscTracersL:AddToggle({ Name="Impact Flash", Default=true,  Flag="bt_if", Callback=function(v) BulletTracers.ImpactFlash=v end })

MiscTracersL:AddDropdown({ Name="Mode",     Values={"Beam","Lightning","Helix"},  Default="Beam", Flag="bt_mode",  Callback=function(v) BulletTracers.Mode=v end })
MiscTracersL:AddDropdown({ Name="Material", Values={"Neon","ForceField","Glass"}, Default="Neon", Flag="bt_mat",   Callback=function(v) BulletTracers.Material=v end })
MiscTracersL:AddSlider({ Name="Thickness",   Min=1, Max=8,  Default=2,  Decimals=0, Flag="bt_thick",  Callback=function(v) BulletTracers.Thickness=v end })
MiscTracersL:AddSlider({ Name="Glow Size",   Min=1, Max=8,  Default=3,  Decimals=0, Flag="bt_glow",   Callback=function(v) BulletTracers.GlowSize=v end })
MiscTracersL:AddSlider({ Name="Fade Time",   Min=2, Max=30, Default=12, Decimals=0, Suffix="x0.1s",   Flag="bt_fade",   Callback=function(v) BulletTracers.FadeTime=v/10 end })
MiscTracersL:AddSlider({ Name="Impact Size", Min=1, Max=20, Default=5,  Decimals=0, Suffix="x0.1",    Flag="bt_isize",  Callback=function(v) BulletTracers.ImpactSize=v/10 end })
MiscTracersL:AddColorPicker({ Name="Color",      Default=Color3.fromRGB(140,80,255), Flag="bt_col",  Callback=function(c) BulletTracers.Color=c end })
MiscTracersL:AddColorPicker({ Name="Glow Color", Default=Color3.fromRGB(80,40,220),  Flag="bt_gcol", Callback=function(c) BulletTracers.GlowColor=c end })



end

do

local SettingsTab = Window:AddTab({ Name="Settings", Icon=Hyperion.Lucide.Settings })
local ThemeSec    = SettingsTab:AddSection({ Name="Themes", Side="Left",  Group="Appearance" })
local SystemSec   = SettingsTab:AddSection({ Name="System", Side="Right", Group="Appearance" })

ThemeSec:AddDropdown({ Name="Color Theme",
    Values={"Purple","Midnight","Rose","Crimson","Sunset","Sakura","StarryNight","Aurora","Nebula","Ocean","Christmas","Neko"},
    Default="Purple", Flag="theme_sel",
    Callback=function(v)
        pcall(function() Hyperion:SetTheme(v) end)
        pcall(function()
            local th = Hyperion.Themes[v]
            if th and th.BackgroundImage and th.BackgroundImage ~= "" then
                Window:SetBackground(th.BackgroundImage, th.BackgroundTint or 0.45)
            else
                Window:SetBackground(nil)
            end
        end)
        Notify("Theme","Applied: "..v,"Success")
    end })


SystemSec:AddKeybind({ Name="Menu Keybind", Default=Enum.KeyCode.RightShift, Flag="menu_kb",
    Callback=function(v)
        if typeof(v) == "EnumItem" then
            _menuKeybind = v
        end
    end })

SystemSec:AddButton({ Name="Refresh ESP", Icon=Hyperion.Lucide.RefreshCw,
    Callback=function()
        local toClean = {}
        for plr in pairs(ActiveESP) do table.insert(toClean, plr) end
        for _, plr in ipairs(toClean) do CleanupESP(plr) end
        for _,p in ipairs(Players:GetPlayers()) do if p~=LP then InitializeESP(p) end end
        Notify("ESP","Refreshed.","Success")
    end })
SystemSec:AddButton({ Name="Unload Script", Icon=Hyperion.Lucide.Power,
    Callback=function()
        RenderConnection:Disconnect()
        pcall(function() UIS.MouseIconEnabled=true end)
        local toClean = {}
        for plr in pairs(ActiveESP) do table.insert(toClean, plr) end
        for _, plr in ipairs(toClean) do CleanupESP(plr) end
        if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
        kitRemoveAll()
        pcall(FOVCircle.Remove,FOVCircle); pcall(AimDot.Remove,AimDot); pcall(AimDotOut.Remove,AimDotOut)
        HideFOVFill(); pcall(function() if _fovFillGui then _fovFillGui:Destroy() end end)
        pcall(FOVWatermarkText.Remove, FOVWatermarkText)
        for _,d in pairs(CL) do pcall(d.Remove,d) end
        pcall(RageFOV.Remove,RageFOV); pcall(RageTargetInfo.Remove,RageTargetInfo)
        Rage.Enabled=false; Rage.TPWalk=false; Rage.Spinbot=false; Rage.HitboxExpander=false
        KillAura.Enabled=false
        AutoMine.Enabled=false
        SpinbotStop(); HitboxRestore(); RageCleanup()
        Move.Fly=false; Move.Noclip=false
        StopAutoFarm(); Notify("Hyperion","Unloaded.","Info")
        task.wait(1); pcall(function() Window:Destroy() end)
    end })

SystemSec:AddButton({ Name="Server Info", Icon=Hyperion.Lucide.Users,
    Callback=function()
        Notify("Server","Players: "..#Players:GetPlayers().."  |  PlaceId: "..game.PlaceId,"Info",4)
    end })

end



Notify("Hyperion v1.4","Loaded! Welcome, "..LP.DisplayName.."  ·  RightShift to toggle.","Success",5)
