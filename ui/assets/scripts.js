// Golden Framework //

var resourceUrl = "https://golden_framework/";

var whitelistedDepartment_LSPD = false;
var whitelistedDepartment_BCSO = false;
var whitelistedDepartment_SAHP = false;
var whitelistedDepartment_LSFD = false;
var whitelistedDepartment_EMS = false;
var whitelistedDepartment_CIV = false;

var phoneVolume = 0;
var getCharacters;
var firstLoad = true;

$(document).ready(function() {
    window.addEventListener('message', function(event) {
        var framework = event.data;

        if (framework.type === "loadInConfigToUI") {
            $(".characterUI-BG").attr("style", "display: block; position: absolute; width: 100%; height: 100%; background-size: cover; background-repeat: no-repeat; background-image: url('" + framework.characterBackground + "') !important;");
            $(".characterTextTitle").text(framework.serverName);

            $(".bodyClass").css("display", "block");
        } else if (framework.type === "characterOpenUI") {
            $(".showMoneyUI").css("display", "none");
            $(".bankingUI").css("display", "none");
            $(".characterUI-BG").css("display", "block");
        } else if (framework.type === "characterCloseUI") {
            $(".showMoneyUI").css("display", "block");
            $(".bankingUI").css("display", "block");
            $(".characterUI-BG").css("display", "none");
        } else if (framework.type === "getPlayerCharacters") {
            getCharacters = framework.data;
            $(".characterList").empty();

            if (getCharacters != null) {
                for (var i = 0; i < getCharacters.length; i++) {
                    if (getCharacters[i].Character_Gender == "Male") {
                        $(".characterList").append('<li class="characterListItem"><button class="ui inverted violet labeled icon button" type="button" style="min-width: 325px;" onclick="selectedCharacter('+ getCharacters[i].Character_ID +')"><i class="icon user" style="color:aqua;"></i><span style="color: white;">Play as: &nbsp; &nbsp; </span><b>'+ getCharacters[i].Character_Name +'</b> &nbsp; &nbsp; <span style="color: white;">( <b>'+ getCharacters[i].Character_DepJob +'</b> )</span></button><button class="ui inverted primary button" type="button" onclick="editCharacter('+ getCharacters[i].Character_ID +')" style="margin-left: 5px">Edit</button></li>');
                    } else if (getCharacters[i].Character_Gender == "Female") {
                        $(".characterList").append('<li class="characterListItem"><button class="ui inverted violet labeled icon button" type="button" style="min-width: 325px;" onclick="selectedCharacter('+ getCharacters[i].Character_ID +')"><i class="icon user" style="color:pink;"></i><span style="color: white;">Play as: &nbsp; &nbsp; </span><b>'+ getCharacters[i].Character_Name +'</b> &nbsp; &nbsp; <span style="color: white;">( <b>'+ getCharacters[i].Character_DepJob +'</b> )</span></button><button class="ui inverted primary button" type="button" onclick="editCharacter('+ getCharacters[i].Character_ID +')" style="margin-left: 5px">Edit</button></li>');
                    }
                }
            }
        } else if (framework.type === "addNewCharacterToList") {
            newPlayerCharacterID = framework.data_ID;
            newPlayerCharacterNAME = framework.data_NAME;
            newPlayerCharacterGENDER = framework.data_GENDER;
            newPlayerCharacterDEPJOB = framework.data_DEPJOB;

            if (newPlayerCharacterGENDER == "Male") {
                $(".characterList").append('<li class="characterListItem"><button class="ui inverted violet labeled icon button" type="button" style="min-width: 325px;" onclick="selectedCharacter('+ newPlayerCharacterID +')"><i class="icon user" style="color:aqua;"></i><span style="color: white;">Play as: &nbsp; &nbsp; </span><b>'+ newPlayerCharacterNAME +'</b> &nbsp; &nbsp; <span style="color: white;">( <b>'+ newPlayerCharacterDEPJOB +'</b> )</span></button><button class="ui inverted primary button" type="button" onclick="editCharacter('+ newPlayerCharacterID +')" style="margin-left: 5px">Edit</button></li>');
            } else if (newPlayerCharacterGENDER == "Female") {
                $(".characterList").append('<li class="characterListItem"><button class="ui inverted violet labeled icon button" type="button" style="min-width: 325px;" onclick="selectedCharacter('+ newPlayerCharacterID +')"><i class="icon user" style="color:pink;"></i><span style="color: white;">Play as: &nbsp; &nbsp; </span><b>'+ newPlayerCharacterNAME +'</b> &nbsp; &nbsp; <span style="color: white;">( <b>'+ newPlayerCharacterDEPJOB +'</b> )</span></button><button class="ui inverted primary button" type="button" onclick="editCharacter('+ newPlayerCharacterID +')" style="margin-left: 5px">Edit</button></li>');
            }
        } else if (framework.type === "characterLoadingToggle") {
            if (framework.action == "creatingCharacter") {
                if (framework.toggle == true) {
                    $('#characterLoading1').addClass("active");
                } else if (framework.toggle == false) {
                    $('#characterLoading1').removeClass("active");
                }
            } else if (framework.action == "loadingCharacter") {
                if (framework.toggle == true) {
                    $('#characterLoading2').addClass("active");
                } else if (framework.toggle == false) {
                    $('#characterLoading2').removeClass("active");
                }
            } else if (framework.action == "savingCharacter") {
                if (framework.toggle == true) {
                    $('#characterSaving').addClass("active");
                } else if (framework.toggle == false) {
                    $('#characterSaving').removeClass("active");
                }
            } else if (framework.action == "loadingCharacterData") {
                if (framework.toggle == true) {
                    $('#loadingCharacterData').addClass("active");
                } else if (framework.toggle == false) {
                    $('#loadingCharacterData').removeClass("active");
                }
            }
        } else if (framework.type === "showMoneyHUD") {
            if (framework.toggle == true) {
                $(".showMoneyUI").css("display", "block");
                $(".bankingUI").css("display", "block");
            } else if (framework.toggle == false) {
                $(".showMoneyUI").css("display", "none");
                $(".bankingUI").css("display", "none");
            }
        } else if (framework.type === "addCharactersMoneyToHUD") {
            playerCharactersBank = framework.data_BANK;
            playerCharactersCash = framework.data_CASH;
			newCharactersBank = separator(playerCharactersBank);
			newCharactersCash = separator(playerCharactersCash);

            $(".bankText").text(newCharactersBank);
            $(".cashText").text(newCharactersCash);
        } else if (framework.type === "getPlayerDepartmentData") {
            getDepData = framework.data;

            if (getDepData[0].Player_CanAccessLSPD == "true") {
                whitelistedDepartment_LSPD = true;
            } else {
                whitelistedDepartment_LSPD = false;
            }
            if (getDepData[0].Player_CanAccessBCSO == "true") {
                whitelistedDepartment_BCSO = true;
            } else {
                whitelistedDepartment_BCSO = false;
            }
            if (getDepData[0].Player_CanAccessSAHP == "true") {
                whitelistedDepartment_SAHP = true;
            } else {
                whitelistedDepartment_SAHP = false;
            }
            if (getDepData[0].Player_CanAccessLSFD == "true") {
                whitelistedDepartment_LSFD = true;
            } else {
                whitelistedDepartment_LSFD = false;
            }
            if (getDepData[0].Player_CanAccessEMS == "true") {
                whitelistedDepartment_EMS = true;
            } else {
                whitelistedDepartment_EMS = false;
            }
            if (getDepData[0].Player_CanAccessCIV == "true") {
                whitelistedDepartment_CIV = true;
            } else {
                whitelistedDepartment_CIV = false;
            }

            setupWhitelistedDepartments()
        } else if (framework.type === "closeAllUI") {
            $(".bodyClass").css("display", "none");
        } else if (framework.type === "addEditCharacterToModal") {
            addEditCharacterInfoToModal(framework.data_ID, framework.data_FNAME, framework.data_LNAME, framework.data_GENDER, framework.data_DEPJOB, framework.data_DOB);
        } else if (framework.type === "toggleBodyDisplay") {
            if (framework.toggleShow == true) {
                $(".bodyClass").css("display", "block");
            } else if (framework.toggleShow == false) {
                $(".bodyClass").css("display", "none");
            }
        }
    });
});

