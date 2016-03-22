import Foundation

class NodeModifier {
    /**
     * Removes the item @param index in @param node
     */
    func removeAt(inout node:Node, _ index:Array<Int>) -> Node {
        
        //continue here: check if you have a removeAt that is recursive
        if(index.count == 1 && node.children.count > index[0]){
            xml.replace(index,replacement);
            xml.normalize();/*removes whitespace after the replace action, if i.e if replacement is an empty xml*/
        }else if(index.length > 1 && xml.children().length() > 0 && (xml.children()[index[0]] as XML).toXMLString() != null){
            xml = replaceChildAt(xml.children()[index[0]],index.slice(1,index.length),replacement);
        }
        return xml;
        
    }
    func removeAt(inout node:Node, _ index:Int){
        ArrayModifier.removeAt(&node.children, index)
    }
}
