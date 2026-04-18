# Hyperion UI Library

Modern Roblox UI library focused on clean design, smooth animations, and easy setup.

---

## ✦ Features

- Clean modern UI
- Smooth animations
- Category → Tab → Section layout
- Built-in config system
- Notifications
- Theme system + theme picker
- Watermark support
- Key system support
- Lucide icons
- Full set of UI elements

---

## ✦ Installation

```lua
local Hyperion = loadstring(game:HttpGet("YOUR_LINK_HERE"))()
✦ Quick Start
local Hyperion = loadstring(game:HttpGet("YOUR_LINK_HERE"))()

local Window = Hyperion:CreateWindow({
    Title = "Hyperion",
    Logo = "rbxassetid://74070104523360",
    Size = UDim2.new(0, 760, 0, 540),
    Keybind = Enum.KeyCode.RightControl
})

Window:AddCategory("Combat")

local Tab = Window:AddTab({
    Name = "Combat",
    Icon = Hyperion.Lucide.Target
})

local Section = Tab:AddSection({
    Name = "Main",
    Side = "Left"
})

Section:AddToggle({
    Name = "Enabled",
    Default = true,
    Flag = "enabled",
    Callback = function(v)
        print(v)
    end
})

Hyperion:Notify({
    Title = "Hyperion",
    Content = "Loaded",
    Type = "Success",
    Duration = 3
})
✦ Window
local Window = Hyperion:CreateWindow({
    Title = "Title",
    Logo = "rbxassetid://ID",
    Size = UDim2.new(0, 760, 0, 540),
    Keybind = Enum.KeyCode.RightControl
})
Options
Title → window name
Logo → asset id
Size → window size
Keybind → toggle key
Theme → custom theme table
Key → required key(s)
KeySave → save key
KeyTitle → key UI title
KeySub → key UI subtitle
✦ Categories
Window:AddCategory("Combat")
Window:AddCategory("Visuals")
✦ Tabs
local Tab = Window:AddTab({
    Name = "Combat",
    Icon = Hyperion.Lucide.Target
})
✦ Sections
local Section = Tab:AddSection({
    Name = "Aimbot",
    Side = "Left"
})
Options
Name
Side → "Left" or "Right"
Group → optional grouping
✦ Elements
Toggle
Section:AddToggle({
    Name = "Toggle",
    Default = false,
    Flag = "toggle",
    Callback = function(v) end
})
Slider
Section:AddSlider({
    Name = "Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "slider",
    Callback = function(v) end
})
Button
Section:AddButton({
    Name = "Button",
    Callback = function() end
})
Dropdown
Section:AddDropdown({
    Name = "Dropdown",
    Values = {"A","B","C"},
    Default = "A",
    Flag = "dropdown",
    Callback = function(v) end
})
Multi Dropdown
Section:AddMultiDropdown({
    Name = "Multi",
    Values = {"A","B"},
    Flag = "multi",
    Callback = function(v) end
})
Textbox
Section:AddTextbox({
    Name = "Textbox",
    Placeholder = "...",
    Flag = "textbox",
    Callback = function(v) end
})
Keybind
Section:AddKeybind({
    Name = "Key",
    Default = Enum.KeyCode.Q,
    Flag = "key",
    Callback = function(v) end
})
Color Picker
Section:AddColorPicker({
    Name = "Color",
    Default = Color3.fromRGB(255,255,255),
    Flag = "color",
    Callback = function(v) end
})
Label
Section:AddLabel({
    Text = "Text"
})
Divider
Section:AddDivider({
    Title = "Section"
})
✦ Flags
print(Hyperion.Flags.enabled)

Used for storing values and configs.

✦ Config System
Window:SaveConfig("name")
Window:LoadConfig("name")
Window:DeleteConfig("name")
Window:ListConfigs()

Window:OpenConfigPanel()
Window:CloseConfigPanel()
Window:RefreshConfigList()
Auto
Hyperion:AutoSave("default")
Hyperion:AutoLoad("default")
✦ Notifications
Hyperion:Notify({
    Title = "Title",
    Content = "Message",
    Type = "Success",
    Duration = 3
})
Types
Info
Success
Warning
Error
✦ Themes
Set Theme
Hyperion:SetTheme("Purple")
Custom Theme
Hyperion:SetTheme({
    Accent = Color3.fromRGB(170,100,255),
    Background = Color3.fromRGB(10,10,14),
    Surface = Color3.fromRGB(18,18,24),
    Text = Color3.fromRGB(255,255,255)
})
Theme Picker
Section:AddThemePicker({
    Callback = function(theme) end
})
✦ Watermark
Hyperion:CreateWatermark({
    Title = "Hyperion",
    Game = "Game Name",
    Keybind = "RightControl"
})
✦ Key System
local Window = Hyperion:CreateWindow({
    Title = "Protected",
    Key = {"key1","key2"},
    KeySave = true,
    KeyTitle = "Enter Key",
    KeySub = "Access required"
})
✦ Example Layout
Window:AddCategory("Combat")

local Tab = Window:AddTab({
    Name = "Combat",
    Icon = Hyperion.Lucide.Target
})

local Left = Tab:AddSection({
    Name = "Main",
    Side = "Left"
})

local Right = Tab:AddSection({
    Name = "Misc",
    Side = "Right"
})

Left:AddToggle({Name = "Enabled"})
Left:AddSlider({Name = "FOV", Min = 0, Max = 300})

Right:AddButton({
    Name = "Reset",
    Callback = function() end
})
✦ Credits

Hyperion UI
