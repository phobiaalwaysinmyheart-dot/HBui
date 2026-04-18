# Hyperion UI Library

![Status](https://img.shields.io/badge/status-active-brightgreen)
![Version](https://img.shields.io/badge/version-3.0-purple)
![Lua](https://img.shields.io/badge/language-Luau-blue)

A modern Roblox UI library focused on clean visuals, smooth animations, flexible layouts, theme support, and a built-in config system.

---

## Overview

Hyperion UI is designed for scripts that need a polished interface without a messy setup process.

### Main goals
- clean modern design
- smooth interactions and transitions
- easy organization
- reusable components
- built-in config support
- theme support
- simple API structure

### Layout structure
Category → Tab → Section → Divider → Elements

---

## Features

- window creation with title, logo, size, and keybind
- category and tab organization
- left / right section support
- grouped sections for fake sub-tabs
- built-in config panel
- notifications
- theme picker support
- watermark support
- key system support
- Lucide icon asset table
- customizable themes
- common UI elements included

---

## Installation

```lua
local Hyperion = loadstring(game:HttpGet("YOUR_LINK_HERE"))()

Replace "YOUR_LINK_HERE" with your raw library link.

Quick Start
local Hyperion = loadstring(game:HttpGet("YOUR_LINK_HERE"))()

local Window = Hyperion:CreateWindow({
    Title = "Hyperion",
    Logo = "rbxassetid://74070104523360",
    Size = UDim2.new(0, 760, 0, 540),
    Keybind = Enum.KeyCode.RightControl,
})

Window:AddCategory("Combat")

local CombatTab = Window:AddTab({
    Name = "Combat",
    Icon = Hyperion.Lucide.Target
})

local MainSection = CombatTab:AddSection({
    Name = "Main",
    Side = "Left"
})

MainSection:AddToggle({
    Name = "Enabled",
    Default = true,
    Flag = "combat_enabled",
    Callback = function(Value)
        print("Enabled:", Value)
    end
})

MainSection:AddSlider({
    Name = "Range",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "combat_range",
    Callback = function(Value)
        print("Range:", Value)
    end
})

MainSection:AddDropdown({
    Name = "Mode",
    Values = {"Legit", "Rage", "Silent"},
    Default = "Legit",
    Flag = "combat_mode",
    Callback = function(Value)
        print("Mode:", Value)
    end
})

Hyperion:Notify({
    Title = "Hyperion",
    Content = "UI loaded successfully.",
    Type = "Success",
    Duration = 3
})
Creating a Window
local Window = Hyperion:CreateWindow({
    Title = "Hyperion",
    Logo = "rbxassetid://74070104523360",
    Size = UDim2.new(0, 760, 0, 540),
    Keybind = Enum.KeyCode.RightControl,
})
Window options
Option	Type	Description
Title	string	Main window title
Logo	string	Asset id for the window logo
Size	UDim2	Window size
Keybind	Enum.KeyCode	Toggle key for showing / hiding the UI
Theme	table	Optional theme overrides
Key	string/table	Optional key or keys required before opening
KeySave	boolean	Saves entered key locally
KeyTitle	string	Title shown on the key prompt
KeySub	string	Subtitle shown on the key prompt
Categories

Categories are useful for visually separating groups of tabs in the sidebar.

Window:AddCategory("Combat")
Window:AddCategory("Visuals")
Window:AddCategory("Misc")
Tabs
local Tab = Window:AddTab({
    Name = "Combat",
    Icon = Hyperion.Lucide.Target
})
Example icons
Hyperion.Lucide.Target
Hyperion.Lucide.Settings
Hyperion.Lucide.Eye
Hyperion.Lucide.User
Hyperion.Lucide.Shield
Hyperion.Lucide.Star
Sections

Sections hold your elements and can be placed on the left or right side.

local Section = Tab:AddSection({
    Name = "Aimbot",
    Side = "Left"
})
Section options
Option	Type	Description
Name	string	Section title
Side	string	"Left" or "Right"
Group	string	Optional grouping label
Groups (Fake Sub Tabs)

Use grouped sections when you want multiple sections to feel like they belong together.

local Section = Tab:AddSection({
    Name = "ESP",
    Side = "Left",
    Group = "Player ESP"
})
Dividers

Dividers help split sections into readable parts.

Section:AddDivider({
    Title = "Colors"
})

You can also add a divider with no title.

Section:AddDivider({})
Elements
Toggle
Section:AddToggle({
    Name = "Enabled",
    Default = true,
    Flag = "enabled",
    Callback = function(Value)
        print(Value)
    end
})
Slider
Section:AddSlider({
    Name = "Amount",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "amount",
    Callback = function(Value)
        print(Value)
    end
})
Button
Section:AddButton({
    Name = "Execute",
    Callback = function()
        print("Clicked")
    end
})
Dropdown
Section:AddDropdown({
    Name = "Mode",
    Values = {"A", "B", "C"},
    Default = "A",
    Flag = "mode",
    Callback = function(Value)
        print(Value)
    end
})
Multi Dropdown
Section:AddMultiDropdown({
    Name = "Options",
    Values = {"ESP", "Tracers", "Boxes"},
    Flag = "multi_options",
    Callback = function(Value)
        print(Value)
    end
})
Textbox
Section:AddTextbox({
    Name = "Player Name",
    Placeholder = "Enter name...",
    Flag = "player_name",
    Callback = function(Value)
        print(Value)
    end
})
Keybind
Section:AddKeybind({
    Name = "Toggle Key",
    Default = Enum.KeyCode.Q,
    Flag = "toggle_key",
    Callback = function(Value)
        print(Value)
    end
})
Color Picker
Section:AddColorPicker({
    Name = "Accent Color",
    Default = Color3.fromRGB(140, 80, 220),
    Flag = "accent_color",
    Callback = function(Value)
        print(Value)
    end
})
Label
Section:AddLabel({
    Text = "This is a label."
})
Flags

Flags store values so they can be reused later.

Section:AddToggle({
    Name = "Enabled",
    Flag = "main_enabled"
})

print(Hyperion.Flags.main_enabled)

Use flags when you want config saving, state tracking, or shared values across your script.

Config System

Hyperion includes built-in config support.

Window:SaveConfig("config")
Window:LoadConfig("config")
Window:DeleteConfig("config")
Window:OpenConfigPanel()
Window:CloseConfigPanel()
Window:RefreshConfigList()
Useful config methods
Window:ListConfigs()
Autosave / autoload helpers
Hyperion:AutoSave("default")
Hyperion:AutoLoad("default")
Notifications
Hyperion:Notify({
    Title = "Hyperion",
    Content = "Loaded!",
    Type = "Success",
    Duration = 3
})
Notification types
Info
Success
Warning
Error
Themes

You can apply built-in themes or your own custom theme table.

Set a built-in theme
Hyperion:SetTheme("Purple")
Set a custom theme
Hyperion:SetTheme({
    Accent = Color3.fromRGB(170, 100, 255),
    Background = Color3.fromRGB(10, 10, 14),
    Surface = Color3.fromRGB(18, 18, 24),
    Text = Color3.fromRGB(255, 255, 255)
})
Theme picker in a section
Section:AddThemePicker({
    Callback = function(ThemeName)
        print("Changed to", ThemeName)
    end
})
Theme Overrides on Window Creation

You can pass a custom theme table directly into the window.

local Window = Hyperion:CreateWindow({
    Title = "Custom UI",
    Theme = {
        Accent = Color3.fromRGB(255, 90, 140),
        Background = Color3.fromRGB(12, 12, 16),
        Surface = Color3.fromRGB(18, 18, 24),
        Text = Color3.fromRGB(255, 255, 255),
    }
})
Watermark

Hyperion can create a small watermark UI.

Hyperion:CreateWatermark({
    Title = "Hyperion",
    Game = "My Game",
    Keybind = "RightControl"
})
Key System Example

If you want the window to require a key before opening:

local Window = Hyperion:CreateWindow({
    Title = "Protected UI",
    Key = {"hyperion", "testkey"},
    KeySave = true,
    KeyTitle = "Key Required",
    KeySub = "Enter your access key to continue."
})
Best Practices
keep tab names short and readable
use categories if you have lots of tabs
split large tabs into multiple sections
use flags for anything you may save later
use dividers to make sections easier to read
avoid putting too many controls in one section
keep theme colors consistent
Example Layout
Window:AddCategory("Combat")
Window:AddCategory("Visuals")

local Combat = Window:AddTab({
    Name = "Combat",
    Icon = Hyperion.Lucide.Target
})

local Aim = Combat:AddSection({
    Name = "Aimbot",
    Side = "Left"
})

local Misc = Combat:AddSection({
    Name = "Misc",
    Side = "Right"
})

Aim:AddToggle({Name = "Enabled", Default = false})
Aim:AddSlider({Name = "FOV", Min = 0, Max = 300, Default = 80})
Aim:AddDropdown({Name = "Hit Part", Values = {"Head", "Torso"}, Default = "Head"})

Misc:AddButton({
    Name = "Reset Settings",
    Callback = function()
        print("Reset clicked")
    end
})
API Summary
Hyperion
Hyperion:CreateWindow(config)
Hyperion:SetTheme(nameOrTable)
Hyperion:Notify(config)
Hyperion:AutoSave(name)
Hyperion:AutoLoad(name)
Hyperion:CreateWatermark(config)
Window
Window:AddCategory(name)
Window:AddTab(tabCfg)
Window:SaveConfig(name)
Window:LoadConfig(name)
Window:DeleteConfig(name)
Window:ListConfigs()
Window:OpenConfigPanel()
Window:CloseConfigPanel()
Window:RefreshConfigList()
Section
Section:AddToggle(cfg)
Section:AddSlider(cfg)
Section:AddButton(cfg)
Section:AddDropdown(cfg)
Section:AddMultiDropdown(cfg)
Section:AddTextbox(cfg)
Section:AddKeybind(cfg)
Section:AddColorPicker(cfg)
Section:AddLabel(cfg)
Section:AddDivider(cfg)
Section:AddThemePicker(cfg)
Credits

Hyperion UI by Phobia
