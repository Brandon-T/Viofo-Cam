//
//  Command_A129.swift
//  Viofo
//
//  Created by Brandon on 2025-08-10.
//

class Command_A129: Command {
    override class var BEEP_SOUND: Int { 9403 }
    override class var ENTER_PARKING_MODE_TIMER: Int { 9435 }
    class var FIRMWARE_A129: String { "A129" }
    class var FIRMWARE_A129_IR: String { "A129_IR" }
    class var FIRMWARE_A129_JP: String { "A129-JP." }
    class var FIRMWARE_A129_PLUS: String { "A129Plus" }
    class var FIRMWARE_A129_PLUS_AR: String { "A129Plus_AR_V" }
    class var FIRMWARE_A129_PLUS_JP: String { "A129Plus_JP" }
    class var FIRMWARE_A129_PRO: String { "A129Pro" }
    class var FIRMWARE_A129_PRO_IR: String { "A129Pro_IR" }
    class var FIRMWARE_A129_PRO_JP: String { "A129Pro-JP" }
    class var FIRMWARE_A129_PRO_PDRM: String { "PDRM" }
    class var FIRMWARE_A129_PRO_W: String { "A129Pro-W" }
    class var FIRMWARE_URL_A129: String { "https://www.viofo.com/download/firmware/A129/filedesc.xml" }
    class var FIRMWARE_URL_A129IR: String { "https://www.viofo.com/download/firmware/A129IR/filedesc.xml" }
    class var FIRMWARE_URL_A129PRO: String { "https://www.viofo.com/download/firmware/A129P/filedesc.xml" }
    class var FIRMWARE_URL_A129PRO_IR: String { "https://www.viofo.com/download/firmware/A129PIR/filedesc.xml" }
    override class var IMAGE_ROTATE: Int { 9413 }
    override class var RESTART_CAMERA: Int { 9423 }
}
