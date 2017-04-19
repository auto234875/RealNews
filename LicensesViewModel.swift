//
//  LicensesViewModel.swift
//  Real News
//
//  Created by PC on 4/19/17.
//  Copyright © 2017 PC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

struct License{
    let name:NSAttributedString
    let content:NSAttributedString
    let rowHeight:CGFloat
}
enum LicenseType:String{
    case RxSwift = "RxSwift"
    case SwiftyStoreKit = "SwiftyStoreKit"
    var content:String{
        switch self{
        case .RxSwift :
            return "The MIT License Copyright © 2015 Krunoslav Zaher All rights reserved.\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
        case .SwiftyStoreKit:
            return "Copyright (c) 2015-2016 Andrea Bizzotto bizz84@gmail.com\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
        }
    }

}

func getLicensesViewModel(cellWidth:CGFloat)->[License]{
    return [getLicenseData(cellWidth: cellWidth, license: .RxSwift), getLicenseData(cellWidth: cellWidth, license: .SwiftyStoreKit)]
}

func getLicenseData(cellWidth:CGFloat,license:LicenseType)->License{
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = padding.paragraphLineSpacing.rawValue
    let nameAttributes:[String:Any] = [NSFontAttributeName:UIFont.detail,NSForegroundColorAttributeName:UIColor.appTextColor]
    let contentAttributes:[String:Any] = [NSFontAttributeName:UIFont.standard,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:UIColor.appTextColor]
    let name = NSAttributedString(string: license.rawValue, attributes: nameAttributes)
    let content = NSAttributedString(string: license.content, attributes: contentAttributes)
    let size = CGSize(width: cellWidth, height: .greatestFiniteMagnitude)
    let nameSize = name.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
    let contentSize = content.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
    let rowHeight = padding.totalTextHorizontal.rawValue * 2 + padding.interLabel.rawValue + nameSize.height + contentSize.height
        return License(name: name, content: content, rowHeight: rowHeight)
}
