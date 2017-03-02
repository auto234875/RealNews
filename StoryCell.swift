//
//  StoryCell.swift
//  Real News
//
//  Created by John Smith on 1/3/17.
//  Copyright © 2017 John Smith. All rights reserved.
//
import UIKit
import RxSwift
class StoryCell:UITableViewCell{
    var mainView:UIView!
    var titleLabel=UILabel()
    var authorLabel=UILabel()
    var timeLabel=UILabel()
    var optionButton = OptionButton()
    var commentCountLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.numberOfLines = 0
        authorLabel.lineBreakMode = .byWordWrapping
        authorLabel.numberOfLines = 0
        optionButton.iconFrame = .zero
        optionButton.color = UIColor.white
        if UIAccessibilityIsReduceTransparencyEnabled() {
            mainView.backgroundColor = UIColor.appBackgroundColor
            mainView.addSubview(timeLabel)
            mainView.addSubview(optionButton)
            mainView.addSubview(titleLabel)
            mainView.addSubview(authorLabel)
            mainView.addSubview(commentCountLabel)

        }else{
            mainView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            (mainView as! UIVisualEffectView).contentView.addSubview(timeLabel)
            (mainView as! UIVisualEffectView).contentView.addSubview(optionButton)
            (mainView as! UIVisualEffectView).contentView.addSubview(titleLabel)
            (mainView as! UIVisualEffectView).contentView.addSubview(authorLabel)
            (mainView as! UIVisualEffectView).contentView.addSubview(commentCountLabel)
        }
        contentView.addSubview(mainView)
    }
    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.frame = CGRect(x: padding.cell.rawValue, y: padding.cell.rawValue, width: contentView.bounds.width-(padding.cell.rawValue*2), height: contentView.bounds.height-(padding.cell.rawValue*2))
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true

        guard let titleText = titleLabel.attributedText else{
            return
        }
        let size = CGSize(width: mainView.bounds.width-padding.horizontalTotal.rawValue, height: CGFloat.greatestFiniteMagnitude)

        let authorSize = authorLabel.attributedText!.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
        authorLabel.frame = CGRect(x: padding.generic.rawValue, y: padding.generic.rawValue, width: authorSize.width, height: authorSize.height)
        
        let titleSize = titleText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
        titleLabel.frame = CGRect(x:padding.generic.rawValue, y: authorLabel.frame.maxY+padding.interLabel.rawValue, width: titleSize.width, height: titleSize.height)
        let timeSize = timeLabel.sizeThatFits(size)
        timeLabel.frame = CGRect(x: padding.generic.rawValue, y: titleLabel.frame.maxY + padding.interLabel.rawValue, width: timeSize.width, height: timeSize.height)
        
        if commentCountLabel.attributedText != nil{
            let commentCountSize = commentCountLabel.attributedText!.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
            commentCountLabel.frame = CGRect(x: timeLabel.frame.maxX, y: timeLabel.frame.origin.y, width: commentCountSize.width, height: commentCountSize.height)
            
        }
        optionButton.frame = CGRect(x: mainView.bounds.width - 44, y: titleLabel.frame.maxY + padding.interLabel.rawValue, width: 44, height: timeSize.height+padding.generic.rawValue)
        let iconFrameWidth:CGFloat = 10
            optionButton.iconFrame = CGRect(x: optionButton.bounds.width-(padding.generic.rawValue+iconFrameWidth), y: 0, width: iconFrameWidth, height: 15)
        
        
        
    }
}
