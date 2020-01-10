//
//  ViewController.swift
//  MartAPIMockup
//
//  Created by zella.ddo on 2019/12/31.
//  Copyright © 2019 zella.ddo. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func fetchBranches(_ sender: Any) {
    
        let url = URL(string: "http://ec2-52-78-180-121.ap-northeast-2.compute.amazonaws.com/api/marts/types/costco")
        
        let result = DataSetter.request(Branches.self, url: url!)
        
        result.subscribe(
            onNext: { branches in
                let names = branches.data.map { $0.branchName }
                
                DispatchQueue.main.async {
                    self.presentAlert(title: "성공🔥", body: names.joined(separator: ","))
                }
            },
            onError: { (error) in
                DispatchQueue.main.async {
                    self.presentAlert(title: "실패🔥", body: error.localizedDescription)
                }
            }
        ).disposed(by: disposeBag)
    }
    
}

extension ViewController {
    
    private func presentAlert(title: String, body: String?) {
        
        let alert = UIAlertController(title: title,
                                      message: body,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
