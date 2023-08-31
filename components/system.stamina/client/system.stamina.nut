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

// local vars
local _bar = {width = 180/2, height = 20/2, value = 0};
local _tween = null;
local _drawBar = null
local _dtBefore = -1;
local _changed = false;

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

    if (_tween != null && !_tween.ended)
        _tween.stop();

    _tween = Tween(1, _bar, {value = data.value}, Tween.easing.linear);

    debugText("system.stamina.showStaminaBar", "true", StaminaSystem.time/1000);
}
addEventHandler ("onStaminaChanged", StaminaSystem.onChanged);

/**
 * @public
 * @description draw stamina ui bar. You can override it like 'StaminaSystem.onRender = function () {}' for custom drawing
 */
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

    debugText("system.stamina.onRenderStart", "true", 0.1);

    // New bar showing method
    local currentValue = StaminaData.getData().value;
    local pos = getPlayerPosition(heroId);
    local projection = Camera.project(pos.x, pos.y + 100, pos.z);

    debugText("system.stamina.onRenderPostProjection", "true", 0.1);

    if (projection) {
        _drawBar = GUI.Bar({
            positionPx = {x = 0, y = 0},
            sizePx = {width = _bar.width, height = _bar.height},
            marginPx = {top = 3, right = 7, bottom = 3, left = 7}, // {top = 7, right = 3, bottom = 7, left = 3},
            stretching = true,
            visible = true,
            file = "BAR_BACK.TGA",
            progress = {file = "BAR_MISC.TGA"}})
        _drawBar.setValue(_bar.value);
        _drawBar.setPositionPx(projection.x - (_bar.width/2), projection.y);
    }

    debugText("system.stamina.onRenderEnd", "true", 0.1);

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