//
//  Command.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import CommandMacros

@GenerateCommandIndex
class Command {
    class var AUTO_POWER_OFF: Int { 3007 }
    class var BASE_URL: String { "http://192.168.1.254" }
    class var BATTERY_CUT_OFF_TIME: Int { 8232 }
    class var BATTERY_CUT_OFF_VOLTAGE: Int { 9343 }
    class var BEEP_SOUND: Int { 9094 }
    class var BLANK_CHAR_REPLACE: String { "+" }
    class var BLANK_CHAR_REPLACE_2: String { "*" }
    class var BLUETOOTH_ACTION_BUTTON: Int { 0 }
    class var BLUETOOTH_MIC_BUTTON: Int { 0 }
    class var BOOT_DELAY: Int { 9424 }
    class var CAMERA_MODEL_STAMP: Int { 9216 }
    class var CAPTURE_SIZE: Int { 1002 }
    class var CARD_FREE_SPACE: Int { 3017 }
    class var CAR_NUMBER: Int { 9422 }
    class var CHANGE_MODE: Int { 3001 }
    class var CUSTOM_TEXT_STAMP: Int { 9417 }
    class var DATE_FORMAT: Int { 0 }
    class var DAYLIGHT_SAVING: Int { 0 }
    class var DEFAULT_IP: String { "192.168.1.254" }
    class var DEFAULT_PORT: Int { 3333 }
    class var DELETE_ALL_FILE: Int { 4004 }
    class var DELETE_ONE_FILE: Int { 4003 }
    class var DISABLE_REAR_CAMERA: Int { 8098 }
    class var ENTER_PARKING_MODE_TIMER: Int { 0 }
    class var FIRMWARE_VERSION: Int { 3012 }
    class var FONT_CAMERA_MIRROR: Int { 0 }
    class var FORMAT_MEMORY: Int { 3010 }
    class var FORMAT_REMINDER: Int { 0 }
    class var FREQUENCY: Int { 9406 }
    class var FRONT_CAMERA_HDR: Int { 0 }
    class var FRONT_IMAGE_ROTATE: Int { 0 }
    class var FS_UNKNOW_FORMAT: Int { 3025 }
    class var GET_BATTERY_LEVEL: Int { 3019 }
    class var GET_CARD_STATUS: Int { 3024 }
    class var GET_CAR_NUMBER: Int { 9426 }
    class var GET_CURRENT_STATE: Int { 3014 }
    class var GET_CUSTOM_STAMP: Int { 9427 }
    class var GET_FILE_LIST: Int { 3015 }
    class var GET_SENSOR_STATUS: Int { 9432 }
    class var GET_UPDATE_FW_PATH: Int { 3026 }
    class var GET_WIFI_SSID_PASSWORD: Int { 3029 }
    class var GPS: Int { 9410 }
    class var GPS_INFO_STAMP: Int { 9214 }
    class var HDMI_OSD: Int { 0 }
    class var HDR_STAMP: Int { 0 }
    class var HDR_TIME: Int { 8251 }
    class var HDR_TIME_GET: Int { 8252 }
    class var HEART_BEAT: Int { 3016 }
    class var IMAGE_ROTATE: Int { 9093 }
    class var INTERIOR_CAMERA: Int { 0 }
    class var INTERIOR_CAMERA_HDR: Int { 0 }
    class var INTERIOR_CAMERA_MIRROR: Int { 0 }
    class var INTERIOR_CAM_FISHEYE_MODE: Int { 9339 }
    class var INTERIOR_IMAGE_ROTATE: Int { 0 }
    class var IR_CAMERA_COLOR: Int { 9218 }
    class var IR_LED: Int { 0 }
    class var LANGUAGE: Int { 3008 }
    class var LENSES_NUMBER: Int { 8250 }
    class var LIVE_VIDEO_SOURCE: Int { 3028 }
    class var LIVE_VIEW_BITRATE: Int { 2014 }
    class var LIVE_VIEW_URL: Int { 2019 }
    class var LOGO_STAMP: Int { 9229 }
    class var MANAGE_SSD_STORAGE: Int { 0 }
    class var MICROPHONE: Int { 0 }
    class var MOTION_DET: Int { 2006 }
    class var MOVIE_AUDIO: Int { 2007 }
    class var MOVIE_AUTO_RECORDING: Int { 2012 }
    class var MOVIE_BITRATE: Int { 9212 }
    class var MOVIE_CYCLIC_REC: Int { 2003 }
    class var MOVIE_DATE_PRINT: Int { 2008 }
    class var MOVIE_EV_INTERIOR: Int { 0 }
    class var MOVIE_EV_REAR: Int { 9217 }
    class var MOVIE_EXPOSURE: Int { 2005 }
    class var MOVIE_GSENSOR_SENS: Int { 2011 }
    class var MOVIE_LIVE_VIEW_CONTROL: Int { 2015 }
    class var MOVIE_MAX_RECORD_TIME: Int { 2009 }
    class var MOVIE_RECORD: Int { 2001 }
    class var MOVIE_RECORDING_TIME: Int { 2016 }
    class var MOVIE_REC_BITRATE: Int { 2013 }
    class var MOVIE_RESOLUTION: Int { 2002 }
    class var MOVIE_WDR: Int { 2004 }
    class var MULTIPLEX_VIDEO: Int { 9342 }
    class var PARKING_FILES_STORAGE: Int { 9340 }
    class var PARKING_GPS: Int { 0 }
    class var PARKING_G_SENSOR: Int { 9220 }
    class var PARKING_HDR: Int { 0 }
    class var PARKING_MODE: Int { 9421 }
    class var PARKING_MOTION_DETECTION: Int { 9221 }
    class var PARKING_RECORDING_GEOFENCING: Int { 0 }
    class var PARKING_RECORDING_TIMER: Int { 9428 }
    class var PHOTO_AVAIL_NUM: Int { 1003 }
    class var PHOTO_CAPTURE: Int { 1001 }
    class var PRIVACY_MODE: Int { 9330 }
    class var REAR_CAMERA_HDR: Int { 0 }
    class var REAR_CAMERA_MIRROR: Int { 9219 }
    class var REAR_IMAGE_ROTATE: Int { 0 }
    class var RECONNECT_WIFI: Int { 3018 }
    class var REMOTE_CONTROL_FUNCTION: Int { 2020 }
    class var REMOVE_LAST_USER: Int { 3023 }
    class var RESET_SETTING: Int { 3011 }
    class var RESOLUTION_FRAMES: Int { 8076 }
    class var RESTART_CAMERA: Int { 9095 }
    class var SCREEN: Int { 4002 }
    class var SCREEN_SAVER: Int { 9405 }
    class var SET_DATE: Int { 3005 }
    class var SET_NETWORK_MODE: Int { 0 }
    class var SET_TIME: Int { 3006 }
    class var SPEED_UNIT: Int { 9412 }
    class var SSD_CARD: Int { 0 }
    class var STAMP_COLOR: Int { 9331 }
    class var STORAGE_TYPE: Int { 9434 }
    class var STREAM_MJPEG: String { "http://192.168.1.254:8192" }
    class var STREAM_VIDEO: String { "rtsp://192.168.1.254/xxx.mov" }
    class var THUMB: Int { 4001 }
    class var TIME_FORMAT: Int { 0 }
    class var TIME_LAPSE_RECORDING: Int { 9201 }
    class var TIME_ZONE: Int { 9411 }
    class var TRIGGER_RAW_ENCODE: Int { 2017 }
    class var TV_FORMAT: Int { 3009 }
    class var VIDEO_STORAGE: Int { 0 }
    class var VOICE_CONTROL: Int { 9453 }
    class var VOICE_NOTIFICATION: Int { 0 }
    class var VOICE_NOTIFICATION_VOLUME: Int { 8053 }
    class var WIFI_CHANNEL: Int { 0 }
    class var WIFI_NAME: Int { 3003 }
    class var WIFI_PWD: Int { 3004 }
    class var WIFI_STATION_CONFIGURATION: Int { 3032 }
}

extension Command: CommandIndexProvider {
    
}
