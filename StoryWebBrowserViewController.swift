//
//  StoryWebBrowserViewController.swift
//  Real News
//
//  Created by John Smith on 1/12/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import RxSwift
import RxCocoa
extension Reactive where Base: WKWebView {
    public var estimatedProgress: Observable<Double> {
        return self.observe(Double.self, "estimatedProgress")
            .map { $0 ?? 0.0 }
    }
    public var canGoBack: Observable<Bool> {
        return self.observe(Bool.self, "canGoBack").map { $0! ? true : false  }
    }
    public var canGoForward: Observable<Bool> {
        return self.observe(Bool.self, "canGoForward").map { $0! ? true : false  }
    }
}
class StoryWebBrowserViewController:UIViewController,WKUIDelegate{
    var url:String!
    var webView:WKWebView!
    var progressView = UIProgressView(progressViewStyle: .bar)
    var toolbar:WebViewToolBar!
    var story:Story?
    var disposeBag = DisposeBag()
    var progress:Variable<Float>!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewWillLayoutSubviews() {
        toolbar.frame = CGRect(x:0,y:view.bounds.height-44,width:view.bounds.width,height:44)
        progressView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 10)
    }
    
    override func viewDidLoad() {
        toolbar = WebViewToolBar(frame:.zero)
        toolbar.closeButton.rx.tap.subscribe(onNext:{Void in
            self.dismiss(animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
        
        toolbar.commentButton.rx.tap.subscribe(onNext:{[weak self]()->Void in
            guard let weakself = self else {
                return
            }
            let commentVC = CommentViewController()
            commentVC.story = weakself.story
            commentVC.showStory = false
            weakself.present(commentVC, animated: true, completion: nil)
        }).addDisposableTo(disposeBag)

        if story == nil{
            disableCommentButton()
        }else if story!.commentCount == nil{
            disableCommentButton()
        }else if story!.commentCount == 0{
            disableCommentButton()
        }else{
            let commentString = story!.commentCount! > 1 ? String(story!.commentCount!)+" comments" : String(story!.commentCount!)+" comment"
            let commentAttributedString = NSAttributedString(string: commentString, attributes: toolbar.attributes)
            toolbar.commentButton.setAttributedTitle(commentAttributedString, for: .normal)
        }
        
        view.addSubview(toolbar)
        view.addSubview(progressView)
        let myRequest = URLRequest(url: URL(string: url)!)
        webView.load(myRequest)
        
        webView.rx.canGoBack.subscribe(onNext:{[weak self] (canGoBack)->Void in
            guard let weakself = self else {
                return
            }
            weakself.toolbar.backButton.isEnabled = canGoBack
        }).addDisposableTo(disposeBag)
        
        webView.rx.canGoForward.subscribe(onNext:{[weak self] (canGoForward)->Void in
            guard let weakself = self else {
                return
            }
            weakself.toolbar.forwardButton.isEnabled = canGoForward
        }).addDisposableTo(disposeBag)
        
        toolbar.backButton.rx.tap.subscribe(onNext:{[weak self]()->Void in
            guard let weakself = self else {
                return
            }
            weakself.webView.goBack()
        }).addDisposableTo(disposeBag)
        
        toolbar.forwardButton.rx.tap.subscribe(onNext:{[weak self]()->Void in
            guard let weakself = self else {
                return
            }
            weakself.webView.goForward()
        }).addDisposableTo(disposeBag)
        
        toolbar.actionButton.rx.tap.subscribe(onNext:{[weak self]()->Void in
            guard let weakself = self else {
                return
            }
        
            let viewController = UIActivityViewController(activityItems: [weakself.webView.url!], applicationActivities: nil)
            weakself.present(viewController, animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
        
        webView.rx.estimatedProgress.subscribe(onNext:{[weak self](estimatedProgress)->Void in
            guard let weakself = self else {
                return
            }
            weakself.progressView.progress = Float(estimatedProgress)
            if estimatedProgress == 1.0{
                weakself.progressView.progress = 0
            }
        }).addDisposableTo(disposeBag)
    }
    func disableCommentButton(){
        toolbar.commentButton.isEnabled = false
        toolbar.commentButton.isHidden = true

    }
}
