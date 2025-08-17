//
//  LensesResponse.swift
//  Viofo
//
//  Created by Brandon on 2025-08-17.
//

import Foundation

struct LensesResponse: Codable, Equatable, Hashable {
    var cmd: Int
    var status: Int
    var frontSensor: Int
    var interiorSensor: Int
    var rearSensor: Int
    var total: Int
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cmd = try container.decode(Int.self, forKey: .cmd)
        self.status = try container.decode(Int.self, forKey: .status)
        self.frontSensor = try container.decode(Int.self, forKey: .frontSensor)
        self.interiorSensor = try container.decode(Int.self, forKey: .interiorSensor)
        self.rearSensor = try container.decode(Int.self, forKey: .rearSensor)
        self.total = try container.decode(Int.self, forKey: .total)
    }
    
    private enum CodingKeys: String, CodingKey {
        case cmd
        case status
        case frontSensor = "FrontSensor"
        case interiorSensor = "InteriorSensor"
        case rearSensor = "RearSensor"
        case total = "Total"
    }
}
