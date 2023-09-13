// FIXME: 'maxUseDistance' might be in shared space
MiningSystem <- {
    /**
     * @public
     * @description how far we can take object
     */
    maxUseDistance = 1000.0,

    /**
     * @public 
     * @description max possible objects in game
     */
    maxObjects = 256
}

/**
 * @public 
 * @description Create a new mining object 
 *
 * @param {table} arg Is our data, what we want set on object 
 */
function MiningSystem::createMine(arg) {
    local obj = MiningObject()
    MiningSystem.changeMine(obj, arg)
}

/**
 * @public
 * @description Change data for mining object 
 *
 * @param {MiningObject} obj Existin' mining object
 * @param {table} arg Is our data, what we want set on object  
 */
function MiningSystem::changeMine(obj, arg) {
    obj.id = "id" in arg ? arg.id : obj.id
    obj.name = "name" in arg ? arg.name : obj.name
    obj.position = "position" in arg ? arg.position : obj.position
    obj.world = "world" in arg ? arg.world : obj.world
    obj.vobVisual = "vobVisual" in arg ? arg.vobVisual : obj.vobVisual
    obj.vobPhysical = "vobPhysical" in arg ? arg.vobPhysical : obj.vobPhysical
    obj.vobCdDynamic = "vobCdDynamic" in arg ? arg.vobCdDynamic : obj.vobCdDynamic
    obj.vobPosition = "vobPosition" in arg ? arg.vobPosition : obj.vobPosition
    obj.vobRotation = "vobRotation" in arg ? arg.vobRotation : obj.vobRotation
    obj.animation = "animation" in arg ? arg.animation : obj.animation 
    obj.triggerDistance = "triggerDistance" in arg ? arg.triggerDistance : obj.triggerDistance
    obj.actionDistance = "actionDistance" in arg ? arg.actionDistance : obj.actionDistance
    obj.price = "price" in arg ? arg.price : obj.price
    obj.time = "time" in arg ? arg.time : obj.time
    obj.avaible = "avaible" in arg ? arg.avaible : obj.avaible
    obj.require = "require" in arg ? arg.require : obj.require
    obj.resources = "resources" in arg ? arg.resources : obj.resources
    
    MiningSystem.saveRequest()
}

/**
 * @public
 * @description get near mining object for entity
 *
 * @param {x, y, z} pos our position where we can try to find nearest object
 */
function MiningSystem::getMine(pos, world) {
    local nearDistance = MiningSystem.maxUseDistance;
    local object = null;

    foreach (obj_mine in MiningObject.getAllObjects()) {
        local objPos = {x = obj_mine.position[0], y = obj_mine.position[1], z = obj_mine.position[2]};
        local distance = getDistance3d(pos.x, pos.y, pos.z, objPos.x, objPos.y, objPos.z);

        if (obj_mine.world != world)
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
 * @description save all mining obj's data from server to database. Actualy use for onExit()
 */
function MiningSystem::saveRequest() {
    callEvent("onMiningDataSaveRequest");
}

/**
 * @public
 * @description load all mining obj's database to server. Actualy used for onInit()
 */
function MiningSystem::loadRequest() {
    callEvent("onMiningDataLoadRequest");
}

/**
 * @public
 * @description desc
 */
function MiningSystem::getMineWithId(id, world) {
    local object = MiningObject.getObjectWithId(id);
    if (object != null && object.world == world)
        return object;
    else
        return null;
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
 * @description try mine object on server side
 *
 * @param {int} player_id player id lol
 * @param {int} object_id mining object id
 */
function MiningSystem::tryMining(player_id, object_id) {
    local pos = getPlayerPosition(player_id);
    local currStam = StaminaSystem.getValue(player_id);
    local currWorld = getPlayerWorld(player_id);
    local objmine = MiningSystem.getMineWithId(object_id, currWorld);

    // Check - can we mining or not
    if (objmine == null)
        return;

    if (!MiningSystem.canMine(pos, objmine))
        return;

    if (currStam < objmine.price) {
        return;
    }

    // if exist nearby object and has stamina
    local packet = Packet();
    packet.writeUInt16(MiningPacketId.DoMining);
    packet.writeString(objmine.id);
    // we should use RELIABLE_ORDERED for order request - start2end
    packet.send(player_id, RELIABLE_ORDERED);

    // decrease stamina from player for working
    StaminaSystem.setValue(player_id, currStam - objmine.price);

    setTimer(function () {
        // Send net packet
        local packet = Packet();
        packet.writeUInt16(MiningPacketId.EndMining);
        packet.send(player_id, RELIABLE_ORDERED);
        // give resources
        foreach (item in objmine.resources) {
            giveItem(player_id, Items.id(item[0]), item[1]);
            local itemName = "'" + Items.name(Items.id(item[0])) + "(x" + item[1] + ")" + "' ";
            sendPopupMessage(player_id, Loc.getText("mining-give-item") + itemName);
        }
    }, objmine.time, 1);
}

// TODO: Need make object load from parser.
// Then - maybe, saving into file
//MiningParser::getDataFromString(data)

/**
 * @public
 * @description network listener method. Can be override ofc
 */
function MiningSystem::onPacket(player_id, packet) {
    switch (packet.readUInt16()) {
        case MiningPacketId.TryMining:
            local objId = packet.readString();
            MiningSystem.tryMining(player_id, objId);
            break;
    }
}
addEventHandler ("onPacket", function (playerid, packet) {MiningSystem.onPacket(playerid, packet);});

/**
 * @public
 * @description load objects from data 
 */
function MiningSystem::onInit() {
        // Log initialization
        print("MiningSystem successfully initialized...")

        // Load data from db
        MiningSystem.loadRequest()

        // Log how many we load objects
        print("- Loaded Objects: " + MiningObject.getList().len())
}
addEventHandler("onInit", function () {MiningSystem.onInit()});

/**
 * @public
 * @description save object to data
 */
function MiningSystem::onExit() {
    // Log exit 
    print("MiningSystem was shutdown...")

    // Save data to db 
    MiningSystem.saveRequest()
}
addEventHandler("onExit", function () {MiningSystem.onExit()});
