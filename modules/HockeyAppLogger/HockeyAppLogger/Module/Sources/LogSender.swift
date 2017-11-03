// ----------------------------------------------------------------------------
//
//  LogSender.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

public class LogSender
{
// MARK: - Construction

    init(appIdentifier: String, logClient: LogClient) {
        self.appIdentifier = appIdentifier
        self.logClient = logClient
    }

// MARK: - Properties

    var isInProcess: Bool = false

    weak var delegate: LogSenderDelegate?

// MARK: - Functions

    func sendReports() {
        // Prevent infinite loop
        if (LogQueue.sharedQueue.itemsLeft() > 0) {
            sendNextCrashReport()
        }
    }

// MARK: - Actions

    // ...

// MARK: - Private Functions

    /// Send all approved crash reports
    ///
    /// Gathers all collected data and constructs the XML structure and starts the sending process
    ///

    func sendNextCrashReport() {
        if LogQueue.sharedQueue.itemsLeft() == 0 {
            self.isInProcess = false
                delegate?.crashManagerDidFinishSendingCrashReport(self)
            return
        }
        self.isInProcess = true
        // we start sending always with the oldest pending one

        if let report = LogQueue.sharedQueue.dequeue() {
            var crashData: Data?
            if let log = report.log {
                crashData = log.data(using: String.Encoding.utf8)
            }
            else if let crashReport = try? String(contentsOf: report.fullPath, encoding: .utf8),
                report.filename.hasSuffix(crashReport.md5().substring(upto: LogConstants.NumberOfHashSymbols)) {
                crashData = crashReport.data(using: .utf8)
            }

            if let crashData = crashData, crashData.count > 0 {
                sendCrashReport(report: report, data: crashData)
            }
            else {
                // We cannot do anything with this report, so delete it
                cleanCrashReport(report: report)
            }
        }
        else {
            fatalError("Unexpected nil ReportModel from LogQueue")
        }
    }

    private func requestWithBoundary(boundary: String) -> URLRequest {
        let postCrashPath = "api/2/apps/\(appIdentifier)/crashes/upload"

        var request = logClient.request(method: "POST", path: postCrashPath, baseUrl: URL(string: "https://rink.hockeyapp.net/")!, parameters: nil)
        request.setValue("HockeySDK/iOS", forHTTPHeaderField: "User-Agent")
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-type")

        return request
    }

    /// Remove a cached crash report
    ///
    /// - Parameters:
    ///   - report: ReportModel for the crash report.
    ///

    private func cleanCrashReport(report: ReportModel) {
        if report.filename.isEmpty {
            return
        }

        try? fileManager.removeItem(at: report.fullPath)

        // Remove log from LogQueue
        LogQueue.sharedQueue.remove(report.filename)
    }

    /// Send the data to the server
    ///
    /// Wraps data into a POST body and starts sending the data asynchronously
    ///
    /// - Parameters:
    ///   - data: Data that needs to be send to the server.
    ///   - report: ReportModel for the crash report.
    ///

    private func sendCrashReport(report: ReportModel, data: Data) {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        let request: URLRequest? = requestWithBoundary(boundary: LogConstants.LogClientBoundary)
        let postBodyData: Data? = postBody(data, boundary: LogConstants.LogClientBoundary)

        weak var weakSelf = self
        let uploadTask: URLSessionUploadTask? = session.uploadTask(with: request!, from: postBodyData, completionHandler: {(_ responseData: Data?, _ response: URLResponse?, _ error: Error?) -> Void in
            guard let strongSelf = weakSelf else { return }
            session.finishTasksAndInvalidate()
            let httpResponse = response as? HTTPURLResponse
            let statusCode: Int? = httpResponse?.statusCode
            if error == nil {
                strongSelf.processUploadResult(report: report, responseData: responseData, statusCode: statusCode)
            }
        })
        uploadTask?.resume()
    }

    private func postBody(_ data: Data, boundary: String) -> Data {
        var postBody = Data()
        postBody.append("\r\n".data(using: .utf8) ?? Data())
        postBody.append(LogClient.dataWithPostValue(value: data, key: "log", contentType: "text/plain", boundary: boundary, filename: "crash.log"))
        postBody.append("\r\n--\(boundary)--\r\n".data(using: .utf8) ?? Data())
        return postBody
    }

    private func processUploadResult(report: ReportModel, responseData: Data?, statusCode: Int?) {
        var resultSuccess = false
        DispatchQueue.main.async(execute: {() -> Void in
            if let responseData = responseData, responseData.count != 0 {
                if let statusCode = statusCode {
                    if statusCode >= 200 && statusCode < 400 {
                        resultSuccess = true
                        self.cleanCrashReport(report: report)
                        // Only if sending the crash report went successfully, continue with the next one (if there are more)
                        self.sendNextCrashReport()
                    }
                }
            }

            if !resultSuccess {
                self.isInProcess = false
                self.cleanCrashReport(report: report)
            }
        })
    }

// MARK: - Inner Types

    // ...

// MARK: - Constants

    // ...

// MARK: - Variables

    private let fileManager = FileManager.default

    private let appIdentifier: String

    private let logClient: LogClient
}

// ----------------------------------------------------------------------------

