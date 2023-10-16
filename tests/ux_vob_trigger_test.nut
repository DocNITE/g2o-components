if (CLIENT_SIDE)
{
  addEventHandler("onInit", function() {
          InventorySystem.openedContainer = InvContainer();
          print("test is uppun!")
      })
}
else
{
  addEventHandler("onInit", function(){
      //MiningSystem.createMine({position = [0,50, -600], vobVisual = "MIN_ORE_BIG_V1.3DS", vobPosition = [0, 50, -600]})
      })
}
