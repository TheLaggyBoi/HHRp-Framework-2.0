HHCore = nil
local PlayerData = {}
local oncows = true
local wait = true
Citizen.CreateThread(function()
	while HHCore == nil do
		TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('hhrp:playerLoaded')
AddEventHandler('hhrp:playerLoaded', function(xPlayer)
	PlayerData = xPlayer 
end)

RegisterNetEvent('hhrp:setJob')
AddEventHandler('hhrp:setJob', function(job)
	PlayerData.job = job
	
	Citizen.Wait(10)
end)



Citizen.CreateThread(function()

    for _,v in pairs(Config.Cows) do
		RequestModel(GetHashKey(Config.Model))
		while not HasModelLoaded(GetHashKey(Config.Model)) do
			Wait(1)
      end
  
	  ped =  CreatePed(4, GetHashKey(Config.Model),v[1],v[2],v[3], 3374176, false, true)
      SetEntityHeading(ped, v[4])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		if Config.Text3d then
			if (GetDistanceBetweenCoords(coords, 1134.03, -2353.67, 31.13, true) < 30.0)  then
				DrawText3D(1136.73, -2352.22, 31.22, '~y~[E] ~w~Take Milk')	
				DrawText3D(1131.05, -2354.19, 30.99, '~y~[E] ~w~Take Milk')		
				DrawText3D(1135.52, -2355.72, 31.29, '~y~[E] ~w~Take Milk')		
				DrawText3D(1134.41, -2365.31, 31.25, '~y~[E] ~w~Take Milk')					
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for _,v in pairs(Config.Cows) do
			if (GetDistanceBetweenCoords(coords, v[1],v[2],v[3], true) < 2.0)  then

				if IsControlJustReleased(0, 46) then
					TakeMilk()
				end
			end
		end
	end
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(60000)
-- 		if wait then
-- 			wait = false
-- 		end
-- 	end
-- end)

function TakeMilk()
	if wait then
		TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
		time = Config.TimeToEnd * 1000
		exports['hhrp-taskbar']:taskBar(time,Config.TakingLabel)
		TriggerEvent('player:receiveItem',"milkcan", 1)
	else
		TriggerEvent('DoLongHudText', 'You Need To Wait ' .. Config.WaitTime .. ' Seconds Before Take ' .. Config.PrizeLabel .. ' Again', 2)
	end
end

-- Create blips
Citizen.CreateThread(function()
	for _, info in pairs(Config.Blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, info.size)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	  end
end)

function DrawText3D(x,y,z, text)

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

-- Sell Milk 3D Test
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		if Config.Text3d then
			if (GetDistanceBetweenCoords(coords, -635.33, 233.84, 81.88, true) < 2.0)  then
				DrawText3D(-635.33, 233.84, 81.88, '~y~[E] ~w~Sell Milk')	
				if IsControlJustReleased(0, 46) then
					if exports['hhrp-inventory']:hasEnoughOfItem("milkcan", 1, false) then
						SellMilk()
					else
						TriggerEvent('DoLongHudText', 'Not Enough Milk Cans')
					end
				end
			end
		end
	end
end)

function SellMilk()
	exports['hhrp-taskbar']:taskBar(3000,'Selling ' .. Config.PrizeLabel .. '')
	TriggerServerEvent('hhrp_milkerjob:sellitem')
	TriggerEvent('inventory:removeItem', 'milkcan', 1)
    TriggerEvent('OpenInv')
end