Config = Config or {}
ColdGangs = ColdGangs or {}

ColdGangs.WeaponCrafting = {}

function ColdGangs:OpenWeaponCraftingMenu()
    if not self.CurrentGang then return end
    
    local craftingOptions = {}
    
    for _, recipe in pairs(Config.WeaponRecipes) do
        local canCraft = true
        local materials = {}
        
        -- Check materials
        for _, mat in pairs(recipe.materials) do
            local hasAmount = self:GetItemCount(mat.item)
            table.insert(materials, string.format('%s (%d/%d)', mat.item, hasAmount, mat.amount))
            
            if hasAmount < mat.amount then
                canCraft = false
            end
        end
        
        -- Check perk requirement
        if recipe.requiredPerk and not self.CurrentGang.perks[recipe.requiredPerk] then
            canCraft = false
        end
        
        table.insert(craftingOptions, {
            title = recipe.label,
            description = table.concat(materials, ', '),
            icon = 'hammer',
            disabled = not canCraft,
            onSelect = function()
                self:CraftWeapon(recipe)
            end
        })
    end
    
    lib.registerContext({
        id = 'weapon_crafting',
        title = 'Weapon Crafting',
        options = craftingOptions
    })
    
    lib.showContext('weapon_crafting')
end

function ColdGangs:CraftWeapon(recipe)
    local ped = PlayerPedId()
    
    -- Animation
    RequestAnimDict('mini@repair')
    while not HasAnimDictLoaded('mini@repair') do Wait(10) end
    
    TaskPlayAnim(ped, 'mini@repair', 'fixing_a_player', 8.0, -8.0, recipe.time * 1000, 1, 0, false, false, false)
    
    local success = lib.progressBar({
        duration = recipe.time * 1000,
        label = 'Crafting ' .. recipe.label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    })
    
    ClearPedTasks(ped)
    
    if success then
        TriggerServerEvent('cold-gangs:server:craftWeapon', recipe.weapon)
    end
end