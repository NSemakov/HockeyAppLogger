// ----------------------------------------------------------------------------
//
//  LogModel.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
import ModernDesign
import SwiftCommons

// ----------------------------------------------------------------------------

public struct LogModel
{
// MARK: - Construction

    init(exception: NSException?, level: Logger.LogLevel, tag: String, message: String?) {
        self.callStack = Logger.description(level, tag, message, exception)
    }

    init(error: Error?, level: Logger.LogLevel, tag: String, message: String?) {
        self.callStack = Logger.description(level, tag, message, error)
    }

    init(error: NSError?, level: Logger.LogLevel, tag: String, message: String?) {
        self.callStack = Logger.description(level, tag, message, error)
    }

    init(level: Logger.LogLevel, tag: String, message: String?) {
        self.callStack = Logger.description(level, tag, message)
    }

// MARK: - Properties

    let packageInfo = Bundle.main.bundleIdentifier ?? "Unknown bundle identifier"
    
    let version = buildNumber() ?? 0

    let os = UIDevice.current.systemVersion

    let manufacturer = "Manufacturer: Apple Inc."

    let model = UIDevice.Model.deviceName ?? "Unknown model"

    let date = Date().format()

    let callStack: String

// MARK: - Functions

    // ...

// MARK: - Actions

    // ...

// MARK: - Private Functions

    private static func buildNumber() -> Int?
    {
        var result: Int?

        let info = Bundle.main.infoDictionary
        if let version = (info?[kCFBundleVersionKey as String] as? String),
            let buildNumber = Int(version)
        {
            result = buildNumber
        }

        return result
    }

// MARK: - Inner Types

    // ...

// MARK: - Constants

    // ...

// MARK: - Variables

    // ...

}

// ----------------------------------------------------------------------------
