// ----------------------------------------------------------------------------
//
//  LogClient.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2017, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import Foundation

// ----------------------------------------------------------------------------

class LogClient
{
// MARK: - Construction

    // ...

// MARK: - Properties

    // ...

// MARK: - Functions

    func request(method: String, path: String, baseUrl: URL, parameters params: [AnyHashable: Any]?) -> URLRequest {
        assert((method == "POST") || (method == "GET"), "Invalid parameters")

        var endpoint: URL? = baseUrl.appendingPathComponent(path)
        var request = URLRequest(url: endpoint!)
        request.httpMethod = method

        if let params = params {
            let contentType = "multipart/form-data; boundary=\(LogConstants.LogClientBoundary)"
            request.setValue(contentType, forHTTPHeaderField: "Content-type")
            var postBody = Data()

            for (key, value) in params {
                if let value = value as? String, let key = key as? String {
                    postBody.append(LogClient.dataWithPostValue(value: value, key: key, boundary: LogConstants.LogClientBoundary))
                }
            }

            postBody.append("--\(LogConstants.LogClientBoundary)--\r\n".data(using: .utf8) ?? Data())
            request.httpBody = postBody
        }

        return request
    }

    class func dataWithPostValue(value: String, key: String, boundary: String) -> Data {
        return dataWithPostValue(value: value.data(using: .utf8) ?? Data(), key: key, contentType: "text", boundary: boundary, filename: nil)
    }

    class func dataWithPostValue(value: Data, key: String, contentType: String, boundary: String, filename: String?) -> Data {
        var postBody = Data()
        postBody.append("--\(boundary)\r\n".data(using: .utf8) ?? Data())

        // There's certainly a better way to check if we are supposed to send binary data here.
        if let filename = filename, !filename.isEmpty {
            postBody.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".data(using: .utf8) ?? Data())
            postBody.append("Content-Type: \(contentType)\r\n".data(using: .utf8) ?? Data())
            postBody.append("Content-Transfer-Encoding: binary\r\n\r\n".data(using: .utf8) ?? Data())
        }
        else {
            postBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n".data(using: .utf8) ?? Data())
            postBody.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8) ?? Data())
        }
        postBody.append(value)
        postBody.append("\r\n".data(using: .utf8) ?? Data())

        return postBody
    }

// MARK: - Actions

    // ...

// MARK: - Private Functions

    // ...

// MARK: - Inner Types

    // ...

// MARK: - Constants

    // ...

// MARK: - Variables

    // ...

}

// ----------------------------------------------------------------------------
