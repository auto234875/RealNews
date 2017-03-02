//
//  UIView+Extension.swift
//  Real News
//
//  Created by John Smith on 1/15/17.
//  Copyright © 2017 John Smith. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func snapshot() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
func split_image(_ image:UIImage,atDistance:CGFloat,edge:CGRectEdge,scale:CGFloat)->(CGImage,CGImage){
    let imageFrame = CGRect(x: 0, y: 0, width: image.size.width*scale, height: image.size.height*scale)
    let frames = imageFrame.divided(atDistance: atDistance*scale, from: .minYEdge)
    let slice = image.cgImage!.cropping(to: frames.slice)!
    let remainder = image.cgImage!.cropping(to: frames.remainder)!
    return(slice,remainder)
}

