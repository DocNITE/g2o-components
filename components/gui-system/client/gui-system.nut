GuiSystem <- {
    /**
     * @public
     * @description contains all Popup UI messages
     */
    popupRoot = GUI.Window({
        sizePx = {width = 400, height = 200}
        file = "MENU_INGAME.TGA"
    }),

    /**
     * @public
     * @description draw debug ui on screen. Enable it with `GuySystem.canDrawDebug = true`
     */
    canDrawDebug = false
}

# DEBUG UI

class DebugMsgInfo {
# private
    static _container = []

    m_endTime = -1
    m_destroy = false
# public:
    draw = null

    message = ""
    id = ""
    time = 1
    override = true

    constructor(s_message, s_id, i_time, b_override) {
        message = s_message
        id = s_id
        time = i_time
        override = b_override

        if (time > 0)
            m_endTime = getTickCount() + (time * 1000);

        DebugMsgInfo._container.push(this);
    }

    function update(dt) {
        if (dt > m_endTime && time > 0) {
            this.m_destroy = true;
        }
        return this.m_destroy;
    }

    static function _onRender() {
        local dt = getTickCount();
        local count = _container.len();
        // do timing
        for (local i = 0; i < count; i++) {
            local msg = _container[i];
            local result = msg.update(dt);

            if (result) {
                _container.remove(i);
            }
        }
        // draw elements
        for (local i = 0; i < count; i++) {
            local msg = _container[i];
            msg.draw = Draw(0, 0, msg.id + ": " + msg.message);
        }
        // Size elements
        local width = 0;
        for (local i = 0; i < count; i++) {
            local msg = _container[i];
            if (msg.draw.width > width)
                width = msg.draw.width;
        }
        local height = 0;
        for (local i = 0; i < count; i++) {
            local msg = _container[i];
            height += msg.draw.height+(msg.draw.height/2);
        }
        // reposition
        //local ypos = 0;
        local ypos = (4096-(height/2));
        for (local i = 0; i < count; i++) {
            local msg = _container[i];
            msg.draw.visible = true;
            // TOP-RIGHT
            //msg.draw.setPosition(8192 - width, ypos);
            // LEFT-CENTER
            msg.draw.setPosition(0, ypos);
            ypos += msg.draw.height+(msg.draw.height/2);
        }
    }
}

function GuiSystem::debugDraw(s_msg, s_id, i_time = 1, b_override = true) {
    local count = DebugMsgInfo._container.len();
    for (local i = 0; i < count; i++) {
        local msg = DebugMsgInfo._container[i];

        if (msg.id == s_id) {
            if (msg.override) {
                DebugMsgInfo._container.remove(i);
                DebugMsgInfo(s_msg, s_id, i_time, b_override);
                return true;
            } else {
                return false;
            }
        }
    }
    DebugMsgInfo(s_msg, s_id, i_time, b_override);
    return true;
}

function GuiSystem::onDebugRender() {
    DebugMsgInfo._onRender();
}
addEventHandler("onRender", function() {GuiSystem.onDebugRender()});

local _print = print;
function print(s_msg, s_id = null, i_time = 1, b_override = true) {
    // do console message
    _print(s_msg);

    // do UI message
    if (s_id != null) {
        debugText(s_msg, s_id, i_time, b_override);
    }
}

function debugText(s_msg, s_id = null, i_time = 1, b_override = true) {
    if (!GuiSystem.canDrawDebug)
        return;
    // do UI message
    if (s_id != null) {
        GuiSystem.debugDraw(s_msg, s_id, i_time, b_override);
    }
}

# END DEBUG UI

addEventHandler("onInit", function () {
    /**
     * GuiSystem.canDrawDebug = true;
    print("wtf works?")
    GuiSystem.popupRoot.setVisible(true);
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
    popupRoot.insert(window);
    print("end")
     */
})