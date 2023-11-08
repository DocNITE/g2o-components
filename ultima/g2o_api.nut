try {
  G2O_API
} catch(e) {
  G2O_API <- false
}

if (!G2O_API) return

local function removeGothicContent() {
  clearMultiplayerMessages()
  setFreeze(true)
  disableControls(true)

  Camera.movementEnabled = false
  Camera.setPosition(65000,0,65000)
  Camera.setRotation(90,0,0)
}

addEventHandler("onInit", function() {
  removeGothicContent()
  // initialize & start the game
  init({})
  enableEvent_Render(true)
})

addEventHandler("onRender", function() {
  // rend game screen
  local dt = getTickCount();
  render(dt)
})

