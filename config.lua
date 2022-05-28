-- Golden Framework --

Config = {}


Config.Core = {
	-- This is used in the Character Selection UI.
    serverLongName = "Your Server Name (Config)",
	
	-- Used for the Character Selection Background. (E.g https://i.imgur.com/tWQva9x.jpg)
    characterBackground = "https://i.imgur.com/tWQva9x.jpg",
	
	-- Use the Frameworks built-in whitelist, Players cannot join the server unless they have been whitelisted via the `players` table of the database.
    enableWhitelist = true,
	
	-- Enable/Disable Player vs Player.
    enablePvP = true,
	
	-- Enable/Disable Never wanted for all players.
    neverWanted = true, 
	
	-- This is what will be used to interact with any proximated functions within the framework.
    nearestMarker = {
        command = "openui",
        keybindID = 38,
        keybindName = "INPUT_PICKUP"
    }
}


-- Work in Progress Banking System --
Config.BankingSystem = {
	-- Paycheck will run once every 30 minutes.
    paycheckInterval = 30 * 60000
}


-- Work in Progress: You cannot add/remove deps or edit the depName/depType, This will be fully working soon so you can add in more deps, etc... --
-- You can change the paycheck amount and the paycheck message (shows to the player in the chat.) --
Config.DepartmentsList = {
    DEPARTMENTS = {
        LSPD = {
            depName = "Los Santos Police Department",
            depType = "LEO",
            payCheck = 750,
            payCheckMsg = "You have received your <b>$%s</b> Daily Salary"
        },
        BCSO = {
            depName = "Blaine County Sheriffs Office",
            depType = "LEO",
            payCheck = 750,
            payCheckMsg = "You have received your <b>$%s</b> Daily Salary"
        },
        SAHP = {
            depName = "San Andreas Highway Patrol",
            depType = "LEO",
            payCheck = 750,
            payCheckMsg = "You have received your <b>$%s</b> Daily Salary"
        },
        LSFD = {
            depName = "Los Santos Fire Department",
            depType = "FIRE",
            payCheck = 600,
            payCheckMsg = "You have received your <b>$%s</b> Daily Salary"
        },
        EMS = {
            depName = "Emergency Medical Services",
            depType = "FIRE",
            payCheck = 600,
            payCheckMsg = "You have received your <b>$%s</b> Daily Salary"
        },
        CIV = {
            depName = "Civilian: Unemployed",
            depType = "CIVILIAN",
            payCheck = 250,
            payCheckMsg = "You have received your <b>$%s</b> Daily Benefits Paycheck"
        }
    },

    JOBS = {
        MECHANIC = {
            jobName = "Civilian: Mechanic",
            jobType = "CIVILIAN",
            payCheck = 400,
            payCheckMsg = "You have received your <b>$%s</b> Daily Salary"
        },
        DELIVERY = {
            jobName = "Civilian: Delivery Driver",
            jobType = "CIVILIAN",
            payCheck = 450,
            payCheckMsg = "You have received your <b>$%s</b> Daily Salary"
        },
        TRUCKER = {
            jobName = "Civilian: Truck Driver",
            jobType = "CIVILIAN",
            payCheck = 650,
            payCheckMsg = "You have received your <b>$%s</b> Daily Salary"
        },
        AMMUNATION = {
            jobName = "Civilian: Ammunation Worker",
            jobType = "CIVILIAN",
            payCheck = 500,
            payCheckMsg = "You have received your <b>$%s</b> Daily Salary"
        },
        STORECLERK = {
            jobName = "Civilian: 24/7 Clerk",
            jobType = "CIVILIAN",
            payCheck = 450,
            payCheckMsg = "You have received your <b>$%s</b> Daily Salary"
        }
    }
}