-- Golden Framework --
local databaseLoaded = false

CreateThread(function()
	while true do
		if databaseLoaded == false then
			local frameworkSQL = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'framework_sql_file'))
			
			MySQL.ready(function ()
				MySQL.Async.fetchAll("SELECT * FROM gd_characters", {}, function(data)
					if(data == nil) then
						MySQL.Async.execute(frameworkSQL)
						Wait(1000)
						print("---------------------------------\nTables have been inserted into the database automatically! (gd_characters & gd_players)\n---------------------------------")
					end
				end)
			end)
			
			databaseLoaded = true
		end
		
		Wait(5000)
	end
end)

AddEventHandler('playerDropped', function(reason)
	local src = source
	
	local steamId1 = GetPlayerIdentifiers(src)[1]
	local steamId = steamId1:gsub("steam:", "")

	MySQL.Async.execute('UPDATE `gd_players` SET Player_ActiveCharacterID = @activeCharacter WHERE `Player_SteamHEX` = @steamID', { 
		['@activeCharacter'] = 0,
		['@steamID'] = steamId 
	})
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then 
		return 
	end

	if (GetCurrentResourceName() ~= "golden_framework") then
		print("The frameworks resource name MUST be `golden_framework`, Or else the resource will not function properly.")
	end
end)

-- Character Stuff --
RegisterServerEvent("golden:framework:createCharacter")
AddEventHandler("golden:framework:createCharacter", function(FirstName, LastName, DOB, Gender, Dept, StartMoney, PhoneNumber)
	local src = source

	local steamId1 = GetPlayerIdentifiers(src)[1]
	local steamId = steamId1:gsub("steam:", "")

	local Full_Name = FirstName .. " " .. LastName
	local date1 = convertDate(DOB)

	if Dept == "CIV" then
		if Config.VOIPSystem.phoneEnabled then
			MySQL.Async.insert('INSERT INTO `gd_characters` (`Character_Name`, `Character_FName`, `Character_LName`, `Character_Gender`, `Character_DOB`, `Character_DepJob`, `Character_JobName`, `Character_Bank`, `Character_Cash`, `Character_PhoneNo`, `Character_PlayerSteamHEX`) VALUES (@Full_Name, @FName, @LName, @Gender, @DoB, @Department, @JobName, @Bank, @Cash, @PhoneNumber, @PlayerId)', {
				['@Full_Name'] = Full_Name, ['@FName'] = FirstName, ['@LName'] = LastName, ['@Gender'] = Gender, ['@DoB'] = date1, ['@Department'] = Dept, ['@JobName'] = "UNEMPLOYED", ['@Bank'] = StartMoney, ['@Cash'] = StartMoney, ['@PhoneNumber'] = PhoneNumber, ['@PlayerId'] = steamId
			}, function(insertId)
				TriggerClientEvent('golden:framework:sendCreatedCharacterInfo', src, insertId, Full_Name, Gender, Dept)
			end)
		else
			MySQL.Async.insert('INSERT INTO `gd_characters` (`Character_Name`, `Character_FName`, `Character_LName`, `Character_Gender`, `Character_DOB`, `Character_DepJob`, `Character_JobName`, `Character_Bank`, `Character_Cash`, `Character_PlayerSteamHEX`) VALUES (@Full_Name, @FName, @LName, @Gender, @DoB, @Department, @JobName, @Bank, @Cash, @PlayerId)', {
				['@Full_Name'] = Full_Name, ['@FName'] = FirstName, ['@LName'] = LastName, ['@Gender'] = Gender, ['@DoB'] = date1, ['@Department'] = Dept, ['@JobName'] = "UNEMPLOYED", ['@Bank'] = StartMoney, ['@Cash'] = StartMoney, ['@PlayerId'] = steamId
			}, function(insertId)
				TriggerClientEvent('golden:framework:sendCreatedCharacterInfo', src, insertId, Full_Name, Gender, Dept)
			end)
		end
	else
		if Config.VOIPSystem.phoneEnabled then
			MySQL.Async.insert('INSERT INTO `gd_characters` (`Character_Name`, `Character_FName`, `Character_LName`, `Character_Gender`, `Character_DOB`, `Character_DepJob`, `Character_Bank`, `Character_Cash`, `Character_PhoneNo`, `Character_PlayerSteamHEX`) VALUES (@Full_Name, @FName, @LName, @Gender, @DoB, @Department, @Bank, @Cash, @PhoneNumber, @PlayerId)', {
				['@Full_Name'] = Full_Name, ['@FName'] = FirstName, ['@LName'] = LastName, ['@Gender'] = Gender, ['@DoB'] = date1, ['@Department'] = Dept, ['@Bank'] = StartMoney, ['@Cash'] = StartMoney, ['@PhoneNumber'] = PhoneNumber, ['@PlayerId'] = steamId
			}, function(insertId)
				TriggerClientEvent('golden:framework:sendCreatedCharacterInfo', src, insertId, Full_Name, Gender, Dept)
			end)
		else
			MySQL.Async.insert('INSERT INTO `gd_characters` (`Character_Name`, `Character_FName`, `Character_LName`, `Character_Gender`, `Character_DOB`, `Character_DepJob`, `Character_JobName`, `Character_Bank`, `Character_Cash`, `Character_PlayerSteamHEX`) VALUES (@Full_Name, @FName, @LName, @Gender, @DoB, @Department, @JobName, @Bank, @Cash, @PlayerId)', {
				['@Full_Name'] = Full_Name, ['@FName'] = FirstName, ['@LName'] = LastName, ['@Gender'] = Gender, ['@DoB'] = date1, ['@Department'] = Dept, ['@JobName'] = "UNEMPLOYED", ['@Bank'] = StartMoney, ['@Cash'] = StartMoney, ['@PlayerId'] = steamId
			}, function(insertId)
				TriggerClientEvent('golden:framework:sendCreatedCharacterInfo', src, insertId, Full_Name, Gender, Dept)
			end)
		end
	end
end)

