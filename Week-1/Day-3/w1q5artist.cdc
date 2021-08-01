pub contract Artist {
    pub event PicturePrintSuccess(pixels: String)
    pub event PicturePrintFailure(pixels: String)


  pub struct Canvas {

    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
      self.width = width
      self.height = height
      self.pixels = pixels
    }
  }

  pub resource Collection {
  pub let pictures: @[Picture]
  init() {
    self.pictures <- []
  }
  pub fun deposit(picture: @Picture){
    self.pictures.append(<- picture)
  }
  pub fun getCanvases(): [Canvas] {
    var canvases: [Canvas] = []
    var index = 0
    while index < self.pictures.length {
      canvases.append(
        self.pictures[index].canvas
        )
      index = index + 1
    }
    return canvases
    }
  destroy() {
    destroy self.pictures
  }
}
  pub fun createCollection(): @Collection {
    return <- create Collection()
  }


  pub resource Picture {

    pub let canvas: Canvas
    
    init(canvas: Canvas) {
      self.canvas = canvas
    }
  }

  pub resource Printer {
    pub let prints: {String: Canvas}

    init() {
      self.prints = {}
    }

    pub fun print(width: Int, height: Int, pixels: String): @Picture {
      for symbol in pixels.utf8 {
        if symbol < 32 || symbol > 126 {
          return nil
        }
      }
    }

    pub fun print(canvas: Canvas): @Picture? {
      // Canvas needs to fit Printer's dimensions.
      if canvas.pixels.length != Int(self.width * self.height) {
        return nil
      }

      // Printer is only allowed to print unique canvases.
      if self.prints.containsKey(canvas.pixels) == false {
        log("printing new picture")
        let canvas(
          width: width,
          height: height,
          pixels: pixels
        )
        let picture <- create Picture(canvas: canvas)
        emit PicturePrintSuccess(pixels: canvas.pixels)
        self.prints[canvas.pixels] = canvas
        return <- picture
      } else {
        log("picture exists")
        emit PicturePrintFailure(pixels: pixels)
        return nil
      }
    }
  }

  init() {
    self.account.save(
      <- create Printer(width: 5, height: 5),
      to: /storage/ArtistPicturePrinter
    )
    self.account.link<&Printer>(
      /public/ArtistPicturePrinter,
      target: /storage/ArtistPicturePrinter
    )

    self.account.save(
      <- self.createCollection(),
      to: /storage/ArtistPictureCollection
    )
    self.account.link<&Collection>(
      /public/ArtistPictureCollection,
      target: /storage/ArtistPictureCollection
    )
  }
}