$('.ui.dropdown').dropdown();

// Character System //
$("#openCharacterCreationUI").click(function(){
    $(".characterCreationModal").modal({ closable: false }).modal("show");
});

$("#closeCharacterCreationUI").click(function(){
    $(".characterCreationForm").form("clear");
    $(".characterCreationModal").modal("hide");
});

$('#exitGame').click(function(){
    $.post(resourceUrl + 'QuitGame', JSON.stringify({}));
})

$("#createNewCharacter").click(function(){
    var characterCreationFormName = $(".characterCreationForm");
    var FName = characterCreationFormName.form("get value", "firstName");
    var LName = characterCreationFormName.form("get value", "lastName");
    var DoB = characterCreationFormName.form("get value", "dateOfBirth");
    var Gender = characterCreationFormName.form("get value", "gender");
    var Department = characterCreationFormName.form("get value", "department");
    var StartingMoney = characterCreationFormName.form("get value", "startingMoney");

    $(".characterCreationForm").form({
        fields: {
            firstName: 'empty',
            lastName: 'empty',
            dateOfBirth: 'regExp[/^(1[0-2]|0[1-9])/(3[01]|[12][0-9]|0[1-9])/[0-9]{4}$/]',
            gender: 'empty',
            department: 'empty',
            startingMoney: 'empty'
        },
        inline: true,
        on: 'blur'
    });

    if( $(".characterCreationForm").form("is valid")) {
        createNewCharacter(FName, LName, DoB, Gender, Department, StartingMoney);
    }
});