RegisterServerEvent("golden:framework:saveCharacterEdit")
AddEventHandler("golden:framework:saveCharacterEdit", function(CharacterID, FirstName, LastName, DOB, Gender, Dept)
	local src = source

	local steamId1 = GetPlayerIdentifiers(src)[1]
	local steamId = steamId1:gsub("steam:", "")

	local Full_Name = FirstName .. " " .. LastName
	local date1 = convertDate(DOB)

	if Dept == "CIV" then
		MySQL.Async.execute('UPDATE `gd_characters` SET Character_Name = @CharacterName WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterName'] = Full_Name
		})

		MySQL.Async.execute('UPDATE `gd_characters` SET Character_FName = @CharacterFName WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterFName'] = FirstName
		})

		MySQL.Async.execute('UPDATE `gd_characters` SET Character_LName = @CharacterLName WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterLName'] = LastName
		})

		MySQL.Async.execute('UPDATE `gd_characters` SET Character_DOB = @CharacterDOB WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterDOB'] = date1
		})

		MySQL.Async.execute('UPDATE `gd_characters` SET Character_Gender = @CharacterGender WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterGender'] = Gender
		})

		MySQL.Async.execute('UPDATE `gd_characters` SET Character_DepJob = @CharacterDept WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterDept'] = Dept
		})

		local CharacterJobName = MySQL.Sync.fetchScalar('SELECT Character_JobName FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId 
		})
		
		if CharacterJobName == nil then
			MySQL.Async.execute('UPDATE `gd_characters` SET Character_JobName = @JobName WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
				['@characterID'] = CharacterID, 
				['@steamID'] = steamId,
				['@JobName'] = "UNEMPLOYED"
			})
		end
	else
		MySQL.Async.execute('UPDATE `gd_characters` SET Character_Name = @CharacterName WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterName'] = Full_Name
		})

		MySQL.Async.execute('UPDATE `gd_characters` SET Character_FName = @CharacterFName WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterFName'] = FirstName
		})

		MySQL.Async.execute('UPDATE `gd_characters` SET Character_LName = @CharacterLName WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterLName'] = LastName
		})

		MySQL.Async.execute('UPDATE `gd_characters` SET Character_DOB = @CharacterDOB WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterDOB'] = date1
		})

		MySQL.Async.execute('UPDATE `gd_characters` SET Character_Gender = @CharacterGender WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterGender'] = Gender
		})

		MySQL.Async.execute('UPDATE `gd_characters` SET Character_DepJob = @CharacterDept WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId,
			['@CharacterDept'] = Dept
		})

		local CharacterJobName = MySQL.Sync.fetchScalar('SELECT Character_JobName FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { 
			['@characterID'] = CharacterID, 
			['@steamID'] = steamId 
		})
		
		if CharacterJobName ~= nil then
			MySQL.Async.execute('UPDATE `gd_characters` SET Character_JobName = @JobName WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID', { 
				['@characterID'] = CharacterID, 
				['@steamID'] = steamId,
				['@JobName'] = nil
			})
		end
	end

	Wait(1000)

	MySQL.Async.fetchAll('SELECT Character_ID, Character_Name, Character_Gender, Character_DepJob FROM `gd_characters` WHERE `Character_PlayerSteamHEX` = @steamID', { ['@steamID'] = steamId }, function(AllPlayerCharacters)
		local AllCharacters = (json.encode(AllPlayerCharacters))

		TriggerClientEvent('golden:framework:stopCharacterSaving', src, AllCharacters)
	end)
