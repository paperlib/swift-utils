import Foundation

class SVGContainerModifier {
	/**
	 * Scales the SVGContainer 
	 */
	static func scale(_ container:SVGContainer,_ pivot:CGPoint,_ scale:CGPoint) {
        //Swift.print("SVGContainerModifier.scale")
		let position:CGPoint = PointModifier.scale(container.frame.origin, pivot, scale);
		let size:CGSize = CGSize(container.frame.width * scale.x, container.frame.height * scale.y);
		container.frame.origin = position;
		container.frame.size = size;
        //fatalError("uncomment the line bellow")
        //for var i = 0; i < container.items.count; ++i{SVGModifier.scale(container.items[i], pivot, scale)}
        for element:ISVGElement in container.items{SVGModifier.scale(element, pivot, scale)}
	}
}
