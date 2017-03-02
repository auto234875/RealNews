//
//  storiesTableViewDataSource.swift
//  Real News
//
//  Created by John Smith on 1/12/17.
//  Copyright © 2017 John Smith. All rights reserved.
//
import RxSwift
import RxCocoa
import Foundation
import UIKit
struct StoryCellViewModel{
    var story:Story
    let titleAttributedText:NSAttributedString
    let authorAttributedText:NSAttributedString
    let timeAttributedText:NSAttributedString
    let commentCount:NSAttributedString?
    let rowHeight:CGFloat
}

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

enum padding:CGFloat{
    case cell = 5.0
    case generic = 15.0
    case horizontalTotal = 30.0
    case interLabel = 10.0
}

func newStory(cellWidth:CGFloat,type:StoriesType)->Observable<StoryCellViewModel>{
        return createStoriesObservable(type: type).map({(story:Story)->StoryCellViewModel in
            return processStory(story: story,cellWidth: cellWidth)
        })
}

func newStory(cellWidth:CGFloat,id:[Int])->Observable<StoryCellViewModel>{
    return createStoriesObservable(id: id).map({(story:Story)->StoryCellViewModel in
        return processStory(story: story,cellWidth: cellWidth)
    })
}
func processStory(story:Story,cellWidth:CGFloat)->StoryCellViewModel{
    let titleFont = UIFont.boldSystemFont(ofSize: 12)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 5
    let titleAttributes = [NSFontAttributeName:titleFont,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColor.white]
    let titleAttributedText = NSMutableAttributedString(string: story.title, attributes:titleAttributes)
    
    let time = Calendar.current.dateComponents([Calendar.Component.hour,Calendar.Component.minute], from: Date(timeIntervalSince1970: TimeInterval(story.time)), to:Date())
    let timeText = time.hour! == 0 ? String(describing:time.minute!)+"m ago" : String(describing:time.hour!)+"h ago"
    
    let authorFont = UIFont.systemFont(ofSize: 9)
    let authorAttributes = [NSFontAttributeName:authorFont,NSForegroundColorAttributeName:UIColor.white]

    let authorAttributedText = NSMutableAttributedString(string: story.author,attributes:authorAttributes)

    let timeAttributedText = NSAttributedString(string: timeText, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 9),NSForegroundColorAttributeName:UIColor.white])
    
    if story.url != nil {
        var domain = URL(string: story.url!.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)!.host!
        if domain.hasPrefix("www."){
            domain.removeSubrange(domain.startIndex...domain.index(domain.startIndex, offsetBy: 3))
        }
        let domainAttributedText = NSAttributedString(string: "・"+domain, attributes: authorAttributes)
        authorAttributedText.append(domainAttributedText)
    }
    
    let size = CGSize(width: cellWidth - padding.horizontalTotal.rawValue, height: CGFloat.greatestFiniteMagnitude)
    let titleHeight = titleAttributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size.height
    let authorHeight = authorAttributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size.height
    let timeHeight = timeAttributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size.height
    let rowHeight = padding.horizontalTotal.rawValue + (padding.cell.rawValue * 2) + (padding.interLabel.rawValue * 2) + titleHeight + authorHeight + timeHeight
    
    guard let commentCount = story.commentCount else{
        return StoryCellViewModel(story: story, titleAttributedText:titleAttributedText,authorAttributedText:authorAttributedText,timeAttributedText:timeAttributedText,commentCount:nil,rowHeight:rowHeight)
    }
    if commentCount == 0 {
        return StoryCellViewModel(story: story, titleAttributedText:titleAttributedText,authorAttributedText:authorAttributedText,timeAttributedText:timeAttributedText,commentCount:nil,rowHeight:rowHeight)
    }

    let commentAttributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 9),NSForegroundColorAttributeName:UIColor.white]
    var commentString = "・"+String(commentCount)
    commentString += commentCount > 1 ? " comments" : " comment"
    let commentAttributedText = NSAttributedString(string:commentString, attributes: commentAttributes)
    
    return StoryCellViewModel(story: story, titleAttributedText:titleAttributedText,authorAttributedText:authorAttributedText,timeAttributedText:timeAttributedText,commentCount:commentAttributedText,rowHeight:rowHeight)
    
}
extension String {
    func htmlAttributedString() -> NSMutableAttributedString? {
            guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
            guard let html = try? NSMutableAttributedString(
                data: data,
                options:[NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil) else { return nil }
            return html
        }
    
}

func newComment(cellWidth:CGFloat,story:Story)->Observable<CommentViewModel?>{
    
    return createCommentsObservable(kids: [story.id],isRoot:true,level:0)!.map({comment in
        guard let authorString = comment.author else{
            return nil
        }
        guard let commentString = comment.text else{
            return nil
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let authorFont = UIFont.boldSystemFont(ofSize: 14)
        let commentFont = UIFont.systemFont(ofSize: 13)
        let authorAttributes = [NSFontAttributeName:authorFont]
        let commentAttributes = [NSFontAttributeName:commentFont,NSParagraphStyleAttributeName:paragraphStyle]
        
        let indentation = CGFloat(comment.level)*10
        let contentViewWidth = cellWidth - ((padding.cell.rawValue * 2) + (padding.horizontalTotal.rawValue) + indentation)
        let size = CGSize(width: contentViewWidth, height: CGFloat.greatestFiniteMagnitude)

        let commentAttributedText = commentString.htmlAttributedString()!
        commentAttributedText.addAttributes(commentAttributes, range:NSMakeRange(0, commentAttributedText.length))
        let authorAttributedText = NSAttributedString(string: authorString,attributes:authorAttributes)
        let commentDetailAttributes = [NSFontAttributeName:authorFont,NSForegroundColorAttributeName:UIColor.lightGray]
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


