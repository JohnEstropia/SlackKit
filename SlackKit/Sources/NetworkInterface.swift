//
// NetworkInterface.swift
//
// Copyright © 2016 Peter Zignego. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

internal struct NetworkInterface {
    
    private let apiUrl = "https://slack.com/api/"
    
    internal func request(_ endpoint: SlackAPIEndpoint, token: String, parameters: [String: AnyObject]?, successClosure: ([String: AnyObject])->Void, errorClosure: (SlackError)->Void) {
        var requestString = "\(apiUrl)\(endpoint.rawValue)?token=\(token)"
        if let params = parameters {
            requestString += requestStringFromParameters(params)
        }
        guard let url =  URL(string: requestString) else {
            errorClosure(SlackError.clientNetworkError)
            return
        }
        let request = URLRequest(url:url)
        URLSession.shared.dataTask(with: request) {
            (data, response, internalError) -> Void in
            self.handleResponse(data, response: response, internalError: internalError, successClosure: {(json) in
                successClosure(json)
            }, errorClosure: {(error) in
                errorClosure(error)
            })
        }.resume()
    }
    
    internal func uploadRequest(_ token: String, data: Data, parameters: [String: AnyObject]?, successClosure: ([String: AnyObject])->Void, errorClosure: (SlackError)->Void) {
        var requestString = "\(apiUrl)\(SlackAPIEndpoint.FilesUpload.rawValue)?token=\(token)"
        if let params = parameters {
            requestString = requestString + requestStringFromParameters(params)
        }
        guard let url =  URL(string: requestString) else {
            errorClosure(SlackError.clientNetworkError)
            return
        }
        let request = NSMutableURLRequest(url:url)
        request.httpMethod = "POST"
        let boundaryConstant = randomBoundary()
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        let boundaryStart = "--\(boundaryConstant)\r\n"
        let boundaryEnd = "--\(boundaryConstant)--\r\n"
        let contentDispositionString = "Content-Disposition: form-data; name=\"file\"; filename=\"\(parameters!["filename"])\"\r\n"
        let contentTypeString = "Content-Type: \(parameters!["filetype"])\r\n\r\n"

        let requestBodyData : NSMutableData = NSMutableData()
        requestBodyData.append(boundaryStart.data(using: String.Encoding.utf8)!)
        requestBodyData.append(contentDispositionString.data(using: String.Encoding.utf8)!)
        requestBodyData.append(contentTypeString.data(using: String.Encoding.utf8)!)
        requestBodyData.append(data)
        requestBodyData.append("\r\n".data(using: String.Encoding.utf8)!)
        requestBodyData.append(boundaryEnd.data(using: String.Encoding.utf8)!)
        
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBodyData as Data

        URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, internalError) -> Void in
            self.handleResponse(data, response: response, internalError: internalError, successClosure: {(json) in
                successClosure(json)
            }, errorClosure: {(error) in
                errorClosure(error)
            })
        }.resume()
    }
    
    private func handleResponse(_ data: Data?, response:URLResponse?, internalError:NSError?, successClosure: ([String: AnyObject])->Void, errorClosure: (SlackError)->Void) {
        guard let data = data, response = response as? HTTPURLResponse else {
            errorClosure(SlackError.clientNetworkError)
            return
        }
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                errorClosure(SlackError.clientJSONError)
                return
            }
            
            switch response.statusCode {
            case 200:
                if (json["ok"] as! Bool == true) {
                    successClosure(json)
                } else {
                    if let errorString = json["error"] as? String {
                        throw ErrorDispatcher.dispatch(errorString)
                    } else {
                        throw SlackError.unknownError
                    }
                }
            case 429:
                throw SlackError.tooManyRequests
            default:
                throw SlackError.clientNetworkError
            }
        } catch let error {
            if let slackError = error as? SlackError {
                errorClosure(slackError)
            } else {
                errorClosure(SlackError.unknownError)
            }
        }
    }
    
    private func randomBoundary() -> String {
        return String(format: "slackkit.boundary.%08x%08x", arc4random(), arc4random())
    }
    
    private func requestStringFromParameters(_ parameters: [String: AnyObject]) -> String {
        var requestString = ""
        for key in parameters.keys {
            if let value = parameters[key] as? String, encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) {
                requestString += "&\(key)=\(encodedValue)"
            } else if let value = parameters[key] as? Int {
                requestString += "&\(key)=\(value)"
            }
        }
        
        return requestString
    }
    
}
