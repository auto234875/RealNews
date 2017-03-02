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
    selectionStyle = .none
    backgroundColor = UIColor.clear
    contentView.backgroundColor = UIColor.clear
    
    if UIAccessibilityIsReduceTransparencyEnabled() {
        mainView.backgroundColor = UIColor.black
        mainView.addSubview(viewControllerLabel)
    }else{
        mainView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        (mainView as! UIVisualEffectView).contentView.addSubview(viewControllerLabel)
    }
    contentView.addSubview(mainView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.frame = CGRect(x: padding.cell.rawValue, y: padding.cell.rawValue, width: contentView.bounds.width-(padding.cell.rawValue*2), height: contentView.bounds.height-(padding.cell.rawValue*2))
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true

        let viewControllerLabelSize = CGSize(width: mainView.frame.width - padding.horizontalTotal.rawValue, height: .greatestFiniteMagnitude)
        let viewControllerFrame = viewControllerLabel.sizeThatFits(viewControllerLabelSize)
        viewControllerLabel.frame = CGRect(x: (mainView.bounds.width/2) - (viewControllerFrame.width/2), y: (mainView.bounds.height/2) - (viewControllerFrame.height/2), width: viewControllerFrame.width, height: viewControllerFrame.height)
    }
}
