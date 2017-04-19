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

func newStory(cellWidth:CGFloat,type:StoriesType)->Observable<StoryCellViewModel?>{
        return createStoriesObservable(type: type).map({(story:Story?)->StoryCellViewModel? in
            guard let unwrappedStory = story else {
                return nil
            }
            return processStory(story: unwrappedStory,cellWidth: cellWidth)
        })
}

func newStory(cellWidth:CGFloat,id:[Int])->Observable<StoryCellViewModel?>{
    return createStoriesObservable(id: id).map({(story:Story?)->StoryCellViewModel? in
        guard let unwrappedStory = story else {
            return nil
        }
        return processStory(story: unwrappedStory,cellWidth: cellWidth)
    })
}
func searchStory(cellWidth:CGFloat,searchTerm:String?,order:SearchOrder)->Observable<StoryCellViewModel?>?{
    guard let searchTerm = searchTerm else{
        return nil
    }
    let trimmedText =  searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedText.isEmpty {
        return nil
    }
    return createSearchStoriesObservable(searchTerm: trimmedText, order: order).map({(story:Story?)->StoryCellViewModel? in
        guard let unwrappedStory = story else {
            return nil
        }
        return processStory(story: unwrappedStory,cellWidth: cellWidth)
    })
}

func processStory(story:Story,cellWidth:CGFloat)->StoryCellViewModel{
    let titleFont = UIFont.standard
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = padding.paragraphLineSpacing.rawValue
    let titleAttributes:[String:Any] = [NSFontAttributeName:titleFont,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColor.appTextColor]
    let titleAttributedText = NSMutableAttributedString(string: story.title, attributes:titleAttributes)
    
    let authorFont = UIFont.standard
    let authorAttributes = [NSFontAttributeName:authorFont,NSForegroundColorAttributeName:UIColor.lightAppTextColor]
    let authorAttributedText = NSMutableAttributedString(string: story.author,attributes:authorAttributes)
    
    let time = Calendar.current.dateComponents([Calendar.Component.hour,Calendar.Component.minute], from: Date(timeIntervalSince1970: TimeInterval(story.time)), to:Date())
    let timeText = time.hour! == 0 ? String(describing:time.minute!)+"m ago" : String(describing:time.hour!)+"h ago"
    let timeAttributedText = NSAttributedString(string: timeText, attributes: [NSFontAttributeName:authorFont,NSForegroundColorAttributeName:UIColor.lightAppTextColor])

    let size = CGSize(width: cellWidth - padding.genericDouble.rawValue, height: CGFloat.greatestFiniteMagnitude)
    let titleHeight = titleAttributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size.height
    let authorHeight = authorAttributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size.height
    let timeHeight = timeAttributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size.height
    let rowHeight = padding.genericDouble.rawValue + padding.cellDouble.rawValue + padding.interLabel.rawValue * 2 + titleHeight + authorHeight + timeHeight + padding.BrownFontVertical.rawValue * 3
    
    guard let commentCount = story.commentCount else{
        return StoryCellViewModel(story: story, titleAttributedText:titleAttributedText,authorAttributedText:authorAttributedText,timeAttributedText:timeAttributedText,commentCount:nil,rowHeight:rowHeight)
    }
    
    let commentAttributes = [NSFontAttributeName:authorFont,NSForegroundColorAttributeName:UIColor.turquoise]
    var commentString = "・"+String(commentCount)
    commentString += commentCount > 1 ? " comments" : " comment"
    let commentAttributedText = NSAttributedString(string:commentString, attributes: commentAttributes)
    
    return StoryCellViewModel(story: story, titleAttributedText:titleAttributedText,authorAttributedText:authorAttributedText,timeAttributedText:timeAttributedText,commentCount:commentAttributedText,rowHeight:rowHeight)
    
}






