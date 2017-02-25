import Foundation

public class XMLParser{
    /**
     * Returns the root of an xml
     * EXAMPLE: let xml:NSXMLElement = XMLParser.root("<subCategories><category><id>someId</id><name>someName</name></category></subCategories>")!
     * EXAMPLE: Swift.print(xml.children![0].childCount)//2
     * EXAMPLE: <media><book><novel/><biography/></book><music><cd/><cassette/></music><film><dvd/><vhs/><blueray/><dvd>movie.mkv</dvd></film><media>
     * NOTE: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/NSXML_Concepts/NSXML.html#//apple_ref/doc/uid/TP40001263-SW1
     */
    static func root(_ xmlStr:String)->XML?{
        let xmlDoc:XMLDocument = try! XMLDocument(xmlString: xmlStr, options: 0)
        let rootElement:XML = xmlDoc.rootElement()!
        return rootElement
    }
    /**
     * Returns all children of the root element
     * EXAMPLE: rootChildren("<a><one></one><two></two></a>")//Output: <one></one><two></two>
     */
    static func rootChildren(_ xmlStr:String)->Array<XML>{
        let rootElement:XML = root(xmlStr)!
        let children:[XMLNode] = rootElement.children!
        let theChildren:Array<XML> = children as! [XML]
        return theChildren
    }
    /**
     * New
     */
    static func children(_ xml:XML)->Array<XML>{
        return xml.children as! [XML]
    }
    /**
     * Retuns the first xml node that has the name of the speccified nodename
     * XMLParser.firstNode(<p>text</p>,"p")
     * @output:text
     */
    static func firstNode(_ xml:XML, _ nodeName:String) -> XML? {
        return xml.elements(forName: nodeName).count > 0 ? xml.elements(forName: nodeName)[0] : nil//Swift 3 updated
    }
    /**
     *
     */
    static func rootChildrenByFilePath(_ filePath:String)->Array<XML>{
        let xmlStr:String = FileParser.content(filePath)!
        return rootChildren(xmlStr)
    }
    /**
     * Returns the value of a child
     * NOTE: retuns "" if there is no value
     * NOTE: To return a string representation of an XML cast the NSXMLElement as a String: String("<p>text<p/>".xml)//<p>text<p/>
     * CAUTION: This method can also return text values within nested children, use with caution
     * EXAMPLE: XMLParser.value("<p>text</p>".xml)//text
     */
    static func value(_ child:XML)->String{
        return child.stringValue!
    }
    /**
     * Returns the the entire xml structure as a string
     * NOTE: There is also .XMLString and a few abrivations of that method
     */
    static func string(_ child:XML)->String{
        return String(describing: child)
    }
    /**
     * Returns string Content of an xml
     * EXAMPLE: valueAt("<p>text</p>".xml,[0])//text
     */
    static func valueAt(_ child:XML,_ index:Array<Int>)->String?{
        return childAt(child, index)?.stringValue
    }
    /**
     * Returns all attributes in PARAM: child
     * EXAMPLE: attributes.count// num of attributes
     * EXAMPLE: if(attributes.count > 0) {  print(attributes[0]["value"]) }//prints the first attribute value in the first child that has an attribute
     */
    static func attributes(_ child:XML) -> [[String:String]]{
        
        //print("you should probably not use this, use attribs instead")
        
        var attributes = [[String:String]]()
        if(child.attributes != nil && child.attributes!.count > 0){
            for node:XMLNode in child.attributes!{
                var attribute:Dictionary<String,String> = [:]
                let name:String = node.name!
                let value:String = node.stringValue!
                //print("name: " + name + " " + "value:"+value)
                attribute["name"] = name//👈the problem is here.
                attribute["value"] = value//👈the problem is here.
                attributes.append(attribute)
            }
        }
        return attributes
    }
    /**
     * New
     */
    static func attribs(_ child:XML) -> Dictionary<String,String>{
        var dict:Dictionary<String,String> = [:]
        if(child.attributes != nil && child.attributes!.count > 0){
            child.attributes?.forEach{
                dict[$0.name!] = $0.stringValue!
            }
        }
        return dict
    }
    /**
     * Returns a key/value object with the attributes at the @param index in @param database
     * @example: DatabaseParser.attributesAt(database,[0,0])["title"]
     */
    static func attributesAt(_ child:XML, _ index:Array<Int>) -> [String:String]?{// :TODO: rename to objAt?
        return childAt(child,index)?.attribs
    }
    /**
     * Returns an array of Object instances containing key/value pairs of the xml properties at @param index from @param child
     * @Note: returns an empty array if the index is out of bound
     * @Note: to access the actual xml child at the specific index use native xml notation or use the XMLparser.childAt(index) function
     */
    static func siblingAttributes(_ child:XML, _ index:Array<Int>)->[Dictionary<String,String>] {// :TODO: rename to objAt
        let xml = childAt(child, index)
        var result:[Dictionary<String,String>] = []
        for c in xml?.children as! Array<XML>{
            result.append(c.attribs)
        }
        return result
    }
    /**
     * Returns child from PARAM: children at PARAM: index
     * EXAMPLE: XMLParser.childAt(children, 0)
     */
    static func childAt(_ children:[XMLNode], _ index:Int)->XML?{//swift 3 upgrade, was -> children:NSArray
        return children[index] as? XML
    }
    /**
     * Returns an an XML instance at @param index (Array index)
     * NOTE: this function is recursive
     * NOTE: to find a child at an integer use the native code: xml.children[integer]
     * NOTE: to find the children of the root use an empty array as the index value
     */
    static func childAt(_ xml:XML?,_ index:Array<Int>)->XML? {
        //Swift.print("index: " + "\(index)")
        if(index.count == 0 && xml != nil) {
            return xml
        }
        else if(index.count == 1 && xml != nil && xml?.child(at: index[0]) != nil) {//XMLParser.childAt(xml!.children!, index[0])
            return xml!.childByIndex(index[0])
        }// :TODO: if index.length is 1 you can just ref index
        else if(index.count > 1 && xml!.children!.count > 0) {
            return XMLParser.childAt(xml!.children![index[0]] as? XML,index.slice2(1,index.count))
        }
        return nil
    }
    /**
     * Returns the attribute value of @param child by key @param name
     * PARAM: attrKey: name of the attribute
     * NOTE: returns nil if there is no attr by that name
     * EXAMPLE: if let type:String = XMLParser.attribute(child, "type") { print("type: " + type) }
     * EXAMPLE: print(XMLParser.attribute(child, "type"))//returns Optional("digital") if there is something
     */
    static func attribute(_ child:XML,_ attrKey:String)->String?{
        return child.attribute(forName: attrKey)?.stringValue
    }
    /**
     * Returns the name of the @param child
     */
    static func name(_ child:XML)->String{
        return child.name!//child.localName also works
    }
    /**
     * Returns the first attribute that contains the attribute by the @param name and with the @param value
     */
    static func childByAttribute(_ child:XML,_ attributeName:String,_ attributeValue:String){
        //not implimented yet
    }
    /**
     * You can also drill down to the nodes you want using [ xmldoc nodesForXPath: @"/application/movie[@name='tc']" error: err ]
     * You can use the returned nodes as the new context node for evaluating further XPath expressions.
     */
    static func xPath(){
        
    }
    /**
     * Parses through an xml and returns an array
     * NOTE: this method does not seem to be recursive
     * NOTE: also adds other attributes and value pairs if they exist in the xml
     * EXAMPLE:
     * 	<items>
            <item title="orange" property="harry"/>
            <item title="blue" property="na"/>
        </items>
     * outputs: [{title:"orange", property:harry}, {title:"blue", property:"no"}]
     * TODO: Does it support xml string value? 
     */
    static func toArray(_ xml:XML)->[[String:String]] {
        
        //you probably shouldnt use this method as it uses the old attibutes method. Try the method arr() instead, its recursive but should still work for 2d arrays
        
        var items:[Dictionary<String,String>] = []
        let count = xml.children!.count//or use rootElement.childCount TODO: test this
        for i in 0..<count{
            let child:XML = XMLParser.childAt(xml.children!, i)!
            //print("Import - child.toXMLString(): " + child.toXMLString());
            var item:Dictionary<String,String> = Dictionary<String,String>()
            let attributes:[Dictionary<String,String>] = XMLParser.attributes(child)//TODO: use: attribs instead
            for attribute in attributes {
                item[attribute["name"]!] = attribute["value"]!
            }
            if(child.stringValue != nil && child.stringValue!.count > 0) { item["xml"] = child.stringValue! }
            items.append(item)
        }
        return items
    }
    /**
     * New
     */
    static func arr(_ xml:XML) -> [Any]{
        var items:[Any] = []
        let count = xml.children!.count//or use rootElement.childCount TODO: test this
        for i in 0..<count{
            let child:XML = XMLParser.childAt(xml.children!, i)!
            //print("Import - child.toXMLString(): " + child.toXMLString());
            //var item:Dictionary<String,Any> = Dictionary<String,Any>()
            var item:[Any] = []
            if(xml.attributes != nil && xml.attributes!.count > 0){
                item.append(child.attribs)
            }
            if(child.stringValue != nil && child.stringValue!.count > 0) {
                item.append(child.stringValue!)
            }else if(child.hasComplexContent) {
                item.append(arr(child))
            }
            items.append(item)
        }
        return items
    }
    /**
     * Returns the first matching xml that has the attribute key value pair @param attribute in @param xml
     */
    static func index(_ xml:XML,_ key:String, _ value:String) -> Array<Int>? {
        if(xml[key] == value) {
            return []
        }else if(xml.childCount > 0){
            for i in 0..<xml.childCount{
                let child:XML = xml.children![i] as! XMLElement
                let match:Array<Int>? = index(child,key,value)
                if(match != nil) {return [i] + match!}
            }
        }
        return nil
    }
    /**
     * Converts XML to Dictioinary and Array notation
     * NOTE: the format can then be converted back to xml and vis verca
     * EXAMPLE: toDictionary(try! XML("<name><color>blue</color><title>Worker</title></name>"))//Output: ["name":[["color":["blue"]],["title":["Worker"]]]]
     */
    
