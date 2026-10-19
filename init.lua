local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Workspace = game:GetService("Workspace")

local Theme = {}
local CONTROL_RIGHT_INSET = 14
local SIDEBAR_WIDTH = 220

local function isFiniteNumber(value)
	return type(value) == "number" and value == value and math.abs(value) < math.huge
end

local function normalizeVersionLabel(value)
	if value == nil then
		return nil
	end
	local textValue = tostring(value)
	if textValue == "" then
		return nil
	end
	if textValue:match("^[vV]") then
		return textValue
	end
	if textValue:match("^%d+$") then
		return "v" .. textValue .. ".0.0"
	end
	if textValue:match("^%d+%.%d+$") or textValue:match("^%d+%.%d+%.%d+$") then
		return "v" .. textValue
	end
	return "v" .. textValue
end

Theme.Colors = {
	Background = Color3.fromRGB(13, 13, 15),
	Surface = Color3.fromRGB(19, 19, 21),
	SurfaceAlt = Color3.fromRGB(31, 31, 34),
	Container = Color3.fromRGB(39, 39, 43),
	Interactive = Color3.fromRGB(51, 51, 56),
	Accent = Color3.fromRGB(226, 226, 230),
	Primary = Color3.fromRGB(227, 227, 231),
	PrimaryStrong = Color3.fromRGB(246, 246, 249),
	ToggleOn = Color3.fromRGB(207, 207, 214),
	Border = Color3.fromRGB(75, 76, 83),
	Text = Color3.fromRGB(242, 242, 245),
	Muted = Color3.fromRGB(192, 193, 201),
	Icon = Color3.fromRGB(176, 177, 185),
	Success = Color3.fromRGB(105, 225, 172),
	Glow = Color3.fromRGB(227, 227, 231),
}

