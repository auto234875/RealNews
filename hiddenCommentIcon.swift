//
//  hiddenCommentIcon.swift
//  Real News
//
//  Created by John Smith on 2/2/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class HiddenCommentIcon:UIView{
    let horizontalCenterLineLayer = CAShapeLayer()
    let upperCenterVerticalLineLayer = CAShapeLayer()
    let lowerCenterVerticalLineLayer = CAShapeLayer()
    let rightBracketLayer = CAShapeLayer()
    let leftBracketLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.addSublayer(upperCenterVerticalLineLayer)
        layer.addSublayer(lowerCenterVerticalLineLayer)
        layer.addSublayer(horizontalCenterLineLayer)
        layer.addSublayer(leftBracketLayer)
        layer.addSublayer(rightBracketLayer)
    }
    func set(expand:Bool,animated:Bool){
        
        if expand{
            if animated {
                DispatchQueue.main.async(execute: {[weak self]()-> Void in
                    guard let weakself = self else{
                        return
                    }
                    weakself.animateExpand(duration: 0.4)
                    
                })
            }else{
                upperCenterVerticalLineLayer.strokeEnd = 0
                lowerCenterVerticalLineLayer.strokeEnd = 0
            }
        
        }else{
            if animated {
                DispatchQueue.main.async(execute: {[weak self]()-> Void in
                    guard let weakself = self else{
                        return
                    }
                    weakself.animateCollapse(duration: 0.4)
                    
                })
            }else{
                upperCenterVerticalLineLayer.strokeEnd = 1.0
                lowerCenterVerticalLineLayer.strokeEnd = 1.0
            }
        }

    }
    func animateCollapse(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        upperCenterVerticalLineLayer.strokeEnd = 1.0
        lowerCenterVerticalLineLayer.strokeEnd = 1.0
        upperCenterVerticalLineLayer.add(animation, forKey: "animateCollapse")
        lowerCenterVerticalLineLayer.add(animation, forKey: "animateCollapse")
    }
    func animateExpand(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 1
        animation.toValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        upperCenterVerticalLineLayer.strokeEnd = 0
        lowerCenterVerticalLineLayer.strokeEnd = 0
        upperCenterVerticalLineLayer.add(animation, forKey: "animateExpand")
        lowerCenterVerticalLineLayer.add(animation, forKey: "animateExpand")
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalCenterLine = UIBezierPath()
        let upperCenterVerticalLine = UIBezierPath()
        let lowerCenterVerticalLine = UIBezierPath()
        let leftBracketPath = UIBezierPath()
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        horizontalCenterLine.move(to: CGPoint(x: bounds.origin.x + 2, y: bounds.height/2))
        horizontalCenterLine.addLine(to: CGPoint(x: bounds.width - 2, y: bounds.height/2))
        upperCenterVerticalLine.move(to: center)
        upperCenterVerticalLine.addLine(to: CGPoint(x: center.x, y: 2))
        lowerCenterVerticalLine.move(to: center)
        lowerCenterVerticalLine.addLine(to: CGPoint(x: center.x, y: bounds.height - 2))
        leftBracketPath.move(to: CGPoint(x:3,y:0))
        leftBracketPath.addLine(to: .zero)
        leftBracketPath.move(to: .zero)
        leftBracketPath.addLine(to: CGPoint(x: 0, y: bounds.height))
        leftBracketPath.move(to: CGPoint(x: 0, y: bounds.height))
        leftBracketPath.addLine(to: CGPoint(x: 3, y: bounds.height))
        let mirrorOverXOrigin = CGAffineTransform(scaleX: -1.0, y: 1.0);
        let translate = CGAffineTransform(translationX: bounds.width, y: 0);
        let rightBracketPath = UIBezierPath(cgPath: leftBracketPath.cgPath)
        rightBracketPath.apply(mirrorOverXOrigin)
        rightBracketPath.apply(translate)
        horizontalCenterLineLayer.path = horizontalCenterLine.cgPath
        horizontalCenterLineLayer.fillColor = UIColor.black.cgColor
        horizontalCenterLineLayer.strokeColor = UIColor.black.cgColor
        horizontalCenterLineLayer.lineWidth = 1.0;
        horizontalCenterLineLayer.strokeEnd = 1.0
        upperCenterVerticalLineLayer.path = upperCenterVerticalLine.cgPath
        upperCenterVerticalLineLayer.fillColor = UIColor.black.cgColor
        upperCenterVerticalLineLayer.strokeColor = UIColor.appColor.cgColor
        upperCenterVerticalLineLayer.lineWidth = 1.0
        upperCenterVerticalLineLayer.strokeEnd = 0
        lowerCenterVerticalLineLayer.path = lowerCenterVerticalLine.cgPath
        lowerCenterVerticalLineLayer.fillColor = UIColor.black.cgColor
        lowerCenterVerticalLineLayer.strokeColor = UIColor.black.cgColor
        lowerCenterVerticalLineLayer.lineWidth = 1.0
        lowerCenterVerticalLineLayer.strokeEnd = 0
        leftBracketLayer.path = leftBracketPath.cgPath
        leftBracketLayer.fillColor = UIColor.black.cgColor
        leftBracketLayer.strokeColor = UIColor.black.cgColor
        leftBracketLayer.lineWidth = 1.0
        leftBracketLayer.strokeEnd = 1.0
        rightBracketLayer.path = rightBracketPath.cgPath
        rightBracketLayer.fillColor = UIColor.black.cgColor
        rightBracketLayer.strokeColor = UIColor.black.cgColor
        rightBracketLayer.lineWidth = 1.0
        rightBracketLayer.strokeEnd = 1.0
    }
}
