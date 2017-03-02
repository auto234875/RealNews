//
//  CommentButton.swift
//  Real News
//
//  Created by John Smith on 2/4/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class OptionButton:UIButton{
    let squareLayer = CAShapeLayer()
    let arrowLayer = CAShapeLayer()
    var iconFrame:CGRect!
    var color = UIColor.appColor
    override init(frame:CGRect) {
        super.init(frame:frame)
        layer.addSublayer(squareLayer)
        layer.addSublayer(arrowLayer)
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func set(fire:Bool){
        
        if fire{
                let transform = CGAffineTransform.identity.translatedBy(x: 0, y: -iconFrame.height/3)
                arrowLayer.setAffineTransform(transform)
        }else{
            let transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
            arrowLayer.setAffineTransform(transform)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let squarePath = UIBezierPath()
        let arrowHalfGap = iconFrame.width/6
        let squareOriginHeight = iconFrame.origin.y + (iconFrame.height/3)
        let squareBottom = iconFrame.origin.y+iconFrame.height
        let squareRight = iconFrame.origin.x+iconFrame.width
        let squareMidX = iconFrame.origin.x+(iconFrame.width/2)
        squarePath.move(to: CGPoint(x: iconFrame.origin.x+(iconFrame.width/2 - arrowHalfGap), y: squareOriginHeight))
        squarePath.addLine(to: CGPoint(x: iconFrame.origin.x, y: squareOriginHeight))
        squarePath.move(to: CGPoint(x: iconFrame.origin.x, y: squareOriginHeight))
        squarePath.addLine(to: CGPoint(x: iconFrame.origin.x, y: squareBottom))
        squarePath.move(to: CGPoint(x: iconFrame.origin.x, y: squareBottom))
        squarePath.addLine(to: CGPoint(x: squareRight, y: squareBottom))
        squarePath.move(to: CGPoint(x: squareRight, y: squareBottom))
        squarePath.addLine(to: CGPoint(x: squareRight, y: squareOriginHeight))
        squarePath.move(to: CGPoint(x: squareRight, y: squareOriginHeight))
        squarePath.addLine(to: CGPoint(x: iconFrame.origin.x+(iconFrame.width/2 + arrowHalfGap), y: squareOriginHeight))
        let arrowPath = UIBezierPath()
        
        arrowPath.move(to: CGPoint(x: squareMidX, y: iconFrame.origin.y+iconFrame.height/10))
        arrowPath.addLine(to: CGPoint(x: squareMidX, y: iconFrame.origin.y+(iconFrame.height/3) * 2))
        arrowPath.move(to: CGPoint(x: squareMidX,   y: iconFrame.origin.y+iconFrame.height/10))
        arrowPath.addLine(to: CGPoint(x:iconFrame.origin.x+(iconFrame.width/3.5),y:iconFrame.origin.y+iconFrame.height/4.5))
        arrowPath.move(to: CGPoint(x: squareMidX, y:iconFrame.origin.y+iconFrame.height/10))
        arrowPath.addLine(to: CGPoint(x:iconFrame.origin.x+(iconFrame.width) - (iconFrame.width/3.5),y:iconFrame.origin.y+iconFrame.height/4.5))
        
        squareLayer.path = squarePath.cgPath
        //squareLayer.fillColor = UIColor.appBackgroundColor.cgColor
        squareLayer.fillColor = UIColor.clear.cgColor
        squareLayer.strokeColor = color.cgColor
        squareLayer.lineWidth = 1.0
        squareLayer.strokeEnd = 1.0
        arrowLayer.path = arrowPath.cgPath
        //arrowLayer.fillColor = UIColor.appBackgroundColor.cgColor
        arrowLayer.fillColor = UIColor.clear.cgColor
        arrowLayer.strokeColor = color.cgColor
        arrowLayer.lineWidth = 1.0
        arrowLayer.strokeEnd = 1.0
    }
    
}
