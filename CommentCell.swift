//
//  CommentCell.swift
//  Real News
//
//  Created by John Smith on 1/20/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class CommentCell:UITableViewCell{
    let mainView = UIView()
    let authorLabel = UILabel()
    let commentLabel = UITextView()
    let replyLabel = UILabel()
    let timeLabel = UILabel()
    let hiddenCommentIcon = HiddenCommentIcon()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        authorLabel.lineBreakMode = .byWordWrapping
        authorLabel.numberOfLines = 0
        commentLabel.textContainer.lineFragmentPadding = 0
        commentLabel.textContainerInset = .zero
        commentLabel.backgroundColor = UIColor.clear
        commentLabel.isScrollEnabled = false
        commentLabel.dataDetectorTypes = .link
        commentLabel.isEditable = false
        mainView.backgroundColor = UIColor.clear
        mainView.addSubview(hiddenCommentIcon)
        mainView.addSubview(commentLabel)
        mainView.addSubview(authorLabel)
        mainView.addSubview(replyLabel)
        mainView.addSubview(timeLabel)
        
        contentView.addSubview(mainView)
    }
    override func prepareForReuse()
    {
        super.prepareForReuse()
        hiddenCommentIcon.set(expand: true, animated: false)
    }
    func set(expand:Bool,animated:Bool){
        hiddenCommentIcon.set(expand: expand, animated: animated)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let indentation:CGFloat = CGFloat(indentationLevel)*indentationWidth
        let mainViewWidth:CGFloat = contentView.bounds.width - (padding.cell.rawValue * 2 + indentation)
        let mainViewOriginX:CGFloat = padding.cell.rawValue + indentation
        let mainViewHeight = contentView.bounds.height - (padding.cell.rawValue * 2)
        mainView.frame = CGRect(x: mainViewOriginX, y: padding.cell.rawValue, width: mainViewWidth, height: mainViewHeight)
       separatorInset = UIEdgeInsetsMake(0, mainView.frame.origin.x + padding.generic.rawValue, 0, padding.totalTextHorizontal.rawValue)
        if authorLabel.attributedText == nil {
            return
        }
        
        let hiddenCommentIconWidth:CGFloat = 11
        let hiddenCommentIconHorizontalPadding:CGFloat = 8
        let authorWidth:CGFloat = mainViewWidth - (padding.genericDouble.rawValue) - hiddenCommentIconWidth - hiddenCommentIconHorizontalPadding
        let originX = padding.generic.rawValue
        let originY = padding.generic.rawValue
        let authorSize = CGSize(width: authorWidth, height: CGFloat.greatestFiniteMagnitude)
        let authorRect = authorLabel.sizeThatFits(authorSize)
        hiddenCommentIcon.frame = CGRect(x: originX, y: originY + 3, width: hiddenCommentIconWidth, height: hiddenCommentIconWidth)
        authorLabel.frame = CGRect(x:hiddenCommentIcon.frame.maxX+hiddenCommentIconHorizontalPadding, y: originY, width: authorRect.width, height: authorRect.height + padding.BrownFontVertical.rawValue)
        let timeLabelSize = CGSize(width: mainViewWidth-(authorLabel.frame.maxX+padding.generic.rawValue), height: .greatestFiniteMagnitude)
        let timeLabelFrame = timeLabel.sizeThatFits(timeLabelSize)
        timeLabel.frame = CGRect(x: authorLabel.frame.maxX, y: authorLabel.frame.origin.y, width: timeLabelFrame.width, height: timeLabelFrame.height + padding.BrownFontVertical.rawValue)
        if replyLabel.attributedText != nil {
            replyLabel.frame = CGRect(x: timeLabel.frame.maxX, y: timeLabel.frame.origin.y, width: (mainViewWidth-timeLabel.frame.maxX+padding.generic.rawValue), height: authorLabel.frame.height)
        }else{
            replyLabel.frame = .zero
        }
        if commentLabel.attributedText == nil{
            commentLabel.frame = .zero
            return
        }
        
        let commentLabelYorigin = authorLabel.frame.maxY + padding.interLabel.rawValue
        let commentWidth = mainViewWidth - (padding.genericDouble.rawValue)
        let commentSize = CGSize(width: commentWidth, height: .greatestFiniteMagnitude)
        let commentRect = commentLabel.sizeThatFits(commentSize)
        commentLabel.frame = CGRect(x: originX, y: commentLabelYorigin, width: commentRect.width, height: commentRect.height + padding.BrownFontVertical.rawValue)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
