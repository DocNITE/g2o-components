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

class InvItem {
#public:
  instance = null
  amount = 0
  name = null

  constructor(instance, amount, name = null) {
    this.instance = instance
    this.amount = amount
    this.name = name
  }
}

class InvContainer {
#private:
  m_drawlist = []
  m_itemrend = []
  m_inforend = null
#public:
  /*
    List of all Items in Container
  */
  contents = [] 

  /*
    Inv owner. NULL - is chest or some container
  */
  npc = null

  /*
    inventory mode
  */
  invMode = InvContainerMode.INV_MODE_DEFAULT

  /*
    Current selected item
  */
  selectedItem = 0

  /*
    View slots offset for rows scrolling
  */
  offset = 0
  
  /*
    passive = only used for display
  */
  passive = false

  /*
    Used for anchor position on screen
  */
  anchorMode = InvAnchorMode.TOP_RIGHT

  /*
    Get all equiped items on character
  */
  function getEquippedItems() {
    local result = []

    if (npc == null) 
      return result
    
    result.push(Items.name(getPlayerArmor(npc)))
    result.push(Items.name(getPlayerAmulet(npc)))
    result.push(Items.name(getPlayerBelt(npc)))
    result.push(Items.name(getPlayerHelmet(npc)))
    result.push(Items.name(getPlayerMeleeWeapon(npc)))
    result.push(Items.name(getPlayerRangedWeapon(npc)))
    result.push(Items.name(getPlayerRing(npc, HAND_LEFT)))
    result.push(Items.name(getPlayerRing(npc, HAND_RIGHT)))
    result.push(Items.name(getPlayerShield(npc)))
    result.push(Items.name(getPlayerSpell(npc, 0)))
    result.push(Items.name(getPlayerSpell(npc, 1)))
    result.push(Items.name(getPlayerSpell(npc, 2)))
    result.push(Items.name(getPlayerSpell(npc, 3)))
    result.push(Items.name(getPlayerSpell(npc, 4)))
    result.push(Items.name(getPlayerSpell(npc, 5)))
    result.push(Items.name(getPlayerSpell(npc, 6)))

    return result
  }

  /*
    Check if item was equiped
  */
  function isItemEquipped(instanceItem) {
    local arr = getEquippedItems()
    foreach (item in arr) {
      if (item == instanceItem)
        return true
    }
    return false
  }

  /*
    Used for drawing UI elements and something
  */

