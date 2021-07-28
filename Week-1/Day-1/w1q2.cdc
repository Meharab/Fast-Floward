pub struct Canvas {

  pub let width: UInt8
  pub let height: UInt8
  pub let pixels: String

  init(width: UInt8, height: UInt8, pixels: String) {
    self.width = width
    self.height = height
    // The following pixels
    // 123
    // 456
    // 789
    // should be serialized as
    // 123456789
    self.pixels = pixels
  }
}

pub fun serializeStringArray(_ lines: [String]): String {
  var buffer = ""
  for line in lines {
    buffer = buffer.concat(line)
  }

  return buffer
}

pub resource Picture {
  pub let canvas: Canvas
  
  init(canvas: Canvas) {
    self.canvas = canvas
  }  
}

pub resource Printer {
  pub fun print(canvas: Canvas): @Picture? {
    let letterX <- create Picture(canvas: canvas) 
    log(letterX.canvas)
    return <-letterX    
  }
}

pub fun main() {
    let pixelsX = [
        "*   *",
        "* * *",
        "*   *",
        "*   *",
        "*   *"
    ]

    //log(pixelsX)

    let canvasX = Canvas(
        width: 5,
        height: 5,
        pixels: serializeStringArray(pixelsX)
    )

    //W1Q2 - Uniques
    let printX <- create Printer()
    let letterX <- printX.print(canvas: canvasX)
    destroy letterX
    destroy printX
}