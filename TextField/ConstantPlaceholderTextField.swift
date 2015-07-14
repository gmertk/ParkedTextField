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
            // Force update placeholder to get the new value of constantText
            if let holder = placeholder {
                placeholder = holder + ""
            } else {
                placeholder = ""
            }
        }
    }

    // Investigate if we really need @IBInspectable. Maybe super.placeholder in the storyboard is enough.
    @IBInspectable public override var placeholder: String? {
        didSet {
            if let holder = placeholder {
                super.placeholder = holder + constantText
            } else {
                super.placeholder = constantText
            }
        }
    }

    enum TypingState {
        case Start, Typed, TypedEmpty
    }

    var typingState = TypingState.Start

    var beginningOfConstantText: UITextPosition? {
        get {
            return positionFromPosition(endOfDocument, offset: -count(constantText))
        }
    }

    var prevText = ""

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)
        prevText = text
    }

    func textChanged(sender: UITextField) {
        switch typingState {
        case .Start where count(text) > 0:
            text = text + constantText
            typingState = .Typed

            goToBeginningOfConstantText()
            prevText = text
        case .Typed:
            var endIndexOfText = count(text)
            var startIndexOfConstantText = endIndexOfText - count(constantText)
            var shouldBeConstantText = text[startIndexOfConstantText..<endIndexOfText]

            if shouldBeConstantText != constantText {
                text = prevText
                goToBeginningOfConstantText()
            } else {
                prevText = text
            }

            if text == constantText {
                typingState = .Start
                text = ""
            }
        default:
            break

        }
    }

    func goToBeginningOfConstantText() {
        if let position = beginningOfConstantText {
            goToTextPosition(position)
        }
    }

    func goToTextPosition(textPosition: UITextPosition!) {
        selectedTextRange = textRangeFromPosition(textPosition, toPosition: textPosition)
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}