//
//  HNAlgolia.swift
//  Real News
//
//  Created by PC on 3/31/17.
//  Copyright © 2017 PC. All rights reserved.
//

import Foundation
import RxSwift

enum SearchOrder:String{
    case recent = "http://hn.algolia.com/api/v1/search_by_date?query="
    case popular = "http://hn.algolia.com/api/v1/search?query="
}

func createSearchStoriesObservableRecursive(searchTerm:String,order:SearchOrder,page:Int)->Observable<Any>{
    let urlString = (order.rawValue + searchTerm+"&tags=story&hitsPerPage=50&page="+String(page)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string:urlString)!
    return URLSession.shared.rx.json(url:url).map({(json:Any)->Observable<Any> in
        var observableStories = [Observable<Any>]()
        let result = json as! Dictionary<String,Any>
        let hits = result["hits"] as? [Dictionary<String,Any>]
        if hits != nil && !hits!.isEmpty{
            for i in hits!{
                let objectID = i["objectID"] as! String
                let storyURL = URL(string:"https://hacker-news.firebaseio.com/v0/item/"+objectID+".json")
                observableStories.append(URLSession.shared.rx.json(url:storyURL!))
            }
            let bigOb =  Observable.from(observableStories).concat()
            return bigOb.concat(createSearchStoriesObservableRecursive(searchTerm: searchTerm, order: order, page: page + 1))
        }else{
            //we need to return an observable that generates an unexpected object(not a json)
            //this way the observer knows that the search is finished
            //return an Observable.never or .empty will not cause the observer closure to get triggered
            //and the loading animation will never halt. The user will not know that the search has completed.
            return Observable.of(false)
        }
    }).flatMap({observable in
        return observable
    })
}
func createSearchStoriesObservable(searchTerm:String,order:SearchOrder)->Observable<Story?>{
    return mapStoriesObservable(observable: createSearchStoriesObservableRecursive(searchTerm: searchTerm, order: order, page: 0))
}
