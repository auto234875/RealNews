//
//  SimpleTabBarViewController.swift
//  Real News
//
//  Created by John Smith on 1/12/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit


class SimpleTabBarViewController:UITabBarController,UIViewControllerTransitioningDelegate,UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate{
    var originFrame:CGRect!
    var moreNavigationControllerDataSource:UITableViewDataSource?
    var moreNavigationControllerDelegate:UITableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor.black
        transitioningDelegate = self
        modalPresentationStyle = UIModalPresentationStyle.custom
        let tableView = moreNavigationController.topViewController!.view as! UITableView
        moreNavigationController.navigationBar.isHidden = true
        moreNavigationControllerDataSource = tableView.dataSource
        moreNavigationControllerDelegate = tableView.delegate
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clear
        tableView.backgroundView = UIImageView(image: UIImage(named: "storiesBackground"))
        tableView.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreNavigationControllerDataSource!.tableView(tableView, numberOfRowsInSection: section)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ViewControllerCell else{
            return
        }
        let infoCell = UITableViewCell()
        moreNavigationControllerDelegate!.tableView!(tableView, willDisplay:infoCell, forRowAt: indexPath)
        let title = infoCell.textLabel!.text
        let attributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.systemFont(ofSize: 20)]
        cell.viewControllerLabel.attributedText = NSAttributedString(string: title!, attributes: attributes)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moreNavigationControllerDelegate!.tableView!(tableView, didSelectRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ViewControllerCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.selectedViewController{
            guard let viewController = viewController as? StoriesViewController else{
                return true
            }
            viewController.storiesTableView.setContentOffset(.zero, animated: true)
        }
        return true
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) ->UIViewControllerAnimatedTransitioning? {
        return SplitFadeAnimator(withDuration: 0.3, forTransitionType: TransitionType.Presenting, originFrame: self.originFrame)
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SplitFadeAnimator(withDuration: 0.3, forTransitionType: TransitionType.Dismissing, originFrame: self.originFrame)
    }
}
