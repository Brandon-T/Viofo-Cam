//
//  CameraFile.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

struct CameraFiles: Decodable {
    let files: [CameraFile]
    
    struct CameraFile: Codable {
        let name: String
        let filePath: String
        let size: Int64
        let timeCode: Int64
        let time: String
        let attr: Int32

        enum CodingKeys: String, CodingKey {
            case name = "NAME"
            case filePath = "FPATH"
            case size = "SIZE"
            case timeCode = "TIMECODE"
            case time = "TIME"
            case attr = "ATTR"
        }
    }

    init(from decoder: Decoder) throws {
        struct AllFile: Decodable {
            let file: CameraFile
            
            enum CodingKeys: String, CodingKey {
                case file = "File"
            }
        }

        struct FileList: Decodable {
            let allFiles: [AllFile]
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .allFiles)
                
                var allFiles: [AllFile] = []
                while !unkeyedContainer.isAtEnd {
                    allFiles.append(try unkeyedContainer.decode(AllFile.self))
                }
                self.allFiles = allFiles
            }
            
            enum CodingKeys: String, CodingKey {
                case allFiles = "ALLFile"
            }
        }

        let fileList = try FileList(from: decoder)
        self.files = fileList.allFiles.map { $0.file }
    }
}

extension CameraFiles.CameraFile {
    private static let LOCKED_FILE = "RO"
    private static let MT_LOCKED_FILE = "evt_rec"
    private static let MT_MANUAL_LOCKED_FILE = "manual_rec"
    private static let PARKING_FILE = "Parking"
    private static let PARKING_FILE_FRONT = "PF.MP4"
    private static let PARKING_FILE_REAR = "PR.MP4"
    private static let SCREEN_SUFFIX = "?custom=1&cmd=4002"
    private static let THUMB_SUFFIX = "?custom=1&cmd=4001"
    
    private var httpPathComponent: String? {
        let normalized = filePath.replacingOccurrences(of: "\\", with: "/")
        let parts = normalized.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
        
        guard parts.count == 2 else {
            return nil
        }
        
        let tail = parts[1].trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return String(tail)
    }
    
    var fileURL: URL? {
        guard let tail = httpPathComponent else {
            return nil
        }
        
        return URL(string: Command.BASE_URL)!.appendingPathComponent(tail)
    }
    
    var screenURL: URL? {
        guard let base = fileURL else {
            return nil
        }
        
        return URL(string: base.absoluteString + Self.SCREEN_SUFFIX)
    }
    
    var thumbURL: URL? {
        guard let base = fileURL else {
            return nil
        }
        
        return URL(string: base.absoluteString + Self.THUMB_SUFFIX)
    }
    
    var thumbFileName: String {
        name + ".jpg"
    }
}
