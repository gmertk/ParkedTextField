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
        gmailTextField.parkedText = "@gmail.com"
        gmailTextField.placeholder = "account"
    }

    @IBAction func valueChanged(sender: ParkedTextField) {
        println(sender.text)
    }
}