Theme.CornerRadius = UDim.new(0, 16)
Theme.Stroke = {
	Color = Color3.fromRGB(255, 255, 255),
	Thickness = 1.1,
	Transparency = 0.83,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	LineJoinMode = Enum.LineJoinMode.Round,
}
Theme.PanelTransparency = 0
Theme.HoverDuration = 0.2
Theme.PressScale = 0.985
Theme.OpenScale = 0.95
Theme.Padding = 16
Theme.Font = { Caption = 13, Body = 14, Label = 14, Heading = 17 }
Theme.Animation = {
	Hover = TweenInfo.new(Theme.HoverDuration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Press = TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Release = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Open = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Fade = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
}

-- Lucide icon atlas support. ImageLabel renders raster images;
-- custom executor asset URIs are supported when a matching API is available.
local LUCIDE_CELL_SIZE = 96
local LucideStarterPositions = {
        ["house"] = Vector2.new(0, 0),
        ["settings"] = Vector2.new(96, 0),
        ["search"] = Vector2.new(192, 0),
        ["info"] = Vector2.new(288, 0),
        ["check"] = Vector2.new(384, 0),
        ["x"] = Vector2.new(480, 0),
        ["plus"] = Vector2.new(576, 0),
        ["minus"] = Vector2.new(672, 0),
        ["chevron-down"] = Vector2.new(768, 0),
        ["chevron-up"] = Vector2.new(864, 0),
        ["chevron-right"] = Vector2.new(0, 96),
        ["chevron-left"] = Vector2.new(96, 96),
        ["menu"] = Vector2.new(192, 96),
        ["list"] = Vector2.new(288, 96),
        ["layers"] = Vector2.new(384, 96),
        ["arrow-up-right"] = Vector2.new(480, 96),
        ["move-up-right"] = Vector2.new(576, 96),
        ["arrow-right"] = Vector2.new(672, 96),
        ["arrow-left"] = Vector2.new(768, 96),
        ["arrow-down"] = Vector2.new(864, 96),
        ["arrow-up"] = Vector2.new(0, 192),
        ["crosshair"] = Vector2.new(96, 192),
        ["eye"] = Vector2.new(192, 192),
        ["eye-off"] = Vector2.new(288, 192),
        ["users"] = Vector2.new(384, 192),
        ["user"] = Vector2.new(480, 192),
        ["lock"] = Vector2.new(576, 192),
        ["unlock"] = Vector2.new(672, 192),
        ["shield"] = Vector2.new(768, 192),
        ["bell"] = Vector2.new(864, 192),
        ["calendar"] = Vector2.new(0, 288),
        ["heart"] = Vector2.new(96, 288),
        ["star"] = Vector2.new(192, 288),
        ["bookmark"] = Vector2.new(288, 288),
        ["package"] = Vector2.new(384, 288),
        ["gift"] = Vector2.new(480, 288),
        ["activity"] = Vector2.new(576, 288),
        ["zap"] = Vector2.new(672, 288),
        ["sparkles"] = Vector2.new(768, 288),
        ["wrench"] = Vector2.new(864, 288),
        ["hammer"] = Vector2.new(0, 384),
        ["compass"] = Vector2.new(96, 384),
        ["globe"] = Vector2.new(192, 384),
        ["file-text"] = Vector2.new(288, 384),
        ["message-circle"] = Vector2.new(384, 384),
        ["panel-left"] = Vector2.new(480, 384),
        ["filter"] = Vector2.new(576, 384),
        ["sliders-horizontal"] = Vector2.new(672, 384),
        ["circle-help"] = Vector2.new(768, 384),
        ["external-link"] = Vector2.new(864, 384),
        ["download"] = Vector2.new(0, 480),
        ["upload"] = Vector2.new(96, 480),
        ["copy"] = Vector2.new(192, 480),
        ["edit"] = Vector2.new(288, 480),
        ["trash-2"] = Vector2.new(384, 480),
        ["play"] = Vector2.new(480, 480),
        ["pause"] = Vector2.new(576, 480),
        ["power"] = Vector2.new(672, 480),
        ["rocket"] = Vector2.new(768, 480),
        ["circle-check"] = Vector2.new(864, 480),
        ["circle-x"] = Vector2.new(0, 576),
        ["alert-triangle"] = Vector2.new(96, 576),
        ["maximize"] = Vector2.new(192, 576),
        ["diamond"] = Vector2.new(288, 576),
        ["camera"] = Vector2.new(384, 576),
        ["monitor"] = Vector2.new(480, 576),
        ["smartphone"] = Vector2.new(576, 576),
        ["code"] = Vector2.new(672, 576),
        ["link"] = Vector2.new(768, 576),
        ["book-open"] = Vector2.new(864, 576),
        ["folder"] = Vector2.new(0, 672),
        ["database"] = Vector2.new(96, 672),
        ["volume-2"] = Vector2.new(192, 672),
        ["rotate-cw"] = Vector2.new(288, 672),
        ["grid-2x2"] = Vector2.new(384, 672),
}
local LucideAtlasRegistry = {}
local LucideAliases = {
    main = "house", home = "house", movement = "move-up-right",
    aimbot = "crosshair", target = "crosshair", visuals = "eye",
    esp = "eye", exploits = "wrench", general = "settings",
    tune = "sliders-horizontal", welcome = "sparkles",
    aim = "crosshair", layers = "layers", list = "list",
    combat = "crosshair", person = "user", lightning = "zap",
    bolt = "zap", info = "info", user = "user",
}
local function normalizeLucideName(name)
    if type(name) ~= "string" then return nil end
    local normalized = name:lower():gsub("^lucide:", ""):gsub("^lucide/", "")
    normalized = normalized:gsub("([a-z])([A-Z])", "%1-%2") -- separator-compatible names
    normalized = normalized:gsub("[_%s]+", "-")
    return normalized
end
local function normalizeRobloxAssetId(assetId)
    if type(assetId) == "number" and assetId > 0 then
        return "rbxassetid://" .. tostring(math.floor(assetId))
    end
    if type(assetId) == "string" then
        if assetId:match("^rbxassetid://%d+$") then return assetId end
        if assetId:match("^%d+$") then return "rbxassetid://" .. assetId end
    end
    -- Executors may return opaque custom-asset URIs (typically rbxasset://... or content://...). 
    if type(assetId) == "string" and assetId ~= "" and not assetId:match("^https?://") then
        return assetId
    end
    error("Lucide atlas needs an asset ID or a supported custom asset URI", 3)
end
local function registerLucideAtlas(assetId, icons, cellSize)
    local image = normalizeRobloxAssetId(assetId)
    assert(type(icons) == "table", "Lucide atlas requires an icon map")
    local cell = cellSize or LUCIDE_CELL_SIZE
    assert(type(cell) == "number" and cell > 0, "Lucide atlas cell size must be positive")
    for name, offset in pairs(icons) do
        local key = normalizeLucideName(name)
        assert(key and key ~= "", "Lucide icon names must be nonempty strings")
        local pos = offset
        if type(offset) == "table" and offset.Offset then pos = offset.Offset end
        if type(pos) == "table" and type(pos[1]) == "number" and type(pos[2]) == "number" then
            pos = Vector2.new(pos[1], pos[2])
        end
        assert(typeof(pos) == "Vector2", "Lucide atlas offsets must be Vector2 or {x, y}")
        LucideAtlasRegistry[key] = { Image = image, Offset = pos, Cell = cell }
    end
end

-- Executor-friendly Lucide atlas loading (no Roblox Creator Hub upload required).
-- The embedded PNG is extracted only when a compatible filesystem/custom-asset API exists.
-- Missing executor features never prevent the rest of Havoc from loading.
local EMBEDDED_LUCIDE_PNG_BASE64 = [=[
iVBORw0KGgoAAAANSUhEUgAAA8AAAAMACAYAAADrPg4vAAEAAElEQVR4nOzdZ9grVdn28XPRQZSuAlJsgIqCqIBKlaKIBVQs2LC3RwW7+IrYsQC2Rx97w4YF
FAFlU1WkIyhIE9hIl9427Pp/P6y5Jcy9Jpkkk8xMcv6O4z5gJ5k116wkk7lmNcnMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM
zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM
zMzM+gCsDDyo7jjMzMzMrLxQdwBmZk0FrC5pe0lbS9pI0iaSHi5p1dxLb5d0g6SLJF0q6XRJp4QQbhtXrGZmZmZmZmZ9AdYG3gecDSxmcIuBs4D3AGvXfVxm
ZmZm1uIWYGAFSc/L/vn7EMJ9dcZjNirAaoqtj2tLelD2d5ukeyRdJemyEMKC+iKcDMDWkj6keF5ZuuLiF0s6StJBIYQzKi7bzMzMzCYZsBHwj46Wln8AG9Ud
l1kVgDWBNwE/A64t0dK4CPg78CVgN2CZuo+hTYDNgeOHaOnt1xxgs7qP28zMzMxaAHgBcFviovJOYK+64zMbFPAs4EhgwZAJ1o3AwcB6dR9TkwEPAb5MvIFQ
1kLgCmL36JOyv7OBK7Pn+innUODBddeDmZmZ2TRpTRdoYGlJH5V0gIrjRtJXJb0vhLBwXLFNI2BLSe+VtHqPl94q6eAQwpmjj6qdgG0kfV7S0ysueoGkH0j6
aAjhPxWX3WrA0yT9XNKjerz0BknHSTpJ0pmS/lXU3RxYTtKjJW0laUdJz5b0sB7lXy7ppSGEc8tHb2ZmZmYTDXhY1tJS1klArwtPGxCwHnB3H+/H3bg1chZg
VeD7wJI+6nIQtwJvrvt4mwJ4OzC/S30tBn5J7E4+8FhgYBngucCv6D6Z1n1+f8zMzMxMkgQ8FZg7wEX/tcAz645/EgH7DPB+7FN33E0CbEnsNtvLQuJMwj8A
PgrsC7wZ+ADwWeDXJcuBmIitUvex1wUIwKe71M/irJ4rn08A2Bj4Md1vdnyi6v2a2WQCliP2OjEzs0kCvJPi8ZALsud7vqbu45g0xASsX27hygAvIbb6FVkA
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
ZmZmZu0H7AYsLHEB2HQLiV1ELQO8ZIB6fEndcVtvTNE6ncCDiWtV93OeWkS8uXc2cHL2d3b2WD8Tly0AvojX+TUzMzObHMBziJP3tNWVOPmdBViBB67j2Ms5
wAp1x23lMGXrdAJPAv5YzSmjlGOBTes+bjMzM7NpVDQZS2WIXYefKekxkpbuY9NlFCemkaR/qP9JqIbZfrHiRE+nhhCmavKrsrKE9nmSVu/x0lsl/T6EcN/o
o7KqAMtJ2j3759HTMNEKcSmRDyt+rqse8rBI0u8kfTaEkFp/2czMzMzMzGy8iGtV7weczuDrMZNtexrwbuBhdR+XmZmZmY2hBdjMrK2AVSVtL2lrSRtJ2kTS
2pJW1f3nTyTdLul6SRdLulTSaZJOCSHcMdaAzczMzMzMzKoGPAh4UN1xmJmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZ
mZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZ
mZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZ
mZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZnZhAGWA5arOw4zMzMzMzOzkQDWAr4K3JX9fRVYq+64zMzMzMzMzCqRtfi+
G7iN2e4CDgRWrDtOMzMzMzMzs4EAAXglcFUi8c27KnttqDtuMzMzMzMzs9KArYFTSyS+eWcDO9Qdv5mZmZmZmVlXwMbAkQMkvnlHAhvXfTxmZmZmZmZmD0Cc
4OprwIIeie1cYO/sb26P1y7IyvREWWZmZmZmZlYv7p/g6vYeyeysya7oPjlW123NzMxs+niiEDMzqwVxsqqXSPqcpEd2eelCSd+XdEAI4caCslaX9AFJ+0pa
vktZ10j6pKTvhBCWDBC22cgR17h+0Bh3eXsIgTHur9Wy90chhAV1xzKNXP/1cv2bmZkNgPITXM0BNu2j3I2Aw4ElPcr1RFnWSMD+wD0lvhtVmgs8s+5jbwPg
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
XHPYbBDUPNuzVQfYiRaOeWwr4JCCur4HeFbd8U06+msJ9s2fYZDuwugfh5bIfujP6Xj/WtWFs0q4C/TY4S7QjUJcTujdwG09jvMu4EBKvFdDxNBrMq2RxWDT
jdldwGc4+W0RYF2Kf9Od/I4IxUnwxA5RaRLKJcGtSn6bPAnWzCQ2UssmgTG/f53wJFhjhyfBahxgdUkfkLSvpG4J/TWSPinpOyGEJUPuM0h6iaTPSXpkl5cu
lPR9SQeEEG4cZp9mecQZyedp9jVX5ROO2WgBr5b0o8RTh4QQ3jvueKZJlmDtl3hqIicpbJrsBk/RpFb+/JuZmRUBNgIOB5b0uJt8NrDDEPvZGji1xF3rOcCm
FR6i2SzAVbnPnVt+Wyg7r+S55XdMSLcET+QydU1EekywP/9mZmZlZBeSf6k6QeX+BLuXgWaiNhsE8ExgLvHGzx9w8ttaxOEy92R/B9Qdz7QBDuio//3rjmfa
AB/tqP+P1h2PmZlZq1DhRFl4gitruOzzvnLdcdjwiPMKtGVY08Rx/dfL9W9mZjYkhpgoC09wZWZmZmZmZm0DrAl8FVjQI5m9Cnhl9pcfW5m3ICvTa6yamZmZ
mZlZsxDH8R7RI7Et4whgo7qPx8zMzMzMzKwryk+UlecJrszMzMzMzKxdiBMH7U2cQbeXudlrG7vGvZmZmZmZmVlXdJ8oa2aCqxXqjtPMzMzMzMysEtw/UdbM
OoSe4MrMzMzMzMwmF16H0MzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM
zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM
zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM
zMzMzMzMzMzMzMzMzMzMzMxKCnUHYO0FLCdJIYQFdcdiZmZmZpPP15/1AZaR9ODsn3eFEBbVGY/ZWAH7A/dkf/vXHY+ZmZmZTSZgFeDVwO+Aednf77LHVqk7
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
WdMQW4LP7fhOndOG7xFwYEfMjegCxewuXAeOc/u6tSn+Jn5+qkScUO9/gLklfkfH7RbgU8BD6q6nUcH13zrE1uCzB6jPc3Cr79CY8C7QrZ4Ey8YLWFrSIyW9
VdJ7c08frDiJwdwQQtFdOzMrgZjwPi/75+/bMtEZ8ExJG6tBk2Bw/yQel4QQTh339nVrU/xN/PxUjTh+8cmKS9+sWm80ukvSXElnhRAW1RzLWLj+2yW77vwf
xQmuet0guFPSxyR91deh1cCTYJndD9gqcceniWvrmZmZmVmLAWsSeyPel7j+nA98CVir7jjNbMLhdZjNzMzMbEyADYBvdlx/fht4ZN1xmdkUIS7gvlzdcZiZ
mZnZdPD1p5mZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZ
mZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZ
mZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmNV6g7ADMzM6sH
sKKk3SU9VdK6klaVdLmk8yQdHkKYN2C5K0l6qaQnS3qUpNslXSvpLElHhxDuGzJ0M2s44PWSXizpn5I+HUK4vd6IzMzMzGwqAQ8GvgTcQbGbgP2A0jfLgQC8
B7i5S7l3AIcADx7lMZpZfYDX5773x9Ydk5mZtRywHLBc3XGY1cGf/8EB2wBXd0lQ847MWnR7lfsg4Hd9lHsV8IxxHLPZqAAr08dNomkBnJn4zj+y7rjMzKyl
gA8C92R/H6w7HrNxAdYCvgrclf19FVir7rjaAng6cGcfSeqM3wPLdCl3WeCYAcq9G9hunHVgVgVgFeBYYAkwF3hm3TE1BbBOVi9576o7NjMzayFgx9wPyxJg
x7rjMhslYovvu4HbEhdVdwEHEsezWgHgYcAtAySpMz7XpewvDlHuzfgmhrUIsav/73Of46vqjqspgLcUfNfn1B2bmdTASbCALSU9XtJxIYTrKipzHUm7Svpn
COHMKsqcBMBDFev6EZJmurfdJOkqSReEEBZUtJ/lJD1B0gaSHpo9fI+kaxTfk5uq2M+0AE6RlG8x+VMIYfs64mmT7Pyyed1xFDjP56fZiF0L95b0GUnr93j5
vyXtL+mnIQRGHVvbAD9RrMu8syV9TdIZipNV7SLpi7r/fD1jiaTtQwh/yZW7vaQTJS2Ve/2Nkt4n6XjFybW2lvROSVskYvhRCOG15Y/GrD7ABySlbgitGkK4
Y9zxNA1wlKTnJZ5aKGmtYeoou6bcPfvn0VVdq5rVBvhIx12iO4HUj2S/ZW7BA7t7faSKWNsKeCpwKHBJjzvy9wEnAu8EVh9gP6tn256YldXNJVlMQ7/fkw7Y
vks9OgHuInd+aar9666nJgG2Bk4doB7PBnaoO/4mATYg3SXxUGDpxOsfCVybeP25wFIdr1saOD/xumuADRLlLg18JfH6xcB6o64Hs2EBzwAWFJx7Vqs7vroB
qwHzCuoH4DVDlL08cEZHWWcAy1cZv9lYAcskvjCHVVDuYbky59FlHNOkInab/UuXE1I384AvU6KLGvBQ4sVNt5NfN3/GiVwh4IQudXd83fE1FenzSxPdwxSe
n/KAjYkTLw3rSGDjuo+nCYjzBuTNocvkPcQL/UWJ7fbueM2rE88vBLbuUm4gfS57f9XHbVYlYnJ3ZZdzzlQmwMQxv28GjqLcb+05xGErW3Q7ByX287JEWS8b
5bGZjVR2Usk7roJyj5vmExSwBvCzEiejMm4D9umyr9eTHp83iMOYovepDOLkNb1sW3ecTUT6/NJUq9ZdX3UhTnD1NYpbV2bMBfbO/ub2eO2CrMypHmPK7PGK
ANuU2O5Lie3O7Hj+7MTzXyxR7o6J7X477HFOGuLv6tHAF5jic0MTEG/c9LoxN1XXLcQbYGeS7l1S1tXA54BVSuzv+4ntvz+OYzUbCZwAVw54MnGZiar9gI4u
J8QuKT8ewX6uBDarsw6bBPhjiTr7Q91xNhGxS35brFp3fY0b909wdXuPupk12RXdJ8fquu00Af6Rq4/76OjK3GW7NQrely2JXdTzbqPEbyyxK/T83LbnVXKw
EwJ4Q65+jqk7pmkGfKDHOYYyn/1JAbyuRH30o+s6wcQbEKlhGdfiZaisT7V8YApOEKtKuiL32MmSXjTk7n4jaYfcY49SnOjjAWGFEPKPtRZxOv5jJT24y8su
kfQXSZcq1sdSktaRtJmk7SV1uxt3nKQ9sv//reKkKUXukHSKpPMl3SBpkaTVJD1W0jaSunVRvEPSbiGE07q8ZuIRuxPm62BR9t98l9mnhxBOH31U7ZGdc27N
PXyRpC+NP5oH2FfS43KPrTZJ56JusouWlyhOJtNtfciFkr4v6YAQwo0FZa0u6QOKddptTNg1kj4p6TshhCUDhN1KxBlqOycR+08I4WElt/2ypPzyJT9WvIZ4
Ve7xQ0MI7ylZ7s2S1uh46MoQwqPKbDsNgAsUJ5DstG5VE4RaecBWkv4kqdfa46uHEG4bQ0i1A46U9MISLz1OcSLankVKWimEcF/B/p4g6YKCbTcNIVxYYh9m
4wOsCXyCeAe6V9e2Os0DTiNO3rRC3fU2KOBJwB0Fxzgf+AbxRNKtjOWBlwBndamvOdlfkTOyMrr+YABPBL5F8Wfjtl7xTjpiF7i8H2V/eUfXHW/TkG4B/mMD
4kp9f1atO65xoPwEV3OATfsodyPgcHp3yZuqibKA03PHvxhYueS2Gyfq897sr9MS4LEly3xwosy/DneUkwN4WsHn9hV1xzZt6D3ut9M0tQB/oWSdlO0e3XUZ
KWC/LtvuN67jttmI35EdmfKhRg9AHLBelIw12b+Ap9Zdf/0iLsz+r4Jj+it9TghD7HLyRmL3wbLuJHaN6auHAfA4Zl+kzbgU6NaaPbGIk0Tkf0AWAZsAjyU9
Sc3T6o67SXAC3Bjcn6D2chZDTIhHTLDLTPzXV4LdVqTngnhlH9tXOgSD9ORZPx3s6CYPcdx6yv/VHds0Ib3eL8Tf5JsSj09TArwKcdKrKlxO7LnYbX/Hdtm+
a/dpGx3gudyf580D9qw7ptoRE6dhBsbX7S56fCGbBvh2wbF8D1h2iHKfAPy7RJ1dBeS7dPazn+WIY4xTvjFouW0G/DZRFz/peP6niec9mUwHnADXjjiW9CBm
j/vMu5o4m2jP8akl9hmAvYgXV90sBL4JlOoS3EbAKxLHfRkleztRbrxfqXV8gRUL3pOXDneUk4H4O5hKrgAurju+aULxuN/PM8VzzHQCNgTeBRxPf708/0n8
TXgGPc73xF6J93Qp6x68HNLYEK+pnkpslV+Yey8WMM1JMLBZn1+EprqeljTpA08hdmvL+wEVTBBAXBey26RaVwHdxvGV3c9SzF6+iuzYNh+2/DYBNmf2TaTF
dLRYEVvOU+9763owjApOgGvDEBNcjSCG2+qKoW7ELsd3J4755yTWAU5svxbp3iYzFgJrlChnaeCXie3vBB5UzdG2G/GmTTfr1B3jNAC2In3D7gziOcUJcA6x
Vfg1dG/8+h7wmD7L3anHdwJgp1Ed17TLPu8vJM7CfWWJ92IBsEfdcdeC4m4RV3L/2NHOv5MTr72l4LX9/N2SKPfkxOuOB24oiPkrdddnGcDvErGfQ4V3xShO
gitJfjv2swJwXmI/R1S1jzYAfpOog18kXpfqUvrrOmJuIpwAjx33t75ekTjGTgsYU+tr9jk4iDgDcjeVtUI3CfDhguM9gjiJWK/t/9Slzk4qsf0apHu0AHyw
mqNsP9Jdbjt5HPCIUTzu91Zgw+w1ToALEK89i5SaJyBX3kE9vhMAnx3FsUwz4o3T/0dxftTNfKZtOB7xRy7fJL4EeAsFLZE0YBkkYheLbyRefxcNbxEgJqb5
VsDFwBYj2tfcjv3MpcLkt2M/Tys4pg2q3lcTEbud549/CfCkYV47jXACPFbZd7fbBHozjgA2qiG+jbJ993IWE/QDTvyNu7jgWK8mdnMuHCoD7N+lrj7UZbvl
iOvZXlOw7T/pMVnitAAexuzrpzyPAx4hitf7XQK8sON1ToALEHvSpAw0UzNwbo/vBMA5VR/HNCPO03BjiXrv5tC6j2OsgOckKuHnPbapPQHOXr8U6YmYdhg2
llECPpSIeVZLYYX7Wwt4X/Y3si7iwK8Tx/X+Ue2vSeizVZeSrcXTCCfAYwOsS+zO2s2ZwHYNiHW7LJZu7gTWrTvWqhCT/24XNXOBj5G4eQps22W7Z+ReG4gT
+B1I9/kjrmeAFqFJBby/x+cRPA54pOgy7jf3OifABbLvfspBA5T1UGbf4L+W2WsCLwYeOorjmSbEVt/UMJVBfLju4xkrYJ9EJbyjxzarJLYpPaNkl3L/kCi3
2/q2AvZNbPOaYWMZJdJdyHesO65hAbskjuvEuuMaNQYY10uJ8cLTCifAY0Mc/9XNu6lgToKqEBO1d/eIudHn/16Ik06t1vG3HbErZy/XErvjHkLswfVi0uOA
FwIvyl5zSLbNdSXKvxl4Zi621i5BWAXggkQ9pcahehzwCNBj3G/utU6ACxDPq1cn6ucZvbeeVdbeiXJ+QHrC1L1HcTzTAng4cH6iXru5i3jeP4y43O3Mdehp
9Mi3Jg5x7FTem0tslx9b+oUKYsmvU9Z1nbFsm7ck4n/TsLGMCrAMs2fHu5USE5s0XXZs+clz7mbCxublMeDMzqTHgf+k13aTDifAY0P6/N/pdmKPldoTHeJc
Ax9KnGPyev5+NU12bJ8GLqT75FVNs5DYKv9hYJm663GcSK/9ewPw3cTjHgdcMUqM+8293glwF8SkqNNVDHDtRpx4KW9v0onx90dxLNOA2NJ+UaJOu7mR3DAh
YhL9eBp0o3tsGDwBfiax+9US4npfQ985ILYsH5uVOZcSyxrRvgT4UYl4J2ZNNNJJwkSNAyaOzXsCsCfwEQZc25c4LX3eIuCjwEuIs7OvNI5jahKcAI8NvRPg
GVcBr6SGH0li68Qr6T6rfadWJcDZ5/3CksfWZH8CVq67PseF9Nq/nye9hJXHAVeIkuN+c9s4Ae6CAa6/E2U8mtldnZcQk7WHMrvX27XAo0dxPJOMeA3618Tn
uZvL6HM27yZp1N3VEMKpxMmUHhRCuLuiMu+QtBvxR/SeEAJVlNswqa5Ql489itG5XNLOucfWltSzNb9JiBf660t6rKSNJG2c/XcjSRtI6tZif2wI4axe+wgh
nA0cI+m5HQ8vLekTuViukXRZ7u9SSVeEEOaXPSazIawv6TBJ+wHvCyGcPI6dAltLOlhS313xWuRrkh5fdxAV2FbS5yR1HUI1CYjda1+WeOrHkm5OPL7DSAOa
Pu+XlEp0vxhC6Nn7ymYb5PqbeAP4WZJ2kbSrpEclXnZeCOE/2evPk/TkjufWkfQv4ApJx0maI+nEEMLtgx/JVDhI0tP7eP1Zkp438z70A1hf0o11X2s2KgGW
pOwLUknymyu38jIbJDVD9Z1jj2J07kg81tj1IonLicwktjNJ7kzSO+hs4p/s87XP7fGaR2R/+XHii4F/64FJ8cz/zw0hLOojDrMZd0gq6tHzFEknEbv4fzCE
cMkoAgA2Vkymkq05HbrF2njEsaGT1D32bcABIYRb6g5kxF4oac3cY2eFEP4hScAlir8nMzYG1gkhXDeuACcVsJXSv7FnSvp/Yw5n4nS7/iYOc9hK9ye8W6p7
Y4AUE9vO/39y4jWPkvTW7G8xcKbuT4jP8LXM/YCnS3pXH5scK2mvEMI9fe5nHUlHSdpC0u3Aq0IIR/dTRpUalwDbQFJf5MrW/m2A1FjBBWOPogviLKYHK95B
y1/EDOu4EMJpZV8cQjidOIP6rgPsa2lJj8z+8tsvBM6S9I4QwnkDlG3T64OSblW8y5y6oy/FBGB34HuSDggh3FjFjoE1FFt39pPUbamdaxQvgpeS9I0q9l2T
1NJ3l2mwHjNB0kqKNxwfpHjNsIqkVXOvu13xxsEiSfdkf/MkDdLj6rGKPWI6Y9haUm0XSmPy2sRjP+z4/5P1wARYkraX9LNRBTQNsi7LP9fsc8Ntkl4WQmjU
tcYkyLrNziS8O6r/G46/zf1/rzXEl1a8Nnu6pI9JuoO4bvlxkuaEEP7V5/4nzSGKv3udrlBsAHlO7vGjJL2o3xsIWfJ7suL5XYq/Id/LbuIt7jfgKowzAd4X
2GuM+xtG25a8SHWPesTYoxid1LGkjrkWxEkdjtLsi5MqnClpkPHnb5T0S8U7q1VZVrHb6G+BR9V10rJWIoTwy6yV922SDtTsJEqKv0lvlrQ3cLCkz4UQ7h1o
h7FL6dskfVzdL7DuVrx5dVAI4T5aNt43ITUk5oshhG9VUXhWP9/MPfzBCst/k6R8WZP0ezYL8DBJz849vEBS5zJ2p0h6S+41ToCHkA1L+rGkDfNPSXpNCGHu
AMUeASwcIqwFkn4TQvjuEGU0Tta1+QDFG51FN0F7mSfp050NAiGE04CPSPqI4s26MlaRtEf2p6y79G8lfWLaukoDuyjeYOy0WNLeijci8wnwchUkvzMeKump
ks7op7yqjCoBXjXx2OOyv7Zate4AurhC0hI98A5OqhWgrfLHsljSlXUEUuBhGi75XaD4Hl6s+7sdXyrp4kHGV0hSCOFqSVsT12ie6YKd/xu0G/n6iieu6wfc
3qZU1pryZeDHkj4gaV+le6usrHin/g3AJyV9J4SwpMw+sovalyh2d35kl5culPR9VdjabDag12j29dhvQwidN3pPTmy3w6gCmhLvl7R74vGDQwi/H7DM7YeI
Z8ZzAU1YEvwzzU6myrhI93ddPjnV7TaE8Bngy4rfh5mW5X7yjUcp9hB6nKTdBoixzVLzK3w7hHAGcIHiTYfOGwvPAtYoOySlS/I7YytNWAI8ipawum1SdwBF
Qgj3ABfrgZOePAZ4TNu7dgCP0+y7s/8MIdxXQzhF/iPpaknr9Xjd1bo/ub1U0iXZf68a1XiUEMJNkm6SdGr+OWBdzU6KN5L0aHXvQn+pJCcMNrAQwq2SPgR8
V9KnFRPW1GzQj1BsbXxzmYmy+pjg6nhJ+4YQLuw3drMReHXisc7uzwohXO9xwNUhrkf7qcRTp0nav2QxpW7KDeiFkiYiASYueZfv4dDNzZI+K+mX2c38nrLE
+OjsT8B6kvaS9GGVH5b2bGCFhl1fjkzW/T+f8C+U9Bnpv7nFMYq/zzOWVWw57/nZLJH8SjVO1jiqtVQHarVquKZf8J+QeGyfcQcxAqlxUcePPYousq7AL1V6
si4pdmNeNYSwfghh5xDC20MIXwohHBtCuLyuyRhCCNeGEE4OIXw7hPCBEMKeIYQnKP5YnFOw2X8kvbhsa5xZNyGEy0IIL1VMWGfdpOkwM1HWHGDT/JPARsDh
ihev3ZLfsyXtEELYxcmvNQFxebsn5h6+UVJqmbaTE49V0eI4VbJ5AX6ueDHf6VZJLw8hlO3C/I9KA3ugS0dY9lhlCWWpRDazpqTPS/oF8HHiEqk9G+yAZbLX
Hqg4fODz6m9OlqunJfnN7KzZY9+Pzt10+GViu57DWUsmv1J6yM5YjCoBblL31Ko0/Zh+lXjs7dmMxK0ErKk4g19e6lhrFUI4XXHq/lS3kC0l/QRo/MRkxDWC
j1RMOPJulLRTCOGCsQZlEy/7/myreCPpii4v3VnS34BvAg8D1gAOUrwQ7fajfI3i+MmtQginVBW3WQVSN3l/VHBjNPXZdQLch2yIxA81u8cWkl4bQvh3H8V9
StIfNNhkb938S1kr3ATZW/0lwTMTVx0g6S+SbgF+Bcy6NgG2AH6p2HL8F8XhM09X79mkO12dxThNUusyH5H799GK3aA7PSu7iZTUR/IrSQ8p8ZqRGOckWPsp
16WnwfZRnBWtTf6sOIa0s6v2apK+IOkNtUQ0vC9q9uQ1Fyi28jROCOHcbEKB4zT7ruPuipNjvKipdxiBBylO5pVfGkmSblBMfv853qhsWmRL4P0SOEpxSYb9
lZ68amairJk1U7tNcHWH4oXkV5r6vRuTbaGya/Rtayi/VbIJ2HaXtFaJl6eWrCq6Vjo58VjqfJ2UtTanlowpcpNii9AkzYRc2bjf3Dq3+dbkXp4s6RjNHm50
u6TnZ8NEJkYI4VRgQ8Xj3lVxrO4z1X1m/k4PkfRiSbsCjwshXCs9INl6cJ8hLZD0V90/vvjcKezZlup+/OfOf3TpBn028CvFFuKzZtZ47pH8/k39nX/aB3gz
s7VmZk3gLYn4B5mJd6yA1yTiBkiNL2o04LUFx9L49S2BzYD/FMT/B2DQtYBHBlgZOKkg5n8Tly1oLWD1xHGluhiOO645ibhWrTuuYVDR+R9YE/gqsKDgc9nN
gmzbvpckqyr+ugBvH6C+mi41UUsjAcsDZwxxrGf2KP/ixDY9uxECHx4wntNpQe+lMoCtgPmJYzyDeNNiXHE8nPi7mrcISCXnEwl4EPBc4EvAhX18JvfrKGO/
Prb7Z7av3Yk3/KcacFGufu4jrmqSf91Le9TrlcAXgF2BSwtecyrwxMTjR9Vx7CND+y8g2poALwWcmYh9PvD8uuMrC3g+6Yve00h8OZsIeBxwXcGJ4GTiHeNG
AFbJ6jblKuDRdcc4LJwAjw0Vn/+J43uPKPh8phwBbNSU+McN+HofddUWrVmXGdhjyGPtmuwD/5fYpuuNYWA14N4hYtqj0kqqQVYHVyaO7VZiy+S44liB4t/b
d44rjiYCHgG8DvgZxY0IAMd2bHNsl9fdBPwceD1xUizrwOxr1ORkesQbFXd3qedeTgUeTEyQ874+7uOe0YpkwsrJum+8QVK+q99ykn5FC5LgLMZfaXZ3onsl
vaktXVRCCBcpdk1LnVC2l3QM0G+XncoRk63jNHsdOEm6StKOIYTLxxqUWYcQwqUhhD0Vx3R1myhrZoKrPUMIEzOBjE2Ve9V7Xd/UOOAdemzzckkrDBJQJjVD
e2sQx/1+X+n1fl834Hq/g8bxHaV/b78XQvjqOOJoqhDCNSGE74cQXiHp4YprxH5Ys8egbkfsabG8pO1yz92rOHzmaZIeFkJ4eQjhe2Vnk54y+e918vo6m2H7
/2mwse5/lfScEMJdSo85nqw5ZWj/HfRWtgDPAN5QcBem0S3BxJbfVPckgH3qjm8QxNarawqO6c91JsHEO+KpHgMQ75RvWFdsVcMtwGPDCM//QCB2tcr7AvHi
sop9tP33y12ga8RwXaA/UqL8tRPbXdJjm6G6ZNPyLtDABwqO7fNjjuP/FcTxJ8bYBbttSLfy7pT95R1Td7xtAVyWq7tZayznXv8E4JOkh2GknErHNS5wXuI1
W4z+SNPGOQmWjUkI4bvENV4/nntqpiX4JSGERvW75/6W39SPwAEhhB+MN6JqhBAuBbaRdKKkR+ae3kbSH4DdQgh3jjMuYC3F5aSelHj6UknPmplkwqwpQggA
lyWeumxmEg5Tavbgw5Sb3GQI20p61ZjLr2WpuEGEEOYD26r8JFgzzgshdB3/m5WfWg94IwrWAwYer7gSQafbJH2oREw3K06CNb/EaxuJ4vV+z5P0ReJaqP1Y
GEK4e4A4XiTpE4mn/iVpjwmbaKxqcyQ9J/fYLl1ea+VcK6lzfpeVis4jkpQtHfhRSR8FnqS48sJeeuC5aEZny6+ALSVtlnvN9Yrfw8lB+++gt7oFeAZwYMFd
mfnAC+uObwawG3HwfcpBdcdXBWAD4PKCYzybMS5XBTwU+HtBLBdRYkKVtsEtwGPDiM//bS9/1NpeP8CbEuW/paryJwF9jAMGPpd47f+OO+Y6EJdJS002NYwl
xMksu80+n4/jyaTHUN4GbNK7hOkGbJqou3OAcxOPP6HueNsC+Eai/l48QDlPIrYMX0Scv+dwcr0bgaMT+/pSZQczAI8BnmAhhAM1uxVYiq2sh9OAJBjYTXHd
sVQXq8+FEMrcpW68EMJVimOCU+NpnyLpeLqsq1YV4GGKrdFPTDx9kWLLb/Lun5mZNUKp9YCBpTW7NV1qz5KUw/qQZq/3O6wg6dmKYyJ7AtaW9FtJ+VmHF0l6
WQjh4mrDm0gXKrZWdnqypM1zj10nyUs1lpBdbz4j8dQ2/ZYVQvh7COGjIYTHhRCWCyG8dKblN9vXnpKem9tsiaRv9ruvKjkBnnBNToKnJfmdEUL4t2IS/K/E
00+W9EdGODV/dsf6ZEmpO6TnSdouhHD9qPZvZmaVODnx2A6Jx54tKd+j559lulpPiNRapFXpOdM8sILiNU4qCX9PCOG4yqOaQNnwluPzD2v2JE7HeShMb1ny
e4LSQ+D+U/G+Hinp24mnfpVNFlsbJ8BToIlJ8LQlvzOymQh3kJSatOQpkka5ZvNrJKW6W50jaacQws0j3LeZmVUgu1GZ/w3ZmNnDV16b2HxaWn+l2PI6Kjd1
e5I4Kd93JW2VePqb0z7j8wDKjO31+N8eOpLf/HhcSTpfUmXLEgEPl3SspHzvxnsVZ/eulSfBmhIhhAMBSfpY7qmZJPilIYRR/lj817QmvzNCCNcCOyiehB6f
e3qU3aBTaw+fJWnXEMLtI9yvmZlV62TNnnxme2XLKBEnd3pB7vnFihOWTYUQwvezRPTFSk+wWda6kh6Xe2xuj20+ImnvxOMnSprq9X4H9EfFbrNFDXepVmLr
UCL53SmEcEdF+3qi4g2o/OSvkvT/QghXVLGfYTgBniJNSIKnPfmdEUK4Afi9ZifAqRluq5JaG/VPTn77BzxN0n7ZPw8JIZxdZzxmNnVOkZSfHOy/CbCkV2j2
2r9/nLY5HkII35P0vWHKIC5PlZ9Jem6X1++pdK+7KxXH/S4cJp5pFEK4GThfcbhYynkhhL677wKvV7xB8k9Jn57U66GSye8tFexnOUnvVvz8r5h4yW8lHTrs
fqrgLtBTps7u0E5+Z0mNxR3louAXlozBCgBLAx+UdKriBeYrJJ0GHAQsW290ZjZFTk48tkPH/0979+cqbZB4bG7qhcDmkn6s2dfXd0p6vocaDaXbmOm+x1MD
b1Dspv5cSe+T9PMB42q0YZNfYH16rAUOPAzYV3FoxueVTn7PkPTKpozTdgvwFKqjJdjJb9KmuX8v1GhbgC9THHvReWLKx2AFgA0l/USzZ05cRtIHJT0TeHUI
Ye6YQzOzKVOwHvDMOOBVlV7793djCm/SbJh4bG7+gWzM4+80e8bnxZL2ztZRtcHNUfytLXquX+/O/fvZwOPqnpypSsMkv9m55ChJW0i6Fzhd0j8U1+9F0rKS
1lecv2ZzdW9U/bOkF4QQ7hnsSKrnBHhKjTMJdvI7W7ZG2vq5hy8eZdeoEMLi7IJp846HHwGsOqndfqoC7KU4Zf9qXV62jaTzgf8JIfx4PJG1Rn62ziZrU6w2
3U5Wehzw5onX/iyEcN+oA5pQG+b+vUBxyZ3/6jHj834hhKNHE9pU+YukeZJWyj0+L3uutKylPrUc5KsUx2+3XgXJ78m6fyb1FRVXMdlxgFC+I+mdTTv/uAv0
FBtHd2gnv4WeoNkX2qPs/jzD3aD7ADwEOEzS4eqe/M54iKQfAT8CHjLa6Frli8CB2UViIwHLAe+WdFDdsZiVlFoPeCdN99q/lQKW0uyb1f8OISzpeE1QvMjf
OlHE9zzjczVCCPMl/Snx1J+y5/qR+o5I0iuz97zVKk5+B3WtpBeHEN7UtORXcgI89UaZBDv57SrV9Xgc3aNS+3A36ATgGYrrI7+y4CXXKtcK0OHVkv4GPH0E
oTVd6oduZcXeJhcDe2cXjI0ABGBvxUnivqTYfTSvcT/eZkqPA361pnvt36qto9nXMFfm/v0RpX8n/izpbaMIaoqlxvr2Nf4XWFrpGbqlON57u36DapIGJL83
Ki5ztHEI4TdDlDNSToBtJEmwk9+eUq2ufSXAWYtVv0s7/KNkLFOrY6Krk5Wewl+SjlT8cXmCpF8UvOZRkv40hRNknSDproLnNlAcR30GUPtFRhbDGYoxpSa6
keKxnDC2oMxKKlgPOPWb4NbfwW2YeGzuzP8AL1LxjM8vCiEsGE1YU+sXeuDvy10q/g2eJUt+3yBp7S4ve1e2jFjrjDD5Xdxj19dK+pGkPSStF0I4qEnjfVOc
AJukapNgJ7+lpFpdS3WBBtYBvqE4qcltwDeAdUvu1y3AXQAbSDpJsRtsKmm9V9K+IYQ9Qwi3hBBuDyG8XHHG1dTJfmaCrD8Djx5V3E0SQrhWcZxQt6Whnibp
FOAIYKPxRHY/YCPgCMUupE/r8tKzJe2YHZNZE53c4/mpWvt3BDZMPHaV9N9xpD+SZ3wem2wZrx0Ul/v6maQdyiztBWwGHCzpasX5PLrZU9L1wC+BFwzQ0FCL
ESa/f5W0hqTHSNpF0kuzv70kbSvp4SGER4QQXhtC+O1UL/MFvJnZ3lx3XGUBb0nE/6a64xqHbJxeyvwySTCwG3BfQRkeW5cBrs/VzT30GHcCrE5sTZxX8P58
kzgLZbcyAnBnbtubqj265snqLu+PudfsBdxa8NkF+AdxcfeifWwCnNNl+zuAV+e2mZN43aojqoaxyj5rewFXdKkTgAXEz+7DSpY78O8L93+His5RM67O9tO6
m8TD1E9Dyn9Tovz8ereWAV7R47PsyZeGAPy/RJ2+Eng48O/Ec4uA3euO2yJgH+DvPb4jvdwMHAysUvfxFAFWA84uiP88YM0u2z4c+GfBtqfi+UzKwwlwqzFg
EoyT31KANRL1U9haBqwMfBS4vaBuO90JfIIuJ2rgjMR2Dx3N0TYDXRJg4kRXP+pSp0uAL1PiLjCwLPH7s7hLeYeTda9ighPgGWSTS9H783tXVnep9QM7y+v7
96UjhtuqiKHJBqmfhpXvBLgPwNo9PtMvrTvGNgO+najTnYDTCur7nXXHbBHwuh7fjRk3lHzdsXUfUwqwCjHJTTmP2DJctO06wKUF255KXLHEygLemKjI1vyA
AW9NxP+GuuMaJ/pMgnHyWxqwfaKOfpB43XLEi818a3EZt2Tv4ayTF/DdxOsHmdq+NShIgIGtgMu61OMNxC79/e7vWcA1XcqdC2zLFCTAM4g3fg4inkO66dr6
Sh8JGPe3Ql/eY58L6aMVusn6qZ+Glu8EuE/AxQWf61tp8MzrbQAcl6jXkwvq+//qjtfuBxxZ8D51uo6YBP68xGuXNPH7RPomDTj5HT/g+YnK/H7dcZUFHJKI
/wV1xzVulEyCcfLbF+DtiXp6f8fzywBvAK4qqNN+XA+8k47WS2C/xOsm+q416QT4VmLiU+Q3dPnxKLHPNen+A7yQdJfrVSs89MYhjr89vEu9zDgL2D6xfakE
DNga+EuJ/cwBJmYcfNn6aXD5ToD7BPxfwWf7f+uOre3ofoO0059oyVjRaQF8oeR79wt6D4sBuKruY8oD1id9HePktw7AI4h3SjotZICWlHEDNibdVe8xdcdW
B3okwTj57Rvw9URd7UZsrXopxXfzO/2dODnD8yju+tJpLvB6YnK9a+L5XpNCtBrpBLjIPOJ6sFXt+zXA3X3sf9Wq9t1kxAT11BL18YAElR4JGPcn2PnfoLyz
gR1qOfgR6lU/LSjfCXCfgJcXfMa3rDu2NgOWolxidAVdxlhaPYhdg48p8f6VcSXwzLqPKQ94VyLWv+Pkt6dlRlFoCOEa4CRJz8rt63fErp7nSFqS2rZGQdIm
kl4nKT9+8h8hhH+NP6T6hRAOBKS4hmen5SQd3vH/eR/PZpa22VLLDq2n+L14co9tL1d8L34WQlgiScAxirPxfVzSxgXbbSDpu5I+oPQMiBPTAjakCyS9IoRQ
akbuMkIIPwLOVFxqZ4uqym27EMLpwDaSXiLpcypecmpnSecSexEdUFQesLri53tfpWegn3GNpE9K+s7Md2jCpJagenZ2Hq/CtqnHKiw/NRzj7qoKn1CnJB7z
2r/DS60BnOcZnxsqhHCHpOcCj5P0quxv/T6KmKe4oslhkuaEEHotBVSHzROPfWCI2Z6fE0IoWsbQyiCOrVtU0Z2Xuu1Vd33WjeKW4JQD6463yYgzCvbrP8AH
gcIfY+Ld6r2Afw1Q/u1AGGc9jBO9W4AXA59nhF3YiGO6v0DvlslVRxVDUwErZJ/vXhNl3Q6cmHj8xJLbfpAGjuGqEvDYHvXQRo+ru16bDjg2V2dTNW/JKADb
9PhcesbnFiFeI21PXH6vm0uB19KCllDiUk15yR6ruOV3fID9e3zI2sDr52UolwS723MXxBNQP24hXrSv1Mc+liV2U7y2z309YpTHXie6J8ADTXQ1RCy9Jsha
dVyxNA2wFvA14tJIVVmQlblW3cc3DsShFKmZ3tvqAmDpuuu16YBViTfYjsbJbyWAV/X4bE703BmTirhkULeu7a+tO8aygG8k4n9l4nVOfseNuHxLrxaPpvoJ
E95a0C+6J8EH1h1f0wG7lPzs3UWP5YxK7GslYvJ8S8l9PqfKY20S4k2B1PrJQ010NUQ8a5K+C30PMJKhKW1CnIuhzAyevRwJFA0LmFjAE4jnkLZbADy17vq0
6UR6DeAZ3607Phsc8KuC9/UeWpQMkl7q6Vrg8R2vWR8nv/UAnkGcNr4tifA/cLfnQqSTYLf8lgDs2+Ozdx9wKBWuy0ucCOITxDWCu3lfVftsIh54MXM3DVib
nLjm+D0dce1fd0xNQvmJsvImcoKrfhBvIpwzQN01xYXA0+quR5teFC8vcwKwbN3x2eCIk7imtKrXJ7HnR+pm5wLi0KBjSd/8hylPfsc65g9YT9ITFScWSK7x
WCMk3SjpohDCZXUH03TAeyV9NPvnJ0MIB9cZT1sAn5T0/xJPLZL0Q0mfCCH8e0T7XkvShyS9TdKKiZd8IoSQn+xsohBnRX28pONCCNfVHY8kAetK2kWetCaJ
ODZ9b0mfUe8JTP4taX9JPw0hVDYrU5sBG0h6hqQqL3SWUfwtl6R/KJ6/qnK3pHMlXTqhk5RZSwC/l5Qf43uZpK1DCLfWEJJVhDjfx7WS8rN37xZC+EMNIQ0M
+IikT/W5mSe8MrPxIbZodU4Ot4S4Bt3YumkC6xLHjXSOs7wP2GxcMZj1i+4TZU3FBFdmNj7MXkf2NmCTuuOyagBfyr2//6aF8w0Ql7fMT4LXzVS3/JpZTYhr
/h4JfBeobVkc4FHEmY+/C2xdVxxm/eD+ibLuyf6mZoIrMxsf4vChY4k3qq+kgevA2uBy7+/cNr+/2Q3iH5RIfo9x8mtmZtZSxGWlRrZslZmZJAEr1x2DjQ6w
MhOyDCSwA3Fyz845X+YBfwBeWHd8TTIRb7iZmZmZmdm0A5aS9HDF+ZZuCCFUOU+DmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZ
mZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZmZ
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
C/G46n9Eph4/HNf+hzXI+S+9/mmZ1/+8j9f/IvP6XFDc7vUTff5bSTo+cyxrt9n2SZL+mdm+KpcrjTXL7XvtzPbHj/bsjIek+0taWjq2G5Xm3K27bhtK+lfm
3J+jiseujYuk12SO5zXjev2wJL02s/9Xj2v/TdPt/aj7/WoySWtJOiZz/enkq2pp3ZUUkr7Rx+uHtVSpzmvVee4GpSHvf3rcx36Sbpe0SNIBFZc90fc/mqDr
gfq4P5s4klaQdGKbL/lIgt+W136g+ILcLmm/yg+uwSRtkzlfS9Xm5rt4zSOLczVn7IFvUY/tlP+x2nqc9RjGIOe/9PpVJS0svf529fCDqBRI3VF67c0qnpb2
8PqJP/+t1OMFVukm5/LMtlW7XJmuc5ruAPg9mWP7SgPqtZakMzN1WyKp3OIzMeQAeKp0ez/qfr+aTNLHMuemm3mzXUjaYoByhvWxOs7ZsDTk/U8P5T8uU37P
D/i7lD3x9z+aoOuBag6ARz0G+HXku5dU2e05KyLeD6wFrBUR+/VT6UkXEacCJ5QXA4eqTSAUEX8CHksaR/1u4L8i4t2j7u7cSqlF6PNFXVsdGxGnjasewxrk
/Jdefxsp03mrlYHn9LD7XZjf1eu4XroJTcv5H9DqwH3HsJ/7kvISzJLdM8tqHVurlPH+F8AjM6sPioiehwyYWWMNkmfgpsyyOpIfNSlHQs+Gvf/pwSY9LuvL
jN//zKSRBcBKrRx7ZlaNPPidExGLZngM156kcQuttiAlsMqKiD9FxJ4R8dFxBr4tPgmUsysuBt5TQ12G1ff5L8klDXppD6/Lza/6ox73OU3nvy/FmKtfjmFX
J0TErWPYTyNI2pz503j9m5TNvxZKWV9PJo3/K/slKSGWmU2+8jymvdg0s6yfJJRVGaTuTTHs/U8nvyTNQjIn12AwiJm9/5lVoxzjtAXwwNKyK4GnjSP4nXUR
cY6kzzI/uctbJJ0cEUfUUa92JL2E/BzEh0TE2eOuz7AqOP8/BhaybGvhUyRtHBEX516glLyhPEfhLcyfOD732qk6/wPaFdgXmNcFriLnAh8cUdlN9aLMsu9E
xJJxV0RperA3AQeSn+vzXGDXiCjfuJnZBIqIrxaNMc8DVspsshHzA95DJD0rIv4OIOm/SMFR2QXAP6usb+EO4IfFHKwTaZT3nxFxudLUpu8gNeJ9cti52n3/
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
uIi4uc76GChNnbY5sCH5xEmtVii2BTiHdP0YJQFXAedHxMUj3tdEkfQq0nzWZW71tanh+5/RkvQw0jV9zbrrQmrFPy0i/lN3RcyWIenekt4u6WQNl0hlsaST
lMbsTd/g9hHx+a+eUqvkF9XsVrClkr6gDuOczGy2SNomc624QNLj6q6bWdXk+x8bE7cAW0dKk74/CXgMsAlpqooNgAXc/fkRcAPwb+AC4CLgJOC3EVH3GMuJ
5vNfLaVcBG8EdgCa8qN4JXAC8NmIOLnuyphZs0jaC3hv8c/PAu93q69NO9//2Cg5ALaBSVodICJurbsus0hFxvSIuK7uukyi4vNb95jUO/z9MbNu5Hlpze7i
+08zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMz
MzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMz
MzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMz
MzMzMzOzEZK0sqSV666HWR0krSFp9brrMYyouwJmZmZmZpNA0n7Ae4p/HhQR+9VXG7PRkLQO8CTgMcAmwGbAvYEFpU1vAK4EzgcuAk4GfhsR14+rrmZmZmZm
NgKSHqf5Hld3vcyqIGkDSe+UdLqkJZnPeq+WSDpN0p6SNqj7uHJWqLsCg5K0EvDM4p8/i4g76qyPWSeSAti8+BtHt5ErgVMi4qox7Ms6kLQR8DTgwoj4Q931
MTOzgT2szbI/jrsiVi1JKwL3ATYC7g/cyozEF5IeQ+rV8Cxg+QqKXA54dPH3UUlHk3pLnFJB2bOrGHtxSsuThlM8FsOaSFJIepWkS4Z4kjaoJZJ+LumRdZ+H
WSVpG0m3tLwnn6i7TmZmNhhJr8n81r6m7npZ7yTdW9IOkt4m6YuS/iDpn8q3eE51fCFpS0knVHXT2YNfSHpE3cc9sSTtkjmpu9RdL7NWklaVdPQYLyzt3CHp
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
0ysu28zMzMzMzKx/ku4t6e1KU+D106051136JKV5mRuZ3HNs84uamZmZmZlZs0laQJqy8TGkIWSbARsAC7g7fhQpieS/gQtIia1OAn4bETeOtcJmZmZmZmZm
VZO0ejFEz8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM
zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM
zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMpkfU
XQEzMzMzM7MqSArg4cCjgQcC6wIrANcA/wL+DJwWEYtqq6TVaqIDYElrAIqIW+uuyyyStBJARNxRd13Mxs2ffzOrgqTVgZXGtLtFEbFwTPsyGytJmwCvB14A
bNBl81uBo4AvRMRvRlw1s/5IWkfScyV9RNKRks6XdL3mu75Y9yNJB0naRdLaddd/WknaS9Ktxd9eddfHbJwkvbfl8//euutjZpND0vKSXirpeEk3Z+5nRu0a
ST+U9PS6z4VZFSRtIOkbkpYM+J34vaRH130cNuOKD/I7JZ0+xIdZxWtPk7SnpG5PgqxHknbMnOsd666X2ThIOjDz+T+47nqZWfNJ+i9JZw1xX1O1H0las+7z
YjYoSf9P0nUVfBcWS/qApOXrPiYbvUZ1gZb0GOA9wLOAqj+AS4CjgYMi4pSKy54ZxYXhLNLYilbnAltGxJKxV8psTCR9Enh7m9UHR8Se46zPLJC0EfA00vit
XiwGfhERl4+uVpNB0rrANsD6jK+L7bAWAf8ATo+Im+uuTJUkPQg4CbhX3XUpORPYftrOt00/Se8BDqDaeOYo4AURcXuFZZrNJ2lLSSdU8PSmV7+Q9Ii6j3sS
SXpVh/P6qrrrZzYqyrf8lrkluEKStpV0ywDX+FskbVt3/esiaQtJRyu1aEyqWyV9UdL6dZ/PKih1e25Sy2/Zd+o+R2b9kPS+Lp/psyXtL+l5kh4raWtJz5T0
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
FVvNfLfnOiglIbuk5X2Yy3EzcRrVTU3SNqQkKs+i+gRdi0lJiA70EwozG4Tad4eGGe323Imk9YCtgQ1p2O9NF/8izUP7n7orMg5KSRQXMvr3SMCqszpPp6Q1
gN8Aj6q5KmX/AbYdd1dsm27FdeU7QJUB0lLgf2c44VXtJK1Emocc0jzkTpxXFUn3lvR2SSdLWtzz88v5Fks6SdJb5eQlZlYB5VuC3fJrE03z5zkdhUvrPs66
SbqHpB+M4Vz36jSl7MZmlZO0vKT9NNy9/Jz/SPIYdZsNSlnCnqN00/lDSedJuk5pLrY5S4tl5xXbHKjUpaLpU86Y2QSS9F5JtxZ/7627PmbDkvR4pXlOR+Xv
kh5f93E2hVIW+e9JumqE57ydG5W6vO8ud3u2MVDKAjzoLBh3SDpMUrektmY9m6QuafNIWh0gIm6tuy5mNluUugHh7j82LZQyri4YUfE3RIRGVPZEk7Qa+Tl5
R2FRRCzsvplZ9ZSSwb2GlIF8zS6bX0bqQv15d8+3qk10AGxmZmZmZpND0orAo4HNgfsB65Iy7l8HXAycEREX1ldDMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMz
MzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMz
MzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMz
MzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM+uVpLUlrV13PczMzMzMzHoRdVfAmkXS+sAWwEOA+wIb
ABsB9wbWI31mFrR5+Q2AgKuAK4F/Av8u/ns+cHZE/Gd0tTczMzMzM2vPAfAMk7Q8sA3wdGA7UuC73oh3exXwZ+D3wPHAaRGxZMT7NDMzMzMzcwA8a4qg9xnA
S4EdgLq7MF8HnAB8HTg2IpbWXB+ztiTdB3ggcC9gpeJvIanHw6UR8a8aq9c4xfVmM2BLYPUBivgH8MeIuKnP/W4IbAVsOMA+by72edkArzUzMzOzJpC0QNL7
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
z5y1KXgi4ruSLgC+Q747OKTW272LvyWSLiMlhZvLrL0qaZ7YjejtoeL5wO4RcdYQVTczMzOzAbgF2KyBuowLHtbcPMFzzgK2j4irRrCvxouIs0lzJn8U6DZt
1/LAfwHbATsUf48H7k/36+kdwEHAoxz8mpmZmdVjnC3AqxWJdyZB226OEyLXfXaSHnbk6jrKLsGNFBGXSHosaW7Y51VYbr/zBE+9iLgNeLekLwH7AS8gBbtV
WAIcAewXEX+tqEwzMzMzG8A4A+CDiz8bvcszy14o6SsRccfYa9MHSSsB/5NZNZNTxETELZJ2JU1L9CGWfTgw8Dy9vc4TPGsi4mLgRZL2JmVtfhGpdXcQfyd1
Y/9SRFxWURXNzMzMbAiT1CpovfsTqbtlqyeREvpsWkN9elLU7VfAE0ur7iB1051JxXzBB5BabOemJ/ol8MH6ajXdIuKyiNgnIh5AShj2TuD7wF/IJ826ldRd
/bvA24FHRMR/RcT7HPyamZmZNceoWoCnsTvlxBxTRPxH0hHAy0qrHg+cK+k7wFeB30RErV2LJS0HbA/sAbyQ/GfyiIj4zzjr1UQRcYykjYA1IuLmuuszK4rx
ume1LpO0BrBi8c87Zi15WBe5z+aOUm7a5a4eUPr3EvIPIG4DFrPs9WMTSbm5l7vJzQF9ywDlmJmZWQPFKAqVtCEpq+w9RlF+DW4GNouIK+quSK8k3ZM0rc39
Omz2D+BI4ETg9+MKMiWtR0oi9CTguaTsue38A9gqIq4dR93MbDiSNiZNAzUK50bE5m32exbwiBHt9yERccGIyjYzM7MxGkkADCBpK1K3wXuNah9jcjXw8Yg4
s+uWDVN0KT6W+a0o7VxIGld6YfF3MXAlcFW/LVySVgfWB+5NmkZm0+LvYcV/e/F34BkRcWE/+zaz+kgK4GRSFvOqfTAi3t9mv+8iZfKu2nnAFnX3ljEzM7Nq
jCwAtmaQdC/g06SstsNYSHoYsLD4WwrcWKxbizSefLXi714Mn0n7O8CbI+KaIcsxszGT9DBSELxGhcWeA2wdEYva7HMF4LfA4yrc553A4yLi9ArLNDMzM7NR
k7SdpOMkLVFzLZF0vKTt6j5fZjYcSZtKOqOia8Ph6mEaPUmrSjpM0uIK9nmepEeP41yZmZnZ+LgFeMYoJVF6MfBSYLOaqzPnAuBw4JsRMZPTHZlNK0n3J7XK
DpIT4l/A6RFxVZ/7XLPYZ6ccCO3cApwJXORuz2ZmZtPHAfAMk/QA4AmkaYe2I43VXX7Eu11CGlv8e+B3wIkRcemI92lmZmZmZuYA2O4maWWWTVi1ESmJ1b2A
exb/XRlYvU0RtwKLSGOFryn+eyVwOS2JtdqN4TMzMzMzMzNrJElr9zIuz8zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM
zMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzM
zMysXv8fpydqNZUM+LwAAAAASUVORK5CYII=
]=]
local DEFAULT_LUCIDE_PATH = "Havoc_Lucide_Starter_Atlas.png"
local cachedLucideAsset = nil

local function decodeEmbeddedPNG()
    -- Decode base64 in standard Luau; do not depend on executor-specific crypt APIs.
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local decoded = table.create(math.floor(#EMBEDDED_LUCIDE_PNG_BASE64 * 3 / 4))
    local buffer, bits = 0, 0
    for index = 1, #EMBEDDED_LUCIDE_PNG_BASE64 do
        local character = EMBEDDED_LUCIDE_PNG_BASE64:sub(index, index)
        if character == "=" then break end
        local value = alphabet:find(character, 1, true)
        if value then
            buffer = buffer * 64 + (value - 1)
            bits = bits + 6
            if bits >= 8 then
                bits = bits - 8
                local divisor = 2 ^ bits
                local byte = math.floor(buffer / divisor)
                decoded[#decoded + 1] = string.char(byte % 256)
                buffer = buffer % divisor
            end
        end
    end
    return table.concat(decoded)
end

local function getCustomAssetLoader()
    if type(getcustomasset) == "function" then return getcustomasset end
    if type(getsynasset) == "function" then return getsynasset end
    if type(syn) == "table" and type(syn.get_custom_asset) == "function" then
        return syn.get_custom_asset
    end
    return nil
end

local function loadLocalLucideAtlas(path, allowExtract)
    local assetLoader = getCustomAssetLoader()
    if not assetLoader then return nil, "no custom asset API" end
    if type(path) ~= "string" or path == "" then return nil, "invalid atlas path" end

    local exists = false
    if type(isfile) == "function" then
        local ok, result = pcall(isfile, path)
        exists = ok and result == true
    elseif type(readfile) == "function" then
        local ok = pcall(readfile, path)
        exists = ok
    end

    if not exists and allowExtract then
        if type(writefile) ~= "function" then return nil, "no filesystem write API" end
        local ok, err = pcall(writefile, path, decodeEmbeddedPNG())
        if not ok then return nil, tostring(err) end
    elseif not exists and not allowExtract then
        return nil, "file missing"
    end

    local ok, uri = pcall(assetLoader, path)
    if ok and type(uri) == "string" and uri ~= "" then return uri end
    return nil, ok and "custom asset API returned no URI" or tostring(uri)
end

local function resolveStarterLucideAtlas(config)
    if config.LucideAtlasId ~= nil then return normalizeRobloxAssetId(config.LucideAtlasId) end
    if config.LucideAtlasImage ~= nil then return config.LucideAtlasImage end
    if config.LucideAssetResolver ~= nil then
        assert(type(config.LucideAssetResolver) == "function", "LucideAssetResolver must be a function")
        local ok, uri = pcall(config.LucideAssetResolver, config)
        if ok and type(uri) == "string" and uri ~= "" then return uri end
    end
    if cachedLucideAsset then return cachedLucideAsset end
    if config.AutoLucide == false then return nil end
    local path = config.LucideAtlasPath or DEFAULT_LUCIDE_PATH
    local uri = loadLocalLucideAtlas(path, config.LucideAtlasPath == nil)
    if uri then cachedLucideAsset = uri end
    return uri
end

local Elements = (function()
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local COLORS = Theme.Colors
	local componentElements = {}

	function componentElements.Make(className, properties, parent)
		local object = Instance.new(className)
		if object:IsA("GuiObject") then
			object.BorderSizePixel = 0
		end
		for key, value in pairs(properties) do
			object[key] = value
		end
		object.Parent = parent
		return object
	end

	function componentElements.GradientTint(baseColor, targetColor)
		local function channel(target, base)
			if base == 0 then
				return 1
			end
			return math.clamp(target / base, 0, 1)
		end
		return Color3.new(
			channel(targetColor.R, baseColor.R),
			channel(targetColor.G, baseColor.G),
			channel(targetColor.B, baseColor.B)
		)
	end

	function componentElements.Gradient(parent, baseColor, targetColor, rotation)
		return componentElements.Make("UIGradient", {
			Color = ColorSequence.new(
				Color3.new(1, 1, 1),
				componentElements.GradientTint(baseColor, targetColor)
			),
			Rotation = rotation or 90,
		}, parent)
	end

	function componentElements.Corner(parent, radius)
		return componentElements.Make("UICorner", {
			CornerRadius = UDim.new(0, radius or Theme.CornerRadius.Offset),
		}, parent)
	end

	function componentElements.Stroke(parent, transparency)
		local properties = table.clone(Theme.Stroke)
		if transparency ~= nil then
			properties.Transparency = transparency
		end
		return componentElements.Make("UIStroke", properties, parent)
	end

	function componentElements.Padding(parent, amount, verticalAmount)
		local inset = amount or Theme.Padding
		local verticalInset
		if verticalAmount == nil then
			verticalInset = inset
		else
			verticalInset = verticalAmount
		end
		return componentElements.Make("UIPadding", {
			PaddingLeft = UDim.new(0, inset),
			PaddingRight = UDim.new(0, inset),
			PaddingTop = UDim.new(0, verticalInset),
			PaddingBottom = UDim.new(0, verticalInset),
		}, parent)
	end

	function componentElements.Tween(object, duration, properties, style)
		local animation = TweenService:Create(
			object,
			TweenInfo.new(duration, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			properties
		)
		animation:Play()
		return animation
	end

	function componentElements.AddPressFeedback(button, scaleTarget)
		local scale = componentElements.Make("UIScale", { Scale = 1 }, scaleTarget or button)
		local baseColor = button.BackgroundColor3
		local buttonStroke = button:FindFirstChildOfClass("UIStroke")
		local baseStrokeColor
		if buttonStroke then
			baseStrokeColor = buttonStroke.Color
		else
			baseStrokeColor = COLORS.Border
		end
		button.MouseEnter:Connect(function()
			componentElements.Tween(button, Theme.HoverDuration, {
				BackgroundColor3 = baseColor:Lerp(Color3.new(1, 1, 1), 0.08),
			})
			if buttonStroke then
				componentElements.Tween(buttonStroke, Theme.HoverDuration, {
					Color = baseStrokeColor:Lerp(Color3.new(1, 1, 1), 0.18),
					Transparency = 0.84,
				})
			end
		end)
		button.MouseLeave:Connect(function()
			componentElements.Tween(button, Theme.HoverDuration, { BackgroundColor3 = baseColor })
			if buttonStroke then
				componentElements.Tween(buttonStroke, Theme.HoverDuration, {
					Color = baseStrokeColor,
					Transparency = Theme.Stroke.Transparency,
				})
			end
		end)
		button.MouseButton1Down:Connect(function()
			componentElements.Tween(scale, Theme.Animation.Press.Time, { Scale = Theme.PressScale }, Enum.EasingStyle.Quint)
		end)
		local function release()
			componentElements.Tween(scale, Theme.Animation.Release.Time, { Scale = 1 }, Enum.EasingStyle.Quint)
		end
		button.MouseButton1Up:Connect(release)
		button.MouseButton1Click:Connect(release)
	end

	function componentElements.TextLabel(parent, text, size, color, font)
		return componentElements.Make("TextLabel", {
			BackgroundTransparency = 1,
			Font = font or Enum.Font.Gotham,
			Text = text,
			TextColor3 = color or COLORS.Text,
			TextSize = size,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
		}, parent)
	end

	function componentElements.Button(parent, text, size, color, manualFeedback)
		local element = componentElements.Make("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = color or COLORS.Interactive,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamMedium,
			Selectable = true,
			Size = size,
			Text = text,
			TextColor3 = COLORS.Text,
			TextSize = Theme.Font.Body,
		}, parent)
		componentElements.Corner(element, 11)
		local outline = componentElements.Stroke(element)
		if not manualFeedback then
			element.SelectionGained:Connect(function()
				componentElements.Tween(outline, Theme.HoverDuration, {
					Color = COLORS.Primary,
					Transparency = 0.15,
				})
			end)
			element.SelectionLost:Connect(function()
				componentElements.Tween(outline, Theme.HoverDuration, {
					Color = Theme.Stroke.Color,
					Transparency = Theme.Stroke.Transparency,
				})
			end)
			componentElements.AddPressFeedback(element)
		end
		return element
	end

	function componentElements.SetCanvasHeight(scroller, layout, bottomPadding)
		local extra = bottomPadding or 12
		local function update()
			local inset = scroller:FindFirstChildOfClass("UIPadding")
			local paddingY = 0
			if inset then
				paddingY = inset.PaddingTop.Offset + inset.PaddingBottom.Offset
			end
			scroller.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + paddingY + extra)
		end
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
		update()
	end

	function componentElements.SafeCallback(owner, callback, ...)
		if type(callback) ~= "function" then
			return
		end
		local ok, err = xpcall(callback, debug.traceback, ...)
		if not ok then
			warn("[Havoc Lib] Callback failed:\n" .. tostring(err))
			if owner and owner.Notify then
				owner:Notify({
					Title = "callback error",
					Content = "a component callback failed. see the developer console.",
					Duration = 5,
				})
			end
		end
	end

	function componentElements.ActionButton(parent, options, owner)
		local backgroundColor = options.Color or COLORS.Accent
		local luminance = backgroundColor.R * 0.2126 + backgroundColor.G * 0.7152 + backgroundColor.B * 0.0722
		local textColor = options.TextColor or COLORS.Text
		if not options.TextColor and luminance > 0.55 then
			textColor = Color3.fromRGB(27, 27, 29)
		end
		local size = options.Size or UDim2.new(1, 0, 0, options.Height or 44)
		local element = componentElements.Button(parent, options.Name, size, backgroundColor)
		element.BackgroundColor3 = backgroundColor
		element.TextColor3 = textColor
		element.Font = Enum.Font.GothamBold
		element.TextSize = Theme.Font.Body
		local gradientShade
		if luminance > 0.55 then
			gradientShade = 0.08
		else
			gradientShade = 0.23
		end
		componentElements.Gradient(element, backgroundColor, backgroundColor:Lerp(Color3.new(0, 0, 0), gradientShade * 0.22))
		element.TextXAlignment = Enum.TextXAlignment.Center
		element.MouseButton1Click:Connect(function()
			componentElements.SafeCallback(owner, options.Callback)
		end)
		return element
	end

	function componentElements.Paragraph(parent, options)
		local content = componentElements.Make("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			LayoutOrder = options.LayoutOrder or 0,
			Size = UDim2.new(1, 0, 0, 0),
			Text = options.Content or "",
			TextColor3 = options.Color or Color3.fromRGB(201, 202, 210),
			TextSize = math.max(13, options.TextSize or Theme.Font.Body),
			TextWrapped = true,
			LineHeight = options.LineHeight or 1.17,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			RichText = options.RichText == true,
		}, parent)
		return content
	end

	function componentElements.Toggle(parent, options, owner)
		local value = options.Default == true
		local row = componentElements.Make("Frame", {
			BackgroundColor3 = COLORS.Container,
			BorderSizePixel = 0,
			Size = options.Size or UDim2.new(1, 0, 0, 48),
		}, parent)
		componentElements.Corner(row, 13)
		componentElements.Gradient(row, COLORS.Container, Color3.fromRGB(36, 36, 39), 90)
		local rowStroke = componentElements.Stroke(row, 0.98)
		local label = componentElements.TextLabel(row, options.Name, 14, COLORS.Text, Enum.Font.GothamMedium)
		label.Position = UDim2.fromOffset(15, 0)
		label.Size = UDim2.new(1, -CONTROL_RIGHT_INSET - 46 - 26, 1, 0)
		local track = componentElements.Make("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = value and COLORS.ToggleOn or Color3.fromRGB(75, 75, 82),
			BorderSizePixel = 0,
			Position = UDim2.new(1, -CONTROL_RIGHT_INSET, 0.5, 0),
			Size = UDim2.fromOffset(46, 25),
		}, row)
		componentElements.Corner(track, 26)
		local trackStroke = componentElements.Stroke(track, 0)
		trackStroke.Color = value and COLORS.PrimaryStrong or Color3.fromRGB(93, 93, 100)
		local onTrack = componentElements.Make("Frame", {
			BackgroundColor3 = COLORS.ToggleOn,
			BackgroundTransparency = value and 0 or 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
		}, track)
		componentElements.Corner(onTrack, 26)
		componentElements.Gradient(onTrack, COLORS.ToggleOn, COLORS.PrimaryStrong)
		local knob = componentElements.Make("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = Color3.fromRGB(250, 250, 252),
			BorderSizePixel = 0,
			Position = value and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
			Size = UDim2.fromOffset(19, 19),
		}, track)
		componentElements.Corner(knob, 10)
		componentElements.Stroke(knob, 0.97)
		local hitbox = componentElements.Make("TextButton", {
			BackgroundTransparency = 1,
			Name = tostring(options.Name) .. " toggle",
			Size = UDim2.fromScale(1, 1),
			Text = "",
			Selectable = true,
		}, row)
		componentElements.Corner(hitbox)
		componentElements.AddPressFeedback(hitbox, row)
		local toggle = { Value = value, Frame = row }
		local function setValue(nextValue, fireCallback)
			value = nextValue == true
			toggle.Value = value
			componentElements.Tween(onTrack, Theme.HoverDuration, {
				BackgroundTransparency = value and 0 or 1,
			})
			componentElements.Tween(track, Theme.HoverDuration, {
				BackgroundColor3 = value and COLORS.ToggleOn or Color3.fromRGB(75, 75, 82),
			})
			componentElements.Tween(trackStroke, Theme.HoverDuration, {
				Color = value and COLORS.PrimaryStrong or Color3.fromRGB(93, 93, 100),
			})
			componentElements.Tween(knob, Theme.HoverDuration, {
				Position = value and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
			})
			if fireCallback ~= false then
				componentElements.SafeCallback(owner, options.Callback, value)
			end
		end
		toggle.Set = function(_, nextValue, fireCallback)
			setValue(nextValue, fireCallback)
		end
		hitbox.MouseEnter:Connect(function()
			componentElements.Tween(row, Theme.HoverDuration, { BackgroundColor3 = Color3.fromRGB(48, 48, 52) })
			componentElements.Tween(rowStroke, Theme.HoverDuration, { Transparency = 1 })
		end)
		hitbox.MouseLeave:Connect(function()
			componentElements.Tween(row, Theme.HoverDuration, { BackgroundColor3 = COLORS.Container })
			componentElements.Tween(rowStroke, Theme.HoverDuration, { Transparency = 1 })
		end)
		hitbox.SelectionGained:Connect(function()
			componentElements.Tween(rowStroke, Theme.HoverDuration, {
				Color = COLORS.Primary,
				Transparency = 0.15,
			})
		end)
		hitbox.SelectionLost:Connect(function()
			componentElements.Tween(rowStroke, Theme.HoverDuration, {
				Color = Theme.Stroke.Color,
				Transparency = 1,
			})
		end)
		hitbox.MouseButton1Click:Connect(function()
			setValue(not value)
		end)
		return toggle
	end

	function componentElements.Slider(parent, options, owner, connections)
		local minimum = options.Min or 0
		local maximum = options.Max or 100
		local step = options.Step or 1
		assert(
			isFiniteNumber(minimum)
				and isFiniteNumber(maximum)
				and isFiniteNumber(step)
				and maximum > minimum
				and step > 0,
			"Slider requires finite Min and Max values with Max > Min, and a finite Step > 0"
		)
		local default = options.Default
		if default == nil then
			default = minimum
		end
		assert(isFiniteNumber(default), "Slider Default must be a finite number")
		local value = math.clamp(default, minimum, maximum)
		local row = componentElements.Make("Frame", {
			BackgroundColor3 = COLORS.Container,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 102),
		}, parent)
		componentElements.Corner(row, 13)
		componentElements.Gradient(row, COLORS.Container, Color3.fromRGB(36, 36, 39), 90)
		local name = componentElements.TextLabel(row, options.Name, 14, COLORS.Text, Enum.Font.GothamMedium)
		name.Position = UDim2.fromOffset(20, 7)
		name.Size = UDim2.new(1, -40, 0, 24)
		local valueBox = componentElements.Make("TextBox", {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = COLORS.SurfaceAlt,
			ClearTextOnFocus = false,
			Font = Enum.Font.Gotham,
			Position = UDim2.new(1, -CONTROL_RIGHT_INSET, 0, 19),
			Size = UDim2.fromOffset(68, 24),
			Text = tostring(value),
			TextColor3 = COLORS.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Center,
		}, row)
		componentElements.Corner(valueBox, 12)
		local valueStroke = componentElements.Stroke(valueBox, 1)
		local bar = componentElements.Make("Frame", {
			BackgroundColor3 = Color3.fromRGB(24, 24, 27),
			BorderSizePixel = 0,
			Position = UDim2.new(0, 20, 0, 51),
			Size = UDim2.new(1, -20 - CONTROL_RIGHT_INSET, 0, 7),
		}, row)
		componentElements.Corner(bar, 20)
		local minimumLabel = componentElements.TextLabel(row, tostring(minimum), 10, Color3.fromRGB(176, 176, 183))
		minimumLabel.TextSize = 11
		minimumLabel.Position = UDim2.new(0, 20, 0, 76)
		minimumLabel.Size = UDim2.new(0, 70, 0, 16)
		local maximumLabel = componentElements.TextLabel(row, tostring(maximum), 10, Color3.fromRGB(176, 176, 183))
		maximumLabel.TextSize = 11
		maximumLabel.AnchorPoint = Vector2.new(1, 0)
		maximumLabel.Position = UDim2.new(1, -CONTROL_RIGHT_INSET, 0, 76)
		maximumLabel.Size = UDim2.new(0, 70, 0, 16)
		local fill = componentElements.Make("Frame", {
			BackgroundColor3 = COLORS.Primary,
			BorderSizePixel = 0,
			Size = UDim2.new((value - minimum) / (maximum - minimum), 0, 1, 0),
		}, bar)
		componentElements.Corner(fill, 20)
		local thumb = componentElements.Make("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(248, 248, 249),
			BorderSizePixel = 0,
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(18, 18),
			ZIndex = bar.ZIndex + 2,
		}, fill)
		componentElements.Corner(thumb, 9)
		componentElements.Stroke(thumb, 0.82)
		local sliderButton = componentElements.Make("TextButton", {
			Active = true,
			BackgroundTransparency = 1,
			Name = tostring(options.Name) .. " slider",
			Selectable = true,
			Size = UDim2.new(1, -12 - CONTROL_RIGHT_INSET, 0, 28),
			Position = UDim2.new(0, 12, 0, 43),
			Text = "",
		}, row)
		local sliderFocusStroke = componentElements.Stroke(row, 1)
		sliderButton.SelectionGained:Connect(function()
			componentElements.Tween(sliderFocusStroke, Theme.HoverDuration, {
				Color = COLORS.Primary,
				Transparency = 0.15,
			})
		end)
		sliderButton.SelectionLost:Connect(function()
			componentElements.Tween(sliderFocusStroke, Theme.HoverDuration, {
				Transparency = 1,
			})
		end)
		local slider = { Value = value, Frame = row }
		local function formatValue(number)
			local decimals = options.Decimals
			if decimals == nil then
				decimals = #((tostring(step):split(".")[2]) or "")
			end
			return string.format("%." .. tostring(math.clamp(decimals, 0, 6)) .. "f", number)
		end
		local function setValue(nextValue, fireCallback)
			assert(isFiniteNumber(nextValue), "Slider value must be a finite number")
			local snapped = minimum + math.floor((math.clamp(nextValue, minimum, maximum) - minimum) / step + 0.5) * step
			value = math.clamp(snapped, minimum, maximum)
			slider.Value = value
			local alpha = (value - minimum) / (maximum - minimum)
			componentElements.Tween(fill, 0.18, { Size = UDim2.new(alpha, 0, 1, 0) }, Enum.EasingStyle.Quint)
			thumb.Position = UDim2.new(1, 0, 0.5, 0)
			valueBox.Text = formatValue(value)
			if fireCallback ~= false then
				componentElements.SafeCallback(owner, options.Callback, value)
			end
		end
		slider.Set = function(_, nextValue, fireCallback)
			setValue(nextValue, fireCallback)
		end
		local dragging = false
		local function update(input)
			local width = math.max(bar.AbsoluteSize.X, 1)
			setValue(minimum + math.clamp((input.Position.X - bar.AbsolutePosition.X) / width, 0, 1) * (maximum - minimum))
		end
		sliderButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				update(input)
			end
		end)
		table.insert(connections, UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end))
		table.insert(connections, UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				update(input)
			end
		end))
		valueBox.FocusLost:Connect(function()
			local parsed = tonumber(valueBox.Text)
			if parsed then
				setValue(parsed)
			else
				valueBox.Text = formatValue(value)
			end
		end)
		valueBox.Focused:Connect(function()
			componentElements.Tween(valueStroke, Theme.HoverDuration, {
				Color = COLORS.Primary,
				Transparency = 0.1,
			})
		end)
		valueBox.FocusLost:Connect(function()
			componentElements.Tween(valueStroke, Theme.HoverDuration, {
				Color = Theme.Stroke.Color,
				Transparency = 0.88,
			})
		end)
		table.insert(connections, UserInputService.InputBegan:Connect(function(input)
			if GuiService.SelectedObject ~= sliderButton then return end
			if input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.Down then
				setValue(value - step)
			elseif input.KeyCode == Enum.KeyCode.Right or input.KeyCode == Enum.KeyCode.Up then
				setValue(value + step)
			elseif input.KeyCode == Enum.KeyCode.PageDown then
				setValue(value - step * 10)
			elseif input.KeyCode == Enum.KeyCode.PageUp then
				setValue(value + step * 10)
			end
		end))
		setValue(value, false)
		return slider
	end

	function componentElements.IconImage(parent, icon, size)
		if type(icon) == "number" or (type(icon) == "string" and icon:match("^%d+$")) then
			return componentElements.Make("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxassetid://" .. tostring(icon),
				ImageColor3 = COLORS.Muted,
				Size = UDim2.fromOffset(size, size),
			}, parent)
		end
		if type(icon) == "string" and icon:match("^https?://") then
			error("Icon image URLs must be uploaded to Roblox and passed as an asset ID", 2)
		end
		if type(icon) == "string" and icon:match("^rbxassetid://%d+$") then
			return componentElements.Make("ImageLabel", {
				BackgroundTransparency = 1,
				Image = icon,
				ImageColor3 = COLORS.Muted,
				Size = UDim2.fromOffset(size, size),
			}, parent)
		end
		local normalizedIcon
		if type(icon) == "string" then
			normalizedIcon = normalizeLucideName(icon) or ""
		else
			normalizedIcon = ""
		end
		-- Registered Lucide art takes precedence over legacy hand-drawn icons.
		-- Explicit lucide: names and ordinary names both work when an atlas is present.
		local atlasEntry = LucideAtlasRegistry[normalizedIcon]
		if not atlasEntry and not normalizedIcon:match("^lucide:") then
			atlasEntry = LucideAtlasRegistry[LucideAliases[normalizedIcon]]
		end
		if atlasEntry then
			return componentElements.Make("ImageLabel", {
				BackgroundTransparency = 1,
				Image = atlasEntry.Image,
				ImageRectOffset = atlasEntry.Offset,
				ImageRectSize = Vector2.new(atlasEntry.Cell, atlasEntry.Cell),
				ImageColor3 = COLORS.Icon,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromOffset(size, size),
			}, parent)
		end
		if normalizedIcon == "home" or normalizedIcon == "main" then
			local homeIcon = componentElements.Make("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(size, size),
			}, parent)
			local iconSize = size * 0.84
			local drawing = componentElements.Make("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(iconSize, iconSize),
			}, homeIcon)
			local function line(x, y, width, height, rotation)
				local segment = componentElements.Make("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = COLORS.Icon,
					BorderSizePixel = 0,
					Name = "HavocIconPart",
					Position = UDim2.fromOffset(x, y),
					Rotation = rotation,
					Size = UDim2.fromOffset(width, height),
				}, drawing)
				componentElements.Corner(segment, math.min(width, height) / 2)
				return segment
			end
			line(iconSize * 0.34, iconSize * 0.35, iconSize * 0.43, 1.3, -38)
			line(iconSize * 0.66, iconSize * 0.35, iconSize * 0.43, 1.3, 38)
			line(iconSize * 0.29, iconSize * 0.67, 1.3, iconSize * 0.36, 0)
			line(iconSize * 0.71, iconSize * 0.67, 1.3, iconSize * 0.36, 0)
			line(iconSize * 0.5, iconSize * 0.88, iconSize * 0.44, 1.3, 0)
			line(iconSize * 0.5, iconSize * 0.81, 1.2, iconSize * 0.2, 0)
			return homeIcon
		end
		if normalizedIcon == "aimbot" then
			local crosshair = componentElements.Make("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(size, size),
			}, parent)
			local ring = componentElements.Make("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(size * 0.46, size * 0.46),
			}, crosshair)
			componentElements.Corner(ring)
			componentElements.Make("UIStroke", {
				Color = COLORS.Muted,
				Thickness = 1.2,
				Transparency = 0,
			}, ring)
			local function tick(x, y, width, height)
				local segment = componentElements.Make("Frame", {
					BackgroundColor3 = COLORS.Icon,
					BorderSizePixel = 0,
					Name = "HavocIconPart",
					Position = UDim2.fromOffset(x, y),
					Size = UDim2.fromOffset(width, height),
				}, crosshair)
				componentElements.Corner(segment, math.min(width, height) / 2)
			end
			tick(size * 0.5 - 0.6, size * 0.08, 1.2, size * 0.18)
			tick(size * 0.5 - 0.6, size * 0.74, 1.2, size * 0.18)
			tick(size * 0.08, size * 0.5 - 0.6, size * 0.18, 1.2)
			tick(size * 0.74, size * 0.5 - 0.6, size * 0.18, 1.2)
			return crosshair
		end
		if normalizedIcon == "settings" or normalizedIcon == "exploits"
			or normalizedIcon == "movement" or normalizedIcon == "esp"
			or normalizedIcon == "sparkles" then
			local iconRoot = componentElements.Make("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(size, size),
			}, parent)
			local function part(width, height, x, y, rotation)
				local segment = componentElements.Make("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = COLORS.Icon,
					BorderSizePixel = 0,
					Name = "HavocIconPart",
					Position = UDim2.fromScale(x, y),
					Rotation = rotation or 0,
					Size = UDim2.fromOffset(width, height),
				}, iconRoot)
				componentElements.Corner(segment, math.min(width, height) / 2)
				return segment
			end
			if normalizedIcon == "settings" then
				local ring = componentElements.Make("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(size * 0.48, size * 0.48),
				}, iconRoot)
				componentElements.Corner(ring, size)
				componentElements.Make("UIStroke", {
					Color = COLORS.Muted,
					Thickness = 1.3,
				}, ring)
				part(size * 0.16, size * 0.16, 0.5, 0.5)
				part(size * 0.13, size * 0.2, 0.5, 0.1)
				part(size * 0.13, size * 0.2, 0.5, 0.9)
				part(size * 0.2, size * 0.13, 0.1, 0.5)
				part(size * 0.2, size * 0.13, 0.9, 0.5)
				part(size * 0.13, size * 0.2, 0.23, 0.23, 45)
				part(size * 0.13, size * 0.2, 0.77, 0.23, -45)
				part(size * 0.13, size * 0.2, 0.23, 0.77, -45)
				part(size * 0.13, size * 0.2, 0.77, 0.77, 45)
			elseif normalizedIcon == "exploits" then
				part(size * 0.78, 1.5, 0.5, 0.5, 45)
				part(size * 0.78, 1.5, 0.5, 0.5, -45)
				part(size * 0.18, 2, 0.19, 0.19, 45)
				part(size * 0.18, 2, 0.81, 0.19, -45)
			elseif normalizedIcon == "movement" then
				part(size * 0.62, 2, 0.42, 0.58, -45)
				part(size * 0.3, 2, 0.68, 0.29, 45)
				part(size * 0.3, 2, 0.79, 0.4, -45)
			elseif normalizedIcon == "esp" then
				local diamond = part(size * 0.52, size * 0.52, 0.5, 0.5, 45)
				diamond.BackgroundTransparency = 1
				componentElements.Make("UIStroke", {
					Color = COLORS.Muted,
					Thickness = 1.2,
				}, diamond)
				part(size * 0.14, size * 0.14, 0.5, 0.5)
			else
				part(1.4, size * 0.76, 0.5, 0.5)
				part(size * 0.76, 1.4, 0.5, 0.5)
				part(size * 0.12, size * 0.12, 0.15, 0.2)
				part(size * 0.12, size * 0.12, 0.85, 0.8)
			end
			return iconRoot
		end
		if normalizedIcon == "info" then
			local infoIcon = componentElements.Make("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(size, size),
			}, parent)
			local ring = componentElements.Make("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(size * 0.78, size * 0.78),
			}, infoIcon)
			componentElements.Corner(ring, size)
			componentElements.Make("UIStroke", {
				Color = COLORS.Muted,
				Thickness = 1.2,
			}, ring)
			local dot = componentElements.Make("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = COLORS.Muted,
				BorderSizePixel = 0,
				Name = "HavocIconPart",
				Position = UDim2.fromScale(0.5, 0.3),
				Size = UDim2.fromOffset(1.5, 1.5),
			}, infoIcon)
			componentElements.Corner(dot, 1)
			local stem = componentElements.Make("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = COLORS.Muted,
				BorderSizePixel = 0,
				Name = "HavocIconPart",
				Position = UDim2.fromScale(0.5, 0.6),
				Size = UDim2.fromOffset(1.5, size * 0.28),
			}, infoIcon)
			componentElements.Corner(stem, 1)
			return infoIcon
		end
		local namedIcons = {
			aim = "◎",
			bell = "♧",
			bolt = "ϟ",
			bookmark = "◇",
			combat = "◎",
			check = "✓",
			esp = "◈",
			exploits = "×",
			eye = "◉",
			general = "☷",
			info = "i",
			layers = "▤",
			lightning = "ϟ",
			list = "≡",
			movement = "↗",
			person = "♙",
			search = "⌕",
			settings = "○",
			shield = "⬡",
			sparkles = "✦",
			target = "◎",
			tune = "☷",
			user = "♙",
			visuals = "◉",
			welcome = "✦",
		}
		local iconText = ""
		if type(icon) == "string" then
			iconText = namedIcons[normalizedIcon] or (icon:match("^[%a%s_%-]+$") and "▤" or icon)
		end
		local label = componentElements.TextLabel(parent, iconText, size, COLORS.Muted, Enum.Font.GothamMedium)
		label.TextXAlignment = Enum.TextXAlignment.Center
		return label
	end

	return componentElements
