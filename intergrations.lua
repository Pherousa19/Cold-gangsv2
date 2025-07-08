Config = Config or {}
ColdGangs = ColdGangs or {}

ColdGangs.Integrations = {}

function ColdGangs:SendPhoneMessage(Player, gang, title, message, data)
    local phone = self.Config.Phone
    
    if phone == 'okokphone' then
        TriggerEvent('okokPhone:sendMessage', {
            from = gang,
            to = self:GetPlayerPhone(Player),
            message = message,
            time = os.date('%H:%M'),
            photo = data and data.photo or nil
        })
    elseif phone == 'lb-phone' then
        exports['lb-phone']:SendMessage({
            from = gang,
            to = self:GetPlayerIdentifier(Player),
            message = message,
            attachments = data and data.attachments or {}
        })
    elseif phone == 'qs-phone' then
        TriggerClientEvent('qs-phone:sendMessage', Player.source, {
            sender = gang,
            message = message,
            time = os.time()
        })
    elseif phone == 'qb-phone' then
        TriggerClientEvent('qb-phone:client:AddNewMessage', Player.source, {
            number = gang,
            message = message
        })
    end
end

function ColdGangs:SendDispatchAlert(alertType, coords, data)
    local dispatch = self.Config.Dispatch
    local alertConfig = self.Config.DispatchCodes[alertType]
    
    if not alertConfig then return end
    
    if dispatch == 'ps-dispatch' then
        exports['ps-dispatch']:SendDispatch(alertConfig.code, alertConfig.title, {
            coords = coords,
            priority = alertConfig.priority,
            jobs = alertConfig.jobs,
            data = data
        })
    elseif dispatch == 'qs-dispatch' then
        exports['qs-dispatch']:SendAlert({
            code = alertConfig.code,
            title = alertConfig.title,
            coords = coords,
            jobs = alertConfig.jobs,
            priority = alertConfig.priority
        })
    elseif dispatch == 'cd_dispatch' then
        TriggerClientEvent('cd_dispatch:SendAlert', -1, {
            code = alertConfig.code,
            title = alertConfig.title,
            coords = coords,
            jobs = alertConfig.jobs
        })
    elseif dispatch == 'origen-police' then
        exports['origen_police']:SendAlert({
            code = alertConfig.code,
            message = alertConfig.title,
            coords = coords,
            jobs = alertConfig.jobs,
            priority = alertConfig.priority
        })
    end
end

function ColdGangs:CreateGangGarage(gangName, coords)
    local garage = self.Config.Garage
    
    if garage == 'qb-garage' then
        exports['qb-garages']:AddGangGarage(gangName, coords)
    elseif garage == 'codem-garage' then
        exports['codem-garage']:CreateGarage({
            name = gangName .. '_garage',
            coords = coords,
            type = 'gang',
            gang = gangName
        })
    elseif garage == 'okokgarage' then
        exports['okokGarage']:AddGarage({
            garage = gangName .. '_garage',
            coords = coords,
            gang = gangName
        })
    elseif garage == 'qs-garage' then
        exports['qs-advancedgarages']:CreateGangGarage(gangName, coords)
    elseif garage == 'jg-garages' then
        exports['jg-advancedgarages']:CreateGarage({
            name = gangName .. '_garage',
            coords = coords,
            type = 'gang',
            job = gangName
        })
    end
end