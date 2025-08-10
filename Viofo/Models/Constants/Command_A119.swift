//
//  Command_A119.swift
//  Viofo
//
//  Created by Brandon on 2025-08-10.
//

class Command_A119: Command {
    override class var BEEP_SOUND: Int { 9403 }
    override class var DATE_FORMAT: Int { 9416 }
    override class var ENTER_PARKING_MODE_TIMER: Int { 9435 }
    class var FIRMWARE_A119_MINI: String { "A119 Mini" }
    class var FIRMWARE_URL_A119MINI: String { "https://www.viofo.com/download/firmware/A119Mini/filedesc.xml" }
    override class var HDR_TIME: Int { 2027 }
    override class var HDR_TIME_GET: Int { 2028 }
    override class var IMAGE_ROTATE: Int { 9413 }
    override class var MOVIE_WDR: Int { 2026 }
    override class var RESTART_CAMERA: Int { 9423 }
    override class var VOICE_CONTROL: Int { 9453 }
    override class var VOICE_NOTIFICATION: Int { 9449 }
    override class var VOICE_NOTIFICATION_VOLUME: Int { 9447 }
    override class var WIFI_CHANNEL: Int { 9448 }
}
