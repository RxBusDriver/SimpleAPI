//
//  SearchViewController.swift
//  PracticeRxAPI
//
//  Created by BLICK on 2020/01/10.
//  Copyright © 2020 BLICK. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var shownCities = [String]()
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"]
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        searchBar.rx.text
            .orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
//            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged() //이전 값과 같은지 검사
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [unowned self] query in
                print("query: \(query)")
                self.shownCities = self.allCities.filter { $0.hasPrefix(query) }
                self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        return cell
    }
}

extension SearchViewController {
    static func instantiate() -> SearchViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        return viewController
    }
}
