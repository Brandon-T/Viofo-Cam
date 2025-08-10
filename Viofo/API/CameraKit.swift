//
//  CameraKit.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

extension Client {

    static func sendSwitchCameraCommand(_ command: Int = 8234) async throws -> SwitchCameraResponse {
        try await Client.sendCommand(command, as: SwitchCameraResponse.self)
    }

    static func sendCommand(_ command: Int, timeout: TimeInterval) async throws -> CommonResponse {
        try await Client.sendCommand(command, timeout: timeout, as: CommonResponse.self)
    }

    static func setSingleSetting(_ command: Int, _ value: Int) async throws -> CommonResponse {
        try await Client.sendCommandWithParam(command, value, as: CommonResponse.self)
    }

    static func setSingleSetting(_ command: Int, _ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(command, value, as: CommonResponse.self)
    }

    static func heartBeat() async throws -> CommonResponse {
        try await Client.sendCommand(Command.HEART_BEAT, timeout: 3, as: CommonResponse.self)
    }

    static func removeLastUser() async throws -> CommonResponse {
        try await Client.sendCommand(Command.REMOVE_LAST_USER, timeout: 3, as: CommonResponse.self)
    }

    static func getFirmwareVersion() async throws -> String? {
        try await Client.sendCommand(Command.FIRMWARE_VERSION, timeout: 15, as: CommonResponse.self).string
    }

    static func getLiveViewUrl() async throws -> StreamUrlData {
        try await Client.sendCommand(Command.LIVE_VIEW_URL, as: StreamUrlData.self)
    }

