-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 
HHCore 		= nil
PlayerData 	= {}

Citizen.CreateThread(function()
	while HHCore == nil do
		TriggerEvent(Config.HHCoreSHAREDOBJECT, function(obj) HHCore = obj end)
		Citizen.Wait(0)
	end
	while HHCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = HHCore.GetPlayerData()
	TriggerServerEvent('t1ger_deliveryjob:fetchCompanySV')
end)

RegisterNetEvent('hhrp:playerLoaded')
AddEventHandler('hhrp:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('hhrp:setJob')
AddEventHandler('hhrp:setJob', function(job)
	PlayerData.job = job
end)

-- [[ HHCore SHOW ADVANCED NOTIFICATION ]] --
RegisterNetEvent('t1ger_deliveryjob:ShowAdvancedNotifyHHCore')
AddEventHandler('t1ger_deliveryjob:ShowAdvancedNotifyHHCore', function(title, subject, msg, icon, iconType)
	HHCore.ShowAdvancedNotification(title, subject, msg, icon, iconType)
	-- If you want to switch HHCore.ShowNotification with something else:
	-- 1) Comment out the function
	-- 2) add your own
	
end)

-- [[ HHCore SHOW NOTIFICATION ]] --
RegisterNetEvent('t1ger_deliveryjob:ShowNotifyHHCore')
AddEventHandler('t1ger_deliveryjob:ShowNotifyHHCore', function(msg)
	ShowNotifyHHCore(msg)
end)

function ShowNotifyHHCore(msg)
	HHCore.ShowNotification(msg)
	-- If you want to switch HHCore.ShowNotification with something else:
	-- 1) Comment out the function
	-- 2) add your own
end

companyBlips = {}
function CreateCompanyBlips(k,v,label)
	local mk = Config.BlipSettings 
	if mk.enable then
		blip = AddBlipForCoord(v.menuPos[1], v.menuPos[2], v.menuPos[3])
		SetBlipSprite (blip, mk.sprite)
		SetBlipDisplay(blip, mk.display)
		SetBlipScale  (blip, mk.scale)
		--SetBlipColour (blip, mk.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(label)
		EndTextCommandSetBlipName(blip)
		table.insert(companyBlips, blip)
	end
end

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function drawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
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

-- Function for Mission text:
function DrawMissionText(text)
    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(0.5,0.955)
end

-- Round Fnction:
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function LoadAnim(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function LoadModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
end