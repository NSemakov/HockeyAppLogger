// ----------------------------------------------------------------------------
//
//  ReportModel.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public struct ReportModel
{
// MARK: - Construction

    init(filename: String, log: String?, description: String?) {
        self.filename = filename
        self.fullPath = URL(fileURLWithPath: LogHelper.default.reportsDir).appendingPathComponent(filename)
        self.log = log
        self.description = description
    }

// MARK: - Properties

    let filename: String

    // Path with file:/// in front of
    let fullPath: URL

    var log: String?

    var description: String?
}

// ----------------------------------------------------------------------------
