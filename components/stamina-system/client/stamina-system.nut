StaminaSystem <- {
    /**
     * @public
     * @description show ui bar on screen
     */
    showStaminaBar = false,

    /**
     * @public
     * @description show time for stamina before hide.
     */
    time = 10000
};

/**
 * @public
 * @description show stamina bar, when it's changed
 *
 * @param {StaminaData} data local player's stamina data
 */
function StaminaSystem::onChanged(data) {
    // for rendering
    StaminaSystem.showStaminaBar = true;
    _changed = true;
}
addEventHandler ("onStaminaChanged", StaminaSystem.onChanged);

/**
 * @public
 * @description draw stamina ui bar. You can override it like 'StaminaSystem.onRender = function () {}' for custom drawing
 */

local _drawBar = null
local _dtBefore = -1;
local _changed = false;

function StaminaSystem::onRender() {
    if (!StaminaSystem.showStaminaBar) {
        _dtBefore = -1;
        _drawBar = null;
        _changed = false;
        return;
    } else {
        if (_dtBefore == -1 || _changed == true) {
            _dtBefore = getTickCount() + StaminaSystem.time;
            _changed = false;
        }
        _drawBar = null;
    }

    local dt = getTickCount();
    if (dt > _dtBefore) {
        StaminaSystem.showStaminaBar = false;
        return;
    }

    // New bar showing method
    local currentValue = StaminaData.getData().value;
    local pos = getPlayerPosition(heroId);
    local projection = Camera.project(pos.x, pos.y + 100, pos.z);

    if (projection) {
        _drawBar = GUI.Bar(0, 0, anx(180), any(20), anx(7), any(3), "BAR_BACK.TGA", "BAR_MISC.TGA", Orientation.Horizontal)
	    _drawBar.setStretching(false)
        _drawBar.setValue(currentValue);
        _drawBar.setVisible(true)
        _drawBar.setPositionPx(projection.x - (180/2), projection.y);
    }
    /*
    // LEGACY CODE (used drawing)
    local currentValue = ceil(StaminaData.getData().value/10);
    local progress = "";
    for (local i = 0; i < currentValue; i++) {
        progress = progress + "=";
    }
    local textBar = "#" + progress + "#";
    local pos = getPlayerPosition(heroId);
    local projection = Camera.project(pos.x, pos.y + 100, pos.z);

    if (projection) {
        _drawBar = Draw(4000, 4000, "")
        _drawBar.text = textBar;
        _drawBar.setPositionPx(projection.x - (_drawBar.widthPx/2), projection.y);
        if (currentValue <= 3)
            _drawBar.setColor(255, 0, 0);
        else if (currentValue > 3 && currentValue <= 7)
            _drawBar.setColor(255, 165, 0);
        else
            _drawBar.setColor(0, 255, 0);
        _drawBar.visible = true;
    }
    */
}
addEventHandler ("onRender", function () {StaminaSystem.onRender()});