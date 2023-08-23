// FIXME: 'maxUseDistance' might be in shared space
MiningSystem <- {
    /**
     * @public
     * @description how far we can take object
     */
    maxUseDistance = 1000.0,
}

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
 * @description try mine object on server side
 *
 * @param {int} player_id player id lol
 */
function MiningSystem::tryMining(player_id) {
    local pos = getPlayerPosition(player_id);
    local currStam = StaminaSystem.getValue(player_id);
    local objmine = MiningSystem.getMine(pos);

    // Check - can we mining or not
    if (objmine == null)
        return;

    if (currStam < objmine.price)
        return;

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
        }
    }, objmine.time, 1);
}

/**
 * @public
 * @description network listener method. Can be override ofc
 */
function MiningSystem::onPacket(player_id, packet) {
    switch (packet.readUInt16()) {
        case MiningPacketId.TryMining:
            MiningSystem.tryMining(player_id);
            break;
    }
}
addEventHandler ("onPacket", function (playerid, packet) {MiningSystem.onPacket(playerid, packet);});