//
//  Near_MeTests.swift
//  Near MeTests
//
//  Created by Mohammed Salah on 16/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//
@testable import Near_Me
import RxSwift
import Swinject
import XCTest

class NearMeTests: XCTestCase {
    let container = Container()
    let disposBag = DisposeBag()
    var viewModel: NearMeViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // services
        container.autoregister(LocationManager.self, initializer: LocationUpdater.init).inObjectScope(ObjectScope.container)

        // viewModel
        container.autoregister(NearMeViewModel.self, initializer: NearMeViewModel.init)
        viewModel = container.resolve(NearMeViewModel.self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNearMeViewModelUpdatePlacesSubject() throws {
        // Arrange
        var places: [Place]?
        viewModel?.placesUpdateSubject.observeOn(MainScheduler.instance).subscribe(onNext: { placesArray in
            places = placesArray
        }).disposed(by: disposBag)

        // Act
        viewModel?.placesUpdateSubject.onNext([])

        // Assert
        XCTAssertNotNil(places)
    }

    func testNearMeViewModelErrorSubject() throws {
        // Arrange
        var error: CustomError?
        viewModel?.errorSubject.observeOn(MainScheduler.instance).subscribe(onNext: { expectedError in
            error = expectedError
        }).disposed(by: disposBag)

        // Act
        viewModel?.errorSubject.onNext(CustomError(code: "", message: ""))

        // Assert
        XCTAssertNotNil(error)
    }

    func testNearMeViewModelLoadingSubject() throws {
        // Arrange
        let expectedValue: Bool = true
        var value = false
        viewModel?.loadingSubject.observeOn(MainScheduler.instance).subscribe(onNext: { isTrue in
            value = isTrue
        }).disposed(by: disposBag)

        // Act
        viewModel?.loadingSubject.onNext(expectedValue)

        // Assert
        XCTAssertEqual(value, expectedValue)
    }

    func testUpdateModeDefaultValue() throws {
        // Act
        let defaultValue = viewModel?.currentPlacesUpdateType.value

        // Assert
        XCTAssertEqual(defaultValue?.rawValue, PlacesUpdateType.Realtime.rawValue)
    }
}
