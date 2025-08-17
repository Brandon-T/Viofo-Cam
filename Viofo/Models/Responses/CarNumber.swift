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
        let container = try decoder.container(keyedBy: AnyKey.self)
        let candidates = ["CarNO", "CARNUMBER", "String"]
        
        for name in candidates {
            let key = AnyKey(stringValue: name)
            if let s = try container.decodeIfPresent(String.self, forKey: key) {
                self.carNo = s.isEmpty ? nil : s
                return
            }
        }
        
        self.carNo = nil
    }
    
    private struct AnyKey: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }
        init?(intValue: Int) { return nil }
        init(stringValue: String) { self.stringValue = stringValue }
    }
}
