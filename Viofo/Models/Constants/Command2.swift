//
//  Command2.swift
//  Viofo
//
//  Created by Brandon on 2025-08-16.
//

import Foundation
import CommandMacros

public enum ViofoCameraModel {
    case A119
    case A119Mini
    case A129
    case A129IR
    case A129Plus
    case A129PlusIR
    case A129Pro
    case A129ProIR
    case A129ProPDRM
    case A129ProW
    case A139
    case A139Pro
    case A229
    case A339
}

public class Command2 {
    private(set) public var AUTO_POWER_OFF: Int = 3007
    private(set) public var BASE_URL: String = "http://192.168.1.254"
    private(set) public var BATTERY_CUT_OFF_TIME: Int = 8232
    private(set) public var BATTERY_CUT_OFF_VOLTAGE: Int = 9343
    private(set) public var BEEP_SOUND: Int = 9094
    private(set) public var BLANK_CHAR_REPLACE: String = "+"
    private(set) public var BLANK_CHAR_REPLACE_2: String = "*"
    private(set) public var BLUETOOTH_ACTION_BUTTON: Int = 0
    private(set) public var BLUETOOTH_MIC_BUTTON: Int = 0
    private(set) public var BOOT_DELAY: Int = 9424
    private(set) public var CAMERA_MODEL_STAMP: Int = 9216
    private(set) public var CAPTURE_SIZE: Int = 1002
    private(set) public var CARD_FREE_SPACE: Int = 3017
    private(set) public var CAR_NUMBER: Int = 9422
    private(set) public var CHANGE_MODE: Int = 3001
    private(set) public var CUSTOM_TEXT_STAMP: Int = 9417
    private(set) public var DATE_FORMAT: Int = 0
    private(set) public var DAYLIGHT_SAVING: Int = 0
    private(set) public var DEFAULT_IP: String = "192.168.1.254"
    private(set) public var DEFAULT_PORT: Int = 3333
    private(set) public var DELETE_ALL_FILE: Int = 4004
    private(set) public var DELETE_ONE_FILE: Int = 4003
    private(set) public var DISABLE_REAR_CAMERA: Int = 8098
    private(set) public var ENTER_PARKING_MODE_TIMER: Int = 0
    private(set) public var FIRMWARE_VERSION: Int = 3012
    private(set) public var FONT_CAMERA_MIRROR: Int = 0
    private(set) public var FORMAT_MEMORY: Int = 3010
    private(set) public var FORMAT_REMINDER: Int = 0
    private(set) public var FREQUENCY: Int = 9406
    private(set) public var FRONT_CAMERA_HDR: Int = 0
    private(set) public var FRONT_IMAGE_ROTATE: Int = 0
    private(set) public var FS_UNKNOW_FORMAT: Int = 3025
    private(set) public var GET_BATTERY_LEVEL: Int = 3019
    private(set) public var GET_CARD_STATUS: Int = 3024
    private(set) public var GET_CAR_NUMBER: Int = 9426
    private(set) public var GET_CURRENT_STATE: Int = 3014
    private(set) public var GET_CUSTOM_STAMP: Int = 9427
    private(set) public var GET_FILE_LIST: Int = 3015
    private(set) public var GET_SENSOR_STATUS: Int = 9432
    private(set) public var GET_UPDATE_FW_PATH: Int = 3026
    private(set) public var GET_WIFI_SSID_PASSWORD: Int = 3029
    private(set) public var GPS: Int = 9410
    private(set) public var GPS_INFO_STAMP: Int = 9214
    private(set) public var HDMI_OSD: Int = 0
    private(set) public var HDR_STAMP: Int = 0
    private(set) public var HDR_TIME: Int = 8251
    private(set) public var HDR_TIME_GET: Int = 8252
    private(set) public var HEART_BEAT: Int = 3016
    private(set) public var IMAGE_ROTATE: Int = 9093
    private(set) public var INTERIOR_CAMERA: Int = 0
    private(set) public var INTERIOR_CAMERA_HDR: Int = 0
    private(set) public var INTERIOR_CAMERA_MIRROR: Int = 0
    private(set) public var INTERIOR_CAM_FISHEYE_MODE: Int = 9339
    private(set) public var INTERIOR_IMAGE_ROTATE: Int = 0
    private(set) public var IR_CAMERA_COLOR: Int = 9218
    private(set) public var IR_LED: Int = 0
    private(set) public var LANGUAGE: Int = 3008
    private(set) public var LENSES_NUMBER: Int = 8250
    private(set) public var LIVE_VIDEO_SOURCE: Int = 3028
    private(set) public var LIVE_VIEW_BITRATE: Int = 2014
    private(set) public var LIVE_VIEW_URL: Int = 2019
    private(set) public var LOGO_STAMP: Int = 9229
    private(set) public var MANAGE_SSD_STORAGE: Int = 0
    private(set) public var MICROPHONE: Int = 0
    private(set) public var MOTION_DET: Int = 2006
    private(set) public var MOVIE_AUDIO: Int = 2007
    private(set) public var MOVIE_AUTO_RECORDING: Int = 2012
    private(set) public var MOVIE_BITRATE: Int = 9212
    private(set) public var MOVIE_CYCLIC_REC: Int = 2003
    private(set) public var MOVIE_DATE_PRINT: Int = 2008
    private(set) public var MOVIE_EV_INTERIOR: Int = 0
    private(set) public var MOVIE_EV_REAR: Int = 9217
    private(set) public var MOVIE_EXPOSURE: Int = 2005
    private(set) public var MOVIE_GSENSOR_SENS: Int = 2011
    private(set) public var MOVIE_LIVE_VIEW_CONTROL: Int = 2015
    private(set) public var MOVIE_MAX_RECORD_TIME: Int = 2009
    private(set) public var MOVIE_RECORD: Int = 2001
    private(set) public var MOVIE_RECORDING_TIME: Int = 2016
    private(set) public var MOVIE_REC_BITRATE: Int = 2013
    private(set) public var MOVIE_RESOLUTION: Int = 2002
    private(set) public var MOVIE_WDR: Int = 2004
    private(set) public var MULTIPLEX_VIDEO: Int = 9342
    private(set) public var PARKING_FILES_STORAGE: Int = 9340
    private(set) public var PARKING_GPS: Int = 0
    private(set) public var PARKING_G_SENSOR: Int = 9220
    private(set) public var PARKING_HDR: Int = 0
    private(set) public var PARKING_MODE: Int = 9421
    private(set) public var PARKING_MOTION_DETECTION: Int = 9221
    private(set) public var PARKING_RECORDING_GEOFENCING: Int = 0
    private(set) public var PARKING_RECORDING_TIMER: Int = 9428
    private(set) public var PHOTO_AVAIL_NUM: Int = 1003
    private(set) public var PHOTO_CAPTURE: Int = 1001
    private(set) public var PRIVACY_MODE: Int = 9330
    private(set) public var REAR_CAMERA_HDR: Int = 0
    private(set) public var REAR_CAMERA_MIRROR: Int = 9219
    private(set) public var REAR_IMAGE_ROTATE: Int = 0
    private(set) public var RECONNECT_WIFI: Int = 3018
    private(set) public var REMOTE_CONTROL_FUNCTION: Int = 2020
    private(set) public var REMOVE_LAST_USER: Int = 3023
    private(set) public var RESET_SETTING: Int = 3011
    private(set) public var RESOLUTION_FRAMES: Int = 8076
    private(set) public var RESTART_CAMERA: Int = 9095
    private(set) public var SCREEN: Int = 4002
    private(set) public var SCREEN_SAVER: Int = 9405
    private(set) public var SET_DATE: Int = 3005
    private(set) public var SET_NETWORK_MODE: Int = 0
    private(set) public var SET_TIME: Int = 3006
    private(set) public var SPEED_UNIT: Int = 9412
    private(set) public var SSD_CARD: Int = 0
    private(set) public var STAMP_COLOR: Int = 9331
    private(set) public var STORAGE_TYPE: Int = 9434
    private(set) public var STREAM_MJPEG: String = "http://192.168.1.254:8192"
    private(set) public var STREAM_VIDEO: String = "rtsp://192.168.1.254/xxx.mov"
    private(set) public var THUMB: Int = 4001
    private(set) public var TIME_FORMAT: Int = 0
    private(set) public var TIME_LAPSE_RECORDING: Int = 9201
    private(set) public var TIME_ZONE: Int = 9411
    private(set) public var TRIGGER_RAW_ENCODE: Int = 2017
    private(set) public var TV_FORMAT: Int = 3009
    private(set) public var VIDEO_STORAGE: Int = 0
    private(set) public var VOICE_CONTROL: Int = 9453
    private(set) public var VOICE_NOTIFICATION: Int = 0
    private(set) public var VOICE_NOTIFICATION_VOLUME: Int = 8053
    private(set) public var WIFI_CHANNEL: Int = 0
    private(set) public var WIFI_NAME: Int = 3003
    private(set) public var WIFI_PWD: Int = 3004
    private(set) public var WIFI_STATION_CONFIGURATION: Int = 3032

