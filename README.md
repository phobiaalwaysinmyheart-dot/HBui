[README_Hyperion_UI_UPDATED.md](https://github.com/user-attachments/files/26493054/README_Hyperion_UI_UPDATED.md)
# Hyperion UI Library – README (Updated)

## New: Categories, Groups, and Dividers

### Categories (Sidebar Headers)
Use categories to organize tabs in the sidebar.

```lua
Window:AddCategory("Combat")
```

They act as **labels**, not clickable tabs.

---

### Tabs
Tabs are the main pages of your UI.

```lua
local Tab = Window:AddTab({
    Name = "Combat",
    Icon = Hyperion.Lucide.Target
})
```

---

### Sections
Sections hold your UI elements.

```lua
local Section = Tab:AddSection({
    Name = "Aimbot",
    Side = "Left"
})
```

---

### Groups (Fake Sub Tabs)
Groups organize sections inside a tab.

```lua
local Section = Tab:AddSection({
    Name  = "ESP Settings",
    Side  = "Left",
    Group = "Player ESP"
})
```

Groups are NOT real tabs — they are visual organization tools.

---

### Dividers
Dividers split content inside a section.

```lua
Section:AddDivider({ Title = "Colors" })
```

#### Example layout:

```lua
Section:AddToggle({ Name = "Enable ESP" })

Section:AddDivider({ Title = "Colors" })

Section:AddColorPicker({ Name = "Box Color" })
Section:AddColorPicker({ Name = "Name Color" })
```

#### What dividers do:
- Separate settings into readable sections
- Add a labeled break (like “Colors”, “Info”, “Danger”)
- Improve UI clarity

---

### Best Practices

Use:
- **Categories** → organize sidebar
- **Tabs** → main features
- **Groups** → organize sections inside tabs
- **Dividers** → split content inside sections

---

### Example Structure

```lua
Window:AddCategory("Visuals")

local Tab = Window:AddTab({
    Name = "Visuals",
    Icon = Hyperion.Lucide.Eye
})

local Section = Tab:AddSection({
    Name  = "ESP",
    Side  = "Left",
    Group = "Player ESP"
})

Section:AddToggle({ Name = "Enable ESP" })

Section:AddDivider({ Title = "Colors" })

Section:AddColorPicker({ Name = "Box Color" })
```

---

### Summary

| Feature    | Purpose |
|-----------|--------|
| Category  | Sidebar label |
| Tab       | Main page |
| Section   | Container |
| Group     | Organizes sections (fake sub tab) |
| Divider   | Splits section content |

---

UI structure:
```
Category → Tab → Section → Divider → Elements
```
