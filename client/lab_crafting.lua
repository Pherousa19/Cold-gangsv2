
local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent("cold-gangs:client:openedLabUI", function(labType)
    local recipes = GetRecipesForLab(labType)
    local menu = {
        {
            header = "Crafting: " .. labType:upper(),
            isMenuHeader = true
        }
    }
    for _, recipe in pairs(recipes) do
        table.insert(menu, {
            header = recipe.label,
            txt = "Requires: " .. table.concat(recipe.ingredients, ", "),
            params = {
                event = "cold-gangs:client:startCraft",
                args = {
                    lab = labType,
                    item = recipe.item
                }
            }
        })
    end
    exports['qb-menu']:openMenu(menu)
end)
RegisterNetEvent("cold-gangs:client:startCraft", function(data)
    TriggerServerEvent("cold-gangs:server:attemptCraft", data.lab, data.item)
end)
function GetRecipesForLab(labType)
    if labType == "meth" then
        return {
            {item = "meth_bag", label = "Meth Bag", ingredients = {"acetone", "pseudoephedrine"}}
        }
    elseif labType == "mdma" then
        return {
            {item = "mdma_pill", label = "MDMA Pill", ingredients = {"safrole", "reagent"}}
        }
    elseif labType == "lsd" then
        return {
            {item = "lsd_tab", label = "LSD Tab", ingredients = {"ergoline", "ethanol"}}
        }
    end
    return {}
end
