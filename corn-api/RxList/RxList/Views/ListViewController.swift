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
    private let tableView = UITableView()
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        fetch()
    }
    
    // MARK: - Configure Views
    private func configureViews() {
        configureBaseView()
        configureIndicatorView()
        configureCell()
        configureTableView()
    }
    
    private func configureBaseView() {
        title = "Cities"
        view.backgroundColor = .white
    }
    
    private func configureIndicatorView() {
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func configureCell() {
        tableView.register(UINib(nibName: CityCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: CityCell.reusableIdentifier)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - Fetch
    private func fetch() {
        viewModel.isLoading
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        viewModel.isLoading
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.fetchCityList()
            .bind(to: tableView.rx.items(cellIdentifier: CityCell.reusableIdentifier, cellType: CityCell.self)) { _, city, cell in
                cell.countryLabel.text = city.country
                cell.capitalLabel.text = city.city
        }.disposed(by: disposeBag)
    }
}

