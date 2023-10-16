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

enum InvAnchor {
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
    Used for drawing UI elements and something
  */
  function onRender() {

  }
}
