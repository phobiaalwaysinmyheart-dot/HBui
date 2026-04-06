[README_Hyperion_UI_GITHUB.md](https://github.com/user-attachments/files/26494941/README_Hyperion_UI_GITHUB.md)
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

---

## Features
- 🧩 Tabs & Categories
- 📂 Built-in Config Manager
- 🎨 Theme System + Theme Picker
- 🔘 Toggles, Sliders, Dropdowns, MultiDropdowns
- 🎯 Keybinds
- 🌈 Color Pickers
- 📑 Dividers & Groups
- 🔔 Notifications

---

## Installation

```lua
local Hyperion = loadstring(game:HttpGet("YOUR_LINK_HERE"))()
```

---

## Quick Example

```lua
local Window = Hyperion:CreateWindow({
    Title = "Hyperion",
    Keybind = Enum.KeyCode.RightControl
})

Window:AddCategory("Main")

local Tab = Window:AddTab({
    Name = "Home",
    Icon = Hyperion.Lucide.Home
})

local Section = Tab:AddSection({
    Name = "Example",
    Side = "Left"
})

Section:AddToggle({
    Name = "Enabled",
    Default = true
})
```

---

## Structure Guide

```
Category → Tab → Section → Divider → Elements
```

### Categories
Organize sidebar tabs.

### Tabs
Main pages of your UI.

### Sections
Containers for elements.

### Groups
Organize sections visually (like sub tabs).

### Dividers
Split sections into readable parts.

---

## Divider Example

```lua
Section:AddDivider({ Title = "Colors" })

Section:AddColorPicker({ Name = "Main Color" })
Section:AddColorPicker({ Name = "Accent Color" })
```

---

## Theme System

```lua
Hyperion:SetTheme("Midnight")
```

Or:

```lua
Section:AddThemePicker({
    Callback = function(theme)
        print(theme)
    end
})
```

---

## Config System

```lua
Window:SaveConfig("myconfig")
Window:LoadConfig("myconfig")
Window:DeleteConfig("myconfig")
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

## Tips
- Use **groups + dividers** to make UI clean
- Keep flags unique
- Use Lucide icons for consistency

---

## Credits
- Hyperion UI by Phobia
- Icons by Lucide

