//
//  ParkedTextField.swift
//  TextField
//
//  Created by Gunay Mert Karadogan on 13/7/15.
//  Copyright (c) 2015 Gunay Mert Karadogan. All rights reserved.
//

import UIKit

public class ParkedTextField: UITextField {

    // MARK: Properties

    /// Constant part of the text. Defaults to "".
    @IBInspectable public var parkedText: String {
        get {
            return _parkedText
        }
        set {
            guard var text = text else {
                return
            }
            if !text.isEmpty {
                let typed = text[text.startIndex..<text.endIndex.advancedBy(-self.parkedText.characters.count)]
                text = typed + newValue

                prevText =  text
                _parkedText = newValue
                
                textChanged(self)
            } else {
                _parkedText = newValue
            }

            // Force update placeholder to get the new value of parkedText
            placeholder = placeholderText + parkedText
        }
    }
    var _parkedText = ""

    /// Variable part of the text. Defaults to "".
    @IBInspectable public var typedText: String {
        get {
            guard let text = text else {
                return ""
            }
            if text.hasSuffix(parkedText) {
                return text[text.startIndex..<text.endIndex.advancedBy(-parkedText.characters.count)]
            } else {
                return text
            }
        }
        set {
            text = newValue + parkedText
            textChanged(self)
        }
    }

    /// Placeholder before parkedText. Defaults to "".
    @IBInspectable public var placeholderText: String = "" {
        didSet {
            placeholder = placeholderText + parkedText
        }
    }


    /// Constant part of the text. Defaults to the text field's font.
    public var parkedTextFont: UIFont! {
        didSet {
            parkedText += ""
        }
    }

    /// Constant part of the text. Defaults to the text field's textColor.
    @IBInspectable public var parkedTextColor: UIColor! {
        didSet {
            parkedText += ""
        }
    }

    /// Attributes wrapper for font and color of parkedText
    var parkedTextAttributes: [String: NSObject] {
        return [
            NSFontAttributeName: parkedTextFont,
            NSForegroundColorAttributeName: parkedTextColor ?? textColor
        ]
    }

    public override var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                let attributedString = NSMutableAttributedString(string: placeholder)
                let parkedTextRange = NSMakeRange(placeholderText.characters.count, parkedText.characters.count)
                if placeholder.hasSuffix(parkedText) {
                    attributedString.addAttributes(parkedTextAttributes, range: parkedTextRange)
                    attributedPlaceholder = attributedString
                }
            }
        }
    }

    enum TypingState {
        case Start, Typed
    }
    var typingState = TypingState.Start

    var beginningOfParkedText: UITextPosition? {
        get {
            return positionFromPosition(endOfDocument, offset: -parkedText.characters.count)
        }
    }

    var prevText = ""


    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        
        if let boldFont = font {
            parkedTextFont = bold(boldFont)
        } else {
            parkedTextFont = font
        }

        parkedTextColor = textColor

        addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)

        text = ""
        prevText = text!

        typingState = .Start
    }


    // MARK: EditingChanged handler

    func textChanged(sender: UITextField) {
        switch typingState {
        case .Start where text!.characters.count > 0:
            text = typedText + parkedText
            updateAttributedTextWith(text!)
            prevText = text!
            goToBeginningOfParkedText()

            typingState = .Typed

        case .Typed:
            if text == parkedText {
                typingState = .Start
                text = ""
                return
            }

            // If the parkedText has changed, don't update prevText.
            if text!.hasSuffix(parkedText) {
                prevText = text!
            }
            updateAttributedTextWith(prevText)
            goToBeginningOfParkedText()

        default:
            break

        }
    }

    // MARK: Utilites
    func updateAttributedTextWith(text: String) {
        if let parkedTextRange = text.rangeOfString(parkedText, options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil) {
            let nsRange = NSRangeFromRange(text, range: parkedTextRange)

            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes(parkedTextAttributes, range: nsRange)

            attributedText = attributedString
        }
    }

    /// http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
    func NSRangeFromRange(text:String, range : Range<String.Index>) -> NSRange {
        let utf16view = text.utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        let loc = utf16view.startIndex.distanceTo(from)
        let len = from.distanceTo(to)
        return NSMakeRange(loc, len)
    }

    func goToBeginningOfParkedText() {
        if let position = beginningOfParkedText {
            goToTextPosition(position)
        }
    }

    func goToTextPosition(textPosition: UITextPosition!) {
        selectedTextRange = textRangeFromPosition(textPosition, toPosition: textPosition)
    }

    func bold(font: UIFont) -> UIFont {
        let descriptor = font.fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
        return UIFont(descriptor: descriptor, size: 0)
    }
}