//
//  Firmware.swift
//  Viofo
//
//  Created by Brandon on 2025-08-16.
//

import Foundation

struct ViofoFirmware: Equatable {
    let vendor: String
    let model: String
    let device: ViofoCameraModel
    let version: String
    let versionNumber: Double
    let buildDate: Date
    let firmware: String
    
    static func from(_ firmware: String) throws -> ViofoFirmware {
        let calendar = Calendar(identifier: .gregorian)
        let pattern = #"^\s*(VIOFO)_([A-Z0-9]+)_(?:V)?([0-9]+(?:\.[0-9]+)*)_([0-9]{6})\s*$"#
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        guard let m = regex.firstMatch(in: firmware, options: [], range: NSRange(firmware.startIndex..., in: firmware)) else {
            throw ViofoParseError.noMatch
        }
        
        func group(_ i: Int) -> String {
            String(firmware[Range(m.range(at: i), in: firmware)!])
        }
        
        let vendor = group(1)
        let model  = group(2)
        let version = group(3)
        let yymmdd = group(4)

        // YYMMDD to Date (assume 2000–2099)
        let yy = Int(yymmdd.prefix(2))!
        let mm = Int(yymmdd.dropFirst(2).prefix(2))!
        let dd = Int(yymmdd.suffix(2))!
        
        guard (1...12).contains(mm), (1...31).contains(dd) else {
            throw ViofoParseError.badDate(yymmdd)
        }
        
        let year = 2000 + yy
        var comps = DateComponents(year: year, month: mm, day: dd)
        comps.calendar = calendar
        guard let date = calendar.date(from: comps) else {
            throw ViofoParseError.badDate(yymmdd)
        }
        
        let startIndex = version.startIndex
        guard let endIndex = version.index(startIndex, offsetBy: 3, limitedBy: version.endIndex),
              startIndex < endIndex,
              let versionNumber = Double(version[startIndex..<endIndex]) else {
            throw ViofoParseError.badFirmwareVersion(version)
        }
        
        var device = ViofoCameraModel.from(firmware)
        if device == .unknown {
            device = ViofoCameraModel.from(model)
        }

        return ViofoFirmware(vendor: vendor, model: model, device: device, version: version, versionNumber: versionNumber, buildDate: date, firmware: firmware, )
    }
    
    var downloadURL: URL? {
        switch device {
        case .unknown:
            return nil
        case .a119:
            return URL(string: "https://www.viofo.com/download/firmware/A119/filedesc.xml")
        case .a119Mini:
            return URL(string: "https://www.viofo.com/download/firmware/A119Mini/filedesc.xml")
        case .a119Mini2:
            return URL(string: "https://www.viofo.com/download/firmware/A119Mini2/filedesc.xml")
        case .a129:
            return URL(string: "https://www.viofo.com/download/firmware/A129/filedesc.xml")
        case .a129IR:
            return URL(string: "https://www.viofo.com/download/firmware/A129IR/filedesc.xml")
        case .a129Plus:
            return URL(string: "https://www.viofo.com/download/firmware/A129P/filedesc.xml")
        case .a129PlusAR:
            return URL(string: "https://www.viofo.com/download/firmware/A129PAR/filedesc.xml")
        case .a129Pro:
            return URL(string: "https://www.viofo.com/download/firmware/A129P/filedesc.xml")
        case .a129ProIR:
            return URL(string: "https://www.viofo.com/download/firmware/A129PIR/filedesc.xml")
        case .a129ProPDRM:
            return URL(string: "https://www.viofo.com/download/firmware/PDRM/filedesc.xml")
        case .a129ProW:
            return URL(string: "https://www.viofo.com/download/firmware/A129PW/filedesc.xml")
        case .a139:
            return URL(string: "https://www.viofo.com/download/firmware/A139/filedesc.xml")
        case .a139Pro:
            return URL(string: "https://www.viofo.com/download/firmware/A139P/filedesc.xml")
        case .a229:
            return URL(string: "https://www.viofo.com/download/firmware/A229/filedesc.xml")
        case .a229Plus:
            return URL(string: "https://www.viofo.com/download/firmware/A229P/filedesc.xml")
        case .a229S:
            return URL(string: "https://www.viofo.com/download/firmware/A229S/filedesc.xml")
        case .a229U:
            return URL(string: "https://www.viofo.com/download/firmware/A229U/filedesc.xml")
        case .a329:
            return URL(string: "https://www.viofo.com/download/firmware/A329/filedesc.xml")
        case .a329S:
            return URL(string: "https://www.viofo.com/download/firmware/A329S/filedesc.xml")
        case .a329T:
            return URL(string: "https://www.viofo.com/download/firmware/A329T/filedesc.xml")
        }
    }
}

