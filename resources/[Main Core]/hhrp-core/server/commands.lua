TriggerEvent('es:addGroupCommand', 'setjob', 'admin', function(source, args, user)
	print("running this shit")
	if tonumber(args[1]) and args[2] and tonumber(args[3]) then
		local xPlayer = HHCore.GetPlayerFromId(args[1])

		if xPlayer then
			if HHCore.DoesJobExist(args[2], args[3]) then
				xPlayer.setJob(args[2], args[3])
			else
				TriggerClientEvent('chatMessagess', source, 'SYSTEM: ', 3, 'That job does not exist.')
			end

		else
			TriggerClientEvent('chatMessagess', source, 'SYSTEM: ', 3, 'Player not online.')
		end
	else
		TriggerClientEvent('chatMessagess', source, 'SYSTEM: ', 3, 'Invalid usage.')
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessagess', source, 'SYSTEM: ', 3, 'Insufficient Permissions.')
end, {help = _U('setjob'), params = {{name = "id", help = _U('id_param')}, {name = "job", help = _U('setjob_param2')}, {name = "grade_id", help = _U('setjob_param3')}}})

RegisterCommand('hhrp-setjob', function(source, args)
	if source == 0 or source =="console" then
		if tonumber(args[1]) and args[2] and tonumber(args[3]) then
			local xPlayer = HHCore.GetPlayerFromId(args[1])
			if xPlayer then
				if HHCore.DoesJobExist(args[2], args[3]) then
					xPlayer.setJob(args[2], args[3])
					print("JOB Set")
				else
					print("No Such Job")
				end
			else
				print("No Target Player")
			end
		end
	else
		print("Not TXadmin")
	end
end)

TriggerEvent('es:addGroupCommand', 'giveaccountmoney', 'admin', function(source, args, user)
	local _source = source
	local xPlayer = HHCore.GetPlayerFromId(args[1])
	local account = args[2]
	local amount  = tonumber(args[3])

	if amount ~= nil then
		if xPlayer.getAccount(account) ~= nil then
			xPlayer.addAccountMoney(account, amount)
		else
			TriggerClientEvent('hhrp:showNotification', _source, _U('invalid_account'))
		end
	else
		TriggerClientEvent('hhrp:showNotification', _source, _U('amount_invalid'))
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessagess', source, 'SYSTEM: ', 3, 'Insufficient Permissions.')
end, {help = _U('giveaccountmoney'), params = {{name = "id", help = _U('id_param')}, {name = "account", help = _U('account')}, {name = "amount", help = _U('money_amount')}}})

RegisterCommand('hhrp-giveaccountmoney', function(source, args)
	if source == 0 or source =="console" then
		local xPlayer = HHCore.GetPlayerFromId(args[1])
		local account = args[2]
		local amount  = tonumber(args[3])
	
		if amount ~= nil then
			if xPlayer.getAccount(account) ~= nil then
				xPlayer.addAccountMoney(account, amount)
				print("Money Set")
			else
				print("Invalid Account")
			end
		else
			print("Invalid Amount")
		end
	else
		print("Not TXadmin")
	end
end)

TriggerEvent('es:addGroupCommand', 'clear', 'user', function(source, args, user)
	TriggerClientEvent('chat:clear', source)
end, function(source, args, user)
	TriggerClientEvent('chatMessagess', source, 'SYSTEM: ', 3, 'Insufficient Permissions.')
end, {help = _U('chat_clear')})

TriggerEvent('es:addGroupCommand', 'clearall', 'admin', function(source, args, user)
	TriggerClientEvent('chat:clear', -1)
end, function(source, args, user)
	TriggerClientEvent('chatMessagess', source, 'SYSTEM: ', 3, 'Insufficient Permissions.')
end, {help = _U('chat_clear_all')})