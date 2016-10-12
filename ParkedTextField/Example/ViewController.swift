//
//  ViewController.swift
//  ParkedTextFieldExample
//
//  Created by Gunay Mert Karadogan on 14/7/15.
//  Copyright (c) 2015 Gunay Mert Karadogan. All rights reserved.
//

import UIKit
import ParkedTextField

class ViewController: UIViewController {
    
    @IBOutlet weak var slackTextField: ParkedTextField!
    @IBOutlet weak var gmailTextField: ParkedTextField!
    var i = 0, j = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let progress = UIProgressView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 2))
		progress.progressViewStyle = .bar
		view.addSubview(progress)
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) { 
			progress.setProgress(0.5, animated: true)
		}
		
        slackTextField.parkedText = ".slack.com"
        slackTextField.placeholderText = "yourteam"
    }
    
    @IBAction func valueChanged(_ sender: ParkedTextField) {
        print("text = " + sender.text!)
        print("typedText = " + sender.typedText)
    }
    
    @IBAction func changeParkedText(_ sender: AnyObject) {
        let texts = [".slack.com", "@gmail.com", "@hotmail.com", "@facebook.com"]
        gmailTextField.parkedText = texts[j]
        
        j = (j + 1) % texts.count
    }
    
    
    @IBAction func changeNotParkedText(_ sender: AnyObject) {
        let texts = ["ios-developers", "larry", "bill", "mark"]
        gmailTextField.typedText = texts[i]
        
        i = (i + 1) % texts.count
    }
}
