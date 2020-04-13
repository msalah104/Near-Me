//
//  Requestable.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import Alamofire
import CodableAlamofire

protocol Requestable: URLRequestConvertible {
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var header: [String: String]? { get }
    var queryParamters: String? { get }
    var baseUrl: URL { get }
    var parameters: Parameters? { get }
    var timeoutIntervalForRequest: TimeInterval { get }

    @discardableResult
    func request<T: Codable>(requestID: String, with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest

    @discardableResult
    func request<T: Codable>(requestID: String, with responseArray: @escaping (DataResponse<[T]>) -> Void) -> DataRequest

    @discardableResult
    func request<T: Any>(requestID: String, with responseDictionryObject: @escaping (DataResponse<T>) -> Void) -> DataRequest
}

extension Requestable {
    // method is post by default
    var method: Alamofire.HTTPMethod {
        return .post
    }

    // just to add nil as default parameter
    var parameters: Parameters? {
        return nil
    }

    var queryParamters: String? {
        return nil
    }

    var header: [String: String]? {
        return nil
    }

    // default timeoutIntervalForRequest
    var timeoutIntervalForRequest: TimeInterval {
        return 30.0
    }

    @discardableResult
    func request<T: Codable>(requestID: String, with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self, requestID: requestID).responseDecodableObject(completionHandler: responseObject).validateErrors()
    }

    @discardableResult
    func request<T: Codable>(requestID: String, with responseArray: @escaping (DataResponse<[T]>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self, requestID: requestID).responseDecodableObject(completionHandler: responseArray).validateErrors()
    }

    @discardableResult
    func request<T: Any>(requestID: String, with responseDictionry: @escaping (DataResponse<T>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self, requestID: requestID).responseJSON(completionHandler: responseDictionry as! (DataResponse<Any>) -> Void).validateErrors()
    }

    func asURLRequest() throws -> URLRequest {
        // update timeoutIntervalForRequest from router
        ServiceManager.shared.manager.session.configuration.timeoutIntervalForRequest = timeoutIntervalForRequest

        var url = baseUrl

        if !path.isEmpty {
            url = url.appendingPathComponent(path)
        }

        if let extraParams = queryParamters {
            url = url.appendingPathComponent(extraParams)
        }

        // get ApiKey

        var urlRequest = try URLRequest(url: url, method: method)

        if header != nil {
            for (key, value) in header! {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

//        if let token = UserConfiguration.current.user.getToken() {
//            urlRequest.addValue(token, forHTTPHeaderField: ServerKeys.userToken)
//        }

//        urlRequest.addValue(ServerKeys.contentValue, forHTTPHeaderField: ServerKeys.content)
        print("\(url.absoluteString)")

        switch method {
        case .get:
            var urlRequest = try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.replacingOccurrences(of: "%2C", with: ","))!)
            return urlRequest
        default:
            var urlRequest = try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
            urlRequest.url = URL(string: (urlRequest.url?.absoluteString.replacingOccurrences(of: "%2C", with: ","))!)
            return urlRequest
        }
    }

    fileprivate func asURLRequest() -> String {
        var url = baseUrl

        if !path.isEmpty {
            url = url.appendingPathComponent(path)
        }

        return url.absoluteString
    }
}
