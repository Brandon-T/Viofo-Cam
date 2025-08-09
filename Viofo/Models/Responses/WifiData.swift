//
//  WifiData.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

struct WifiData: Codable {
    let ssid: String
    let passphrase: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ssid = try container.decode(String.self, forKey: .ssid)
        self.passphrase = try container.decode(String.self, forKey: .passphrase)
    }
    
    private enum CodingKeys: String, CodingKey {
        case ssid = "SSID"
        case passphrase = "PASSPHRASE"
    }
}
