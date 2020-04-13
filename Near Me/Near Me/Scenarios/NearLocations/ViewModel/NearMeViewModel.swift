//
//  NearMe.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit
import RxSwift

enum PlacesUpdateType:String {
    case Realtime = "Realtime";
    case SingleTime = "Single Update";
}

final class NearMeViewModel {
    
    // MARK: - Properties
    
    var currentPlacesUpdateType = Variable(PlacesUpdateType.Realtime)
    var placesUpdateSubject: PublishSubject<[PlacesUpdateType]> = PublishSubject()
    var placesNotFoundSubject: PublishSubject<Bool> = PublishSubject()
    var errorSubject: PublishSubject<CustomError> = PublishSubject()
    
    // MARK: - Fields

    private var disposeBag = DisposeBag()
    private var locationManager: LocationManager!
    
    
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

}

extension NearMeViewModel: LocationDelegate {
    
    func userNewCurrentLocation(_ long: Double, _ lat: Double) {
        
    }
    
    func errorWhileRequestLocation(_ error: Error) {
        let customError = CustomError(code: "0X0", message: error.localizedDescription)
        errorSubject.onNext(customError)
    }
}
