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
    let middleView = UIView()
    override init(frame:CGRect){
        super.init(frame: frame)
        let attributes = [NSForegroundColorAttributeName: UIColor.turquoise,NSFontAttributeName:UIFont.standard]
        let closeButtonAttributedString = NSAttributedString(string: "CLOSE", attributes: attributes)
        closeButton.setAttributedTitle(closeButtonAttributedString, for: .normal)
        closeButton.backgroundColor = UIColor.clear
        let storyButtonAttributedString = NSAttributedString(string: "STORY", attributes: attributes)
        storyButton.setAttributedTitle(storyButtonAttributedString, for: .normal)
        storyButton.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        middleView.backgroundColor = UIColor.clear
        addSubview(middleView)
        addSubview(closeButton)
        addSubview(storyButton)

        
    }
    
    override func layoutSubviews() {
        let buttonsWidth:CGFloat = 88
        closeButton.frame = CGRect(x: 0, y: 0, width: buttonsWidth, height: bounds.height)
        middleView.frame = CGRect(x: closeButton.frame.maxX, y: 0, width: bounds.width-buttonsWidth*2, height: bounds.height)
        storyButton.frame = CGRect(x: middleView.frame.maxX, y: 0, width: buttonsWidth, height: bounds.height)
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
