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

pub fun display(canvas: Canvas) {
    let width = Int(canvas.width)
    let height = Int(canvas.height)

    var height_index : Int = 0
    var previous_height_index : Int = 0
    var line: String = ""

    while height_index <= height+1 {                

        switch height_index {
            case 0:
                //top frame
                log("+-----+")                
            case height+1:
                //bottom frame
                log("+-----+")
            default: 
                //picture line 1,2,3,4,5
                line = canvas.pixels.slice(from: previous_height_index*width, upTo: height_index*width)
                log("|".concat(line).concat("|"))                
        }

        height_index = height_index + 1        
        previous_height_index = height_index - 1
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

    //W1Q1 - Frame It!
    display(canvas: canvasX)   
}