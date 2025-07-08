
local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent("cold-gangs:client:ApplyDrugEffect", function(drug)
    local ped = PlayerPedId()
    if drug == "weed" then
        AnimpostfxPlay("DrugsMichaelAliensFightIn", 0, true)
        SetTimecycleModifier("spectator5")
        StartScreenEffect("DrugsTrevorClownsFight", 0, true)
        ShakeGameplayCam("DRUNK_SHAKE", 0.75)
        Wait(30000)
    elseif drug == "coke" then
        AnimpostfxPlay("DrugsTrevorClownsFight", 0, true)
        ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.5)
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.15)
        Wait(25000)
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    elseif drug == "meth" then
        AnimpostfxPlay("DrugsMichaelAliensFight", 0, true)
        SetPedMoveRateOverride(ped, 1.2)
        SetTimecycleModifier("REDMIST_blend")
        Wait(25000)
        SetPedMoveRateOverride(ped, 1.0)
    elseif drug == "heroin" then
        AnimpostfxPlay("DrugsTrevorClownsFight", 0, true)
        SetTimecycleModifier("drug_drive_blend03")
        ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 0.5)
        Wait(30000)
    elseif drug == "lsd" then
        SetTimecycleModifier("scanline_cam_cheap")
        AnimpostfxPlay("DrugsTrevorClownsFight", 0, true)
        ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 0.8)
        Wait(30000)
    elseif drug == "shrooms" then
        SetTimecycleModifier("BarryFadeOut")
        AnimpostfxPlay("DrugsMichaelAliensFight", 0, true)
        Wait(30000)
    end
    AnimpostfxStopAll()
    ClearTimecycleModifier()
    StopAllScreenEffects()
end)
