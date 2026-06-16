-- HyperionExample.lua
-- Full demo of every HyperionUI element. Run in an executor to verify the library.
--
-- RECENT CHANGES:
--   - Dropdown arrows now use image icons (up/down) instead of text glyphs
--     Down: rbxassetid://134387593103194
--     Up:   rbxassetid://95689861013321
--
-- PENDING / TODO:
--   - Add Swords icon to Hyperion.Lucide table (currently nil — Combat tab has no icon)
--     Search "swords" on icons.rest and paste the asset ID
--   - Add more icons from icons.rest as needed (see icons.rest for full catalog)
--   - Wire Redliner loader entry (PlaceId 115875349872417)
--   - Wire Project Delta loader entry (PlaceId unknown)

local Hyperion = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/phobiaalwaysinmyheart-dot/HBui/refs/heads/main/HyperionUI.lua"
))()

-- ============================================================
-- WINDOW
-- ============================================================
local Window = Hyperion:CreateWindow({
    Title          = "Hyperion Demo",
    Logo           = "rbxassetid://134963728913547",
    Keybind        = Enum.KeyCode.RightShift,
    ConfigSystem   = true,
    ConfigAutoLoad = true,
    AutoLoadName   = "demo_default",
})


-- ============================================================
-- TABS
-- ============================================================
local HomeTab     = Window:AddTab({ Name = "Home",     Icon = Hyperion.Lucide.Home     })
local DropTab     = Window:AddTab({ Name = "Dropdowns", Icon = Hyperion.Lucide.List    })
local VisualTab   = Window:AddTab({ Name = "Visual",   Icon = Hyperion.Lucide.Eye      })
local InputTab    = Window:AddTab({ Name = "Input",    Icon = Hyperion.Lucide.Sliders  })
local MiscTab     = Window:AddTab({ Name = "Misc",     Icon = Hyperion.Lucide.Star     })
local SettingsTab = Window:AddTab({ Name = "Settings", Icon = Hyperion.Lucide.Settings })

-- ============================================================
-- HOME TAB  –  toggles, sliders, infobox, dropdowns
-- ============================================================
local HomeL = HomeTab:AddSection({ Name = "Features",  Side = "Left",  Group = "Main" })
local HomeR = HomeTab:AddSection({ Name = "Status",    Side = "Right", Group = "Main" })
local ModeL = HomeTab:AddSection({ Name = "Mode",      Side = "Left",  Group = "Settings" })
local ModeR = HomeTab:AddSection({ Name = "Options",   Side = "Right", Group = "Settings" })

local StatusBox = HomeR:AddInfobox({
    Title = "Idle",
    Text  = "No features are active.",
    Type  = "Info",
    Icon  = Hyperion.Lucide.Info,
})

local activeCount = 0
local function refreshStatus()
    if activeCount == 0 then
        StatusBox:SetTitle("Idle")
        StatusBox:SetContent("No features are active.")
        StatusBox:SetType("Info")
    elseif activeCount == 1 then
        StatusBox:SetTitle("Running")
        StatusBox:SetContent("1 feature is active.")
        StatusBox:SetType("Success")
    else
        StatusBox:SetTitle("Running")
        StatusBox:SetContent(activeCount .. " features are active.")
        StatusBox:SetType("Success")
    end
end

HomeL:AddToggle({
    Name     = "Auto Farm",
    Default  = false,
    Flag     = "demo_autofarm",
    Callback = function(v) activeCount += v and 1 or -1; refreshStatus() end,
})
HomeL:AddToggle({
    Name     = "Auto Collect",
    Default  = false,
    Flag     = "demo_autocollect",
    Callback = function(v) activeCount += v and 1 or -1; refreshStatus() end,
})
HomeL:AddToggle({
    Name     = "Silent Aim",
    Default  = false,
    Flag     = "demo_silentaim",
    Callback = function(v) activeCount += v and 1 or -1; refreshStatus() end,
})
HomeL:AddSlider({
    Name     = "Walk Speed",
    Min      = 16,
    Max      = 250,
    Default  = 16,
    Suffix   = " u/s",
    Flag     = "demo_walkspeed",
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end,
})
HomeL:AddSlider({
    Name     = "Jump Power",
    Min      = 7,
    Max      = 200,
    Default  = 7,
    Flag     = "demo_jumppower",
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = v
        end
    end,
})

