//
//  Client.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

struct Client {
    static let cameraIP: String = Command.DEFAULT_IP
    
    private static let baseCommandURL = "http://\(Self.cameraIP)/?custom=1&cmd="
    private static let addParam = "&par="
    private static let addStr = "&str="
    
    static func sendRequest(
        command: Int,
        param: Int? = nil,
        str: String? = nil,
        paramsMap: [String: String] = [:],
        timeout: TimeInterval = 30
    ) async throws -> Data {
        var urlString: String

        if !paramsMap.isEmpty {
            var comps = "\(baseCommandURL)\(command)"
            for (k, v) in paramsMap {
                comps += "&\(k)=\(v)"
            }
            urlString = comps
        } else if let param {
            urlString = "\(baseCommandURL)\(command)\(addParam)\(param)"
        } else if let str {
            urlString = "\(baseCommandURL)\(command)\(addStr)\(str)"
        } else {
            urlString = "\(baseCommandURL)\(command)"
        }

        guard let url = URL(string: urlString) else {
            throw CameraCommandError.invalidURL
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = timeout

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw CameraCommandError.badResponse
        }
        
        guard (200..<300).contains(http.statusCode) else {
            throw CameraCommandError.httpError(http.statusCode)
        }
        
        guard !data.isEmpty else {
            throw CameraCommandError.emptyData
        }

        return data
    }

    static func sendRequest<T: Decodable>(
        command: Int,
        param: Int? = nil,
        str: String? = nil,
        paramsMap: [String: String] = [:],
        timeout: TimeInterval = 30,
        decodeAs type: T.Type
    ) async throws -> T {
        
        let data = try await sendRequest(command: command, param: param, paramsMap: paramsMap, timeout: timeout)

        do {
            return try XMLDecoder().decode(T.self, from: data)
        } catch {
            throw CameraCommandError.parseError(error.localizedDescription)
        }
    }
}