end)()

local HavocLib = {}
HavocLib.__index = HavocLib

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local COLORS = Theme.Colors
local make = Elements.Make
local corner = Elements.Corner
local stroke = Elements.Stroke
local padding = Elements.Padding
local tween = Elements.Tween
local addPressFeedback = Elements.AddPressFeedback
local textLabel = Elements.TextLabel
local button = Elements.Button
local setCanvasHeight = Elements.SetCanvasHeight
local safeCallback = Elements.SafeCallback
local iconImage = Elements.IconImage

local function encodeConfigValue(value)
	local valueType = typeof(value)
	if valueType == "Color3" then
		return {
			__havocType = "Color3",
			R = value.R,
			G = value.G,
			B = value.B,
		}
	elseif valueType == "EnumItem" and value.EnumType == Enum.KeyCode then
		return {
			__havocType = "KeyCode",
			Name = value.Name,
		}
	elseif valueType == "string" or valueType == "number" or valueType == "boolean" then
		return value
	end
	error("Unsupported configuration value type: " .. valueType, 2)
end

local function decodeConfigValue(value, expectedType)
	if expectedType == "Color3" then
		assert(type(value) == "table" and value.__havocType == "Color3", "Invalid saved Color3 value")
		assert(type(value.R) == "number" and type(value.G) == "number" and type(value.B) == "number", "Invalid saved Color3 channels")
		return Color3.new(value.R, value.G, value.B)
	elseif expectedType == "EnumItem" then
		assert(type(value) == "table" and value.__havocType == "KeyCode", "Invalid saved keybind value")
		assert(type(value.Name) == "string", "Invalid saved keybind name")
		local keyCode = Enum.KeyCode[value.Name]
		assert(keyCode ~= nil, "Unknown saved keybind: " .. value.Name)
		return keyCode
	end
	assert(typeof(value) == expectedType, "Saved value type does not match control type")
	return value
