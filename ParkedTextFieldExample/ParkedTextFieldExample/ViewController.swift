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
    var i = 0, j = 0

    override func viewDidLoad() {
        super.viewDidLoad()
//        gmailTextField.parkedText = "@gmail.com"

    }

    @IBAction func valueChanged(sender: ParkedTextField) {
        println("text = " + sender.text)
        println("typedText = " + sender.typedText)
    }

    @IBAction func changeParkedText(sender: AnyObject) {
        let texts = [".slack.com", "@gmail.com", "@hotmail.com", ".facebook.com"]

        gmailTextField.parkedText = texts[j]

        j = (j + 1) % texts.count
    }


    @IBAction func changeNotParkedText(sender: AnyObject) {
        let texts = ["what", "me", "you", "id"]

        gmailTextField.typedText = texts[i]

        i = (i + 1) % texts.count
    }
}
