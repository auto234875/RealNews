//
//  CommentViewController.swift
//  Real News
//
//  Created by John Smith on 1/20/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class CommentViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    var commentTableView = UITableView()
    let refreshControl = UIRefreshControl()
    var commentViewModel=[CommentViewModel]()
    var story:Story!
    var toolbar:CommentToolBar!
    var progressView = UIProgressView(progressViewStyle: .bar)
    var showStory:Bool!
    let disposeBag = DisposeBag()
    var commentsDisposable:Disposable?
    override func viewDidLoad() {
        toolbar = CommentToolBar(frame:.zero)
        refreshControl.tintColor = UIColor.appColor
        commentTableView.addSubview(refreshControl)
        commentTableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        commentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyCommentCell")
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.backgroundColor = UIColor.clear
        commentTableView.separatorColor = UIColor.clear
        
        toolbar.closeButton.rx.tap.subscribe(onNext:{[weak self]()->Void in
            guard let weakself = self else{
                return
            }
            if weakself.commentsDisposable != nil{
                weakself.commentsDisposable!.dispose()
            }
            weakself.dismiss(animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
        
        toolbar.storyButton.rx.tap.subscribe(onNext:{[weak self]()->Void in
            guard let weakself = self else{
                return
            }
            let destination = StoryWebBrowserViewController()
            destination.url = weakself.story.url
            weakself.present(destination, animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
        
        if story.url == nil || showStory == false{
            toolbar.storyButton.isEnabled = false
            toolbar.storyButton.isHidden = true
        }
        let backgroundView = UIImageView(image: UIImage(named: "storiesBackground"))
        backgroundView.contentMode = .scaleAspectFill
        view.addSubview(backgroundView)
        view.addSubview(progressView)
        view.addSubview(toolbar)
        view.addSubview(commentTableView)
        
        self.commentsDisposable = loadComments()
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext:{
            DispatchQueue.main.async(execute: {[weak self]()->Void in
                guard let weakself = self else {
                    return
                }
                if weakself.commentsDisposable != nil{
                    weakself.commentsDisposable!.dispose()
                }
                weakself.commentViewModel.removeAll()
                weakself.commentTableView.reloadData()
                weakself.commentsDisposable = weakself.loadComments()
                weakself.refreshControl.endRefreshing()
            })
        }).addDisposableTo(disposeBag)
    }
    
    func loadComments()->Disposable{
        let commentsDisposable = newComment(cellWidth: UIScreen.main.bounds.width,story:story).subscribe(onNext:{(comment:CommentViewModel?)->Void in
            if comment == nil {
                return
            }
            DispatchQueue.main.async(execute: {[weak self]()-> Void in
                guard let weakself = self else{
                    return
                }
                weakself.commentViewModel.append(comment!)
                weakself.commentTableView.reloadData()
                guard let commentCount = weakself.story.commentCount else{
                    return
                }
                weakself.progressView.progress = Float(weakself.commentViewModel.count)/Float(commentCount)
            })
        },onCompleted:{
            DispatchQueue.main.async(execute: {[weak self]()-> Void in
                guard let weakself = self else{
                    return
                }
                weakself.progressView.progress = 0
            })
        })
        return commentsDisposable
    }
    override func viewWillLayoutSubviews() {
        progressView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 10)
        toolbar.frame = CGRect(x:0,y:view.bounds.height-44,width:view.bounds.width,height:44)
        commentTableView.frame = CGRect(x:0,y:progressView.frame.height,width:view.bounds.width,height:view.bounds.height-(toolbar.frame.height+progressView.frame.height))
    }

   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentViewModel.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.reuseIdentifier! == "EmptyCommentCell"{
            cell.isHidden = true
            return
        }
        let commentCell = cell as! CommentCell
        let comment = commentViewModel[indexPath.row]
        commentCell.indentationLevel = comment.level
        commentCell.authorLabel.attributedText = comment.authorAttributedText
        commentCell.timeLabel.attributedText = comment.timeAttributedText
        if comment.collapsed{
            if comment.expanded{
                commentCell.set(expand:false,animated:true)
                commentViewModel[indexPath.row].expanded = false
            }else{
                commentCell.set(expand: false, animated: false)
            }
            commentCell.commentLabel.attributedText = nil
            commentCell.replyLabel.attributedText = comment.replyAttributedText
            
        }else {
            if comment.expanded == false {
                commentCell.set(expand: true, animated: true)
                commentViewModel[indexPath.row].expanded = true
            }
            commentCell.commentLabel.attributedText = comment.commentAttributedText
            commentCell.replyLabel.attributedText = nil
            }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if commentViewModel[indexPath.row].completeCollapsed {
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCommentCell")!
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let comment = commentViewModel[indexPath.row]
        if comment.completeCollapsed{
            return 0
        }else if comment.collapsed{
            return comment.collapsedRowHeight
        }
        return comment.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if commentViewModel[indexPath.row].collapsed {
            toggleComments(tableView, indexPath: indexPath, collapsed: false)
            return
        }
        
        toggleComments(tableView, indexPath: indexPath, collapsed: true)
    }
    
    func toggleComments(_ tableView:UITableView,indexPath:IndexPath,collapsed:Bool){
        var rowsArray = [indexPath]
        guard let children = findChildrenComments(commentViewModel[indexPath.row].comment.kids,index:indexPath.row) else{
            toggleRowHeight(tableView, indexPath: rowsArray, collapsed: collapsed)
            return
        }
        rowsArray = rowsArray + children
        toggleRowHeight(tableView, indexPath: rowsArray, collapsed: collapsed)
    }
    
    func findChildrenComments(_ kids:[Int]?,index:Int)->[IndexPath]?{
        if kids == nil{
            return nil
        }
        var children = [IndexPath]()
        for i in index...commentViewModel.count-1{
            let comment = commentViewModel[i].comment
            if kids!.contains(comment.id){
                children.append(IndexPath(row: i, section: 0))

                guard let kidsIndexPath = findChildrenComments(comment.kids,index:i) else{
                    continue
                }
                children = children + kidsIndexPath
            }
    }
        return children.count == 0 ? nil : children
    }
    func toggleRowHeight(_ tableView:UITableView,indexPath:[IndexPath],collapsed:Bool){
        commentViewModel[indexPath[0].row].collapsed = collapsed
        if indexPath.count > 1{
            for i in 1...indexPath.count-1{
                commentViewModel[indexPath[i].row].completeCollapsed = collapsed
            }
        }
        tableView.reloadData()
    }
    
}
