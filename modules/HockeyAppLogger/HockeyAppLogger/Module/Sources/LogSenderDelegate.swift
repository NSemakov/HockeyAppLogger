// ----------------------------------------------------------------------------
//
//  LogSenderDelegate.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public protocol LogSenderDelegate: class
{
// MARK: - Methods

    /// Invoked after sending crash reports succeeded.
    ///
    /// - Parameters:
    ///   - crashManager: The `LogSender` instance invoking this delegate.
    ///

    func crashManagerDidFinishSendingCrashReport(_ crashManager: LogSender)
}

// ----------------------------------------------------------------------------

