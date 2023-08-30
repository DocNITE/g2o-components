GuiSystem <- {
    /**
     * @public
     * @description contains all Popup UI messages
     */
    popupRoot = GUI.Window({
        sizePx = {width = 400, height = 200}
        file = "MENU_INGAME.TGA"
    })
}

/**
 * addEventHandler("onInit", function () {
    GuiSystem.canDrawDebug = true;
    debugText("Ui test 1", "", 30);
    GuiSystem.popupRoot.setVisible(true);
    debugText("Ui test show  poop", "", 30);
    local window = GUI.Bar({
        visible = true,
        sizePx = {width = 400, height = 40},
        positionPx = {x = 100, y = 100},
        file = "MENU_RANGE_DRP.TGA",
        progress = {file = "BAR_MISC.TGA"},
        minimum = 5,
        maximum = 15,
        value = 8,
        stretching = true,
        marginPx = {top = 0, right = 0, bottom = 0, left = 0},
    })
    // code was not working lol
    debugText("Ui test add child", "", 30);
    popupRoot.insert(window);
    debugText("Ui test end", "", 30);
})
 */