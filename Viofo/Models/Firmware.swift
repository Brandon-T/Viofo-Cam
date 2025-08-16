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
    let version: String
    let buildDate: Date
    
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

        return ViofoFirmware(vendor: vendor, model: model, version: version, buildDate: date)
    }
}

enum ViofoParseError: Error, CustomStringConvertible {
    case noMatch
    case badDate(String)
    var description: String {
        switch self {
        case .noMatch: return "String does not match expected VIOFO firmware format."
        case .badDate(let s): return "Cannot parse YYMMDD date: \(s)"
        }
    }
}
