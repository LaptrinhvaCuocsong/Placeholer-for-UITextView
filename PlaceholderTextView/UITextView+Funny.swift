//
//  UITextView+Funny.swift
//  PlaceholderTextView
//
//  Created by nguyen manh hung on 10/20/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

fileprivate var key = "placeholderKey"

extension UITextView {
    
    var placeholder: String {
        get {
            if let value = objc_getAssociatedObject(self, &key) as? String {
                return value
            }
            return ""
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_COPY)
            if newValue.isEmpty {
                removePlaceholder()
            }
            else {
                addPlaceholder(newValue)
            }
        }
    }
    
}

fileprivate extension UITextView {
    
    func addPlaceholder(_ text: String) {
        let label = UILabel()
        label.text = text
        label.font = self.font
        label.textColor = .lightGray
        let padding = self.textContainer.lineFragmentPadding
        
    }
    
    func removePlaceholder() {
        
    }
    
}
