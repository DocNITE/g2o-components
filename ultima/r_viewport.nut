// using for game content rendering
local buffer = []
// using for drawing ui content with g2o api
local drawlist = []

# API START

function r_pushbuf(elem) {
  buffer.push(elem)
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

  local _back = Texture(0, 0, 8191, 8191, "white")
  _back.setColor(0,0,0)
  _back.visible = true
  drawlist.push(_back)

  foreach(buf in buffer) {
    if (buf instanceof image_t) {
      local x = tx+buf.x*mult
      local y = ty+buf.y*mult
      local w = buf.width*mult
      local h = buf.height*mult
      local tex = Texture(anx(x), any(y), anx(w), any(h), buf.file)
      tex.setColor(buf.color.r, buf.color.g, buf.color.b)
      tex.alpha = buf.color.a
      tex.rotation = buf.rotate
      tex.visible = true
      drawlist.push(tex)
    } else if (buf instanceof label_t) {
      local x = tx+buf.x*mult
      local y = ty+buf.y*mult
      local draw = Draw(anx(x), any(y), buf.content)
      draw.rotation = buf.rotate
      draw.setColor(buf.color.r, buf.color.g, buf.color.b)
      draw.alpha = buf.color.a
      draw.setScale(mult, mult)
      draw.visible = true
      drawlist.push(draw)
      draw.top()
      print(draw.widthPx)
      print(draw.text)
    }
  }

  local _backl = Texture(0, 0, anx(tx), any(th), "white")
  _backl.setColor(0,0,0)
  _backl.visible = true
  drawlist.push(_backl)

  local _backr = Texture(anx(tx+tw), 0, anx(tx), any(th), "white")
  _backr.setColor(0,0,0)
  _backr.visible = true
  drawlist.push(_backr)

}

function r_restore() {
  buffer = []
} 

# API END

function r_viewport_init() {}

