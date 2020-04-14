//
//  NearMe.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum PlacesUpdateType:String {
    case Realtime = "Realtime";
    case SingleTime = "Single Update";
}

final class NearMeViewModel {
    
    // MARK: - Properties
    
    var currentPlacesUpdateType = Variable(PlacesUpdateType.Realtime)
    var placesUpdateSubject: PublishSubject<[Place]> = PublishSubject()
    var placesNotFoundSubject: PublishSubject<Bool> = PublishSubject()
    var errorSubject: BehaviorSubject<CustomError?> = BehaviorSubject(value: nil)

    private var disposeBag = DisposeBag()
    private var locationManager: LocationManager!
    private let LocationError =
        CustomError(code: "0X0", message: "Please check the location permission")
    
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        
        // Subscrib on location mode change to update the location manager
        currentPlacesUpdateType.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] (type) in
            switch self.currentPlacesUpdateType.value {
            case .Realtime:
                self.locationManager.updateMeWhenLocationChange(self)
            case .SingleTime:
                self.locationManager.getMyCurrentLocation(self)
            }
        }).disposed(by: disposeBag)
    }
    
    func fetchPlacesForNewLocation( long:Double, lat:Double) {
        let apiParams = FourSquarRequestParamters(long: long, lat: lat)
        let api = FoursquareApi(params: apiParams)
        
        // Fetch and notify table with plain info about places
        let places = api.fetchNearLocations().share()
        places.toArray().subscribe(onSuccess: { (places) in
            self.placesUpdateSubject.onNext(places)
        }) { (error) in
            self.errorSubject.onNext(CustomError.getError(error: error))
        }.disposed(by: disposeBag)
        
        
        let images = places.map({
            $0.id
        }).flatMap({
            FoursquareApi(params: PlaceImageRequestParamters(id: $0 ?? "")).fetchImage().catchError { (error) in
                print(error.message)
                return Observable.just("")
            }
            }).share()
        
        let allPlaces = Observable<Place>.zip(images, places, resultSelector: { (image, place) in
            let placeCopy = place.getCopy()
            placeCopy.imageUrl = image
            return placeCopy
            }).toArray()
        
        allPlaces.subscribe(onSuccess: { [unowned self] (places) in
            self.placesUpdateSubject.onNext(places)
        }) { (error) in
            
            print(error)
        }.disposed(by: disposeBag)
//        placesUpdateSubject = allPlaces
       
//        let images = places.flatMap{ place in
//            let param = PlaceImageRequestParamters(id: id ?? "")
//            var imageUrl = ""
//            let api = FoursquareApi(params: param as RequestParamters)
//            return api.fetchImage()
//        }
        
//        let places = locations.map{$0.id}
        
//        locations.subscribe(onNext: { placesResponse in
//            let places = placesResponse.places
//        }, onError: { (error) in
//
//        }, onCompleted: {
//
//            }).disposed(by: disposeBag)
        
//        api.fetchNearLocations().get { [unowned self] placesResponse in
//            let allPlaces = placesResponse.places
//            self.fetchImagesForPlaces(places: allPlaces ?? [])
//            self.placesUpdateSubject.onNext(allPlaces ?? [])
//        }.catch { error in
//            self.errorSubject.onNext((error as! CustomError))
//        }
    }

}

extension NearMeViewModel: LocationDelegate {
    
    func userNewLocation(_ long: Double, _ lat: Double) {
        self.fetchPlacesForNewLocation(long: long, lat: lat)
    }
    
    func errorWhileRequestLocation(_ error: Error) {
        errorSubject.onNext(LocationError)
    }
}
