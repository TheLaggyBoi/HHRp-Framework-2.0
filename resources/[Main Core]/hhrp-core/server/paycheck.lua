HHCore.StartPayCheck = function()

	function payCheck()
		local xPlayers = HHCore.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = HHCore.GetPlayerFromId(xPlayers[i])
			local job     = xPlayer.job.grade_name
			local salary  = 15

			if salary > 0 then
				if job == 'unemployed' then -- unemployed
					xPlayer.addAccountMoney('bank', salary)
				elseif Config.EnableSocietyPayouts then -- possibly a society
					TriggerEvent('hhrp-society:getSociety', xPlayer.job.name, function (society)
						if society ~= nil then -- verified society
							TriggerEvent('hhrp-addonaccount:getSharedAccount', society.account, function (account)
								if account.money >= salary then -- does the society money to pay its employees?
									xPlayer.addAccountMoney('bank', salary)
									account.removeMoney(salary)
								else
									TriggerClientEvent('hhrp:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
								end
							end)
						else -- not a society
							xPlayer.addAccountMoney('bank', salary)
						end
					end)
				else -- generic job
					xPlayer.addAccountMoney('bank', salary)
				end
			end

		end

		SetTimeout(Config.PaycheckInterval, payCheck)

	end

	SetTimeout(Config.PaycheckInterval, payCheck)

end

-- ESX.StartPayCheck = function()
-- 	function payCheck()
-- 		local xPlayers = ESX.GetPlayers()

-- 		for i=1, #xPlayers, 1 do
-- 			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
-- 			local job     = xPlayer.job.grade_name
-- 			local salary  = xPlayer.job.grade_salary

-- 			if salary > 0 then
-- 				if job == 'unemployed' then -- unemployed
-- 					xPlayer.addAccountMoney('bank', salary)
-- 					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_help', salary), 'CHAR_BANK_MAZE', 9)
-- 				elseif Config.EnableSocietyPayouts then -- possibly a society
-- 					TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
-- 						if society ~= nil then -- verified society
-- 							TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
-- 								if account.money >= salary then -- does the society money to pay its employees?
-- 									xPlayer.addAccountMoney('bank', salary)
-- 									account.removeMoney(salary)

-- 									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
-- 								else
-- 									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
-- 								end
-- 							end)
-- 						else -- not a society
-- 							xPlayer.addAccountMoney('bank', salary)
-- 							TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
-- 						end
-- 					end)
-- 				else -- generic job
-- 					xPlayer.addAccountMoney('bank', salary)
-- 					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
-- 				end
-- 			end

-- 		end

-- 		SetTimeout(Config.PaycheckInterval, payCheck)
-- 	end

-- 	SetTimeout(Config.PaycheckInterval, payCheck)
-- end

HHCore.RegisterServerCallback('paycheck:checkSalary', function(source, cb)
	if source ~= nil then
		local xPlayer = HHCore.GetPlayerFromId(source)
		local salary  = xPlayer.job.grade_salary
		if xPlayer ~= nil then
			cb(salary)
		else
			cb(false)
		end
	end
end)




