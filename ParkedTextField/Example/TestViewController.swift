//
//  TestViewController.swift
//  ParkedTextField
//
//  Created by Robin Malhotra on 28/09/16.
//  Copyright © 2016 Gunay Mert Karadogan. All rights reserved.
//

import UIKit
import ParkedTextField
class TestViewController: UIViewController, UITextFieldDelegate {

	let urlTextField = ParkedTextField()
	var isSub = false
	override func viewDidLoad() {
		super.viewDidLoad()
		urlTextField.parkedText = ".kayako.com"
		urlTextField.placeholderText = "Your company here "
		view.addSubview(urlTextField)
		urlTextField.frame.origin = CGPoint(x: 0, y: 0)
		urlTextField.frame.size = CGSize(width: 300, height: 34)
		urlTextField.textAlignment = .left
		// Do any additional setup after loading the view.
		urlTextField.addTarget(self, action: #selector(TestViewController.chalJaBC), for: .editingChanged)
		
	}

	func chalJaBC(sender: ParkedTextField) {
		if isSub == false {
			let result = sender.text!.substring(to: (sender.text?.characters.count)! - 11)
			if result.characters.last == "." && isSub == false {
				urlTextField.parkedText = ""
				urlTextField.text = result
				isSub = true
				urlTextField.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
				urlTextField.textColor = UIColor.black
			}
		}
		
		
	}
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
	func index(from: Int) -> Index {
		return self.index(startIndex, offsetBy: from)
	}
	
	func substring(from: Int) -> String {
		let fromIndex = index(from: from)
		return substring(from: fromIndex)
	}
	
	func substring(to: Int) -> String {
		let toIndex = index(from: to)
		return substring(to: toIndex)
	}
	
	func substring(with r: Range<Int>) -> String {
		let startIndex = index(from: r.lowerBound)
		let endIndex = index(from: r.upperBound)
		return substring(with: startIndex..<endIndex)
	}
}