end

-- Register additional Lucide sprite atlases before building your UI.
-- Example: HavocLib.RegisterLucideAtlas(customAssetUri, iconOffsets, 96)
function HavocLib.RegisterLucideAtlas(assetId, icons, cellSize)
    registerLucideAtlas(assetId, icons, cellSize)
end

function HavocLib.new(options)
	local config = options or {}
    local starterAtlasImage = resolveStarterLucideAtlas(config)
    if starterAtlasImage then
        registerLucideAtlas(starterAtlasImage, LucideStarterPositions, LUCIDE_CELL_SIZE)
    end
    if config.LucideAtlases ~= nil then
        assert(type(config.LucideAtlases) == "table", "LucideAtlases must be a table")
        for _, page in ipairs(config.LucideAtlases) do
            assert(type(page) == "table", "LucideAtlases entries must be tables")
            registerLucideAtlas(page.Image or page.AssetId, page.Icons, page.CellSize or LUCIDE_CELL_SIZE)
        end
    end
	local player = Players.LocalPlayer
	assert(player, "Havoc Lib must be initialized on the client")
	local playerGui = player:WaitForChild("PlayerGui")
	-- Avoid stacking earlier versions when the hub is reloaded.
	if config.ReplaceExisting ~= false then
		local previousGui = playerGui:FindFirstChild(config.Name or "havoc lib")
		if previousGui and previousGui:IsA("ScreenGui") then
			previousGui:Destroy()
		end
	end

	local self = setmetatable({}, HavocLib)
	self._startedAt = os.clock()
	self._connections = {}
	self._notifications = {}
	self._destroyed = false
	self._settings = {}
	self._configurationSaving = config.ConfigurationSaving or { Enabled = false }
	if self._configurationSaving.Enabled then
		local store = self._configurationSaving.Store
		assert(type(store) == "table", "ConfigurationSaving.Store is required when configuration saving is enabled")
		assert(type(store.Save) == "function", "ConfigurationSaving.Store.Save must be a function")
		assert(type(store.Load) == "function", "ConfigurationSaving.Store.Load must be a function")
	end

	local screen = make("ScreenGui", {
		Name = config.Name or "havoc lib",
		DisplayOrder = config.DisplayOrder or 1000,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, playerGui)
	self.ScreenGui = screen

	local window = setmetatable({
		_library = self,
		_tabs = {},
		_connections = {},
		_visible = true,
	}, Window)
	self.Window = window

	local minimumWindowSize = Vector2.new(640, 440)
	local maximumWindowSize = Vector2.new(1120, 860)
	local defaultWindowSize = Vector2.new(860, 590)
	local root = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = COLORS.Background,
		BorderSizePixel = 0,
		Position = config.Position or UDim2.fromScale(0.5, 0.5),
		Size = config.Size or UDim2.fromOffset(defaultWindowSize.X, defaultWindowSize.Y),
	}, screen)
	window.Root = root
	make("UISizeConstraint", {
		MinSize = minimumWindowSize,
		MaxSize = maximumWindowSize,
	}, root)
	local responsiveScale = make("UIScale", { Scale = 1 }, root)
	local function updateResponsiveScale()
		local camera = Workspace.CurrentCamera
		if not camera then return end
		local viewport = camera.ViewportSize
		responsiveScale.Scale = math.clamp(
			math.min((viewport.X - 32) / defaultWindowSize.X, (viewport.Y - 32) / defaultWindowSize.Y),
			0.1,
			1
		)
	end
	updateResponsiveScale()
	local viewportConnection = nil
	local function connectViewport()
		if viewportConnection then
			viewportConnection:Disconnect()
			local oldIndex = table.find(window._connections, viewportConnection)
			if oldIndex then
				table.remove(window._connections, oldIndex)
			end
			viewportConnection = nil
		end
		local camera = Workspace.CurrentCamera
		if camera then
			viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveScale)
			table.insert(window._connections, viewportConnection)
		end
		updateResponsiveScale()
	end
	local cameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		connectViewport()
	end)
	table.insert(window._connections, cameraConnection)
	connectViewport()
	root.ClipsDescendants = true
	corner(root, 20)
	local outline = make("Frame", {
		Active = false,
		AnchorPoint = root.AnchorPoint,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = root.Position,
		Selectable = false,
		Size = root.Size,
		ZIndex = 20,
	}, screen)
	corner(outline, 20)
	local outlineScale = make("UIScale", { Scale = responsiveScale.Scale }, outline)
	local rootStroke = stroke(outline)
	rootStroke.Color = Color3.fromRGB(92, 93, 101)
	rootStroke.Thickness = 1.1
	rootStroke.Transparency = 0.38
	local function syncOutline()
		outline.AnchorPoint = root.AnchorPoint
		outline.Position = root.Position
		outline.Size = UDim2.new(
			root.Size.X.Scale,
			root.Size.X.Offset - 2,
			root.Size.Y.Scale,
			root.Size.Y.Offset - 2
		)
	end
	root:GetPropertyChangedSignal("AnchorPoint"):Connect(syncOutline)
	root:GetPropertyChangedSignal("Position"):Connect(syncOutline)
	root:GetPropertyChangedSignal("Size"):Connect(syncOutline)
	syncOutline()
	responsiveScale:GetPropertyChangedSignal("Scale"):Connect(function()
		outlineScale.Scale = responsiveScale.Scale
	end)
	window._stroke = rootStroke
	window._outline = outline
	Elements.Gradient(root, Color3.fromRGB(19, 19, 21), COLORS.Background, 90)
	local rootGlow = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = COLORS.Glow,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0, -18),
		Size = UDim2.new(0.82, 0, 0, 88),
	}, root)
	corner(rootGlow, 40)
	local rootGlowGradient = make("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(126, 142, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(116, 193, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(126, 142, 255)),
		}),
		Rotation = 0,
	}, rootGlow)
	rootGlowGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.94),
		NumberSequenceKeypoint.new(1, 1),
	})
	local rootScale = make("UIScale", { Scale = Theme.OpenScale }, root)
	window._scale = rootScale
	window._open = true

	local function squareCornerFill(parent, position, color, radius)
		return make("Frame", {
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Position = position,
			Size = UDim2.fromOffset(radius, radius),
		}, parent)
	end

	local header = make("Frame", {
		BackgroundColor3 = Color3.fromRGB(25, 26, 29),
		ClipsDescendants = true,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.new(1, 0, 0, 60),
	}, root)
	window.Header = header
	corner(header, 20)
	padding(header, 14, 0)
	header.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
	Elements.Gradient(header, Color3.fromRGB(24, 24, 26), header.BackgroundColor3, 90)
	squareCornerFill(header, UDim2.new(0, 0, 1, -20), header.BackgroundColor3, 20)
	squareCornerFill(header, UDim2.new(1, -20, 1, -20), header.BackgroundColor3, 20)
	local headerSeparator = make("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.85,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 1),
	}, header)
	if config.Logo ~= nil then
		local logoAsset
		if type(config.Logo) == "number" and config.Logo > 0 and config.Logo % 1 == 0 then
			logoAsset = "rbxassetid://" .. tostring(config.Logo)
		elseif type(config.Logo) == "string" then
			local numericId = string.match(config.Logo, "^%d+$")
			local assetUri = string.match(config.Logo, "^rbxassetid://%d+$")
			logoAsset = numericId and ("rbxassetid://" .. numericId) or assetUri
		end
		assert(logoAsset, "Logo must be a positive Roblox asset ID or rbxassetid:// URI")
		local logoImage = make("ImageLabel", {
			BackgroundColor3 = COLORS.Interactive,
			BorderSizePixel = 0,
			Image = logoAsset,
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromOffset(32, 32),
		}, header)
		logoImage.AnchorPoint = Vector2.new(0, 0.5)
		logoImage.Position = UDim2.new(0, 0, 0.5, 0)
		corner(logoImage)
		local logoCorner = logoImage:FindFirstChildOfClass("UICorner")
		if logoCorner then logoCorner.CornerRadius = UDim.new(0, 6) end
		stroke(logoImage)
	else
		local logo = make("Frame", {
			BackgroundColor3 = COLORS.Interactive,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(32, 32),
		}, header)
		logo.AnchorPoint = Vector2.new(0, 0.5)
		logo.Position = UDim2.new(0, 0, 0.5, 0)
		corner(logo, 6)
		stroke(logo)
		local monogram = textLabel(logo, "h", 17, COLORS.Text, Enum.Font.GothamBold)
		monogram.Size = UDim2.fromScale(1, 1)
		monogram.TextXAlignment = Enum.TextXAlignment.Center
	end
	local title = textLabel(header, config.Title or "havoc lib", 14, COLORS.Text, Enum.Font.GothamBold)
	title.Position = UDim2.fromOffset(43, 5)
	title.Size = UDim2.new(0, 176, 0, 24)
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.TextSize = 17
	local subtitle = textLabel(header, config.Subtitle or "made by convict", 11, Color3.fromRGB(200, 200, 205))
	subtitle.Position = UDim2.fromOffset(43, 30)
	subtitle.Size = UDim2.new(0, 176, 0, 17)
	subtitle.TextTruncate = Enum.TextTruncate.AtEnd
	local statusPill = make("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(20, 34, 30),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 301, 0.5, 0),
		Size = UDim2.fromOffset(57, 19),
		Visible = config.ShowStatus == true,
	}, header)
	corner(statusPill, 9)
	local statusDot = make("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = COLORS.Success,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 7, 0.5, 0),
		Size = UDim2.fromOffset(6, 6),
	}, statusPill)
	corner(statusDot, 99)
	local statusLabel = textLabel(statusPill, "live", 11, Color3.fromRGB(175, 255, 215), Enum.Font.GothamBold)
	statusLabel.Position = UDim2.fromOffset(17, 0)
	statusLabel.Size = UDim2.new(1, -17, 1, 0)
	statusLabel.TextXAlignment = Enum.TextXAlignment.Left
	statusLabel.TextColor3 = Color3.fromRGB(185, 255, 219)
	local normalizedVersionLabel = normalizeVersionLabel(config.Version)
	local version = textLabel(header, normalizedVersionLabel or "", 10, COLORS.Muted, Enum.Font.GothamMedium)
	version.AnchorPoint = Vector2.new(0, 0.5)
	version.Position = UDim2.new(0, 228, 0.5, 0)
	version.Size = UDim2.fromOffset(74, 25)
	version.Visible = normalizedVersionLabel ~= nil
	version.BackgroundColor3 = Color3.fromRGB(36, 36, 39)
	version.TextColor3 = Color3.fromRGB(232, 232, 235)
	corner(version, 10)
	stroke(version, 0.78)
	Elements.Gradient(version, Color3.fromRGB(43, 43, 47), Color3.fromRGB(33, 33, 36), 90)
	version.TextXAlignment = Enum.TextXAlignment.Center
	version.Font = Enum.Font.GothamMedium

	local search = make("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(34, 34, 38),
		ClearTextOnFocus = false,
		Font = Enum.Font.Gotham,
		PlaceholderColor3 = COLORS.Muted,
		PlaceholderText = "search components...",
		Position = UDim2.new(1, -94, 0.5, 0),
		Size = UDim2.new(0.29, 0, 0, 33),
		Text = "",
		TextColor3 = COLORS.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, header)
	search.Visible = false
	search.BackgroundTransparency = 0.08
	search.ZIndex = 11
	corner(search, 12)
	local searchStroke = stroke(search)
	search.Focused:Connect(function()
		tween(searchStroke, Theme.HoverDuration, {
			Color = COLORS.Primary,
			Transparency = 0.1,
		})
	end)
	search.FocusLost:Connect(function()
		tween(searchStroke, Theme.HoverDuration, {
			Color = Theme.Stroke.Color,
			Transparency = Theme.Stroke.Transparency,
		})
	end)
	padding(search, 10, 0)
	window.SearchBox = search
	-- Search is a compact icon until there is room for the entire header.
	-- Focusing it temporarily replaces LIVE, not the version/title.
	local searchExpanded = false
	local searchToggle = button(header, "⌕", UDim2.fromOffset(30, 32), COLORS.Interactive, true)
	searchToggle.Name = "OpenSearch"
	searchToggle.AnchorPoint = Vector2.new(1, 0.5)
	searchToggle.Position = UDim2.new(1, -89, 0.5, 0)
	searchToggle.BackgroundTransparency = 1
	searchToggle.Text = ""
	searchToggle.ZIndex = 9
	local searchRing = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(13, 14),
		Size = UDim2.fromOffset(12, 12),
	}, searchToggle)
	corner(searchRing, 20)
	local searchRingStroke = stroke(searchRing, 0)
	searchRingStroke.Color = COLORS.Icon
	searchRingStroke.Thickness = 1.4
	local searchHandle = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = COLORS.Icon,
		Position = UDim2.fromOffset(20, 21),
		Rotation = 45,
		Size = UDim2.fromOffset(7, 1.5),
	}, searchToggle)
	corner(searchHandle, 2)
	local searchToggleStroke = searchToggle:FindFirstChildOfClass("UIStroke")
	if searchToggleStroke then searchToggleStroke.Transparency = 1 end
	searchToggle.MouseEnter:Connect(function()
		tween(searchToggle, Theme.HoverDuration, { BackgroundTransparency = 0.62 })
	end)
	searchToggle.MouseLeave:Connect(function()
		tween(searchToggle, Theme.HoverDuration, { BackgroundTransparency = 1 })
	end)
	local function updateHeaderLayout()
		local width = root.AbsoluteSize.X / math.max(responsiveScale.Scale * rootScale.Scale, 0.01)
		local labelWidth = TextService:GetTextSize(title.Text, title.TextSize, title.Font, Vector2.new(1000, 26)).X
		local metadataX = math.clamp(43 + labelWidth + 16, 188, 308)
		title.Size = UDim2.fromOffset(math.max(90, metadataX - 53), 24)
		subtitle.Size = UDim2.fromOffset(math.max(90, metadataX - 53), 17)
		version.Position = UDim2.new(0, metadataX, 0.5, 0)
		statusPill.Position = UDim2.new(0, metadataX + (normalizedVersionLabel and 82 or 0), 0.5, 0)
		local actionsStart = width - 84
		local searchWidth = math.clamp(width * 0.23, 165, 200)
		local searchStart = actionsStart - 12 - searchWidth
		local versionEnd = metadataX + (normalizedVersionLabel and 74 or 0)
		version.Visible = normalizedVersionLabel ~= nil and versionEnd < actionsStart - 50
		if not version.Visible then versionEnd = metadataX end
		local statusEnd = versionEnd + (version.Visible and 8 or 0) + 57
		local canShowLive = config.ShowStatus == true and statusEnd + 44 < actionsStart
		local fullSearch = config.SearchEnabled == true and width >= 780 and searchStart >= statusEnd + 20
		local expandedSearch = config.SearchEnabled == true and searchExpanded and not fullSearch
		statusPill.Visible = canShowLive and not expandedSearch
		search.Size = UDim2.fromOffset(searchWidth, 33)
		search.Visible = fullSearch or (expandedSearch and searchStart > versionEnd + 8)
		searchToggle.Visible = config.SearchEnabled == true and not fullSearch and not search.Visible
	end
	searchToggle.MouseButton1Click:Connect(function()
		searchExpanded = true
		updateHeaderLayout()
		if search.Visible then task.defer(function() search:CaptureFocus() end) end
	end)
	search.FocusLost:Connect(function()
		if searchExpanded then
			searchExpanded = false
			updateHeaderLayout()
		end
	end)
	root:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateHeaderLayout)
	responsiveScale:GetPropertyChangedSignal("Scale"):Connect(updateHeaderLayout)
	task.defer(updateHeaderLayout)

	local windowActions = make("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(72, 36),
	}, header)
	local actionsLayout = make("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, windowActions)
	local minimizeButton = button(windowActions, "−", UDim2.fromOffset(30, 32), COLORS.Interactive, true)
	minimizeButton.TextSize = 20
	minimizeButton.LayoutOrder = 1
	local closeButton = button(windowActions, "×", UDim2.fromOffset(30, 32), COLORS.Interactive, true)
	closeButton.TextSize = 20
	closeButton.LayoutOrder = 2
	for _, actionButton in ipairs({ minimizeButton, closeButton }) do
		actionButton.BackgroundTransparency = 1
		actionButton.TextColor3 = Color3.fromRGB(228, 228, 231)
		local actionStroke = actionButton:FindFirstChildOfClass("UIStroke")
		if actionStroke then actionStroke.Transparency = 1 end
		local actionCorner = actionButton:FindFirstChildOfClass("UICorner")
		if actionCorner then actionCorner.CornerRadius = UDim.new(0, 11) end
		local hovered = false
		local selected = false
		local function updateActionState()
			local highlighted = hovered or selected
			local isClose = actionButton == closeButton
			tween(actionButton, Theme.HoverDuration, {
				BackgroundColor3 = isClose and Color3.fromRGB(104, 43, 47) or Color3.fromRGB(47, 47, 51),
				BackgroundTransparency = hovered and 0 or 1,
				TextColor3 = highlighted and COLORS.Text or Color3.fromRGB(228, 228, 231),
			})
			if actionStroke then
				tween(actionStroke, Theme.HoverDuration, {
					Color = selected and COLORS.Primary or Theme.Stroke.Color,
					Transparency = selected and 0.25 or 1,
				})
			end
		end
		actionButton.MouseEnter:Connect(function()
			hovered = true
			updateActionState()
		end)
		actionButton.MouseLeave:Connect(function()
			hovered = false
			updateActionState()
		end)
		actionButton.SelectionGained:Connect(function()
			selected = true
			updateActionState()
		end)
		actionButton.SelectionLost:Connect(function()
			selected = false
			updateActionState()
		end)
	end
	window._expandedSize = root.Size
	window._expandedPosition = root.Position
	window._minimized = false
	window._maximized = false

	local body = make("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = UDim2.new(0, 0, 0, 60),
		Size = UDim2.new(1, 0, 1, config.ShowMetrics == true and -84 or -60),
	}, root)
	window.Body = body
	local bodyGlow = make("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.985,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
	}, body)
	local sidebar = make("Frame", {
		BackgroundColor3 = Color3.fromRGB(15, 15, 17),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.new(0, SIDEBAR_WIDTH, 1, 0),
	}, body)
	Elements.Gradient(sidebar, Color3.fromRGB(17, 17, 19), sidebar.BackgroundColor3, 90)
	corner(sidebar, 18)
	squareCornerFill(sidebar, UDim2.new(0, 0, 0, 0), sidebar.BackgroundColor3, 18)
	squareCornerFill(sidebar, UDim2.new(1, -18, 0, 0), sidebar.BackgroundColor3, 18)
	squareCornerFill(sidebar, UDim2.new(1, -18, 1, -18), sidebar.BackgroundColor3, 18)
	local tabViewport = make("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(13, 14),
		Size = UDim2.new(1, -26, 1, -28),
	}, sidebar)
	local tabList = make("ScrollingFrame", {
		Active = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = true,
		ScrollBarThickness = 0,
		ScrollBarImageTransparency = 1,
		TopImage = "",
		MidImage = "",
		BottomImage = "",
		VerticalScrollBarInset = Enum.ScrollBarInset.None,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, 18, 1, 0),
	}, tabViewport)
	local tabLayout = make("UIListLayout", {
		Padding = UDim.new(0, 3),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, tabList)
	setCanvasHeight(tabList, tabLayout, 16)
	window._tabList = tabList

	local content = make("Frame", {
		BackgroundColor3 = Color3.fromRGB(24, 24, 26),
		BackgroundTransparency = 0,
		Position = UDim2.new(0, SIDEBAR_WIDTH, 0, 0),
		Size = UDim2.new(1, -SIDEBAR_WIDTH, 1, 0),
	}, body)
	Elements.Gradient(content, Color3.fromRGB(26, 26, 28), content.BackgroundColor3, 90)
	corner(content, 16)
	squareCornerFill(content, UDim2.new(0, 0, 0, 0), content.BackgroundColor3, 16)
	squareCornerFill(content, UDim2.new(1, -16, 0, 0), content.BackgroundColor3, 16)
	squareCornerFill(content, UDim2.new(0, 0, 1, -16), content.BackgroundColor3, 16)
	window.Content = content
	local sidebarDivider = make("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.87,
		BorderSizePixel = 0,
		Position = UDim2.new(0, SIDEBAR_WIDTH - 1, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
	}, body)
	
	local function updateSidebarWidth()
		local sizeX = root.AbsoluteSize.X / math.max(responsiveScale.Scale * rootScale.Scale, 0.01)
		local newWidth = math.clamp(math.floor(sizeX * 0.335), 210, 230)
		sidebar.Size = UDim2.new(0, newWidth, 1, 0)
		sidebarDivider.Position = UDim2.new(0, newWidth - 1, 0, 0)
		content.Position = UDim2.new(0, newWidth, 0, 0)
		content.Size = UDim2.new(1, -newWidth, 1, 0)
	end
	root:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSidebarWidth)
	responsiveScale:GetPropertyChangedSignal("Scale"):Connect(updateSidebarWidth)
	task.defer(updateSidebarWidth)

	local status = make("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, -24),
		Size = UDim2.new(1, 0, 0, 24),
		Visible = config.ShowMetrics == true,
	}, root)
	local statusText = textLabel(status, "fps --  |  ping -- ms  |  runtime 0s", 12, COLORS.Muted)
	statusText.Position = UDim2.new(0, 17, 0, 0)
	statusText.Size = UDim2.new(1, -34, 1, 0)
	window._statusText = statusText
	window._status = status

	local resizeGrip = make("TextButton", {
		Active = true,
		AnchorPoint = Vector2.new(1, 1),
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -6, 1, -6),
		Selectable = false,
		Size = UDim2.fromOffset(28, 28),
		Text = "",
		ZIndex = 30,
	}, root)
	local resizeStart = nil
	local resizeStartSize = nil
	resizeGrip.InputBegan:Connect(function(input)
		if window._maximized or window._minimized then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizeStart = input.Position
			local scale = math.max(responsiveScale.Scale, 0.1)
			resizeStartSize = root.AbsoluteSize / scale
		end
	end)
	table.insert(window._connections, UserInputService.InputChanged:Connect(function(input)
		if not resizeStart or not resizeStartSize then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local scale = math.max(responsiveScale.Scale, 0.1)
		local delta = Vector2.new(
			input.Position.X - resizeStart.X,
			input.Position.Y - resizeStart.Y
		) / scale
		local width = math.clamp(resizeStartSize.X + delta.X, minimumWindowSize.X, maximumWindowSize.X)
		local height = math.clamp(resizeStartSize.Y + delta.Y, minimumWindowSize.Y, maximumWindowSize.Y)
		root.Size = UDim2.fromOffset(width, height)
		window._expandedSize = root.Size
	end))
	table.insert(window._connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizeStart = nil
			resizeStartSize = nil
		end
	end))
	-- Both header controls hide the entire window without resizing or destroying it.
	minimizeButton.MouseButton1Click:Connect(function()
		window:SetVisible(false)
	end)
	closeButton.MouseButton1Click:Connect(function()
		window:SetVisible(false)
	end)

	-- Touch-only floating launcher. This belongs directly to ScreenGui instead of
	-- Root, so hiding the window never hides the control needed to reopen it.
	-- TouchEnabled is Roblox's capability check; don't show a mobile launcher
	-- on ordinary mouse/keyboard-only desktops.
	if UserInputService.TouchEnabled and config.MobileToggleEnabled ~= false then
		local diameter = 48
		local screenInset = 12
		local launcher = make("TextButton", {
			Name = "HavocMobileToggle",
			Active = true,
			AutoButtonColor = false,
			BackgroundColor3 = Color3.fromRGB(31, 31, 35),
			BackgroundTransparency = 0.08,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.new(0, screenInset, 0.5, -diameter / 2),
			Size = UDim2.fromOffset(diameter, diameter),
			Text = "h",
			Font = Enum.Font.GothamBold,
			TextColor3 = COLORS.Text,
			TextSize = 22,
			Selectable = false,
			ZIndex = 100,
		}, screen)
		corner(launcher, 14)
		local launcherOutline = stroke(launcher, 0.6)
		launcherOutline.Thickness = 1
		window.MobileToggle = launcher

		local activeTouch = nil
		local touchOrigin = nil
		local buttonOrigin = nil
		local dragged = false
		local function clampLauncher(pos)
			local camera = Workspace.CurrentCamera
			local bounds = camera and camera.ViewportSize or Vector2.new(1920, 1080)
			return Vector2.new(
				math.clamp(pos.X, screenInset, math.max(screenInset, bounds.X - diameter - screenInset)),
				math.clamp(pos.Y, screenInset, math.max(screenInset, bounds.Y - diameter - screenInset))
			)
		end
		local function moveLauncher(position)
			launcher.Position = UDim2.fromOffset(position.X, position.Y)
		end
		launcher.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch or activeTouch ~= nil then return end
			activeTouch = input
			touchOrigin = Vector2.new(input.Position.X, input.Position.Y)
			buttonOrigin = Vector2.new(launcher.AbsolutePosition.X, launcher.AbsolutePosition.Y)
			dragged = false
		end)
		table.insert(window._connections, UserInputService.InputChanged:Connect(function(input)
			if input ~= activeTouch or touchOrigin == nil then return end
			local delta = Vector2.new(input.Position.X, input.Position.Y) - touchOrigin
			if delta.Magnitude > 8 then dragged = true end
			if dragged then moveLauncher(clampLauncher(buttonOrigin + delta)) end
		end))
		table.insert(window._connections, UserInputService.InputEnded:Connect(function(input)
			if input ~= activeTouch then return end
			-- A drag only repositions the launcher; a tap toggles visibility.
			if not dragged and not self._destroyed then
				window:SetVisible(not window._visible)
			end
			activeTouch = nil
			touchOrigin = nil
			buttonOrigin = nil
		end))
		-- Re-clamp after rotation/viewport resizing to avoid losing the button.
		local viewportChanged = nil
		local function bindViewport()
			if viewportChanged then
				viewportChanged:Disconnect()
				viewportChanged = nil
			end
			local camera = Workspace.CurrentCamera
			if camera then
				viewportChanged = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					moveLauncher(clampLauncher(launcher.AbsolutePosition))
				end)
			end
		end
		bindViewport()
		table.insert(window._connections, Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindViewport))
		table.insert(window._connections, {
			Disconnect = function()
				if viewportChanged then viewportChanged:Disconnect() end
			end,
		})
		-- Reposition from the initial relative position after AbsoluteSize resolves.
		task.defer(function()
			if launcher.Parent then moveLauncher(clampLauncher(launcher.AbsolutePosition)) end
		end)
	end

	-- Default show/hide shortcut. Ignore keys consumed by Roblox, including chat,
	-- and ignore all focused TextBoxes (including the library's own search field).
	window.ToggleKey = config.ToggleKey == nil and Enum.KeyCode.K or config.ToggleKey
	assert(typeof(window.ToggleKey) == "EnumItem" and window.ToggleKey.EnumType == Enum.KeyCode,
		"ToggleKey must be an Enum.KeyCode")
	table.insert(window._connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if UserInputService:GetFocusedTextBox() ~= nil then return end
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if input.KeyCode ~= window.ToggleKey then return end
		if not window._library._destroyed then
			window:SetVisible(not window._visible)
		end
	end))

	local dragStart = nil
	local startPosition = nil
	local function isInside(guiObject, point)
		if not guiObject.Visible then return false end
		local objectPosition = guiObject.AbsolutePosition
		local objectSize = guiObject.AbsoluteSize
		return point.X >= objectPosition.X
			and point.X <= objectPosition.X + objectSize.X
			and point.Y >= objectPosition.Y
			and point.Y <= objectPosition.Y + objectSize.Y
	end
	header.InputBegan:Connect(function(input)
		if window._maximized or not window._visible then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if isInside(windowActions, input.Position) or isInside(search, input.Position) then
				return
			end
			dragStart = input.Position
			startPosition = root.Position
		end
	end)
	local dragEndConnection = UserInputService.InputChanged:Connect(function(input)
		if not dragStart or not startPosition then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local delta = (input.Position - dragStart) / math.max(responsiveScale.Scale, 0.1)
		root.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
	end)
	local dragStopConnection = UserInputService.InputEnded:Connect(function(input)
		if dragStart and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragStart = nil
			startPosition = nil
		end
	end)
	table.insert(window._connections, dragEndConnection)
	table.insert(window._connections, dragStopConnection)

	local frameCounter = 0
	local elapsedFrame = 0
	local statusConnection = RunService.RenderStepped:Connect(function(dt)
		frameCounter = frameCounter + 1
		elapsedFrame = elapsedFrame + dt
		if elapsedFrame >= 0.5 then
			local fps = math.floor(frameCounter / elapsedFrame + 0.5)
			local ping = "--"
			local ok, result = pcall(function()
				return player:GetNetworkPing() * 1000
			end)
			if ok and type(result) == "number" then ping = tostring(math.floor(result + 0.5)) end
			statusText.Text = string.format("fps %d  |  ping %s ms  |  runtime %ds", fps, ping, math.floor(os.clock() - self._startedAt))
			frameCounter = 0
			elapsedFrame = 0
		end
	end)
	table.insert(window._connections, statusConnection)

	window._applySearch = function()
		local query = string.lower(search.Text)
		for _, tab in ipairs(window._tabs) do
			local tabNameMatches = query == "" or string.find(string.lower(tab._name), query, 1, true) ~= nil
			for _, card in ipairs(tab._cards) do
				local visible = tabNameMatches or string.find(string.lower(card._searchText), query, 1, true) ~= nil
				card._frame.Visible = visible
			end
			tab._button.Visible = tabNameMatches or tab._matches(query)
		end
		for index, tab in ipairs(window._tabs) do
			if tab._caption then
				local groupHasVisibleTab = false
				for candidateIndex = index, #window._tabs do
					local candidate = window._tabs[candidateIndex]
					if candidateIndex > index and candidate._caption then
						break
					end
					if candidate._button.Visible then
						groupHasVisibleTab = true
						break
					end
				end
				tab._caption.Visible = groupHasVisibleTab
			end
		end
		if window._activeTab and not window._activeTab._button.Visible then
			for _, tab in ipairs(window._tabs) do
				if tab._button.Visible then
					window:SelectTab(tab)
					break
				end
			end
		end
		for _, tab in ipairs(window._tabs) do
			tab._page.Visible = tab == window._activeTab and tab._button.Visible
			if tab._emptyState then
				tab._emptyState.Visible = tab._page.Visible and #tab._cards == 0
			end
			tab._updateScrollHint()
		end
	end
	search:GetPropertyChangedSignal("Text"):Connect(window._applySearch)

	if self._configurationSaving.Enabled then
		window:_CreateConfigManager(self._configurationSaving)
	end

	tween(rootScale, Theme.Animation.Open.Time, { Scale = 1 }, Enum.EasingStyle.Quint)
	root.BackgroundTransparency = 1
	tween(root, Theme.Animation.Fade.Time, { BackgroundTransparency = 0 })
	tween(rootStroke, Theme.Animation.Fade.Time, { Transparency = 0.38 })
	return window