HomeR:AddLabel({ Text = "Toggle the features on the left to update this box." })

ModeL:AddDropdown({
    Name     = "Farm Mode",
    Values   = { "Nearest", "Furthest", "Random", "Lowest HP" },
    Default  = "Nearest",
    Flag     = "demo_farmmode",
    Callback = function(v)
        Hyperion:Notify({ Title = "Farm Mode", Content = "Set to: " .. v, Type = "Info", Duration = 2 })
    end,
})
ModeL:AddDropdown({
    Name     = "Priority",
    Values   = { "Players", "NPCs", "Both" },
    Default  = "Both",
    Flag     = "demo_priority",
    Callback = function(v) end,
})

ModeR:AddInfobox({
    Title = "Mode Info",
    Text  = "Farm Mode controls target selection order. Priority filters which entity types are targeted.",
    Type  = "Info",
    Icon  = Hyperion.Lucide.Info,
})
ModeR:AddInfobox({
    Title = "Note",
    Text  = "These settings are saved to your config automatically.",
    Type  = "Success",
})

-- ============================================================
-- DROPDOWNS TAB  –  showcase new image arrow icons
-- ============================================================
local DL = DropTab:AddSection({ Name = "Single Select", Side = "Left",  Group = "Dropdowns" })
local DR = DropTab:AddSection({ Name = "Multi Select",  Side = "Right", Group = "Dropdowns" })

DL:AddInfobox({
    Title = "New Arrow Icons",
    Text  = "Dropdowns now use image arrows instead of text glyphs. Open one to see the up arrow.",
    Type  = "Info",
    Icon  = Hyperion.Lucide.Info,
})
DL:AddDropdown({
    Name     = "Weapon",
    Values   = { "Sword", "Bow", "Staff", "Dagger", "Axe" },
    Default  = "Sword",
    Flag     = "demo_weapon",
    Callback = function(v)
        Hyperion:Notify({ Title = "Weapon", Content = "Selected: " .. v, Type = "Info", Duration = 2 })
    end,
})
DL:AddDropdown({
    Name     = "Difficulty",
    Values   = { "Easy", "Normal", "Hard", "Insane" },
    Default  = "Normal",
    Flag     = "demo_diff",
    Callback = function(v) end,
})
DL:AddDropdown({
    Name     = "Team",
    Values   = { "Red", "Blue", "Green", "Yellow" },
    Default  = "Red",
    Flag     = "demo_team",
    Callback = function(v) end,
})

