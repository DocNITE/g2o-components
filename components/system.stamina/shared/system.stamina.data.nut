local _globalData = [];

class SharedStaminaData {
    /**
     * @public | @readonly
     * @description current value of stamina
     */
    value = 100;

    /**
     * @public | @readonly
     * @description max value of stamina
     */
    maxValue = 100;

    /**
     * @public
     * @description if true - our stamina can be changed. If false - we have infinity stamina
     */
    canDrain = true;

    /**
     * @public
     * @description take all existin' stamina data
     */
    static function getAllData() {
        return _globalData;
    }

    static function getList() {
        return _globalData;
    }
}