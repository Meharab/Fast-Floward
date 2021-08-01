import Artist from "./w1q5artist"

transaction(width: Int, height: Int, pixels: String) {
    prepare(account: AuthAccount) {
        let printerRef = getAccount(f8d6e0586b0a20c7)
            .getCapability(/public/ArtistPicturePrinter)
            .borrow<&Artist.Printer>()
            ?? panic("could not borrow printer reference")

        let collectionRef = account
            .getCapability(/public/ArtistPictureCollection)
            .borrow<&Artist.Collection>()
            ?? panic("could not borrow collection reference")
        
        let picture <- printerRef.print(
            width: width,
            height: height,
            pixels: pixels
        )
        if picture != nil {
            collectionRef.deposit(picture <- picture)
        } else {
            destroy picture
        }
    }
}