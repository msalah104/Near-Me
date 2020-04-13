//
//  ItunesApi.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import Alamofire
import PromiseKit
import UIKit

//class ItunesApi: Api {
//    enum APIRouter: Requestable {
//        case getProducts(ItunesApi)
//
//        var path: String {
//            switch self {
//            case .getProducts:
//                return "/search"
//            }
//        }
//
//        var baseUrl: URL {
//            return Configurations.rootUrl
//        }
//
//        var method: HTTPMethod {
//            switch self {
//            case .getProducts:
//                return .get
//            }
//        }
//
//        var parameters: Parameters? {
//            switch self {
//            case let .getProducts(api):
//                return api.params?.getParamsAsJson()
//            }
//        }
//    }
//}
//
//extension ItunesApi {
//    func getProducts() -> Promise<ProductResponse> {
//        return fireRequestWithSingleResponse(requestable: APIRouter.getProducts(self))
//    }
//}
