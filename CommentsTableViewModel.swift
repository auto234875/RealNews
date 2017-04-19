//
//  CommentsTableViewModel.swift
//  Real News
//
//  Created by PC on 4/1/17.
//  Copyright © 2017 PC. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation
import UIKit

struct CommentViewModel{
    let comment:Comment
    let authorAttributedText:NSAttributedString
    let commentAttributedText:NSAttributedString
    let timeAttributedText:NSAttributedString
    let replyAttributedText:NSAttributedString
    let level:Int
    var rowHeight:CGFloat
    var collapsedRowHeight:CGFloat
    var collapsed:Bool
    var completeCollapsed:Bool
    var expanded:Bool
}

func newComment(cellWidth:CGFloat,story:Story)->Observable<CommentViewModel?>?{
    
    guard let observable = createCommentsObservable(kids: [story.id],isRoot:true,level:0) else{
        return nil
    }
    return observable.map({wrappedComment in
        guard let comment = wrappedComment else{
            return nil
        }
        guard let authorString = comment.author,let commentString = comment.text else{
            return nil
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = padding.paragraphLineSpacing.rawValue
        let authorFont = UIFont.detail
        let commentFont = UIFont.standard
        let authorAttributes = [NSFontAttributeName:authorFont,NSForegroundColorAttributeName:UIColor.appTextColor]
        let commentAttributes = [NSFontAttributeName:commentFont,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColor.appTextColor]
        let indentation = CGFloat(comment.level)*10
        let contentViewWidth = cellWidth - ((padding.cell.rawValue * 2) + (padding.genericDouble.rawValue) + indentation)
        let size = CGSize(width: contentViewWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let commentAttributedText = commentString.htmlAttributedString()!
        commentAttributedText.addAttributes(commentAttributes, range:NSMakeRange(0, commentAttributedText.length))
        let authorAttributedText = NSAttributedString(string: authorString,attributes:authorAttributes)
        let commentDetailAttributes = [NSFontAttributeName:commentFont,NSForegroundColorAttributeName:UIColor.lightAppTextColor]
        let time = Calendar.current.dateComponents([Calendar.Component.hour,Calendar.Component.minute], from: Date(timeIntervalSince1970: TimeInterval(comment.time!)), to:Date())
        var timeText = "・"
        timeText += time.hour! == 0 ? String(describing:time.minute!)+"m ago" : String(describing:time.hour!)+"h ago"
        let timeAttributedText = NSAttributedString(string: timeText, attributes: commentDetailAttributes)
        var replyString = "・"
        if comment.kids == nil {
            replyString += "0 reply"
        }else{
            replyString += String(comment.kids!.count)
            replyString += comment.kids!.count > 1 ? " replies" : " reply"
        }
        let replyAttributedString = NSAttributedString(string: replyString, attributes: commentDetailAttributes)
        let authorHeight = authorAttributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).height
        let commentHeight = commentAttributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).height
        let rowHeight = authorHeight + commentHeight + padding.generic.rawValue + padding.generic.rawValue + padding.interLabel.rawValue + (padding.cell.rawValue * 2)
        let collapsedRowHeight = rowHeight - commentHeight - padding.generic.rawValue
        return CommentViewModel(comment:comment,authorAttributedText: authorAttributedText, commentAttributedText:commentAttributedText,timeAttributedText:timeAttributedText,replyAttributedText:replyAttributedString,level:comment.level,rowHeight:rowHeight,collapsedRowHeight:collapsedRowHeight,collapsed:false,completeCollapsed:false,expanded:true)
    })
}
