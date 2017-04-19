//
//  AboutView.swift
//  Real News
//
//  Created by John Smith on 2/19/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
class AboutView:UIView{
    let name = UILabel()
    let title = UILabel()
    let email = UILabel()
    let mobile = UILabel()
    let avatar = UIImageView(image: UIImage(named: "portrait"))
    let hireMeButton = UILabel()
    let hireMeGesture = UITapGestureRecognizer()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        let nameAttributes:[String:Any] = [NSForegroundColorAttributeName:UIColor.appTextColor,NSFontAttributeName:UIFont(name: "Brown-Regular", size: 30)!]
        let detailAttributes:[String:Any] = [NSForegroundColorAttributeName:UIColor.appTextColor,NSFontAttributeName:UIFont.standard]
        let hireMeButtonAttributes:[String:Any] = [NSForegroundColorAttributeName:UIColor.turquoise,NSFontAttributeName:UIFont.standard]
        
        name.attributedText = NSAttributedString(string: "John Smith", attributes: nameAttributes)
        title.attributedText = NSAttributedString(string: "Software Developer", attributes: detailAttributes)
        mobile.attributedText = NSAttributedString(string: "832.898.4718", attributes: detailAttributes)
        email.attributedText = NSAttributedString(string: "auto234875@gmail.com", attributes: detailAttributes)
        hireMeButton.attributedText = NSAttributedString(string: "Hire me", attributes: hireMeButtonAttributes)
        hireMeButton.addGestureRecognizer(hireMeGesture)
        hireMeButton.isUserInteractionEnabled = true
        addSubview(avatar)
        addSubview(name)
        addSubview(title)
        addSubview(email)
        addSubview(mobile)
        addSubview(hireMeButton)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = bounds.width/2
        avatar.frame = CGRect(x: center - 80, y: 50, width: 160, height: 160)
        avatar.layer.cornerRadius = 80
        avatar.layer.masksToBounds = true
        let size = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
        let nameSize = name.sizeThatFits(size)
        name.frame = CGRect(x: center - nameSize.width/2, y: avatar.frame.maxY + 50, width: nameSize.width, height: nameSize.height)
        
        let titleSize = title.sizeThatFits(size)
        title.frame = CGRect(x: padding.totalTextHorizontal.rawValue, y: name.frame.maxY + 50, width: titleSize.width, height: titleSize.height)
        let mobileSize = mobile.sizeThatFits(size)
        mobile.frame = CGRect(x: padding.totalTextHorizontal.rawValue, y: title.frame.maxY + padding.paragraphLineSpacing.rawValue, width: mobileSize.width, height: mobileSize.height)
        let emailSize = email.sizeThatFits(size)
        email.frame = CGRect(x: padding.totalTextHorizontal.rawValue, y: mobile.frame.maxY + padding.paragraphLineSpacing.rawValue, width: emailSize.width, height: emailSize.height + padding.BrownFontVertical.rawValue)
        let hireMeSize = hireMeButton.sizeThatFits(size)
        hireMeButton.frame = CGRect(x: padding.totalTextHorizontal.rawValue, y: email.frame.maxY + padding.paragraphLineSpacing.rawValue, width: hireMeSize.width, height: hireMeSize.height + padding.BrownFontVertical.rawValue)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
