--------------------------------
------- Created by Hamza -------
-------------------------------- 

HHCore 						= nil
local PlayerData            = nil
local MiningPos 			= {}
local WashingPos 			= {}
local SmeltingPos 			= {}
local keyPressed 			= false
local currentlyMining 		= false
local currentlyWashing 		= false
local currentlySmelting 	= false

Citizen.CreateThread(function()
	while HHCore == nil do
		TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)
		Citizen.Wait(0)
	end
	while HHCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = HHCore.GetPlayerData()
end)

-- Load Spot Status:
RegisterNetEvent('hhrp_MinerJob:loadSpot')
AddEventHandler('hhrp_MinerJob:loadSpot', function(list, list2, list3)
    MiningPos = list
    WashingPos = list2
    SmeltingPos = list3
end)

-- Update Mining Spot Status:
RegisterNetEvent('hhrp_MinerJob:updateStatus')
AddEventHandler('hhrp_MinerJob:updateStatus', function(id,status)
    if id ~= nil or status ~= nil then 
        MiningPos[id].mining = status
    end
end)

-- CreateThread Function for Mining:
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped,true)
        for k,v in pairs(MiningPos) do
            v.spot[1] = v.spot[1]
            v.spot[2] = v.spot[2]
            v.spot[3] = v.spot[3]
			if not v.mining and not currentlyMining then
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.spot[1], v.spot[2], v.spot[3], true) <= 10.0 then
					DrawMarker(Config.MiningMarker, v.spot[1], v.spot[2], v.spot[3]-0.97, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MiningMarkerScale.x, Config.MiningMarkerScale.y, Config.MiningMarkerScale.z, Config.MiningMarkerColor.r, Config.MiningMarkerColor.g, Config.MiningMarkerColor.b, Config.MiningMarkerColor.a, false, true, 2, false, false, false, false)
				end    
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.spot[1], v.spot[2], v.spot[3], true) <= 1.5 then
					DrawText3Ds(v.spot[1], v.spot[2], v.spot[3], Config.DrawMining3DText)
				end
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.spot[1], v.spot[2], v.spot[3], true) <= 1.0 then
					if IsControlJustPressed(0,Config.KeyToStartMining) and not keyPressed then
						keyPressed = true
						--HHCore.TriggerServerCallback("hhrp_MinerJob:getPickaxe", function(pickaxe)
						if exports['hhrp-inventory']:hasEnoughOfItem('pickaxe', 1, true) then
							local stone = exports['hhrp-inventory']:getQuantity('stone')
							if stone <= 95 then		
								HHCore.TriggerServerCallback("hhrp_MinerJob:didmining", function(didminingok) 
									if didminingok then
										TriggerServerEvent("hhrp_MinerJob:spotStatus", k, true)
										currentlyMining = true
										Citizen.Wait(250)
										MiningEvent(k,v)
									else
										exports['mythic_notify']:SendAlert('error', 'You Did Mining Once You Feel Tired Now!')
										keyPressed = false
									end
								end)
							else
								TriggerServerEvent("hhrp_MinerJob:getStoneLimit")
								exports['mythic_notify']:SendAlert('error', 'You can’t carry more stones with you!')
								keyPressed = false
							end
						else
							exports['mythic_notify']:SendAlert('error', 'You need a pick')
							keyPressed = false
						end
						--end
						break;
					end
				end
			end
        end
    end
end)

-- Create Mining Blips:
Citizen.CreateThread(function()
	for i = 1, #Config.MiningPositions do
		if Config.MiningPositions[i].blipEnable then
			local blip = AddBlipForCoord(Config.MiningPositions[i].spot[1], Config.MiningPositions[i].spot[2], Config.MiningPositions[i].spot[3])
			SetBlipSprite(blip, Config.MiningPositions[i].blipSprite)
			SetBlipDisplay(blip, Config.MiningPositions[i].blipDisplay)
			SetBlipScale  (blip, Config.MiningPositions[i].blipScale)
			SetBlipColour (blip, Config.MiningPositions[i].blipColor)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.MiningPositions[i].blipName)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Mining Function:
