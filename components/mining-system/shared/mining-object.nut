local _miningObjects = [];

class SharedMiningObject {
    // Unique object indetifier
    id = "";
    // Object name
    name = "";
    // Object iteract position
    position = [0,0,0];
    // Parent world
    world = "NEWWORLD\\NEWWORLD.ZEN";

    // Object visual model (set "" if you dont want use it)
    vobVisual = "";
    // Vob physical (1 or 0)
    vobPhysical = 0;
    // Vob colision (1 or 0)
    vobCdDynamic = 0;
    // Vob position
    vobPosition = [0,0,0];
    // Vob rotation
    vobRotation = [0,0,0];

    // Play animation when player gathering
    animation = "T_PLUNDER";
    // Distance, where we can interact with object
    triggerDistance = 100;
    // Distance, where we can see action button
    actionDistance = 300;
    // Stamina cost
    price = 5;
    // Mining time
    time = 1000;
    // Object HP, if it set 0, it delete automaticaly. Set -1 if you want infinity HP
    avaible = 30;

    // Items require for mining (instance, usingType)
    require = [];
    // Items what can be given from object (instance, amount)
    resources = [];

    // Access to global objects store
    static function getAllObjects() {
        return _miningObjects;
    }
}