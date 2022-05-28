CREATE TABLE IF NOT EXISTS `gd_characters` (
  `Character_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_Name` varchar(255) DEFAULT NULL,
  `Character_FName` varchar(255) DEFAULT NULL,
  `Character_LName` varchar(255) DEFAULT NULL,
  `Character_Gender` varchar(255) DEFAULT NULL,
  `Character_DOB` date DEFAULT NULL,
  `Character_DepJob` varchar(255) DEFAULT NULL,
  `Character_JobName` varchar(255) DEFAULT NULL,
  `Character_Bank` float DEFAULT NULL,
  `Character_Cash` float DEFAULT NULL,
  `Character_PhoneNo` varchar(255) DEFAULT NULL,
  `Character_PlayerSteamHEX` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Character_ID`),
  KEY `Character_PlayerSteamHEX` (`Character_PlayerSteamHEX`),
  KEY `Character_FName` (`Character_FName`),
  KEY `Character_LName` (`Character_LName`),
  KEY `Character_DepJob` (`Character_DepJob`),
  KEY `Character_PhoneNo` (`Character_PhoneNo`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `gd_players` (
  `Player_SteamHEX` varchar(255) DEFAULT NULL,
  `Player_Name` varchar(255) DEFAULT NULL,
  `Player_isStaff` varchar(255) DEFAULT 'false',
  `Player_CanAccessLSPD` varchar(255) DEFAULT 'false',
  `Player_CanAccessBCSO` varchar(255) DEFAULT 'false',
  `Player_CanAccessSAHP` varchar(255) DEFAULT 'false',
  `Player_CanAccessLSFD` varchar(255) DEFAULT 'false',
  `Player_CanAccessEMS` varchar(255) DEFAULT 'false',
  `Player_CanAccessCIV` varchar(255) DEFAULT 'false',
  `Player_Whitelisted` varchar(255) DEFAULT 'false',
  `Player_ActiveCharacterID` varchar(255) DEFAULT '0',
  KEY `steam_id` (`Player_SteamHEX`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;