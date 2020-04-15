//
//  NearMeViewController.swift
//  Near Me
//
//  Created by Mohammed Salah on 12/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import AlamofireImage

final class NearMeViewController: BaseViewController, NearMeStoryboardLodable {

    //MARK: - Outlets
    @IBOutlet weak var errorContainerView: UIView!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeModeButton: UIBarButtonItem!
    
    //MARK: - Properties
    private let ErrorNotResultes = "No places found near you"
    private let NoLocationImage = UIImage(named: "noLocations")
    private let ErrorImage = UIImage(named: "error")
    private var disposeBag = DisposeBag()
    
    // ViewModel Will be injected by swinject
    var viewModel:NearMeViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataBinding()
    }
    
    func setupUI() {
        tableView.tableFooterView = UIView(frame: .zero)
        changeModeButton = self.navigationItem.rightBarButtonItem
        tableView.register(UINib(nibName: PlaceTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: PlaceTableViewCell.identifier)
        self.errorContainerView.isHidden = true
    }
    
    func setupDataBinding() {
        viewModel.currentPlacesUpdateType.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] (type) in
            self.changeModeButton.title = type.rawValue
            }).disposed(by: disposeBag)
        
        viewModel.placesUpdateSubject.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] (places) in
            self.errorContainerView.isHidden = true
        }).disposed(by: disposeBag)
        
        viewModel.placesUpdateSubject.bind(to: tableView.rx.items(cellIdentifier: PlaceTableViewCell.identifier, cellType: PlaceTableViewCell.self)) {
             _, place, cell in
            cell.placeTitleLabel.text = place.name
            cell.placeAddressLabel.text = place.address
            if let url = URL(string: place.imageUrl ?? "") {
                cell.placeImage.af_setImage(withURL: url)
            }
            
        }.disposed(by: disposeBag)
        
        viewModel.placesNotFoundSubject.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self]  _ in
            self.errorContainerView.isHidden = false
            self.errorLabel.text = self.ErrorNotResultes
            self.errorImage.image = self.NoLocationImage
        }).disposed(by: disposeBag)
        
        viewModel.errorSubject.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self]  (error) in
            if let er = error {
                self.errorContainerView.isHidden = false
                self.errorLabel.text = er.message
                self.errorImage.image = self.ErrorImage
            }
        }).disposed(by: disposeBag)
        
        viewModel.loadingSubject.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self]  isLoading in
            if isLoading {
                self.showDefaultLoader()
            } else {
                self.hideDefaultLoader()
            }
        }).disposed(by: disposeBag)
    }
    
    @objc @IBAction func didPressChangeMode(_ sender: UIBarButtonItem) {
        switch viewModel.currentPlacesUpdateType.value {
        case .Realtime:
            viewModel.currentPlacesUpdateType.value = .SingleTime
        case .SingleTime:
            viewModel.currentPlacesUpdateType.value = .Realtime
        }
    }
}
