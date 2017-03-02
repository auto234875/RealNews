//
//  AboutView.swift
//  Real News
//
//  Created by John Smith on 2/19/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit

class AboutView:BlurView{
    let name = UILabel()
    let title = UILabel()
    let email = UILabel()
    let mobile = UILabel()
    let avatar = UIImageView(image: UIImage(named: "portrait"))
    
    override init(frame:CGRect){
        super.init(frame: frame)
        let nameAttributes = [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont(name: "AppleSDGothicNeo-Regular", size: 40)]
        let detailAttributes = [NSForegroundColorAttributeName:UIColor.appColor,NSFontAttributeName:UIFont(name: "AppleSDGothicNeo-Regular", size: 16)]
        name.attributedText = NSAttributedString(string: "John Smith", attributes: nameAttributes)
        title.attributedText = NSAttributedString(string: "Software Developer", attributes: detailAttributes)
        mobile.attributedText = NSAttributedString(string: "832.898.4718", attributes: detailAttributes)
        email.attributedText = NSAttributedString(string: "auto234875@gmail.com", attributes: detailAttributes)
        
        if mainView.isKind(of: UIVisualEffectView.self){
            let MainView = mainView as! UIVisualEffectView
            MainView.contentView.addSubview(avatar)
            MainView.contentView.addSubview(name)
            MainView.contentView.addSubview(title)
            MainView.contentView.addSubview(email)
            MainView.contentView.addSubview(mobile)
        }else{
            mainView.addSubview(avatar)
            mainView.addSubview(name)
            mainView.addSubview(title)
            mainView.addSubview(email)
            mainView.addSubview(mobile)
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = mainView.bounds.width/2
        avatar.frame = CGRect(x: center - 80, y: 50, width: 160, height: 160)
        avatar.layer.cornerRadius = 80
        avatar.layer.masksToBounds = true
        let size = CGSize(width: mainView.bounds.width-padding.horizontalTotal.rawValue, height: .greatestFiniteMagnitude)
        let nameSize = name.sizeThatFits(size)
        name.frame = CGRect(x: center - nameSize.width/2, y: avatar.frame.maxY + 50, width: nameSize.width, height: nameSize.height)
        
        let titleSize = title.sizeThatFits(size)
        title.frame = CGRect(x: padding.generic.rawValue, y: name.frame.maxY + 50, width: titleSize.width, height: titleSize.height)
        let mobileSize = mobile.sizeThatFits(size)
        mobile.frame = CGRect(x: padding.generic.rawValue, y: title.frame.maxY + 5, width: mobileSize.width, height: mobileSize.height)
        let emailSize = email.sizeThatFits(size)
        email.frame = CGRect(x: padding.generic.rawValue, y: mobile.frame.maxY + 5, width: emailSize.width, height: emailSize.height)
            }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
