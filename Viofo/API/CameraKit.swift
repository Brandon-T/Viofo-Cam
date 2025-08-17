//
//  CameraKit.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

actor CameraKit {
    let firmware: ViofoFirmware
    let command: Command
    
    private static var instance: CameraKit?

    static func shared() async throws -> CameraKit {
        if let existing = instance {
            return existing
        }

        let created = try await CameraKit()
        instance = created
        return created
    }

    private init() async throws {
        let firmwareVersion = try await Client.sendCommand(Command.default.FIRMWARE_VERSION, timeout: 15, as: CommonResponse.self).string ?? "INVALID_FIRMWARE"
        
        self.firmware = try ViofoFirmware.from(firmwareVersion)
        self.command = Command(for: firmware)
    }

    private static func sendCommand(_ command: Int, timeout: TimeInterval) async throws -> CommonResponse {
        try await Client.sendCommand(command, timeout: timeout, as: CommonResponse.self)
    }

    private static func setSingleSetting(_ command: Int, _ value: Int) async throws -> CommonResponse {
        try await Client.sendCommandWithParam(command, value, as: CommonResponse.self)
    }

    private static func setSingleSetting(_ command: Int, _ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(command, value, as: CommonResponse.self)
    }

    func heartBeat() async throws -> CommonResponse {
        try await Client.sendCommand(self.command.HEART_BEAT, timeout: 3, as: CommonResponse.self)
    }

    func removeLastUser() async throws -> CommonResponse {
        try await Client.sendCommand(self.command.REMOVE_LAST_USER, timeout: 3, as: CommonResponse.self)
    }

    func getFirmwareVersion() async throws -> String? {
        try await Client.sendCommand(self.command.FIRMWARE_VERSION, timeout: 15, as: CommonResponse.self).string
    }

    func getLiveViewUrl() async throws -> StreamUrlData {
        try await Client.sendCommand(self.command.LIVE_VIEW_URL, as: StreamUrlData.self)
    }

    func startLiveView() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.MOVIE_LIVE_VIEW_CONTROL, 1, as: CommonResponse.self)
    }

    func stopLiveView() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.MOVIE_LIVE_VIEW_CONTROL, 0, as: CommonResponse.self)
    }
    
    func toggleLiveVideoSource() async throws -> CommonResponse {
        try await Client.sendCommand(self.command.LIVE_VIDEO_SOURCE, as: CommonResponse.self)
    }

    func changeToVideoMode() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.CHANGE_MODE, 1, as: CommonResponse.self)
    }

    func changeToPlayBackMode() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.CHANGE_MODE, 2, as: CommonResponse.self)
    }

    func changeToPlayBackMode2() async throws -> CommonResponse {
        do {
            return try await Client.sendCommand(self.command.CHANGE_MODE, timeout: 10, as: CommonResponse.self)
        } catch {
            return try await Client.sendCommandWithParam(self.command.CHANGE_MODE, 2, as: CommonResponse.self)
        }
    }

    func getCardStatus() async throws -> Int64? {
        try await Client.sendCommand(self.command.GET_CARD_STATUS, as: CommonResponse.self).value
    }

    func setManageSSDStorage(_ command: Int, action: String, time: Int) async throws -> CommonResponse {
        let params = ["str": action, "time": String(time)]
        return try await Client.sendCommandWithParamsMap(command, params, as: CommonResponse.self)
    }

    func queryManageSSDStorage() async throws -> CommonResponse {
        let params = ["str": "querry"] // sic: matches Java spelling
        return try await Client.sendCommandWithParamsMap(self.command.MANAGE_SSD_STORAGE, params, as: CommonResponse.self)
    }

    func cancelManageSSDStorage() async throws -> CommonResponse {
        let params = ["str": "cancel"]
        return try await Client.sendCommandWithParamsMap(self.command.MANAGE_SSD_STORAGE, params, as: CommonResponse.self)
    }

    func formatMemory() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.FORMAT_MEMORY, 1, as: CommonResponse.self)
    }

    func getAllSettingStatus() async throws -> [SettingsResponse] {
        let data = try await Client.sendRequest(command: self.command.GET_CURRENT_STATE)
        let root = try SimpleXML.parse(data)
        guard root.name == "Function" else {
            return []
        }
        
        var results = [SettingsResponse]()
        var currentCmd: Int?
        var currentStatus: Int?
        var currentString: String?
        
        for child in root.children {
            if child.name == "Cmd" {
                if let cmd = currentCmd, let status = currentStatus {
                    results.append(SettingsResponse(cmd: cmd, status: status, string: currentString))
                    currentString = nil
                }
                
                currentCmd = Int(child.text)
            } else if child.name == "Status" {
                currentStatus = Int(child.text)
            } else if child.name == "String" {
                currentString = child.text
            }
            else if child.name == "Function" {
                var nestedCmd: Int?
                var nestedStatus: Int?
                var nestedString: String?
                
                for nestedChild in child.children {
                    if nestedChild.name == "Cmd" {
                        nestedCmd = Int(nestedChild.text)
                    } else if nestedChild.name == "Status" {
                        nestedStatus = Int(nestedChild.text)
                    } else if nestedChild.name == "String" {
                        nestedString = nestedChild.text
                    }
                }
                
                if let cmd = nestedCmd, let status = nestedStatus {
                    results.append(SettingsResponse(cmd: cmd, status: status, string: nestedString))
                }
            }
        }
        
        if let cmd = currentCmd, let status = currentStatus {
            results.append(SettingsResponse(cmd: cmd, status: status, string: currentString))
        }
        
        return results
    }

    func getHDRTimeCurrentValue() async throws -> String {
        try await Client.sendCommand(self.command.HDR_TIME_GET, as: String.self)
    }

    func getLensesNumber() async throws -> LensesResponse {
        try await Client.sendCommand(self.command.LENSES_NUMBER, as: LensesResponse.self)
    }

    func stopRecording() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.MOVIE_RECORD, 0, as: CommonResponse.self)
    }

    func startRecording() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.MOVIE_RECORD, 1, as: CommonResponse.self)
    }
    
    func stopRecordingAudio() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.MICROPHONE, 0, as: CommonResponse.self)
    }
    
    func startRecordingAudio() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.MICROPHONE, 1, as: CommonResponse.self)
    }

    func setDate(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(self.command.SET_DATE, value, as: CommonResponse.self)
    }

    func setTime(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(self.command.SET_TIME, value, as: CommonResponse.self)
    }

    func resetSetting() async throws -> CommonResponse {
        try await Client.sendCommand(self.command.RESET_SETTING, as: CommonResponse.self)
    }

    func setWifiName(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(self.command.WIFI_NAME, value, as: CommonResponse.self)
    }

    func setWifiPwd(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(self.command.WIFI_PWD, value, as: CommonResponse.self)
    }

    func getOTAFile() async throws -> CommonResponse {
        try await Client.sendCommandWithStr(9310, "ready", as: CommonResponse.self)
    }

    func setOTAMd5(_ md5: String) async throws -> CommonResponse {
        // TtmlNode.START is "start" in Android
        let params = ["str": "start", "md5": md5]
        return try await Client.sendCommandWithParamsMap(9310, params, as: CommonResponse.self)
    }

    func setStationModeWifiNameAndPassword(_ ssid: String, _ password: String) async throws -> CommonResponse {
        let name = self.command.BLANK_CHAR_REPLACE.isEmpty ? ssid : ssid.replacingOccurrences(of: " ", with: self.command.BLANK_CHAR_REPLACE)
        let payload = "\(name):\(password)"
        return try await Client.sendCommandWithStr(self.command.WIFI_STATION_CONFIGURATION, payload, as: CommonResponse.self)
    }

    func getCardFreeSpace() async throws -> Int64? {
        try await Client.sendCommand(self.command.CARD_FREE_SPACE, as: CommonResponse.self).value
    }

    func getWifiNameAndPassword() async throws -> WifiData {
        try await Client.sendCommand(self.command.GET_WIFI_SSID_PASSWORD, as: WifiData.self)
    }

    func getFileList() async throws -> [CameraFile] {
        return try await Client.sendCommand(self.command.GET_FILE_LIST, timeout: 100, as: CameraFilesList.self).files
    }

    func deleteOneFile(_ path: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(self.command.DELETE_ONE_FILE, path, as: CommonResponse.self)
    }

    func deleteAllFile() async throws -> CommonResponse {
        try await Client.sendCommand(self.command.DELETE_ALL_FILE, as: CommonResponse.self)
    }

    func restartCamera() async throws -> CommonResponse {
        try await Client.sendCommand(self.command.RESTART_CAMERA, as: CommonResponse.self)
    }

    func reConnectWiFi() async throws -> CommonResponse {
        try await Client.sendCommand(self.command.RECONNECT_WIFI, as: CommonResponse.self)
    }

    func setWiFiStationMode() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.SET_NETWORK_MODE, 1, as: CommonResponse.self)
    }

    func getCarNumber() async throws -> CarNumber {
        try await Client.sendCommand(self.command.GET_CAR_NUMBER, as: CarNumber.self)
    }

    func getCustomStamp() async throws -> CustomStamp {
        try await Client.sendCommand(self.command.GET_CUSTOM_STAMP, as: CustomStamp.self)
    }

    func setCarNumber(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(self.command.CAR_NUMBER, value, as: CommonResponse.self)
    }

    func setCustomTextStamp(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(self.command.CUSTOM_TEXT_STAMP, value, as: CommonResponse.self)
    }

    func setAccessSDCardStorage() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.STORAGE_TYPE, 1, as: CommonResponse.self)
    }

    func getRearCameraStatus() async throws -> CommonResponse {
        try await Client.sendCommand(self.command.GET_SENSOR_STATUS, as: CommonResponse.self)
    }

    func getSSDTFCardStatus() async throws -> CommonResponse {
        try await Client.sendCommand(self.command.SSD_CARD, as: CommonResponse.self)
    }

    func formatSSD() async throws -> CommonResponse {
        try await Client.sendCommand(self.command.FORMAT_SSD, as: CommonResponse.self)
    }

    func setAccessInternalStorage() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(self.command.STORAGE_TYPE, 0, as: CommonResponse.self)
    }

    func getWiFiDirectKey(_ getPwdCommand: Int) async throws -> CommonResponse {
        try await Client.sendCommand(getPwdCommand, as: CommonResponse.self)
    }

    func connectWiFiDirectWithKey(_ sendPwdCommand: Int, key: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(sendPwdCommand, key, as: CommonResponse.self)
    }

    func takeSnapshot() async throws -> CommonResponse {
        try await Client.sendCommand(self.command.TRIGGER_RAW_ENCODE, as: CommonResponse.self)
    }

    func getGPSSignal() async throws -> CommonResponse {
        try await Client.sendCommand(8058, as: CommonResponse.self)
    }

    func getVoiceControlInfo() async throws -> [VoiceControlInfoResponse] {
        let data = try await Client.sendRequest(command: self.command.VOICE_CONTROL_INFO)
        let root = try SimpleXML.parse(data)
        guard root.name == "LIST" else {
            return []
        }
        
        return root.children.map({ VoiceControlInfoResponse(key: $0.name, command: $0.text) })
    }
    
    func getHDRTime() async throws -> HDRTimeResponse {
        try await Client.sendCommand(self.command.HDR_TIME_GET, as: HDRTimeResponse.self)
    }
}
