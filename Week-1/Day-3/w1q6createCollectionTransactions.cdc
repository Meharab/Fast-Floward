import Artist from "./w1q5artist"

transaction() {
    prepare(account: AuthAccount) {
        account.save(
            <- Artist.createCollection(),
            to: /storage/ArtistPictureCollection
        )
        account.link<&Artist.Collection>(
            /public/ArtistPictureCollection,
            target: /storage/ArtistPicturePrinter
        )
    }
}