end)

RegisterServerEvent("golden:framework:getPlayerCharacters")
AddEventHandler("golden:framework:getPlayerCharacters", function()
	local src = source
	
	local steamId1 = GetPlayerIdentifiers(src)[1]
	local steamId = steamId1:gsub("steam:", "")

	MySQL.Async.fetchAll('SELECT Character_ID, Character_Name, Character_Gender, Character_DepJob FROM `gd_characters` WHERE `Character_PlayerSteamHEX` = @steamID', { ['@steamID'] = steamId }, function(AllPlayerCharacters)
		local AllCharacters = (json.encode(AllPlayerCharacters))

		TriggerClientEvent('golden:framework:sendPlayerCharacters', src, AllCharacters)
	end)
end)

RegisterServerEvent("golden:framework:getCharacterInfoEdit")
AddEventHandler("golden:framework:getCharacterInfoEdit", function(characterID)
	local src = source
	
	local steamId1 = GetPlayerIdentifiers(src)[1]
	local steamId = steamId1:gsub("steam:", "")

	local CharacterFName = MySQL.Sync.fetchScalar('SELECT Character_FName FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { ['@characterID'] = characterID, ['@steamID'] = steamId })
	local CharacterLName = MySQL.Sync.fetchScalar('SELECT Character_LName FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { ['@characterID'] = characterID, ['@steamID'] = steamId })
	local CharacterGender = MySQL.Sync.fetchScalar('SELECT Character_Gender FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { ['@characterID'] = characterID, ['@steamID'] = steamId })
	local CharacterDepJob = MySQL.Sync.fetchScalar('SELECT Character_DepJob FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { ['@characterID'] = characterID, ['@steamID'] = steamId })
	local CharacterDOB = MySQL.Sync.fetchScalar('SELECT DATE_FORMAT(Character_DOB, "%m/%d/%Y") FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { ['@characterID'] = characterID, ['@steamID'] = steamId })

	TriggerClientEvent('golden:framework:sendEditCharacterInfo', src, characterID, CharacterFName, CharacterLName, CharacterGender, CharacterDepJob, CharacterDOB)
end)

RegisterServerEvent("golden:framework:setAsActiveCharacter")
AddEventHandler("golden:framework:setAsActiveCharacter", function(characterID)
	local src = source

	local steamId1 = GetPlayerIdentifiers(src)[1]
	local steamId = steamId1:gsub("steam:", "")

	MySQL.Async.execute('UPDATE `gd_players` SET Player_ActiveCharacterID = @activeCharacter WHERE `Player_SteamHEX` = @steamID', { 
		['@activeCharacter'] = characterID, 
		['@steamID'] = steamId 
	})

	local CharacterName = MySQL.Sync.fetchScalar('SELECT Character_Name FROM `gd_characters` WHERE `Character_ID` = @characterID LIMIT 1', { 
		['@characterID'] = characterID 
	})

	local CharacterBank = MySQL.Sync.fetchScalar('SELECT Character_Bank FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { 
		['@characterID'] = CharacterID, 
		['@steamID'] = steamId 
	})
	
	local CharacterCash = MySQL.Sync.fetchScalar('SELECT Character_Cash FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { 
		['@characterID'] = CharacterID, 
		['@steamID'] = steamId 
	})

	TriggerClientEvent("golden:framework:notification:send", src, "characterSystem", "Framework", 'Your now playing as: <b>' .. CharacterName .. '</b>')
end)

RegisterServerEvent("golden:framework:getCharactersMoney")
AddEventHandler("golden:framework:getCharactersMoney", function()
	local src = source

	local steamId1 = GetPlayerIdentifiers(src)[1]
	local steamId = steamId1:gsub("steam:", "")

	local ActiveCharacterID = MySQL.Sync.fetchScalar('SELECT Player_ActiveCharacterID FROM `gd_players` WHERE `Player_SteamHEX` = @steamID LIMIT 1', { 
		['@steamID'] = steamId 
	})

	local CharacterBank = MySQL.Sync.fetchScalar('SELECT Character_Bank FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { 
		['@characterID'] = ActiveCharacterID, 
		['@steamID'] = steamId 
	})
	
	local CharacterCash = MySQL.Sync.fetchScalar('SELECT Character_Cash FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { 
		['@characterID'] = ActiveCharacterID, 
		['@steamID'] = steamId 
	})

	TriggerClientEvent('golden:framework:setCharacterMoneyHUD', src, CharacterBank, CharacterCash)
end)

RegisterServerEvent("golden:framework:refreshCharactersMoney")
AddEventHandler("golden:framework:refreshCharactersMoney", function()
	local src = source

	local steamId1 = GetPlayerIdentifiers(src)[1]
	local steamId = steamId1:gsub("steam:", "")

	local ActiveCharacterID = MySQL.Sync.fetchScalar('SELECT Player_ActiveCharacterID FROM `gd_players` WHERE `Player_SteamHEX` = @steamID LIMIT 1', { 
		['@steamID'] = steamId 
	})

	local CharacterBank = MySQL.Sync.fetchScalar('SELECT Character_Bank FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { 
		['@characterID'] = ActiveCharacterID, 
		['@steamID'] = steamId 
	})
	
	local CharacterCash = MySQL.Sync.fetchScalar('SELECT Character_Cash FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { 
		['@characterID'] = ActiveCharacterID, 
		['@steamID'] = steamId 
	})

	TriggerClientEvent('golden:framework:setCharactersBankHUD', src, CharacterBank, CharacterCash)
