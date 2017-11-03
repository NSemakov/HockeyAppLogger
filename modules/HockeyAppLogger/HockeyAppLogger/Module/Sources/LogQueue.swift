// ----------------------------------------------------------------------------
//
//  LogQueue.swift
//
//  @author     Denis Kolyasev <KolyasevDA@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
import SwiftCommons

// ----------------------------------------------------------------------------

public class LogQueue
{
// MARK: - Construction

    static let sharedQueue = LogQueue()

// MARK: - Methods

    public func enque(_ log: ReportModel) {
        self.logs.value.append(log)
    }

    public func dequeue() -> ReportModel? {
        return self.logs.value.first
    }

    public func itemsLeft() -> Int {
        return self.logs.value.count
    }

    public func remove(_ filename: String)
    {
        let index = self.logs.value.index { $0.filename == filename }
        if let index = index {
            self.logs.value.remove(at: index)
        }
    }

// MARK: - Variables

    private let logs = Atomic(Array<ReportModel>())
}

// ----------------------------------------------------------------------------
