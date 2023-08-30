local _draws = [];

class GUI.Popup extends GUI.Draw {
    constructor(arg) {
        base.constructor(arg);
    }
}

//TODO: Make popup messages

/**
 * local funny = GUI.Popup({
	text = "[#F60005]E[#aadd20]x[#aaffff]a[#ed00ef]m[#ff7800]p[#2900ff]l[#F60005]e [#50cc29]T[#cc298a]e[#F60005]x[#50cc29]t"
});
 */
addEventHandler("onInit", function () {
    //funny.setVisible(true);
})

function GuiSystem::onPopupRender() {

}
addEventHandler("onRender", function () {GuiSystem.onPopupRender()})