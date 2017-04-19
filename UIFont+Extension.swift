//
//  UIFont+Extension.swift
//  Real News
//
//  Created by PC on 4/1/17.
//  Copyright © 2017 PC. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static var standard: UIFont  {
        get {
            return UIFont(name: "Brown-Light", size: 16)!
        }
    }
    static var detail:UIFont{
        get{
            return UIFont(name: "Brown-Regular", size: 16)!
        }
    }
    static var header:UIFont{
        get{
            return UIFont(name: "Brown-Regular", size: 25)!
        }
    }
}
