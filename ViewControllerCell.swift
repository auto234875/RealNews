//
//  ViewControllerCell.swift
//  Real News
//
//  Created by John Smith on 2/14/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerCell:UITableViewCell{
    var mainView = UIView()
    let viewControllerLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = UIColor.clear
    contentView.backgroundColor = UIColor.clear
    separatorInset = UIEdgeInsetsMake(0, padding.cell.rawValue + padding.generic.rawValue, 0, 0)
    mainView.backgroundColor = UIColor.white
    mainView.addSubview(viewControllerLabel)
    contentView.addSubview(mainView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.frame = CGRect(x: padding.cell.rawValue, y: padding.cell.rawValue, width: contentView.bounds.width-(padding.cell.rawValue*2), height: contentView.bounds.height-(padding.cell.rawValue*2))

        let viewControllerLabelSize = CGSize(width: mainView.frame.width - padding.genericDouble.rawValue, height: .greatestFiniteMagnitude)
        let viewControllerFrame = viewControllerLabel.sizeThatFits(viewControllerLabelSize)
        viewControllerLabel.frame = CGRect(x: padding.generic.rawValue, y: (mainView.bounds.height/2) - (viewControllerFrame.height/2), width: viewControllerFrame.width, height: viewControllerFrame.height)
    }
}
