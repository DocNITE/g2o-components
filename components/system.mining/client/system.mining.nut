local _isMining = false;
local _ptr = null;
local _ani = "";
local _doAni = false;
local _doHit = true;

MiningSystem <- {
    /**
     * @public
     * @description play animation, if we can't mining (e.g. dont have stamina)
     */
    aniCantMining = function () {
        playAni(heroId, "T_DONTKNOW")
    },

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
    keyActionText = function (obj_mine) {
        local pos = getPlayerPosition(heroId);
        local obj_name = "???";
        if (obj_mine != null)
            obj_name = obj_mine.name;
        local result = "";
        local text = Loc.getText("mining-key-action");
        result ="[#ffffff]" + text[0] + "[#00ff00]" + getKeyLetter(MiningSystem.keyAction).toupper() + "[#ffffff]" + text[1] + obj_name;
        return result;
    },

    /**
     * @public 
     * @description action text for hit typed object
     */
    hitActionText = function (obj_mine) {
        local obj_name = "???";
        if (obj_mine != null)
            obj_name = obj_mine.name;

        local text = Loc.getText("mining-hit-action")
        local result = ""
        result = text[0] + obj_name + text[1]
        return result
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
    local currentWorld = getWorld();

    foreach (obj_mine in MiningObject.getAllObjects()) {
        local objPos = {x = obj_mine.position[0], y = obj_mine.position[1], z = obj_mine.position[2]};
        local distance = getDistance3d(pos.x, pos.y, pos.z, objPos.x, objPos.y, objPos.z);

        if (obj_mine.world != currentWorld)
            continue;

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
    debugText("system.mining.objectsCount", MiningObject.getAllObjects().len(), 0.1)

    _draw = null;

    local focusedVob = getFocusVob();
    if (focusedVob == null)
        return;

    debugText("system.mining.onRenderFocus", "true", 0.1)

    local mineObj = MiningObject.getObjectWithVobPtr(focusedVob);
    if (mineObj == null)
        return;

    debugText("system.mining.onRenderFindObj", "true", 0.1)
    
 
    local isInHand = false;
    foreach (item in mineObj.require) {

        if (item[1] == MiningRequireType.InHand) { 
            isInHand = true;
            break
        }
    }
    // TODO: Need make next focus text:
    //          Name Object 
    //       hit for mining
    // or     press G for mining
    local pos = {x = mineObj.position[0], y = mineObj.position[1], z = mineObj.position[2]};
    local projection = Camera.project(pos.x, pos.y + 100, pos.z);

    if (projection) {
        local actionText = MiningSystem.keyActionText(mineObj)
        if (isInHand) 
            actionText = MiningSystem.hitActionText(mineObj)
        _draw = GUI.Draw({
            position = {x = 1000, y = 1250}
            text = actionText
        })
        _draw.setPositionPx(projection.x - (_draw.getSizePx().width/2), projection.y);
        _draw.setVisible(true);
    }
}
addEventHandler ("onRender", function () {MiningSystem.onRender()});

/**
 * @public
 * @description  listen key events for activate mining
 *
 * @param {int} key keyboard key lol
 */
function MiningSystem::onKey(key) {
    if (isKeyToggled(MiningSystem.keyAction) && !_isMining) {
        local pos = getPlayerPosition(heroId);

        local focusedVob = getFocusVob();
        if (focusedVob == null)
            return;

        local objmine = MiningObject.getObjectWithVobPtr(focusedVob);
        if (objmine == null)
            return;

        if (!MiningSystem.canMine(pos, objmine)) {
            sendPopupMessage(Loc.getText("mining-too-far"));
            MiningSystem.aniCantMining();
            return;
        }

        if (StaminaSystem.getValue() < objmine.price) {
            sendPopupMessage(Loc.getText("mining-not-enough-stamina"));
            MiningSystem.aniCantMining();
            return;
        }

        // check require items for mining
        local canMine = false;
        foreach (item in objmine.require) {
            if (hasItem(heroId, Items.id(item[0])) && item[1] != MiningRequireType.InHand) 
                canMine = true;

            if (item[1] == MiningRequireType.InHand) {
                //equipItem(heroId, Items.id(item[0]));
                canMine = false;
                break;
            } 
        }

        if (objmine.require.len() <= 0)
            canMine = true;

        // Check CAN WE MINE (at last)
        if (!canMine) {
            local itemList = "";
            foreach (item in objmine.require) {
                itemList = itemList + "'" + Items.name(Items.id(item[0])) + "(x" + item[1] + ")" + "' "
            }
            sendPopupMessage(Loc.getText("mining-not-have-item") + itemList);
            MiningSystem.aniCantMining();
            return;
        }


        _ptr = objmine;
        _ani = objmine.animation;

        // ahh... You know...
        local packet = Packet();
        packet.writeUInt16(MiningPacketId.TryMining);
        packet.writeString(objmine.id);
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
    _doHit = false

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
    _doHit = true
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
    if (_doAni) {
        if (!getPlayerAni(heroId) == _ani)
            playAni(heroId, _ani);
    }
}
addEventHandler ("onRender", function () {MiningSystem.onAniRender();});

/**
 * @public
 * @description used for hit detection on mining obj (need fow ore, woods and something)
 */
function MiningSystem::onHitRender() {
    if (!_doHit)
        return 
    //FIXME: That code might be bugged in some line. So, need review it.
    local pos = getPlayerPosition(heroId)

    local playerVob = Vob(getPlayerPtr(heroId));
    local trafo = playerVob.getTrafoModelNodeToWorld("ZS_RIGHTHAND")
    local trafoPos = trafo.getTranslation()
    local itemName = Items.name(getPlayerMeleeWeapon(heroId)) 
    local instance = Daedalus.instance(itemName)
    local trace = GameWorld.traceRayNearestHit(Vec3(trafoPos.x, trafoPos.y, trafoPos.z), trafo.getRightVector() * (instance.range), TRACERAY_VOB_IGNORE_CHARACTER | TRACERAY_VOB_IGNORE_PROJECTILES | TRACERAY_POLY_NORMAL)

    if (trace && getPlayerBodyState(heroId) == BS_HIT) {
        debugText("system.mining.onHitFinded", trace.vob, 5.0)
       
        local objMine = MiningObject.getObjectWithVobPtr(trace.vob)
        if (objMine == null)
            return;

        debugText("system.mining.onHitObjectFinded", objMine, 5.0)

        if (StaminaSystem.getValue() < objMine.price) {
           // sendPopupMessage(Loc.getText("mining-not-enough-stamina"));
            return;
        }

        // check require items for mining
        local canMine = false;
        foreach (item in objMine.require) {

            if (item[0] == itemName && item[1] == MiningRequireType.InHand) { 
                canMine = true;
                break
            }
        }

        if (!canMine) 
            return

        debugText("system.mining.onHitObject", objMine.name, 5.0)
        
        _ptr = objMine
        _ani = objMine.animation
            
        // ahh... You know...
        local packet = Packet();
        packet.writeUInt16(MiningPacketId.TryMining);
        packet.writeString(objMine.id);
        packet.send(RELIABLE_ORDERED);

        _doHit = false
    }    
}
addEventHandler("onRender", function () {MiningSystem.onHitRender()})
