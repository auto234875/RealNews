//
//  WebViewToolBar.swift
//  Real News
//
//  Created by John Smith on 1/17/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit

class WebViewToolBar:UIView{
    var closeButton = UIButton()
    var commentButton = UIButton()
    var backButton = UIButton()
    var forwardButton = UIButton()
    var actionButton = OptionButton()
    let attributes = [NSForegroundColorAttributeName: UIColor.appColor,NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 14)!]
    override init(frame:CGRect){
        super.init(frame: frame)
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(blurEffectView)
        } else {
            backgroundColor = UIColor.appBackgroundColor
        }
        
        let attributedString = NSAttributedString(string: "CLOSE", attributes: attributes)
        closeButton.setAttributedTitle(attributedString, for: .normal)
        closeButton.backgroundColor = UIColor.clear
        addSubview(closeButton)
        backButton.setImage(UIImage(named:"back"), for: .normal)
        backButton.backgroundColor = UIColor.clear
        addSubview(backButton)
        forwardButton.setImage(UIImage(named:"forward"), for: .normal)
        forwardButton.backgroundColor = UIColor.clear
        addSubview(forwardButton)
        addSubview(actionButton)
        commentButton.tintColor = UIColor.appColor
        commentButton.backgroundColor = UIColor.clear
        addSubview(commentButton)
    }
    
    override func layoutSubviews() {
        closeButton.frame = CGRect(x: 0, y: 0, width: 65, height: bounds.height)
        backButton.frame = CGRect(x: closeButton.frame.maxX, y: 0, width: 44, height: bounds.height)
        forwardButton.frame = CGRect(x: backButton.frame.maxX, y: 0, width: 44, height: bounds.height)
        
        actionButton.iconFrame = CGRect(x: 12, y: 2, width: 20, height: 30)
        actionButton.frame = CGRect(x: forwardButton.frame.maxX, y: 0, width: 44, height: bounds.height)
        guard let commentButtonText = commentButton.currentAttributedTitle else{
            commentButton.frame = .zero
            return
        }
        let size = CGSize(width: .greatestFiniteMagnitude, height: bounds.height)
        let commentSize = commentButtonText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
        //commentButton.frame = CGRect(x: actionButton.frame.maxX, y: 0, width: bounds.width-actionButton.frame.maxX, height: bounds.height)
        commentButton.frame = CGRect(x: bounds.width - commentSize.width - padding.generic.rawValue, y: 0, width: commentSize.width + padding.generic.rawValue, height: bounds.height)
        
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
