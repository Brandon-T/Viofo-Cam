//
//  SettingsModel.swift
//  Viofo
//
//  Created by Brandon on 2025-08-16.
//

public struct Settings: Decodable {
    let settings: [Setting]
}

public struct Setting: Decodable, Identifiable {
    public var id: String {
        return name
    }
    
    public let name: String
    public let command: String
    public let available: [String]
    public let type: String
    public let description: String
    public let warning: String?
    public let depends_on: SettingsDependency?
    public let options: [SettingsOption]?
    public let options_alt: [SettingsOption]?
    
    init(name: String, command: String, available: [String], type: String, description: String, warning: String? = nil, depends_on: SettingsDependency? = nil, options: [SettingsOption]? = nil, options_alt: [SettingsOption]? = nil) {
        self.name = name
        self.command = command
        self.available = available
        self.type = type
        self.description = description
        self.warning = warning
        self.depends_on = depends_on
        self.options = options
        self.options_alt = options_alt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.command = try container.decode(String.self, forKey: .command)
        self.available = try container.decode([String].self, forKey: .available)
        self.type = try container.decode(String.self, forKey: .type)
        self.description = try container.decode(String.self, forKey: .description)
        self.warning = try container.decodeIfPresent(String.self, forKey: .warning)
        self.depends_on = try container.decodeIfPresent(SettingsDependency.self, forKey: .depends_on)
        self.options = try container.decodeIfPresent([SettingsOption].self, forKey: .options)
        self.options_alt = try container.decodeIfPresent([SettingsOption].self, forKey: .options_alt)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case command
        case available
        case type
        case description
        case warning
        case depends_on
        case options
        case options_alt
    }
}

public struct SettingsDependency: Codable {
    public let command: String
    public let values: [Int]
    
    init(command: String, values: [Int]) {
        self.command = command
        self.values = values
    }
}

public struct SettingsOption: Codable {
    public let display: String
    public let value: String
    
    init(display: String, value: String) {
        self.display = display
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.display = try container.decode(String.self, forKey: .display)
        if let stringValue = try? container.decode(String.self, forKey: .value) {
            self.value = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .value) {
            self.value = String(intValue)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .value, in: container, debugDescription: "Value is not a string or integer")
        }
    }
}
