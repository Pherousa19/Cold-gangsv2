
RegisterNetEvent("coldgangs:client:openGangTablet", function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        data = {
            gangName = "Red Reapers",
            logo = "img/redreapers.png",
            turfOwned = 4,
            influence = 78,
            xp = 2450,
            level = 3,
            members = {
                { name = "BigSmoke", rank = "Leader" },
                { name = "Shadow", rank = "Lieutenant" },
                { name = "Rico", rank = "Soldier" }
            },
            perks = {
                "Faster Drug Sales",
                "Increased Racketeering Income"
            }
        }
    })
end)

RegisterNUICallback("closeTablet", function(_, cb)
    SetNuiFocus(false, false)
    cb({})
end)