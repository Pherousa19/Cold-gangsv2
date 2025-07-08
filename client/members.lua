RegisterNUICallback("fetchMembers", function(_, cb)
    QBCore.Functions.TriggerCallback("ColdGangs:GetMembers", function(data)
        SendNUIMessage({
            action = "renderMembers",
            html = CreateMembersHTML(data)
        })
        cb("ok")
    end)
end)

function CreateMembersHTML(data)
    if not data or #data == 0 then
        return "<p>No gang members found.</p>"
    end

    local html = "<table class='gang-table'><thead><tr><th>Name</th><th>Identifier</th><th>Rank</th><th>Last Active</th></tr></thead><tbody>"
    for _, v in ipairs(data) do
        local name = v.charinfo and json.decode(v.charinfo).firstname .. " " .. json.decode(v.charinfo).lastname or "Unknown"
        html = html .. string.format("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
            name,
            v.identifier,
            v.rank or 1,
            v.last_active or "N/A"
        )
    end
    html = html .. "</tbody></table>"
    return html
end