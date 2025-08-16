//
//  Command_A229.swift
//  Viofo
//
//  Created by Brandon on 2025-08-10.
//

import CommandMacros

@GenerateCommandIndex
class Command_A229: Command_A139 {
    override class var BLUETOOTH_ACTION_BUTTON: Int { 9314 }
    override class var BLUETOOTH_MIC_BUTTON: Int { 9313 }
    override class var DAYLIGHT_SAVING: Int { 9323 }
    class var FIRMWARE_NAME: String { "VIOFO_A229" }
    class var FIRMWARE_NAME_JP: String { "VIOFO_A229_JP" }
    class var FIRMWARE_NAME_P: String { "VIOFO_A229P" }
    class var FIRMWARE_NAME_S: String { "VIOFO_A229S" }
    class var FIRMWARE_NAME_U: String { "VIOFO_A229U" }
    class var FIRMWARE_URL_P: String { "https://www.viofo.com/download/firmware/A229Pro/filedesc.xml" }
    class var FIRMWARE_URL_S: String { "https://www.viofo.com/download/firmware/A229Plus/filedesc.xml" }
    override class var FORMAT_REMINDER: Int { 9312 }
    override class var FRONT_CAMERA_HDR: Int { 9318 }
    override class var HDR_STAMP: Int { 9311 }
    override class var INTERIOR_CAMERA: Int { 9322 }
    override class var INTERIOR_CAMERA_HDR: Int { 9333 }
    override class var INTERIOR_CAMERA_MIRROR: Int { 9220 }
    override class var INTERIOR_IMAGE_ROTATE: Int { 8226 }
    override class var LENSES_NUMBER: Int { 8260 }
    override class var MOVIE_BITRATE: Int { 8200 }
    override class var PARKING_GPS: Int { 9225 }
    override class var PARKING_HDR: Int { 9320 }
    override class var REAR_CAMERA_HDR: Int { 9319 }
    override class var REAR_CAMERA_MIRROR: Int { 9219 }
    override class var REAR_IMAGE_ROTATE: Int { 8225 }
    override class var TIME_FORMAT: Int { 9321 }
    override class var WIFI_CHANNEL: Int { 8201 }
    override class var LIVE_VIDEO_SOURCE: Int { 8202 }
    override class var IR_LED: Int { 8203 }
    override class var PARKING_G_SENSOR: Int { 8204 }
    override class var PARKING_MODE: Int { 8205 }
    override class var TIME_LAPSE_RECORDING: Int { 8206 }
    override class var PARKING_MOTION_DETECTION: Int { 8207 }
    override class var GPS: Int { 8208 }
    override class var GPS_INFO_STAMP: Int { 8210 }
    override class var SPEED_UNIT: Int { 8209 }
    override class var DATE_FORMAT: Int { 8211 }
    override class var TIME_ZONE: Int { 8212 }
    override class var CAMERA_MODEL_STAMP: Int { 8213 }
    override class var BEEP_SOUND: Int { 8214 }
    override class var FREQUENCY: Int { 8215 }
    override class var CAR_NUMBER: Int { 8218 }
    override class var CUSTOM_TEXT_STAMP: Int { 8219 }
    override class var MOVIE_EXPOSURE: Int { 8220 }
    override class var MOVIE_EV_INTERIOR: Int { 8220 }
    override class var MOVIE_EV_REAR: Int { 8220 }
    override class var MICROPHONE: Int { 8221 }
    override class var MOVIE_RESOLUTION: Int { 8222 }
    override class var BOOT_DELAY: Int { 8223 }
    override class var FRONT_IMAGE_ROTATE: Int { 8224 }
    override class var GET_CAR_NUMBER: Int { 8228 }
    override class var GET_CUSTOM_STAMP: Int { 8229 }
    override class var RESTART_CAMERA: Int { 8230 }
    override class var MOTION_DET: Int { 0 }
    override class var PARKING_RECORDING_TIMER: Int { 8232 }
    override class var ENTER_PARKING_MODE_TIMER: Int { 8233 }
    override class var VOICE_NOTIFICATION: Int { 9221 }
    override class var WIFI_STATION_CONFIGURATION: Int { 3032 }
    override class var PARKING_RECORDING_GEOFENCING: Int { 8234 }
    override class var SCREEN_SAVER: Int { 8250 }
    override class var VOICE_CONTROL: Int { 9227 }
}
