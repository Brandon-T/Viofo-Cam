//
//  XMLDecoder.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

public final class XMLDecoder {
    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let characters = CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: "\0"))
        guard let sanitizedString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: characters) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid XML String"))
        }
        
        guard let data = sanitizedString.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid XML Data"))
        }
        
        let root = try SimpleXML.parse(data)
        let decoder = _XMLDecoder(element: root)
        return try T(from: decoder)
    }
}

// MARK: - Internal Decoder
private final class _XMLDecoder: Decoder {
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey : Any] = [:]
    let element: SimpleXML.Element

    init(element: SimpleXML.Element, codingPath: [CodingKey] = []) {
        self.element = element
        self.codingPath = codingPath
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let container = _XMLKeyedDecodingContainer<Key>(parent: element, codingPath: codingPath)
        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return _XMLUnkeyedDecodingContainer(elements: element.children, codingPath: codingPath)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Single value container not supported at this level."))
    }
}

// MARK: - Keyed Decoding Container
private struct _XMLKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey]
    var allKeys: [Key] {
        return parent.children.map { element in
            Key(stringValue: element.name)!
        }
    }
    
    private let parent: SimpleXML.Element

    init(parent: SimpleXML.Element, codingPath: [CodingKey]) {
        self.parent = parent
        self.codingPath = codingPath
    }

    func contains(_ key: Key) -> Bool {
        return parent.child(key.stringValue) != nil
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        guard let child = parent.child(key.stringValue) else {
            // A non-existent key is nil
            return true
        }
        // An element with no text or only whitespace is considered nil
        return child.string.isEmpty
    }
    
    private func getChildElement(for key: Key) throws -> SimpleXML.Element {
        guard let child = parent.child(key.stringValue) else {
            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No element found for key \(key.stringValue)"))
        }
        return child
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        let child = try getChildElement(for: key)
        guard let value = Bool(child.string) else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode Bool from '\(child.string)'"))
        }
        return value
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        return try getChildElement(for: key).string
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        let child = try getChildElement(for: key)
        guard let value = Double(child.string) else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode Double from '\(child.string)'"))
        }
        return value
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        let child = try getChildElement(for: key)
        guard let value = Float(child.string) else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode Float from '\(child.string)'"))
        }
        return value
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        let child = try getChildElement(for: key)
        guard let value = child.int else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode Int from '\(child.string)'"))
        }
        return value
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        let child = try getChildElement(for: key)
        guard let value = Int8(child.string) else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode Int8 from '\(child.string)'"))
        }
        return value
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        let child = try getChildElement(for: key)
        guard let value = Int16(child.string) else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode Int16 from '\(child.string)'"))
        }
        return value
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        let child = try getChildElement(for: key)
        guard let value = Int32(child.string) else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode Int32 from '\(child.string)'"))
        }
        return value
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        let child = try getChildElement(for: key)
        guard let value = child.int64 else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode Int64 from '\(child.string)'"))
        }
        return value
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        let child = try getChildElement(for: key)
        guard let value = UInt(child.string) else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode UInt from '\(child.string)'"))
        }
        return value
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        let child = try getChildElement(for: key)
        guard let value = UInt8(child.string) else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode UInt8 from '\(child.string)'"))
        }
        return value
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        let child = try getChildElement(for: key)
        guard let value = UInt16(child.string) else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode UInt16 from '\(child.string)'"))
        }
        return value
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        let child = try getChildElement(for: key)
        guard let value = UInt32(child.string) else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode UInt32 from '\(child.string)'"))
        }
        return value
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        let child = try getChildElement(for: key)
        guard let value = UInt64(child.string) else {
            throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode UInt64 from '\(child.string)'"))
        }
        return value
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        let child = try getChildElement(for: key)
        let decoder = _XMLDecoder(element: child, codingPath: codingPath + [key])
        return try T(from: decoder)
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        let child = try getChildElement(for: key)
        let container = _XMLKeyedDecodingContainer<NestedKey>(parent: child, codingPath: codingPath + [key])
        return KeyedDecodingContainer(container)
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        let children = parent.children(key.stringValue)
        guard !children.isEmpty else {
            throw DecodingError.keyNotFound(key, .init(codingPath: codingPath, debugDescription: "No unkeyed container found for key \(key.stringValue)"))
        }
        
        let container = _XMLUnkeyedDecodingContainer(elements: children, codingPath: codingPath + [key])
        return container
    }

    func superDecoder() throws -> Decoder {
        fatalError("superDecoder() not implemented")
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError("superDecoder(forKey:) not implemented")
    }
}

// MARK: - Unkeyed Decoding Container
private struct _XMLUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var codingPath: [CodingKey]
    var count: Int? { elements.count }
    var isAtEnd: Bool { currentIndex >= elements.count }
    var currentIndex: Int = 0
    
    private let elements: [SimpleXML.Element]
    
    init(elements: [SimpleXML.Element], codingPath: [CodingKey]) {
        self.elements = elements
        self.codingPath = codingPath
    }
    
    private mutating func getNextElement() throws -> SimpleXML.Element {
        guard !isAtEnd else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Unkeyed container is at end."))
        }
        let element = elements[currentIndex]
        currentIndex += 1
        return element
    }
    
    func decodeNil() throws -> Bool {
        // This is a simplified approach, assuming elements in an unkeyed container
        // are not nil. You could extend this if your XML has self-closing tags
        // or other representations of nil within an array.
        return false
    }
    
    func decode(_ type: String.Type) throws -> String { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: Bool.Type) throws -> Bool { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: Int.Type) throws -> Int { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: Int8.Type) throws -> Int8 { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: Int16.Type) throws -> Int16 { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: Int32.Type) throws -> Int32 { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: Int64.Type) throws -> Int64 { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: UInt.Type) throws -> UInt { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: UInt8.Type) throws -> UInt8 { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: UInt16.Type) throws -> UInt16 { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: UInt32.Type) throws -> UInt32 { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: UInt64.Type) throws -> UInt64 { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: Float.Type) throws -> Float { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    func decode(_ type: Double.Type) throws -> Double { throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Only nested containers are supported in unkeyed context.")) }
    
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        let element = try getNextElement()
        let decoder = _XMLDecoder(element: element, codingPath: codingPath)
        return try T(from: decoder)
    }

    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        let element = try getNextElement()
        let container = _XMLKeyedDecodingContainer<NestedKey>(parent: element, codingPath: codingPath)
        return KeyedDecodingContainer(container)
    }

    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Nested unkeyed container not supported in this XML structure."))
    }

    func superDecoder() throws -> Decoder {
        fatalError("superDecoder() not implemented")
    }
}
