Config = Config or {}
ColdGangs = ColdGangs or {}

Config.GangZones = {
    -- Example zone; replace with real data if needed
    ["grove"] = {
        label = "Grove Street",
        polyzone = {
            vector2(100.0, -100.0),
            vector2(150.0, -100.0),
            vector2(150.0, -50.0),
            vector2(100.0, -50.0)
        },
        color = { r = 255, g = 0, b = 0 },
        influence = 0
    }
}

ColdGangs.Zones = Config.GangZones
