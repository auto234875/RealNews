//
//  HackerNewsFirebase.swift
//  Real News
//
//  Created by John Smith on 12/31/16.
//  Copyright © 2016 John Smith. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum StoriesType:String,StoryDescription{
    case topStories = "https://hacker-news.firebaseio.com/v0/topstories.json"
    case askStories = "https://hacker-news.firebaseio.com/v0/askstories.json"
    case newStories = "https://hacker-news.firebaseio.com/v0/newstories.json"
    case bestStories = "https://hacker-news.firebaseio.com/v0/beststories.json"
    case showStories = "https://hacker-news.firebaseio.com/v0/showstories.json"
    case jobStories = "https://hacker-news.firebaseio.com/v0/jobstories.json"
    
    var title:String{
        switch self{
        case .topStories :
            return "Top"
        case .askStories:
            return "Ask"
        case .newStories:
            return "New"
        case .bestStories:
            return "Best"
        case .showStories:
            return "Show"
        case .jobStories:
            return "Jobs"
        }
    }
    
    var icon:UIImage{
        switch self{
        case .topStories :
            return UIImage(named: "top")!
        case .askStories:
            return UIImage(named: "ask")!
        case .newStories:
            return UIImage(named: "new")!
        case .bestStories:
            return UIImage(named: "best")!
        case .showStories:
            return UIImage(named: "show")!
        case .jobStories:
            return UIImage(named: "jobs")!
        }
    }
}

protocol StoryDescription{
    var title:String{get}
    var icon:UIImage{get}
}
struct Story{
    let author:String
    var commentCount:Int?
    var kids:[Int]?
    let time:Int
    let id:Int
    var score:Int
    let url:String?
    var title:String
    let index:Int
}

struct Comment{
    let author:String?
    let title:String?
    let parent:Int?
    let time:Int?
    let id:Int
    let text:String?
    let kids:[Int]?
    let level:Int
}

func createStoriesObservable(type:StoriesType)->Observable<Story>{
     let observable = URLSession.shared.rx.json(url:NSURL(string: type.rawValue) as! URL)
        .map({(json:Any)->Observable<Any> in
            var observableStories = [Observable<Any>]()
            for i in json as! [Int]{
                let storyURL = URL(string:"https://hacker-news.firebaseio.com/v0/item/"+String(i)+".json")
                observableStories.append(URLSession.shared.rx.json(url:storyURL!))
            }
            return Observable.from(observableStories).concat()
        })
    return flatMapStoriesObservable(observable: observable)
}

func flatMapStoriesObservable(observable:Observable<Observable<Any>>)->Observable<Story>{
    
    return mapStoriesObservable(observable:observable.flatMap({observable in
        return observable
    }))

}

func mapStoriesObservable(observable:Observable<Any>)->Observable<Story>{
    
    return observable.mapWithIndex({(json:Any,index)->Story in
        
        let storyDict = json as! Dictionary<String,Any>
        let author = storyDict["by"] as! String
        let commentCount = storyDict["descendants"] as! Int!
        let kids = storyDict["kids"] as! [Int]?
        let time = storyDict["time"] as! Int
        let id = storyDict["id"] as! Int
        let score = storyDict["score"] as! Int
        let url = storyDict["url"] as? String
        let title = storyDict["title"] as! String
        return Story(author:author,commentCount:commentCount,kids:kids,time:time,id:id,score:score,url:url,title:title,index:index)
    })
    
}

func createStoriesObservable(id:[Int])->Observable<Story>{
    var observableStories = [Observable<Any>]()
    for i in id{
        let storyURL = URL(string:"https://hacker-news.firebaseio.com/v0/item/"+String(i)+".json")!
        observableStories.append(URLSession.shared.rx.json(url:storyURL))
    }
    let observable = Observable.from(observableStories).concat()
    return mapStoriesObservable(observable: observable)
}

func createCommentsObservable(kids:[Int]?,isRoot:Bool,level:Int)->Observable<Comment>?{
    if kids == nil{
        return nil
    }
    let str = "https://hacker-news.firebaseio.com/v0/item/"
    var observableArray = [Observable<Comment>]()
    
    for i in kids!{
        observableArray.append(URLSession.shared.rx.json(url:URL(string:str+String(i)+".json")!).flatMapWithIndex({(json:Any,index:Int)->Observable<Comment> in
            
            guard let comment = json as? Dictionary<String,Any> else{
                return Observable.empty()
            }
            let author = comment["by"] as! String?
            let parent = comment["parent"] as! Int?
            let id = comment["id"] as! Int
            let time = comment["time"] as! Int
            let title = comment["title"] as! String?
            let text = comment["text"] as! String?
            let kids = comment["kids"] as! [Int]?
            let observable = Observable.just(Comment(author: author, title:title,parent: parent,time: time, id: id, text: text,kids:kids,level:level))
            if kids == nil{
                return observable
            }
            
            if isRoot{
                return observable.concat(createCommentsObservable(kids: kids,isRoot:false,level:0)!)
            }else{
                return observable.concat(createCommentsObservable(kids: kids,isRoot:false,level:level+1)!)
            }
            
        }))
    }
    return (Observable.from(observableArray).concat())
    
}




