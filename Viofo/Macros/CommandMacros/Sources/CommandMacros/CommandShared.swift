//
//  CommandShared.swift
//  CommandMacros
//
//  Created by Brandon on 2025-08-16.
//

import ObjectiveC

public enum CommandValue: Equatable {
    case int(Int)
    case string(String)
}

public protocol CommandIndexProvider: AnyObject {
    static var index: [String: CommandValue] { get } // synthesized by macro
    
    static nonisolated func resolve(_ name: String) -> CommandValue?

    static nonisolated func resolve<T: CommandIndexProvider>(
        _ type: T.Type, _ name: String
    ) -> CommandValue?
}

public extension CommandIndexProvider {
    static nonisolated func resolve(_ name: String) -> CommandValue? {
        let key = name.split(separator: ".").last.map(String.init) ?? name
        if let v = Self.index[key] { return v }
        
        // walk superclasses for fallback
        var cursor: AnyClass? = class_getSuperclass(Self.self)
        while let cls = cursor {
            if let p = cls as? CommandIndexProvider.Type, let v = p.index[key] { return v }
            cursor = class_getSuperclass(cls)
        }
        return nil
    }
    
    static nonisolated func resolve<T: CommandIndexProvider>(
        _ type: T.Type, _ name: String
    ) -> CommandValue? {
        T.resolve(name)
    }
}
