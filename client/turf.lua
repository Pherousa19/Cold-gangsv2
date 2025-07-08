
-- Phase 2B: Turf Presence Detection (client side)

local currentZone = nil
local inEnemyTurf = false
local captureTimer = 0
local captureCooldown = 0

CreateThread(function()
    while true do
        Wait(1500)

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local foundZone = nil

        for zoneId, data in pairs(Config.GangZones) do
            for _, box in pairs(data.parts) do
                local x1, y1, x2, y2 = box.x1 or box[1], box.y1 or box[2], box.x2 or box[3], box.y2 or box[4]
                local minX, maxX = math.min(x1, x2), math.max(x1, x2)
                local minY, maxY = math.min(y1, y2), math.max(y1, y2)

                if coords.x >= minX and coords.x <= maxX and coords.y >= minY and coords.y <= maxY then
                    foundZone = zoneId
                    break
                end
            end
            if foundZone then break end
        end

        -- Update presence
        if foundZone ~= currentZone then
            currentZone = foundZone
            captureTimer = 0
            inEnemyTurf = false
        end

        -- Try capture logic if in a zone
        if currentZone then
            TriggerServerEvent("cold-gangs:client:getGang", function(playerGang)
                local zoneOwner = exports["cold-gangs"]:GetZoneOwner(currentZone)

                if playerGang and zoneOwner and playerGang ~= zoneOwner then
                    inEnemyTurf = true
                else
                    inEnemyTurf = false
                end
            end)

            if inEnemyTurf and captureCooldown <= 0 then
                captureTimer = captureTimer + 1
                if captureTimer >= 10 then -- 10 * 1.5s = 15s
                    TriggerServerEvent("cold-gangs:server:startTurfCapture", currentZone)
                    captureCooldown = 300 -- cooldown ~7 mins
                    captureTimer = 0
                end
            end
        end

        if captureCooldown > 0 then captureCooldown = captureCooldown - 1 end
    end
end)
