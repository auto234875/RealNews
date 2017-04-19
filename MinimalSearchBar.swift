//
//  MinimalSearchBar.swift
//  Real News
//
//  Created by PC on 4/1/17.
//  Copyright © 2017 PC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class MinimalSearchBar:UIView{
    let rightTextButton = UIButton()
    let leftAccessoryButton = UIButton()
    let searchBar = UITextField()
    let bottomBorderView = UIView()
    let disposeBag = DisposeBag()
    let isActive:Variable<Bool> = Variable(false)
    let text:Variable<String> = Variable("")
    let pause:Variable<Bool> = Variable(false)

    override init(frame:CGRect){
        super.init(frame: frame)
        leftAccessoryButton.setImage(UIImage(named:"setting")!.withRenderingMode(.alwaysTemplate), for: .normal)
        leftAccessoryButton.tintColor = UIColor.turquoise
        let rightTextButtonAttributes:[String:Any] = [NSForegroundColorAttributeName:UIColor.turquoise,NSFontAttributeName:UIFont.standard]
        let rightText = NSAttributedString(string: "SEARCH", attributes: rightTextButtonAttributes)
        rightTextButton.setAttributedTitle(rightText, for: .normal)
        backgroundColor = UIColor.clear
        bottomBorderView.backgroundColor = UIColor.lightGray
        searchBar.font = UIFont.standard
        searchBar.textColor = UIColor.appTextColor
        searchBar.placeholder = "search stories"
        searchBar.clearButtonMode = .whileEditing
        
        searchBar.tintColor = UIColor.appTextColor
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.addSubview(bottomBorderView)
        //leftAccessoryButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        addSubview(searchBar)
        addSubview(rightTextButton)
        addSubview(leftAccessoryButton)
        
        searchBar.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext:{[unowned self]()->Void in
            if !self.isActive.value{
                self.isActive.value = true
            }
        }).addDisposableTo(disposeBag)
        
        searchBar.rx.text
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] text in
                guard let unwrappedText = text else {
                    return
                }
                if self.text.value != unwrappedText {
                    self.text.value = unwrappedText
                }
        }).addDisposableTo(disposeBag)
        
        rightTextButton.rx.tap.subscribe(onNext:{[unowned self]()->Void in
            self.isActive.value = !self.isActive.value
        }).addDisposableTo(disposeBag)
        
        
        isActive.asObservable().subscribe(onNext:{[unowned self](isActive)->Void in
            
            UIView.transition(with: self.rightTextButton, duration: 0.1, options:.transitionFlipFromBottom, animations: {
                var rightText:String
                if self.isActive.value{
                    rightText = "CANCEL"
                }else{
                    self.searchBar.text = nil
                    rightText = "SEARCH"
                }
                self.rightTextButton.setAttributedTitle(NSAttributedString(string: rightText, attributes: rightTextButtonAttributes), for: .normal)
                self.layoutSubviews()
            }, completion: {[unowned self](complete)->Void in
                if self.isActive.value{
                    self.searchBar.becomeFirstResponder()
                }else{
                    self.searchBar.resignFirstResponder()
                }
            })
        }).addDisposableTo(disposeBag)
        
        pause.asObservable().subscribe(onNext:{[unowned self](pause)->Void in
                self.searchBar.resignFirstResponder()
        }).addDisposableTo(disposeBag)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rightButtonSize = rightTextButton.intrinsicContentSize
        if !isActive.value {
            leftAccessoryButton.frame = CGRect(x: 0, y: 0, width: 44 + padding.totalTextHorizontal.rawValue, height: bounds.height)
            searchBar.frame = CGRect(x: leftAccessoryButton.frame.maxX, y: 0, width: bounds.width - (rightButtonSize.width + leftAccessoryButton.frame.width+padding.totalTextHorizontal.rawValue), height: bounds.height)
            
        }else{
            leftAccessoryButton.frame = CGRect(x: 0, y: 0, width: 0, height: bounds.height)
            searchBar.frame = CGRect(x: padding.totalTextHorizontal.rawValue, y: 0, width: bounds.width - (rightButtonSize.width+padding.totalTextHorizontal.rawValue*2), height: bounds.height)
        }
        bottomBorderView.frame = CGRect(x: 0, y: searchBar.bounds.height - 10, width: searchBar.frame.width, height: 0.5)
        rightTextButton.frame = CGRect(x: searchBar.frame.maxX, y: 0, width: rightButtonSize.width, height: bounds.height)
        
        

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