    //Swift 3 update: This method was changed from using AnyObject to Any
    
    static func toDictionary(_ xml:XML)->[String:Any]{
        var root = [String:Any]()
        let attributes = XMLParser.attributes(xml)
        for attr in attributes{root[attr["key"]!] = attr["value"]!}
        if(xml.hasComplexContent){
            var children:[[String:Any]] = []
            for child in xml.children!{children.append(toDictionary(child as! XML))}
            root[xml.name!] = children
        }else if(xml.stringValue != nil && xml.stringValue != ""){root[xml.name!] = [xml.stringValue!]}
        else{root[xml.name!] = []}
        return root
    }
    /**
     * Converts a multi dimensional Dictionary to an XML
     * NOTE: supports: attributes,string content, node name, sub nodes etc
     * TODO: Figure out a more elegant way to grab the node name. Preferably by delaying setting the node name until right before the xml is returned
     * EXAMPLE: toXML(["name":[]])//Output:<name></name>
     * EXAMPLE: toXML(["name":["title":["some content"],"age":"16"],"color":"blue"])//Output: <name color="blue"><title age="16">some content here</title></name>
     * EXAMPLE: toXML(["name":[["color":["blue"]],["title":["Worker"]]]])//<name><color>blue</color><title>Worker</title></name>
     * EXAMPLE:
     * var titleDict:Dictionary<String,AnyObject> = [String:AnyObject]()
     * titleDict["title"] = ["some content here"]
     * titleDict["age"] = "16"
     * var nameDict:Dictionary<String,AnyObject> = [String:AnyObject]()
     * nameDict["name"] = titleDict
     * nameDict["color"] = "blue"
     * toXML(nameDict)//Output: <name color="blue"><title age="16">some content here</title></name>
     */
    static func toXML(_ content:AnyObject)->XML{
        let xml:XML = XML()
        func handleArray(_ theXML:XML,_ theContent:AnyObject){
            for item in (theContent as! Array<AnyObject>){
                if(item is String){
                    theXML.stringValue = item as? String
                }else if(item is Dictionary<String, AnyObject>){/*handle dictionary here*/
                    theXML.appendChild(toXML(item))/*<--recursive*/
                }else{/*array*/
                    fatalError("this can't happen")
                }
            }
        }
        if let dict = content as? Dictionary<String, AnyObject>{/*content is a dictionary*/
            for (key,value) in dict{
                if(value is String) {/*attributes*/
                    xml[key] = value as? String
                }
                else if(value is Dictionary<String, AnyObject>){/*dictionary*/
                    xml.name = key
                    xml.appendChild(toXML(value))/*<--recursive*/
                }else {
                    xml.name = key;
                    handleArray(xml,value)
                }/*array*/
            }
        }
        return xml
    }
}
