//
//  PssLogger.swift
//  PssLogger
//
//  Created by 박수성 on 2022/12/04.
//

import Foundation
import CocoaLumberjack

public class PssLogger: NSObject {
    public static func setupLog() {
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.maximumFileSize = 1024 * 1024 * 10
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    public static func message(_ message: String) {
        DDLogDebug(message)
    }
}
