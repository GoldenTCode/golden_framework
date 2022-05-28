-- Golden Framework --

local isLoaded = false
local showHud = true
local isCharacterSelected = false

CreateThread(function()
	while true do
        Wait(0)
		if Config.Core.neverWanted then
        	if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            	SetPlayerWantedLevel(PlayerId(), 0, false)
            	SetPlayerWantedLevelNow(PlayerId(), false)
        	end
		end
	end
end)

CreateThread(function()
	while true do
		if not isLoaded then
			loadInPlayerDepartmentData()
			selectCharacter()

			isLoaded = true
		end
		
		if IsPauseMenuActive() then
			SendNUIMessage({
				type = 'toggleBodyDisplay',
				toggleShow = false
			})
		else
			SendNUIMessage({
				type = 'toggleBodyDisplay',
				toggleShow = true
			})
		end
		
		Wait(1000)
	end
end)

CreateThread(function()
	while true do
        Wait(3000)

		if isCharacterSelected then
			TriggerServerEvent("golden:framework:refreshCharactersMoney")
		end
	end
end)

AddEventHandler("playerSpawned", function()
	if Config.Core.enablePvP then
    	NetworkSetFriendlyFireOption(true)
    	SetCanAttackFriendly(PlayerPedId(), true, true)
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end

	if (GetCurrentResourceName() ~= "golden_framework") then
		print("The frameworks resource name MUST be `golden_framework`, Or else the resource will not function properly.")
	end
end)

AddEventHandler('onClientMapStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end

	TriggerEvent('chat:addTemplate', 'bankingTemplate', '<div style="font-size: 16.5px; padding: 7px; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.5); border-radius: 3px;"><center>{1}</center></div>')
	TriggerEvent('chat:addTemplate', 'characterTemplate', '<div style="font-size: 16.5px; padding: 7px; margin: 0.5vw; background-color: rgba(255, 128, 0, 0.5); border-radius: 3px;"><center>{1}</center></div>')
	TriggerEvent('chat:addTemplate', 'phoneTemplate', '<div style="font-size: 16.5px; padding: 7px; margin: 0.5vw; background-color: rgba(235, 52, 52, 0.5); border-radius: 3px;"><center>{1}</center></div>')
end)

CreateThread(function()
	RemoveMultiplayerHudCash(0x968F270E39141ECA)
    RemoveMultiplayerBankCash(0xC7C6789AA1CFEDD0)
end)

RegisterNUICallback('QuitGame', function()
	SendNUIMessage({type = 'closeAllUI'})
	SetNuiFocus(false, false)
	
	QuitGame()
end)

-- Character Stuff --
RegisterNetEvent("golden:framework:sendPlayerCharacters")
AddEventHandler("golden:framework:sendPlayerCharacters", function (AllCharacters)
	getCharacters = json.decode(AllCharacters)

	SendNUIMessage({
		type = 'getPlayerCharacters',
		data = getCharacters
	})

	SetNuiFocus(true, true)
	SendNUIMessage({type = 'characterOpenUI'})
	FreezeEntityPosition(PlayerPedId(), true)
end)

RegisterNetEvent("golden:framework:sendPlayerDepartmentData")
AddEventHandler("golden:framework:sendPlayerDepartmentData", function (AllDepData)
	getDepData = json.decode(AllDepData)

	SendNUIMessage({
		type = 'getPlayerDepartmentData',
		data = getDepData
	})
	
	SendNUIMessage({
		type = 'loadInConfigToUI',
		serverName = Config.Core.serverLongName,
		characterBackground = Config.Core.characterBackground
	})
end)

RegisterNetEvent("golden:framework:sendCreatedCharacterInfo")
AddEventHandler("golden:framework:sendCreatedCharacterInfo", function (CharacterID, CharacterName, CharacterGender, CharacterDepJob)
	SendNUIMessage({
		type = 'addNewCharacterToList',
		data_ID = CharacterID,
		data_NAME = CharacterName,
		data_GENDER = CharacterGender,
		data_DEPJOB = CharacterDepJob
	})
	
	SendNUIMessage({
		type = 'characterLoadingToggle',
		action = 'creatingCharacter',
		toggle = false
	})
end)

RegisterNetEvent("golden:framework:sendEditCharacterInfo")
AddEventHandler("golden:framework:sendEditCharacterInfo", function (CharacterID, CharacterFName, CharacterLName, CharacterGender, CharacterDepJob, CharacterDOB)
	SendNUIMessage({
		type = 'characterLoadingToggle',
		action = 'loadingCharacterData',
		toggle = false
	})

	SendNUIMessage({
		type = 'addEditCharacterToModal',
		data_ID = CharacterID,
		data_FNAME = CharacterFName,
		data_LNAME = CharacterLName,
		data_GENDER = CharacterGender,
		data_DEPJOB = CharacterDepJob,
		data_DOB = CharacterDOB
	})
end)

