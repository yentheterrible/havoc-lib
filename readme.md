# havoc library

> a lightweight, high-performance luau interface framework and utility library.

```text
language : luau
license  : mit
status   : active
```

---

### overview

`havoc lib` is built for performance, minimal memory overhead, and smooth runtime execution. it provides clean interface management, responsive scaling, built-in themes, drag-and-drop window handling, and secure callback execution out of the box.

---

### quick start

```lua
local HavocLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/yentheterrible/havoc-lib/main/init.lua"))()

local Window = HavocLib.new({
    Title = "havoc lib",
    Subtitle = "made by yen",
    SearchEnabled = true,
    ShowStatus = true,
    ShowMetrics = true,
})

local Tab = Window:Tab({
    Name = "main",
    Icon = "home",
})

local Section = Tab:Section({
    Name = "general",
    Icon = "sparkles",
})

Section:Button({
    Name = "example button",
    Callback = function()
        Window:Notify({
            Title = "success",
            Content = "button clicked successfully.",
            Duration = 3,
        })
    end,
})
```

---

### structure

```text
├── havoclib.lua    : core library source
└── README.md       : documentation
```

---

### socials

- **discord** : [convictedx](https://discord.com/users/convictedx)
- **email** : [yenthet3rrible@gmail.com](mailto:yenthet3rrible@gmail.com)
- **github** : [@yentheterrible](https://github.com/yentheterrible)
- **tiktok** : [@frostyyontiktok1](https://www.tiktok.com/@frostyyontiktok1) / [@yentheterrible._](https://www.tiktok.com/@yentheterrible._)
