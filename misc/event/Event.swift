import Foundation
/*
 * TODO: Implement the immediate variable if its needed (it would be a way to get assert the 1-level down immediate child an event came from, rather than the origin child which can be many levels deeper in the hierarchy)
 * NOTE: Event could be a struct, most Event classes are really simple and their passed data could be accessed via origin, maybe try using a struct for Element iOS
 */
class Event{
    static var update:String = "eventUpdate"/*Ideally I would name this change but apparently then subclasses can name their const the same*/
    var type:String/**/
    var origin:AnyObject/*origin sender of event, this could also be weak if you discover a memory leak*///TODO:this should be of type IEventSender
    var immediate:AnyObject/*previouse sender of event*///TODO:this should be of type IEventSender
    init(_ type:String = "", _ origin:AnyObject){
        self.type = type
        self.origin = origin
        self.immediate = origin
    }
}
extension Event{
    /**
     * The immediate previouse sender of event
     * NOTE: we return the event as its convenient when chaining method calls, great for attaching self to incoming events
     */
    func setImmediate(immediate:AnyObject)->Event{
        self.immediate = immediate
        return self
    }
    /**
     * NOTE: we return the event as its convenient when chaining method calls
     */
    func setType(type:String)->Event{
        self.type = type
        return self
    }
    func cast<T>() -> T{/*Convenience*/
        return self as! T
    }
    /**
     * TODO: It would be cool if you could also add a call-back method as an argument, also if it could cary arguments, maybe asking too much
     */
    func assert(type:String,_ origin:AnyObject?) -> Bool{
        return self.type == type && self.origin === origin
    }
    /**
     * Convenience method for asserting event target
     */
    func assert(type:String, immediate:AnyObject?) -> Bool{
        return self.type == type && self.immediate === immediate
    }
}