//
//
//  Api.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//
import Alamofire
import PromiseKit
import UIKit

class Api: NSObject {
    var params: RequestParamters?
    var requestType: Requestable?
    var result = ""
    var requestsId = ""

    func getApiName() -> String {
        return ""
    }

    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.shared.beginBackgroundTask(expirationHandler: ({}))
    }

    func endBackgroundUpdateTask(taskID: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(taskID)
    }

    func cancel() {
        ServiceManager.shared.cancelRequestWithID(requestID: requestsId)
    }
}

extension Api {
    func fireRequestWithSingleResponse<T: Codable>(requestable: Requestable) -> Promise<T> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let taskId = beginBackgroundUpdateTask()
        return Promise<T> { seal in
            let completionHandler: (DataResponse<T>) -> Void = { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.endBackgroundUpdateTask(taskID: taskId)
                guard response.error == nil else {
                    if (response.error as? URLError) != nil {
                        // no internet connection
                        let errorN = CustomError(code: "00-000", message: "Sorry, Please check your internet connection")
                        seal.reject(errorN)
                        return
                    }
                    seal.reject(CustomError.getError(error: response.error!))
                    return
                }
                guard response.value != nil else {
                    _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                    seal.reject(CustomError.getError(error: response.error!))
                    return
                }
                seal.fulfill(response.result.value!)
            }

            requestable.request(requestID: requestsId, with: completionHandler)
        }
    }

    func fireRequestWithMultiResponse<T: Codable>(requestable: Requestable) -> Promise<[T]> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let taskId = beginBackgroundUpdateTask()
        return Promise<[T]> { seal in
            let completionHandler: (DataResponse<[T]>) -> Void = { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.endBackgroundUpdateTask(taskID: taskId)
                guard response.error == nil else {
                    if (response.error as? URLError) != nil {
                        // no internet connection
                        let errorN = CustomError(code: "00-000", message: "Sorry, Please check your internet connection")
                        seal.reject(errorN)
                        return
                    }
                    seal.reject(CustomError.getError(error: response.error!))
                    return
                }
                guard response.value != nil else {
                    _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                    seal.reject(CustomError.getError(error: response.error!))
                    return
                }
                seal.fulfill(response.result.value!)
            }

            requestable.request(requestID: requestsId, with: completionHandler)
        }
    }

    func fireRequestWithoutResponse(requestable: Requestable) -> Promise<Bool> {
        return Promise<Bool> { seal in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let taskId = beginBackgroundUpdateTask()
            let completionHandler: (DataResponse<Any>) -> Void = { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.endBackgroundUpdateTask(taskID: taskId)

                guard response.error == nil else {
                    if (response.error as? URLError) != nil {
                        // no internet connection
                        let errorN = CustomError(code: "00-000", message: "Sorry, Please check your internet connection")
                        seal.reject(errorN)
                        return
                    }
                    seal.reject(response.error!)
                    return
                }
                guard response.value != nil else {
                    _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                    seal.reject(response.error!)
                    return
                }

                if let result = response.result.value as? [String: Any] {
                    if let _ = result["errors"] {
                        let code = (result["status"] as! NSNumber).stringValue
                        let message = result["message"] as! String
                        let title = result["title"] as! String
                        let error = CustomError(code: code, message: message, title: title)
                        seal.reject(error)
                        return
                    }
                }

                seal.fulfill(true)
            }
            requestable.request(requestID: requestsId, with: completionHandler)
        }
    }

    func fireRequestWithCustomResponse(requestable: Requestable, complition: @escaping (([String: Any]?, CustomError?) -> Void)) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let taskId = beginBackgroundUpdateTask()

        let completionHandler: (DataResponse<Any>) -> Void = { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.endBackgroundUpdateTask(taskID: taskId)
            guard response.error == nil else {
                if (response.error as? URLError) != nil {
                    // no internet connection
                    let errorN = CustomError(code: "00-000", message: "Sorry, Please check your internet connection")
                    complition(nil, errorN)
                    return
                }

                complition(nil, CustomError.getError(error: response.error!))
                return
            }
            guard response.value != nil else {
                _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                complition(nil, response.error! as? CustomError)
                return
            }

            let result: [String: Any] = response.result.value as? [String: Any] ?? [:]

            if let _ = result["errors"] {
                let code = (result["status"] as! NSNumber).stringValue
                let message = result["message"] as! String
                let title = result["title"] as! String
                let error = CustomError(code: code, message: message, title: title)
                complition(nil, error)
                return
            }

            complition(result, nil)
        }
        requestable.request(requestID: requestsId, with: completionHandler)
    }
}
