addEventHandler ("onPlayerJoin", function (pid) {
    // Second is db id, there you can put character name or nickname idk
    StaminaSystem.loadDataRequest(pid, getPlayerName(pid));
});