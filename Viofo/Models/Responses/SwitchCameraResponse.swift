//
//  SwitchCameraResponse.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

struct SwitchCameraResponse: Codable {
    let cmd: Int
    let status: Int
    let value: Int64?
    let string: String?
    let interiorSensor: String?
    let rearSensor: String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cmd = try container.decode(Int.self, forKey: .cmd)
        self.status = try container.decode(Int.self, forKey: .status)
        self.value = try container.decodeIfPresent(Int64.self, forKey: .value)
        self.string = try container.decodeIfPresent(String.self, forKey: .string)
        self.interiorSensor = try container.decodeIfPresent(String.self, forKey: .interiorSensor)
        self.rearSensor = try container.decodeIfPresent(String.self, forKey: .rearSensor)
    }
    
    private enum CodingKeys: String, CodingKey {
        case cmd = "Cmd"
        case status = "Status"
        case value = "Value"
        case string = "String"
        case interiorSensor = "InteriorSensor"
        case rearSensor = "RearSensor"
    }
}
