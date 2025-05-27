PM = {}

PM.ShowFishingBlips = true
PM.Fishingtime = 15 -- "5 seconds"
PM.FishingChance = 85 -- "80%"
PM.RodItem = "angel"
PM.SellSpot = {x = 0,0, y = 0,0, z = 0,0, heading = 90.0}


PM.Spots = {
    vector4(-1849.4810, -1251.1877, 8.6158, 138.5869),
    vector4(-1851.1206, -1249.7139, 8.6158, 142.0712),
    vector4(-1836.3143, -1261.2363, 8.6158, 141.0686),
    vector4(-1834.0311, -1263.4648, 8.6183, 177.5862),
    vector4(-1832.5475, -1264.9276, 8.6183, 206.3529),
    vector4(-1824.3158, -1268.0336, 8.6183, 218.4065),
    vector4(-1864.5313, -1236.3607, 8.6158, 38.1052),  ---- pier unten
    vector4(-3428.3618, 964.2980, 8.3467, 92.5806), --pier oben
    vector4(-3428.4255, 966.5887, 8.3467, 92.5665), 
    vector4(-3428.4319, 968.6041, 8.3467, 92.2130), 
    vector4(-3428.3975, 973.7929, 8.3467, 108.8773), 
    vector4(1340.7526, 4224.4683, 33.9155, 247.3658), 

}

PM.Items = {
    {
        ["item"] = "weapon_pistol",
        ["type"] = "weapon",
        ["amount"] = {1, 1},
        ["chance"] = 1, 
    },
    {
        ["item"] = "aal",
        ["type"] = "item",
        ["amount"] = {1, 2},
        ["chance"] = 25, 
    },
    {
        ["item"] = "karpfen",
        ["type"] = "item",
        ["amount"] = {1, 2},
        ["chance"] = 25, 
    },
    {
        ["item"] = "shark",
        ["type"] = "item",
        ["amount"] = {1, 1},
        ["chance"] = 10, 
    },
    {
        ["item"] = "lachs",
        ["type"] = "item",
        ["ammo"] = {1, 1},
        ["chance"] = 15, 
    },
    {
        ["item"] = "turtle",
        ["type"] = "item",
        ["amount"] = {1, 1},
        ["chance"] = 10, 
    },
    {
        ["item"] = "austern",
        ["type"] = "item",
        ["ammo"] =  {1, 1},
        ["chance"] = 15, 
    },
    {
        ["item"] = "butterfish",
        ["type"] = "item",
        ["ammo"] =  {1, 1},
        ["chance"] = 25, 
    },
    {
        ["item"] = "krabbe",
        ["type"] = "item",
        ["ammo"] =  {1, 1},
        ["chance"] = 15, 
    },
    {
        ["item"] = "shrimp",
        ["type"] = "item",
        ["ammo"] =  {1, 1},
        ["chance"] = 15, 
    }
}

function HelpNotify(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function Notify(msg)
    TriggerEvent('', 'Info', 'Angeln', msg, 5000)
end