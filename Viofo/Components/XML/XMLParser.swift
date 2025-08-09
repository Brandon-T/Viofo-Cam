//
//  XMLParser.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

public final class SimpleXML {
    public final class Element {
        public let name: String
        public var text: String = ""
        public var children: [Element] = []
        public weak var parent: Element?

        init(name: String, parent: Element?) {
            self.name = name
            self.parent = parent
        }
    }

    public static func parse(_ data: Data) throws -> Element {
        let parser = XMLParser(data: data)
        let delegate = Builder()
        parser.delegate = delegate
        
        guard parser.parse() else {
            throw NSError(domain: "XMLParser", code: 1, userInfo: [NSLocalizedDescriptionKey: parser.parserError?.localizedDescription ?? "XML parse failed"])
        }
        
        guard let root = delegate.root else {
            throw NSError(domain: "XMLParser", code: 2, userInfo: [NSLocalizedDescriptionKey: "XML has no root"])
        }
        
        return root
    }

    private final class Builder: NSObject, XMLParserDelegate {
        var root: Element?
        var current: Element?

        func parser(_ parser: XMLParser, didStartElement name: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            
//            let node = Element(name: name, parent: current)
//            current?.children.append(node)
//            current = node
//            
//            if root == nil {
//                root = node
//            }
            
            let node = Element(name: name, parent: current)
            if root == nil {
                root = node
            }
            
            current?.children.append(node)
            current = node
        }

        func parser(_ parser: XMLParser, foundCharacters string: String) {
            current?.text.append(string)
        }

        func parser(_ parser: XMLParser, didEndElement name: String, namespaceURI: String?, qualifiedName qName: String?) {
            current = current?.parent
        }
        
        func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
            print("XML Parsing Error: \(parseError.localizedDescription)")
        }
    }
}

extension SimpleXML.Element {
    func child(_ name: String) -> SimpleXML.Element? {
        children.first {
            $0.name.caseInsensitiveCompare(name) == .orderedSame
        }
    }
    
    func children(_ name: String) -> [SimpleXML.Element] {
        children.filter {
            $0.name.caseInsensitiveCompare(name) == .orderedSame
        }
    }

    var string: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var int: Int? {
        Int(string)
    }
    
    var int64: Int64? {
        Int64(string)
    }
}