  function onRender(dt) {
    m_drawlist = [];

    local scr = getResolution();

# DRAW ITEM INFO START
    local iname = ""
    if (selectedItem >= 0 && selectedItem < contents.len() && contents[selectedItem] != null)
      iname = contents[selectedItem].name

    local inameDraw = Draw(0, 0, iname)
    local ifontheight = inameDraw.heightPx
    local iscrh = (6 + 2 + 1) * ifontheight
    local iscrw = InventorySystem.INV_SCALE_X - (InventorySystem.INV_PADDING*2)
    local iscrx = (scr.x/2) - (InventorySystem.INV_SCALE_X/2) + (InventorySystem.INV_PADDING)
    local iscry = (scr.y) - (InventorySystem.INV_PADDING) - (iscrh)

    if (iname != "") {
      local sitem = contents[selectedItem]
      local instance = Daedalus.instance(sitem.instance)

      local ibtex = Texture(anx(iscrx), any(iscry), anx(iscrw), any(iscrh), InventorySystem.TEX_INV_BACK)
      ibtex.visible = true
      m_drawlist.push(ibtex)

      local ibbtex = Texture(anx(iscrx), any(iscry), anx(iscrw), any(iscrh), InventorySystem.TEX_INV_ITEMINFO)
      ibbtex.visible = true
      m_drawlist.push(ibbtex)

      local ifontpadding = inameDraw.heightPx/2
      
      inameDraw.text = instance.name
      inameDraw.setPositionPx(iscrx + (iscrw/2) - (inameDraw.widthPx/2), iscry + ifontpadding)
      inameDraw.visible = true
      m_drawlist.push(inameDraw)

      local infoColor = InventorySystem.INV_COLOR_DEFAULT
      local nameColor = InventorySystem.INV_COLOR_LIGHT

      if (m_inforend == null) {
        m_inforend = ItemRender(0, 0, 0, 0, "")
        m_inforend.visible = true
      }

      local irend = m_inforend
      irend.zbias = instance.inv_zbias
      irend.rotX  = instance.inv_rotx
      irend.rotY  = instance.inv_roty
      irend.rotZ  = instance.inv_rotz
      irend.setPositionPx(iscrx + (iscrw - iscrh - InventorySystem.INV_ITEM_INFO_PADDING - ifontpadding), iscry)
      irend.setSizePx(iscrh, iscrh)
      if (irend.instance != sitem.instance)
        irend.instance = sitem.instance
      irend.top()

      print(irend.instance)
      print(irend.getPosition().x)

      for (local i = 0; i < 6; i++) {
        local posy = iscry + ifontpadding + ((i+2) * ifontheight)
    
        local nameDraw = Draw(anx(iscrx + ifontpadding), any(posy), instance.text[i])
        nameDraw.setColor(nameColor.r, nameColor.g, nameColor.b)
        nameDraw.alpha = nameColor.a
        nameDraw.visible = true
        m_drawlist.push(nameDraw)
        
        if (instance.count[i] != 0) {
          local valueDraw = Draw(0, 0, instance.count[i])
          valueDraw.setPositionPx((iscrx + iscrw) - ifontpadding - valueDraw.widthPx, posy)
          valueDraw.setColor(infoColor.r, infoColor.g, infoColor.b)
          valueDraw.alpha = infoColor.a
          valueDraw.visible = true
          m_drawlist.push(valueDraw)
        }
      }
    } else {
      if (m_inforend != null) {
        if (m_inforend.instance != "")
          m_inforend.instance = ""
      }      
    }


# DRAW ITEM INFO END

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
      } while ((vy + InventorySystem.INV_ITEM_SIZEY) < (scr.y-(InventorySystem.INV_ITEM_SIZEY)-(InventorySystem.INV_PADDING)-iscrh))
        
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

    local mcols = InventorySystem.INV_MAX_SLOTS_COL
    local mrows; // all show possible rows on screen
    if (InventorySystem.INV_SIZEABLE_HEIGHT)
      mrows = (vy/InventorySystem.INV_ITEM_SIZEY)
    else
      mrows = InventorySystem.INV_MAX_SLOTS_ROW // fixed rows
    
    // Initialize and update itemRender UI
    onItemRender(mcols, mrows, posx, posy)
    
