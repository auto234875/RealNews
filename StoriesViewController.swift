//
//  StoriesViewController.swift
//  Real News
//
//  Created by John Smith on 12/30/16.
//  Copyright © 2016 John Smith. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class StoriesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate{
    var savedStoriesID:[Int]?
    var originFrame:CGRect?
    var Stories:[StoryCellViewModel?] = [StoryCellViewModel?]()
    let disposeBag = DisposeBag()
    let storiesTableView = UITableView()
    let refreshControl = UIRefreshControl()
    var storyDisposable:Disposable!
    var storiesType:StoriesType! {
        didSet{
            title = storiesType.title
            tabBarItem.image = storiesType.icon
            
        }
    }
    override func loadView() {
        storiesTableView.register(StoryCell.self, forCellReuseIdentifier: "StoryCell")
        storiesTableView.delegate = self
        storiesTableView.dataSource = self
        storiesTableView.backgroundView = UIImageView(image: UIImage(named: "storiesBackground"))
        storiesTableView.separatorColor = UIColor.clear
        view = storiesTableView
    }
    override func viewDidLoad() {
        UserDefaults.standard.rx.observe([Int].self, "savedStoriesID").subscribe(onNext:{[weak self](value)->Void in
            self!.savedStoriesID = value
        }).addDisposableTo(disposeBag)
        
        storyDisposable = loadStories()
        refreshControl.tintColor = UIColor.appColor
        storiesTableView.addSubview(refreshControl)
        
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext:{
            DispatchQueue.main.async(execute: {[weak self]()->Void in
                guard let weakself = self else {
                    return
                }
                weakself.storyDisposable.dispose()
                weakself.Stories.removeAll()
                weakself.storiesTableView.reloadData()
                weakself.storyDisposable = weakself.loadStories()
                weakself.refreshControl.endRefreshing()
            })
        }).addDisposableTo(disposeBag)
    }
    
    func loadStories()->Disposable{
        let storyDisposable = newStory(cellWidth: UIScreen.main.bounds.width - padding.cell.rawValue*2,type:storiesType).subscribe(onNext:{(story:StoryCellViewModel)->Void in
            DispatchQueue.main.async(execute: {[weak self]()->Void in
                guard let weakself = self else {
                    return
                }
                weakself.Stories.insert(story, at: story.story.index)
                weakself.storiesTableView.reloadData()
            })
        })
        return storyDisposable
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Stories.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! StoryCell
        let viewModel = Stories[indexPath.row]!
        
        cell.titleLabel.attributedText = viewModel.titleAttributedText
        cell.authorLabel.attributedText = viewModel.authorAttributedText
        cell.timeLabel.attributedText = viewModel.timeAttributedText
        cell.commentCountLabel.attributedText = viewModel.commentCount
        
        cell.optionButton.rx.tap.subscribe(onNext:{Void in
            DispatchQueue.main.async(execute: {[weak self]()->Void in
                guard let weakself = self else{
                    return
                }
                cell.optionButton.set(fire: true)
                let option = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action)->Void in
                    cell.optionButton.set(fire: false)
                })
                option.addAction(cancel)
                if viewModel.commentCount != nil {
                    let showComment = UIAlertAction(title: "View Comments", style: .default, handler: {(action)->Void in
                        let cellRect = tableView.rectForRow(at: indexPath).offsetBy(dx: -tableView.contentOffset.x, dy: -tableView.contentOffset.y)
                        cell.optionButton.set(fire: false)
                        weakself.presentCommentViewController(cellRect: cellRect, story: viewModel.story)
                        
                    })
                    option.addAction(showComment)
                }
                guard let savedStoriesID = weakself.savedStoriesID else {
                    weakself.addSaveStoryOption(weakself: weakself, option: option, id: viewModel.story.id,cell:cell)
                    weakself.present(option, animated: true, completion: nil)
                    return
                }
                
                if savedStoriesID.contains(viewModel.story.id){
                    weakself.addDeleteStoryOption(weakself: weakself, option: option, id: viewModel.story.id, cell: cell, savedStoriesID: savedStoriesID)
                }else{
                    weakself.addSaveStoryOption(weakself: weakself, option: option, id: viewModel.story.id,cell:cell)
                }
                weakself.present(option, animated: true, completion: nil)
                
            })
        }).addDisposableTo(cell.disposeBag)

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "StoryCell")! as! StoryCell
    }
    func addDeleteStoryOption (weakself:StoriesViewController,option:UIAlertController,id:Int,cell:StoryCell,savedStoriesID:[Int]){
        let removeStory = UIAlertAction(title: "Delete Story", style: .default, handler: {(action)->Void in
        let index = savedStoriesID.index(where: {matchingID in
                return matchingID == id ? true : false
        })!
        var tempStoriesID = savedStoriesID
        tempStoriesID.remove(at: index)
        UserDefaults.standard.set(tempStoriesID, forKey: "savedStoriesID")
            cell.optionButton.set(fire: false)
        })
        option.addAction(removeStory)
    }
    func addSaveStoryOption (weakself:StoriesViewController,option:UIAlertController,id:Int,cell:StoryCell){
        let saveStory = UIAlertAction(title: "Save Story", style: .default, handler: {(action)->Void in
            
            guard let tempStoriesID = weakself.savedStoriesID else{
                UserDefaults.standard.set([id], forKey: "savedStoriesID")
                cell.optionButton.set(fire: false)
                return
            }
            UserDefaults.standard.set(tempStoriesID+[id], forKey: "savedStoriesID")
            cell.optionButton.set(fire: false)
            return
        })
        option.addAction(saveStory)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Stories.count == 0 || Stories[indexPath.row] == nil{
            return 0
        }
        
        return Stories[indexPath.row]!.rowHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewModel = Stories[indexPath.row]!
        let cellRect = tableView.rectForRow(at: indexPath).offsetBy(dx: -tableView.contentOffset.x, dy: -tableView.contentOffset.y)
        
        guard let url = viewModel.story.url else{
            presentCommentViewController(cellRect: cellRect, story: viewModel.story)
            return
        }
        
        let destination = StoryWebBrowserViewController()
        destination.url = url
        destination.story = viewModel.story
        destination.transitioningDelegate = tabBarController! as! SimpleTabBarViewController
        (tabBarController! as! SimpleTabBarViewController).originFrame = cellRect
        destination.modalPresentationStyle = UIModalPresentationStyle.custom
        present(destination, animated: true, completion: nil)
    }
    func presentCommentViewController(cellRect:CGRect,story:Story){
        let commentVC = CommentViewController()
        commentVC.story = story
        commentVC.showStory = true
        commentVC.transitioningDelegate = self.tabBarController! as! SimpleTabBarViewController
        (commentVC.transitioningDelegate as! SimpleTabBarViewController).originFrame = cellRect
        self.present(commentVC, animated: true, completion: nil)
    }
    
        
}
