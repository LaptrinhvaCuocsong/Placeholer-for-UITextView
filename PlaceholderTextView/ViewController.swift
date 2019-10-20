//
//  ViewController.swift
//  PlaceholderTextView
//
//  Created by nguyen manh hung on 10/20/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var heightMessageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightMessageTextViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    
    var gestureRecognizer: UITapGestureRecognizer?
    private let defaultHeightMessageView: CGFloat = 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        messageTextView.placeholder = "iMessage"
        messageTextView.layer.borderWidth = 1.0
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        messageTextView.layer.cornerRadius = 8.0
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditMessageTextView))
        view.addGestureRecognizer(gestureRecognizer!)
    }
    
    @objc private func endEditMessageTextView() {
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
    }
    
    @objc private func showKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            var safeInsetBottom: CGFloat!
            if #available(iOS 11.0, *) {
                safeInsetBottom = self.view.safeAreaInsets.bottom
            }
            else {
                safeInsetBottom = self.bottomLayoutGuide.length
            }
            UIView.animate(withDuration: 0.5) {
                self.heightMessageViewConstraint.constant = self.defaultHeightMessageView + keyboardFrame.size.height - safeInsetBottom
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func hideKeyboard(notification: Notification) {
        UIView.animate(withDuration: 0.5) {
            self.heightMessageViewConstraint.constant = self.defaultHeightMessageView
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func sendClicked(_ sender: Any) {
        messageTextView.text = ""
        if messageTextView.isFirstResponder {
            messageTextView.resignFirstResponder()
        }
    }
    
}

