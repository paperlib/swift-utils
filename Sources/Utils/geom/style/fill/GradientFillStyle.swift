import Cocoa

class GradientFillStyle:FillStyle,IGradientFillStyle{
    var gradient:IGradient
    init(_ gradient:IGradient, _ color:NSColor = NSColor.clear){
        self.gradient = gradient
        super.init(color)
    }
}