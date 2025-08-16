//
//  SettingsView.swift
//  Viofo
//
//  Created by Brandon on 2025-08-10.
//

import SwiftUI
import CommandMacros

struct SettingsView: View {
    
    @State
    var settings = [Setting]()
    
    var body: some View {
        VStack {
            ForEach(settings) { setting in
                Text(setting.name)
            }
        }
        .task {
            do {
                let statuses = try await Client.getAllSettingStatus()
                let firmware = try ViofoFirmware.from(await Client.getFirmwareVersion() ?? "INVALID_FIRMWARE")
                let commander = self.command(for: firmware.model)

                let settingsPath = Bundle.main.path(forResource: "Settings", ofType: "json")!
                let data = try Data(contentsOf: URL(filePath: settingsPath))
                self.settings = try JSONDecoder().decode(Settings.self, from: data).settings
                    .filter({
                        return $0.available.first(where: { firmware.model.hasPrefix($0) }) != nil
                    })
                    .filter({
                        if case .int(let value) = commander.resolve($0.command) {
                            print("\($0.command): \(value)")
                            return true
                        }
                        
                        return false
                    })
            } catch {
                print("SETTING ERROR: \(error)")
            }
        }
    }
    
    private let commandRegistry: [(prefix: String, type: CommandIndexProvider.Type)] = [
        // All items must be in order of the longest first!
        ("A139Pro", Command_A139_Pro.self),
        ("A139",    Command_A139.self),
        ("A329",    Command_A329.self),
        ("A229",    Command_A229.self),
        ("A129",    Command_A129.self),
        ("A119",    Command_A119.self),
    ]

    func command(for model: String) -> CommandIndexProvider.Type {
        for (prefix, type) in commandRegistry {
            if model.hasPrefix(prefix) {
                return type
            }
        }
        return Command.self
    }
}

