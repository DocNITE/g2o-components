# TASK -
# TODO: Add popup anhor on player support. It should be using for specific messages

enum PopupOrientation {
    LEFT    = 0,
    RIGHT   = 1,
    CENTER  = 2
}

enum PopupState {
    NONE    = 0, // null state
    OPEN    = 1, // when we create element
    WAIT    = 2, // wait until element close
    CHANGE  = 3, // change position (like push another)
    CLOSE   = 4  // close and destroy element
}

/**
 * @public
 * @description popup shows time, before close
 */
GuiSystem.popupTime <- 4
/**
 * @public
 * @description tween animation (for moving and closing)
 */
GuiSystem.popupAniTime <- 0.5
/**
 * @public
 * @description how many maximum we can show popups?
 */
GuiSystem.popupMaxAmount <- 10
/**
 * @public
 * @description you know... Ui offset of orientation
 */
GuiSystem.popupOffset <- {x = 100, y = 0}
/**
 * @public
 * @description TODO: Not used!
 */
GuiSystem.popupLineSize <- 300
/**
 * @public
 * @description element orintation
 */
GuiSystem.popupOrientation <- PopupOrientation.RIGHT

# GUI

/**
 * @private
 * @description contains all draws
 */
local _draws = []

class GUI.Popup extends GUI.Draw {
# private:
    mEndTime = -1
# public:
    alpha = 0
    xPosition = -1
    yPosition = -1

    time = -1
    state = PopupState.NONE
    tween = null

    ended = false

    constructor(arg) {
        base.constructor(arg)
        time = "time" in arg ? arg.time : time
    }

    function setState(eState, arg) {
      switch (eState) {
        case PopupState.OPEN:
            if (GuiSystem.popupOrientation == PopupOrientation.RIGHT)
                xPosition = getResolution().x
            else if (GuiSystem.popupOrientation == PopupOrientation.LEFT)
                xPosition = -(this.getSizePx().width)
            else
                xPosition = 0 // idk what i need set for CENTER orientation

            yPosition = arg.y

            local target = {xPosition = arg.x, alpha = 250}
            tween = Tween(GuiSystem.popupAniTime, this, target, Tween.easing.outCubic)

            this.setVisible(true);

            debugText("stamina.gui.popup.setVisible", "true", GuiSystem.popupTime);
            break;
        case PopupState.WAIT:
            mEndTime = getTickCount() + (time * 1000)
            // when is done - next we change to PopupState.CLOSE
            break;
        case PopupState.CHANGE:
            Tween(GuiSystem.popupAniTime, this, {yPosition = arg.y}, Tween.easing.outCubic);
            return; // we shouldn't change new state. It's just for remove elements
            break;
        case PopupState.CLOSE:
            local target = null;
            if (GuiSystem.popupOrientation == PopupOrientation.RIGHT)
                target = {xPosition = getResolution().x, alpha = 0}
            else if (GuiSystem.popupOrientation == PopupOrientation.LEFT)
                target = {xPosition = -(this.getSizePx().width), alpha = 0}
            else
                target = {yPosition = getResolution().y, alpha = 0}

            tween = Tween(GuiSystem.popupAniTime, this, target, Tween.easing.inCubic)
            // next we set ended = true
            // and ended marks that element was deleted
            break;
      }
      state = eState;
    }

    function render() {
        this.setPositionPx(xPosition, yPosition);

        if (alpha > 255)
            alpha = 255;

        this.setAlpha(alpha);

        debugText("system.gui.popup.info", "pos - " + xPosition + ", " + yPosition + " | alpha - " + alpha, 0.1);
    }

    function update(dt) {
        if (mEndTime == -1)
            return false

        if (dt > mEndTime)
            return true

        return false
    }
}

# END GUI

/**
 * @public
 * @description push popup message on screen
 *
 * @param {string} text you know
 */
