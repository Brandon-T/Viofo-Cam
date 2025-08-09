//
//  StreamUrlData.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

struct StreamUrlData: Codable {
    let movieLiveViewLink: String
    let photoLiveViewLink: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.movieLiveViewLink = try container.decode(String.self, forKey: .movieLiveViewLink)
        self.photoLiveViewLink = try container.decode(String.self, forKey: .photoLiveViewLink)
    }
    
    private enum CodingKeys: String, CodingKey {
        case movieLiveViewLink = "MovieLiveViewLink"
        case photoLiveViewLink = "PhotoLiveViewLink"
    }
}
