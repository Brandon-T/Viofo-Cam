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
    public let depends_on: SettingsDependency?
    public let options: [SettingsOption]?
    public let options_alt: [SettingsOption]?

    enum CodingKeys: String, CodingKey {
        case name, command, available, type, description, depends_on, options, options_alt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.command = try container.decode(String.self, forKey: .command)
        self.available = try container.decode([String].self, forKey: .available)
        self.type = try container.decode(String.self, forKey: .type)
        self.description = try container.decode(String.self, forKey: .description)
        self.depends_on = try container.decodeIfPresent(SettingsDependency.self, forKey: .depends_on)
        self.options = try container.decodeIfPresent([SettingsOption].self, forKey: .options)
        self.options_alt = try container.decodeIfPresent([SettingsOption].self, forKey: .options_alt)
    }
}

public struct SettingsDependency: Codable {
    public let command: String
    public let values: [Int]
}

public struct SettingsOption: Codable {
    public let display: String
    public let value: String
    
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
