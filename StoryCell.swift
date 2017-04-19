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
    let mainView = UIView()
    var titleLabel=UILabel()
    var authorLabel=UILabel()
    var timeLabel=UILabel()
    var commentButton = UIButton()
    private(set) var disposeBag = DisposeBag()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        separatorInset = UIEdgeInsetsMake(0, padding.totalTextHorizontal.rawValue, 0, padding.totalTextHorizontal.rawValue)
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        authorLabel.backgroundColor = UIColor.clear
        authorLabel.lineBreakMode = .byWordWrapping
        authorLabel.numberOfLines = 0
        commentButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        commentButton.backgroundColor = UIColor.clear
        mainView.backgroundColor = UIColor.clear
        mainView.addSubview(commentButton)
        mainView.addSubview(timeLabel)
        mainView.addSubview(titleLabel)
        mainView.addSubview(authorLabel)
        contentView.addSubview(mainView)
    }
    
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

        if titleLabel.attributedText == nil {
            return
        }
        
        let size = CGSize(width: mainView.bounds.width-padding.genericDouble.rawValue, height: CGFloat.greatestFiniteMagnitude)

        let authorSize = authorLabel.sizeThatFits(size)
        authorLabel.frame = CGRect(x: padding.generic.rawValue, y: padding.generic.rawValue, width: authorSize.width, height: authorSize.height + padding.BrownFontVertical.rawValue)

        let titleSize = titleLabel.sizeThatFits(size)
        titleLabel.frame = CGRect(x:padding.generic.rawValue, y: authorLabel.frame.maxY+padding.interLabel.rawValue, width: titleSize.width, height: titleSize.height + padding.BrownFontVertical.rawValue)
        let timeSize = timeLabel.sizeThatFits(size)
        timeLabel.frame = CGRect(x: padding.generic.rawValue, y: titleLabel.frame.maxY + padding.interLabel.rawValue, width: timeSize.width, height: timeSize.height + padding.BrownFontVertical.rawValue)

        if commentButton.attributedTitle(for: .normal) != nil{
            let commentButtonSize = commentButton.intrinsicContentSize
            commentButton.frame = CGRect(x: timeLabel.frame.maxX, y: titleLabel.frame.maxY, width: commentButtonSize.width, height: timeSize.height + padding.interLabel.rawValue + padding.totalTextHorizontal.rawValue + padding.BrownFontVertical.rawValue)
        }else{
            commentButton.frame = .zero
        }
        }
}