end

function Window:Tab(options)
	assert(type(options) == "table" and type(options.Name) == "string", "Tab requires a Name")
	local tab = setmetatable({
		_window = self,
		_name = options.Name,
		_cards = {},
		_sections = {},
	}, Tab)
	if type(options.CaptionBefore) == "string" and options.CaptionBefore ~= "" then
		local caption = make("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -18, 0, 31),
		}, self._tabList)
		local captionLabel = textLabel(caption, options.CaptionBefore, 12, COLORS.Muted)
		captionLabel.Position = UDim2.new(0, 10, 0, 12)
		captionLabel.Size = UDim2.new(1, -20, 0, 15)
		tab._caption = caption
	end

	local tabButton = make("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = COLORS.Container,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -18, 0, 42),
		Text = "",
	}, self._tabList)
	tab._button = tabButton
	tabButton.BackgroundColor3 = COLORS.SurfaceAlt
	tabButton.BackgroundTransparency = 1
	Elements.Gradient(tabButton, Color3.fromRGB(45, 45, 49), Color3.fromRGB(39, 39, 42), 90)
	tabButton.Selectable = true
	local tabScale = make("UIScale", { Scale = 1 }, tabButton)
	tabButton.MouseButton1Down:Connect(function()
		tween(tabScale, Theme.Animation.Press.Time, { Scale = Theme.PressScale }, Enum.EasingStyle.Quint)
	end)
	local function releaseTabPress()
		tween(tabScale, Theme.Animation.Release.Time, { Scale = 1 }, Enum.EasingStyle.Quint)
	end
	tabButton.MouseButton1Up:Connect(releaseTabPress)
	tabButton.MouseButton1Click:Connect(releaseTabPress)
	corner(tabButton)
	local tabCorner = tabButton:FindFirstChildOfClass("UICorner")
	if tabCorner then tabCorner.CornerRadius = UDim.new(0, 12) end
	local tabStroke = stroke(tabButton)
	tabStroke.Transparency = 1
	tabButton.SelectionGained:Connect(function()
		tween(tabStroke, Theme.HoverDuration, {
			Color = COLORS.Primary,
			Transparency = 0.2,
		})
	end)
	tabButton.SelectionLost:Connect(function()
		tween(tabStroke, Theme.HoverDuration, {
			Color = self._activeTab == tab and COLORS.Primary or Theme.Stroke.Color,
			Transparency = 1,
		})
	end)
	local icon = iconImage(tabButton, options.Icon or options.Name, 19)
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Position = UDim2.new(0, 20, 0.5, 0)
	icon.Size = UDim2.fromOffset(18, 18)
	local label = textLabel(tabButton, options.Name, Theme.Font.Body, COLORS.Muted, Enum.Font.GothamMedium)
	label.Position = UDim2.fromOffset(43, 0)
	label.Size = UDim2.new(1, -53, 1, 0)
	label.TextTruncate = Enum.TextTruncate.AtEnd
	tab._label = label
	local badge = textLabel(tabButton, "", 11, COLORS.Text, Enum.Font.GothamBold)
	badge.AnchorPoint = Vector2.new(1, 0.5)
	badge.Position = UDim2.new(1, -8, 0.5, 0)
	badge.Size = UDim2.fromOffset(26, 22)
	badge.BackgroundColor3 = COLORS.Accent
	badge.TextColor3 = COLORS.Background
	badge.Visible = false
	corner(badge)
	stroke(badge)
	tab.Badge = badge

	local indicator = make("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = COLORS.Accent,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 3, 0, 0),
	}, tabButton)
	corner(indicator)
	indicator.Visible = false
	tab._indicator = indicator

	local pageViewport = make("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -24, 1, 0),
		Visible = false,
	}, self.Content)
	local page = make("ScrollingFrame", {
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.None,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		ScrollBarImageTransparency = 1,
		TopImage = "",
		MidImage = "",
		BottomImage = "",
		ScrollBarThickness = 0,
		ScrollingEnabled = true,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		VerticalScrollBarInset = Enum.ScrollBarInset.None,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, 18, 1, 0),
	}, pageViewport)
	tab._page = pageViewport
	tab._scroller = page
	-- Compatibility with older callers; no visible scroll hint is created.
	local scrollHint = { Visible = false }
	tab._scrollHint = scrollHint
	if type(options.EmptyText) == "string" and options.EmptyText ~= "" then
		local emptyState = make("Frame", {
			Active = false,
			BackgroundTransparency = 1,
			Position = pageViewport.Position,
			Size = pageViewport.Size,
			Visible = false,
			ZIndex = page.ZIndex + 1,
		}, self.Content)
		local emptyLabel = textLabel(emptyState, options.EmptyText, 11, Color3.fromRGB(171, 171, 176))
		emptyLabel.ZIndex = emptyState.ZIndex + 1
		emptyLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		emptyLabel.Position = UDim2.fromScale(0.5, 0.5)
		emptyLabel.Size = UDim2.new(1, -32, 0, 24)
		emptyLabel.TextXAlignment = Enum.TextXAlignment.Center
		tab._emptyState = emptyState
	end
	local pagePadding = padding(page, 12, 22)
	pagePadding.PaddingRight = UDim.new(0, 30)
	local pageLayout = make("UIListLayout", {
		Padding = UDim.new(0, 20),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, page)
	setCanvasHeight(page, pageLayout, 38)
	tab._updateScrollHint = function()
		scrollHint.Visible = false
	end

	tab._matches = function(query)
		if string.find(string.lower(tab._name), query, 1, true) then return true end
		for _, card in ipairs(tab._cards) do
			if string.find(string.lower(card._searchText), query, 1, true) then return true end
		end
		return false
	end
	tabButton.MouseEnter:Connect(function()
		if self._activeTab ~= tab then
			tween(tabButton, Theme.HoverDuration, { BackgroundTransparency = 0.15 })
		end
	end)
	tabButton.MouseLeave:Connect(function()
		if self._activeTab ~= tab then
			tween(tabButton, Theme.HoverDuration, { BackgroundTransparency = 1 })
		end
	end)
	tabButton.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)
	tab:SetBadge(options.Badge)
	table.insert(self._tabs, tab)
	if #self._tabs == 1 then self:SelectTab(tab) end
	self._applySearch()
	return tab
