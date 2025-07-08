
local QBCore = exports['qb-core']:GetCoreObject()
local labs = {
    {name = "meth", coords = vector3(1001.0, -3200.0, -38.99), xpRequired = 100},
    {name = "mdma", coords = vector3(1093.6, -3196.6, -38.99), xpRequired = 200},
    {name = "lsd", coords = vector3(1012.2, -3194.5, -38.99), xpRequired = 300}
}
CreateThread(function()
    for _, lab in pairs(labs) do
        local labCoords = lab.coords
        exports['qb-target']:AddBoxZone("lab_"..lab.name, labCoords, 2.5, 2.5, {
            name = "lab_"..lab.name,
            heading = 0,
            debugPoly = false,
            minZ = labCoords.z - 1.0,
            maxZ = labCoords.z + 1.0
        }, {
            options = {
                {
                    icon = "fas fa-vials",
                    label = "Enter "..lab.name:upper().." Lab",
                    action = function()
                        QBCore.Functions.TriggerCallback("cold-gangs:server:getGangXP", function(xp)
                            if xp >= lab.xpRequired then
                                DoScreenFadeOut(1000)
                                Wait(1200)
                                SetEntityCoords(PlayerPedId(), labCoords)
                                TriggerEvent("cold-gangs:client:openedLabUI", lab.name)
                                DoScreenFadeIn(1000)
                            else
                                QBCore.Functions.Notify("You need more XP to access this lab", "error")
                            end
                        end)
                    end
                }
            },
            distance = 2.5
        })
    end
end)
