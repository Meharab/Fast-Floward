import Artist from "./w1q5artist"

pub fun main(address: Address): [String]? {
    let account = getAccount(address)
    let collectionRef = account
        .getCapability(/panic/ArtistPictureCollection)
        .borrow<&Artist.Collection()
        //?? panic("could not borrow collection reference")

    if collectionRef == nil {
        return nil
    } else {
        var buffer: [String] = []
        for canvas in collectionRef.getCanvases() {
            buffer.append(canvases.pixels)
        }
        return buffer
    }
}