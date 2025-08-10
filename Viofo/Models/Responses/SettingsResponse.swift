//
//  SettingsResponse.swift
//  Viofo
//
//  Created by Brandon on 2025-08-10.
//

import Foundation

struct SettingsResponse: Codable, Equatable, Hashable {
    var cmd: Int
    var status: Int
    var string: String?
}
