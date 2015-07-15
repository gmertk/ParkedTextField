//
//  ViewController.swift
//  ParkedTextFieldExample
//
//  Created by Gunay Mert Karadogan on 14/7/15.
//  Copyright (c) 2015 Gunay Mert Karadogan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gmailTextField: ParkedTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
//        gmailTextField.parkedText = "@gmail.com"

    }

    @IBAction func valueChanged(sender: ParkedTextField) {
        println("text = " + sender.text)
        println("typedText = " + sender.notParkedText)
    }

    @IBAction func changeParkedText(sender: AnyObject) {
        let parkedTexts = [".slack.com", "@gmail.com", "@hotmail.com", ".facebook.com"]

        gmailTextField.parkedText = parkedTexts[Int(arc4random_uniform(UInt32(parkedTexts.count)))]
    }
}
