GuiSystem.popupTime <- 4
GuiSystem.popupMaxAmount <- 10

local _draws = []

enum PopupAniState {
    OPEN    = 0
    WAIT    = 1
    CLOSE   = 2
}

class GUI.Popup extends GUI.Draw {
# private:
    m_endTime = -1
# public:
    time = -1
    state = PopupAniState.OPEN

    constructor(arg) {
        base.constructor(arg)
        time = "time" in arg ? arg.time : time

        //m_endTime = getTickCount() + (time * 1000)
    }

    function update(dt) {
        if (m_endTime == -1)
            return false

        if (dt > m_endTime)
            return true

        return false
    }
}

/**
 * local funny = GUI.Popup({
	text = "[#F60005]E[#aadd20]x[#aaffff]a[#ed00ef]m[#ff7800]p[#2900ff]l[#F60005]e [#50cc29]T[#cc298a]e[#F60005]x[#50cc29]t"
});
 */

function GuiSystem::onPopupRender() {

}
addEventHandler("onRender", function () {GuiSystem.onPopupRender()})