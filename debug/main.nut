if (CLIENT_SIDE)
{
addEventHandler("onInit", function () {
    GuiSystem.canDrawDebug = true;
})

addEventHandler("onRender", function () {
    debugText("character transform", "", 2);
    local playerVob = Vob(getPlayerPtr(heroId));
    local pos = playerVob.getPosition();
    debugText("pos", pos.x + ", " + pos.y + ", " + pos.z, 2);
    local rot = playerVob.getRotation();
    debugText("rot", rot.x + ", " + rot.y + ", " + rot.z, 2);

    // find nearest mining obj
    local objmine = MiningSystem.getMine(getPlayerPosition(heroId));
    if (objmine != null) {
        debugText("system.mining", "", 2);
        debugText("name", objmine.name, 2);
        debugText("id", objmine.id, 2);
    }

})
}
if (SERVER_SIDE)
{

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
});
}