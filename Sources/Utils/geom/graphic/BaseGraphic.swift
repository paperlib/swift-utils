import Cocoa
/**
 * The BaseGraphic class is an Element DataObject class that holds the lineshape, lineStyle and fillStyle
 * TODO: Possibly get rid of the setters for the fillStyle and Line style and use implicit setFillStyle and setLineStyle?
 * NOTE: We dont need a line mask, just subclass the Graphics class so it supports masking of the line aswell (will require some effort)
 */
class BaseGraphic:AbstractGraphic,IGraphicDecoratable{/*was extending AbstractGraphicDecoratable*/
    override var graphic:BaseGraphic {return self}
    /**
     * NOTE: Color can't be uint since uint can't be NaN, use Double as a differntiator
     */
    override func beginFill(){
        if(fillStyle != nil && fillStyle!.color != NSColor.clear ) {/*Updates only if fillStyle is of class FillStyle*/
            //Swift.print("BaseGraphic.beginFill()" )//  " fillStyle!.color:"  + String(fillStyle!.color)
            fillShape.graphics.fill(fillStyle!.color)//Stylize the fill
        }
    }
    override func stylizeFill(){
        GraphicsModifier.stylize(fillShape.path,fillShape.graphics)//realize style on the graphic
        //fillShape.display()/*draw the fileShape*/<--temp
    }
    override func applyLineStyle() {
        //Swift.print("lineStyle!.color: " + String(lineStyle!.color))
        if(lineStyle != nil) {/*updates only if lineStyle of class LineStyle*/
            lineShape.graphics.line(lineStyle!.thickness, lineStyle!.color, lineStyle!.lineCap, lineStyle!.lineJoin, lineStyle!.miterLimit,lineStyle!.phase,lineStyle!.lengths)
        }
    }
    override func stylizeLine(){
        GraphicsModifier.stylizeLine(lineShape.path,lineShape.graphics)//realize style on the graphic
        //lineShape.display()/*draw the lineShape*/
    }
    override func getGraphic()->BaseGraphic{
        return self
    }
    override func getDecoratable()->IGraphicDecoratable{return self}/*new*/
}
