//
//  ViewController.swift
//  RxList
//
//  Created by 이동건 on 2020/01/10.
//  Copyright © 2020 이동건. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ListViewController: UIViewController {
    private let viewModel: ListViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewModel.fetchCityList().subscribe(onNext: { cities in
            cities.forEach {
                print("Country: \($0.country) City: \($0.city)")
            }
        }).disposed(by: disposeBag)
    }
}

