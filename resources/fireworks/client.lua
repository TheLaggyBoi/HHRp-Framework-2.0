local box = nil
local animlib = 'anim@mp_fireworks'

function msg(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(false, true)
end

RegisterCommand("sf", function()
	TriggerEvent('frobski-fireworks:start')
	--TriggerServerEvent('fireworks')
end)

RegisterNetEvent('bz-noperms')
AddEventHandler('bz-noperms', function()
msg("~r~Sorry! You don't have permission to do that.")
end)


RegisterNetEvent('frobski-fireworks:start')
AddEventHandler('frobski-fireworks:start', function()

	RequestAnimDict(animlib)

	while not HasAnimDictLoaded(animlib) do
		   Citizen.Wait(10)
    end
        
	if not HasNamedPtfxAssetLoaded("proj_indep_firework_v2") then
		RequestNamedPtfxAsset("proj_indep_firework_v2")
		while not HasNamedPtfxAssetLoaded("proj_indep_firework_v2") do
		   Wait(10)
		end
	end

	if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
		   Wait(10)
		end
	end

	if not HasNamedPtfxAssetLoaded("proj_xmas_firework") then
		RequestNamedPtfxAsset("proj_xmas_firework")
		while not HasNamedPtfxAssetLoaded("proj_xmas_firework") do
		   Wait(10)
		end
	end

	local pedcoords = GetEntityCoords(GetPlayerPed(-1))
	local ped = GetPlayerPed(-1)
	local times = 20

	TaskPlayAnim(ped, animlib, 'place_firework_3_box', -1, -8.0, 3000, 0, 0, false, false, false)
	Citizen.Wait(4000)
	ClearPedTasks(ped)
		   
	box = CreateObject(GetHashKey('ind_prop_firework_03'), pedcoords, true, false, false)
	PlaceObjectOnGroundProperly(box)
	FreezeEntityPosition(box, true)
	local firecoords = GetEntityCoords(box)

	Citizen.Wait(10000)
	repeat
	UseParticleFxAssetNextCall("proj_indep_firework_v2")
	local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", firecoords.x, firecoords.y, firecoords.z+22, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("scr_indep_fireworks")
	local part2 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", firecoords.x, firecoords.y, firecoords.z+22, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("proj_xmas_firework")
	local part3 = StartNetworkedParticleFxNonLoopedAtCoord("scr_firework_xmas_spiral_burst_rgw", firecoords.x, firecoords.y, firecoords.z+22, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

	times = times - 1
	Citizen.Wait(2000)
	until(times == 0)
	DeleteEntity(box)
	box = nil
end)

