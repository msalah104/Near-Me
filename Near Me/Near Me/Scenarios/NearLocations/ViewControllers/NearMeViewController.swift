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

final class NearMeViewController: UIViewController, NearMeStoryboardLodable {

    //MARK: - Outlets
    @IBOutlet weak var errorContainerView: UIView!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeModeButton: UIBarButtonItem!
    
    //MARK: - Properties
    
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
    }
    
    func setupDataBinding() {
        viewModel.currentPlacesUpdateType.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] (type) in
            self.changeModeButton.title = type.rawValue
            }).disposed(by: disposeBag)
        
        viewModel.placesUpdateSubject.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] (places) in
            
        }).disposed(by: disposeBag)
        
        viewModel.placesUpdateSubject.bind(to: tableView.rx.items(cellIdentifier: PlaceTableViewCell.identifier, cellType: PlaceTableViewCell.self)) {
            [unowned self] _, place, cell in
        }.disposed(by: disposeBag)
        
        viewModel.placesNotFoundSubject.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self]  _ in
            
        }).disposed(by: disposeBag)
        
        viewModel.errorSubject.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self]  (error) in
            
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
