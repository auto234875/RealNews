//
//  colors.swift
//  Real News
//
//  Created by John Smith on 1/12/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var appColor: UIColor  {
        get {
            return UIColor(hue: 0.96, saturation: 0.02, brightness: 0.35, alpha: 1)
        }
    }
    static var appBackgroundColor:UIColor{
        get{
            return UIColor(red: 248, green: 250, blue: 251, alpha: 1)
            
        }
    }
}
