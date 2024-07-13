//
//  CustomLogger.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 12.07.2024.
//

import CocoaLumberjack
import Foundation

final class CustomLogger {
    static func setup () {
        DDLog.add(DDOSLogger.sharedInstance)

        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
}
