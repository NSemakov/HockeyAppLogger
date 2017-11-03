// ----------------------------------------------------------------------------
//
//  LogHelper.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

class LogHelper
{
// MARK: - Construction

    static let `default` = LogHelper()

    private init() {
        self.reportsDir = LogHelper.roxieReportsDir()
    }

// MARK: - Properties

    let reportsDir: String

// MARK: - Functions

    // ...

// MARK: - Actions

    // ...

// MARK: - Private Functions

    private static func roxieReportsDir() -> String {
        let fileManager = FileManager()

        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)

        let reportsDir = URL(fileURLWithPath: paths[0]).appendingPathComponent(LogConstants.LogDirectory).path

        if !fileManager.fileExists(atPath: reportsDir) {
            try? fileManager.createDirectory(atPath: reportsDir, withIntermediateDirectories: true, attributes: nil)
        }

        return reportsDir
    }

// MARK: - Inner Types

    // ...

// MARK: - Constants

    // ...

// MARK: - Variables

    // ...

}

// ----------------------------------------------------------------------------