function MiningEvent(k,v)

	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	
	--FreezeEntityPosition(playerPed, true)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'))
	Citizen.Wait(200)
	
	local pickaxe = GetHashKey("prop_tool_pickaxe")
	
	-- Loads model
	RequestModel(pickaxe)
    while not HasModelLoaded(pickaxe) do
      Wait(1)
    end
	
	local anim = "melee@hatchet@streamed_core_fps"
	local action = "plyr_front_takedown"
	
	 -- Loads animation
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
      Wait(1)
    end
	
	local object = CreateObject(pickaxe, coords.x, coords.y, coords.z, true, false, false)
	AttachEntityToEntity(object, playerPed, GetPedBoneIndex(playerPed, 57005), 0.1, 0.0, 0.0, -90.0, 25.0, 35.0, true, true, false, true, 1, true)

	-- exports['pogressBar']:drawBar(10000, 'Kasama')
	exports['hhrp-taskbar']:taskBar(1000, "Mining")
	Citizen.Wait(200)
	TaskPlayAnim(PlayerPedId(), anim, action, 3.0, -3.0, -1, 31, 0, false, false, false)
	Citizen.Wait(2000)
	TaskPlayAnim(PlayerPedId(), anim, action, 3.0, -3.0, -1, 31, 0, false, false, false)
	Citizen.Wait(2000)
	TaskPlayAnim(PlayerPedId(), anim, action, 3.0, -3.0, -1, 31, 0, false, false, false)
	Citizen.Wait(2000)
	TaskPlayAnim(PlayerPedId(), anim, action, 3.0, -3.0, -1, 31, 0, false, false, false)
	Citizen.Wait(2000)
	TaskPlayAnim(PlayerPedId(), anim, action, 3.0, -3.0, -1, 31, 0, false, false, false)
	Citizen.Wait(2000)
	TriggerEvent( "player:receiveItem", "stone", 5 )
	--TriggerServerEvent("hhrp_MinerJob:reward",Config.Stone,Config.StoneReward)
	TriggerServerEvent("hhrp_MinerJob:spotStatus", k, false)
	
	ClearPedTasks(PlayerPedId())
	--FreezeEntityPosition(playerPed, false)
    DeleteObject(object)
	currentlyMining = false
	keyPressed = false
end

-- CreateThread Function for Washing:
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped,true)
        for k,v in pairs(WashingPos) do
            v.spot[1] = v.spot[1]
            v.spot[2] = v.spot[2]
            v.spot[3] = v.spot[3]
			if not currentlyWashing then
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.spot[1], v.spot[2], v.spot[3], true) <= 20.0 then
					DrawMarker(Config.WasherMarker, v.spot[1], v.spot[2], v.spot[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.WasherMarkerScale.x, Config.WasherMarkerScale.y, Config.WasherMarkerScale.z, Config.WasherMarkerColor.r, Config.WasherMarkerColor.g, Config.WasherMarkerColor.b, Config.WasherMarkerColor.a, false, true, 2, false, false, false, false)
				end    
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.spot[1], v.spot[2], v.spot[3], true) <= 1.2 then
					DrawText3Ds(v.spot[1], v.spot[2], v.spot[3], Config.DrawWasher3DText)
				end
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.spot[1], v.spot[2], v.spot[3], true) <= 1.2 then
					if IsControlJustPressed(0,Config.KeyToStartWashing) and not keyPressed then
						keyPressed = true
						--HHCore.TriggerServerCallback("hhrp_MinerJob:getWashPan", function(washPan)
							--if washPan then
							local WStone = exports['hhrp-inventory']:getQuantity('washedstone')
								--HHCore.TriggerServerCallback("hhrp_MinerJob:getWashedStoneLimit", function(washedStoneLimitOK)
									if WStone <= 95  then
										currentlyWashing = true
										Citizen.Wait(250)
										WashingEvent(k,v)
									else
										exports['mythic_notify']:SendAlert('error', 'You cannot carry more washed stones with you!')
										keyPressed = false
									end
								--end)
							--else
								--exports['mythic_notify']:SendAlert('error', 'A wash plate is needed here!')
								--keyPressed = false
							--end
						--end)
						break;
					end
				end
			end
        end
    end
end)

-- Create Washing Blips:
Citizen.CreateThread(function()
	for i = 1, #Config.WashingPositions do
		if Config.WashingPositions[i].blipEnable then
			local blip = AddBlipForCoord(Config.WashingPositions[i].spot[1], Config.WashingPositions[i].spot[2], Config.WashingPositions[i].spot[3])
			SetBlipSprite(blip, Config.WashingPositions[i].blipSprite)
			SetBlipDisplay(blip, Config.WashingPositions[i].blipDisplay)
			SetBlipScale  (blip, Config.WashingPositions[i].blipScale)
			SetBlipColour (blip, Config.WashingPositions[i].blipColor)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.WashingPositions[i].blipName)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

