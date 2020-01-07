//
//  HomeViewController.swift
//  SimpleExchangeRate
//
//  Created by dana.allwhite on 2020/01/06.
//  Copyright © 2020 allwhite. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

protocol HomePresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
    
    weak var listener: HomePresentableListener?
    
    // MARK: - Instantiate ViewController
    
    static func instantiate() -> HomeViewController {
        let instance = instantiate(storyboardName: "Main", identifier: "HomeViewController") as! HomeViewController
        return instance
    }
    
    @IBOutlet weak var tableView: UITableView!
    let pickerView = UIPickerView()
    
    private let exchangeRateAPI = ExchangeRateAPI.shared
    private let allCurrencyCodes = CurrencyCode.allCases
    private let bag = DisposeBag()
    private let viewModel = HomeViewModel()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCurrencyPickerOnTitle()
        
        pickerView.rx.modelSelected(CurrencyCode.self)
            .map { (codes) -> CurrencyCode in
                return codes[0]
            }.bind(to: viewModel.baseCurrencySelected)
            .disposed(by: bag)
            
        
        viewModel.selectedCurrencyRates
            .drive(tableView.rx.items(cellIdentifier: "Cell")){ row, model, cell in
            cell.detailTextLabel?.text = model.rate
            cell.textLabel?.text = model.code
            
        }.disposed(by: bag)
        
        viewModel.lastUpdatedTime
            .drive(onNext: { (string) in
                self.navigationItem.prompt = string
            }).disposed(by: bag)
       
//       let result = exchangeRateAPI.getRates(for: .USD)
//           .map { result -> ResultData in
//               print(result)
//               guard case .success(let value) = result else {
//                    return ResultData.empty
//               }
//               return value
//           }
//
//        let rates = result.map { (data) -> [Rate] in
//            return data.rates ?? []
//        }.asDriver(onErrorJustReturn: [])
//
//       rates.drive(tableView.rx.items(cellIdentifier: "Cell")) { row, model, cell in
//            cell.detailTextLabel?.text = model.rate
//            cell.textLabel?.text = model.code
//
//       }.disposed(by: bag)
//
//        let title = result.map { (data) -> String in
//            guard let base = data.base else {
//                return ""
//            }
//            return base
//        }.asDriver(onErrorJustReturn: "")
//
//        title.drive(onNext: { (string) in
//            self.title = string
//            }).disposed(by: bag)
//
//        let prompt = result.map { (data) -> String in
//            guard let date = data.date else {
//                return ""
//            }
//            return date
//        }.asDriver(onErrorJustReturn: "")
//
//        prompt.drive(onNext: { (string) in
//            self.navigationItem.prompt = string
//        })
   }
    
    private func addCurrencyPickerOnTitle() {
        Observable.just(allCurrencyCodes)
        .bind(to: pickerView.rx.itemTitles) { _, code in
            return code.rawValue
        }
        .disposed(by: bag)
//        pickerView.frame = CGRect(x: 0, y: 0, width: 400, height: 80)
        self.navigationItem.titleView = pickerView
    }
}

