local ESX = exports['es_extended']:getSharedObject()

-- Prüfe, ob der Spieler eine Angel hat
ESX.RegisterServerCallback("PM_fishing:rodCheck", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(false) end

    local xItem = xPlayer.getInventoryItem('angel')
    cb(xItem and xItem.count > 0)
end)

-- Spieler fängt zufälligen Fisch
RegisterNetEvent("PM_fishing:catchRandom", function(fishingId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not fishingId then return end

    local spot = PM.Spots[fishingId]
    if not spot then return end

    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)
    local spotCoords = vector3(spot.x, spot.y, spot.z)

    if #(pedCoords - spotCoords) > 2.0 then return end

    if math.random(1, 100) > PM.FishingChance then
        return TriggerClientEvent("esx:showNotification", src, "Du hast nichts geangelt")
    end

    local item = GetRandomItem(PM.Items)
    if not item then return end

    if item.type == "item" then
        local amount = 1
        if type(item.amount) == "table" then
            amount = math.random(item.amount[1], item.amount[2])
        elseif type(item.amount) == "number" then
            amount = item.amount
        end

        xPlayer.addInventoryItem(item.item, amount)
        local label = xPlayer.getInventoryItem(item.item).label or item.item
        TriggerClientEvent("esx:showNotification", src, ("Du hast %sx %s gefangen"):format(amount, label))

    elseif item.type == "weapon" then
        if not xPlayer.hasWeapon(item.item) then
            xPlayer.addWeapon(item.item:upper(), item.ammo or 250)
            TriggerClientEvent("esx:showNotification", src, ("Du hast 1x %s gefangen"):format(item.item:upper()))
        else
            TriggerClientEvent("esx:showNotification", src, "Du hast nichts geangelt")
        end
    end
end)

RegisterServerEvent("PM_fishing:sellFish")
AddEventHandler("PM_fishing:sellFish", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local total = 0

    for _, item in pairs({"fish1", "fish2", "fish3"}) do
        local count = xPlayer.getInventoryItem(item).count
        if count > 0 then
            local price = 10 -- Preis pro Fisch
            xPlayer.removeInventoryItem(item, count)
            total = total + (count * price)
        end
    end

    if total > 0 then
        xPlayer.addMoney(total)
        TriggerClientEvent("PM_fishing:Notify", source, "Du hast deine Fische für $" .. total .. " verkauft.")
    else
        TriggerClientEvent("PM_fishing:Notify", source, "Du hast keine Fische zum Verkaufen.")
    end
end)


-- Funktion um ein zufälliges Item basierend auf Wahrscheinlichkeit zu wählen
function GetRandomItem(items)
    local totalChance = 0
    for _, v in ipairs(items) do
        totalChance = totalChance + (v.chance or 0)
    end

    local pick = math.random(1, totalChance)
    local current = 0

    for _, v in ipairs(items) do
        current = current + (v.chance or 0)
        if pick <= current then
            return v
        end
    end

    return nil
end
