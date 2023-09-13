local draw = null;

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

    local focus = getFocusVob();
    if (focus) {
        debugText("focus.vob", focus, 0.1);
    }

})
}
if (SERVER_SIDE)
{
    addEventHandler("onInit", function () {
                //TODO: Add save in file support! Then - add multiple loading!
    })

addEventHandler ("onPlayerJoin", function (pid) {
        // Second is db id, there you can put character name or nickname idk
        StaminaSystem.loadDataRequest(pid, getPlayerName(pid));
        //setPlayerScale(pid, 0.01, 0.01, 0.01)
        // Test popup from server
        sendPopupMessage(pid, "[#F60005]Welcome to server from server side!");
});
}
