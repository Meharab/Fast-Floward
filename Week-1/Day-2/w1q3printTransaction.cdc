import Artist from "./w1q3artist.cdc"

transaction() {
  
  let pixels: String
  let picture: @Artist.Picture?
  let collectionRef: &Artist.Collection

  prepare(account: AuthAccount) {
    let printerRef = getAccount(0x02)
      .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
      .borrow()
      ?? panic("Couldn't borrow printer reference.")

      self.collectionRef = account
        .getCapability(/public/ArtistPictureCollection)
        .borrow<&Artist.Collection>()
        ?? panic("couldn't borrow collection reference")
    
    // Replace with your own drawings.
    self.pixels = "*   * * *   *   * * *   *"
    let canvas = Artist.Canvas(
      width: 5,
      height: 5,
      pixels: self.pixels
    )
    
    self.picture <- printerRef.print(canvas: canvas)
  }

  execute {
    if (self.picture == nil) {
      log("Picture with ".concat(self.pixels).concat(" already exists! can't print for dublicate canvas"))
      destroy self.picture
    } else {
      log("Picture printed!")
      self.collectionRef.deposit(picture: <- self.picture!)
    }

    
  }
}
