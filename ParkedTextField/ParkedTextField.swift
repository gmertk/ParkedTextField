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

    /// Constant part of the text. Defaults to "".
    @IBInspectable public var parkedText: String = "" {
        didSet {
            // Force update placeholder to get the new value of constantText
            placeholder = placeholderText + parkedText
        }
    }

    @IBInspectable public var placeholderText: String = "" {
        didSet {
            placeholder = placeholderText + parkedText
        }
    }

    @IBInspectable public var notParkedText: String = "" {
        didSet {

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
                let parkedTextRange = NSMakeRange(count(placeholderText), count(parkedText))
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
            return positionFromPosition(endOfDocument, offset: -count(parkedText))
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
            notParkedText = text

            let newText = text + parkedText

            let range = newText.rangeOfString(parkedText, options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
            let nsrange = NSRangeFromRange(newText, range: range!)

            let attributedString = NSMutableAttributedString(string: newText)
            attributedString.addAttributes(parkedTextAttributes, range: nsrange)
            attributedText = attributedString

            prevText = text
            goToBeginningOfConstantText()

            typingState = .Typed

        case .Typed:
            if text == parkedText {
                typingState = .Start
                text = ""
                notParkedText = text
                return
            }

            // Reset to prevText if you tried to change parkedText.
            if !text.hasSuffix(parkedText) {
                let attributedString = NSMutableAttributedString(string: prevText)

                let range = prevText.rangeOfString(parkedText, options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
                let nsrange = NSRangeFromRange(prevText, range: range!)

                attributedString.addAttributes(parkedTextAttributes, range: nsrange)
                attributedText = attributedString
            } else {
                prevText = text

                notParkedText = text[text.startIndex..<advance(text.endIndex, -count(parkedText))]
            }
            goToBeginningOfConstantText()

        default:
            break

        }
    }

    // MARK: Utilites

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