local multiOut = DR:AddInfobox({
    Title = "Nothing selected",
    Text  = "Pick options from the list on the left.",
    Type  = "Info",
})
DR:AddMultiDropdown({
    Name     = "Item Blacklist",
    Values   = { "Sword", "Bow", "Shield", "Potion", "Armor", "Ring", "Staff" },
    Default  = {},
    Flag     = "demo_blacklist",
    Callback = function(sel)
        local list = {}
        for k, v in pairs(sel) do if v then table.insert(list, k) end end
        table.sort(list)
        if #list == 0 then
            multiOut:SetTitle("Nothing selected")
            multiOut:SetContent("Pick options from the list on the left.")
            multiOut:SetType("Info")
        else
            multiOut:SetTitle(#list .. " blocked")
            multiOut:SetContent(table.concat(list, ", "))
            multiOut:SetType("Warning")
        end
    end,
})
DR:AddMultiDropdown({
    Name     = "Active Buffs",
    Values   = { "Speed", "Strength", "Defense", "Regen", "Stealth" },
    Default  = {},
    Flag     = "demo_buffs",
    Callback = function(sel) end,
})

-- ============================================================
-- VISUAL TAB  –  color pickers, sliders, toggles
-- ============================================================
local EspL   = VisualTab:AddSection({ Name = "ESP",     Side = "Left",  Group = "Visuals" })
local EspR   = VisualTab:AddSection({ Name = "Preview", Side = "Right", Group = "Visuals" })
local ChamsL = VisualTab:AddSection({ Name = "Chams",   Side = "Left",  Group = "Effects" })
local ChamsR = VisualTab:AddSection({ Name = "Info",    Side = "Right", Group = "Effects" })

local colorPreview = EspR:AddInfobox({
    Title = "No Color",
    Text  = "Select a color on the left.",
    Type  = "Info",
})

EspL:AddToggle({ Name = "Enable ESP", Default = false, Flag = "demo_esp", Callback = function(v) end })
EspL:AddColorPicker({
    Name     = "ESP Color",
    Default  = Color3.fromRGB(255, 80, 80),
    Flag     = "demo_espcolor",
    Callback = function(c)
        colorPreview:SetTitle("ESP Color")
        colorPreview:SetContent(string.format(
            "R: %d  G: %d  B: %d\n#%02X%02X%02X",
            math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255),
            math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)
        ))
        colorPreview:SetType("Success")
    end,
})
EspL:AddSlider({ Name = "Box Thickness", Min = 1, Max = 5,    Default = 1,   Suffix = " px", Flag = "demo_espthick", Callback = function(v) end })
EspL:AddSlider({ Name = "Max Distance",  Min = 50, Max = 2000, Default = 500, Suffix = " st", Flag = "demo_espdist",  Callback = function(v) end })

EspR:AddLabel({ Text = "Live color preview above." })

ChamsL:AddToggle({ Name = "Enable Chams",      Default = false, Flag = "demo_chams",      Callback = function(v) end })
ChamsL:AddColorPicker({ Name = "Chams Color",  Default = Color3.fromRGB(100, 200, 255), Flag = "demo_chamscolor", Callback = function(c) end })
ChamsL:AddToggle({ Name = "See Through Walls", Default = false, Flag = "demo_chamswalls", Callback = function(v) end })
ChamsL:AddSlider({ Name = "Transparency", Min = 0, Max = 100, Default = 20, Suffix = "%", Flag = "demo_chamstrans", Callback = function(v) end })

ChamsR:AddInfobox({ Title = "Chams",   Text = "Chams highlight character models with a solid color overlay.", Type = "Info",    Icon = Hyperion.Lucide.Eye })
ChamsR:AddInfobox({ Title = "Warning", Text = "Enable Chams must be ON for other chams settings to take effect.", Type = "Warning", Icon = Hyperion.Lucide.AlertCircle })

-- ============================================================
-- INPUT TAB  –  textboxes, keybinds
-- ============================================================
local TxtL = InputTab:AddSection({ Name = "Text",     Side = "Left",  Group = "Input" })
local TxtR = InputTab:AddSection({ Name = "Keybinds", Side = "Right", Group = "Input" })

TxtL:AddTextbox({ Name = "Target Player", Placeholder = "Enter username...", Default = "", Flag = "demo_target", Callback = function(v) end })
TxtL:AddTextbox({ Name = "Custom Tag",    Placeholder = "Display text above ESP...", Default = "", Flag = "demo_tag", Callback = function(v) end })
TxtL:AddDivider({ Title = "Send" })
TxtL:AddButton({
    Name     = "Submit",
    Icon     = Hyperion.Lucide.Check,
    Callback = function()
        local target = Hyperion.Flags["demo_target"] or ""
        local tag    = Hyperion.Flags["demo_tag"] or ""
        Hyperion:Notify({
            Title    = target ~= "" and target or "(no player)",
            Content  = tag ~= "" and tag or "(no tag set)",
            Type     = "Info",
            Duration = 4,
        })
    end,
})