RegisterServerEvent('paycheck:collectPay')
AddEventHandler('paycheck:collectPay', function()
	local source = source
	local xPlayer = HHCore.GetPlayerFromId(source)
	local job     = xPlayer.job.grade_name
	local salary  = xPlayer.job.grade_salary

	if salary > 0 then
		if job == 'unemployed' then -- unemployed
			xPlayer.addMoney( salary)
		elseif Config.EnableSocietyPayouts then -- possibly a society
			TriggerEvent('hhrp-society:getSociety', xPlayer.job.name, function (society)
				if society ~= nil then -- verified society
					TriggerEvent('hhrp-addonaccount:getSharedAccount', society.account, function (account)
						if account.money >= salary then -- does the society money to pay its employees?
							xPlayer.addMoney( salary)
							account.removeMoney(salary)
							--TriggerClientEvent("banking:updateCash", source, (xPlayer.getMoney()))
						else
							TriggerClientEvent('hhrp:showAdvancedNotification', source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
						end
					end)
				else -- not a society
					xPlayer.addMoney( salary)
				end
			end)
		else -- generic job
			xPlayer.addMoney( salary)
		end
	end
end)

RegisterServerEvent('paycheck:collectPayStack')
AddEventHandler('paycheck:collectPayStack', function()
	local source = source
	local xPlayer = HHCore.GetPlayerFromId(source)
	local job     = xPlayer.job.grade_name
	local salary  = xPlayer.job.grade_salary * 2

	if salary > 0 then
		if job == 'unemployed' then -- unemployed
			xPlayer.addMoney( salary)
		elseif Config.EnableSocietyPayouts then -- possibly a society
			TriggerEvent('hhrp-society:getSociety', xPlayer.job.name, function (society)
				if society ~= nil then -- verified society
					TriggerEvent('hhrp-addonaccount:getSharedAccount', society.account, function (account)
						if account.money >= salary then -- does the society money to pay its employees?
							xPlayer.addMoney( salary)
							account.removeMoney(salary)
							--TriggerClientEvent("banking:updateCash", source, (xPlayer.getMoney()))

						else
							TriggerClientEvent('hhrp:showAdvancedNotification', source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
						end
					end)
				else -- not a society
					xPlayer.addMoney( salary)
				end
			end)
		else -- generic job
			xPlayer.addMoney( salary)
		end
	end
end)

RegisterServerEvent('paycheck:collectPayStack3')
AddEventHandler('paycheck:collectPayStack3', function()
	local source = source
	local xPlayer = HHCore.GetPlayerFromId(source)
	local job     = xPlayer.job.grade_name
	local salary  = xPlayer.job.grade_salary * 3

	if salary > 0 then
		if job == 'unemployed' then -- unemployed
			xPlayer.addMoney( salary)
		elseif Config.EnableSocietyPayouts then -- possibly a society
			TriggerEvent('hhrp-society:getSociety', xPlayer.job.name, function (society)
				if society ~= nil then -- verified society
					TriggerEvent('hhrp-addonaccount:getSharedAccount', society.account, function (account)
						if account.money >= salary then -- does the society money to pay its employees?
							xPlayer.addMoney( salary)
							account.removeMoney(salary)
							--TriggerClientEvent("banking:updateCash", source, (xPlayer.getMoney()))

						else
							TriggerClientEvent('hhrp:showAdvancedNotification', source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
						end
					end)
				else -- not a society
					xPlayer.addMoney( salary)
				end
			end)
		else -- generic job
			xPlayer.addMoney( salary)
		end
	end
end) 

RegisterServerEvent('paycheck:collectPayStack4')
AddEventHandler('paycheck:collectPayStack4', function()
	local source = source
	local xPlayer = HHCore.GetPlayerFromId(source)
	local job     = xPlayer.job.grade_name
	local salary  = xPlayer.job.grade_salary * 4

	if salary > 0 then
		if job == 'unemployed' then -- unemployed
			xPlayer.addMoney( salary)
		elseif Config.EnableSocietyPayouts then -- possibly a society
			TriggerEvent('hhrp-society:getSociety', xPlayer.job.name, function (society)
				if society ~= nil then -- verified society
					TriggerEvent('hhrp-addonaccount:getSharedAccount', society.account, function (account)
						if account.money >= salary then -- does the society money to pay its employees?
							xPlayer.addMoney( salary)
							account.removeMoney(salary)
							--TriggerClientEvent("banking:updateCash", source, (xPlayer.getMoney()))

						else
							TriggerClientEvent('hhrp:showAdvancedNotification', source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
						end
					end)
				else -- not a society
					xPlayer.addMoney( salary)
				end
			end)
		else -- generic job
			xPlayer.addMoney( salary)
		end
	end
end) 

RegisterServerEvent('paycheck:collectPayStack5')
AddEventHandler('paycheck:collectPayStack5', function()
	local source = source
	local xPlayer = HHCore.GetPlayerFromId(source)
	local job     = xPlayer.job.grade_name
	local salary  = xPlayer.job.grade_salary * 5

	if salary > 0 then
		if job == 'unemployed' then -- unemployed
			xPlayer.addMoney( salary)
		elseif Config.EnableSocietyPayouts then -- possibly a society
			TriggerEvent('hhrp-society:getSociety', xPlayer.job.name, function (society)
				if society ~= nil then -- verified society
					TriggerEvent('hhrp-addonaccount:getSharedAccount', society.account, function (account)
						if account.money >= salary then -- does the society money to pay its employees?
							xPlayer.addMoney( salary)
							account.removeMoney(salary)
							--TriggerClientEvent("banking:updateCash", source, (xPlayer.getMoney()))

						else
							TriggerClientEvent('hhrp:showAdvancedNotification', source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
						end
					end)
				else -- not a society
					xPlayer.addMoney( salary)
				end
			end)
		else -- generic job
			xPlayer.addMoney( salary)
		end
	end
end) 