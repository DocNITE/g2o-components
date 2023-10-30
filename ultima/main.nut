function init() {
  clearMultiplayerMessages()
  enableEvent_Render(true)
  setFreeze(true)

  Camera.movementEnabled = false
  Camera.setPosition(0,0,-500)
  Camera.setRotation(90,0,0)

  r_init()
}
addEventHandler("onInit", function (){init()})
