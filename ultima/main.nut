function init(args) {
  // initialize systems
  r_init()
  // log 
  print("Game succesful running!")
}

function render(dt) {
  r_drawdemo()
}

local jx = -16;
local jy = -16;
function r_drawdemo() {
  local screen = r_scr_res() 

  r_restore()

  if (jx < 300 && jy <= -16) {
    jx++
  } else if (jx >= 300 && jy < 300) {
    jy++
  } else if (jy > -16 && jx > -16) {
    jx--
    jy--
  }

  r_setcol(0, 255, 0)
  r_drawrect(jx, jy, jx+64, jy+64)
  r_setcol(255, 0, 0)
  r_drawtext(jx, jy+64, "Hello World!")

  r_blit()

  if (isKeyToggled(KEY_ESCAPE))
    exitGame()
}

