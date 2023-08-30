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

        if (distance > obj_mine.actionDistance)
            continue;

        object = obj_mine;
        nearDistance = distance;
    }

    return object;
}

/**
 * @public
 * @description
 *
 * @param {MiningObject} obj_mine
 */
function MiningSystem::canMine(pos, obj_mine) {
    local objPos = {x = obj_mine.position[0], y = obj_mine.position[1], z = obj_mine.position[2]};
    local distance = getDistance3d(pos.x, pos.y, pos.z, objPos.x, objPos.y, objPos.z);

    if (distance <= obj_mine.triggerDistance)
        return true
    else
        return false
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

/**
 * @public
 * @description  listen key events for activate mining
 *
 * @param {int} key keyboard key lol
 */

local _isMining = false;
local _ptr = null;
local _ani = "";
local _doAni = false;

function MiningSystem::onKey(key) {
    if (isKeyToggled(MiningSystem.keyAction) && !_isMining) {
        local pos = getPlayerPosition(heroId);
        local objmine = MiningSystem.getMine(pos);

        // find nearest object
        if (objmine == null)
            return;

        if (!MiningSystem.canMine(pos, objmine))
            return;

        // check require items for mining
        local canMine = false;
        foreach (item in objmine.require) {
            if (hasItem(heroId, Items.id(item[0])))
                canMine = true;

            // AHTUNG!!!: Maybe dirty code. It's, probably, can dupe item. So fix me, if you can!
            if (item[1] == MiningRequireType.InHand)
                equipItem(heroId, Items.id(item[0]));
        }

        if (objmine.require.len() <= 0)
            canMine = true;

        // Check CAN WE MINE (at last)
        if (!canMine)
            return;

        _ptr = objmine;
        _ani = objmine.animation;

        // ahh... You know...
        local packet = Packet();
        packet.writeUInt16(MiningPacketId.TryMining);
        packet.send(RELIABLE_ORDERED);
    }
}
addEventHandler ("onKey", function (key) {MiningSystem.onKey(key)});

/**
 * @public
 * @description called when start mining
 */
function MiningSystem::onMining() {
    _isMining = true;
    playAni(heroId, _ani);
    setFreeze(true);
    _doAni = true;

    local pos = getPlayerPosition(heroId);
    local angle = getVectorAngle(pos.x, pos.z, _ptr.position[0], _ptr.position[2]);
    setPlayerAngle(heroId, angle);
}

/**
 * @public
 * @description called when mining was end
 */
function MiningSystem::onEndMining() {
    _isMining = false;
    stopAni(heroId, _ani);
    setFreeze(false);
    _doAni = false;
    _ptr = null;
}

/**
 * @public
 * @description network listener for client side
 *
 * @param {Packet} packet network data (packet)
 */
function MiningSystem::onPacket(packet) {
    switch (packet.readUInt16()) {
        case MiningPacketId.DoMining:
            MiningSystem.onMining();
            break;
        case MiningPacketId.EndMining:
            MiningSystem.onEndMining();
            break;
    }
}
addEventHandler ("onPacket", function (packet) {MiningSystem.onPacket(packet);});

/**
 * @public
 * @description used for animation cycling. Can be override ofc
 */
function MiningSystem::onAniRender() {
    // If it empty - we dont need play animations
    if (_doAni) {
        if (!getPlayerAni(heroId) == _ani)
            playAni(heroId, _ani);
    }
}
addEventHandler ("onRender", function () {MiningSystem.onAniRender();});
