StaminaSystem <- {
    // Should we save our data everytime?
    autosave = true,
    // Timer beetween saves
    timer = 900000
}

function StaminaSystem::saveRequest() {
    callEvent("onStaminaDataSaveRequest");
}

function StaminaSystem::loadRequest() {
    callEvent("onStaminaDataLoadRequest");
}

function StaminaSystem::loadDataRequest(playerid, playerName) {
    callEvent("onStaminaDataRequest", playerid, playerName);
}

function StaminaSystem::setValue(playerid, value) {
    foreach (stamina in StaminaData.getAllData()) {
        if (stamina.ownerId == playerid) {
            stamina.setValue(value);
        }
    }
}

function StaminaSystem::setMaxValue(playerid, value) {
    foreach (stamina in StaminaData.getAllData()) {
        if (stamina.ownerId == playerid) {
            stamina.setMaxValue(value);
        }
    }
}

function StaminaSystem::getValue(playerid) {
    foreach (stamina in StaminaData.getAllData()) {
        if (stamina.ownerId == playerid) {
            return stamina.value;
        }
    }
}

function StaminaSystem::getMaxValue(playerid) {
    foreach (stamina in StaminaData.getAllData()) {
        if (stamina.ownerId == playerid) {
            return stamina.maxValue;
        }
    }
}

addEventHandler ("onInit", StaminaSystem.loadRequest);
addEventHandler ("onExit", StaminaSystem.saveRequest);