TxtR:AddKeybind({ Name = "Toggle Farm", Default = Enum.KeyCode.F, Flag = "demo_kb_farm",
    Callback = function() Hyperion:Notify({ Title = "Farm", Content = "Keybind triggered.", Type = "Info", Duration = 2 }) end })
TxtR:AddKeybind({ Name = "Toggle ESP",  Default = Enum.KeyCode.G, Flag = "demo_kb_esp",
    Callback = function() Hyperion:Notify({ Title = "ESP",  Content = "Keybind triggered.", Type = "Info", Duration = 2 }) end })
TxtR:AddKeybind({ Name = "Hide UI",     Default = Enum.KeyCode.RightShift, Flag = "demo_kb_ui", Callback = function() end })
TxtR:AddInfobox({ Title = "Keybinds", Text = "Click a keybind then press any key to rebind it. Saved with config.", Type = "Info" })

-- ============================================================
-- MISC TAB  –  notifications, labels, dividers, infoboxes
-- ============================================================
local NotifL = MiscTab:AddSection({ Name = "Notifications", Side = "Left",  Group = "Test" })
local NotifR = MiscTab:AddSection({ Name = "Info",          Side = "Right", Group = "Test" })
local LabelL = MiscTab:AddSection({ Name = "Labels",        Side = "Left",  Group = "Labels" })
local LabelR = MiscTab:AddSection({ Name = "Infoboxes",     Side = "Right", Group = "Labels" })

NotifL:AddButton({ Name = "Info",    Icon = Hyperion.Lucide.Info,        Callback = function() Hyperion:Notify({ Title = "Info",    Content = "This is an info notification.",          Type = "Info",    Duration = 3 }) end })
NotifL:AddButton({ Name = "Success", Icon = Hyperion.Lucide.Check,       Callback = function() Hyperion:Notify({ Title = "Success", Content = "Operation completed successfully.",       Type = "Success", Duration = 3 }) end })
NotifL:AddButton({ Name = "Warning", Icon = Hyperion.Lucide.AlertCircle, Callback = function() Hyperion:Notify({ Title = "Warning", Content = "Something needs your attention.",        Type = "Warning", Duration = 3 }) end })
NotifL:AddButton({ Name = "Error",   Icon = Hyperion.Lucide.XCircle,     Callback = function() Hyperion:Notify({ Title = "Error",   Content = "Something went wrong.",                  Type = "Error",   Duration = 3 }) end })

NotifR:AddInfobox({ Title = "Notification Types", Text = "Four types: Info, Success, Warning, Error. Each has its own accent color.",   Type = "Info",    Icon = Hyperion.Lucide.Info })
NotifR:AddInfobox({ Title = "Duration",           Text = "Pass Duration (seconds) to control how long it stays. Omit for persistent.", Type = "Success" })

LabelL:AddLabel({ Text = "This is a plain label." })
LabelL:AddDivider({ Title = "Section A" })
LabelL:AddLabel({ Text = "Labels and dividers are purely visual — no flags or callbacks." })
LabelL:AddDivider({ Title = "Section B" })
LabelL:AddLabel({ Text = "Use them to group related elements or add notes." })

LabelR:AddInfobox({ Title = "Info box",    Text = "General information.",         Type = "Info"    })
LabelR:AddInfobox({ Title = "Success box", Text = "Something worked.",             Type = "Success" })
LabelR:AddInfobox({ Title = "Warning box", Text = "Check this setting.",           Type = "Warning" })
LabelR:AddInfobox({ Title = "Error box",   Text = "This configuration is broken.", Type = "Error"   })

