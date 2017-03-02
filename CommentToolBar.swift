//
//  CommentToolBar.swift
//  Real News
//
//  Created by John Smith on 2/2/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit

class CommentToolBar:UIView{
    var closeButton = UIButton()
    var storyButton = UIButton()
    var mainView = UIVisualEffectView(effect: UIBlurEffect(style:.extraLight))
    
    override init(frame:CGRect){
        super.init(frame: frame)
        let attributes = [NSForegroundColorAttributeName: UIColor.appTextColor,NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 15)!]
        let closeButtonAttributedString = NSAttributedString(string: "CLOSE", attributes: attributes)
        closeButton.setAttributedTitle(closeButtonAttributedString, for: .normal)
        closeButton.backgroundColor = UIColor.clear
        let storyButtonAttributedString = NSAttributedString(string: "STORY", attributes: attributes)
        storyButton.setAttributedTitle(storyButtonAttributedString, for: .normal)
        storyButton.backgroundColor = UIColor.clear
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            backgroundColor = UIColor.clear
            mainView.frame = bounds
            mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(mainView)
            mainView.contentView.addSubview(closeButton)
            mainView.contentView.addSubview(storyButton)

        } else {
            backgroundColor = UIColor.appBackgroundColor
            addSubview(closeButton)
            addSubview(storyButton)
        }

        
    }
    
    override func layoutSubviews() {
        closeButton.frame = CGRect(x: 0, y: 0, width: 88, height: bounds.height)
        storyButton.frame = CGRect(x: bounds.width-88, y: 0, width: 88, height: bounds.height)
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
