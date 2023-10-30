class coolClass {
  val = 34
  constructor() {

  }
}

local obj = coolClass()
obj.val = 50

if (obj instanceof coolClass)
  print("da it yes")
