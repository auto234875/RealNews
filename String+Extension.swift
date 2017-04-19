//
//  String+Extension.swift
//  Real News
//
//  Created by PC on 4/1/17.
//  Copyright © 2017 PC. All rights reserved.
//

import Foundation
import UIKit
extension String {
    func htmlAttributedString() -> NSMutableAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options:[NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil) else { return nil }
        return html
    }
    
}
