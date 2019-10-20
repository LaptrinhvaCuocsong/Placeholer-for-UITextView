//
//  UITextView+Funny.swift
//  PlaceholderTextView
//
//  Created by nguyen manh hung on 10/20/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import UIKit

fileprivate var observerTextKey = "observerTextKey"
fileprivate var placeholderLabelKey = "placeholderLabelKey"
fileprivate var placeholderKey = "placeholderKey"
fileprivate let observerKeyPath = "text"

extension UITextView {
    
    fileprivate var placeholderLabel: UILabel? {
        get {
            if let label = objc_getAssociatedObject(self, &placeholderLabelKey) as? UILabel {
                return label
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &placeholderLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var observerText: ObserverText? {
        get {
            if let observer = objc_getAssociatedObject(self, &observerTextKey) as? ObserverText {
                return observer
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &observerTextKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var placeholder: String? {
        get {
            if let value = objc_getAssociatedObject(self, &placeholderKey) as? String {
                return value
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &placeholderKey, newValue, .OBJC_ASSOCIATION_COPY)
            if newValue?.isEmpty ?? true {
                removePlaceholder()
                removeObserverText()
            }
            else {
                addPlaceholder(newValue!)
                addObserverText()
            }
        }
    }
    
}

fileprivate class ObserverText: NSObject {
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(notification:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textViewDidChange(notification: Notification) {
        if let textView = notification.object as? UITextView {
            if let text = textView.placeholder, textView.text.isEmpty {
                textView.addPlaceholder(text)
            }
            else {
                textView.removePlaceholder()
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, keyPath == observerKeyPath, let textView = object as? UITextView {
            if let newText = change?[NSKeyValueChangeKey.newKey] as? String, !newText.isEmpty {
                textView.removePlaceholder()
            }
            else {
                if let text = textView.placeholder {
                    textView.addPlaceholder(text)
                }
            }
        }
    }
    
}

fileprivate extension UITextView {
    
    func addObserverText() {
        observerText = ObserverText()
        self.addObserver(observerText!, forKeyPath: observerKeyPath, options: .new, context: nil)
    }
    
    func removeObserverText() {
        if let observerText = observerText {
            self.removeObserver(observerText, forKeyPath: observerKeyPath)
        }
        observerText = nil
    }
    
    func addPlaceholder(_ text: String) {
        placeholderLabel?.removeFromSuperview()
        placeholderLabel = UILabel()
        placeholderLabel?.text = text
        if let selfFont = self.font {
            placeholderLabel?.font = UIFont.systemFont(ofSize: selfFont.pointSize, weight: .thin)
        }
        else {
            placeholderLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .thin)
        }
        placeholderLabel?.textColor = .lightGray
        placeholderLabel?.numberOfLines = 0
        let padding = self.textContainer.lineFragmentPadding
        let estimateSize = placeholderLabel!.sizeThatFits(CGSize(width: self.frame.size.width - 2*padding, height: self.frame.size.height))
        placeholderLabel?.frame = CGRect(x: padding, y: self.textContainerInset.top, width: estimateSize.width, height: estimateSize.height)
        self.addSubview(placeholderLabel!)
    }
    
    func removePlaceholder() {
        placeholderLabel?.removeFromSuperview()
    }
    
}
