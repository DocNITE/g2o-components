StaminaSystem <- {
    /**
     * @public
     * @description should we save our data everytime?
     */
    autosave = true,

    /**
     * @public
     * @description should we load data every server start?
     */
    autoload = true,

    /**
     * @public
     * @description timer beetwen saves
     */
    timer = 900000
}

/**
 * @public
 * @description save all stamina data from server to database. Actualy use for onExit()
 */
function StaminaSystem::saveRequest() {
    callEvent("onStaminaDataSaveRequest");
}

/**
 * @public
 * @description load all stamina database to server. Actualy used for onInit()
 */
function StaminaSystem::loadRequest() {
    callEvent("onStaminaDataLoadRequest");
}

/**
 * @public
 * @description load stamina values from save data for specific player
 *
 * @param {int} player_id player id
 * @param {string} data_id stamina data base save id. You can put there player's name.
 */
function StaminaSystem::loadDataRequest(player_id, data_id) {
    callEvent("onStaminaDataRequest", player_id, data_id);
}

/**
 * @public
 * @description sets stamina value for specific player
 *
 * @param {int} player_id player id
 * @param {int} value value what we want
 */
function StaminaSystem::setValue(player_id, value) {
    foreach (stamina in StaminaData.getAllData()) {
        if (stamina.ownerId == player_id) {
            stamina.setValue(value);
        }
    }
}

/**
 * @public
 * @description sets max stamina value for specific player
 *
 * @param {int} player_id player id
 * @param {int} value value what we want
 */
function StaminaSystem::setMaxValue(player_id, value) {
    foreach (stamina in StaminaData.getAllData()) {
        if (stamina.ownerId == player_id) {
            stamina.setMaxValue(value);
        }
    }
}


/**
 * @public
 * @description get stamina value from specific player
 *
 * @param {int} player_id player id
 */
function StaminaSystem::getValue(player_id) {
    foreach (stamina in StaminaData.getAllData()) {
        if (stamina.ownerId == player_id) {
            return stamina.value;
        }
    }
}

/**
 * @public
 * @description get maximum stamina value from specific player
 *
 * @param {int} player_id player id
 */
function StaminaSystem::getMaxValue(player_id) {
    foreach (stamina in StaminaData.getAllData()) {
        if (stamina.ownerId == player_id) {
            return stamina.maxValue;
        }
    }
}


/**
 * @private
 * @description default events for initialization stamina data
 */
addEventHandler ("onInit", function () {
    if (StaminaSystem.autoload)
        StaminaSystem.loadRequest();
});
/**
 * @private
 * @description default events for saving stamina data
 */
addEventHandler ("onExit", function () {
    if (StaminaSystem.autosave)
        StaminaSystem.saveRequest();
});