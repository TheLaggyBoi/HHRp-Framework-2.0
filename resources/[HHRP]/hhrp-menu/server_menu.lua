HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj)
    HHCore = obj
end)

RegisterServerEvent('hhrp-interactions:putInVehicle')
AddEventHandler('hhrp-interactions:putInVehicle', function(target)
    TriggerClientEvent('hhrp-interactions:putInVehicle', target)
end)

RegisterServerEvent('hhrp-interactions:outOfVehicle')
AddEventHandler('hhrp-interactions:outOfVehicle', function(target)
    TriggerClientEvent('hhrp-interactions:outOfVehicle', target)
end)