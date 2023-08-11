class MiningObject extends SharedMiningObject {
    canSave = true;

    function sync(pid) {
        if (!SERVER_SIDE)
            return;

        local packet = Packet();
        packet.writeUInt16(MiningPacketId.Create);
        packet.writeString(id);
        packet.writeString(name);
        packet.writeFloat(position[0]);
        packet.writeFloat(position[1]);
        packet.writeFloat(position[2]);
        packet.writeString(world);
        packet.writeString(vobVisual);
        packet.writeUInt8(vobPhysical);
        packet.writeFloat(vobPosition[0]);
        packet.writeFloat(vobPosition[1]);
        packet.writeFloat(vobPosition[2]);
        packet.writeFloat(vobRotation[0]);
        packet.writeFloat(vobRotation[1]);
        packet.writeFloat(vobRotation[2]);
        packet.writeUInt16(triggerDistance);
        packet.writeUInt16(actionDistance);
        packet.writeUInt16(price);
        packet.writeUInt16(time);
        packet.writeUInt16(avaible);
        packet.writeUInt8(require.len());
        foreach (value in require) {
            packet.writeString(value[0]);
            packet.writeUInt8(value[1]);
        }
        packet.writeUInt8(resources.len());
        foreach (value in resources) {
            packet.writeString(value[0]);
            packet.writeUInt8(value[1]);
        }
        packet.send(pid, RELIABLE_ORDERED);
        packet = null;
    }

    static function loadFromFile(file) {

    }

    static function onPacket(pid, packet) {}
}

addEventHandler ("onPlayerJoin", function (pid) {
    foreach (obj in MiningObject.getAllObjects()) {
        obj.sync(pid);
    }
});

addEventHandler ("onPacket", function (pid, packet) {
    MiningObject.onPacket(pid, packet)
});