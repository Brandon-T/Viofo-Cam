/// Attach this to each class/enum that declares your `static let`s.
/// Generates: `public static let index: [String: CommandValue]`
@attached(member, names: named(index), prefixed(__index_))
public macro GenerateCommandIndex() = #externalMacro(
    module: "CommandMacrosImplementation",
    type: "GenerateCommandIndexMacro"
)
