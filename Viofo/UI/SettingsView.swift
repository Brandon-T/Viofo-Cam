//
//  SettingsView.swift
//  Viofo
//
//  Created by Brandon on 2025-08-10.
//

import SwiftUI
import CommandMacros

import SwiftUI
import CommandMacros

// MARK: - SettingsScreen

struct SettingsScreen: View {
    @State private var settings: [Setting] = []
    @State private var statuses: [SettingsResponse] = []
    @State private var command: Command = .default
    @State private var isLoading = true
    @State private var errorText: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading settings…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if let errorText {
//                    ContentUnavailableView("Couldn’t load settings", systemImage: "exclamationmark.triangle", description: Text(errorText))
                } else {
                    List {
                        ForEach(settings) { setting in
                            let enabled = dependencySatisfied(for: setting, settings: settings, statuses: statuses, command: command)

                            NavigationLink {
                                OptionsScreen(
                                    setting: setting,
                                    isEnabled: enabled,
                                    current: currentValue(for: setting, statuses: statuses, command: command),
                                    options: options(for: setting, isDependencySatisfied: enabled),
                                    onSelect: { selected in
                                        Task { await apply(setting: setting, selectedValue: selected) }
                                    }
                                )
                            } label: {
                                SettingRow(
                                    setting: setting,
                                    isEnabled: enabled,
                                    currentDisplay: currentDisplay(for: setting, statuses: statuses, command: command)
                                )
                            }
                            .disabled(!enabled && setting.options_alt == nil) // can still open when alt options exist
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Settings")
        }
        .task(load)
    }
}

// MARK: - Row

private struct SettingRow: View {
    let setting: Setting
    let isEnabled: Bool
    let currentDisplay: String?

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(setting.name)
                    .font(.body.weight(.medium))
                if !setting.description.isEmpty {
                    Text(setting.description).font(.footnote).foregroundStyle(.secondary)
                }
            }

            Spacer()

            // current selection
            Text(currentDisplay ?? "—")
                .font(.callout)
                .foregroundStyle(isEnabled ? .secondary : .tertiary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .contentShape(Rectangle())
        .opacity(isEnabled || setting.options_alt != nil ? 1 : 0.5)
    }
}

// MARK: - OptionsScreen

private struct OptionsScreen: View {
    let setting: Setting
    let isEnabled: Bool
    let current: SettingsResponse?
    let options: [SettingsOption]
    let onSelect: (SettingsOption) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                ForEach(options, id: \.value) { option in
                    Button {
                        onSelect(option)
                        dismiss()
                    } label: {
                        HStack {
                            Text(option.display)
                            Spacer()
                            if isSelected(option, current: current) {
                                Image(systemName: "checkmark")
                                    .font(.callout.weight(.semibold))
                            }
                        }
                    }
                }
            } header: {
                Text(setting.name)
            } footer: {
                if !isEnabled, setting.options_alt != nil {
                    Text("Some options are unavailable until prerequisite setting is changed.")
                }
            }
        }
        .navigationTitle(setting.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func isSelected(_ option: SettingsOption, current: SettingsResponse?) -> Bool {
        guard let current else { return false }
        if let s = current.string { return option.value == s }
        return option.value == String(current.status)
    }
}

// MARK: - Data / helpers

