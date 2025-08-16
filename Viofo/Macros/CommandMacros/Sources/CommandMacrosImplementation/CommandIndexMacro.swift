import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct CommandMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [GenerateCommandIndexMacro.self]
}

public struct GenerateCommandIndexMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf decl: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        // ----- Identify the type name and whether this is a subclass -----
        let typeName: String
        var hasSuperclass = false
        if let cls = decl.as(ClassDeclSyntax.self) {
            typeName = cls.name.text
            hasSuperclass = (cls.inheritanceClause != nil) // any superclass/protocols listed
        } else if let en = decl.as(EnumDeclSyntax.self) {
            typeName = en.name.text
        } else {
            typeName = "Unknown"
        }
        let backingName = "__index_\(typeName)"
        
        // ----- Collect Int/String type properties (static let / static var / class var) -----
        var entries: [(name: String, type: String)] = []
        
        for member in decl.memberBlock.members {
            guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { continue }
            
            let isLet = varDecl.bindingSpecifier.tokenKind == .keyword(.let)
            let isVar = varDecl.bindingSpecifier.tokenKind == .keyword(.var)
            
            let hasStatic = varDecl.modifiers.contains(where: { $0.name.text == "static" }) == true
            let hasClass  = varDecl.modifiers.contains(where: { $0.name.text == "class"  }) == true
            
            // We index:
            // - static let NAME: Int|String = ...
            // - static var NAME: Int|String = ...
            // - class  var NAME: Int|String { ... }   (overridable members)
            guard (isLet && hasStatic) || (isVar && (hasStatic || hasClass)) else { continue }
            
            for binding in varDecl.bindings {
                guard
                    let pattern = binding.pattern.as(IdentifierPatternSyntax.self),
                    let typeAnnot = binding.typeAnnotation?.type.as(IdentifierTypeSyntax.self)
                else { continue }
                
                let name = pattern.identifier.text
                let typeName = typeAnnot.name.text
                if typeName == "Int" || typeName == "String" {
                    entries.append((name, typeName))
                }
            }
        }
        
        // ----- Build the dictionary body -----
        let dictItems = entries.map { e -> String in
            switch e.type {
            case "Int":    return #""\#(e.name)": .int(\#(e.name))"#
            case "String": return #""\#(e.name)": .string(\#(e.name))"#
            default:       return ""
            }
        }.joined(separator: ",\n        ")
        
        // ----- Emit a private backing constant (immutable, per-type unique) -----
        let backingDecl: DeclSyntax = """
        private nonisolated(unsafe) static let \(raw: backingName): [String: CommandValue] = [
            \(raw: dictItems)
        ]
        """
        
        // ----- Emit the public computed index; override when subclassing -----
        let overrideToken = hasSuperclass ? "override " : ""
        let indexDecl: DeclSyntax = """
        public \(raw: overrideToken)nonisolated class var index: [String: CommandValue] {
            \(raw: backingName)
        }
        """
        
        return [backingDecl, indexDecl]
    }
}