    private static func isDevice(_ firmwareName: String, currentFirmware: String) -> Bool {
        return currentFirmware.contains(firmwareName)
    }

    public init(for model: ViofoCameraModel, firmware: String, version: Double) {
        switch model {
        case .A119:
            self.BEEP_SOUND = 9403
            self.DATE_FORMAT = 9416
            self.ENTER_PARKING_MODE_TIMER = 9435
            self.HDR_TIME = 2027
            self.HDR_TIME_GET = 2028
            self.IMAGE_ROTATE = 9413
            self.MOVIE_WDR = 2026
            self.RESTART_CAMERA = 9423
            self.VOICE_NOTIFICATION = 9449
            self.VOICE_NOTIFICATION_VOLUME = 9447
            self.WIFI_CHANNEL = 9448
            
            if firmware.lowercased().contains("ir") {
                self.IR_LED = 9218
            }
            
            if version >= 2.1 {
                self.BLUETOOTH_MIC_BUTTON = 9465
                self.BLUETOOTH_ACTION_BUTTON = 9466
            }
      
        case .A129, .A129IR, .A129Plus, .A129PlusIR, .A129Pro, .A129ProIR, .A129ProPDRM, .A129ProW:
            self.RESTART_CAMERA = 9423
            self.IMAGE_ROTATE = 9413
            self.BEEP_SOUND = 9403
            
            if model == .A129 {
                if version >= 2.5 {
                    self.BLUETOOTH_MIC_BUTTON = 9465
                    self.BLUETOOTH_ACTION_BUTTON = 9466
                }
            }
            
            if model == .A129Plus {
                self.ENTER_PARKING_MODE_TIMER = 9435
                self.HDR_TIME = 2027
                self.HDR_TIME_GET = 2028
                if version >= 1.9 {
                    self.MOVIE_WDR = 2026
                }
                if firmware.lowercased().contains("ir") {
                    self.IR_LED = self.IR_CAMERA_COLOR
                }
                if version >= 2.0 {
                    self.BLUETOOTH_MIC_BUTTON = 9465
                    self.BLUETOOTH_ACTION_BUTTON = 9466
                }
            }
            
            if model == .A129Pro {
                self.ENTER_PARKING_MODE_TIMER = 9435
                if version >= 2.9 {
                    self.BLUETOOTH_MIC_BUTTON = 9465
                    self.BLUETOOTH_ACTION_BUTTON = 9466
                }
            }
            
            if model == .A129ProPDRM {
                self.IMAGE_ROTATE = 0
                self.MOTION_DET = 0
                self.MOVIE_DATE_PRINT = 0
                self.GPS = 0
            }
            
            if model == .A129ProIR {
                self.IR_LED = self.IR_CAMERA_COLOR
            }
            
        case .A139, .A139Pro:
            self.BLANK_CHAR_REPLACE = "*"
            self.MOVIE_BITRATE = 8200
            self.WIFI_CHANNEL = 8201
            self.LIVE_VIDEO_SOURCE = 8202
            self.IR_LED = 8203
            self.PARKING_G_SENSOR = 8204
            self.PARKING_MODE = 8205
            self.TIME_LAPSE_RECORDING = 8206
            self.PARKING_MOTION_DETECTION = 8207
            self.GPS = 8208
            self.GPS_INFO_STAMP = 8210
            self.SPEED_UNIT = 8209
            self.DATE_FORMAT = 8211
            self.TIME_ZONE = 8212
            self.CAMERA_MODEL_STAMP = 8213
            self.BEEP_SOUND = 8214
            self.FREQUENCY = 8215
            self.CAR_NUMBER = 8218
            self.CUSTOM_TEXT_STAMP = 8219
            self.MOVIE_EXPOSURE = 8220
            self.MOVIE_EV_INTERIOR = 8220
            self.MOVIE_EV_REAR = 8220
            self.MICROPHONE = 8221
            self.MOVIE_RESOLUTION = 8222
            self.BOOT_DELAY = 8223
            self.FRONT_IMAGE_ROTATE = 8224
            self.INTERIOR_IMAGE_ROTATE = 8225
            self.REAR_IMAGE_ROTATE = 8226
            self.GET_CAR_NUMBER = 8228
            self.GET_CUSTOM_STAMP = 8229
            self.RESTART_CAMERA = 8230
            self.MOTION_DET = 0
            self.PARKING_RECORDING_TIMER = 8232
            self.ENTER_PARKING_MODE_TIMER = 8233
            self.VOICE_NOTIFICATION = 9221
            self.INTERIOR_CAMERA_MIRROR = 9219
            self.REAR_CAMERA_MIRROR = 9220
            
            if version >= 1.5 && model == .A139 {
                self.PARKING_RECORDING_GEOFENCING = 8234
            }
            
            if version >= 1.9 && model == .A139 {
                self.BLUETOOTH_MIC_BUTTON = 9313
                self.BLUETOOTH_ACTION_BUTTON = 9314
            }
            
            if model == .A139Pro {
                if version >= 1.2 {
                    self.BLUETOOTH_MIC_BUTTON = 9313
                    self.BLUETOOTH_ACTION_BUTTON = 9314
                }
            }

        case .A229:
            self.BLANK_CHAR_REPLACE = "*"
            self.MOVIE_BITRATE = 8200
            self.WIFI_CHANNEL = 8201
            self.LIVE_VIDEO_SOURCE = 8202
            self.IR_LED = 8203
            self.PARKING_G_SENSOR = 8204
            self.PARKING_MODE = 8205
            self.TIME_LAPSE_RECORDING = 8206
            self.PARKING_MOTION_DETECTION = 8207
            self.GPS = 8208
            self.GPS_INFO_STAMP = 8210
            self.SPEED_UNIT = 8209
            self.DATE_FORMAT = 8211
            self.TIME_ZONE = 8212
            self.CAMERA_MODEL_STAMP = 8213
            self.BEEP_SOUND = 8214
            self.FREQUENCY = 8215
            self.CAR_NUMBER = 8218
            self.CUSTOM_TEXT_STAMP = 8219
            self.MOVIE_EXPOSURE = 8220
            self.MOVIE_EV_INTERIOR = 8220
            self.MOVIE_EV_REAR = 8220
            self.MICROPHONE = 8221
            self.MOVIE_RESOLUTION = 8222
            self.BOOT_DELAY = 8223
            self.FRONT_IMAGE_ROTATE = 8224
            self.INTERIOR_IMAGE_ROTATE = 8226
            self.REAR_IMAGE_ROTATE = 8225
            self.GET_CAR_NUMBER = 8228
            self.GET_CUSTOM_STAMP = 8229
            self.RESTART_CAMERA = 8230
            self.MOTION_DET = 0
            self.PARKING_RECORDING_TIMER = 8232
            self.ENTER_PARKING_MODE_TIMER = 8233
            self.VOICE_NOTIFICATION = 9221
            self.INTERIOR_CAMERA_MIRROR = 9220
            self.REAR_CAMERA_MIRROR = 9219
            self.PARKING_RECORDING_GEOFENCING = 8234
            
            if Self.isDevice("A229", currentFirmware: firmware) || Self.isDevice("A229P", currentFirmware: firmware) || Self.isDevice("A229S", currentFirmware: firmware) || Self.isDevice("A229U", currentFirmware: firmware) {
                self.LENSES_NUMBER = 8260
                self.SCREEN_SAVER = 8250
                if version >= 1.3 || Self.isDevice("A229U", currentFirmware: firmware) {
                    self.PARKING_HDR = 9320
                    self.TIME_FORMAT = 9321
                    self.FRONT_CAMERA_HDR = 9318
                    self.REAR_CAMERA_HDR = 9319
                    self.INTERIOR_CAMERA = 9322
                    self.DAYLIGHT_SAVING = 9323
                }
            }
            
            if ((Self.isDevice("A229P", currentFirmware: firmware) || Self.isDevice("A229S", currentFirmware: firmware)) && version >= 1.2) || Self.isDevice("A229U", currentFirmware: firmware) {
                self.FORMAT_REMINDER = 9312
                self.HDR_STAMP = 9311
                self.PARKING_GPS = 9225
            }
            
            if (Self.isDevice("A229", currentFirmware: firmware) && version >= 1.2) || Self.isDevice("A229U", currentFirmware: firmware) || ((Self.isDevice("A229P", currentFirmware: firmware) || Self.isDevice("A229S", currentFirmware: firmware)) && version >= 1.3) {
                self.BLUETOOTH_MIC_BUTTON = 9313
                self.BLUETOOTH_ACTION_BUTTON = 9314
            }

        case .A339:
            self.BLANK_CHAR_REPLACE = "*"
            self.MOVIE_BITRATE = 8200
            self.WIFI_CHANNEL = 8201
            self.LIVE_VIDEO_SOURCE = 8202
            self.IR_LED = 8203
            self.PARKING_G_SENSOR = 8204
            self.PARKING_MODE = 8205
            self.TIME_LAPSE_RECORDING = 8206
            self.PARKING_MOTION_DETECTION = 8207
            self.GPS = 8208
            self.GPS_INFO_STAMP = 8210
            self.SPEED_UNIT = 8209
            self.DATE_FORMAT = 8211
            self.TIME_ZONE = 8212
            self.CAMERA_MODEL_STAMP = 8213
            self.BEEP_SOUND = 8214
            self.FREQUENCY = 8215
            self.CAR_NUMBER = 8218
            self.CUSTOM_TEXT_STAMP = 8219
            self.MOVIE_EXPOSURE = 8220
            self.MOVIE_EV_INTERIOR = 8220
            self.MOVIE_EV_REAR = 8220
            self.MICROPHONE = 8221
            self.MOVIE_RESOLUTION = 8222
            self.BOOT_DELAY = 8223
            self.FRONT_IMAGE_ROTATE = 8224
            self.GET_CAR_NUMBER = 8228
            self.GET_CUSTOM_STAMP = 8229
            self.RESTART_CAMERA = 8230
            self.MOTION_DET = 0
            self.PARKING_RECORDING_TIMER = 8232
            self.ENTER_PARKING_MODE_TIMER = 8233
            self.VOICE_NOTIFICATION = 9221
            self.INTERIOR_CAMERA_MIRROR = 9220
            self.REAR_CAMERA_MIRROR = 9219
            self.INTERIOR_IMAGE_ROTATE = 8226
            self.REAR_IMAGE_ROTATE = 8225
            self.PARKING_RECORDING_GEOFENCING = 8234
            self.STORAGE_TYPE = 9327
            self.LENSES_NUMBER = 8260
            self.SCREEN_SAVER = 8250
            self.SSD_CARD = 9326
            self.VIDEO_STORAGE = 9315
            self.MANAGE_SSD_STORAGE = 9316
            self.FORMAT_REMINDER = 9312
            self.HDR_STAMP = 9311
            self.PARKING_GPS = 9225
            self.BLUETOOTH_MIC_BUTTON = 9313
            self.BLUETOOTH_ACTION_BUTTON = 9314
            self.PARKING_HDR = 9320
            self.DAYLIGHT_SAVING = 9323
            self.TIME_FORMAT = 9321
            self.FRONT_CAMERA_HDR = 9318
            self.REAR_CAMERA_HDR = 9319
            self.INTERIOR_CAMERA_HDR = 9333
            self.HDMI_OSD = 9325
            
            if Self.isDevice("A329S", currentFirmware: firmware) || Self.isDevice("A329T", currentFirmware: firmware) {
                self.INTERIOR_CAMERA = 9322
            }
      
        default:
            break
        }
    }
}
