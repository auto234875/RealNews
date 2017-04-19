//
//  AboutViewController.swift
//  Real News
//
//  Created by John Smith on 2/19/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import MessageUI
class AboutViewController:UIViewController,MFMailComposeViewControllerDelegate{
    let aboutView = AboutView()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        view.addSubview(aboutView)
        aboutView.hireMeGesture.rx.methodInvoked(#selector(touchesBegan(_:with:))).subscribe(onNext:{[unowned self](event)->Void in
            if !MFMailComposeViewController.canSendMail() {
                return
            }
            let composeVC = MFMailComposeViewController()
            composeVC.setToRecipients(["auto234875@gmail.com"])
            self.present(composeVC, animated: true, completion: nil)
            composeVC.mailComposeDelegate = self
        }).addDisposableTo(disposeBag)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        aboutView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height-tabBarController!.tabBar.frame.height)
    }
}
