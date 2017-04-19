//
//  LicenseCell.swift
//  Real News
//
//  Created by PC on 4/19/17.
//  Copyright © 2017 PC. All rights reserved.
//

import Foundation
import UIKit

class LicenseCell:UITableViewCell{
    let name = UILabel()
    let content = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        separatorInset = UIEdgeInsetsMake(0, padding.totalTextHorizontal.rawValue, 0, padding.totalTextHorizontal.rawValue)
        name.lineBreakMode = NSLineBreakMode.byWordWrapping
        name.numberOfLines = 0
        name.backgroundColor = UIColor.clear
        content.backgroundColor = UIColor.clear
        content.lineBreakMode = .byWordWrapping
        content.numberOfLines = 0
        contentView.addSubview(name)
        contentView.addSubview(content)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = CGSize(width: contentView.bounds.width - padding.totalTextHorizontal.rawValue*2, height: .greatestFiniteMagnitude)
        let nameSize = name.sizeThatFits(size)
        let contentSize = content.sizeThatFits(size)
        name.frame = CGRect(x: padding.totalTextHorizontal.rawValue, y: padding.totalTextHorizontal.rawValue, width: nameSize.width, height: nameSize.height)
        content.frame = CGRect(x: padding.totalTextHorizontal.rawValue, y: name.frame.maxY + padding.interLabel.rawValue, width: contentSize.width, height: contentSize.height)
    }
}
