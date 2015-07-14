//
//  ViewController.swift
//  One Word
//
//  Created by Gunay Mert Karadogan on 19/4/15.
//  Copyright (c) 2015 Gunay Mert Karadogan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func editingChanged(sender: ConstantPlaceholderTextField) {
        println(sender.constantText)
        println(sender.text)
        println(sender.placeholder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

