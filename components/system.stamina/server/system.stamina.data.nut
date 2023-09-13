/**
 * @public
 * @description stamina contain data for specific player
 */
class StaminaData extends SharedStaminaData {
# private:
    _minPassed = 0;
# public:
    /**
     * @protected
     * @description local database id for specific player
     */
    owner = "";

    /**
     * @protected
     * @description player id
     */
    ownerId = -1;

    constructor() {
        getAllData().push(this);
    }

    /**
     * @protected
     * @description used for recovery timer.
     *
     * @param {int} num minute what we want add
     */
    function addMinute(num) {
        _minPassed += num;
    }

    /**
    * @protected
    * @description used for perm. set recovery timer.
    *
    * @param {int} num minute
    */
    function setMinute(num) {
        _minPassed = num;
    }

    /**
     * @protected
     * @description description
     *
     * @return {int} minute
     */
    function getMinute() {
        return _minPassed;
    }

    /**
     * @public
     * @description description
     */
    function setValue(val) {
        if (!canDrain)
            return;

        value = clamp(val, 0, maxValue);
        sync();
    }

    /**
     * @public
     * @description description
     */
    function setMaxValue(val) {
        maxValue = val;

        if (!canDrain)
            return;

        value = clamp(value, 0, maxValue);
        sync();
    }

    /**
     * @private
     * @description well, we might to move it in something library
     */
    function clamp(value, minValue, maxValue) {
        if (value > maxValue)
            return maxValue;
        else if (value < minValue)
            return minValue;
        else
            return value;
    }

    /**
     * @private
     * @description synchronize stamina data on player's client
     */
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

/**
 * @private
 * @description load stamina data for specific player. If it's doesn't exist - he create a new data
 */
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
    newData.sync();
    callEvent("onStaminaDataSaveRequest");
});

/**
 * @private
 * @description load all stamina data from database
 */
addEventHandler ("onStaminaDataLoadRequest", function () {
    try
    {
        local fileLoad = file("components/system.stamina/data/db.txt", "r");
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

/**
 * @private
 * @description save all stamina data into database
 */
addEventHandler ("onStaminaDataSaveRequest", function () {
    local fileWrite = file("components/system.stamina/data/db.txt", "w");
    foreach (value in StaminaData.getAllData()) {
        fileWrite.write(value.owner + " " + value.value + " " + value.maxValue + "\n");
    }
    fileWrite.close();
});

/**
 * @private
 */
addEventHandler ("onPacket", StaminaData.onPacket);
