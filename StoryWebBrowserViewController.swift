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
        progressView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: progressView.frame.height)
    }
    
    override func viewDidLoad() {
        progressView.progressTintColor = UIColor.turquoise
        toolbar = WebViewToolBar(frame:.zero)
        toolbar.closeButton.rx.tap.subscribe(onNext:{Void in
            self.dismiss(animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
        
        toolbar.commentButton.rx.tap.subscribe(onNext:{[unowned self]()->Void in
            let commentVC = CommentViewController()
            commentVC.story = self.story
            commentVC.showStory = false
            self.present(commentVC, animated: true, completion: nil)
        }).addDisposableTo(disposeBag)

        if story?.commentCount == nil{
            toolbar.commentButton.isEnabled = false
            toolbar.commentButton.isHidden = true
         }else{
            let commentString = story!.commentCount! > 1 ? String(story!.commentCount!)+" COMMENTS" : String(story!.commentCount!)+" COMMENT"
            let commentAttributedString = NSAttributedString(string: commentString, attributes: toolbar.attributes)
            toolbar.commentButton.setAttributedTitle(commentAttributedString, for: .normal)
        }
        
        view.addSubview(toolbar)
        view.addSubview(progressView)
        let myRequest = URLRequest(url: URL(string: url)!)
        webView.load(myRequest)
        
        webView.rx.canGoBack.subscribe(onNext:{[unowned self] (canGoBack)->Void in
            self.toolbar.backButton.isEnabled = canGoBack
            if canGoBack {
                self.toolbar.backButton.tintColor = UIColor.turquoise
            }else{
                self.toolbar.backButton.tintColor = UIColor.lightAppTextColor
            }
        }).addDisposableTo(disposeBag)
        
        webView.rx.canGoForward.subscribe(onNext:{[unowned self] (canGoForward)->Void in
            self.toolbar.forwardButton.isEnabled = canGoForward
            if canGoForward {
                self.toolbar.forwardButton.tintColor = UIColor.turquoise
            }else{
                self.toolbar.forwardButton.tintColor = UIColor.lightAppTextColor
            }
        }).addDisposableTo(disposeBag)
        
        toolbar.backButton.rx.tap.subscribe(onNext:{[unowned self]()->Void in
            self.webView.goBack()
        }).addDisposableTo(disposeBag)
        
        toolbar.forwardButton.rx.tap.subscribe(onNext:{[unowned self]()->Void in

            self.webView.goForward()
        }).addDisposableTo(disposeBag)
        
        toolbar.actionButton.rx.tap.subscribe(onNext:{[unowned self]()->Void in
            let viewController = UIActivityViewController(activityItems: [self.webView.url!], applicationActivities: nil)
            self.present(viewController, animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
        
        webView.rx.estimatedProgress.subscribe(onNext:{[unowned self](estimatedProgress)->Void in
            self.progressView.progress = Float(estimatedProgress)
            if estimatedProgress == 1.0{
                self.progressView.progress = 0
            }
        }).addDisposableTo(disposeBag)
    }
}
