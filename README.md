[Hyperion_README_FINAL.md](https://github.com/user-attachments/files/26499859/Hyperion_README_FINAL.md)
# Hyperion UI Library

![Status](https://img.shields.io/badge/status-active-brightgreen)
![Version](https://img.shields.io/badge/version-3.0-purple)
![Lua](https://img.shields.io/badge/language-Luau-blue)

---

## Overview
Hyperion UI is a modern Roblox UI library focused on:
- clean design
- smooth animations
- easy config system
- organized layouts

Structure:
Category → Tab → Section → Divider → Elements

---

## Installation
```lua
local Hyperion = loadstring(game:HttpGet("YOUR_LINK_HERE"))()
```

---

## Basic Setup
```lua
local Window = Hyperion:CreateWindow({
    Title = "Hyperion",
    Logo = "rbxassetid://74070104523360",
    Size = UDim2.new(0, 760, 0, 540),
    Keybind = Enum.KeyCode.RightControl,
})
```

---

## Categories
```lua
Window:AddCategory("Combat")
```

---

## Tabs
```lua
local Tab = Window:AddTab({
    Name = "Combat",
    Icon = Hyperion.Lucide.Target
})
```

---

## Sections
```lua
local Section = Tab:AddSection({
    Name = "Aimbot",
    Side = "Left"
})
```

---

## Groups (Fake Sub Tabs)
```lua
local Section = Tab:AddSection({
    Name = "ESP",
    Side = "Left",
    Group = "Player ESP"
})
```

---

## Dividers
```lua
Section:AddDivider({ Title = "Colors" })
```

---

## Example Elements
```lua
Section:AddToggle({ Name = "Enabled", Default = true })
Section:AddSlider({ Name = "Amount", Min = 0, Max = 100, Default = 50 })
Section:AddDropdown({ Name = "Mode", Values = {"A","B"}, Default = "A" })
```

---

## Config System
```lua
Window:SaveConfig("config")
Window:LoadConfig("config")
Window:DeleteConfig("config")
Window:OpenConfigPanel()
```

---

## Notifications
```lua
Hyperion:Notify({
    Title = "Hyperion",
    Content = "Loaded!",
    Type = "Success",
    Duration = 3
})
```

---

## Credits
Hyperion UI by Phobia
