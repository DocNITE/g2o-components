MiningSystem <- {}

function MiningSystem::tryMining(playerid) {
    // TODO: Wee need try to gathering from server. Then - we receive packet on client.
    // On client we freeze player and play animation.
    // When timer from server was done - we receive packet on client again for closing animations lol.
    local pos = getPlayerPosition;
    foreach (value in MiningObject.getAllObjects()) {
        if (getDistance3d(pos.x, pos.y, pos.z, value.position[0], value.position[1], value.position[2]) < value.actionDistance)
        {
            doMining(value, playerid);
            return;
        }
    }
}

local function doMining(object, pid) {

    //TODO: Сделать таймер добычи. Дальше отправлять игрока к триггер зоне,
    //там он кидает пакет, когда дошел, и затем запускаем таймер
    /*
    setTimer(function () {

    }, 3000, 1);
    */
}

addEventHandler ("onInit", function () {

});