    static func startLiveView() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(Command.MOVIE_LIVE_VIEW_CONTROL, 1, as: CommonResponse.self)
    }

    static func stopLiveView() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(Command.MOVIE_LIVE_VIEW_CONTROL, 0, as: CommonResponse.self)
    }

    static func changeToVideoMode() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(Command.CHANGE_MODE, 1, as: CommonResponse.self)
    }

    static func changeToPlayBackMode() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(Command.CHANGE_MODE, 2, as: CommonResponse.self)
    }

    static func changeToPlayBackMode2() async throws -> CommonResponse {
        do {
            return try await Client.sendCommand(Command.CHANGE_MODE, timeout: 10, as: CommonResponse.self)
        } catch {
            return try await Client.sendCommandWithParam(Command.CHANGE_MODE, 2, as: CommonResponse.self)
        }
    }

    static func getCardStatus() async throws -> Int64? {
        try await Client.sendCommand(Command.GET_CARD_STATUS, as: CommonResponse.self).value
    }

    static func setManageSSDStorage(_ command: Int, action: String, time: Int) async throws -> CommonResponse {
        let params = ["str": action, "time": String(time)]
        return try await Client.sendCommandWithParamsMap(command, params, as: CommonResponse.self)
    }

    static func queryManageSSDStorage() async throws -> CommonResponse {
        let params = ["str": "querry"] // sic: matches Java spelling
        return try await Client.sendCommandWithParamsMap(Command_A339.MANAGE_SSD_STORAGE, params, as: CommonResponse.self)
    }

    static func cancelManageSSDStorage() async throws -> CommonResponse {
        let params = ["str": "cancel"]
        return try await Client.sendCommandWithParamsMap(Command_A339.MANAGE_SSD_STORAGE, params, as: CommonResponse.self)
    }

    static func formatMemory() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(Command.FORMAT_MEMORY, 1, as: CommonResponse.self)
    }

    static func getAllSettingStatus() async throws -> [Int: String] {
        let data = try await Client.sendRequest(command: Command.GET_CURRENT_STATE)
        let root = try SimpleXML.parse(data)
        if root.name == "Function" {
            var i: Int = 0
            var result = [Int: String]()
            
            for child in root.children {
                if child.name == "Cmd" {
                    i = Int(child.text) ?? 0
                } else if child.name == "Status" {
                    if (i == 8222 || i == 8220) {
                        result[i] = child.text
                    }
                } else if child.name == "Start" {
                    if i == Command.HDR_TIME {
                        result[i] = child.text
                    }
                } else if child.name == "End" {
                    if i == Command.HDR_TIME {
                        if let value = result[i] {
                            result[i] = "\(value)-\(child.text)"
                        } else {
                            result[i] = child.text
                        }
                    }
                }
            }
            
            return result
        }
        
        return [:]
    }

    static func getHDRTimeCurrentValue() async throws -> String {
        try await Client.sendCommand(Command.HDR_TIME_GET, as: String.self)
    }

    static func getLensesNumber() async throws -> Int {
        try await Client.sendCommand(Command.LENSES_NUMBER, as: Int.self)
    }

    static func stopRecording() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(Command.MOVIE_RECORD, 0, as: CommonResponse.self)
    }

    static func startRecording() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(Command.MOVIE_RECORD, 1, as: CommonResponse.self)
    }

    static func setDate(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(Command.SET_DATE, value, as: CommonResponse.self)
    }

    static func setTime(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(Command.SET_TIME, value, as: CommonResponse.self)
    }

    static func resetSetting() async throws -> CommonResponse {
        try await Client.sendCommand(Command.RESET_SETTING, as: CommonResponse.self)
    }

    static func setWifiName(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(Command.WIFI_NAME, value, as: CommonResponse.self)
    }

    static func setWifiPwd(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(Command.WIFI_PWD, value, as: CommonResponse.self)
    }

    static func getOTAFile() async throws -> CommonResponse {
        try await Client.sendCommandWithStr(9310, "ready", as: CommonResponse.self)
    }

    static func setOTAMd5(_ md5: String) async throws -> CommonResponse {
        // TtmlNode.START is "start" in Android
        let params = ["str": "start", "md5": md5]
        return try await Client.sendCommandWithParamsMap(9310, params, as: CommonResponse.self)
    }

    static func setStationModeWifiNameAndPassword(_ ssid: String, _ password: String) async throws -> CommonResponse {
        let name = Command.BLANK_CHAR_REPLACE.isEmpty ? ssid : ssid.replacingOccurrences(of: " ", with: Command.BLANK_CHAR_REPLACE)
        let payload = "\(name):\(password)"
        return try await Client.sendCommandWithStr(Command.WIFI_STATION_CONFIGURATION, payload, as: CommonResponse.self)
    }

    static func getCardFreeSpace() async throws -> Int64? {
        try await Client.sendCommand(Command.CARD_FREE_SPACE, as: CommonResponse.self).value
    }

    static func getWifiNameAndPassword() async throws -> WifiData {
        try await Client.sendCommand(Command.GET_WIFI_SSID_PASSWORD, as: WifiData.self)
    }

    static func getFileList() async throws -> [CameraFile] {
        return try await Client.sendCommand(Command.GET_FILE_LIST, timeout: 100, as: CameraFilesList.self).files
    }

    static func deleteOneFile(_ path: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(Command.DELETE_ONE_FILE, path, as: CommonResponse.self)
    }

    static func deleteAllFile() async throws -> CommonResponse {
        try await Client.sendCommand(Command.DELETE_ALL_FILE, as: CommonResponse.self)
    }

    static func restartCamera() async throws -> CommonResponse {
        try await Client.sendCommand(Command.RESTART_CAMERA, as: CommonResponse.self)
    }

    static func reConnectWiFi() async throws -> CommonResponse {
        try await Client.sendCommand(Command.RECONNECT_WIFI, as: CommonResponse.self)
    }

    static func setWiFiStationMode() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(Command.SET_NETWORK_MODE, 1, as: CommonResponse.self)
    }

    static func getCarNumber() async throws -> CarNumber {
        try await Client.sendCommand(Command.GET_CAR_NUMBER, as: CarNumber.self)
    }

    static func getCustomStamp() async throws -> CustomStamp {
        try await Client.sendCommand(Command.GET_CUSTOM_STAMP, as: CustomStamp.self)
    }

    static func setCarNumber(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(Command.CAR_NUMBER, value, as: CommonResponse.self)
    }

    static func setCustomTextStamp(_ value: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(Command.CUSTOM_TEXT_STAMP, value, as: CommonResponse.self)
    }

    static func setAccessSDCardStorage() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(Command.STORAGE_TYPE, 1, as: CommonResponse.self)
    }

    static func getRearCameraStatus() async throws -> CommonResponse {
        try await Client.sendCommand(Command.GET_SENSOR_STATUS, as: CommonResponse.self)
    }

    static func getSSDTFCardStatus() async throws -> CommonResponse {
        try await Client.sendCommand(9326, as: CommonResponse.self)
    }

    static func formatSSD() async throws -> CommonResponse {
        try await Client.sendCommand(9317, as: CommonResponse.self)
    }

    static func setAccessInternalStorage() async throws -> CommonResponse {
        try await Client.sendCommandWithParam(Command.STORAGE_TYPE, 0, as: CommonResponse.self)
    }

    static func getWiFiDirectKey(_ getPwdCommand: Int) async throws -> CommonResponse {
        try await Client.sendCommand(getPwdCommand, as: CommonResponse.self)
    }

    static func connectWiFiDirectWithKey(_ sendPwdCommand: Int, key: String) async throws -> CommonResponse {
        try await Client.sendCommandWithStr(sendPwdCommand, key, as: CommonResponse.self)
    }

    static func takeSnapshot() async throws -> CommonResponse {
        try await Client.sendCommand(Command.TRIGGER_RAW_ENCODE, as: CommonResponse.self)
    }

    static func getGPSSignal() async throws -> CommonResponse {
        try await Client.sendCommand(8058, as: CommonResponse.self)
    }

    static func getSwitchCamera(_ command: Int) async throws -> SwitchCameraResponse {
        try await sendSwitchCameraCommand(command)
    }

    static func getVoiceControlInfo() async throws -> String {
        try await Client.sendCommand(9228, as: String.self)
    }
}
