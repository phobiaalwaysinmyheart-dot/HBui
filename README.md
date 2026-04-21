# Hyperion UI

A premium UI library for Roblox — modern, clean, and batteries-included. Dark themes, animated backgrounds, live theme swapping, a built-in config system with autoload, notifications, a key system, watermark overlay, and a wide set of elements (toggles, sliders, dropdowns, color pickers, keybinds, textboxes, and more).

```lua
local Hyperion = loadstring(game:HttpGet("https://raw.githubusercontent.com/phobiaalwaysinmyheart-dot/HBui/main/HyperionUI.lua"))()
```

---

## Quick start

```lua
local Hyperion = loadstring(game:HttpGet("https://raw.githubusercontent.com/phobiaalwaysinmyheart-dot/HBui/main/HyperionUI.lua"))()

local Window = Hyperion:CreateWindow({
    Title   = "My Script",
    Keybind = Enum.KeyCode.RightControl,
    -- Config system (see below)
    ConfigSystem   = true,   -- show the folder/config button and enable Save/Load
    ConfigAutoLoad = true,   -- automatically restore the last-used config on open
    AutoLoadName   = "default",
})

-- Optional: pick a theme
Hyperion:SetTheme("Vaporwave")

local Tab = Window:AddTab("Main", "rbxassetid://10723407389") -- lucide-home
local Section = Tab:AddSection("Features")

Section:AddToggle({
    Name    = "Example Toggle",
    Flag    = "ExampleToggle",   -- flags are what get saved/loaded
    Default = false,
    Callback = function(v) print("toggled:", v) end,
})
```

---

## Themes

Hyperion ships with twelve built-in themes. Apply any by name with `Hyperion:SetTheme("Name")`.

| Theme | Animated | Style |
|---|---|---|
| `Purple` | no | default, dark purple accent |
| `Midnight` | no | cool blue |
| `Rose` | no | warm pink/red |
| `Crimson` | no | deep red |
| `StarryNight` | ✓ | deep navy with falling stars |
| `Aurora` | ✓ | teal/green with drifting wisps |
| `Nebula` | ✓ | magenta deep-space with stars |
| `Sunset` | ✓ | warm orange with embers |
| `Ocean` | ✓ | deep blue with rising bubbles |
| `Sakura` | ✓ | pink with falling petals |
| **`Vaporwave`** | ✓ | pink/magenta/cyan '80s gradient with floating orbs |

Live theme swaps propagate to every themed element — there is no flash or rebuild.

```lua
Hyperion:SetTheme("Vaporwave")

-- Or pass a custom table:
Hyperion:SetTheme({
    Accent     = Color3.fromRGB(0, 255, 180),
    Background = Color3.fromRGB(10, 10, 10),
    -- ...override any theme key
})

-- React to theme changes:
local unsub = Hyperion:OnThemeChanged(function(theme)
    print("theme accent is now:", theme.Accent)
end)
-- unsub() to stop listening
```

### The Vaporwave theme

A hot-pink / magenta / deep-purple / cyan-teal gradient with cyan-tinted floating orbs drifting upward. Good fit for scripts that want a playful, stylized look rather than a serious tool vibe. The accent is `Color3.fromRGB(255, 95, 195)` and the background animates across the full vaporwave sunset palette.

```lua
Hyperion:SetTheme("Vaporwave")
```

---

## Config system

Flags attached to elements (toggles, sliders, dropdowns, color pickers, keybinds, textboxes) are stored in `Hyperion.Flags` and can be persisted to disk as JSON under `Hyperion/Configs/<name>.json`.

### Enable, disable, autoload

All three config behaviors are controlled from `CreateWindow`:

```lua
local Window = Hyperion:CreateWindow({
    Title          = "Script",
    ConfigSystem   = true,        -- default: true. false = hide the folder button and disable Save/Load
    ConfigAutoLoad = true,        -- default: true. false = don't restore on open
    AutoLoadName   = "default",   -- file name (without .json) used by the autoloader
})
```

* **`ConfigSystem = false`** hides the in-window Config (folder) button and makes `Hyperion:SaveConfig`, `:LoadConfig`, `:AutoLoad`, and `:AutoSave` become no-ops.
* **`ConfigAutoLoad = false`** keeps the config UI available but stops the automatic restore that runs after the window is built.
* **`AutoLoadName`** chooses which file the autoloader picks up. If it doesn't exist yet, nothing happens (no error).

### Toggle the system at runtime

```lua
Hyperion:DisableConfig()   -- hides the folder button, closes the panel if open
Hyperion:EnableConfig()    -- shows it again

Hyperion:SetConfigEnabled(false)  -- same as DisableConfig
print(Hyperion:IsConfigEnabled()) -- true/false

-- Listen for changes
Hyperion:OnConfigEnabledChanged(function(enabled)
    print("config system is now:", enabled)
end)
```

### Manual save/load from code

```lua
Hyperion:SaveConfig("my_preset")     -- writes Hyperion/Configs/my_preset.json
Hyperion:LoadConfig("my_preset")     -- reads it back and fires every flag's callback
Hyperion:ListConfigs()               -- { "default", "my_preset", ... }
Hyperion:DeleteConfig("my_preset")
```

