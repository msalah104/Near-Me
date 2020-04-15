//
//  ItunesApi.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import Alamofire
import PromiseKit
import RxSwift
import UIKit

class FoursquareApi: Api {
    init(params: RequestParamters) {
        super.init()
        self.params = params
    }

    enum APIRouter: Requestable {
        case fetchNearLocations(FoursquareApi)
        case fetchImage(FoursquareApi)

        var path: String {
            switch self {
            case .fetchNearLocations:
                return "explore"
            case let .fetchImage(api):
                return (api.params as! PlaceImageRequestParamters).id ?? ""
            }
        }

        var queryParamters: String? {
            switch self {
            case .fetchNearLocations:
                return nil
            case .fetchImage:
                return "photos"
            }
        }

        var baseUrl: URL {
            return Configurations.BaseUrl
        }

        var method: HTTPMethod {
            switch self {
            case .fetchNearLocations, .fetchImage:
                return .get
            }
        }

        var parameters: Parameters? {
            switch self {
            case let .fetchNearLocations(api), let .fetchImage(api):
                return api.params?.getParamsAsJson()
            }
        }
    }
}

extension FoursquareApi {
    func fetchNearLocations() -> Observable<Place> {
        return Observable.create { observable in
            let callBack: Promise<PlacesResponse> = self.fireRequestWithSingleResponse(requestable: APIRouter.fetchNearLocations(self))

            callBack.get { respose in
                if let places = respose.places {
                    for place in places {
                        observable.onNext(place)
                    }
                }
                observable.onCompleted()
            }.catch { error in
                observable.onError(error)
            }
            return Disposables.create()
        }
    }

    func fetchImage() -> Observable<String> {
        return Observable.create { observable in
            let callBack: Promise<PlaceImageResponse> = self.fireRequestWithSingleResponse(requestable: APIRouter.fetchImage(self))

            callBack.get { respose in
                if let image = respose.image {
                    observable.onNext(image.imageUrl)
                }
                observable.onCompleted()
            }.catch { error in
                observable.onError(error)
            }
            return Disposables.create()
        }
    }
}
