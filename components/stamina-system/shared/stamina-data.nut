local _globalData = [];

class SharedStaminaData {
    // Current value of stamina
    value = 100;
    // Maximum possible value of stamina
    maxValue = 100;

    // If true - stamina was drain. If false - stamina was infinity
    canDrain = true;

    static function getAllData() {
        return _globalData;
    }
}