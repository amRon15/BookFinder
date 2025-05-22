//
//  NSAttributedString+ext.swift
//  BookFinder
//
//  Created by 邱允聰 on 22/5/2025.
//

import Foundation
import UIKit

extension NSAttributedString{
    
    func detailAttributedText(_ text: String, _ main: String) -> NSAttributedString{
        var frontText = AttributedString("\(text): ")
        frontText.foregroundColor = .systemGray
        
        let mainText = AttributedString(main)
        
        return NSAttributedString(frontText + mainText)
    }
}
