//
//  HDRTimeResponse.swift
//  Viofo
//
//  Created by Brandon on 2025-08-17.
//

import Foundation

struct HDRTimeResponse: Codable, Equatable, Hashable {
    var cmd: Int
    var status: Int
    var start: String
    var end: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cmd = try container.decode(Int.self, forKey: .cmd)
        self.status = try container.decode(Int.self, forKey: .status)
        self.start = try container.decode(String.self, forKey: .start)
        self.end = try container.decode(String.self, forKey: .end)
    }
    
    private enum CodingKeys: String, CodingKey {
        case cmd
        case status
        case start = "Start"
        case end = "End"
    }
}
