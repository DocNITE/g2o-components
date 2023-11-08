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

class label_t {
  font = "FONT_OLD_20_WHITE_HI"
  content = ""
  x = 0
  y = 0
  rotate = 0
  color = color_t()
}

local _color = color_t()

# API START

function r_setcol(r, g, b, a = 255) {
  _color = color_t(r, g, b, a)
}

function r_clrcol() {
  _color = color_t()
}

function r_drawrect(x1, y1, x2, y2) {
  local img = image_t()
  img.x = x1
  img.y = y2
  img.width = (x2-x1)
  img.height = (y2-y1)
  img.file = "white"
  img.color = _color
  r_pushbuf(img)
}

function r_drawtext(x, y, text, font = null) {
  local txt = label_t()
  txt.x = x
  txt.y = y
  txt.color = _color
  txt.content = text
  if (font)
    txt.font = font
  r_pushbuf(txt)
}

# API END

function r_draw_init() {}

