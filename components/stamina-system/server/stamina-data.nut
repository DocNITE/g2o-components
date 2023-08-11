class StaminaData extends SharedStaminaData {
    // Local data id (like character name)
    owner = "";
    // Player Id
    ownerId = -1;

    constructor() {
        getAllData().push(this);
    }

    function setValue(val) {
        if (!canDrain)
            return;

        value = clamp(val, maxValue);
        sync();
    }

    function setMaxValue(val) {
        maxValue = clamp(value, val);

        if (!canDrain)
            return;

        value = clamp(value, maxValue);
        sync();
    }

    function sync() {
        if (ownerId == -1 || !isPlayerConnected(ownerId))
            return;

        local packet = Packet();
        packet.writeUInt16(StaminaPacketId.Change);
        packet.writeUInt16(value);
        packet.writeUInt16(maxValue);
        packet.send(ownerId, RELIABLE_ORDERED);
    }

    static function onPacket(pid, packet) {}
}

addEventHandler ("onStaminaDataRequest", function (ownerId, owner) {
    foreach (value in StaminaData.getAllData()) {
        if (value.owner == owner) {
            value.ownerId = ownerId;
            value.sync();
            return;
        }
    }

    local newData = StaminaData();
    newData.owner = owner;
    newData.ownerId = ownerId;
    callEvent("onStaminaDataSaveRequest");
});

addEventHandler ("onStaminaDataLoadRequest", function () {
    try
    {
        local fileLoad = file("components/stamina-system/data/db.txt", "r");
        local args = 0;

        do{
            args = fileLoad.read("l");
            if(args != null){
                local arg = sscanf("sdd", args);
                local data = StaminaData();
                data.owner = arg[0];
                data.value = arg[1];
                data.maxValue = arg[2];
            }
            else{
                break;
            }
        } while (args != null)

        fileLoad.close();
    }
    catch (errorMsg) {}
});

addEventHandler ("onStaminaDataSaveRequest", function () {
    local fileWrite = file("components/stamina-system/data/db.txt", "w");
    foreach (value in StaminaData.getAllData()) {
        fileWrite.write(value.owner + " " + value.value + " " + value.maxValue + "\n");
    }
    fileWrite.close();
});

// events
addEventHandler ("onPacket", StaminaData.onPacket);

// Mmm...
local function clamp(value, maxValue) {
    if (value > maxValue)
        return maxValue;
    else
        return value;
}

//TODO: Make global loading data (and dont destroy when player exit from game)