local dataPath      = "components/system.mining/data/"
local dataFormat    = ".txt"

/**
 * @protected
 * @description server side class implementation
 */
class MiningObject extends SharedMiningObject {
    canSave = true;

    constructor() {
        this.getAllObjects().push(this);
    }

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
        packet.writeString(animation);
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

/**
 * @private
 * @description 
 */
addEventHandler("onMiningDataSaveRequest", function() {
    local objList = MiningObject.getList()
    for (local i = 0; i < objList.len(); i++) {
        try 
        {
            local objMine = objList[i]
            if (objMine == null)
                continue

            print(objMine)
            //local fileSave = file(dataPath + i + dataFormat, "w")
            // TODO: Make parser saving
        }
        catch (errorMsg) {}
    }
})

/**
 * @private 
 * @description 
 */
addEventHandler("onMiningDataLoadRequest", function() {
        for(local i = 0; i < MiningSystem.maxObjects; i++) {
            try
            {
                local fileLoad = file(dataPath + i + dataFormat, "r");
                local data = "";
                local line = "";
                while (line != null) {
                    line = fileLoad.read("l");
                    if (line != null)
                        data = data + line;
                }

                fileLoad.close();
                local objMine = MiningObject(); 
                MiningParser.setDataFromString(data, objMine);
            } 
            catch (errorMsg) {}
        }
})

/**
 * @private
 * @description sync objects for new connected player 
 */
addEventHandler ("onPlayerJoin", function (pid) {
    foreach (obj in MiningObject.getAllObjects()) {
        obj.sync(pid);
    }
});

/** 
 * @private
 * @description some network sync from client
 */
addEventHandler ("onPacket", function (pid, packet) {
    MiningObject.onPacket(pid, packet)
});