function GuiSystem::addPopupMessage(text) {
    debugText("system.gui.popup.add", "true", GuiSystem.popupTime);

    local draw = GUI.Popup({time = GuiSystem.popupTime, text = text})
    // TODO: Add after it would be fix
    // draw.setLineSizePx(GuiSystem.popupLineSize)
    // draw.updateLineSize()
    local count = _draws.len()

    local clearFirst = false;

    if (count+1 > GuiSystem.popupMaxAmount)
        clearFirst = true;

    for (local i = 0; i < count; i++) {
        local popup = _draws[i]

        if (clearFirst && popup.state != PopupState.CLOSE) {
            popup.setState(PopupState.CLOSE, null)
            clearFirst = false;
            continue;
        }

        popup.setState(PopupState.CHANGE, {
            y = popup.getPositionPx().y + (popup.getSizePx().height*2 + (popup.getSizePx().height/2))
        })

        debugText("system.gui.popup.changed", i, GuiSystem.popupTime);
    }

    _draws.push(draw)

    debugText("system.gui.popup.addEnd", "true", GuiSystem.popupTime);
}

/**
 * @public
 * @description animation complete event handler
 *
 * @param {Tween} tween tween animation source
 */
function GuiSystem::onPopupTweenEnded(tween) {
    debugText("system.gui.popup.onTweenEndedStart", "true", GuiSystem.popupTime);

    local count = _draws.len();

    for (local i = 0; i < count; i++) {
        local popup = _draws[i];

        if (popup.tween == tween)
        {
            if (popup.state == PopupState.OPEN) {
                popup.setState(PopupState.WAIT, null)
            } else if (popup.state == PopupState.CLOSE) {
                popup.ended = true;
                popup.tween = null;
                _draws.remove(i);
            }
        }
    }

    debugText("system.gui.popup.onTweenEndedEnd", "true", GuiSystem.popupTime);
}
addEventHandler("Tween.onEnded", function (tween) {GuiSystem.onPopupTweenEnded(tween)})

/**
 * @public
 * @description show popups on screen
 */
function GuiSystem::onPopupRender() {
    local count = _draws.len();
    local dt = getTickCount();

    debugText("system.gui.popup.count", count, 0.1);

    for (local i = 0; i < count; i++) {
        local popup = _draws[i];

        popup.render();

        if (popup.state == PopupState.NONE) {
            local target = {x = 0, y = 0};
            if (GuiSystem.popupOrientation == PopupOrientation.RIGHT) {
                target.x = (getResolution().x) - GuiSystem.popupOffset.x - popup.getSizePx().width;
                target.y = (getResolution().y/2) + GuiSystem.popupOffset.y;
            } else if (GuiSystem.popupOrientation == PopupOrientation.LEFT) {
                target.x = GuiSystem.popupOffset.x;
                target.y = (getResolution().y/2) + GuiSystem.popupOffset.y;
            } else if (GuiSystem.popupOrientation == PopupOrientation.CENTER) {
                target.x = (getResolution().x/2) + GuiSystem.popupOffset.x;
                target.y = (getResolution().y/2) + GuiSystem.popupOffset.y;
            }
            popup.setState(PopupState.OPEN, target)
        } else if (popup.state == PopupState.WAIT) {
            local result = popup.update(dt);
            if (result) {
                popup.setState(PopupState.CLOSE, null);
            }
        }
    }
}
addEventHandler("onRender", function () {GuiSystem.onPopupRender()})

/**
 * @public
 * @description give messages from server
 *
 * @param {Packet} packet network packet data
 */
function GuiSystem::onPopupPacket(packet) {
    switch (packet.readUInt16()) {
        case GuiPacketId.Send:
            GuiSystem.addPopupMessage(packet.readString());
            break;
    }
}
addEventHandler("onPacket", function (packet) {GuiSystem.onPopupPacket(packet)})

/**
 * @public
 * @description just global function for send popups
 *
 * @param {string} sText text lol
 */
function sendPopupMessage(sText) {
    GuiSystem.addPopupMessage(sText);
}