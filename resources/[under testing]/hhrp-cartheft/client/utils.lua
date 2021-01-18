

HHCore 						= nil
local PlayerData            = {}

-- Outlaw Notify:
local timing, isPlayerWhitelisted = math.ceil(1 * 60000), false
local streetName
local _

Citizen.CreateThread(function()
	while HHCore == nil do
		TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)
		Citizen.Wait(0)
	end
	while HHCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = HHCore.GetPlayerData()
	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('hhrp:playerLoaded')
AddEventHandler('hhrp:playerLoaded', function(xPlayer)
	HHCore.PlayerData = xPlayer
end)

RegisterNetEvent('hhrp:setJob')
AddEventHandler('hhrp:setJob', function(job)
	HHCore.PlayerData.job = job
	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

-- [[ POLICE ALERTS ]] --
function AlertPoliceFunction()
	TriggerServerEvent('t1ger_carthief:OutlawNotifySV',GetEntityCoords(PlayerPedId()),streetName)
	
	-- If you want to use your own alert:
	-- 1) Comment out the 'TriggerServerEvent('t1ger_carthief:OutlawNotifySV',GetEntityCoords(PlayerPedId()),streetName)'
	-- 2) replace whatever even you use to trigger your alert.
	
end

RegisterNetEvent('t1ger_carthief:OutlawNotifyBlip')
AddEventHandler('t1ger_carthief:OutlawNotifyBlip', function(targetCoords)
	if isPlayerWhitelisted and Config.PoliceBlipShow then
		local alpha = Config.PoliceBlipAlpha
		local policeNotifyBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.PoliceBlipRadius)

		SetBlipHighDetail(policeNotifyBlip, true)
		SetBlipColour(policeNotifyBlip, Config.PoliceBlipColor)
		SetBlipAlpha(policeNotifyBlip, alpha)
		SetBlipAsShortRange(policeNotifyBlip, true)

		while alpha ~= 0 do
			Citizen.Wait(Config.PoliceBlipTime * 4)
			alpha = alpha - 1
			SetBlipAlpha(policeNotifyBlip, alpha)

			if alpha == 0 then
				RemoveBlip(policeNotifyBlip)
				return
			end
		end
	end
end)

RegisterNetEvent('t1ger_carthief:OutlawNotifyCL')
AddEventHandler('t1ger_carthief:OutlawNotifyCL', function(alert)
	if isPlayerWhitelisted then
		TriggerEvent('chat:addMessage', { args = {_U('dispatch_name').. alert}})
	end
end)

-- Thread for Police Notify
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

-- [[ HHCore SHOW NOTIFICATION ]] --
RegisterNetEvent('t1ger:ShowNotifyHHCore')
AddEventHandler('t1ger:ShowNotifyHHCore', function(msg)
	ShowNotifyHHCore(msg)
	
	-- If you want to switch HHCore.ShowNotification with something else:
	-- 1) Comment out the function
	-- 2) add your own
	
end)

function ShowNotifyHHCore(msg)
	HHCore.ShowNotification(msg)
	-- If you want to switch HHCore.ShowNotification with something else:
	-- 1) Comment out the function
	-- 2) add your own
end

-- [[ PHONE MESSAGES ]] --
function JobNotifyMSG(msg)
	local phoneNr = Config.CarThiefNPCName
    PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", true)
	HHCore.ShowNotification(_U('new_msg_from', phoneNr))
	TriggerServerEvent('gcPhone:sendMessage', phoneNr, msg)
	
	-- If you use GCPhone and have not changed in it, do not touch this!
	-- If you use another phone or customized gcphone functions etc:
	-- 1) Edit the TriggerServerEvent to your likings
		
end

function DrawVehHealthUtils(vehHealth)
	-- Background Settings:
	drawRct(0.905, 0.95, 0.0630, 0.020, 0, 0, 0, 80)
	-- Health Bar Settings:
	drawRct(0.905, 0.95, 0.0630*(vehHealth*0.01), 0.019, 255, 30, 0, 125)
	-- Text Settings:
	SetTextScale(0.34, 0.34)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(_U('veh_health')..round(vehHealth, 1)..'%')
	DrawText(0.938,0.9480)
end

function drawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

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

function refreshPlayerWhitelisted()	
	if not HHCore.PlayerData then
		return false
	end
	if not HHCore.PlayerData.job then
		return false
	end
	if Config.PoliceJobName == HHCore.PlayerData.job.name then
		return true
	end
	return false
end
