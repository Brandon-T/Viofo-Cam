//
//  CommonResponse.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

struct CommonResponse: Codable, Equatable, Hashable {
    var cmd: Int?
    var status: Int
    var value: Int64?
    var string: String?
    var otaFile: String?
    var devStatus: String?
    var error: String?
    var totalNum: Int?
    var curNum: Int?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cmd = try container.decodeIfPresent(Int.self, forKey: .cmd)
        self.status = try container.decode(Int.self, forKey: .status)
        self.value = try container.decodeIfPresent(Int64.self, forKey: .value)
        self.string = try container.decodeIfPresent(String.self, forKey: .string)
        self.otaFile = try container.decodeIfPresent(String.self, forKey: .otaFile)
        self.devStatus = try container.decodeIfPresent(String.self, forKey: .devStatus)
        self.error = try container.decodeIfPresent(String.self, forKey: .error)
        self.totalNum = try container.decodeIfPresent(Int.self, forKey: .totalNum)
        self.curNum = try container.decodeIfPresent(Int.self, forKey: .curNum)
    }
    
    private enum CodingKeys: String, CodingKey {
        case cmd = "Cmd"
        case status = "Status"
        case value = "Value"
        case string = "String"
        case otaFile = "OTA_FILE"
        case devStatus = "DevStatus"
        case error = "Error"
        case totalNum = "TotalNum"
        case curNum = "CurNum"
    }
}
