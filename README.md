[README_Hyperion_UI (1).md](https://github.com/user-attachments/files/26494949/README_Hyperion_UI.1.md)
# Hyperion UI Library – README

## Overview
This is a quick implementation guide for the completed **Hyperion UI Library v3.0**.

The library builds UI in this general chain:

```lua
Hyperion -> CreateWindow() -> AddTab() -> AddSection() -> Add elements
```

---

## Basic setup

```lua
local Hyperion = loadstring(game:HttpGet("YOUR_LINK_HERE"))()

local Window = Hyperion:CreateWindow({
    Title = "Hyperion",
    Logo = "rbxassetid://74070104523360",
    Size = UDim2.new(0, 760, 0, 540),
    Keybind = Enum.KeyCode.RightControl,
})

local MainTab = Window:AddTab({
    Name = "Main",
    Icon = Hyperion.Lucide.Home
})

local LeftSection = MainTab:AddSection({
    Name = "Combat",
    Side = "Left"
})

local RightSection = MainTab:AddSection({
    Name = "Visuals",
    Side = "Right"
})
```

---

## Window options

### `Hyperion:CreateWindow({...})`
Supported options:

```lua
local Window = Hyperion:CreateWindow({
    Title = "Hyperion",
    Logo = "rbxassetid://74070104523360",
    Size = UDim2.new(0, 760, 0, 540),
    Keybind = Enum.KeyCode.RightControl,
    Theme = {}
})
```

### Window methods

```lua
Window:Toggle()
Window:Destroy()

Window:SaveConfig("legit")
Window:LoadConfig("legit")
Window:ListConfigs()
Window:DeleteConfig("legit")

Window:OpenConfigPanel()
Window:CloseConfigPanel()
Window:RefreshConfigList()

Window:AutoLoad("default")
Window:AutoSave("default")
```

---

## Tabs

### `Window:AddTab({...})`

```lua
local Tab = Window:AddTab({
    Name = "Aimbot",
    Icon = Hyperion.Lucide.Target
})
```

---

## Sections

### `Tab:AddSection({...})`

```lua
local Section = Tab:AddSection({
    Name = "Main Settings",
    Side = "Left",
    Group = "__default"
})
```

You add all controls to a section.

---

## Elements

## Toggle

```lua
local Toggle = Section:AddToggle({
    Name = "Enabled",
    Default = false,
    Flag = "aim_enabled",
    Callback = function(Value)
        print("Toggle:", Value)
    end
})
```

### Toggle API
```lua
Toggle:Set(true)
Toggle:Get()
```

---

## Slider

```lua
local Slider = Section:AddSlider({
    Name = "FOV",
    Min = 0,
    Max = 300,
    Default = 120,
    Decimals = 0,
    Suffix = "°",
    Flag = "aim_fov",
    Callback = function(Value)
        print("Slider:", Value)
    end
})
```

### Slider API
```lua
Slider:Set(150)
Slider:Get()
```

---

## Button

```lua
Section:AddButton({
    Name = "Print Hello",
    Icon = Hyperion.Lucide.Terminal,
    Callback = function()
        print("Hello")
    end
})
```

---

## Dropdown

```lua
local Dropdown = Section:AddDropdown({
    Name = "Hit Part",
    Values = {"Head", "Torso", "Random"},
    Default = "Head",
    Flag = "hitpart",
    Callback = function(Value)
        print("Dropdown:", Value)
    end
})
```

### Dropdown API
```lua
Dropdown:Set("Torso")
Dropdown:Get()
Dropdown:Refresh({"Head", "Torso", "Random", "Closest"})
```

---

## Multi Dropdown

```lua
local Multi = Section:AddMultiDropdown({
    Name = "Targets",
    Values = {"Players", "NPCs", "Animals"},
    Default = {"Players"},
    Flag = "target_types",
    Callback = function(Value)
        print(Value)
    end
})
```

This is just an alias of `AddDropdown()` with `Multi = true`.

---

## Textbox

```lua
local Box = Section:AddTextbox({
    Name = "Webhook",
    Default = "",
    Placeholder = "Paste webhook...",
    Flag = "webhook_url",
    Callback = function(Value)
        print("Textbox:", Value)
    end
})
```

### Textbox API
```lua
Box:Set("hello")
Box:Get()
```

---

## Theme picker

The library includes a built-in theme picker helper.

```lua
local ThemeSection = Tab:AddSection({
    Name = "Themes",
    Side = "Right"
})

Window:AddThemePicker(ThemeSection, function(ThemeName)
    print("Applied theme:", ThemeName)
end)
```

Built-in themes:
- Purple
- Midnight
- Rose

You can also apply a theme directly:

```lua
Hyperion:SetTheme("Midnight")
```

Or use a custom theme table:

```lua
Hyperion:SetTheme({
    Accent = Color3.fromRGB(0, 170, 255),
    AccentDark = Color3.fromRGB(0, 120, 200),
    Text = Color3.fromRGB(240, 240, 240),
})
```

---

## Notifications

```lua
Hyperion:Notify({
    Title = "Hyperion",
    Content = "Loaded successfully.",
    Type = "Success",
    Duration = 3
})
```

---

## Built-in icons

The library exposes lots of ready-to-use Lucide asset ids:

```lua
Hyperion.Lucide.Home
Hyperion.Lucide.Settings
Hyperion.Lucide.Folder
Hyperion.Lucide.FolderOpen
Hyperion.Lucide.Target
Hyperion.Lucide.Palette
Hyperion.Lucide.Terminal
Hyperion.Lucide.Bug
Hyperion.Lucide.Shield
```

Example:

```lua
local Tab = Window:AddTab({
    Name = "Settings",
    Icon = Hyperion.Lucide.Settings
})
```

---

## Full example

```lua
local Hyperion = loadstring(game:HttpGet("YOUR_LINK_HERE"))()

local Window = Hyperion:CreateWindow({
    Title = "Hyperion Hub",
    Logo = "rbxassetid://74070104523360",
    Size = UDim2.new(0, 760, 0, 540),
    Keybind = Enum.KeyCode.RightControl,
})

local MainTab = Window:AddTab({
    Name = "Main",
    Icon = Hyperion.Lucide.Home
})

local Combat = MainTab:AddSection({
    Name = "Combat",
    Side = "Left"
})

local Visuals = MainTab:AddSection({
    Name = "Visuals",
    Side = "Right"
})

local Enabled = Combat:AddToggle({
    Name = "Aimbot",
    Default = false,
    Flag = "aimbot_enabled",
    Callback = function(v)
        print("Aimbot:", v)
    end
})

local FOV = Combat:AddSlider({
    Name = "FOV",
    Min = 0,
    Max = 300,
    Default = 120,
    Suffix = "°",
    Flag = "aimbot_fov",
    Callback = function(v)
        print("FOV:", v)
    end
})

local HitPart = Combat:AddDropdown({
    Name = "Hit Part",
    Values = {"Head", "Torso", "Random"},
    Default = "Head",
    Flag = "aimbot_hitpart",
    Callback = function(v)
        print("Hit Part:", v)
    end
})

Combat:AddButton({
    Name = "Test Notification",
    Icon = Hyperion.Lucide.Info,
    Callback = function()
        Hyperion:Notify({
            Title = "Hyperion",
            Content = "Button clicked.",
            Type = "Info",
            Duration = 2
        })
    end
})

Visuals:AddTextbox({
    Name = "Player Name",
    Placeholder = "Type a name...",
    Flag = "player_name",
    Callback = function(v)
        print("Player Name:", v)
    end
})

Window:AddThemePicker(Visuals, function(theme)
    print("Theme changed to:", theme)
end)
```

---

## Flags
If you give an element a `Flag`, its value is stored in:

```lua
Hyperion.Flags
```

Example:

```lua
print(Hyperion.Flags["aimbot_enabled"])
print(Hyperion.Flags["aimbot_fov"])
```

This is what the config system saves and loads.

---

## Config system
The library saves configs into:

```lua
Hyperion/Configs/
```

Example:

```lua
Window:SaveConfig("legit")
Window:LoadConfig("legit")
Window:DeleteConfig("legit")
```

You can also open the built-in config manager from the folder button in the UI or by code:

```lua
Window:OpenConfigPanel()
```

---

## Notes
- Build elements after creating a window, tab, and section.
- Use unique `Flag` names so configs do not overwrite each other.
- Use `Hyperion.Lucide` for matching icons.
- Theme changes affect themed elements across the UI.
- If you edit the library later, some element names or options may change.

---

## Quick template

```lua
local Hyperion = loadstring(game:HttpGet("YOUR_LINK_HERE"))()

local Window = Hyperion:CreateWindow({
    Title = "Hyperion"
})

local Tab = Window:AddTab({
    Name = "Main",
    Icon = Hyperion.Lucide.Home
})

local Section = Tab:AddSection({
    Name = "Example",
    Side = "Left"
})

Section:AddToggle({
    Name = "Enabled",
    Default = true,
    Flag = "enabled"
})

Section:AddSlider({
    Name = "Amount",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "amount"
})

Section:AddButton({
    Name = "Run",
    Callback = function()
        print("Ran")
    end
})
```