private extension SettingsScreen {
    func load() async {
        do {
            isLoading = true
            errorText = nil
            let cameraKit = try await CameraKit.shared()
            self.command = await cameraKit.command
            
            let url = Bundle.main.url(forResource: "Settings", withExtension: "json")!
            let data = try Data(contentsOf: url)
            var all = try JSONDecoder().decode(Settings.self, from: data).settings
            
            let voiceControlInfo = try await CameraKit.shared().getVoiceControlInfo()
            let wifiInfo = try await cameraKit.getWifiNameAndPassword()
            let customTextStamp = try await cameraKit.getCustomStamp()
            let carLicenseNumberStamp = try await cameraKit.getCarNumber()
            
            var statuses = try await cameraKit.getAllSettingStatus()
            
            let voiceControlCommands: [SettingsOption] = voiceControlInfo.map({
                .init(display: $0.command, value: $0.key)
            })
            
            if let index = all.firstIndex(where: { $0.command == "VOICE_CONTROL_INFO" }) {
                let setting = all[index]
                all[index] = .init(name: setting.name, command: setting.command, available: setting.available, type: setting.type, description: setting.description, depends_on: nil, options: voiceControlCommands, options_alt: nil)
            }
            
            statuses.append(.init(cmd: command.VOICE_CONTROL, status: 0, string: ""))
            statuses.append(.init(cmd: command.WIFI_NAME, status: 0, string: wifiInfo.ssid))
            statuses.append(.init(cmd: command.WIFI_PWD, status: 0, string: wifiInfo.passphrase))
            statuses.append(.init(cmd: command.CUSTOM_TEXT_STAMP, status: 0, string: customTextStamp.stamp ?? ""))
            statuses.append(.init(cmd: command.GET_CAR_NUMBER, status: 0, string: carLicenseNumberStamp.carNo ?? ""))
            
            await statuses.append(.init(cmd: command.FIRMWARE_VERSION, status: 0, string: cameraKit.firmware.firmware))
            
            self.statuses = statuses

            // Filter to availability by firmware model prefix
            let fwModel = await cameraKit.firmware.model
            self.settings = all.filter { s in
                s.available.contains { fwModel.hasPrefix($0) }
            }
        } catch {
            errorText = String(describing: error)
        }
        isLoading = false
    }

    func apply(setting: Setting, selectedValue: SettingsOption) async {
        // Resolve command code from your instance-based Command
        guard case .int(let cmd)? = command.resolve(setting.command) else { return }

        do {
            let cameraKit = try await CameraKit.shared()
            
            switch cmd {
            case command.SET_TIME:
                let now = Date()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm:ss"
                let time = timeFormatter.string(from: now)
                let encodedTime = time.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                _ = try await cameraKit.setTime(encodedTime)
            case command.SET_DATE:
                let now = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.string(from: now)
                _ = try await cameraKit.setDate(date)
            default:
                if setting.type == "parameter" {
                    _ = try await Client.sendCommandWithParam(cmd, Int(selectedValue.value)!, as: CommonResponse.self)
                } else if setting.type == "string" {
                    _ = try await Client.sendCommandWithStr(cmd, selectedValue.value, as: CommonResponse.self)
                }
                break
            }

            // Refresh statuses so UI updates its checkmark/current value
            self.statuses = try await cameraKit.getAllSettingStatus()
        } catch {
            // You can show a toast or alert if you want
            print("Failed to apply \(setting.name): \(error)")
        }
    }

    // Current raw status for a setting (matches on resolved cmd)
    func currentValue(for setting: Setting,
                      statuses: [SettingsResponse],
                      command: Command) -> SettingsResponse? {
        guard case .int(let cmd)? = command.resolve(setting.command) else { return nil }
        return statuses.first(where: { $0.cmd == cmd })
    }

    // Pretty string for the row’s trailing text, based on options if available
    func currentDisplay(for setting: Setting,
                        statuses: [SettingsResponse],
                        command: Command) -> String? {
        guard let current = currentValue(for: setting, statuses: statuses, command: command) else { return nil }

        // Prefer matching an option label if provided
        let candidates = (setting.options ?? []) + (setting.options_alt ?? [])
        if !candidates.isEmpty {
            if let s = current.string, let match = candidates.first(where: { $0.value == s }) {
                return match.display
            }
            let raw = String(current.status)
            if let match = candidates.first(where: { $0.value == raw }) {
                return match.display
            }
        }

        // Fallback to underlying raw/string
        return current.string ?? String(current.status)
    }

    // Provide the list of options depending on dependency
    func options(for setting: Setting, isDependencySatisfied: Bool) -> [SettingsOption] {
        if let dep = setting.depends_on, !isDependencySatisfied {
            return setting.options_alt ?? []
        }
        return setting.options ?? []
    }

    // Evaluate depends_on
    func dependencySatisfied(for setting: Setting,
                             settings: [Setting],
                             statuses: [SettingsResponse],
                             command: Command) -> Bool {
        guard let dep = setting.depends_on else { return true }
        guard let dependencySetting = settings.first(where: { $0.command == dep.command }) else { return false }
        guard case .int(let depCmd)? = command.resolve(dependencySetting.command) else { return false }
        guard let status = statuses.first(where: { $0.cmd == depCmd }) else { return false }

        return dep.values.contains(status.status)
    }
}
