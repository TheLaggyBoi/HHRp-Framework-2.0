

local authoriseID = ''


HHCore                             = nil
local JobNPC                    = 0
local JobCooldown               = {}
local NPCspawned                = false

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while not NPCspawned do
        JobNPC = math.random(1,#Config.JobNPC)
        TriggerClientEvent("t1ger_carthief:spawnNPC",-1,Config.JobNPC[JobNPC])
        NPCspawned = true
    end
end)

AddEventHandler('hhrp:playerLoaded', function(playerId)
    TriggerClientEvent("t1ger_carthief:spawnNPC",playerId,Config.JobNPC[JobNPC])
end)

-- Server Event to add player cooldown:
RegisterServerEvent("t1ger_carthief:addJobCooldown")
AddEventHandler("t1ger_carthief:addJobCooldown",function(source)
    table.insert(JobCooldown,{PlyIdentifier = GetPlayerIdentifier(source), time = (Config.CooldownTime * 60000)}) -- cooldown timer for doing missions
end)

-- thread for syncing the cooldown timer
Citizen.CreateThread(function() -- do not touch this thread function!
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(JobCooldown) do
            if v.time <= 0 then
                ResetJobCooldown(v.PlyIdentifier)
            else
                v.time = v.time - 1000
            end
        end
end
end)

-- Server Event for selecting risk grade:
RegisterServerEvent("t1ger_carthief:GetRiskGrade")
AddEventHandler("t1ger_carthief:GetRiskGrade", function(Grade, BuyPrice, MinCops, carArray)
    local xPlayer = HHCore.GetPlayerFromId(source)
    local itemLabel = HHCore.GetItemLabel(itemName)
    local paidForJob = false
    local JobVeh = nil

    -- Cops Check:
    local Players = HHCore.GetPlayers()
    local cops = 0
    for i = 1, #Players do
        local xPlayer = HHCore.GetPlayerFromId(Players[i])
        if xPlayer["job"]["name"] == Config.PoliceJobName then
            cops = cops + 1
        end
    end

    if cops >= MinCops then
        -- Payment Check:
        local dirtyCash = xPlayer.getAccount('bank').money
        local moneyCash = xPlayer.getMoney()
        if Config.DirtyCashForJob then
            if dirtyCash >= BuyPrice then
                xPlayer.removeAccountMoney('bank', BuyPrice)
                paidForJob = true
            end
        else
            if moneyCash >= BuyPrice then
                xPlayer.removeMoney(BuyPrice)
                paidForJob = true
            end
        end
        if not paidForJob then
            TriggerClientEvent("t1ger:ShowNotifyHHCore",source,_U('not_enough_money'))
        end
    else
        TriggerClientEvent("t1ger:ShowNotifyHHCore",source,_U('not_enough_police'))
    end

    if paidForJob then

        TriggerEvent("t1ger_carthief:addJobCooldown",source)

        local car = math.random(1,#carArray)
        JobVeh = carArray[car]

        if Grade == 1 then
            label = "Low"
        elseif Grade == 2 then
            label = "Medium"
        elseif Grade == 3 then
            label = "High"
        end

        TriggerClientEvent("t1ger_carthief:BrowseAvailableJobs",source, 0, Grade, JobVeh)
        TriggerClientEvent("t1ger:ShowNotifyHHCore",source,string.format(_U('paid_for_job', BuyPrice, label)))
    end
end)

-- Server Event for Job Reward:
RegisterServerEvent("t1ger_carthief:JobComplete")
AddEventHandler("t1ger_carthief:JobComplete",function(reward,percent)
    local xPlayer = HHCore.GetPlayerFromId(source)
    local JobReward = math.floor(reward*(percent/100))
    if Config.ReceiveDirtyCash then
        xPlayer.addAccountMoney('bank', JobReward)
    else
        xPlayer.addMoney(JobReward)
    end
    TriggerClientEvent("t1ger:ShowNotifyHHCore",source,string.format(_U('reward_msg', JobReward)))
end)


-- Callback to get cooldown timer:
HHCore.RegisterServerCallback("t1ger_carthief:getJobCooldown",function(source,cb)
    local _source = source
    local xPlayer = HHCore.GetPlayerFromId(_source)
    if not CheckJobCooldown(GetPlayerIdentifier(source)) then
        cb(false)
    else
        TriggerClientEvent("t1ger:ShowNotifyHHCore",source,string.format(_U('cooldown_msg', GetJobCooldown(GetPlayerIdentifier(source)))))
        cb(true)
    end
end)

RegisterServerEvent('t1ger_carthief:OutlawNotifySV')
AddEventHandler('t1ger_carthief:OutlawNotifySV', function(targetCoords, streetName)
    TriggerClientEvent('t1ger_carthief:OutlawNotifyCL', -1,string.format(_U('police_notify', streetName)))
    TriggerClientEvent('t1ger_carthief:OutlawNotifyBlip', -1, targetCoords)
end)

RegisterServerEvent("t1ger_carthief:syncJobsData")
AddEventHandler("t1ger_carthief:syncJobsData",function(data)
    TriggerClientEvent("t1ger_carthief:syncJobsData",-1,data)
end)

-- Functions for Job Cooldown:
function ResetJobCooldown(source)
    for k,v in pairs(JobCooldown) do
        if v.PlyIdentifier == source then
            table.remove(JobCooldown,k)
        end
    end
end
function GetJobCooldown(source)
    for k,v in pairs(JobCooldown) do
        if v.PlyIdentifier == source then
            return math.ceil(v.time/60000)
        end
    end
end
function CheckJobCooldown(source)
    for k,v in pairs(JobCooldown) do
        if v.PlyIdentifier == source then
            return true
        end
    end
    return false
end

