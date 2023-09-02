/**
 * @public
 * @description send popup message for specific player
 *
 * @param {int} iPlayerId playerd id
 * @param {string} sText sended message
 */
function GuiSystem::addPopupMessage(iPlayerId, sText) {
    local packet = Packet();
    packet.writeUInt16(GuiPacketId.Send);
    packet.writeString(sText);
    packet.send(iPlayerId, RELIABLE_ORDERED);
}

// You know...
function sendPopupMessage(iPlayerId, sText) {
    GuiSystem.addPopupMessage(iPlayerId, sText);
}