end)

RegisterServerEvent("golden:framework:getPlayerDepData")
AddEventHandler("golden:framework:getPlayerDepData", function()
	local src = source

	local steamId1 = GetPlayerIdentifiers(src)[1]
	local steamId = steamId1:gsub("steam:", "")

	MySQL.Async.fetchAll('SELECT Player_CanAccessLSPD, Player_CanAccessBCSO, Player_CanAccessSAHP, Player_CanAccessLSFD, Player_CanAccessEMS, Player_CanAccessCIV FROM `gd_players` WHERE `Player_SteamHEX` = @steamID', { 
		['@steamID'] = steamId 
	}, function(PlayerDepData)
	   local AllPlayerDepData = (json.encode(PlayerDepData))

	   TriggerClientEvent('golden:framework:sendPlayerDepartmentData', src, AllPlayerDepData)
	end)
end)

-- Whitelisting --
AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local src = source

    deferrals.defer()
    deferrals.update("Checking Database...")

    local steamId1 = GetPlayerIdentifiers(src)[1]
	local steamId = steamId1:gsub("steam:", "")

	local PlayerName = GetPlayerName(src)

	local doesExist = MySQL.Sync.fetchScalar('SELECT COUNT(*) FROM `gd_players` WHERE `Player_SteamHEX` = @steamID LIMIT 1', {
		['@steamID'] = steamId
	})
	
	Wait(2000)
	
	if string.starts(steamId1, "steam:") then
		if doesExist == 1 then
			if Config.Core.enableWhitelist then
				local PlayerWhitelisted = MySQL.Sync.fetchScalar('SELECT Player_Whitelisted FROM `gd_players` WHERE `Player_SteamHEX` = @steamID LIMIT 1', { 
					['@steamID'] = steamId 
				})
				Wait(1000)
				if PlayerWhitelisted == "true" then
					deferrals.done()
				else
					deferrals.done("Whitelist: You do not have permission to be in this server. If this is an error, Please contact Xd_Golden_Tiger#9681 on discord!")
				end
			else
				deferrals.done()
			end
		else
			MySQL.Sync.execute('INSERT INTO `gd_players` (`Player_SteamHEX`, `Player_Name`) VALUES (@steamID, @playerName)', {
				['@steamID'] = steamId,
				['@playerName'] = PlayerName
			})
			Wait(2000)

			if Config.Core.enableWhitelist then
				local PlayerWhitelisted = MySQL.Sync.fetchScalar('SELECT Player_Whitelisted FROM `gd_players` WHERE `Player_SteamHEX` = @steamID LIMIT 1', { 
					['@steamID'] = steamId 
				})
				Wait(1000)
				if PlayerWhitelisted == "true" then
					deferrals.done()
				else
					deferrals.done("Whitelist: You do not have permission to be in this server. If this is an error, Please contact Xd_Golden_Tiger#0001 on discord!")
				end
			else
				deferrals.done()
			end
		end
	else
		deferrals.done("You must have steam open in order to play in our server. Golden Framework is using Steam for the Identifier system.")
	end
