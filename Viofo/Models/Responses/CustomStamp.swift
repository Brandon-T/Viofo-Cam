//
//  CustomStamp.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

struct CustomStamp: Codable, Equatable, Hashable {
    var stamp: String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let customStamp = try? container.decodeIfPresent(String.self, forKey: .init(stringValue: "CustomStamp")!)
        let customText = try? container.decodeIfPresent(String.self, forKey: .init(stringValue: "CUSTOMTEXT")!)
        let string = try? container.decodeIfPresent(String.self, forKey: .init(stringValue: "String")!)
        self.stamp = customStamp ?? customText ?? string
    }
}
