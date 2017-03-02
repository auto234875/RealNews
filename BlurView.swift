//
//  BlurUILabel.swift
//  Real News
//
//  Created by John Smith on 2/19/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit

class BlurView:UIView{
    var mainView:UIView!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            mainView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.extraLight))
        } else {
            mainView = UIView()
            mainView.backgroundColor = UIColor.appTextColor
        }
        mainView.frame = bounds
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(mainView)
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
