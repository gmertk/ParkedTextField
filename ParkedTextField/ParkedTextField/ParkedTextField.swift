//
//  ParkedTextField.swift
//  TextField
//
//  Created by Gunay Mert Karadogan on 13/7/15.
//  Copyright (c) 2015 Gunay Mert Karadogan. All rights reserved.
//

import UIKit

open class ParkedTextField: UITextField {
    
    // MARK: Properties
    
    /// Constant part of the text. Defaults to "".
    @IBInspectable open var parkedText: String {
        get {
            return _parkedText
        }
        set {
            guard var text = text else {
                return
            }
            if !text.isEmpty {
                let typed = text[text.startIndex..<text.index(text.endIndex, offsetBy: -self.parkedText.count)]
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
    @IBInspectable open var typedText: String {
        get {
            guard let text = text else {
                return ""
            }
            if text.hasSuffix(parkedText) {
                return String(text[text.startIndex..<text.index(text.endIndex, offsetBy: -parkedText.count)])
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
    @IBInspectable open var placeholderText: String = "" {
        didSet {
            placeholder = placeholderText + parkedText
        }
    }
    
    
    /// Constant part of the text. Defaults to the text field's font.
    @objc open var parkedTextFont: UIFont! {
        didSet {
            parkedText += ""
        }
    }
    
    /// Constant part of the text. Defaults to the text field's textColor.
    @IBInspectable open var parkedTextColor: UIColor! {
        didSet {
            parkedText += ""
        }
    }
    
    /// Attributes wrapper for font and color of parkedText
    var parkedTextAttributes: [NSAttributedString.Key: NSObject] {
        return [
            NSAttributedString.Key.font: parkedTextFont,
            NSAttributedString.Key.foregroundColor: parkedTextColor ?? textColor!
        ]
    }
    
    open override var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                let attributedString = NSMutableAttributedString(string: placeholder)
                let parkedTextRange = NSMakeRange(placeholderText.count, parkedText.count)
                if placeholder.hasSuffix(parkedText) {
                    attributedString.addAttributes(parkedTextAttributes, range: parkedTextRange)
                    attributedPlaceholder = attributedString
                }
            }
        }
    }
    
    enum TypingState {
        case start, typed
    }
    var typingState = TypingState.start
    
    var beginningOfParkedText: UITextPosition? {
        get {
            return position(from: endOfDocument, offset: -parkedText.count)
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
        
        addTarget(self, action: #selector(ParkedTextField.textChanged(_:)), for: .editingChanged)
        
        text = ""
        prevText = text!
        
        typingState = .start
    }
    
    
    // MARK: EditingChanged handler
    
    @objc func textChanged(_ sender: UITextField) {
        switch typingState {
        case .start where text!.count > 0:
            text = typedText + parkedText
            updateAttributedTextWith(text!)
            prevText = text!
            goToBeginningOfParkedText()
            
            typingState = .typed
            
        case .typed:
            if text == parkedText {
                typingState = .start
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
    func updateAttributedTextWith(_ text: String) {
        if let parkedTextRange = text.range(of: parkedText, options: NSString.CompareOptions.backwards, range: nil, locale: nil) {
            let nsRange = text.nsRange(from: parkedTextRange)
            
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes(parkedTextAttributes, range: nsRange)
            
            attributedText = attributedString
        }
    }
    
    func goToBeginningOfParkedText() {
        if let position = beginningOfParkedText {
            goToTextPosition(position)
        }
    }
    
    func goToTextPosition(_ textPosition: UITextPosition!) {
        selectedTextRange = textRange(from: textPosition, to: textPosition)
    }
    
    func bold(_ font: UIFont) -> UIFont {
        let descriptor = font.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitBold)
        return UIFont(descriptor: descriptor!, size: 0)
    }
}

// https://stackoverflow.com/a/30404532/805882
fileprivate extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16),
            let to = range.upperBound.samePosition(in: utf16) else {
            return NSRange(location: NSNotFound, length: 0)
        }
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
}

