//
//  PaddedLabel.swift
//  BookFinder
//
//  Created by 邱允聰 on 20/5/2025.
//

import UIKit

class PaddedLabel: UILabel {
    
    var contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInset)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentInset.left + contentInset.right,
                      height: size.height + contentInset.top + contentInset.bottom)
    }
}
