local Fishing = false
local FishingId = nil

-- Initialisiere ESX
CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Wait(100)
    end
end)

-- Blips für Angelspots
CreateThread(function()
    for _, spot in pairs(PM.Spots) do
        local blip = AddBlipForCoord(spot.x, spot.y, spot.z)
        SetBlipSprite(blip, 68) -- Fisch-Symbol
        SetBlipColour(blip, 3) -- Hellblau
        SetBlipScale(blip, 0.8)
        SetBlipDisplay(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Angelspot")
        EndTextCommandSetBlipName(blip)
    end
end)

-- Interaktion mit Angelspot
CreateThread(function()
    while true do 
        local sleep = 500
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for k, spot in ipairs(PM.Spots) do
            local coords = vector3(spot.x, spot.y, spot.z)
            local dist = #(pedCoords - coords)

            if dist < 5 then
                sleep = 0

                if not Fishing then
                    DrawMarker(1, coords.x, coords.y, coords.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 51, 206, 255, 144, false, false, 2, false)
                end

                if dist < 0.5 then
                    if Fishing then
                        HelpNotify("Drücke ~INPUT_VEH_DUCK~ um das Angeln abzubrechen")
                    else
                        HelpNotify("Drücke ~INPUT_VEH_HORN~ um zu Angeln")
                    end

                    if IsControlJustPressed(0, 38) and not Fishing then
                        ESX.TriggerServerCallback("PM_fishing:rodCheck", function(hasRod)
                            if hasRod then
                                Fishing = true
                                FishingId = k
                                SetEntityHeading(ped, spot.w)
                                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, false)
                            else
                                Notify("Du hast keine Angel dabei")
                            end
                        end)

                    elseif IsControlJustPressed(0, 73) and Fishing then
                        StopFishing()
                    end
                end
            end
        end

        -- Spieler hat Spot verlassen
        if sleep == 500 and Fishing then
            StopFishing()
            Notify("Du hast den Angelspot verlassen, das Angeln wurde abgebrochen.")
        end

        Wait(sleep)
    end
end)

-- Fischverkäufer
local SellCoords = PM.SellSpot -- z.B. {x = -3250.0, y = 994.5, z = 12.5, heading = 90.0}

-- Verkauf-Marker + Interaktion
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        local dist = #(pedCoords - vector3(SellCoords.x, SellCoords.y, SellCoords.z))

        if dist < 5.0 then
            sleep = 0
            DrawMarker(1, SellCoords.x, SellCoords.y, SellCoords.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                1.0, 1.0, 1.0, 255, 153, 51, 144, false, false, 2, false)

            if dist < 1.5 then
                HelpNotify("Drücke ~INPUT_CONTEXT~ um deine Fische zu verkaufen")

                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("PM_fishing:sellFish")
                end
            end
        end

        Wait(sleep)
    end
end)

-- NPC beim Verkäufer
CreateThread(function()
    RequestModel("a_m_m_farmer_01")
    while not HasModelLoaded("a_m_m_farmer_01") do
        Wait(100)
    end

    local npc = CreatePed(4, "a_m_m_farmer_01", SellCoords.x, SellCoords.y, SellCoords.z - 1.0, SellCoords.heading, false, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end)



-- Fishing Loop (AFK-Farming)
CreateThread(function()
    while true do
        if Fishing then
            Wait(PM.Fishingtime * 1000)

            local ped = PlayerPedId()
            if not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and FishingId then
                TriggerServerEvent("PM_fishing:catchRandom", FishingId)
            end
        else
            Wait(1000)
        end
    end
end)

-- Stop-Funktion zentralisiert
function StopFishing()
    local ped = PlayerPedId()
    Fishing = false
    FishingId = nil
    ClearPedTasksImmediately(ped)
    SetCurrentPedWeapon(ped, "WEAPON_UNARMED", true)
end

-- Notify Wrapper
RegisterNetEvent("PM_fishing:Notify", function(message)
    Notify(message)
end)