end)

-- Banking Stuff --
RegisterServerEvent("golden:framework:payCheckInterval")
AddEventHandler("golden:framework:payCheckInterval", function()
	local src = source

	local steamId1 = GetPlayerIdentifiers(src)[1]
	local steamId = steamId1:gsub("steam:", "")

	local ActiveCharacterID = MySQL.Sync.fetchScalar('SELECT Player_ActiveCharacterID FROM `gd_players` WHERE `Player_SteamHEX` = @steamID LIMIT 1', { 
		['@steamID'] = steamId 
	})

	if ActiveChar ~= 0 then
		local CharacterDepartment = MySQL.Sync.fetchScalar('SELECT Character_DepJob FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { 
			['@characterID'] = ActiveCharacterID, 
			['@steamID'] = steamId 
		})

		if CharacterDepartment == "CIV" then
			local CharacterJobName = MySQL.Sync.fetchScalar('SELECT Character_JobName FROM `gd_characters` WHERE `Character_ID` = @characterID AND `Character_PlayerSteamHEX` = @steamID LIMIT 1', { 
				['@characterID'] = ActiveCharacterID, 
				['@steamID'] = steamId 
			})

			if CharacterJobName == "UNEMPLOYED" then
				local ConfigDepartmentData = Config.DepartmentsList.DEPARTMENTS[CharacterDepartment]
				local CharacterPayCheckAmount = ConfigDepartmentData.payCheck
				local CharacterPayCheckMessage = ConfigDepartmentData.payCheckMsg
				local PlayerBank = MySQL.Sync.fetchScalar('SELECT Character_Bank FROM `gd_characters` WHERE `Character_ID` = @charID LIMIT 1', { ['@charID'] = ActiveCharacterID })
				local newBankBalance = PlayerBank + tonumber(CharacterPayCheckAmount)

				MySQL.Async.execute('UPDATE `gd_characters` SET Character_Bank = @CharBank WHERE `Character_ID` = @charID LIMIT 1', { ['@CharBank'] = newBankBalance, ['@charID'] = ActiveCharacterID })
				TriggerClientEvent("golden:framework:notification:send", src, "bankingSystem", "Pay Check", string.format(CharacterPayCheckMessage, CharacterPayCheckAmount))
			else
				local ConfigJobData = Config.DepartmentsList.JOBS[CharacterJobName]
				local CharacterPayCheckAmount = ConfigJobData.payCheck
				local CharacterPayCheckMessage = ConfigJobData.payCheckMsg
				local PlayerBank = MySQL.Sync.fetchScalar('SELECT Character_Bank FROM `gd_characters` WHERE `Character_ID` = @charID LIMIT 1', { ['@charID'] = ActiveCharacterID })
				local newBankBalance = PlayerBank + tonumber(CharacterPayCheckAmount)

				MySQL.Async.execute('UPDATE `gd_characters` SET Character_Bank = @CharBank WHERE `Character_ID` = @charID LIMIT 1', { ['@CharBank'] = newBankBalance, ['@charID'] = ActiveCharacterID })
				TriggerClientEvent("golden:framework:notification:send", src, "bankingSystem", "Pay Check", string.format(CharacterPayCheckMessage, CharacterPayCheckAmount))
			end
		else
			local ConfigDepartmentData = Config.DepartmentsList.DEPARTMENTS[CharacterDepartment]
			local CharacterPayCheckAmount = ConfigDepartmentData.payCheck
			local CharacterPayCheckMessage = ConfigDepartmentData.payCheckMsg
			local PlayerBank = MySQL.Sync.fetchScalar('SELECT Character_Bank FROM `gd_characters` WHERE `Character_ID` = @charID LIMIT 1', { ['@charID'] = ActiveCharacterID })
			local newBankBalance = PlayerBank + tonumber(CharacterPayCheckAmount)
			
			MySQL.Async.execute('UPDATE `gd_characters` SET Character_Bank = @CharBank WHERE `Character_ID` = @charID LIMIT 1', { ['@CharBank'] = newBankBalance, ['@charID'] = ActiveCharacterID })
			TriggerClientEvent("golden:framework:notification:send", src, "bankingSystem", "Pay Check", string.format(CharacterPayCheckMessage, CharacterPayCheckAmount))
		end
	end
end)