//
//  AddThoughtViewController.swift
//  cgPad
//
//  Created by Colby Gatte on 11/10/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

protocol AddThoughtViewController_DidAddThought {
    func addThoughtViewController_DidAddThought(_:Thought)
}

class AddThoughtViewController: UITableViewController {
    
    @IBOutlet weak var thoughtTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
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
            _ = Thought(new: self.thoughtTextField.text!, uid: Db.user.uid, save: true)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }



}
