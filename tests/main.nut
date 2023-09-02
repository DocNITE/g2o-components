if (CLIENT_SIDE)
{
addEventHandler("onInit", function () {
    // Enabled debug drawing
    GuiSystem.canDrawDebug = true;
    // Test popups
    /**
     * setTimer(function () {
        GuiSystem.addPopupMessage("Fatagn Shatagn Lol fuckFatagn Shatagn Lol fuckFatagn Shatagn Lol fuckFatagn Shatagn Lol fuckFatagn Shatagn Lol fuckFatagn Shatagn Lol fuck");
    }, 4000, 666);
     */
    // Test popup like welcome
    sendPopupMessage("[#aaffff]Welcome to server from client side!");
})

addEventHandler("onRender", function () {
    debugText("character transform", "", 2);
    local playerVob = Vob(getPlayerPtr(heroId));
    local pos = playerVob.getPosition();
    debugText("pos", pos.x + ", " + pos.y + ", " + pos.z, 2);
    local rot = playerVob.getRotation();
    debugText("rot", rot.x + ", " + rot.y + ", " + rot.z, 2);

    //playerVob.setRotation(rot.x, rot.y, 90);

    // find nearest mining obj
    local objmine = MiningSystem.getMine(getPlayerPosition(heroId));
    if (objmine != null) {
        debugText("system.mining", "", 0.1);
        debugText("name", objmine.name, 0.1);
        debugText("id", objmine.id, 0.1);
    }

})
}
if (SERVER_SIDE)
{

    // Test mining obj
    local testGatch = MiningObject();
    testGatch.id = "sword-farming";
    testGatch.name = "mining sword"
    testGatch.position = [0,0,0];
    testGatch.vobVisual = "MIN_ORE_BIG_V1.3DS";
    testGatch.require = [["ITMW_1H_SPECIAL_04", MiningRequireType.InHand]];
    testGatch.resources = [["ITMW_SCHWERT", 2]];
    testGatch.time = 10000;
    MiningObject.getAllObjects().push(testGatch);

addEventHandler ("onPlayerJoin", function (pid) {
        // Second is db id, there you can put character name or nickname idk
        StaminaSystem.loadDataRequest(pid, getPlayerName(pid));
        // Test popup from server
        sendPopupMessage(pid, "[#F60005]Welcome to server from server side!");
});
}