//
//  CameraError.swift
//  Viofo
//
//  Created by Brandon on 2025-08-10.
//

public enum ErrorStatus: Int {
    case cmdNotFound = 0
    case `default` = 1
    case parErr = -21
    case fwOffset = 2
    case fwInvalidStg = 3
    case fwReadErr = 4
    case fwReadChkErr = 5
    case fwWriteErr = 6
    case fwRead2Err = 7
    case fwWriteChkErr = 8
    case fail = 9
    case folderFull = 10
    case storageFull = 11
    case batteryLow = 12
    case movieSlow = 13
    case movieWrError = 14
    case movieFull = 15
    case deleteFailed = 17
    case fileError = 18
    case fileLocked = 19
    case noBuff = 20
    case exifErr = 21
    case noFile = 22
    case ok = 23
    case recordStarted = 24
    case recordStopped = 25
    case disconnect = 26
    case micOn = 27
    case micOff = 28
    case powerOff = 29
    case removeByUser = 30
    case sensorNumChanged = 31
    case cardInsert = 32
    case cardRemove = 33
    case rearCameraInserted = 16
    case rearCameraRemoved = 34
}
