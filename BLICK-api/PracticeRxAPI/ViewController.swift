//
//  ViewController.swift
//  PracticeRxAPI
//
//  Created by BLICK on 2020/01/09.
//  Copyright © 2020 BLICK. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    var count = 0
    
    @IBOutlet weak var justButton: UIButton!
    @IBOutlet weak var justLabel: UILabel!
    @IBOutlet weak var presentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        justButton.rx.tap
            .map { _ in
                self.count += 1
                return "\(self.count)" }
            .bind(to: self.justLabel.rx.text)
            .disposed(by: disposeBag)
        
//        justButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.count += 1
//                self?.justLabel.text = String(self?.count ?? 0)
//                }, onError: { error in
//                    print("occured error", error)
//            }, onCompleted: {
//                print("completed")
//            }) {
//                print("disposed bag")
//        }.disposed(by: disposeBag)
        
        presentButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let viewController = SearchViewController.instantiate()
                self?.present(viewController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
}

