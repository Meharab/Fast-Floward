access(all) contract SomeContract {
    pub var testStruct: SomeStruct

    pub struct SomeStruct {
        // 4 Variables
        // 
        pub(set) var a: String

        pub var b: String

        access(contract) var c: String

        access(self) var d: String

        // 3 Functions
        //
        pub fun publicFunc() {
            log("publicFunc is called")
        }

        access(self) fun privateFunc() {
            log("privateFunc is called")
        }

        access(contract) fun contractFunc() {
            log("contractFunc is called")
        }


        pub fun structFunc() {
            // Area 1
            // Variables that can be read: a b c d.
            log(self.a)
            log(self.b)
            log(self.c)
            log(self.d)
            // Variables that can be modified: a b c d.
            self.a = 0
            self.b = 1
            self.c = 3
            self.d = 8

            log(self.a)
            log(self.b)
            log(self.c)
            log(self.d)
            // Functions that can be accessed: publicFunc privateFunc contractFunc
            self.publicFunc()
            self.privateFunc()
            self.contractFunc()
        }

        init() {
            self.a = "a"
            self.b = "b"
            self.c = "c"
            self.d = "d"
        }
    }

    pub resource SomeResource {
        pub var e: Int

        pub fun resourceFunc() {
            // Area 2
            // Variables that can be read: a b c .
            log(self.a)
            log(self.b)
            log(self.c)
            // Variables that can be modified: a .
            self.a = 1

            log(self.a)
            // Functions that can be accessed: publicFunc contractFunc
            self.publicFunc()
            self.contractFunc()
        }

        init() {
            self.e = 38
        }
    }

    pub fun createSomeResource(): @SomeResource {
        return <- create SomeResource()
    }

    pub fun questsAreFun() {
        // Area 3
        // Variables that can be read: a b c .
        log(self.a)
        log(self.b)
        log(self.c)
        // Variables that can be modified: a .
        self.a = 1

        log(self.a)
        // Functions that can be accessed: publicFunc contractFunc
        self.publicFunc()
        self.contractFunc()
    }

    init() {
        self.testStruct = SomeStruct()
    }
}
