class color_t {
  r = 255
  g = 255
  b = 255
  a = 255

  constructor(r = 255, g = 255, b = 255, a = 255) {
    this.r = r
    this.g = g
    this.b = b
    this.a = a
  }
}

class image_t {
  file = "default"
  x = 0
  y = 0
  width = 0
  height = 0
  rotate = 0
  color = color_t()
}

// draw permanetly background screen with g2o api
local _back   = null
local _backl  = null
local _backr  = null
// using for game content rendering
local buffer = []
// using for drawing ui content with g2o api
local drawlist = []

function r_init() {
  local true_screen = getResolution()
  local screen = r_scr_res() 
  local mult = (true_screen.y+0.0)/(screen.y+0.0)
  local tw = screen.x * mult
  local th = screen.y * mult
  local tx = (true_screen.x/2) - (tw/2)
  local ty = (true_screen.y/2) - (th/2)
  local tlx = tx + tw
  local tly = ty + th

  _back = Texture(0, 0, 8191, 8191, "white")
  _back.setColor(0,0,0)
  _back.visible = true

  _backl = Texture(0, 0, anx(tx), any(th), "white")
  _backl.setColor(0,0,0)
  _backl.visible = true

  _backr = Texture(anx(tx+tw), 0, anx(tx), any(th), "white")
  _backr.setColor(0,0,0)
  _backr.visible = true

  addEventHandler("onRender", r_drawdemo)
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

  r_drawcube(jx, jy, 64, 64, 0, 255, 0)

  r_blit()
}

function r_drawcube(x, y, w, h, r, g, b) {
  local img = image_t()
  img.x = x
  img.y = y
  img.width = w
  img.height = h
  img.file = "white"
  img.color = color_t(r, g, b)
  buffer.push(img)
}

function r_scr_res() {
  return {x = (cfg.r_height_resolution*cfg.r_aspect_ratio), y = cfg.r_height_resolution}
}

function r_blit() {
  drawlist = []

  local true_screen = getResolution()
  local screen = r_scr_res() 
  local mult = (true_screen.y+0.0)/(screen.y+0.0)
  local tw = screen.x * mult
  local th = screen.y * mult
  local tx = (true_screen.x/2) - (tw/2)
  local ty = (true_screen.y/2) - (th/2)
  local tlx = tx + tw
  local tly = ty + th

  foreach(buf in buffer) {
    if (buf instanceof image_t) {
      local x = tx+buf.x*mult
      local y = ty+buf.y*mult
      local w = buf.width*mult
      local h = buf.height*mult
      local tex = Texture(anx(x), any(y), anx(w), any(h), buf.file)
      tex.setColor(buf.color.r, buf.color.g, buf.color.b)
      tex.alpha = buf.color.a
      tex.visible = true
      drawlist.push(tex)
    }
  }

  _backl.top()
  _backr.top()
}

function r_restore() {
  buffer = []
} 
