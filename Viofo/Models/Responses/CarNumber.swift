//
//  CarNumber.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

struct CarNumber: Codable, Equatable, Hashable {
    var carNo: String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let carNo = try? container.decodeIfPresent(String.self, forKey: .init(stringValue: "CarNO")!)
        let carNumber = try? container.decodeIfPresent(String.self, forKey: .init(stringValue: "CARNUMBER")!)
        let string = try? container.decodeIfPresent(String.self, forKey: .init(stringValue: "String")!)
        self.carNo = carNo ?? carNumber ?? string
    }
}
