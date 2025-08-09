//
//  Command.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import Foundation

open class Command {
    open class var AUTO_POWER_OFF: Int { 3007 }
    open class var BASE_URL: String { "http://192.168.1.254" }
    open class var BATTERY_CUT_OFF_TIME: Int { 8232 }
    open class var BATTERY_CUT_OFF_VOLTAGE: Int { 9343 }
    open class var BEEP_SOUND: Int { 9094 }
    open class var BLANK_CHAR_REPLACE: String { "+" }
    open class var BLANK_CHAR_REPLACE_2: String { "*" }
    open class var BLUETOOTH_ACTION_BUTTON: Int { 0 }
    open class var BLUETOOTH_MIC_BUTTON: Int { 0 }
    open class var BOOT_DELAY: Int { 9424 }
    open class var CAMERA_MODEL_STAMP: Int { 9216 }
    open class var CAPTURE_SIZE: Int { 1002 }
    open class var CARD_FREE_SPACE: Int { 3017 }
    open class var CAR_NUMBER: Int { 9422 }
    open class var CHANGE_MODE: Int { 3001 }
    open class var CUSTOM_TEXT_STAMP: Int { 9417 }
    open class var DATE_FORMAT: Int { 0 }
    open class var DAYLIGHT_SAVING: Int { 0 }
    open class var DEFAULT_IP: String { "192.168.1.254" }
    open class var DEFAULT_PORT: Int { 3333 }
    open class var DELETE_ALL_FILE: Int { 4004 }
    open class var DELETE_ONE_FILE: Int { 4003 }
    open class var DISABLE_REAR_CAMERA: Int { 8098 }
    open class var ENTER_PARKING_MODE_TIMER: Int { 0 }
    open class var FIRMWARE_VERSION: Int { 3012 }
    open class var FONT_CAMERA_MIRROR: Int { 0 }
    open class var FORMAT_MEMORY: Int { 3010 }
    open class var FORMAT_REMINDER: Int { 0 }
    open class var FREQUENCY: Int { 9406 }
    open class var FRONT_CAMERA_HDR: Int { 0 }
    open class var FRONT_IMAGE_ROTATE: Int { 0 }
    open class var FS_UNKNOW_FORMAT: Int { 3025 }
    open class var GET_BATTERY_LEVEL: Int { 3019 }
    open class var GET_CARD_STATUS: Int { 3024 }
    open class var GET_CAR_NUMBER: Int { 9426 }
    open class var GET_CURRENT_STATE: Int { 3014 }
    open class var GET_CUSTOM_STAMP: Int { 9427 }
    open class var GET_FILE_LIST: Int { 3015 }
    open class var GET_SENSOR_STATUS: Int { 9432 }
    open class var GET_UPDATE_FW_PATH: Int { 3026 }
    open class var GET_WIFI_SSID_PASSWORD: Int { 3029 }
    open class var GPS: Int { 9410 }
    open class var GPS_INFO_STAMP: Int { 9214 }
    open class var HDMI_OSD: Int { 0 }
    open class var HDR_STAMP: Int { 0 }
    open class var HDR_TIME: Int { 8251 }
    open class var HDR_TIME_GET: Int { 8252 }
    open class var HEART_BEAT: Int { 3016 }
    open class var IMAGE_ROTATE: Int { 9093 }
    open class var INTERIOR_CAMERA: Int { 0 }
    open class var INTERIOR_CAMERA_HDR: Int { 0 }
    open class var INTERIOR_CAMERA_MIRROR: Int { 0 }
    open class var INTERIOR_CAM_FISHEYE_MODE: Int { 9339 }
    open class var INTERIOR_IMAGE_ROTATE: Int { 0 }
    open class var IR_CAMERA_COLOR: Int { 9218 }
    open class var IR_LED: Int { 0 }
    open class var LANGUAGE: Int { 3008 }
    open class var LENSES_NUMBER: Int { 8250 }
    open class var LIVE_VIDEO_SOURCE: Int { 3028 }
    open class var LIVE_VIEW_BITRATE: Int { 2014 }
    open class var LIVE_VIEW_URL: Int { 2019 }
    open class var LOGO_STAMP: Int { 9229 }
    open class var MANAGE_SSD_STORAGE: Int { 0 }
    open class var MICROPHONE: Int { 0 }
    open class var MOTION_DET: Int { 2006 }
    open class var MOVIE_AUDIO: Int { 2007 }
    open class var MOVIE_AUTO_RECORDING: Int { 2012 }
    open class var MOVIE_BITRATE: Int { 9212 }
    open class var MOVIE_CYCLIC_REC: Int { 2003 }
    open class var MOVIE_DATE_PRINT: Int { 2008 }
    open class var MOVIE_EV_INTERIOR: Int { 0 }
    open class var MOVIE_EV_REAR: Int { 9217 }
    open class var MOVIE_EXPOSURE: Int { 2005 }
    open class var MOVIE_GSENSOR_SENS: Int { 2011 }
    open class var MOVIE_LIVE_VIEW_CONTROL: Int { 2015 }
    open class var MOVIE_MAX_RECORD_TIME: Int { 2009 }
    open class var MOVIE_RECORD: Int { 2001 }
    open class var MOVIE_RECORDING_TIME: Int { 2016 }
    open class var MOVIE_REC_BITRATE: Int { 2013 }
    open class var MOVIE_RESOLUTION: Int { 2002 }
    open class var MOVIE_WDR: Int { 2004 }
    open class var MULTIPLEX_VIDEO: Int { 9342 }
    open class var PARKING_FILES_STORAGE: Int { 9340 }
    open class var PARKING_GPS: Int { 0 }
    open class var PARKING_G_SENSOR: Int { 9220 }
    open class var PARKING_HDR: Int { 0 }
    open class var PARKING_MODE: Int { 9421 }
    open class var PARKING_MOTION_DETECTION: Int { 9221 }
    open class var PARKING_RECORDING_GEOFENCING: Int { 0 }
    open class var PARKING_RECORDING_TIMER: Int { 9428 }
    open class var PHOTO_AVAIL_NUM: Int { 1003 }
    open class var PHOTO_CAPTURE: Int { 1001 }
    open class var PRIVACY_MODE: Int { 9330 }
    open class var REAR_CAMERA_HDR: Int { 0 }
    open class var REAR_CAMERA_MIRROR: Int { 9219 }
    open class var REAR_IMAGE_ROTATE: Int { 0 }
    open class var RECONNECT_WIFI: Int { 3018 }
    open class var REMOTE_CONTROL_FUNCTION: Int { 2020 }
    open class var REMOVE_LAST_USER: Int { 3023 }
    open class var RESET_SETTING: Int { 3011 }
    open class var RESOLUTION_FRAMES: Int { 8076 }
    open class var RESTART_CAMERA: Int { 9095 }
    open class var SCREEN: Int { 4002 }
    open class var SCREEN_SAVER: Int { 9405 }
    open class var SET_DATE: Int { 3005 }
    open class var SET_NETWORK_MODE: Int { 0 }
    open class var SET_TIME: Int { 3006 }
    open class var SPEED_UNIT: Int { 9412 }
    open class var SSD_CARD: Int { 0 }
    open class var STAMP_COLOR: Int { 9331 }
    open class var STORAGE_TYPE: Int { 9434 }
    open class var STREAM_MJPEG: String { "http://192.168.1.254:8192" }
    open class var STREAM_VIDEO: String { "rtsp://192.168.1.254/xxx.mov" }
    open class var THUMB: Int { 4001 }
    open class var TIME_FORMAT: Int { 0 }
    open class var TIME_LAPSE_RECORDING: Int { 9201 }
    open class var TIME_ZONE: Int { 9411 }
    open class var TRIGGER_RAW_ENCODE: Int { 2017 }
    open class var TV_FORMAT: Int { 3009 }
    open class var VIDEO_STORAGE: Int { 0 }
    open class var VOICE_CONTROL: Int { 9453 }
    open class var VOICE_NOTIFICATION: Int { 0 }
    open class var VOICE_NOTIFICATION_VOLUME: Int { 8053 }
    open class var WIFI_CHANNEL: Int { 0 }
    open class var WIFI_NAME: Int { 3003 }
    open class var WIFI_PWD: Int { 3004 }
    open class var WIFI_STATION_CONFIGURATION: Int { 3032 }
}

extension Client {
    static func sendCommandWithParam<T: Decodable>(_ command: Int, _ param: Int, as type: T.Type) async throws -> T {
        try await Client.sendRequest(command: command, param: param, decodeAs: type)
    }

    static func sendCommandWithStr<T: Decodable>(_ command: Int, _ str: String, as type: T.Type) async throws -> T {
        try await Client.sendRequest(command: command, str: str, decodeAs: type)
    }

    static func sendCommandWithParamsMap<T: Decodable>(_ command: Int, _ params: [String: String], as type: T.Type) async throws -> T {
        try await Client.sendRequest(command: command, paramsMap: params, decodeAs: type)
    }

    static func sendCommand<T: Decodable>(_ command: Int, as type: T.Type) async throws -> T {
        try await Client.sendRequest(command: command, decodeAs: type)
    }

    static func sendCommand<T: Decodable>(_ command: Int, timeout: TimeInterval, as type: T.Type) async throws -> T {
        try await Client.sendRequest(command: command, timeout: timeout, decodeAs: type)
    }
}
