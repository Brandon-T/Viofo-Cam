//
//  Command_A329.swift
//  Viofo
//
//  Created by Brandon on 2025-08-08.
//

import CommandMacros

@GenerateCommandIndex
class Command_A329: Command_A139 {
    override class var BLUETOOTH_ACTION_BUTTON: Int { 9314 }
    override class var BLUETOOTH_MIC_BUTTON: Int { 9313 }
    override class var DAYLIGHT_SAVING: Int { 9323 }
    class var FIRMWARE_NAME: String { "VIOFO_A329" }
    class var FIRMWARE_NAME_329S: String { "VIOFO_A329S" }
    class var FIRMWARE_NAME_329T: String { "VIOFO_A329T" }
    class var FIRMWARE_URL: String { "https://www.viofo.com/download/firmware/A339/filedesc.xml" }
    override class var FORMAT_REMINDER: Int { 9312 }
    override class var FRONT_CAMERA_HDR: Int { 9318 }
    override class var HDMI_OSD: Int { 9325 }
    override class var HDR_STAMP: Int { 9311 }
    override class var INTERIOR_CAMERA: Int { 9322 }
    override class var INTERIOR_CAMERA_HDR: Int { 9333 }
    override class var INTERIOR_CAMERA_MIRROR: Int { 9220 }
    override class var INTERIOR_IMAGE_ROTATE: Int { 8226 }
    override class var LENSES_NUMBER: Int { 8260 }
    override class var MANAGE_SSD_STORAGE: Int { 9316 }
    class var NORMAL_LED_CONTROL_FRONT: Int { 9224 }
    class var NORMAL_LED_CONTROL_FRONT_TELE: Int { 9336 }
    class var NORMAL_LED_CONTROL_REAL: Int { 9329 }
    override class var PARKING_GPS: Int { 9225 }
    override class var PARKING_HDR: Int { 9320 }
    class var PARK_LED_CONTROL_FRONT: Int { 9226 }
    class var PARK_LED_CONTROL_FRONT_TELE: Int { 9338 }
    class var PARK_LED_CONTROL_REAL: Int { 9337 }
    override class var REAR_CAMERA_HDR: Int { 9319 }
    override class var REAR_CAMERA_MIRROR: Int { 9219 }
    override class var REAR_IMAGE_ROTATE: Int { 8225 }
    override class var TIME_FORMAT: Int { 9321 }
    override class var VIDEO_STORAGE: Int { 9315 }
}
