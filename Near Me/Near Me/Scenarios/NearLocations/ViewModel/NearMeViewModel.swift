//
//  NearMe.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

enum PlacesUpdateType: String {
    case Realtime
    case SingleTime = "Single Update"
}

final class NearMeViewModel {
    // MARK: - Properties

    var currentPlacesUpdateType = Variable(NearMeUserDefaults.getCurrentUpdateMode())
    var placesUpdateSubject: PublishSubject<[Place]> = PublishSubject()
    var loadingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    var placesNotFoundSubject: PublishSubject<Bool> = PublishSubject()
    var errorSubject: BehaviorSubject<CustomError?> = BehaviorSubject(value: nil)

    private var disposeBag = DisposeBag()
    private var locationManager: LocationManager!
    private let LocationError =
        CustomError(code: "0X0", message: "Please check the location permission")

    init(locationManager: LocationManager) {
        self.locationManager = locationManager

        // Subscrib on location mode change to update the location manager
        currentPlacesUpdateType.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] _ in
            NearMeUserDefaults.setCurrentUpdateMode(self.currentPlacesUpdateType.value)
            switch self.currentPlacesUpdateType.value {
            case .Realtime:
                self.locationManager.updateMeWhenLocationChange(self)

            case .SingleTime:
                self.locationManager.getMyCurrentLocation(self)
            }
        }).disposed(by: disposeBag)
    }

    func fetchPlacesForNewLocation(long: Double, lat: Double) {
        loadingSubject.onNext(true)
        let apiParams = FourSquarRequestParamters(long: long, lat: lat)
        let api = FoursquareApi(params: apiParams)

        // Fetch and notify table with plain info about places
        let places = api.fetchNearLocations().share()
        places.toArray().subscribe(onSuccess: { [unowned self] places in
            self.placesUpdateSubject.onNext(places)
            self.loadingSubject.onNext(false)
        }) { error in
            self.errorSubject.onNext(CustomError.getError(error: error))
            self.loadingSubject.onNext(false)
        }.disposed(by: disposeBag)

        fetchPlacesImages(places: places)
    }

    private func fetchPlacesImages(places: Observable<Place>) {
        // Download images for each place
        let images = places.map {
            $0.id
        }.flatMap {
            FoursquareApi(params: PlaceImageRequestParamters(id: $0 ?? "")).fetchImage().catchError { error in
                print(error.message)
                return Observable.just("")
            }
        }.share()

        // Merge images with places
        let allPlaces = Observable<Place>.zip(images, places, resultSelector: { image, place in
            let placeCopy = place.getCopy()
            placeCopy.imageUrl = image
            return placeCopy
        }).toArray()

        allPlaces.subscribe(onSuccess: { [unowned self] places in
            self.placesUpdateSubject.onNext(places)
        }) { error in
            print(error)
        }.disposed(by: disposeBag)
    }
}

extension NearMeViewModel: LocationDelegate {
    func userNewLocation(_ long: Double, _ lat: Double) {
        fetchPlacesForNewLocation(long: long, lat: lat)
    }

    func errorWhileRequestLocation(_: Error) {
        errorSubject.onNext(LocationError)
    }
}
