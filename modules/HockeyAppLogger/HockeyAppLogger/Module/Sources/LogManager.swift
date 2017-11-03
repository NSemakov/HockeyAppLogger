// ----------------------------------------------------------------------------
//
//  LogManager.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation
import SwiftCommons

// ----------------------------------------------------------------------------

class LogManager
{
// MARK: - Construction

    static let sharedManager = LogManager()

    private init() {
        // Do nothing ...
    }

// MARK: - Properties

    // ...

// MARK: - Functions

    func startWithKey(key: String) {
        self.readLogsFromDisk()
        self.logSender = LogSender(appIdentifier: key, logClient: LogClient())
        self.logSender?.delegate = self
    }

    func stop() {
        // Do nothing
    }

    func add(_ log: LogModel) {
        weak var weakSelf = self
        Dispatch.asyncBackground {
            guard let instance = weakSelf else { return }

            let report = instance.writeToDisk(log)
            LogQueue.sharedQueue.enque(report)
            instance.sendIfNeeded()
        }
    }

// MARK: - Actions

    // ...

// MARK: - Private Functions

    private func sendIfNeeded() {
        if let logSender = self.logSender {
            if !logSender.isInProcess {
                if connectedToInternet() && !self.isWaiting {
                    logSender.sendReports()
                }
                else {
                    self.isWaiting = true
                    if self.timer == nil {
                        self.timer = Roxie.scheduledTimer(withTimeInterval: Inner.Delay, repeats: false, block: { [weak self] _ in
                            guard let instance = self else { return }

                            instance.timer?.invalidate()
                            instance.timer = nil

                            instance.isWaiting = false
                            instance.sendIfNeeded()
                        })
                    }
                }
            }
            else {
                // Do nothing. Waiting for delegate call to inform about operation finish
            }
        }
    }

    private func writeToDisk(_ log: LogModel) -> ReportModel {
        let packageInfo = Inner.Package + log.packageInfo
        let version = Inner.Version + String(log.version)
        let os = Inner.OS + String(log.os)
        let manufacturer = log.manufacturer
        let model = Inner.Model + log.model
        let date = Inner.DateTitle + log.date
        let callStack = log.callStack

        let crashReport = [packageInfo, version, os, manufacturer, model, date, callStack].joined(separator: "\n")

        var reportsDir = URL(fileURLWithPath: LogHelper.default.reportsDir, isDirectory: true)

        let filename = String(format: "%.0f", Date.timeIntervalSinceReferenceDate) + "_" + crashReport.md5().substring(upto: LogConstants.NumberOfHashSymbols)

        reportsDir.appendPathComponent(filename)
        try? crashReport.write(to: reportsDir, atomically: true, encoding: String.Encoding.utf8)

        return ReportModel(filename: filename, log: crashReport, description: nil)
    }

    private func connectedToInternet() -> Bool {
        let string = try? String(contentsOf: Inner.WebForCheckConnection)
        return string != nil
    }

    private func readLogsFromDisk() {
        let fileManager = FileManager.default

        let reportsDir = LogHelper.default.reportsDir
        if fileManager.fileExists(atPath: reportsDir),
            let dirArray = try? fileManager.contentsOfDirectory(atPath: reportsDir) {

            for file in dirArray {
                let filePath = URL(fileURLWithPath: reportsDir).appendingPathComponent(file).path

                if let fileAttributes = try? fileManager.attributesOfItem(atPath: filePath),
                    let type = fileAttributes[.type] as? FileAttributeType,
                    type == FileAttributeType.typeRegular,
                    let size = (fileAttributes[.size] ?? 0) as? Int,
                    size > 0,
                    !file.hasSuffix(".DS_Store"),
                    !file.hasSuffix(".analyzer"),
                    !file.hasSuffix(".plist"),
                    !file.hasSuffix(".data"),
                    !file.hasSuffix(".meta"),
                    !file.hasSuffix(".desc")
                {
                    let report = ReportModel(filename: file, log: nil, description: nil)
                    LogQueue.sharedQueue.enque(report)
                }
            }
        }

        Dispatch.asyncBackground {
            self.sendIfNeeded()
        }
    }

// MARK: - Inner Types

    // ...

// MARK: - Constants

    private struct Inner {
        static let WebForCheckConnection = URL(string: "http://www.appleiphonecell.com/")!
        static let Package = "Package: "
        static let Version = "Version: "
        static let OS = "OS: "
        static let Model = "Model: "
        static let DateTitle = "Date: "
        static let Delay = 3 * Date.Intervals.InSeconds.Minute // 3 minutes
    }

// MARK: - Variables

    private var isWaiting = false

    private var logSender: LogSender?

    private var timer: Timer?
}

// ----------------------------------------------------------------------------

extension LogManager: LogSenderDelegate {
// MARK: - Methods
    
    func crashManagerDidFinishSendingCrashReport(_ crashManager: LogSender) {
        Dispatch.asyncBackground {
            self.sendIfNeeded()
        }
    }
}

// ----------------------------------------------------------------------------