public enum ViofoCameraModel {
    case unknown
    case a119
    case a119Mini
    case a119Mini2
    case a129
    case a129IR
    case a129Plus
    case a129PlusAR
    case a129Pro
    case a129ProIR
    case a129ProPDRM
    case a129ProW
    case a139
    case a139Pro
    case a229
    case a229Plus
    case a229S
    case a229U
    case a329
    case a329S
    case a329T
    
    static func from(_ string: String) -> ViofoCameraModel {
        if string.hasPrefix("A119") {
            if string.contains("Mini2") {
                return .a119Mini2
            }
            
            if string.contains("Mini") {
                return .a119Mini
            }
            
            return .a119
        }
        
        if string.hasPrefix("A129") {
            if string.hasPrefix("A129Plus_JP") {
                return .a129Plus
            }
            
            if string.hasPrefix("A129Plus_AR_V") {
                return .a129PlusAR
            }
            
            if string.hasPrefix("A129Plus") {
                return .a129Plus
            }
            
            if string.hasPrefix("A129Pro_IR") {
                return .a129ProIR
            }
            
            if string.hasPrefix("A129Pro-JP") {
                return .a129Pro
            }
            
            if string.hasPrefix("A129Pro-W") {
                return .a129ProW
            }
            
            if string.hasPrefix("A129Pro") {
                return .a129Pro
            }
            
            if string.hasPrefix("A129_IR") {
                return .a129IR
            }
            
            if string.hasPrefix("A129-JP.") {
                return .a129
            }
            
            if string.hasPrefix("A129") {
                return .a129
            }
        }
        
        if string.hasPrefix("PDRM") {
            return .a129ProPDRM
        }
        
        if string.hasPrefix("VIOFO_A139_JP_") {
            return .a139
        }
        
        if string.hasPrefix("VIOFO_A139P_JP_") {
            return .a139Pro
        }
        
        if string.hasPrefix("VIOFO_A139P") {
            return .a139Pro
        }
        
        if string.hasPrefix("VIOFO_A139") {
            return .a139
        }
        
        if string.hasPrefix("VIOFO_A229_JP") {
            return .a229
        }
        
        if string.hasPrefix("VIOFO_A229P") {
            return .a229Plus
        }
        
        if string.hasPrefix("VIOFO_A229S") {
            return .a229S
        }
        
        if string.hasPrefix("VIOFO_A229U") {
            return .a229U
        }
        
        if string.hasPrefix("VIOFO_A229") {
            return .a229
        }
        
        if string.hasPrefix("VIOFO_A329S") {
            return .a329S
        }
        
        if string.hasPrefix("VIOFO_A329T") {
            return .a329T
        }
        
        if string.hasPrefix("VIOFO_A329") {
            return .a329
        }
        
        return .unknown
    }
}

enum ViofoParseError: Error, CustomStringConvertible {
    case noMatch
    case badDate(String)
    case badFirmwareVersion(String)
    var description: String {
        switch self {
        case .noMatch: return "String does not match expected VIOFO firmware format."
        case .badDate(let s): return "Cannot parse YYMMDD date: \(s)"
        case .badFirmwareVersion(let s): return "Cannot parse Version Number: \(s)"
        }
    }
}
