//
//  Thought.swift
//  cgPad
//
//  Created by Colby Gatte on 11/10/16.
//  Copyright © 2016 colbyg. All rights reserved.
//
/*
 Like codes:
 0 - Like
 1 - Dislike
*/


import UIKit
import Firebase

// @@@@ add code to verify the uid when Thought() is init'd

class Thought: NSObject {
    
    var fireRef: FIRDatabaseReference?
    var uid: String!
    
    var thought: String!
    var createdAt: String!
    var likes: [Int:Int]!
    
    var likeExists: Bool = true
    
    init(with snapshot: FIRDataSnapshot, uid: String) {
        super.init()
        
        self.fireRef = snapshot.ref
        self.uid = uid
        
        let values = snapshot.value as! [String:Any]
        
        self.setValues(values: values)
    }
    
    init(new thought: String, uid: String, save: Bool) {
        super.init()
        
        self.likes = [:]
        self.thought = thought
        self.uid = uid
        self.createdAt = ThoughtsSettings.dateFormatter.string(from: Date())
        self.likes[0] = 0;
        self.likes[1] = 0;
    
        
        if save {
            let thoughtDbEntry = Db.thoughts.childByAutoId()
            thoughtDbEntry.setValue(self.toAnyObject())
            
            self.fireRef = thoughtDbEntry.ref
        }
    }
    
    func setValues(values: [String:Any]) {
        self.thought = values["thought"] as! String
        self.createdAt = values["createdAt"] as! String
        
        self.likes = [:]
        self.likes[0] = (values["0"] as! Int)
        self.likes[1] = (values["1"] as! Int)
    }
    
    func toAnyObject() -> Any {
        return [
            "thought": self.thought,
            "createdAt": self.createdAt,
            "user": self.uid,
            "0": self.likes[0] ?? 0,
            "1": self.likes[1] ?? 0
        ]
    }
    
    
    func update(completion: (()->())? = nil) {
        let key = self.fireRef?.key
        
        Db.thoughts.child(key!).observeSingleEvent(of: .value){ (snapshot: FIRDataSnapshot) in
            let values = snapshot.value as! [String: Any]
            self.setValues(values: values)
            
            if completion != nil {
                completion!()
            }
        }
    }
    
    
    
    // how to i let this return true/false to let user know of like or not liked?
    func like(likeValue: Int, completion: (()->())? = nil) {
        
        
        if self.fireRef != nil {
            // check to see if this user has liked it already
            

            Db.likes.child(self.uid).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                // Now we are in cgPad/likes/(uid)/(list of thought:likeValue)
                
                // @@@@ the following can probably be simplified
                // if a like already exists, here we update it
                if snapshot.hasChild(self.fireRef!.key) {
                    let currentLikeValue = snapshot.childSnapshot(forPath: self.fireRef!.key).value as! Int
                    if currentLikeValue == likeValue { // value is the same, do nothing
                        
                    } else {
                        // de-increment like value
                        let oldLikeValue = likeValue == 0 ? 1 : 0
                        self.likes[oldLikeValue] = self.likes[oldLikeValue]! - 1
                        // increment new like value
                        self.likes[likeValue] = self.likes[likeValue]! + 1
                        // save de-incremented like value
                        self.fireRef!.updateChildValues([String(likeValue): self.likes[likeValue]!, String(oldLikeValue): self.likes[oldLikeValue]!])
                        // update likes table
                        snapshot.ref.updateChildValues([self.fireRef!.key: likeValue])
                        
                    }
                } else { // if it doesn't exist, we create it
                    self.likes[likeValue] = self.likes[likeValue]! + 1
                    // update likes table
                    //Db.likes.child(self.uid).updateChildValues([self.fireRef!.key: likeValue]) // <-- OLD WAY I WAS DOING IT
                    snapshot.ref.updateChildValues([self.fireRef!.key: likeValue])
                    // update thoughts table
                    self.fireRef!.updateChildValues([String(likeValue): self.likes[likeValue]!])
                }
                
                // @@@@ THIS RUNS EVEN IF THERE IS AN ERROR ABOVE
                if completion != nil {
                    completion!()
                }
                
            })
        } else {
            print("@@@@ error 2")
        }
    }
    

}
