import SomeContract from "./w2q1accessControl.cdc"

pub fun main() {
  // Area 4
  // Variables that can be read: a b .
  log(SomeContract.testStruct.a)
  log(SomeContract.testStruct.b)
  // Variables that can be modified: a .
  SomeContract.testStruct.a = 138
  log(SomeContract.testStruct.a)
  // Functions that can be accessed: publicFunc 
  SomeContract.testStruct.publicFunc()

  SomeContract.testStruct.structFunc()
  SomeContract.testStruct.resourceFunc()
  SomeContract.testStruct.questsAreFun()

}
