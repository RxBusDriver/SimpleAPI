//
//  ReusableView.swift
//  RxList
//
//  Created by 이동건 on 2020/01/10.
//  Copyright © 2020 이동건. All rights reserved.
//

import UIKit

protocol ReusableView {
    static var reusableIdentifier: String { get }
}

extension UITableViewCell: ReusableView {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
