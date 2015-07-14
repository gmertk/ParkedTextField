//
//  ConstantPlaceholderTextField.swift
//  TextField
//
//  Created by Gunay Mert Karadogan on 13/7/15.
//  Copyright (c) 2015 Gunay Mert Karadogan. All rights reserved.
//

import UIKit

@IBDesignable public class ConstantPlaceholderTextField: UITextField {

    @IBInspectable public var constantText: String = "" {
        didSet {
            // Update placeholder to get the new value of constantText
            if let holder = placeholder {
                placeholder = holder + ""
            } else {
                placeholder = ""
            }

        }
    }

    // FIX: Do we need @IBInspectable? Or normal placeholder just works.
    // FIX: Maybe didSet ve willSet kullanilabilir.
    //        get {
    //            return _placeholder
    //        }
    //        set {
    //            if let newValue = newValue {
    //                _placeholder = newValue
    //                super.placeholder = _placeholder + constantText
    //            }
    //        }

    @IBInspectable public override var placeholder: String? {
        didSet {
            if let holder = placeholder {
                super.placeholder = holder + constantText
            } else {
                super.placeholder = constantText
            }
        }
    }

//    var _placeholder: String = ""

    enum TypingState {
        case Start, TypedInPlaceholder, TypedInConstantText, TypedEmpty
    }

    var typingState = TypingState.Start


    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name:
//            UITextFieldTextDidChangeNotification, object: self)

        addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)

    }

    func textChanged(sender: UITextField) {
//
//        // start state
        if count(text) == 1 {
            text = text + constantText
            let beginning = beginningOfDocument
            goToTextPosition(beginning)
        }
//            else if range.location == 0 && range.length == 1 {
//            textField.text = ""
//
//        }
        else {
            var reversedText = reverse(text)
            var i = 0
            for char in reverse(constantText) {
                if reversedText[advance(reversedText.startIndex, i)] != char {
                    reversedText.removeAtIndex(i)
                    text = String(reversedText)
                    let placeholderStartingTextPosition = positionFromPosition(endOfDocument, offset: -count(constantText))
                    goToTextPosition(placeholderStartingTextPosition)
                    break
                }
                i += 1
            }


        }
//        let constantStartIndex = count(text) - count(constantText)
        // Don't change constantPlaceholder
//        if range.location > constantStartIndex {
//            let placeholderStartingTextPosition = textField.positionFromPosition(textField.endOfDocument, offset: -count(constantPlaceholder))
//            goToTextPosition(placeholderStartingTextPosition)
//            return false
//        }



    }

    func goToTextPosition(textPosition: UITextPosition!) {
        selectedTextRange = textRangeFromPosition(textPosition, toPosition: textPosition)
    }


    
//    func textChanged(notification: NSNotification) {
//        NSNotificationCenter.defaultCenter().removeObserver(UITextViewTextDidChangeNotification)
//
//        text = "mert"
//
//
//
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textChanged:", name: UITextViewTextDidChangeNotification, object: nil)
//
//    }
//
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(UITextViewTextDidChangeNotification)
//    }
}