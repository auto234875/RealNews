//
//  HNSearchBar.swift
//  Real News
//
//  Created by PC on 4/14/17.
//  Copyright © 2017 PC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HNSearchBar:MinimalSearchBar{
    let enable = Variable(false)
    let searchOptionTitle = Variable("")
    let showSearchSettings = Variable(false)
    private let alternateView = UIView()
    private let searchOption = UILabel()
    private let optionOneButton = UIButton()
    private let optionTwoButton = UIButton()
    let searchOrder = Variable(SearchOrder.popular)
    override init(frame:CGRect){
        super.init(frame: frame)
        enable.asObservable().subscribe(onNext:{[unowned self](enable)->Void in
            self.rightTextButton.isUserInteractionEnabled = enable
            self.leftAccessoryButton.isUserInteractionEnabled = enable
            self.searchBar.isUserInteractionEnabled = enable
        }).addDisposableTo(disposeBag)
        
        alternateView.backgroundColor = UIColor.clear
        addSubview(alternateView)
        
        leftAccessoryButton.rx.tap.subscribe(onNext:{[unowned self]()->Void in
            self.showSearchSettings.value = true
        }).addDisposableTo(disposeBag)
        
        optionOneButton.layer.cornerRadius = 5
        optionTwoButton.layer.cornerRadius = 5
        searchOption.textColor = UIColor.appTextColor
        searchOption.font = UIFont.detail
        searchOptionTitle.asObservable().subscribe(onNext:{[unowned self](title)->Void in
            self.searchOption.text = title
        }).addDisposableTo(disposeBag)
        
        showSearchSettings.asObservable().subscribe(onNext:{[unowned self](show)->Void in
            if show{
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn,animations: {
                    self.layoutSubviews()
                }, completion: {(complete)->Void in
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut,animations: {
                        let searchOptionSize = self.searchOption.intrinsicContentSize
                        let optionButtonWidth = (self.bounds.width - searchOptionSize.width - padding.genericDouble.rawValue - padding.totalTextHorizontal.rawValue*2)/2
                        self.searchOption.frame = CGRect(x: padding.totalTextHorizontal.rawValue, y: 0, width: searchOptionSize.width, height: self.bounds.height)
                        self.optionOneButton.frame = CGRect(x: padding.totalTextHorizontal.rawValue + searchOptionSize.width + padding.generic.rawValue, y: padding.cell.rawValue, width: optionButtonWidth, height: self.bounds.height - padding.cellDouble.rawValue)
                        self.optionTwoButton.frame = CGRect(x: padding.totalTextHorizontal.rawValue + searchOptionSize.width + padding.genericDouble.rawValue + optionButtonWidth, y: padding.cell.rawValue, width: optionButtonWidth, height: self.bounds.height - padding.cellDouble.rawValue)
                    }, completion: nil)
                })
            }else{
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn,animations: {
                    self.hideSearchOption()
                }, completion: {(complete)->Void in
                    if complete{
                        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut,animations: {
                            self.layoutSubviews()
                        }, completion: nil)
                    }
                })
            }
        }).addDisposableTo(disposeBag)
        alternateView.addSubview(searchOption)
        
        let buttonNormalAttributes:[String:Any] = [NSForegroundColorAttributeName:UIColor.turquoise,NSFontAttributeName:UIFont.detail]
        let buttonSelectedAttributes:[String:Any] = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.detail]
        let buttonOneNormalAttributedString = NSAttributedString(string: "POPULAR", attributes: buttonNormalAttributes)
        let buttonOneSelectedAttributedString = NSAttributedString(string: "POPULAR", attributes: buttonSelectedAttributes)
        let buttonTwoNormalAttributedString = NSAttributedString(string: "RECENT", attributes: buttonNormalAttributes)
        let buttonTwoSelectedAttributedString = NSAttributedString(string: "RECENT", attributes: buttonSelectedAttributes)
        optionOneButton.backgroundColor = UIColor.turquoise
        optionOneButton.setAttributedTitle(buttonOneSelectedAttributedString, for: .normal)
        optionOneButton.layer.borderColor = UIColor.turquoise.cgColor
        optionOneButton.layer.borderWidth = 1.0
        alternateView.addSubview(optionOneButton)
        optionTwoButton.backgroundColor = UIColor.clear
        optionTwoButton.setAttributedTitle(buttonTwoNormalAttributedString, for: .normal)
        optionTwoButton.layer.borderColor = UIColor.turquoise.cgColor
        optionTwoButton.layer.borderWidth = 1.0
        alternateView.addSubview(optionTwoButton)
        
        optionOneButton.rx.tap.subscribe(onNext:{[unowned self]()->Void in
            if self.optionOneButton.backgroundColor == UIColor.clear{
                self.searchOrder.value = .popular
                UIView.animate(withDuration:0.1, delay: 0, options: .curveEaseIn,animations: {
                    self.optionOneButton.setAttributedTitle(buttonOneSelectedAttributedString, for: .normal)
                    self.optionTwoButton.setAttributedTitle(buttonTwoNormalAttributedString, for: .normal)
                    self.optionOneButton.backgroundColor = UIColor.turquoise
                    self.optionTwoButton.backgroundColor = UIColor.clear
                }, completion: {(complete)->Void in
                    self.showSearchSettings.value = false
                })
            }else{
            self.showSearchSettings.value = false
            }
        }).addDisposableTo(disposeBag)
        
        optionTwoButton.rx.tap.subscribe(onNext:{[unowned self]()->Void in
            if self.optionTwoButton.backgroundColor == UIColor.clear{
                self.searchOrder.value = .recent
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn,animations: {
                    self.optionOneButton.setAttributedTitle(buttonOneNormalAttributedString, for: .normal)
                    self.optionTwoButton.setAttributedTitle(buttonTwoSelectedAttributedString, for: .normal)
                    self.optionTwoButton.backgroundColor = UIColor.turquoise
                    self.optionOneButton.backgroundColor = UIColor.clear
                }, completion: {(complete)->Void in
                    self.showSearchSettings.value = false
                })
            }else{
            self.showSearchSettings.value = false
            }
        }).addDisposableTo(disposeBag)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        if !showSearchSettings.value {
            alternateView.frame = .zero
            hideSearchOption()
            return
        }
        alternateView.frame = bounds
        leftAccessoryButton.frame = CGRect(x: leftAccessoryButton.frame.origin.x, y: leftAccessoryButton.frame.origin.y, width: 0, height: leftAccessoryButton.frame.height)
        rightTextButton.frame = CGRect(x:rightTextButton.frame.origin.x, y: rightTextButton.frame.origin.y, width: 0, height: rightTextButton.frame.height)
        bottomBorderView.frame = CGRect(x: bottomBorderView.frame.origin.x, y: bottomBorderView.frame.origin.y, width: 0, height: bottomBorderView.frame.height)
        searchBar.frame = CGRect(x: searchBar.frame.origin.x, y: searchBar.frame.origin.y, width: 0, height: searchBar.frame.height)
    }
    func hideSearchOption(){
        let searchOptionSize = searchOption.intrinsicContentSize
        let optionButtonWidth = (bounds.width - searchOptionSize.width - padding.genericDouble.rawValue - padding.totalTextHorizontal.rawValue*2)/2
        self.searchOption.frame = CGRect(x: padding.totalTextHorizontal.rawValue, y: 0, width: 0, height: self.bounds.height)
        self.optionOneButton.frame = CGRect(x: padding.totalTextHorizontal.rawValue + searchOptionSize.width + padding.generic.rawValue, y: padding.cell.rawValue, width: 0, height: self.bounds.height - padding.cellDouble.rawValue)
        self.optionTwoButton.frame = CGRect(x: padding.totalTextHorizontal.rawValue + searchOptionSize.width + padding.genericDouble.rawValue + optionButtonWidth, y: padding.cell.rawValue, width: 0, height: self.bounds.height - padding.cellDouble.rawValue)
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
