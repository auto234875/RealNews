//
//  GradientView.swift
//  Real News
//
//  Created by PC on 4/1/17.
//  Copyright © 2017 PC. All rights reserved.
//

import Foundation
import UIKit

class GradientView:UIView{
    let gradient = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        gradient.colors = [UIColor.turquoise.cgColor, UIColor.darkTurquoise.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradient, at: 0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
