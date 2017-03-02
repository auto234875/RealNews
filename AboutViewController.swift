//
//  AboutViewController.swift
//  Real News
//
//  Created by John Smith on 2/19/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit
class AboutViewController:UIViewController{
    let aboutView = AboutView()
    
    override func viewDidLoad() {
        let backgroundView = UIImageView(image: UIImage(named: "storiesBackground"))
        backgroundView.contentMode = .scaleAspectFill
        view.addSubview(backgroundView)
        view.addSubview(aboutView)
    }
    
    override func viewWillLayoutSubviews() {
        aboutView.frame = CGRect(x: padding.cell.rawValue, y: padding.cell.rawValue, width: view.bounds.width-(padding.cell.rawValue*2), height: view.bounds.height-(padding.cell.rawValue*2)-tabBarController!.tabBar.frame.height)
    }
}
