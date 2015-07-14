//
//  ViewController.swift
//  One Word
//
//  Created by Gunay Mert Karadogan on 19/4/15.
//  Copyright (c) 2015 Gunay Mert Karadogan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!

    let constantPlaceholder = ".slack.com"
    let transparentPlaceholder = "yourteam"

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self

        let labelFont = UIFont(name: "HelveticaNeue-UltraLight", size: 20)!

        let paragraphStyle = NSMutableParagraphStyle.alloc()
        paragraphStyle.lineHeightMultiple = 1
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Center
        let labelShadow = NSShadow()
        labelShadow.shadowColor = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 0.5)
        labelShadow.shadowOffset = CGSizeMake(1.0, 1.0)
        labelShadow.shadowBlurRadius = 1
        let labelColor = UIColor.blueColor()

        let attributesForText = [NSForegroundColorAttributeName: labelColor,
            NSFontAttributeName: labelFont,
            NSShadowAttributeName: labelShadow,
            NSParagraphStyleAttributeName : paragraphStyle]

        let attributedString = NSMutableAttributedString(string: transparentPlaceholder + constantPlaceholder, attributes: attributesForText)

        attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.orangeColor()], range: NSMakeRange(0, count(transparentPlaceholder)))

        textField.attributedPlaceholder = attributedString

//        textField.attributedText = attributedString
//        textField.textColor = UIColor.blackColor()
//        textField.clearsOnBeginEditing = false

        textField.textAlignment = NSTextAlignment.Center
    }

    // Called when becoming the first responder status
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }


    // Called when resigning the first responder status
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }


    // Called whenever the user taps the built-in clear button.
    // Also called when editing begins and the clearsOnBeginEditing = true.
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }


    // Called whenever the user taps the return button.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }


    // Called whenever the user types a new character in the text field or deletes an existing character.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        println(string)
        println(range)

        // start state
        if textField.text.isEmpty {
            textField.text = constantPlaceholder
            let beginning = textField.beginningOfDocument
            goToTextPosition(beginning)
            return true
        } else if range.location == 0 && range.length == 1 {
            textField.text = ""

        }

        let constantStartIndex = count(textField.text) - count(constantPlaceholder)
        // Don't change constantPlaceholder
        if range.location > constantStartIndex {
            let placeholderStartingTextPosition = textField.positionFromPosition(textField.endOfDocument, offset: -count(constantPlaceholder))
            goToTextPosition(placeholderStartingTextPosition)
            return false
        }

        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        // another state
        if !textField.text.isEmpty {
            let placeholderStartingTextPosition = textField.positionFromPosition(textField.endOfDocument, offset: -count(constantPlaceholder))
            goToTextPosition(placeholderStartingTextPosition)
        }
    }

    func goToTextPosition(textPosition: UITextPosition!) {
        textField.selectedTextRange = textField.textRangeFromPosition(textPosition, toPosition: textPosition)
    }
}

