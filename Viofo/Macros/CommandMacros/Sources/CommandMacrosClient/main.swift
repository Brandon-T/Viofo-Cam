import CommandMacros

@GenerateCommandIndex
class Command {
    class var AUTO_POWER_OFF: Int { 3007 }
    class var BASE_URL: String { "http://192.168.1.254" }
    class var BATTERY_CUT_OFF_TIME: Int { 8232 }
    class var BATTERY_CUT_OFF_VOLTAGE: Int { 9343 }
    class var BEEP_SOUND: Int { 9094 }
}

@GenerateCommandIndex
class Command_A119: Command {
    override class var AUTO_POWER_OFF: Int { 3007 }
    override class var BASE_URL: String { "http://10.0.0.254" }
    override class var BATTERY_CUT_OFF_TIME: Int { 8232 }
    override class var BATTERY_CUT_OFF_VOLTAGE: Int { 9343 }
    override class var BEEP_SOUND: Int { 25000 }
}

extension Command: CommandIndexProvider {}

let CommandType: CommandIndexProvider.Type = Command_A119.self

if case .int(let v)? = Command.resolve("BEEP_SOUND") {
    print(v) // 9403
}

if case .int(let v)? = CommandType.resolve("BEEP_SOUND") {
    print(v) // 9403
}