RegisterNetEvent("golden:framework:stopCharacterSaving")
AddEventHandler("golden:framework:stopCharacterSaving", function (AllCharacters)
	Wait(5000)
	
	getCharacters = json.decode(AllCharacters)

	SendNUIMessage({
		type = 'getPlayerCharacters',
		data = getCharacters
	})

	SendNUIMessage({
		type = 'characterLoadingToggle',
		action = 'savingCharacter',
		toggle = false
	})
end)

RegisterNUICallback('CreateCharacter', function(data)
	SendNUIMessage({
		type = 'characterLoadingToggle',
		action = 'creatingCharacter',
		toggle = true
	})

	TriggerServerEvent("golden:framework:createCharacter", data.FirstName, data.LastName, data.DOB, data.Gender, data.Dept, data.StartMoney, data.PhoneNumber)
end)

RegisterNUICallback('SelectedCharacter', function(data)
	TriggerServerEvent("golden:framework:setAsActiveCharacter", data.characterID)
	
	SendNUIMessage({
		type = 'characterLoadingToggle',
		action = 'loadingCharacter',
		toggle = true
	})

	Wait(2000)
	
	TriggerServerEvent("golden:framework:getCharactersMoney")
end)

RegisterNUICallback('EditCharacterBtn', function(data)
	SendNUIMessage({
		type = 'characterLoadingToggle',
		action = 'loadingCharacterData',
		toggle = true
	})

	TriggerServerEvent("golden:framework:getCharacterInfoEdit", data.characterID)
end)

RegisterNUICallback('EditCharacter', function(data)
	SendNUIMessage({
		type = 'characterLoadingToggle',
		action = 'savingCharacter',
		toggle = true
	})

	TriggerServerEvent("golden:framework:saveCharacterEdit", data.ID, data.FirstName, data.LastName, data.DOB, data.Gender, data.Dept)
end)

RegisterCommand("selectcharacter", function(source, args, raw)
	selectCharacter()
end)

-- Banking Stuff --
local bankUIOpen = false

RegisterNetEvent("golden:framework:payCheckToggle")
AddEventHandler("golden:framework:payCheckToggle", function(togglePayCheck)
	if togglePayCheck == "changingCharacter" then
		isCharacterSelected = false
	elseif togglePayCheck == "selectedCharacter" then
		isCharacterSelected = true
		
		StartPayCheck()
	end
end)

StartPayCheck = function()
	CreateThread(function()
		while true do
			if isCharacterSelected == false then 
				return
			end
			
			Wait(Config.BankingSystem.paycheckInterval)
			
			TriggerServerEvent("golden:framework:payCheckInterval")
		end
	end)
end

RegisterNetEvent("golden:framework:setCharactersBankHUD")
AddEventHandler("golden:framework:setCharactersBankHUD", function(Bank, Cash)
	SendNUIMessage({
		type = 'addCharactersMoneyToHUD',
		data_BANK = Bank,
		data_CASH = Cash
	})
end)

RegisterCommand("togglemoney", function(source, args, raw)
	showHud = not showHud
	
	if showHud then
		SendNUIMessage({
			type = 'showMoneyHUD',
			toggle = true
		})
	elseif showHud == false then
		SendNUIMessage({
			type = 'showMoneyHUD',
			toggle = false
		})
	else
		SendNUIMessage({
			type = 'showMoneyHUD',
			toggle = true
		})
	end
end)

RegisterNetEvent("golden:framework:setCharacterMoneyHUD")
AddEventHandler("golden:framework:setCharacterMoneyHUD", function(Bank, Cash)
	SendNUIMessage({
		type = 'addCharactersMoneyToHUD',
		data_BANK = Bank,
		data_CASH = Cash
	})

	SendNUIMessage({
		type = 'characterLoadingToggle',
		action = 'loadingCharacter',
		toggle = false
	})

	SendNUIMessage({type = 'characterCloseUI'})
	SetNuiFocus(false, false)
	FreezeEntityPosition(PlayerPedId(), false)
	
	TriggerEvent("golden:framework:payCheckToggle", "selectedCharacter")
end)

-- Notifications --
RegisterNetEvent("golden:framework:notification:send")
AddEventHandler("golden:framework:notification:send", function(notificationType, notificationTitle, notificationMessage)
	if not IsPauseMenuActive() then
		SendNUIMessage({
        	createNotification = true,
        	dataType = notificationType,
			dataTitle = notificationTitle,
			dataMessage = notificationMessage
   	 	})
	end
end)