    local mslots = mcols * mrows
    local ccount = contents.len()
    for (local i = 0; i < mslots; i++) {
      local sx = (i % mcols) * (InventorySystem.INV_ITEM_SIZEX)
      local sy = (floor(i / mcols)) * (InventorySystem.INV_ITEM_SIZEY)
      
      local slot = i

      // Draw background slot texture
      local stexStr = InventorySystem.TEX_INV_ITEM

      if (ccount > 0 && slot < ccount && slot >= 0) {
        if (selectedItem == slot && !isItemEquipped(contents[selectedItem].instance)) 
          stexStr = InventorySystem.TEX_INV_ITEM_HIGHLIGHTED
        else if (selectedItem == slot && isItemEquipped(contents[selectedItem].instance))
          stexStr = InventorySystem.TEX_INV_ITEM_ACTIVATED_HIGHLIGHTED
        else if (isItemEquipped(contents[slot].instance))
          stexStr = InventorySystem.TEX_INV_ITEM_ACTIVATED
      } else {
        if (ccount == 0 && selectedItem == slot)
          stexStr = InventorySystem.TEX_INV_ITEM_HIGHLIGHTED
      }

      local stex = Texture(anx(posx+sx), 
                          any(posy+sy), 
                          anx(InventorySystem.INV_ITEM_SIZEX), 
                          any(InventorySystem.INV_ITEM_SIZEY),
                          stexStr)
      stex.visible = true
      m_drawlist.push(stex)
 
      if (ccount > 0 && slot < ccount && slot >= 0) {
        // Draw item render objects in slot
        local sitem = contents[slot];
        local instance = Daedalus.instance(sitem.instance)

        local srx = posx+sx
        local sry = posy+sy
        local srw = InventorySystem.INV_ITEM_SIZEX
        local srh = InventorySystem.INV_ITEM_SIZEY

        if (selectedItem == slot) {
          srx -= InventorySystem.INV_ITEM_SELECTED_PADDING
          sry -= InventorySystem.INV_ITEM_SELECTED_PADDING
          srw += InventorySystem.INV_ITEM_SELECTED_PADDING * 2
          srh += InventorySystem.INV_ITEM_SELECTED_PADDING * 2
        }

        local srend = m_itemrend[slot]
        srend.zbias = instance.inv_zbias
        srend.rotX  = instance.inv_rotx
        srend.rotY  = instance.inv_roty
        srend.rotZ  = instance.inv_rotz
        srend.setPositionPx(srx, sry)
        srend.setSizePx(srw, srh)
        if (srend.instance != sitem.instance)
          srend.instance = sitem.instance
        srend.top()
        
        // Draw additional info, like equiped and amount
        local amountColor = InventorySystem.INV_COLOR_DEFAULT
        local eqColor = InventorySystem.INV_COLOR_HOTKEY

        local padding = InventorySystem.INV_ITEM_TEXT_PADDING
        
        if (sitem.amount > 1) {
          local samountDraw = Draw(0, 0, sitem.amount)
          samountDraw.setScale(1,1)
          samountDraw.setPositionPx((posx+sx)+InventorySystem.INV_ITEM_SIZEX-samountDraw.widthPx - padding, 
                                    (posy+sy)+InventorySystem.INV_ITEM_SIZEY-samountDraw.heightPx - padding)
          samountDraw.setColor(amountColor.r,
                                amountColor.g, 
                                amountColor.b)
          samountDraw.alpha = amountColor.a
          samountDraw.visible = true
          m_drawlist.push(samountDraw)
        }
      } else {
         local srend = m_itemrend[slot]
         if (srend.instance != "")
          srend.instance = ""
      }
    }
# DRAW SLOTS END
  }

  /*
    Well... We should create static UI ItemRender objects
    for more perfomance. And then update it in onRender method
  */
  function onItemRender(mcols, mrows, posx, posy) {
    local mslots = mcols * mrows
    local ccount = contents.len()

    if (mslots == m_itemrend.len())
      return;
    
    // clear old content
    m_itemrend = []
    
    for (local i = 0; i < mslots; i++) {
      local sx = (i % mcols) * (InventorySystem.INV_ITEM_SIZEX)
      local sy = (floor(i / mcols)) * (InventorySystem.INV_ITEM_SIZEY)

      if (i >= 0) {
        local srx = posx+sx
        local sry = posy+sy
        local srw = InventorySystem.INV_ITEM_SIZEX
        local srh = InventorySystem.INV_ITEM_SIZEY
      
        local srend = ItemRender(anx(srx),
                                any(sry),
                                anx(srw),
                                any(srh),
                                "")
        srend.visible = true
        m_itemrend.push(srend)
      }
    }
  }

  /*
    Used for detecting keyboard key press
  */
  function onKey(key) {

  }

  function _getSlot(x, y) {
    return InventorySystem.INV_MAX_SLOTS_COL * y + x
  }
}

