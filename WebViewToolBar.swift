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
    var actionButton = UIButton()
    let attributes = [NSForegroundColorAttributeName: UIColor.turquoise,NSFontAttributeName:UIFont.standard]
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
            backgroundColor = UIColor.white
        }
        
        commentButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        closeButton.setImage(UIImage(named:"X")!.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.backgroundColor = UIColor.clear
        closeButton.tintColor = UIColor.turquoise
        addSubview(closeButton)
        backButton.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.backgroundColor = UIColor.clear
        backButton.tintColor = UIColor.lightAppTextColor
        addSubview(backButton)
        forwardButton.setImage(UIImage(named:"forward")!.withRenderingMode(.alwaysTemplate), for: .normal)
        forwardButton.backgroundColor = UIColor.clear
        forwardButton.tintColor = UIColor.lightAppTextColor
        addSubview(forwardButton)
        actionButton.setImage(UIImage(named:"activity")!.withRenderingMode(.alwaysTemplate), for: .normal)
        actionButton.backgroundColor = UIColor.clear
        actionButton.tintColor = UIColor.turquoise
        actionButton.contentEdgeInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
        addSubview(actionButton)
        commentButton.backgroundColor = UIColor.clear
        addSubview(commentButton)
    }
    
    override func layoutSubviews() {
        closeButton.frame = CGRect(x: 0, y: 0, width: 44, height: bounds.height)
        backButton.frame = CGRect(x: closeButton.frame.maxX, y: 0, width: 44, height: bounds.height)
        forwardButton.frame = CGRect(x: backButton.frame.maxX, y: 0, width: 44, height: bounds.height)
        
        actionButton.frame = CGRect(x: forwardButton.frame.maxX, y: 0, width: 44, height: bounds.height)
        guard let commentButtonText = commentButton.currentAttributedTitle else{
            commentButton.frame = .zero
            return
        }
        let size = CGSize(width: .greatestFiniteMagnitude, height: bounds.height)
        let commentSize = commentButtonText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
        commentButton.frame = CGRect(x: bounds.width - commentSize.width - padding.totalTextHorizontal.rawValue, y: 0, width: commentSize.width + padding.totalTextHorizontal.rawValue, height: bounds.height)
        
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
