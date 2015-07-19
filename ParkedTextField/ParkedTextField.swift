//
//  ConstantPlaceholderTextField.swift
//  TextField
//
//  Created by Gunay Mert Karadogan on 13/7/15.
//  Copyright (c) 2015 Gunay Mert Karadogan. All rights reserved.
//

import UIKit

public class ParkedTextField: UITextField {

    // MARK: Properties
    /// Constant part of the text location. Defaults to `true`
    @IBInspectable public var parkedTextAtEnd: Bool = true

    /// Constant part of the text. Defaults to "".
    @IBInspectable public var parkedText: String {
        get {
            return _parkedText
        }
        set {
            if !text.isEmpty {
                
                let typed = parkedTextAtEnd ? text[text.startIndex..<advance(text.endIndex, -count(parkedText))] : text[parkedText.endIndex..<text.endIndex]
                text = typed + newValue

                prevText =  text
                _parkedText = newValue
                
                textChanged(self)
            } else {
                _parkedText = newValue
            }

            // Force update placeholder to get the new value of parkedText
            placeholder = parkedTextAtEnd ? placeholderText + parkedText : parkedText + placeholderText
        }
    }
    var _parkedText = ""

    /// Variable part of the text. Defaults to "".
    @IBInspectable public var typedText: String {
        get {
            if parkedTextAtEnd {
                if text.hasSuffix(parkedText) {
                    return text[text.startIndex..<advance(text.endIndex, -count(parkedText))]
                } else {
                    return text
                }
            } else {
                if text.hasPrefix(parkedText) {
                    return text[parkedText.endIndex..<text.endIndex]
                } else {
                    return text
                }
            }
        }
        set {
            text = (parkedTextAtEnd) ? newValue + parkedText : parkedText + newValue
            textChanged(self)
        }
    }

    /// Placeholder before parkedText. Defaults to "".
    @IBInspectable public var placeholderText: String = "" {
        didSet {
            placeholder = parkedTextAtEnd ? (placeholderText + parkedText) : (parkedText + placeholderText)
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
    
    var typedTextAttributes: [String: NSObject] {
        return [
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: textColor
        ]
    }

    public override var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                let attributedString = NSMutableAttributedString(string: placeholder)
                let parkedTextRange: NSRange
                if parkedTextAtEnd {
                    parkedTextRange = NSMakeRange(count(placeholderText), count(parkedText))
                } else {
                    parkedTextRange = NSMakeRange(0, count(parkedText))
                }
                attributedString.addAttributes(parkedTextAttributes, range: parkedTextRange)
                attributedPlaceholder = attributedString
            }
        }
    }

    enum TypingState {
        case Start, Typed
    }
    var typingState = TypingState.Start

    var beginningOfConstantText: UITextPosition? {
        get {
            return parkedTextAtEnd ?
                positionFromPosition(endOfDocument, offset: -count(parkedText))
                : beginningOfDocument
        }
    }

    var prevText = ""


    // MARK: Initialization

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        if let boldFont = bold(font) {
            parkedTextFont = boldFont
        } else {
            parkedTextFont = font
        }

        parkedTextColor = textColor

        addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)

        text = ""
        prevText = text

        typingState = .Start
    }


    // MARK: EditingChanged handler

    func textChanged(sender: UITextField) {
        switch typingState {
        case .Start where count(text) > 0:
            text = parkedTextAtEnd ? typedText + parkedText : parkedText + typedText
            updateAttributedTextWith(text)
            prevText = text
            parkedTextAtEnd ? goToBeginningOfConstantText() : goToEndOfText()

            typingState = .Typed

        case .Typed:
            if text == parkedText {
                typingState = .Start
                text = ""
                return
            }

            // Reset to prevText if you tried to change parkedText.
            if parkedTextAtEnd {
                if text.hasSuffix(parkedText) {
                    prevText = text
                }
            } else {
                if text.hasPrefix(parkedText) {
                    prevText = text
                }
            }
            updateAttributedTextWith(prevText)
            parkedTextAtEnd ? goToBeginningOfConstantText() : goToEndOfText()

        default:
            break

        }
    }

    // MARK: Utilites
    func updateAttributedTextWith(text: String) {
        if let parkedTextRange = text.rangeOfString(parkedText, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
            let nsRange = NSRangeFromRange(text, range: parkedTextRange)

            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes(parkedTextAttributes, range: nsRange)
            if !parkedTextAtEnd {
                if let typedTextRange = text.rangeOfString(typedText, options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil) {
                    attributedString.addAttributes(typedTextAttributes, range: NSRangeFromRange(text, range:typedTextRange))
                }
            }
            
            attributedText = attributedString
        }
    }

    /// http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
    func NSRangeFromRange(text:String, range : Range<String.Index>) -> NSRange {
        let utf16view = text.utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        return NSMakeRange(from - utf16view.startIndex, to - from)
    }

    func goToBeginningOfConstantText() {
        if let position = beginningOfConstantText {
            goToTextPosition(position)
        }
    }
    func goToEndOfText() {
        goToTextPosition(endOfDocument)
    }

    func goToTextPosition(textPosition: UITextPosition!) {
        selectedTextRange = textRangeFromPosition(textPosition, toPosition: textPosition)
    }

    func bold(font: UIFont) -> UIFont? {
        let descriptor = font.fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)

        if let descriptor = descriptor {
            return UIFont(descriptor: descriptor, size: 0)
        } else {
            return nil
        }
    }
}