function WashingEvent(k,v)
	
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	
	FreezeEntityPosition(playerPed, true)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'))
	Citizen.Wait(200)
	
	--HHCore.TriggerServerCallback("hhrp_MinerJob:removeStone", function(stoneCount)
	local WStoneCount = exports['hhrp-inventory']:hasEnoughOfItem('stone', 10, true)
		if WStoneCount then
			-- exports['pogressBar']:drawBar(10000, 'Plaunami akmenys')
			exports['hhrp-taskbar']:taskBar(500, "Washing Stones")
			Citizen.Wait(200)
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			TriggerEvent("inventory:removeItem", "stone", 10)
			Citizen.Wait(10000)
			--Citizen.Wait(1000)
			TriggerEvent("player:receiveItem", "washedstone", 10)
			--TriggerEvent("player:recieveItem", 'washedstone', Config.WStoneReward)
			--TriggerEvent( "player:receiveItem", "heartstopper", 10 )

			--TriggerServerEvent("hhrp_MinerJob:reward",Config.WStone,Config.WStoneReward)
		else
			exports['mythic_notify']:SendAlert('error', 'Here you need 10x washed stone!')
		end
		ClearPedTasks(playerPed)
		FreezeEntityPosition(playerPed, false)
		currentlyWashing = false
		keyPressed = false
	--end)
end

-- CreateThread Function for Washing:
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped,true)
        for k,v in pairs(SmeltingPos) do
            v.spot[1] = v.spot[1]
            v.spot[2] = v.spot[2]
            v.spot[3] = v.spot[3]
			if not currentlySmelting then
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.spot[1], v.spot[2], v.spot[3], true) <= 20.0 then
					DrawMarker(Config.SmelterMarker, v.spot[1], v.spot[2], v.spot[3]-0.97, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.SmelterMarkerScale.x, Config.SmelterMarkerScale.y, Config.SmelterMarkerScale.z, Config.SmelterMarkerColor.r, Config.SmelterMarkerColor.g, Config.SmelterMarkerColor.b, Config.SmelterMarkerColor.a, false, true, 2, false, false, false, false)
				end    
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.spot[1], v.spot[2], v.spot[3], true) <= 1.5 then
					DrawText3Ds(v.spot[1], v.spot[2], v.spot[3], Config.DrawSmelter3DText)
				end
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.spot[1], v.spot[2], v.spot[3], true) <= 1.0 then
					if IsControlJustPressed(0,Config.KeyToStartSmelting) and not keyPressed then
						keyPressed = true
						local closestPlayer, closestDistance = HHCore.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance >= 0.7 then
							local WStoneCount1 = exports['hhrp-inventory']:hasEnoughOfItem('washedstone', 10, true)
							if WStoneCount1 then
								TriggerEvent("inventory:removeItem", 'washedstone', 10)
								currentlySmelting = true
								Citizen.Wait(250)
								SmeltingEvent(k,v)
							else
								exports['mythic_notify']:SendAlert('error', 'You need at least 10 washed stones to start melting here!')
								keyPressed = false
							end
							--end)
						else
							exports['mythic_notify']:SendAlert('error', 'You are too close to another person!')
							keyPressed = false
						end	
						break;
					end
				end
			end
        end
    end
end)

-- Create Smelting Blips:
Citizen.CreateThread(function()
	for i = 1, #Config.SmeltingPositions do
		if Config.SmeltingPositions[i].blipEnable then
			local blip = AddBlipForCoord(Config.SmeltingPositions[i].spot[1], Config.SmeltingPositions[i].spot[2], Config.SmeltingPositions[i].spot[3])
			SetBlipSprite(blip, Config.SmeltingPositions[i].blipSprite)
			SetBlipDisplay(blip, Config.SmeltingPositions[i].blipDisplay)
			SetBlipScale  (blip, Config.SmeltingPositions[i].blipScale)
			SetBlipColour (blip, Config.SmeltingPositions[i].blipColor)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.SmeltingPositions[i].blipName)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Function for Smelting:
function SmeltingEvent()
		
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	
	--FreezeEntityPosition(playerPed, true)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'))
	Citizen.Wait(200)

	-- exports['pogressBar']:drawBar(10000, 'Lydomi nuplauti akmenys')
	exports['hhrp-taskbar']:taskBar(10000, "Smelting Stones")
	--Citizen.Wait(10000)
	local rewardChance = math.random(1,10)
	if rewardChance <= 2 then
		
		TriggerEvent("player:receiveItem", 'goldbar', 1)

	elseif rewardChance > 2 and rewardChance <= 5 then
		TriggerEvent("player:receiveItem", 'aluminium', 10)
	elseif rewardChance > 5 and rewardChance <= 7 then
		TriggerEvent("player:receiveItem", 'copper', 10)
	elseif rewardChance > 7 and rewardChance <= 10 then
		TriggerEvent("player:receiveItem", 'steel', 10)
	end
	--TriggerServerEvent("hhrp_MinerJob:rewardSmelting")
	
	--FreezeEntityPosition(playerPed, false)
	currentlySmelting = false
	keyPressed = false

end

-- Refresh Spots:
Citizen.CreateThread(function()
    TriggerServerEvent("hhrp_MinerJob:refreshSpots")
end)

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end
