local _miningObjects = [];

class SharedMiningObject {
    /**
     * @public
     * @description Unique object indetifier
     */
    id = "";

    /**
     * @public
     * @description Object name
     */
    name = "";

    /**
     * @public
     * @description Object iteract position
     */
    position = [0,0,0];

    /**
     * @public
     * @description Parent world
     */
    world = "NEWWORLD\\NEWWORLD.ZEN";

    /**
     * @public
     * @description Object visual model (set "" if you dont want use it)
     */
    vobVisual = "";

    /**
     * @public
     * @description Vob physical (1 or 0)
     */
    vobPhysical = 0;

    /**
     * @public
     * @description Vob colision (1 or 0)
     */
    vobCdDynamic = 0;

    /**
     * @public
     * @description Vob position
     */
    vobPosition = [0,0,0];

    /**
     * @public
     * @description Vob rotation
     */
    vobRotation = [0,0,0];

    /**
     * @public
     * @description Play animation when player gathering
     */
    animation = "T_PLUNDER";

    /**
     * @public
     * @description Distance, where we can interact with object
     */
    triggerDistance = 200;

    /**
     * @public
     * @description Distance, where we can see action button
     */
    actionDistance = 400;

    /**
     * @public
     * @description Stamina cost
     */
    price = 5;

    /**
     * @public
     * @description Mining cooldown time
     */
    time = 1000;

    /**
     * @public
     * @description Object HP, if it set 0, it delete automaticaly. Set -1 if you want infinity HP
     */
    avaible = 30;

    //TODO: Add respawn support

    /**
     * @public
     * @description Items require for mining (instance, usingType) (check only on client)
     */
    require = [];

    /**
     * @public
     * @description Items what can be given from object (instance, amount, chance(%)) (give only on server)
     */
    resources = [];
    
    /**
     * @public 
     * @description Get table of all class data
     */
    function getTable() {
        return {
            id = id,
            name = name,
            position = position,
            world = world,
            vobVisual = vobVisual,
            vobPhysical = vobPhysical,
            vobCdDynamic = vobCdDynamic,
            vobPosition = vobPosition,
            vobRotation = vobRotation,
            animation = animation,
            triggerDistance = triggerDistance,
            actionDistance = actionDistance,
            price = price,
            time = time,
            avaible = avaible,
            require = require,
            resources = resources
        }
    }
        
    /**
     * @protected
     * @description Access to global objects store
     */
    static function getAllObjects() {
        return _miningObjects;
    }

    static function getList() {
        return _miningObjects;
    }

    static function getObjectWithId(id) {
        foreach (object in _miningObjects) {
            if (object.id == id)
                return object;
        }
        return null;
    }
}
