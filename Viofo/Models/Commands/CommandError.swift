//
//  CommandError.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

enum CameraCommandError: Error {
    case invalidURL
    case badResponse
    case httpError(Int)
    case emptyData
    case parseError(String)
}
