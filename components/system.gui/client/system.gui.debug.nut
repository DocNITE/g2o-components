/**
* @public
* @description draw debug ui on screen. Enable it with `GuySystem.canDrawDebug = true`
*/
GuiSystem.canDrawDebug <- false

local _draws = []
local _container = []

class DebugMsgInfo {
    # private
        m_endTime = -1
        m_destroy = false
    # public:
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

            _container.push(this);
        }

        function update(dt) {
            if (dt > m_endTime && time > 0) {
                this.m_destroy = true;
            }
            return this.m_destroy;
        }

        static function _onRender() {
            _draws = [];

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
                _draws.push(Draw(0, 0, msg.id + ": " + msg.message));
            }
            // Size elements
            local width = 0;
            for (local i = 0; i < count; i++) {
                local msg = _container[i];
                local draw = _draws[i];
                if (draw.widthPx > width)
                    width = draw.widthPx;
            }
            local height = 0;
            for (local i = 0; i < count; i++) {
                local msg = _container[i];
                local draw = _draws[i];
                height += draw.heightPx+(draw.heightPx/2);
            }
            // reposition
            //local ypos = 0;
            local ypos = ((getResolution().y/2)-(height/2));
            for (local i = 0; i < count; i++) {
                local msg = _container[i];
                local draw = _draws[i];
                draw.visible = true;
                // TOP-RIGHT
                //msg.draw.setPosition(8192 - width, ypos);
                // LEFT-CENTER
                draw.setPositionPx(10, ypos);
                ypos += draw.heightPx+(draw.heightPx/2);
            }
        }
    }

    function GuiSystem::debugDraw(s_msg, s_id, i_time = 1, b_override = true) {
        local count = _container.len();
        for (local i = 0; i < count; i++) {
            local msg = _container[i];

            if (msg.id == s_id) {
                if (msg.override) {
                    _container.remove(i);
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
            debugText(s_id, s_msg, i_time, b_override);
        }
    }

    function debugText(s_id, s_msg, i_time = 1, b_override = true) {
        if (!GuiSystem.canDrawDebug)
            return;

        GuiSystem.debugDraw(s_msg, s_id, i_time, b_override);
    }