function createNewCharacter(FName, LName, DoB, Gender, Department, StartingMoney) {
    var OneToNine1 = Math.floor(Math.random() * 9) + 1;
    var OneToNine2 = Math.floor(Math.random() * 9) + 1;
    var OneToNine3 = Math.floor(Math.random() * 9) + 1;
    var OneToNine4 = Math.floor(Math.random() * 9) + 1;
    var OneToNine5 = Math.floor(Math.random() * 9) + 1;
    var OneToNine6 = Math.floor(Math.random() * 9) + 1;
    var ZeroToNine1 = Math.floor(Math.random() * 10);
    var ZeroToNine3 = Math.floor(Math.random() * 10);
    var ZeroToNine6 = Math.floor(Math.random() * 10);
    var PhoneNumberGen = "(213) " + OneToNine1 + ZeroToNine1 + OneToNine2 + "-" + OneToNine3 + ZeroToNine3 + OneToNine4 + OneToNine5 + ZeroToNine6 + OneToNine6;

    $.post(resourceUrl + 'CreateCharacter', JSON.stringify({
        FirstName: FName,
        LastName: LName,
        DOB: DoB,
        Gender: Gender,
        Dept: Department,
        StartMoney: StartingMoney,
        PhoneNumber: PhoneNumberGen
    }));

    $(".characterCreationForm").form("clear");
    $(".characterCreationModal").modal("hide");
}

