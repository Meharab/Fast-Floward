import Artist from "./w1q3artist.cdc"

pub fun main() {
  let accounts = [
    getAccount(0x01),
    getAccount(0x02),
    getAccount(0x03),
    getAccount(0x04),
    getAccount(0x05)
    ]

  for account in accounts {
    let collectionRef = account
      .getCapability(/public/ArtistPictureCollection)
      .borrow<&Artist.Collection>()

    if collectionRef == nil {
      log("account".concat(account.address.toString()).concat(" does not have a picture collection"))
    } else {
       log("account's".concat(account.address.toString()).concat(" pictures"))
       var pictureNumber = 1
       for canvas in collectionRef!.getCanvases() {
        var rowIndex = 0
        log("picture #".concat(pictureNumber.toString()))
        while rowIndex < canvas.height {
          let row = canvas.pixels.slice(from: rowIndex * canvas.width, upTo: (rowIndex + 1) * canvas.width)
          log(row)
          rowIndex = rowIndex + 1
        }
        pictureNumber = pictureNumber + 1

       }
    }
  }
}
