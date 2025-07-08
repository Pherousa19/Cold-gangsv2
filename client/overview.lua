RegisterNUICallback("fetchOverview", function(_, cb)
    QBCore.Functions.TriggerCallback("ColdGangs:GetOverview", function(data)
        SendNUIMessage({
            action = "renderOverview",
            html = CreateOverviewHTML(data)
        })
        cb("ok")
    end)
end)

function CreateOverviewHTML(data)
    if not data then
        return "<p>You are not in a gang.</p>"
    end

    local html = string.format([[
        <div class="overview-block">
            <h2 style="color:%s">%s</h2>
            <p><strong>Reputation:</strong> %s XP</p>
            <p><strong>Bank:</strong> £%s</p>
            <p><strong>Turf Controlled:</strong> %s zones</p>
            <p><strong>Hourly Income:</strong> £%s</p>
            <p><strong>Upgrades:</strong> %s</p>
        </div>
    ]],
    data.color or "#fff",
    data.name or "Unnamed Gang",
    data.rep or 0,
    data.bank or 0,
    data.turf_count or 0,
    data.income or 0,
    data.upgrades and ("Drug: L" .. (data.upgrades.drug or 0) .. ", Defense: L" .. (data.upgrades.defense or 0)) or "None")

    return html
end