You can also call `Hyperion:AutoLoad("default")` manually if you've set `ConfigAutoLoad = false` but still want to trigger a load at a specific moment in your build sequence.

### What gets saved

Every element with a `Flag` field contributes to the saved config. Supported value types:

* `boolean`, `number`, `string`
* `Color3`
* `EnumItem` (e.g. `Enum.KeyCode.F`)
* plain tables

### File layout

```
<workspace>/
└── Hyperion/
    └── Configs/
        ├── default.json
        ├── pvp.json
        └── farming.json
```

Your executor needs `readfile`, `writefile`, `isfile`, `isfolder`, `makefolder`, `listfiles`, and optionally `delfile` / `fremovefile`. If any are missing, the library degrades gracefully — the config panel will just show an empty list.

---

## Elements

Each section supports the following element methods. All of them take a table with at minimum a `Name`, usually a `Flag` (for config save/load), a `Default`, and a `Callback`.

```lua
Section:AddToggle({ Name, Flag, Default, Callback })
Section:AddButton({ Name, Callback })
Section:AddSlider({ Name, Flag, Min, Max, Default, Increment, Suffix, Callback })
Section:AddDropdown({ Name, Flag, Options, Default, Multi, Callback })
Section:AddColorPicker({ Name, Flag, Default, Callback })
Section:AddKeybind({ Name, Flag, Default, Callback })
Section:AddTextbox({ Name, Flag, Default, Placeholder, Callback })
Section:AddLabel({ Text })
Section:AddParagraph({ Title, Content })
```

Updating an element later:

```lua
local myToggle = Section:AddToggle({ Name = "X", Flag = "x_flag", Default = false })
myToggle:Set(true)         -- updates visual and fires callback
myToggle:SetText("New name")
```

---

## Notifications

```lua
Hyperion:Notify({
    Title    = "Saved",
    Content  = "Configuration saved to disk.",
    Type     = "Success",   -- Info | Success | Warning | Error
    Duration = 3,
})
```

---

## Key system

Gate script access behind a key (or list of keys):

```lua
Hyperion:CreateWindow({
    Title    = "Private",
    Key      = "hunter2",           -- or a table: { "keyA", "keyB" }
    KeySave  = true,                -- remember the key on disk (default true)
    KeyTitle = "Access Required",
    KeySub   = "Enter your key to continue.",
})
```

---

## Watermark

An optional on-screen watermark with live FPS and game name:

```lua
local Wm = Hyperion:Watermark({
    Title   = "MyScript v1.0",
    Game    = "Bedwars",
    Keybind = Enum.KeyCode.RightShift,   -- optional toggle key
})

Wm:SetTitle("v1.1")
Wm:SetGame("Arsenal")
Wm:SetVisible(false)
Wm:Destroy()
```

---

## Cleanup

```lua
Hyperion:Unload()   -- destroys all windows, disconnects signals, removes GUIs
```

---

## API reference (abbreviated)

### Library-level

| Method | Purpose |
|---|---|
| `Hyperion:CreateWindow(config)` | Creates and returns a Window. |
| `Hyperion:SetTheme(name \| table)` | Applies a theme preset or override table. |
| `Hyperion:OnThemeChanged(fn)` | Fires whenever the theme changes. Returns unsub. |
| `Hyperion:Notify(config)` | Shows a toast notification. |
| `Hyperion:Watermark(config)` | Creates a draggable watermark. |
| `Hyperion:SaveConfig(name)` | Saves `Hyperion.Flags` to disk. |
| `Hyperion:LoadConfig(name)` | Loads flags from disk and fires callbacks. |
| `Hyperion:AutoLoad(name)` | Silent load if file exists. |
| `Hyperion:AutoSave(name)` | Convenience alias for SaveConfig. |
| `Hyperion:ListConfigs()` | Returns an array of saved config names. |
| `Hyperion:DeleteConfig(name)` | Removes a saved config file. |
| `Hyperion:EnableConfig()` | Turns the config system on. |
| `Hyperion:DisableConfig()` | Turns the config system off. |
| `Hyperion:SetConfigEnabled(bool)` | Same as Enable/Disable. |
| `Hyperion:IsConfigEnabled()` | Returns current state. |
| `Hyperion:OnConfigEnabledChanged(fn)` | Listener for the toggle. |
| `Hyperion:Unload()` | Full cleanup. |

### Window

| Method | Purpose |
|---|---|
| `Window:AddTab(name, icon)` | Creates a sidebar tab. |
| `Window:SelectTab(tabOrName)` | Programmatically selects a tab. |
| `Window:SetVisible(bool)` | Shows/hides the window. |
| `Window:OpenConfigPanel()` | Opens the built-in config panel. |
| `Window:CloseConfigPanel()` | Closes it. |

### Tab

| Method | Purpose |
|---|---|
| `Tab:AddSection(title)` | Adds a titled section inside the tab. |

---

## Compatibility

Hyperion is designed for Roblox script-executor environments and uses the standard executor API:

`isfile`, `readfile`, `writefile`, `makefolder`, `isfolder`, `listfiles`, `delfile` / `fremovefile`, `getgenv`, `cloneref`, `gethui` (optional), `protect_gui` / `syn.protect_gui` (optional).

Missing optional functions are stubbed so the library still loads — features that need them (e.g. saving configs to disk) simply become no-ops.

---

## License

MIT.