/*
*zCListSort<oCItem>* oCItemContainer::JumpOffset (zBOOL& isAtTop, zBOOL& isAtBottom)
{
	isAtTop = TRUE;

	if (!contents)			return NULL;
	if  (selectedItem<0)	return contents->GetNextInList();
	
	// Calculate Offset
	if (selectedItem+1 > contents->GetNumInList()) 
	{
		selectedItem = contents->GetNumInList()-1;
		CheckSelectedItem();
	}
	
	if (selectedItem < offset) 
	{
		offset = offset - maxSlotsRow;
		if (offset<0) offset = 0;
	};
	
	// Jump Offset in List	
	zCListSort <oCItem>* node = contents->GetNextInList();		
	for (int i=0; i<offset; i++) 
	{
		if (node) node = node -> GetNextInList();
	}

	isAtTop	= (offset==0);
	return node;
}*/
/*
  function onRender(dt) {
    m_drawlist = [];

    local scr = getResolution();

# DRAW ITEM INFO START
// TODO: Item info support
# DRAW ITEM INFO END

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

    local mcols = InventorySystem.INV_MAX_SLOTS_COL
    local mrows; // all show possible rows on screen
    if (InventorySystem.INV_SIZEABLE_HEIGHT)
      mrows = (vy/InventorySystem.INV_ITEM_SIZEY)
    else
      mrows = InventorySystem.INV_MAX_SLOTS_ROW // fixed rows

    // Initialize and update itemRender UI
    onItemRender(mcols, mrows, posx, posy)

    local mslots = mcols * mrows
    local ccount = contents.len()
    for (local i = 0; i < mslots; i++) {
      local sx = (i % mcols) * (InventorySystem.INV_ITEM_SIZEX)
      local sy = (floor(i / mcols)) * (InventorySystem.INV_ITEM_SIZEY)
      
      local slot = i
      local stexStr = InventorySystem.TEX_INV_ITEM

      if (ccount > 0 && slot < ccount && slot >= 0) {
        if (selectedItem == slot && !isItemEquipped(contents[selectedItem].instance)) 
          stexStr = InventorySystem.TEX_INV_ITEM_HIGHLIGHTED
        else if (selectedItem == slot && isItemEquipped(contents[selectedItem].instance))
          stexStr = InventorySystem.TEX_INV_ITEM_ACTIVATED_HIGHLIGHTED
        else if (isItemEquipped(contents[slot].instance))
          stexStr = InventorySystem.TEX_INV_ITEM_ACTIVATED
      } else {
        if (ccount == 0 && selectedItem == slot)
          stexStr = InventorySystem.TEX_INV_ITEM_HIGHLIGHTED
      }

      local stex = Texture(anx(posx+sx), 
                          any(posy+sy), 
                          anx(InventorySystem.INV_ITEM_SIZEX), 
                          any(InventorySystem.INV_ITEM_SIZEY),
                          stexStr)
      stex.visible = true
      m_drawlist.push(stex)

      if (ccount > 0 && slot < ccount && slot >= 0) {
        print("try draw item")
        local sitem = contents[slot];
        local instance = Daedalus.instance(sitem.instance)

        local srx = posx+sx
        local sry = posy+sy
        local srw = InventorySystem.INV_ITEM_SIZEX
        local srh = InventorySystem.INV_ITEM_SIZEY

        if (selectedItem == slot) {
          srx -= InventorySystem.INV_ITEM_SELECTED_PADDING
          sry -= InventorySystem.INV_ITEM_SELECTED_PADDING
          srw += InventorySystem.INV_ITEM_SELECTED_PADDING * 2
          srh += InventorySystem.INV_ITEM_SELECTED_PADDING * 2
        }

        local srend = m_itemrend[slot]
        srend.zbias = instance.inv_zbias
        srend.rotX  = instance.inv_rotx
        srend.rotY  = instance.inv_roty
        srend.rotZ  = instance.inv_rotz
        srend.setPositionPx(srx, sry)
        srend.setSizePx(srw, srh)
        srend.instance = sitem.instance
        srend.top()
        //srend.visible = true
      } else {
         local srend = m_itemrend[slot]
         srend.instance = ""
      }
    }
# DRAW SLOTS END
  }

  function onItemRender(mcols, mrows, posx, posy) {
    local mslots = mcols * mrows
    local ccount = contents.len()

    if (mslots == m_itemrend.len())
      return;

    // clear old content
    m_itemrend = []

    for (local i = 0; i < mslots; i++) {
      local sx = (i % mcols) * (InventorySystem.INV_ITEM_SIZEX)
      local sy = (floor(i / mcols)) * (InventorySystem.INV_ITEM_SIZEY)

      if (i >= 0) {
        local srx = posx+sx
        local sry = posy+sy
        local srw = InventorySystem.INV_ITEM_SIZEX
        local srh = InventorySystem.INV_ITEM_SIZEY
      
        local srend = ItemRender(anx(srx),
                                any(sry),
                                anx(srw),
                                any(srh),
                                "")
        srend.visible = true
        m_itemrend.push(srend)
      }
    }
  }

*/
