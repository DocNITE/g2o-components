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
    _dtBefore = -1;
    StaminaSystem.showStaminaBar = true;
}
addEventHandler ("onStaminaChanged", StaminaSystem.onChanged);

/**
 * @public
 * @description draw stamina ui bar. You can override it like 'StaminaSystem.onRender = function () {}' for custom drawing
 */

local _drawBar = null
local _dtBefore = -1;

function StaminaSystem::onRender() {
    if (!StaminaSystem.showStaminaBar) {
        _dtBefore = -1;
        _drawBar = null;
        return;
    } else {
        if (_dtBefore == -1) {
            _dtBefore = getTickCount() + StaminaSystem.time;
        }
        _drawBar = null;
    }

    local dt = getTickCount();
    if (dt > _dtBefore) {
        StaminaSystem.showStaminaBar = false;
        return;
    }

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
}
addEventHandler ("onRender", StaminaSystem.onRender);