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

	let border = CALayer()
	
	@IBInspectable var borderColor: UIColor = UIColor.white {
		didSet {
			setupBorder()
		}
	}
	
	@IBInspectable var borderWidth: CGFloat = 2 {
		didSet {
			setupBorder()
		}
	}
	
	
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
                let typed = text[text.startIndex..<text.characters.index(text.endIndex, offsetBy: -self.parkedText.characters.count)]
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
                return text[text.startIndex..<text.characters.index(text.endIndex, offsetBy: -parkedText.characters.count)]
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
    open var parkedTextFont: UIFont! {
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
    open var parkedTextAttributes: [String: NSObject] {
        return [
            NSFontAttributeName: parkedTextFont,
            NSForegroundColorAttributeName: parkedTextColor ?? textColor!
        ]
    }

    open override var placeholder: String? {
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
        case start, typed
    }
    var typingState = TypingState.start

    var beginningOfParkedText: UITextPosition? {
        get {
            return position(from: endOfDocument, offset: -parkedText.characters.count)
        }
    }

    var prevText = ""


    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
		setupBorder()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
		setupBorder()
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
	
	func setupBorder() {
		border.borderColor = self.borderColor.cgColor
		
		border.borderWidth = borderWidth
		border.cornerRadius = borderWidth/2
		border.masksToBounds = true
		self.layer.addSublayer(border)
		self.layer.masksToBounds = true
	}


    // MARK: EditingChanged handler

    func textChanged(_ sender: UITextField) {
        switch typingState {
        case .start where text!.characters.count > 0:
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
            let nsRange = NSRangeFromRange(text, range: parkedTextRange)

            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes(parkedTextAttributes, range: nsRange)

            attributedText = attributedString
        }
    }

    /// http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
    func NSRangeFromRange(_ text:String, range : Range<String.Index>) -> NSRange {
        let utf16view = text.utf16
        let from = String.UTF16View.Index(range.lowerBound, within: utf16view)
        let to = String.UTF16View.Index(range.upperBound, within: utf16view)
		

        let loc = utf16view.startIndex.distance(to: from)
        let len = from.distance(to: to)
        return NSMakeRange(loc, len)
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
        let descriptor = font.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits.traitBold)
        return UIFont(descriptor: descriptor!, size: 0)
    }
	
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width:  self.frame.size.width, height: borderWidth)
	}
	
	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return editingRect(forBounds: bounds)
	}
	
	override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return editingRect(forBounds: bounds)
	}
	
	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: 20, dy: 0)
	}

}
