HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj)
    HHCore = obj
end)

HHCore.RegisterServerCallback("disc-drugsales:sellDrug", function(source, cb)
    local player = HHCore.GetPlayerFromId(source)

    if player then
        math.randomseed(os.time())
        local randomPayment = math.random(item.priceMin, item.priceMax)
        local randomCount = math.random(item.sellCountMin, item.sellCountMax)
        local count = randomCount

        player.addMoney(randomPayment * count)

        cb(randomPayment * count)
    else
        cb(false)
    end
end)
HHCore.RegisterServerCallback("disc-drugsales:sellDrugcoke", function(source, cb)
    local player = HHCore.GetPlayerFromId(source)

    if player then
        math.randomseed(os.time())
        local randomPayment = 450

        local randomCount = 1
        local count = randomCount
        player.addMoney(randomPayment * count)
        cb(randomPayment * count)
    else
        cb(false)
    end
end)
HHCore.RegisterServerCallback("disc-drugsales:sellDrugmarijuana", function(source, cb)
    local player = HHCore.GetPlayerFromId(source)

    if player then
        math.randomseed(os.time())
        local randomPayment = 250
        local randomCount = 1
        local count = randomCount

        player.addMoney(randomPayment * count)

        cb(randomPayment * count)
    else
        cb(false)
    end
end)
HHCore.RegisterServerCallback("disc-drugsales:sellDrugoxy", function(source, cb)
    local player = HHCore.GetPlayerFromId(source)

    if player then
        math.randomseed(os.time())
        local randomPayment = 1550
        local randomCount = 1
        local count = randomCount
        player.addMoney(randomPayment * count)

        cb(randomPayment * count)
    else
        cb(false)
    end
end)

-- DoPlayerHaveItems = function(player)
--     local item = false

--     for k, v in pairs(Config.DrugItems) do
--         local itemName = v.name
--         local itemInformation = player.getInventoryItem(itemName)

--         if itemInformation and itemInformation["count"] > 0 then
--             item = v

--             break
--         end
--     end

--     return item, item ~= false
-- end
-- DoPlayerHaveItemscoke = function(player)
--     local item = false

--     for k, v in pairs(Config.DrugItems) do
--         local itemName = 'coke'
--         local itemInformation = player.getInventoryItem(itemName)

--         if itemInformation and itemInformation["count"] > 0 then
--             item = itemName

--             break
--         end
--     end
--     return item, item ~= false
-- end
-- DoPlayerHaveItemsmarijuana = function(player)
--     local item = false

--     for k, v in pairs(Config.DrugItems) do
--         local itemName = 'marijuana'
--         local itemInformation = player.getInventoryItem(itemName)

--         if itemInformation and itemInformation["count"] > 0 then
--             item = itemName

--             break
--         end
--     end

--     return item, item ~= false
-- end
-- DoPlayerHaveItemsoxy = function(player)
--     local item = false

--     for k, v in pairs(Config.DrugItems) do
--         local itemName = 'oxy'
--         local itemInformation = player.getInventoryItem(itemName)

--         if itemInformation and itemInformation["count"] > 0 then
--             item = itemName

--             break
--         end
--     end

--     return item, item ~= false
-- end

-- HHCore.RegisterServerCallback('disc-drugsales:hasDrugs', function(source, cb)
--     local player = HHCore.GetPlayerFromId(source)
--     local item, hasItem = DoPlayerHaveItems(player)
--     cb(hasItem)
-- end)
-- HHCore.RegisterServerCallback('disc-drugsales:hasDrugscoke', function(source, cb)
--     local player = HHCore.GetPlayerFromId(source)
--     local item, hasItem = DoPlayerHaveItemscoke(player)
--     cb(hasItem)
-- end)
-- HHCore.RegisterServerCallback('disc-drugsales:hasDrugsmarijuana', function(source, cb)
--     local player = HHCore.GetPlayerFromId(source)
--     local item, hasItem = DoPlayerHaveItemsmarijuana(player)
--     cb(hasItem)
-- end)
-- HHCore.RegisterServerCallback('disc-drugsales:hasDrugsoxy', function(source, cb)
--     local player = HHCore.GetPlayerFromId(source)
--     local item, hasItem = DoPlayerHaveItemsmarijuana(player)
--     cb(hasItem)
-- end)

HHCore.RegisterServerCallback('disc-drugsales:getOnlinePolice', function(source, cb)
    local _source = source
    local xPlayers = HHCore.GetPlayers()
    local cops = 0

    for i = 1, #xPlayers, 1 do

        local xPlayer = HHCore.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end
    Wait(25)
    cb(cops)
end)