end

function Window:SelectTab(tab)
	assert(type(tab) == "table" and tab._window == self and table.find(self._tabs, tab), "Tab does not belong to this window")
	if self._activeTab == tab then return end
	self._activeTab = tab
	for _, item in ipairs(self._tabs) do
		local active = item == tab
		item._page.Visible = active
		item._page.Position = UDim2.fromOffset(12, 0)
		-- Keep page position stable during tab switches (no lateral shifting).
		item._scrollHint.Visible = false
		item._updateScrollHint()
		if item._emptyState then
			item._emptyState.Visible = active and #item._cards == 0
		end
		tween(item._button, Theme.HoverDuration, {
			BackgroundColor3 = active and Color3.fromRGB(43, 43, 47) or COLORS.SurfaceAlt,
			BackgroundTransparency = active and 0 or 1,
		})
		local itemStroke = item._button:FindFirstChildOfClass("UIStroke")
		if itemStroke then
			itemStroke.Transparency = 1
			itemStroke.Color = Theme.Stroke.Color
		end
		item._indicator.Visible = false
		tween(item._indicator, 0.24, {
			BackgroundColor3 = Color3.fromRGB(120, 146, 206),
			Size = UDim2.new(0, 0, 0, 0),
		})
		for _, child in ipairs(item._button:GetDescendants()) do
			if child:IsA("TextLabel") and child ~= item.Badge then
				tween(child, Theme.HoverDuration, { TextColor3 = active and COLORS.Text or COLORS.Muted })
			elseif child:IsA("ImageLabel") then
				tween(child, Theme.HoverDuration, { ImageColor3 = active and COLORS.Text or COLORS.Icon })
			elseif child:IsA("Frame") and child.Name == "HavocIconPart" then
				tween(child, Theme.HoverDuration, { BackgroundColor3 = active and COLORS.Text or COLORS.Icon })
			elseif child:IsA("UIStroke") then
				tween(child, Theme.HoverDuration, { Color = active and COLORS.Text or COLORS.Icon })
			end
		end
	end
