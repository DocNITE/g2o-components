StaminaSystem <- {
    /**
     * @public
     * @description show ui bar on screen
     */
    showStaminaBar = false,

    /**
     * @public
     * @description show time for stamina before hide. Set '-1' if want infinity time
     */
    time = 1000
};

/**
 * @public
 * @description show stamina bar, when it's changed
 *
 * @param {StaminaData} data local player's stamina data
 */
function StaminaSystem::onChanged(data) {

}
addEventHandler ("onStaminaChanged", StaminaSystem.onChanged);

/**
 * @public
 * @description draw stamina ui bar. You can override it like 'StaminaSystem.onRender = function () {}' for custom drawing
 */
function StaminaSystem::onRender() {

}
addEventHandler ("onRender", StaminaSystem.onRender);