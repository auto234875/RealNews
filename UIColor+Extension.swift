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
    static var appTextColor: UIColor  {
        get {
            return UIColor(hue: 0.89, saturation: 0.03, brightness: 0.21, alpha: 1)
        }
    }
    static var lightAppTextColor: UIColor  {
        get {
            return UIColor(hue: 0.50, saturation: 0.06, brightness: 0.53, alpha: 1)
        }
    }

    static var turquoise:UIColor{
        get{
            return UIColor(hue: 0.51, saturation: 0.75, brightness: 0.72, alpha: 1)
        }
    }
    static var darkTurquoise:UIColor{
        get{
            return UIColor(hue: 0.51, saturation: 0.74, brightness: 0.17, alpha: 1)
        }
    }
}