end

function Tab:SetBadge(value)
	if value == nil or value == false or value == "" or value == 0 then
		self.Badge.Visible = false
		self._label.Size = UDim2.new(1, -53, 1, 0)
	else
		self.Badge.Text = tostring(value)
		self.Badge.Visible = true
		self._label.Size = UDim2.new(1, -86, 1, 0)
	end
end

function Tab:Section(options)
	local sectionOptions
	if type(options) == "string" then
		sectionOptions = { Name = options }
	else
		sectionOptions = options or {}
	end
	local frame = make("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = sectionOptions.BackgroundColor or Color3.fromRGB(33, 33, 36),
		BackgroundTransparency = Theme.PanelTransparency,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
	}, self._scroller)
	corner(frame, 17)
	-- The width cap reproduces the centered, compact cards in the reference.
	make("UISizeConstraint", { MaxSize = Vector2.new(500, 100000) }, frame)
	padding(frame, 16, 17)
	if sectionOptions.GradientColor then
		Elements.Gradient(frame, frame.BackgroundColor3, sectionOptions.GradientColor)
	else
		Elements.Gradient(frame, Color3.fromRGB(36, 36, 39), frame.BackgroundColor3, 90)
	end
	stroke(frame, 0.78)
	local layout = make("UIListLayout", {
		Padding = UDim.new(0, 12),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, frame)
	local headingRow = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 24),
		LayoutOrder = -1,
	}, frame)
	local icon = iconImage(headingRow, sectionOptions.Icon or sectionOptions.Name or "layers", 18)
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.Position = UDim2.new(0, 9, 0.5, 0)
	icon.Size = UDim2.fromOffset(18, 18)
	local headingIconColor = COLORS.Text
	if icon:IsA("ImageLabel") then
		icon.ImageColor3 = headingIconColor
	elseif icon:IsA("TextLabel") then
		icon.TextColor3 = headingIconColor
	end
	for _, iconPart in ipairs(icon:GetDescendants()) do
		if iconPart:IsA("ImageLabel") then
			iconPart.ImageColor3 = headingIconColor
		elseif iconPart:IsA("TextLabel") then
			iconPart.TextColor3 = headingIconColor
		elseif iconPart:IsA("Frame") and iconPart.Name == "HavocIconPart" then
			iconPart.BackgroundColor3 = headingIconColor
		elseif iconPart:IsA("UIStroke") then
			iconPart.Color = headingIconColor
		end
	end
	local headingText = sectionOptions.Name or "Section"
	local headingWidth = TextService:GetTextSize(
		headingText,
		Theme.Font.Heading,
		Enum.Font.GothamBold,
		Vector2.new(1000, 22)
	).X
	local heading = textLabel(headingRow, headingText, Theme.Font.Heading, COLORS.Text, Enum.Font.GothamBold)
	heading.Position = UDim2.fromOffset(32, 0)
	heading.Size = UDim2.new(0, headingWidth + 6, 1, 0)
	local divider = make("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(84, 84, 90),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 43 + headingWidth, 0.5, 0),
		Size = UDim2.new(1, -(43 + headingWidth), 0, 1),
		ZIndex = headingRow.ZIndex + 1,
	}, headingRow)
	corner(divider, 1)
	local dividerGradient = Elements.Gradient(divider, Color3.fromRGB(75, 75, 81), Color3.fromRGB(46, 46, 50), 0)
	dividerGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 0.82),
	})
	local function updateDivider()
		local dividerStart = 43 + headingWidth
		divider.Position = UDim2.new(0, dividerStart, 0.5, 0)
		divider.Size = UDim2.new(1, -dividerStart, 0, 1)
		divider.Visible = headingRow.AbsoluteSize.X > dividerStart + 24
	end
	headingRow:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateDivider)
	updateDivider()
	local section = setmetatable({
		_tab = self,
		_window = self._window,
		_frame = frame,
		_layout = layout,
		_title = sectionOptions.Name or "Section",
	}, Section)
	table.insert(self._sections, section)
	return section
end

function Section:_register(frame, searchText)
	table.insert(self._tab._cards, { _frame = frame, _searchText = self._title .. " " .. searchText })
	if self._tab._emptyState then
		self._tab._emptyState.Visible = false
	end
	self._window._applySearch()
	return frame
end

function Section:_registerSetting(options, control)
	local flag = options.Flag
	if flag == nil then
		return
	end
	assert(type(flag) == "string" and flag ~= "", "Configurable controls require a non-empty string Flag")
	local settings = self._window._library._settings
	assert(settings[flag] == nil, "Duplicate configuration Flag: " .. flag)
	settings[flag] = {
		Control = control,
		ValueType = typeof(control.Value),
	}
end

function Section:Button(options)
	assert(type(options) == "table" and type(options.Name) == "string", "Button requires a Name")
	local element = Elements.ActionButton(self._frame, options, self._window._library)
	self:_register(element, options.Name)
	return element
end

