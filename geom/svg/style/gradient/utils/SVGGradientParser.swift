import Foundation
/**
 * This class has methods that converts xml data into SVGGradient instances
 */
class SVGGradientParser {
	/**
	 * Returns an gradient instance with data derived from @param xml 
	 * @param xml (<linearGradient id="skyline"><stop offset="0" style="stop-color:blue"/><stop offset="1" style="stop-color:red"/></linearGradient>)
	 * other attributes: gradientTransform,gradientUnits,xlink:href
	 */
	class func linearGradient(xml:NSXMLElement)->SVGLinearGradient{
		// trace("linearGradient ");
		var x1Str:String = SVGPropertyParser.property(xml,"x1")!;
		// trace("x1: " + x1);
		let x1:CGFloat = StringAsserter.percentage(x1Str) ? StringParser.percentage(x1Str) : SVGPropertyParser.value(x1Str);
		var y1Str:String = SVGPropertyParser.property(xml,"y1")!;
		let y1:CGFloat = StringAsserter.percentage(y1Str) ? StringParser.percentage(y1Str) : SVGPropertyParser.value(y1Str);
		var x2Str:String = SVGPropertyParser.property(xml,"x2")!;
		let x2:CGFloat = StringAsserter.percentage(x2Str) ? StringParser.percentage(x2Str) : SVGPropertyParser.value(x2Str);
		var y2Str:String = SVGPropertyParser.property(xml,"y2")!;
		let y2:CGFloat = StringAsserter.percentage(y2Str) ? StringParser.percentage(y2Str) : SVGPropertyParser.value(y2Str);
		var svgGradient:SVGGradient = Utils.gradient(xml);
		return SVGLinearGradient(svgGradient.offsets,svgGradient.colors,svgGradient.opacities,x1,y1,x2,y2,svgGradient.gradientUnits,svgGradient.spreadMethod,svgGradient.id,svgGradient.gradientTransform);
	}
}
private class Utils{
	/**
	 * Returns an gradient instance with data derived from @param xml 
	 */
	class func gradient(xml:NSXMLElement)->SVGGradient{
		var offsets:Array<CGFloat> = [];
		var colors:Array<CGColor> = [];
		var opacities:Array<CGFloat> = [];
        let children:NSArray = xml.children!
        for (var i = 0; i < xml.childCount; i++) {
            let child:NSXMLElement = XMLParser.childAt(children, i)!
            
			var offsetStr:String = SVGPropertyParser.property(child,"offset")!
            var offset:CGFloat = StringAsserter.digit(offsetStr) ? CGFloat(Double(offsetStr)!) * 255 : StringParser.percentage(offsetStr) / 100 * 255;
			/*offset is number between 0-1 or offset is percentage %*/
			// :TODO: possibly itterate the offset if its null (see Element framework on how to do this)
			// Swift.print("offset: " + offset);
			let hexColor:UInt
            let stopOpacity:CGFloat
			//var stopOpacity:CGFloat;
			/*0-1*/
			var style:String? = SVGPropertyParser.property(child,"style");
			// :TODO: if style is present then dont check for color etc
			if(style != nil){
				// Swift.print("style: " + style);
				var inlineStyle:Dictionary<String,String> = SVGStyleParser.inlineStyle(style!);
//				ObjectParser.describe(inlineStyle);
				var stopColorProperty:String = inlineStyle["stop-color"]!;
				// Swift.print("stopColorProperty: " + stopColorProperty);
				
                stopOpacity = SVGPropertyParser.value(inlineStyle["stop-opacity"]);
                hexColor = StringParser.color(stopColorProperty)
				// Swift.print("stopOpacity: " + stopOpacity);
			} else{
                stopOpacity = SVGPropertyParser.value(SVGPropertyParser.property(child,"stop-opacity"))
				hexColor = StringParser.color(SVGPropertyParser.property(child,"stop-color")!)
                
			}
            if(stopOpacity.isNaN) {stopOpacity = 1}/*Forces stopOpacity to be 1 if its NaN*/
            var stopColor:CGColor = CGColor.color(hexColor, stopOpacity)//Double();
			offsets.append(offset);
			colors.append(stopColor);
			opacities.append(stopOpacity);
		}
		// Swift.print("colors: " + colors);
		// Swift.print("offsets: " + offsets);
		// Swift.print("opacities: " + opacities);
		var gradientUnits:String = SVGPropertyParser.property(xml,"gradientUnits");
		/*userSpaceOnUse*/
		// Swift.print("gradientUnits: " + gradientUnits);
		var spreadMethod:String = SVGPropertyParser.property(xml,"spreadMethod");
		var id:String = SVGPropertyParser.id(xml);
		//var gradientTransform:Matrix = Utils.gradientTransform(xml);
		return SVGGradient(offsets,colors,opacities,spreadMethod,id,gradientUnits/*,gradientTransform*/);
	}
}