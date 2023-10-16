InventorySystem <- {
  /*
    Used in currently time container
  */
  openedContainer = null
}

/*
  src: oInventory.h  line: 27  
  Used for columns and rows amount for inventory
  But! For default ros must be sizeable for 
  screen resolution, like original game!
*/
InventorySystem.INV_MAX_SLOTS_COL <- 5
InventorySystem.INV_MAX_SLOTS_ROW <- 2

/*
  src: oInventory.cpp  line: 91
  All textures description
*/
InventorySystem.TEX_INV_BACK				                <- "INV_BACK.TGA";						// standard background (all)
InventorySystem.TEX_INV_BACK_CONTAINER					  	<- "INV_BACK_CONTAINER.TGA";				// background container (all)
InventorySystem.TEX_INV_BACK_PLUNDER					    	<- "INV_BACK_PLUNDER.TGA";				// background plunder target (all)
InventorySystem.TEX_INV_BACK_STEAL						     	<- "INV_BACK_STEAL.TGA";					// background steal target (all)
InventorySystem.TEX_INV_BACK_BUY						      	<- "INV_BACK_BUY.TGA";					// background trade - trader (all)
InventorySystem.TEX_INV_BACK_SELL							      <- "INV_BACK_SELL.TGA";					// background trade - player (all)
InventorySystem.TEX_INV_TITLE								        <- "INV_TITLE.TGA";						// inventory title (border)
InventorySystem.TEX_INV_ITEM								        <- "INV_SLOT.TGA";						// normal slot (border)
InventorySystem.TEX_INV_ITEM_ACTIVATED					  	<- "INV_SLOT_EQUIPPED.TGA";				// equipped slot (border)
InventorySystem.TEX_INV_ITEM_ACTIVATED_HIGHLIGHTED	<- "INV_SLOT_EQUIPPED_HIGHLIGHTED.TGA";	// equipped and higlighted slot (border)
InventorySystem.TEX_INV_ITEM_HIGHLIGHTED				  	<- "INV_SLOT_HIGHLIGHTED.TGA";			// higlighted slot (border)
InventorySystem.TEX_INV_ITEMINFO							      <- "INV_DESC.tga";						// item description (border)
InventorySystem.TEX_INV_ARROW_TOP							      <- "O.TGA";								// up arrow
InventorySystem.TEX_INV_ARROW_BOTTOM						    <- "U.TGA";								// down arrow

InventorySystem.INV_COLOR_LIGHT	  <- InvColor(255, 255, 255, 255);	// inactive title font color (light grey)
InventorySystem.INV_COLOR_DEFAULT	<- InvColor(255, 255, 255, 255);	// default text color (grey)
InventorySystem.INV_COLOR_BRIGHT  <- InvColor(255, 255, 255, 255);	// highlighted text color (white)
InventorySystem.INV_COLOR_HOTKEY  <- InvColor(255, 0, 0, 255);	// hotkey font color (red)

/*
  src: oInventory.cpp  line: 125
  Slot size
*/
InventorySystem.INV_ITEM_SIZEX			<- 70; // Pixel (eigentlich 100)
InventorySystem.INV_ITEM_SIZEY			<- 70; // Pixel (eigentlich 100)

/* 
  src: oInventory.cpp  line: 79
  base ui scaling
*/ 
InventorySystem.INV_SCALE_X <- 800;
InventorySystem.INV_SCALE_Y <- 600;

InventorySystem.INV_PADDING <- 32;

InventorySystem.INV_AMOUNT_TEXT_PADDING <- 10;

/*
  Size rows for screen height resolution
*/
InventorySystem.sizeableRows <- true

addEventListener("onInit", function () {
    print("system.inventory was running!")
  })
