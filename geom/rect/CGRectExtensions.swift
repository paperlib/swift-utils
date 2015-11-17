import Foundation

extension CGRect {
    /**
     *
     */
    func clone()->CGRect{
        return CGRect(self.origin.x,self.origin.y,self.width,self.height)
    }
}
/*Convenient extensions*/
extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat){
        self.origin = CGPoint(x,y)
        self.size = CGSize(width: width,height: height)//add initializer to CGSize
    }
    var x:CGFloat {set {origin.x = newValue} get {return origin.x} }
    var y:CGFloat {set {origin.y = newValue} get {return origin.y} }
        
    
}
