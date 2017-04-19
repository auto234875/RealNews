//
//  LicensesViewController.swift
//  Real News
//
//  Created by PC on 4/19/17.
//  Copyright © 2017 PC. All rights reserved.
//

import Foundation
import UIKit

class LicensesViewController:UITableViewController{
    let licenseTableView = UITableView()
    var licenseViewModel = [License]()
    
    override func loadView() {
        view = licenseTableView
    }
    override func viewDidLoad() {
        licenseTableView.backgroundColor = UIColor.white
        licenseTableView.allowsSelection = false
        licenseViewModel = getLicensesViewModel(cellWidth: UIScreen.main.bounds.width - padding.totalTextHorizontal.rawValue * 2)
        licenseTableView.register(LicenseCell.self, forCellReuseIdentifier: "cell")
        licenseTableView.dataSource = self
        licenseTableView.delegate = self
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return licenseViewModel.count
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! LicenseCell
        let viewModel = licenseViewModel[indexPath.row]
        
        cell.name.attributedText = viewModel.name
        cell.content.attributedText = viewModel.content
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{
            return LicenseCell()
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return licenseViewModel[indexPath.row].rowHeight
    }

}
