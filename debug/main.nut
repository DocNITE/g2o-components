if (CLIENT_SIDE)
{
addEventHandler("onInit", function () {
    GuiSystem.canDrawDebug = true;
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