/**
 * @protected
 * @description mining object
 */
class MiningObject extends SharedMiningObject {
    /**
     * @private
     * @description vob pointer
     */
    _vob = null;

    /**
     * @private
     * @description used for object synchronization on client
     *
     * @param {Packet} packet networked packet from server
     */
    function create(packet) {
        if (!CLIENT_SIDE)
            return;

        // Set all variables from server object
        id = packet.readString();
        name = packet.readString();
        position[0] = packet.readFloat();
        position[1] = packet.readFloat();
        position[2] = packet.readFloat();
        world = packet.readString();
        vobVisual = packet.readString();
        vobPhysical = packet.readUInt8();
        vobPosition[0] = packet.readFloat();
        vobPosition[1] = packet.readFloat();
        vobPosition[2] = packet.readFloat();
        vobRotation[0] = packet.readFloat();
        vobRotation[1] = packet.readFloat();
        vobRotation[2] = packet.readFloat();
        triggerDistance = packet.readUInt16();
        actionDistance = packet.readUInt16();
        price = packet.readUInt16();
        time = packet.readUInt16();
        avaible = packet.readUInt16();

        for (local i = 0; i < packet.readUInt8(); i++) {
            local soValue = [packet.readString(), packet.readUInt8()];
            require.push(soValue);
        }
        for (local i = 0; i < packet.readUInt8(); i++) {
            local soValue = [packet.readString(), packet.readUInt8()];
            resources.push(soValue);
        }

        // Create vob visual
        createVisual();
    }

    /**
     * @public
     * @description create vob for mining object
     */
    function createVisual() {
        if (!CLIENT_SIDE)
            return;

        if (vobVisual == "" || world != getWorld())
            return;

        if (_vob != null) {
            _vob.removeFromWorld();
            _vob = null;
        }

        _vob = Vob(vobVisual);
        _vob.setPosition(vobPosition[0], vobPosition[1], vobPosition[2]);
        _vob.setRotation(vobRotation[0], vobRotation[1], vobRotation[2]);

        if (vobPhysical == 1)
            _vob.physicsEnabled = true;
        else
            _vob.physicsEnabled = false;

        if (vobCdDynamic == 1)
            _vob.cdDynamic = true;
        else
            _vob.cdDynamic = false;

	    _vob.addToWorld();
    }

    static function onPacket(pid, packet) {
        if (CLIENT_SIDE) {
            local packetId = packet.readUInt16();
            switch (packetId) {
                case MiningPacketId.Create:
                    // Create object for client
                    local newObject = MiningObject();
                    newObject.create(packet);
                    MiningObject.getAllObjects().push(newObject);
                    break;
                case MiningPacketId.Destroy:
                    // Destroy object with id field
                    local destroyId = packet.readString();
                    local count = MiningObject.getAllObjects().len();
                    for (local i; i < count; i++) {
                        local objects = MiningObject.getAllObjects();

                        if (objects[i] == null)
                            continue;

                        if (objects[i].id == destroyId) {
                            objects[i]._vob.removeFromWorld();
                            objects[i] = null;
                        }
                    }
                    break;
            }
        }
    }
}

addEventHandler ("onPacket", function (packet) {
    MiningObject.onPacket(heroId, packet)
});

addEventHandler ("onWorldEnter", function (world) {
    foreach (obj in MiningObject.getAllObjects()) {
        if (obj.world == world)
            obj.createVisual();
    }
});