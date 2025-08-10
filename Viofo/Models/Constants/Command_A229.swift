//
//  Command_A229.swift
//  Viofo
//
//  Created by Brandon on 2025-08-10.
//

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
    override class var PARKING_GPS: Int { 9225 }
    override class var PARKING_HDR: Int { 9320 }
    override class var REAR_CAMERA_HDR: Int { 9319 }
    override class var REAR_CAMERA_MIRROR: Int { 9219 }
    override class var REAR_IMAGE_ROTATE: Int { 8225 }
    override class var TIME_FORMAT: Int { 9321 }
}
