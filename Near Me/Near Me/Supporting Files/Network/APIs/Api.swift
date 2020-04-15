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
import RxSwift
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
}