function separator(numb) {
    var str = numb.toString().split(".");
    str[0] = str[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");

    return str.join(".");
}

function selectedCharacter(id) {
    $.post(resourceUrl + 'SelectedCharacter', JSON.stringify({
        characterID: id
    }));
}

function editCharacter(id) {
    $.post(resourceUrl + 'EditCharacterBtn', JSON.stringify({
        characterID: id
    }));
}

function addEditCharacterInfoToModal(ID, FNAME, LNAME, GENDER, DEPJOB, DOB) {
    var characterEditFormName = $(".characterEditForm");

    characterEditFormName.form("set values", {
        firstName: `${FNAME}`,
        lastName: `${LNAME}`,
        gender: `${GENDER}`,
        department: `${DEPJOB}`,
        dateOfBirth: `${DOB}`
    });

    $(".editIDText").text(ID);
    $('.characterEditModal').modal({ closable: false }).modal('show');
}

$("#closeCharacterEditUIBtn").click(function(){
    $(".characterEditForm").form("clear");
    $(".characterEditModal").modal("hide");
});

$("#editCharacterBtn").click(function(){
    var characterCreationFormName = $(".characterEditForm");
    var FName = characterCreationFormName.form("get value", "firstName");
    var LName = characterCreationFormName.form("get value", "lastName");
    var DoB = characterCreationFormName.form("get value", "dateOfBirth");
    var Gender = characterCreationFormName.form("get value", "gender");
    var Department = characterCreationFormName.form("get value", "department");
    var CharacterID = $(".editIDText").text();

    $(".characterEditForm").form({
        fields: {
            firstName: 'empty',
            lastName: 'empty',
            dateOfBirth: 'regExp[/^(1[0-2]|0[1-9])/(3[01]|[12][0-9]|0[1-9])/[0-9]{4}$/]',
            gender: 'empty',
            department: 'empty'
        },
        inline: true,
        on: 'blur'
    });

    if( $(".characterEditForm").form("is valid")) {
        $(".characterEditModal").modal("hide");

        saveEditCharacter(CharacterID, FName, LName, DoB, Gender, Department)
    }
});

function saveEditCharacter(CharacterID, FName, LName, DoB, Gender, Department) {
    $.post(resourceUrl + 'EditCharacter', JSON.stringify({
        ID: CharacterID,
        FirstName: FName,
        LastName: LName,
        DOB: DoB,
        Gender: Gender,
        Dept: Department
    }));

    $(".characterCreationForm").form("clear");
    $(".characterCreationModal").modal("hide");
}


// Department Whitelisting System //
function setupWhitelistedDepartments() {
    $("#departmentDropdown1").empty();
    $("#departmentDropdown2").empty();
	
    if (whitelistedDepartment_LSPD == true) {
        $("#departmentDropdown1").append('<div class="item" data-value="LSPD">Los Santos Police Department</div>');
        $("#departmentDropdown2").append('<div class="item" data-value="LSPD">Los Santos Police Department</div>');
    }

    if (whitelistedDepartment_BCSO == true) {
        $("#departmentDropdown1").append('<div class="item" data-value="BCSO">Blaine County Sheriffs Office</div>');
        $("#departmentDropdown2").append('<div class="item" data-value="BCSO">Blaine County Sheriffs Office</div>');
    }

    if (whitelistedDepartment_SAHP == true) {
        $("#departmentDropdown1").append('<div class="item" data-value="SAHP">San Andreas Highway Patrol</div>');
        $("#departmentDropdown2").append('<div class="item" data-value="SAHP">San Andreas Highway Patrol</div>');
    }

    if (whitelistedDepartment_LSFD == true) {
        $("#departmentDropdown1").append('<div class="item" data-value="LSFD">Los Santos Fire Department</div>');
        $("#departmentDropdown2").append('<div class="item" data-value="LSFD">Los Santos Fire Department</div>');
    }

    if (whitelistedDepartment_EMS == true) {
        $("#departmentDropdown1").append('<div class="item" data-value="EMS">Emergency Medical Services</div>');
        $("#departmentDropdown2").append('<div class="item" data-value="EMS">Emergency Medical Services</div>');
    }

    if (whitelistedDepartment_CIV == true) {
        $("#departmentDropdown1").append('<div class="item" data-value="CIV">Civilian Operations</div>');
        $("#departmentDropdown2").append('<div class="item" data-value="CIV">Civilian Operations</div>');
    }
	
	if( $('#departmentDropdown1').is(':empty') || $('#departmentDropdown2').is(':empty') ) {
		$(".departmentNullError").html("<h5 class='ui red header'>You are not whitelisted in any departments, If this is an error, Please contact an admin.</h5>");
	}
}

// Notifications //
const notificationTypes = { 
    ["successNotification"]: { ["icon"]: "icon check circle" },
    ["errorNotification"]: { ["icon"]: "icon exclamation triangle" },
    ["infoNotification"]: { ["icon"]: "icon info circle" },
    ["messageSystem"]: { ["icon"]: "icon comment alternate" },
    ["phoneSystem"]: { ["icon"]: "icon phone" },
    ["characterSystem"]: { ["icon"]: "icon user" },
	["bankingSystem"]: { ["icon"]: "icon dollar sign" }
};

$notificationCreate = function (notificationData) {  
    var notificationID = notificationData["notificationMessage"].length + 1;
    let notificationContent = $(
        `<div class="ui icon black hidden small message" id="${notificationID}" style="width: 100%;">
			<i class="${notificationTypes[notificationData.notificationType]["icon"]}"></i>
			<div class="content">
				<div class="header">
					${notificationData['notificationTitle']}
				</div>
				<p>${notificationData["notificationMessage"]}</p>
			</div>
		</div>`
    ).appendTo(`.notificationSystem`).transition('scale');
  
    setTimeout(() => {
        notificationContent.transition('scale');
    }, 10000);
  
    return notificationContent;
};

$(function () {
    window.addEventListener("message", function (event) {
        var framework = event.data;

        if (framework.createNotification === true) {
            $notificationCreate({
                notificationType: framework.dataType,
                notificationTitle: framework.dataTitle,
                notificationMessage: framework.dataMessage,
            });
        }
    });
});