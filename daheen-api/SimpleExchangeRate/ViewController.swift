//
//  ViewController.swift
//  SimpleExchangeRate
//
//  Created by Daheen Lee on 2020/01/02.
//  Copyright © 2020 allwhite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let service = NetworkService()
        service.getRates(for: .USD).subscribe { (event) in
            print(event)
        }
    }


}

