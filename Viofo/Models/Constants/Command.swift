//
//  Command.swift
//  Viofo
//
//  Created by Brandon on 2025-08-16.
//

import Foundation
import CommandMacros

@GenerateCommandIndex
class Command {
    private let currentFirmware: ViofoFirmware
    
    private(set) var AUTO_POWER_OFF: Int = 3007
    private(set) var BASE_URL: String = "http://192.168.1.254"
    private(set) var BATTERY_CUT_OFF_TIME: Int = 8232
    private(set) var BATTERY_CUT_OFF_VOLTAGE: Int = 9343
    private(set) var BEEP_SOUND: Int = 9094
    private(set) var BLANK_CHAR_REPLACE: String = "+"
    private(set) var BLANK_CHAR_REPLACE_2: String = "*"
    private(set) var BLUETOOTH_ACTION_BUTTON: Int = 0
    private(set) var BLUETOOTH_MIC_BUTTON: Int = 0
    private(set) var BOOT_DELAY: Int = 9424
    private(set) var CAMERA_MODEL_STAMP: Int = 9216
    private(set) var CAPTURE_SIZE: Int = 1002
    private(set) var CARD_FREE_SPACE: Int = 3017
    private(set) var CAR_NUMBER: Int = 9422
    private(set) var CHANGE_MODE: Int = 3001
    private(set) var CUSTOM_TEXT_STAMP: Int = 9417
    private(set) var DATE_FORMAT: Int = 0
    private(set) var DAYLIGHT_SAVING: Int = 0
    private(set) var DEFAULT_IP: String = "192.168.1.254"
    private(set) var DEFAULT_PORT: Int = 3333
    private(set) var DELETE_ALL_FILE: Int = 4004
    private(set) var DELETE_ONE_FILE: Int = 4003
    private(set) var DISABLE_REAR_CAMERA: Int = 8098
    private(set) var ENTER_PARKING_MODE_TIMER: Int = 0
    private(set) var FIRMWARE_VERSION: Int = 3012
    private(set) var FONT_CAMERA_MIRROR: Int = 0
    private(set) var FORMAT_MEMORY: Int = 3010
    private(set) var FORMAT_REMINDER: Int = 0
    private(set) var FREQUENCY: Int = 9406
    private(set) var FRONT_CAMERA_HDR: Int = 0
    private(set) var FRONT_IMAGE_ROTATE: Int = 0
    private(set) var FS_UNKNOW_FORMAT: Int = 3025
    private(set) var GET_BATTERY_LEVEL: Int = 3019
    private(set) var GET_CARD_STATUS: Int = 3024
    private(set) var GET_CAR_NUMBER: Int = 9426
    private(set) var GET_CURRENT_STATE: Int = 3014
    private(set) var GET_CUSTOM_STAMP: Int = 9427
    private(set) var GET_FILE_LIST: Int = 3015
    private(set) var GET_SENSOR_STATUS: Int = 9432
    private(set) var GET_UPDATE_FW_PATH: Int = 3026
    private(set) var GET_WIFI_SSID_PASSWORD: Int = 3029
    private(set) var GPS: Int = 9410
    private(set) var GPS_INFO_STAMP: Int = 9214
    private(set) var HDMI_OSD: Int = 0
    private(set) var HDR_STAMP: Int = 0
    private(set) var HDR_TIME: Int = 8251
    private(set) var HDR_TIME_GET: Int = 8252
    private(set) var HEART_BEAT: Int = 3016
    private(set) var IMAGE_ROTATE: Int = 9093
    private(set) var INTERIOR_CAMERA: Int = 0
    private(set) var INTERIOR_CAMERA_HDR: Int = 0
    private(set) var INTERIOR_CAMERA_MIRROR: Int = 0
    private(set) var INTERIOR_CAM_FISHEYE_MODE: Int = 9339
    private(set) var INTERIOR_IMAGE_ROTATE: Int = 0
    private(set) var IR_CAMERA_COLOR: Int = 9218
    private(set) var IR_LED: Int = 0
    private(set) var LANGUAGE: Int = 3008
    private(set) var LENSES_NUMBER: Int = 8250
    private(set) var LIVE_VIDEO_SOURCE: Int = 3028
    private(set) var LIVE_VIEW_BITRATE: Int = 2014
    private(set) var LIVE_VIEW_URL: Int = 2019
    private(set) var LOGO_STAMP: Int = 9229
    private(set) var MANAGE_SSD_STORAGE: Int = 0
    private(set) var MICROPHONE: Int = 0
    private(set) var MOTION_DET: Int = 2006
    private(set) var MOVIE_AUDIO: Int = 2007
    private(set) var MOVIE_AUTO_RECORDING: Int = 2012
    private(set) var MOVIE_BITRATE: Int = 9212
    private(set) var MOVIE_CYCLIC_REC: Int = 2003
    private(set) var MOVIE_DATE_PRINT: Int = 2008
    private(set) var MOVIE_EV_INTERIOR: Int = 0
    private(set) var MOVIE_EV_REAR: Int = 9217
    private(set) var MOVIE_EXPOSURE: Int = 2005
    private(set) var MOVIE_GSENSOR_SENS: Int = 2011
    private(set) var MOVIE_LIVE_VIEW_CONTROL: Int = 2015
    private(set) var MOVIE_MAX_RECORD_TIME: Int = 2009
    private(set) var MOVIE_RECORD: Int = 2001
    private(set) var MOVIE_RECORDING_TIME: Int = 2016
    private(set) var MOVIE_REC_BITRATE: Int = 2013
    private(set) var MOVIE_RESOLUTION: Int = 2002
    private(set) var MOVIE_WDR: Int = 2004
    private(set) var MULTIPLEX_VIDEO: Int = 9342
    private(set) var NORMAL_LED_CONTROL_FRONT: Int = 0
    private(set) var NORMAL_LED_CONTROL_FRONT_TELE: Int = 0
    private(set) var NORMAL_LED_CONTROL_REAL: Int = 0
    private(set) var PARKING_FILES_STORAGE: Int = 9340
    private(set) var PARKING_GPS: Int = 0
    private(set) var PARKING_G_SENSOR: Int = 9220
    private(set) var PARKING_HDR: Int = 0
    private(set) var PARKING_MODE: Int = 9421
    private(set) var PARKING_MOTION_DETECTION: Int = 9221
    private(set) var PARKING_RECORDING_GEOFENCING: Int = 0
    private(set) var PARKING_RECORDING_TIMER: Int = 9428
    private(set) var PARK_LED_CONTROL_FRONT: Int = 0
    private(set) var PARK_LED_CONTROL_FRONT_TELE: Int = 0
    private(set) var PARK_LED_CONTROL_REAL: Int = 0
    private(set) var PHOTO_AVAIL_NUM: Int = 1003
    private(set) var PHOTO_CAPTURE: Int = 1001
    private(set) var PRIVACY_MODE: Int = 9330
    private(set) var REAR_CAMERA_HDR: Int = 0
    private(set) var REAR_CAMERA_MIRROR: Int = 9219
    private(set) var REAR_IMAGE_ROTATE: Int = 0
    private(set) var RECONNECT_WIFI: Int = 3018
    private(set) var REMOTE_CONTROL_FUNCTION: Int = 2020
    private(set) var REMOVE_LAST_USER: Int = 3023
    private(set) var RESET_SETTING: Int = 3011
    private(set) var RESOLUTION_FRAMES: Int = 8076
    private(set) var RESTART_CAMERA: Int = 9095
    private(set) var SCREEN: Int = 4002
    private(set) var SCREEN_SAVER: Int = 9405
    private(set) var SET_DATE: Int = 3005
    private(set) var SET_NETWORK_MODE: Int = 0
    private(set) var SET_TIME: Int = 3006
    private(set) var SPEED_UNIT: Int = 9412
    private(set) var SSD_CARD: Int = 0
    private(set) var STAMP_COLOR: Int = 9331
    private(set) var STORAGE_TYPE: Int = 9434
    private(set) var FORMAT_SSD: Int = 9317
    private(set) var STREAM_MJPEG: String = "http://192.168.1.254:8192"
    private(set) var STREAM_VIDEO: String = "rtsp://192.168.1.254/xxx.mov"
    private(set) var THUMB: Int = 4001
    private(set) var TIME_FORMAT: Int = 0
    private(set) var TIME_LAPSE_RECORDING: Int = 9201
    private(set) var TIME_ZONE: Int = 9411
    private(set) var TRIGGER_RAW_ENCODE: Int = 2017
    private(set) var TV_FORMAT: Int = 3009
    private(set) var VIDEO_STORAGE: Int = 0
    private(set) var VOICE_CONTROL: Int = 9453
    private(set) var VOICE_CONTROL_INFO: Int = 9228
    private(set) var VOICE_NOTIFICATION: Int = 0
    private(set) var VOICE_NOTIFICATION_VOLUME: Int = 8053
    private(set) var WIFI_CHANNEL: Int = 0
    private(set) var WIFI_NAME: Int = 3003
    private(set) var WIFI_PWD: Int = 3004
    private(set) var WIFI_STATION_CONFIGURATION: Int = 3032
    
