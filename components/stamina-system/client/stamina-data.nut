local myData = null;

class StaminaData extends SharedStaminaData {
    static function onPacket(packet) {
        local packetid = packet.readUInt16();
        switch (packetid) {
            case StaminaPacketId.Change:
                if (myData == null)
                    myData = StaminaData();
                myData.value = packet.readUInt16();
                myData.maxValue = packet.readUInt16();
                // call event for scripts
                callEvent("onStaminaChanged", myData);
                break;
        }
    }
}

addEventHandler ("onPacket", StaminaData.onPacket);