-- ============================================================
-- SETTINGS TAB  –  theme picker + keybinds + config
-- ============================================================
local ThemeL  = SettingsTab:AddSection({ Name = "Themes", Side = "Left",  Group = "Appearance" })
local ConfigR = SettingsTab:AddSection({ Name = "Config", Side = "Right", Group = "Appearance" })
local KbL     = SettingsTab:AddSection({ Name = "Keybinds", Side = "Left",  Group = "Keybinds" })
local KbR     = SettingsTab:AddSection({ Name = "Info",     Side = "Right", Group = "Keybinds" })

ThemeL:AddThemePicker({})

ConfigR:AddInfobox({ Title = "14 Themes", Text = "Purple, Midnight, Rose, StarryNight, Aurora, Nebula, Sunset, Ocean, Crimson, Sakura, Vaporwave, Love, Christmas, Neko", Type = "Info", Icon = Hyperion.Lucide.Palette })
ConfigR:AddInfobox({ Title = "Auto-load", Text = "Open the config panel, select a config, then toggle Auto-load to restore it every startup.", Type = "Info", Icon = Hyperion.Lucide.Info })
ConfigR:AddDivider({ Title = "Quick Actions" })
ConfigR:AddButton({ Name = "Save Config",   Icon = Hyperion.Lucide.Save,     Callback = function()
    local ok = Hyperion:SaveConfig("demo_default")
    Hyperion:Notify({ Title = "Config", Content = ok and "Saved." or "Save failed.", Type = ok and "Success" or "Error", Duration = 3 })
end })
ConfigR:AddButton({ Name = "Load Config",   Icon = Hyperion.Lucide.Download, Callback = function()
    local ok = Hyperion:LoadConfig("demo_default")
    Hyperion:Notify({ Title = "Config", Content = ok and "Loaded." or "No config found.", Type = ok and "Success" or "Warning", Duration = 3 })
end })
ConfigR:AddButton({ Name = "Delete Config", Icon = Hyperion.Lucide.Trash,    Callback = function()
    Hyperion:DeleteConfig("demo_default")
    Hyperion:Notify({ Title = "Config", Content = "demo_default deleted.", Type = "Warning", Duration = 2 })
end })

local KbList = Hyperion:CreateKeybindList({
    Title    = "Keybinds",
    Position = UDim2.new(0, 16, 1, -16),
    Keybinds = {
        { Name = "Hide UI",     Key = Enum.KeyCode.RightShift },
        { Name = "Toggle Farm", Key = Enum.KeyCode.F          },
        { Name = "Toggle ESP",  Key = Enum.KeyCode.G          },
    },
})
KbList:SetVisible(false)

KbL:AddToggle({
    Name     = "Show Keybind List",
    Default  = false,
    Flag     = "kb_show",
    Callback = function(v) KbList:SetVisible(v) end,
})

local kbFarm = Enum.KeyCode.F
local kbEsp  = Enum.KeyCode.G

KbL:AddKeybind({
    Name     = "Toggle Farm",
    Default  = kbFarm,
    Flag     = "kb_farm",
    Callback = function(v)
        if typeof(v) == "EnumItem" then
            kbFarm = v
            KbList:UpdateKeybind("Toggle Farm", v)
        end
    end,
})
KbL:AddKeybind({
    Name     = "Toggle ESP",
    Default  = kbEsp,
    Flag     = "kb_esp",
    Callback = function(v)
        if typeof(v) == "EnumItem" then
            kbEsp = v
            KbList:UpdateKeybind("Toggle ESP", v)
        end
    end,
})

KbR:AddInfobox({
    Title = "Keybind List",
    Text  = "Toggle 'Show Keybind List' to show a floating overlay on screen listing your current keybinds. Drag it anywhere.",
    Type  = "Info",
    Icon  = Hyperion.Lucide.Info,
})
KbR:AddInfobox({
    Title = "Live Updates",
    Text  = "When you rebind a key above, the overlay updates automatically to show the new binding.",
    Type  = "Success",
})