function Section:Paragraph(options)
	assert(type(options) == "table" and type(options.Name) == "string", "Paragraph requires a Name")
	local paragraph = make("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
	}, self._frame)
	local title
	if options.HideTitle ~= true then
		title = textLabel(paragraph, options.Name, options.TitleSize or 14, COLORS.Text, Enum.Font.GothamMedium)
		title.Size = UDim2.new(1, 0, 0, 20)
	end
	local content = Elements.Paragraph(paragraph, options)
	local paragraphLayout = make("UIListLayout", {
		Padding = UDim.new(0, title and 4 or 0),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, paragraph)
	if title then
		title.LayoutOrder = 1
		content.LayoutOrder = 2
	else
		content.LayoutOrder = 1
	end
	paragraphLayout.Name = "ParagraphLayout"
	self:_register(paragraph, options.Name .. " " .. (options.Content or ""))
	return paragraph
end

function Section:Buttons(options)
	assert(type(options) == "table" and type(options.Buttons) == "table", "Buttons requires a Buttons array")
	local items = options.Buttons
	assert(#items > 0, "Buttons requires at least one button")
	local gap = options.Gap or 8
	local row = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, options.Height or 44),
	}, self._frame)
	local layout = make("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		Padding = UDim.new(0, gap),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, row)
	for index, item in ipairs(items) do
		assert(type(item) == "table" and type(item.Name) == "string", "Each button requires a Name")
		local widthScale = 1 / #items
		local buttonOptions = table.clone(item)
		buttonOptions.Size = UDim2.new(widthScale, -gap * (#items - 1) / #items, 0, options.Height or 44)
		Elements.ActionButton(row, buttonOptions, self._window._library).LayoutOrder = index
	end
	layout.Name = "ButtonLayout"
	self:_register(row, options.Name or table.concat((function()
		local names = {}
		for _, item in ipairs(items) do table.insert(names, item.Name) end
		return names
	end)(), " "))
	return row
end

function Section:Row(options)
	assert(type(options) == "table" and type(options.Items) == "table", "Row requires an Items array")
	local items = options.Items
	assert(#items > 0, "Row requires at least one item")
	local columns = math.clamp(math.floor(options.Columns or #items), 1, #items)
	local gap = options.Gap or 8
	local itemHeight = options.Height or 44
	local row = make("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, itemHeight),
	}, self._frame)
	local grid = make("UIGridLayout", {
		CellPadding = UDim2.fromOffset(gap, gap),
		CellSize = UDim2.new(1 / columns, -gap * (columns - 1) / columns, 0, itemHeight),
		FillDirection = Enum.FillDirection.Horizontal,
		FillDirectionMaxCells = columns,
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, row)
	local function updateRowHeight()
		row.Size = UDim2.new(1, 0, 0, grid.AbsoluteContentSize.Y)
	end
	grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateRowHeight)
	updateRowHeight()

	local searchTerms = {}
	for index, item in ipairs(items) do
		assert(type(item) == "table" and type(item.Type) == "string", "Each row item requires a Type")
		assert(type(item.Name) == "string", "Each row item requires a Name")
		local itemType = string.lower(item.Type)
		if itemType == "button" then
			local buttonOptions = table.clone(item)
			buttonOptions.Size = UDim2.new(1, 0, 0, itemHeight)
			Elements.ActionButton(row, buttonOptions, self._window._library).LayoutOrder = index
		elseif itemType == "toggle" then
			local toggleOptions = table.clone(item)
			toggleOptions.Size = UDim2.new(1, 0, 0, itemHeight)
			local toggle = Elements.Toggle(row, toggleOptions, self._window._library)
			toggle.Frame.LayoutOrder = index
			self:_registerSetting(item, toggle)
		else
			error(string.format("Unsupported row item type %q; use Button or Toggle", item.Type), 2)
		end
		table.insert(searchTerms, item.Name)
	end
	self:_register(row, table.concat(searchTerms, " "))
	return row
end

function Section:Toggle(options)
	assert(type(options) == "table" and type(options.Name) == "string", "Toggle requires a Name")
	local toggle = Elements.Toggle(self._frame, options, self._window._library)
	self:_register(toggle.Frame, options.Name)
	self:_registerSetting(options, toggle)
	return toggle
end

function Section:Slider(options)
	assert(type(options) == "table" and type(options.Name) == "string", "Slider requires a Name")
	local slider = Elements.Slider(self._frame, options, self._window._library, self._window._connections)
	self:_register(slider.Frame, options.Name)
	self:_registerSetting(options, slider)
	return slider
end

function Section:Dropdown(options)
	assert(type(options) == "table" and type(options.Name) == "string", "Dropdown requires a Name")
	local choices = options.Options or {}
	assert(type(choices) == "table", "Dropdown Options must be a table")
	local maxVisible = options.MaxVisible or 5
	assert(
		isFiniteNumber(maxVisible) and maxVisible >= 1 and maxVisible == math.floor(maxVisible),
		"Dropdown MaxVisible must be a positive integer"
	)
	local selected = options.Default
	if selected ~= nil then
		assert(table.find(choices, selected) ~= nil, "Dropdown Default must be included in Options")
	end
	local expanded = false
	local holder = make("Frame", {
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 44),
	}, self._frame)
	local head = button(holder, options.Name .. "   ·   " .. (selected and tostring(selected) or "Select"), UDim2.new(1, 0, 0, 44))
	head.TextXAlignment = Enum.TextXAlignment.Left
	padding(head, 16, 0)
	local chevron = textLabel(holder, "⌄", 20, COLORS.Muted, Enum.Font.GothamMedium)
	chevron.Active = false
	chevron.AnchorPoint = Vector2.new(1, 0)
	chevron.Position = UDim2.new(1, -12, 0, 0)
	chevron.Size = UDim2.fromOffset(18, 44)
	chevron.TextXAlignment = Enum.TextXAlignment.Center
	local menu = make("ScrollingFrame", {
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.None,
		CanvasSize = UDim2.new(),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0,
		ScrollBarImageColor3 = COLORS.Border,
		ScrollBarImageTransparency = 1,
		TopImage = "",
		MidImage = "",
		BottomImage = "",
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundColor3 = COLORS.Background,
		BackgroundTransparency = 0.04,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 0, 0),
		Visible = false,
	}, holder)
	menu.Position = UDim2.new(0, 0, 0, 49)
	corner(menu)
	stroke(menu)
	padding(menu, 14)
	local menuLayout = make("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, menu)
	setCanvasHeight(menu, menuLayout, 4)
	local dropdown = { Value = selected, Frame = holder }
	dropdown.Validate = function(_, value)
		return table.find(choices, value) ~= nil
	end
	local function setExpanded(state)
		if state and #choices == 0 then
			return
		end
		expanded = state
		chevron.Text = expanded and "⌃" or "⌄"
		if expanded then
			menu.Visible = true
			menu.Size = UDim2.new(1, 0, 0, 0)
			local visibleChoices = math.min(#choices, maxVisible)
			local menuHeight = visibleChoices * 36 + 28
			tween(holder, Theme.Animation.Fade.Time, {
				Size = UDim2.new(1, 0, 0, 52 + menuHeight),
			})
			tween(menu, Theme.Animation.Fade.Time, {
				Size = UDim2.new(1, 0, 0, menuHeight),
			})
		else
			tween(holder, Theme.Animation.Fade.Time, { Size = UDim2.new(1, 0, 0, 44) })
			local closeAnimation = tween(menu, Theme.Animation.Fade.Time, { Size = UDim2.new(1, 0, 0, 0) })
			closeAnimation.Completed:Once(function()
				if not expanded then
					menu.Visible = false
				end
			end)
		end
	end
	local function setValue(nextValue, fireCallback)
		assert(dropdown:Validate(nextValue), "Dropdown value must be included in Options")
		selected = nextValue
		dropdown.Value = nextValue
		head.Text = options.Name .. "   ·   " .. tostring(nextValue)
		setExpanded(false)
		if fireCallback ~= false then safeCallback(self._window._library, options.Callback, nextValue) end
	end
	dropdown.Set = function(_, nextValue, fireCallback)
		setValue(nextValue, fireCallback)
	end
	for _, choice in ipairs(choices) do
		local choiceButton = button(menu, tostring(choice), UDim2.new(1, 0, 0, 32), COLORS.Interactive)
		choiceButton.TextXAlignment = Enum.TextXAlignment.Left
		padding(choiceButton, 12, 0)
		choiceButton.MouseButton1Click:Connect(function() setValue(choice) end)
	end
	head.MouseButton1Click:Connect(function() setExpanded(not expanded) end)
	self:_register(holder, options.Name .. " " .. table.concat((function()
		local strings = {}
		for _, option in ipairs(choices) do table.insert(strings, tostring(option)) end
		return strings
	end)(), " "))
	self:_registerSetting(options, dropdown)
	return dropdown
end

function Section:Keybind(options)
	assert(type(options) == "table" and type(options.Name) == "string", "Keybind requires a Name")
	local key = options.Default or Enum.KeyCode.Unknown
	assert(typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode, "Keybind Default must be an Enum.KeyCode")
	local listening = false
	local row = make("Frame", {
		BackgroundColor3 = COLORS.Container,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 48),
	}, self._frame)
	corner(row, 12)
	Elements.Gradient(row, COLORS.Container, Color3.fromRGB(36, 36, 39), 90)
	local label = textLabel(row, options.Name, Theme.Font.Body, COLORS.Text, Enum.Font.GothamMedium)
	label.Position = UDim2.fromOffset(20, 0)
	label.Size = UDim2.new(1, -CONTROL_RIGHT_INSET - 68 - 20, 1, 0)
	local keyButton = button(row, key.Name, UDim2.fromOffset(68, 30), COLORS.SurfaceAlt)
	keyButton.AnchorPoint = Vector2.new(1, 0.5)
	keyButton.Position = UDim2.new(1, -CONTROL_RIGHT_INSET, 0.5, 0)
	Elements.Gradient(keyButton, COLORS.SurfaceAlt, Color3.fromRGB(32, 32, 35), 90)
	local keyCorner = keyButton:FindFirstChildOfClass("UICorner")
	if keyCorner then keyCorner.CornerRadius = UDim.new(0, 12) end
	local keybind = { Value = key, Frame = row }
	local function setKey(nextKey, fireCallback)
		assert(typeof(nextKey) == "EnumItem" and nextKey.EnumType == Enum.KeyCode, "Keybind value must be an Enum.KeyCode")
		key = nextKey
		keybind.Value = key
		keyButton.Text = key.Name
		if fireCallback ~= false then safeCallback(self._window._library, options.Changed, key) end
	end
	keybind.Set = function(_, nextKey, fireCallback)
		setKey(nextKey, fireCallback)
	end
	keyButton.MouseButton1Click:Connect(function()
		listening = true
		keyButton.Text = "..."
	end)
	local connection = UserInputService.InputBegan:Connect(function(input, processed)
		if listening then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				listening = false
				setKey(input.KeyCode)
			end
			return
		end
		if not processed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key and key ~= Enum.KeyCode.Unknown then
			safeCallback(self._window._library, options.Callback, key)
		end
	end)
	table.insert(self._window._connections, connection)
	self:_register(row, options.Name .. " " .. key.Name)
	self:_registerSetting(options, keybind)
	return keybind
end

function Section:Input(options)
	assert(type(options) == "table" and type(options.Name) == "string", "Input requires a Name")
	local multiline = options.Multiline == true
	local row = make("Frame", {
		BackgroundColor3 = COLORS.Container,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, multiline and 104 or 76),
	}, self._frame)
	corner(row, 12)
	local label = textLabel(row, options.Name, Theme.Font.Label, COLORS.Text, Enum.Font.GothamMedium)
	label.Position = UDim2.fromOffset(20, 2)
	label.Size = UDim2.new(1, -40, 0, 25)
	local field = make("TextBox", {
		BackgroundColor3 = COLORS.SurfaceAlt,
		ClearTextOnFocus = false,
		Font = Enum.Font.Gotham,
		MultiLine = multiline,
		PlaceholderColor3 = COLORS.Muted,
		PlaceholderText = options.Placeholder or "Type here...",
		Position = UDim2.new(0, 20, 0, 31),
		Size = UDim2.new(1, -40, 0, multiline and 58 or 30),
		Text = options.Default or "",
		TextColor3 = COLORS.Text,
		TextSize = Theme.Font.Body,
		TextWrapped = multiline,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
		Name = tostring(options.Name) .. " input",
	}, row)
	corner(field, 10)
	local fieldStroke = stroke(field)
	padding(field, 8, 0)
	field.Focused:Connect(function()
		tween(fieldStroke, Theme.HoverDuration, {
			Color = COLORS.Primary,
			Transparency = 0.1,
		})
	end)
	field.FocusLost:Connect(function()
		tween(fieldStroke, Theme.HoverDuration, {
			Color = Theme.Stroke.Color,
			Transparency = Theme.Stroke.Transparency,
		})
	end)
	field.FocusLost:Connect(function(enterPressed)
		safeCallback(self._window._library, options.Callback, field.Text, enterPressed)
	end)
	local input = { Value = field.Text, Frame = row, TextBox = field }
	field:GetPropertyChangedSignal("Text"):Connect(function()
		input.Value = field.Text
		if multiline then
			local availableWidth = math.max(field.AbsoluteSize.X - 16, 1)
			local measured = TextService:GetTextSize(field.Text, field.TextSize, field.Font, Vector2.new(availableWidth, 1000))
			local height = math.clamp(measured.Y + 16, 54, 240)
			field.Size = UDim2.new(1, -40, 0, height)
			row.Size = UDim2.new(1, 0, 0, height + 36)
		end
	end)
	input.Set = function(_, value, fireCallback)
		assert(type(value) == "string", "Input value must be a string")
		field.Text = value
		if fireCallback ~= false then
			safeCallback(self._window._library, options.Callback, value, false)
		end
	end
	self:_register(row, options.Name .. " " .. (options.Placeholder or ""))
	self:_registerSetting(options, input)
	return input
end

function Section:ColorPicker(options)
	assert(type(options) == "table" and type(options.Name) == "string", "ColorPicker requires a Name")
	local color = options.Default or COLORS.Accent
	local hue, saturation, brightness = color:ToHSV()
	local expanded = false
	local holder = make("Frame", {
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 0, 44),
	}, self._frame)
	local head = button(holder, options.Name, UDim2.new(1, 0, 0, 44))
	head.TextXAlignment = Enum.TextXAlignment.Left
	padding(head, 29, 0)
	local preview = make("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(22, 18),
	}, head)
	corner(preview)
	stroke(preview)
	local picker = make("Frame", {
		BackgroundColor3 = COLORS.Background,
		BackgroundTransparency = 0.04,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.new(0, 0, 0, 49),
		Size = UDim2.new(1, 0, 0, 124),
		Visible = false,
	}, holder)
	corner(picker)
	stroke(picker)
	padding(picker, 14)
	local saturationCanvas = make("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.new(1, -26, 1, -16),
		Text = "",
	}, picker)
	corner(saturationCanvas)
	stroke(saturationCanvas)
	local whiteOverlay = make("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, saturationCanvas)
	corner(whiteOverlay)
	make("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Rotation = 0,
	}, whiteOverlay)
	local blackOverlay = make("Frame", {
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, saturationCanvas)
	corner(blackOverlay)
	make("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Rotation = 90,
	}, blackOverlay)
	local selector = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(saturation, 1 - brightness),
		Size = UDim2.fromOffset(10, 10),
	}, saturationCanvas)
	corner(selector)
	stroke(selector)
	local hueBar = make("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Position = UDim2.new(1, -18, 0, 0),
		Size = UDim2.new(0, 10, 1, -16),
		Text = "",
	}, picker)
	corner(hueBar)
	stroke(hueBar)
	make("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
		}),
		Rotation = 90,
	}, hueBar)
	local hueMarker = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, hue, 0),
		Size = UDim2.new(1, 4, 0, 3),
	}, hueBar)
	corner(hueMarker)
	local colorPicker = { Value = color, Frame = holder }
	local function setColor(nextColor, fireCallback)
		color = nextColor
		hue, saturation, brightness = color:ToHSV()
		colorPicker.Value = color
		preview.BackgroundColor3 = color
		saturationCanvas.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		selector.Position = UDim2.fromScale(saturation, 1 - brightness)
		hueMarker.Position = UDim2.new(0.5, 0, hue, 0)
		if fireCallback ~= false then safeCallback(self._window._library, options.Callback, color) end
	end
	colorPicker.Set = function(_, nextColor, fireCallback)
		assert(typeof(nextColor) == "Color3", "ColorPicker value must be a Color3")
		setColor(nextColor, fireCallback)
	end
	local satDragging = false
	local hueDragging = false
	local function setSaturationAt(input)
		local position = saturationCanvas.AbsolutePosition
		local size = saturationCanvas.AbsoluteSize
		saturation = math.clamp((input.Position.X - position.X) / math.max(size.X, 1), 0, 1)
		brightness = 1 - math.clamp((input.Position.Y - position.Y) / math.max(size.Y, 1), 0, 1)
		setColor(Color3.fromHSV(hue, saturation, brightness))
	end
	local function setHueAt(input)
		local position = hueBar.AbsolutePosition
		hue = math.clamp((input.Position.Y - position.Y) / math.max(hueBar.AbsoluteSize.Y, 1), 0, 1)
		setColor(Color3.fromHSV(hue, saturation, brightness))
	end
	saturationCanvas.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			satDragging = true
			setSaturationAt(input)
		end
	end)
	hueBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			hueDragging = true
			setHueAt(input)
		end
	end)
	local inputChanged = UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if satDragging then setSaturationAt(input) elseif hueDragging then setHueAt(input) end
		end
	end)
	local inputEnded = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			satDragging = false
			hueDragging = false
		end
	end)
	table.insert(self._window._connections, inputChanged)
	table.insert(self._window._connections, inputEnded)
	head.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			picker.Visible = true
			picker.Size = UDim2.new(1, 0, 0, 0)
			tween(holder, Theme.Animation.Fade.Time, { Size = UDim2.new(1, 0, 0, 183) })
			tween(picker, Theme.Animation.Fade.Time, { Size = UDim2.new(1, 0, 0, 124) })
		else
			tween(holder, Theme.Animation.Fade.Time, { Size = UDim2.new(1, 0, 0, 44) })
			local closeAnimation = tween(picker, Theme.Animation.Fade.Time, { Size = UDim2.new(1, 0, 0, 0) })
			closeAnimation.Completed:Once(function()
				if not expanded then
					picker.Visible = false
				end
			end)
		end
	end)
	setColor(color, false)
	self:_register(holder, options.Name)
	self:_registerSetting(options, colorPicker)
	return colorPicker
end

function Window:Notify(options)
	return self._library:Notify(options)
end

function Window:SetVisible(visible)
	assert(not self._library._destroyed, "Cannot change visibility after the library has been destroyed")
	visible = visible == true
	self._visible = visible
	self.Root.Visible = visible
	self._outline.Visible = visible
	if visible then
		self._scale.Scale = 1
		self.Root.BackgroundTransparency = 0
		self._stroke.Transparency = 0.48
	end
end

local function validateConfigName(name)
	if type(name) ~= "string" then
		return false, "config name must be text."
	end
	name = string.match(name, "^%s*(.-)%s*$")
	if name == "" then
		return false, "enter a config name first."
	end
	if #name > 40 then
		return false, "config names must be 40 characters or fewer."
	end
	if string.find(name, "[^%w _%-]") then
		return false, "use only letters, numbers, spaces, underscores, and hyphens."
	end
	return true, name
end

function Window:SaveConfig(name)
	local library = self._library
	if not library._configurationSaving.Enabled then
		return false, "configuration saving is disabled."
	end
	local valid, normalizedName = validateConfigName(name)
	if not valid then
		return false, normalizedName
	end
	local store = library._configurationSaving.Store
	local values = {}
	for flag, setting in pairs(library._settings) do
		local value = setting.Control.Value
		if value ~= nil then
			values[flag] = encodeConfigValue(value)
		end
	end
	local ok, result, message = pcall(store.Save, normalizedName, values)
	if not ok then
		warn("[Havoc Lib] Config save failed:", result)
		return false, "config save failed; see the developer console."
	end
	if result ~= true then
		return false, tostring(message or "config store must return true after saving.")
	end
	return true
end

function Window:CreateConfig(name)
	return self:SaveConfig(name)
end

function Window:LoadConfig(name)
	local library = self._library
	if not library._configurationSaving.Enabled then
		return false, "configuration saving is disabled."
	end
	local valid, normalizedName = validateConfigName(name)
	if not valid then
		return false, normalizedName
	end
	local store = library._configurationSaving.Store
	local ok, values, message = pcall(store.Load, normalizedName)
	if not ok then
		warn("[Havoc Lib] Config load failed:", values)
		return false, "config load failed; see the developer console."
	end
	if type(values) ~= "table" then
		return false, tostring(message or "config was not found or returned invalid data.")
	end

	local pending = {}
	for flag, value in pairs(values) do
		local setting = library._settings[flag]
		if setting then
			local decodeOk, decoded = pcall(decodeConfigValue, value, setting.ValueType)
			if not decodeOk then
				warn("[Havoc Lib] Invalid value for config flag " .. tostring(flag) .. ":", decoded)
				return false, "config contains an invalid setting; no values were applied."
			end
			local validate = setting.Control.Validate
			if validate then
				local validationOk, isValid = pcall(validate, setting.Control, decoded)
				if not validationOk or isValid ~= true then
					warn("[Havoc Lib] Invalid value for config flag " .. tostring(flag))
					return false, "config contains an invalid setting; no values were applied."
				end
			end
			table.insert(pending, { Control = setting.Control, Value = decoded })
		else
			warn("[Havoc Lib] Ignoring unknown config flag:", flag)
		end
	end
	for _, item in ipairs(pending) do
		item.Control:Set(item.Value)
	end
	return true
end

function Window:ListConfigs()
	if not self._library._configurationSaving.Enabled then
		return false, nil, "configuration saving is disabled."
	end
	local store = self._library._configurationSaving.Store
	if type(store.List) ~= "function" then
		return false, nil, "config listing is not supported by the configured store."
	end
	local ok, names, message = pcall(store.List)
	if not ok then
		warn("[Havoc Lib] Config listing failed:", names)
		return false, nil, "config listing failed; see the developer console."
	end
	if type(names) ~= "table" then
		return false, nil, tostring(message or "config store returned an invalid list.")
	end
	local result = {}
	for _, name in ipairs(names) do
		if type(name) == "string" then
			table.insert(result, name)
		end
	end
	table.sort(result, function(a, b)
		return string.lower(a) < string.lower(b)
	end)
	return true, result
end

function Window:DeleteConfig(name)
	if not self._library._configurationSaving.Enabled then
		return false, "configuration saving is disabled."
	end
	local valid, normalizedName = validateConfigName(name)
	if not valid then
		return false, normalizedName
	end
	local store = self._library._configurationSaving.Store
	if type(store.Delete) ~= "function" then
		return false, "config deletion is not supported by the configured store."
	end
	local ok, result, message = pcall(store.Delete, normalizedName)
	if not ok then
		warn("[Havoc Lib] Config delete failed:", result)
		return false, "config deletion failed; see the developer console."
	end
	if result ~= true then
		return false, tostring(message or "config store must return true after deleting.")
	end
	return true
end

function Window:_CreateConfigManager(options)
	local tab = self:Tab({
		Name = options.TabName or "configs",
		Icon = options.Icon or "bookmark",
	})
	local section = tab:Section({
		Name = options.SectionName or "configuration manager",
		Icon = "settings",
	})
	local nameInput = section:Input({
		Name = "config name",
		Placeholder = "enter a name",
		Default = options.DefaultConfig or "",
	})
	local function report(success, message, action)
		self:Notify({
			Title = success and "config " .. action or "config error",
			Content = success and (action .. " completed.") or tostring(message or "operation failed."),
			Duration = 4,
		})
	end
	local buttons = {
		{
			Name = "create / save",
			Callback = function()
				local success, message = self:CreateConfig(nameInput.Value)
				report(success, message, "saved")
			end,
		},
		{
			Name = "load",
			Callback = function()
				local success, message = self:LoadConfig(nameInput.Value)
				report(success, message, "loaded")
			end,
		},
	}
	if type(options.Store.List) == "function" then
		table.insert(buttons, {
			Name = "list",
			Callback = function()
				local success, names, message = self:ListConfigs()
				if not success then
					report(false, message, "listed")
					return
				end
				local listContent
				if #names == 0 then
					listContent = "no configs saved."
				else
					listContent = table.concat(names, ", ")
				end
				self:Notify({
					Title = "saved configs",
					Content = listContent,
					Duration = 6,
				})
			end,
		})
	end
	if type(options.Store.Delete) == "function" then
		table.insert(buttons, {
			Name = "delete",
			Callback = function()
				local success, message = self:DeleteConfig(nameInput.Value)
				report(success, message, "deleted")
			end,
		})
	end
	section:Buttons({ Buttons = buttons, Height = 34, Gap = 6 })
end

function HavocLib:Notify(options)
	assert(type(options) == "table", "Notify requires an options table")
	assert(not self._destroyed, "Cannot notify after the library has been destroyed")
	local title = options.Title or "notification"
	local content = options.Content or ""
	local requestedDuration = tonumber(options.Duration) or 4
	assert(isFiniteNumber(requestedDuration), "Notification Duration must be a finite number")
	local duration = math.max(requestedDuration, 0.5)
	local host = self._notificationHost
	if not host then
		host = make("Frame", {
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 1, -15),
			Size = UDim2.new(0, 310, 0, 190),
		}, self.ScreenGui)
		self._notificationHost = host
		make("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
		}, host)
	end
	local wrapper = make("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 0, 76),
	}, host)
	local toast = make("Frame", {
		BackgroundColor3 = COLORS.Container,
		BackgroundTransparency = Theme.PanelTransparency,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 20, 0, 0),
		Size = UDim2.fromScale(1, 1),
	}, wrapper)
	corner(toast)
	stroke(toast)
	local accent = make("Frame", {
		BackgroundColor3 = options.Color or COLORS.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 3, 1, 0),
	}, toast)
	corner(accent)
	stroke(accent)
	local toastTitle = textLabel(toast, tostring(title), 13, COLORS.Text, Enum.Font.GothamBold)
	toastTitle.Position = UDim2.fromOffset(13, 9)
	toastTitle.Size = UDim2.new(1, -24, 0, 20)
	local toastContent = textLabel(toast, tostring(content), 11, COLORS.Muted)
	toastContent.Position = UDim2.fromOffset(13, 30)
	toastContent.Size = UDim2.new(1, -24, 0, 30)
	toastContent.TextWrapped = true
	toastContent.TextYAlignment = Enum.TextYAlignment.Top
	local progress = make("Frame", {
		BackgroundColor3 = options.Color or COLORS.Accent,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -3),
		Size = UDim2.new(1, 0, 0, 3),
	}, toast)
	corner(progress)
	stroke(progress)
	tween(toast, 0.22, { Position = UDim2.fromScale(0, 0) }, Enum.EasingStyle.Quint)
	tween(progress, duration, { Size = UDim2.new(0, 0, 0, 3) }, Enum.EasingStyle.Linear)
	task.delay(duration, function()
		if toast.Parent then
			tween(toast, 0.18, { BackgroundTransparency = 1, Position = UDim2.new(1, 20, 0, 0) })
			for _, child in ipairs(toast:GetDescendants()) do
				if child:IsA("TextLabel") then tween(child, 0.16, { TextTransparency = 1 }) end
				if child:IsA("Frame") then tween(child, 0.16, { BackgroundTransparency = 1 }) end
				if child:IsA("UIStroke") then tween(child, 0.16, { Transparency = 1 }) end
			end
			task.delay(0.2, function()
				if wrapper.Parent then wrapper:Destroy() end
			end)
		end
	end)
	table.insert(self._notifications, wrapper)
	return toast
end

function Window:Destroy()
	self._library:Destroy()
end

function HavocLib:Destroy()
	if self._destroyed then return end
	self._destroyed = true
	for _, connection in ipairs(self.Window._connections) do
		connection:Disconnect()
	end
	table.clear(self.Window._connections)
	self.ScreenGui:Destroy()
	table.clear(self._notifications)
end

HavocLib.Colors = COLORS
HavocLib.Theme = Theme
HavocLib.Design = "Reference Edition | Multi-executor + Lucide"
HavocLib.LucideStarterNames = {}
for name in pairs(LucideStarterPositions) do table.insert(HavocLib.LucideStarterNames, name) end
table.sort(HavocLib.LucideStarterNames)
return HavocLib
