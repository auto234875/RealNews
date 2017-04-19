//
//  enum.swift
//  Real News
//
//  Created by PC on 4/1/17.
//  Copyright © 2017 PC. All rights reserved.
//

import Foundation
import UIKit

enum padding:CGFloat{
    case cell = 5.0//space between cell contentview and mainview
    case cellDouble = 10.0//cell*2
    case generic = 15.0//space between mainview and text label, horizontal or vertical
    case genericDouble = 30//generic*2
    case interLabel = 14.9//vertical space between label
    case paragraphLineSpacing = 9.0//space between text in paragraph
    case totalTextHorizontal = 20.0//cell+generic
    case BrownFontVertical = 3.0 // system does not properly calculate label height, use to prevent letter g from getting cut off at the bottom
}