    public static let `default` = Command()

    public init(for firmware: ViofoFirmware) {
        self.currentFirmware = firmware
        
        switch firmware.device {
        case .unknown:
            break
            
        case .a119, .a119Mini, .a119Mini2:
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
            
            if firmware.model.lowercased().contains("ir") {
                self.IR_LED = 9218
            }
            
            if firmware.versionNumber >= 2.1 {
                self.BLUETOOTH_MIC_BUTTON = 9465
                self.BLUETOOTH_ACTION_BUTTON = 9466
            }
      
        case .a129, .a129IR, .a129Plus, .a129PlusAR, .a129Pro, .a129ProIR, .a129ProPDRM, .a129ProW:
            self.RESTART_CAMERA = 9423
            self.IMAGE_ROTATE = 9413
            self.BEEP_SOUND = 9403
            
            if firmware.device == .a129 {
                if firmware.versionNumber >= 2.5 {
                    self.BLUETOOTH_MIC_BUTTON = 9465
                    self.BLUETOOTH_ACTION_BUTTON = 9466
                }
            }
            
            if firmware.device == .a129Plus {
                self.ENTER_PARKING_MODE_TIMER = 9435
                self.HDR_TIME = 2027
                self.HDR_TIME_GET = 2028
                
                if firmware.versionNumber >= 1.9 {
                    self.MOVIE_WDR = 2026
                }
                
                if firmware.model.lowercased().contains("ir") {
                    self.IR_LED = self.IR_CAMERA_COLOR
                }
                
                if firmware.versionNumber >= 2.0 {
                    self.BLUETOOTH_MIC_BUTTON = 9465
                    self.BLUETOOTH_ACTION_BUTTON = 9466
                }
            }
            
            if firmware.device == .a129Pro {
                self.ENTER_PARKING_MODE_TIMER = 9435
                
                if firmware.versionNumber >= 2.9 {
                    self.BLUETOOTH_MIC_BUTTON = 9465
                    self.BLUETOOTH_ACTION_BUTTON = 9466
                }
            }
            
            if firmware.device == .a129ProPDRM {
                self.IMAGE_ROTATE = 0
                self.MOTION_DET = 0
                self.MOVIE_DATE_PRINT = 0
                self.GPS = 0
            }
            
            if firmware.device == .a129ProIR {
                self.IR_LED = self.IR_CAMERA_COLOR
            }
            
        case .a139, .a139Pro:
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
            
            if firmware.versionNumber >= 1.5 && firmware.device == .a139 {
                self.PARKING_RECORDING_GEOFENCING = 8234
            }
            
            if firmware.versionNumber >= 1.9 && firmware.device == .a139 {
                self.BLUETOOTH_MIC_BUTTON = 9313
                self.BLUETOOTH_ACTION_BUTTON = 9314
            }
            
            if firmware.device == .a139Pro {
                if firmware.versionNumber >= 1.2 {
                    self.BLUETOOTH_MIC_BUTTON = 9313
                    self.BLUETOOTH_ACTION_BUTTON = 9314
                }
            }

        case .a229, .a229Plus, .a229S, .a229U:
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
            
            if self.isDevice("A229") || self.isDevice("A229P") || self.isDevice("A229S") || self.isDevice("A229U") {
                self.LENSES_NUMBER = 8260
                
                if firmware.versionNumber >= 1.3 || self.isDevice("A229U") {
                    self.PARKING_HDR = 9320
                    self.TIME_FORMAT = 9321
                    self.FRONT_CAMERA_HDR = 9318
                    self.REAR_CAMERA_HDR = 9319
                    self.INTERIOR_CAMERA = 9322
                    self.DAYLIGHT_SAVING = 9323
                }
            }
            
            if ((self.isDevice("A229P") || self.isDevice("A229S")) && firmware.versionNumber >= 1.2) || self.isDevice("A229U") {
                self.FORMAT_REMINDER = 9312
                self.HDR_STAMP = 9311
                self.PARKING_GPS = 9225
            }
            
            if (self.isDevice("A229") && firmware.versionNumber >= 1.2) || self.isDevice("A229U") || ((self.isDevice("A229P") || self.isDevice("A229S")) && firmware.versionNumber >= 1.3) {
                self.BLUETOOTH_MIC_BUTTON = 9313
                self.BLUETOOTH_ACTION_BUTTON = 9314
            }

        case .a329, .a329S, .a329T:
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
            self.NORMAL_LED_CONTROL_FRONT = 9224
            self.NORMAL_LED_CONTROL_FRONT_TELE = 9336
            self.NORMAL_LED_CONTROL_REAL = 9329
            self.PARK_LED_CONTROL_FRONT = 9226
            self.PARK_LED_CONTROL_FRONT_TELE = 9338
            self.PARK_LED_CONTROL_REAL = 9337
            self.VOICE_CONTROL = 9227
            self.SCREEN_SAVER = 8250
            
            if self.isDevice("A329S") || self.isDevice("A329T") {
                self.INTERIOR_CAMERA = 9322
            }
        }
    }
    
    private init() {
        // VIOFO_A329T_V1.2_250708
        self.currentFirmware = .init(vendor: "VIOFO",
                                     model: "A119",
                                     device: .a119,
                                     version: "1.2",
                                     versionNumber: 1.2,
                                     buildDate: Date(timeIntervalSince1970: 1751851200),
                                     firmware: "VIOFO_A329T_V1.2_250708")
    }
    
    private func isDevice(_ firmwareName: String) -> Bool {
        return currentFirmware.model.hasPrefix(firmwareName)
    }
}

extension Command: CommandIndexProvider {}
