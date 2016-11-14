//
//  AddThoughtViewController.swift
//  cgPad
//
//  Created by Colby Gatte on 11/10/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

protocol AddThoughtViewController_Delegate {
    func addThoughtViewController_DidAddThought(_ thought: Thought)
}

class AddThoughtViewController: UITableViewController {
    
    @IBOutlet weak var thoughtTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    var delegate: AddThoughtViewController_Delegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addThoughtButtonPressed(_ sender: Any) {
        let charCount = (self.thoughtTextField.text?.characters.count)!
        
        if charCount > 40 {
            self.warningLabel.text = "your thought is a tad long"
        } else if charCount < 4 {
            self.warningLabel.text = "your thought is a tad short"
        } else {
            let thought = Thought(new: self.thoughtTextField.text!, uid: Db.user.uid, save: true)
            self.delegate.addThoughtViewController_DidAddThought(thought)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

}
