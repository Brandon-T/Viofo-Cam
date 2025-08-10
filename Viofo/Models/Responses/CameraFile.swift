//
//  CameraFile.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

struct CameraFile: Codable, Equatable, Hashable {
    var name: String
    var filePath: String
    var size: Int64
    var timeCode: Int64
    var time: String
    var attr: Int32

    enum CodingKeys: String, CodingKey {
        case name = "NAME"
        case filePath = "FPATH"
        case size = "SIZE"
        case timeCode = "TIMECODE"
        case time = "TIME"
        case attr = "ATTR"
    }
    
    var timeCodeDate: Date {
        // VIOFO Dashcam EPOCH is from 2000/1/1 00:00:00 UTC.
        let viofoEpoch = DateComponents(calendar: Calendar(identifier: .gregorian),
                                        timeZone: TimeZone(secondsFromGMT: 0),
                                        year: 2000, month: 1, day: 1).date!
        
        return viofoEpoch.addingTimeInterval(TimeInterval(timeCode))
    }
    
    var timeCodeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: timeCodeDate)
    }
}

struct CameraFilesList: Decodable {
    let files: [CameraFile]

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

extension CameraFile {
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
        return name + ".jpg"
    }
    
    var isVideo: Bool {
        if let fileURL = fileURL {
            return ["mp4", "mpeg", "m4v", "mov", "mkv"].contains(fileURL.pathExtension.lowercased())
        }
        
        return false
    }
    
    var isImage: Bool {
        if let fileURL = fileURL {
            return ["jpg", "jpeg", "png", "heic", "gif"].contains(fileURL.pathExtension.lowercased())
        }
        
        return false
    }
}
