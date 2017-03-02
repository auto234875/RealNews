//
//  SavedStoriesViewController.swift
//  Real News
//
//  Created by John Smith on 2/8/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SavedStoriesViewController:StoriesViewController{
    
    override func viewDidLoad() {
        UserDefaults.standard.rx.observe([Int].self, "savedStoriesID").subscribe(onNext:{[weak self](value)->Void in
            guard let weakself = self else{
                return
            }
            weakself.syncSavedStories(weakself:weakself,oldValue: weakself.savedStoriesID, newValue: value)
        }).addDisposableTo(disposeBag)
    }
    func addStory(weakself:SavedStoriesViewController,id:Int){
        if weakself.savedStoriesID == nil {
            weakself.savedStoriesID = [id]
        }else{
            weakself.savedStoriesID!.append(id)
        }
        let index = weakself.savedStoriesID!.endIndex - 1
        newStory(cellWidth: UIScreen.main.bounds.width - padding.cell.rawValue*2,id:[id]).subscribe(onNext:{(story:StoryCellViewModel)->Void in
            DispatchQueue.main.async(execute: {[weak self]()->Void in
                guard let weakself = self else{
                    return
                }
                weakself.Stories.insert(story, at: index)
                weakself.storiesTableView.insertRows(at: [IndexPath.init(row:index,section:0)], with:UITableViewRowAnimation.none)
            })}).addDisposableTo(disposeBag)
    }
    func removeStory(weakself:SavedStoriesViewController,deleteIndex:Int){
        weakself.savedStoriesID!.remove(at: deleteIndex)
        weakself.Stories.remove(at: deleteIndex)
        weakself.storiesTableView.beginUpdates()
        weakself.storiesTableView.deleteRows(at: [IndexPath(row:deleteIndex,section:0)], with: .left)
        weakself.storiesTableView.endUpdates()
    }
    func removeAllStories(weakself:SavedStoriesViewController){
        weakself.Stories.removeAll()
        weakself.storiesTableView.reloadData()
        weakself.savedStoriesID = nil
        return
    }
    func syncSavedStories(weakself:SavedStoriesViewController,oldValue:[Int]?,newValue:[Int]?){
        guard let newValue = newValue else{
            weakself.removeAllStories(weakself:weakself)
            return
        }
        if newValue.count == 0 {
            weakself.removeAllStories(weakself:weakself)
            return
        }
        guard let oldValue = oldValue else{
            for i in newValue{
                weakself.addStory(weakself:weakself,id:i)
            }
            return
        }
        if newValue == oldValue {
            return
        }
        if oldValue.count > newValue.count {
            let index = oldValue.index(where: {id in
                return newValue.contains(id) ? false : true
            })!
            weakself.removeStory(weakself: weakself, deleteIndex: index)
        }else{
            weakself.addStory(weakself: weakself, id: newValue[newValue.endIndex - 1])
        }
    }
}
