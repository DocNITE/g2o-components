enum InvContainerMode {
  INV_MODE_DEFAULT    = 0,
  INV_MODE_CONTAINER  = 1,
  INV_MODE_PLUNDER    = 2,
  INV_MODE_STEAL      = 3,
  INV_MODE_BUY        = 4,
  INV_MODE_SELL       = 5,
  INV_MODE_MAX        = 32
}

enum InvItemCategory {
  INV_NONE    = 0,
  INV_COMBAT  = 1,
  INV_ARMOR   = 2,
  INV_RUNE    = 3,
  INV_MAGIC   = 4,
  INV_FOOD    = 5,
  INV_POTION  = 6,
  INV_DOCS    = 7,
  INV_OTHER   = 8,
  INV_MAX     = 32
}

enum InvAnchorMode {
  TOP_RIGHT     = 0,
  BOTTOM_RIGHT  = 1,
}

class InvContainer {
#private:
  m_drawlist = []
#public:
  /*
    List of all Items in Container
  */
  contents = [] 

  /*
    inventory mode
  */
  invMode = InvContainerMode.INV_MODE_DEFAULT

  /*
    Current selected item
  */
  selectedItem = 0
  
  /*
    passive = only used for display
  */
  passive = false

  /*
    Used for anchor position on screen
  */
  anchorMode = InvAnchorMode.TOP_RIGHT

  /*
    Used for drawing UI elements and something
  */
  function onRender(dt) {
    m_drawlist = [];

    local scr = getResolution();

# DRAW SLOTS START
    local vx = 0
    local vy = 0
    local posx = 0
    local posy = 0

    for (local i = 0; i < InventorySystem.INV_MAX_SLOTS_COL; i++) {
      vx += InventorySystem.INV_ITEM_SIZEX
    }
      
    posx = scr.x - InventorySystem.INV_PADDING - vx

    if (InventorySystem.INV_SIZEABLE_HEIGHT) {
      // TODO: Anchor support
      do {
        vy += InventorySystem.INV_ITEM_SIZEY
      } while ((vy + InventorySystem.INV_ITEM_SIZEY) < (scr.y-(InventorySystem.INV_ITEM_SIZEY)-(InventorySystem.INV_PADDING)))
        
      posy = (InventorySystem.INV_PADDING) + (InventorySystem.INV_ITEM_SIZEY)
    } else {
      // TODO: Anchor support
      for (local i = 0; i < InventorySystem.INV_MAX_SLOTS_ROW; i++) {
        vy += InventorySystem.INV_ITEM_SIZEY
      }
            
      posy = (InventorySystem.INV_PADDING) + (InventorySystem.INV_ITEM_SIZEY)
    }
    
    local btex = Texture(anx(posx), any(posy), anx(vx), any(vy), InventorySystem.TEX_INV_BACK)
    btex.visible = true
    m_drawlist.push(btex)
    
    local mrows; // all show possible rows on screen
    if (InventorySystem.INV_SIZEABLE_HEIGHT)
      mrows = (vy/70);
    else
      mrows = InventorySystem.INV_MAX_SLOTS_ROW; // fixed rows
    
    local sx = 0
    local sy = 0
    for (local x = 0; x < InventorySystem.INV_MAX_SLOTS_COL; x++) {
      sx = posx + (x * InventorySystem.INV_ITEM_SIZEX)
      sy = posy
      for (local y = 0; y < mrows; y++) {
        local stex = Texture(anx(sx), 
                            any(sy), 
                            anx(InventorySystem.INV_ITEM_SIZEX), 
                            any(InventorySystem.INV_ITEM_SIZEY),
                            InventorySystem.TEX_INV_ITEM)
        stex.visible = true
        m_drawlist.push(stex)
        sy += InventorySystem.INV_ITEM_SIZEY
      }
    }

# DRAW SLOTS END
  }

  /*
    Used for detecting keyboard key press
  */
  function onKey(key) {

  }
}
