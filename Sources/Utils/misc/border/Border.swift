import Foundation

class Border{
    var top:CGFloat = 0;
    var right:CGFloat = 0;
    var bottom:CGFloat = 0;
    var left:CGFloat = 0;
    required init(_ args:Any...){
        switch(args.count){
            case 1: left = args[0] as! CGFloat; right = args[0] as! CGFloat; top = args[0] as! CGFloat; bottom = args[0] as! CGFloat; break;
            case 2: top = args[0] as! CGFloat; bottom = args[0] as! CGFloat;left = args[1] as! CGFloat; right = args[1] as! CGFloat; break;
            case 3: top = args[0] as! CGFloat; left = args[1] as! CGFloat; right = args[1] as! CGFloat; bottom = args[2] as! CGFloat; break;
            case 4: top = args[0] as! CGFloat; right = args[1] as! CGFloat; bottom = args[2] as! CGFloat; left = args[3] as! CGFloat; break;
            default:break;
        }
    }
    /**
     * TODO: Could this be added through an extension?
     */
    init(_ args:Array<CGFloat>){
        switch(args.count){
            case 1: left = args[0]; right = args[0]; top = args[0]; bottom = args[0]; break;
            case 2: top = args[0]; bottom = args[0];left = args[1]; right = args[1]; break;
            case 3: top = args[0]; left = args[1]; right = args[1]; bottom = args[2]; break;
            case 4: top = args[0]; right = args[1]; bottom = args[2]; left = args[3]; break;
            default:break;
        }
    }
}
