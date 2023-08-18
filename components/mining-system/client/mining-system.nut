MiningSystem <- {
    /**
     * @public
     * @description play animation, if we can't mining (e.g. dont have stamina)
     */
    aniCantMining = "T_DONTKNOW",

    /**
     * @public
     * @description how far we can take object
     */
    maxUseDistance = 1000.0,

    /**
     * @public
     * @description mining keyboard key
     */
    keyAction = KEY_G,

    /**
     * @public
     * @description action text what can be displayed on object
     */
    keyActionText = function () {
        local pos = getPlayerPosition(heroId);
        local obj_mine = MiningSystem.getMine(pos);
        local obj_name = "???";
        if (obj_mine != null)
            obj_name = obj_mine.name;
        local result = "";
        local text = ["Press ", " for mining "];
        result = text[0] + getKeyLetter(MiningSystem.keyAction) + text[1] + obj_name;
        return result;
    }
};

/**
 * @public
 * @description get near mining object for entity
 *
 * @param {x, y, z} pos our position where we can try to find nearest object
 */
function MiningSystem::getMine(pos) {
    local nearDistance = MiningSystem.maxUseDistance;
    local object = null;

    foreach (obj_mine in MiningObject.getAllObjects()) {
        local objPos = {x = obj_mine.position[0], y = obj_mine.position[1], z = obj_mine.position[2]};
        local distance = getDistance3d(pos.x, pos.y, pos.z, objPos.x, objPos.y, objPos.z);

        if (distance >= nearDistance)
            continue;

        object = obj_mine;
        nearDistance = distance;
    }

    return object;
}

/**
 * @public
 * @description show action text on object
 */

local _draw = null;

function MiningSystem::onRender() {
    _draw = null;

    local obj_mine = MiningSystem.getMine(getPlayerPosition(heroId));
    if (obj_mine == null)
        return;

    local pos = {x = obj_mine.position[0], y = obj_mine.position[1], z = obj_mine.position[2]};
    local projection = Camera.project(pos.x, pos.y + 100, pos.z);

    if (projection) {
        _draw = Draw(4000, 4000, "")
        _draw.text = MiningSystem.keyActionText();
        _draw.setPositionPx(projection.x - (_draw.widthPx/2), projection.y);
        _draw.visible = true;
    }
}
addEventHandler ("onRender", function () {MiningSystem.onRender()});
