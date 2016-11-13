//
//  Database.swift
//  cgPad
//
//  Created by Colby Gatte on 11/13/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Database: NSObject {
    static func anonymousLogin(completion: (()->())? = nil) {
        FIRAuth.auth()?.signInAnonymously(completion: { (user: FIRUser?, error: Error?) in
            if error == nil {
                Db.user = user!
            } else {
                print("12> " + (error?.localizedDescription)!)
            }
            print("\n\n@@@@ logged in")
            
            if completion != nil {
                completion!()
            }
            
        })
    }
    
    static func getPopularThoughts(completion: @escaping (() -> ())) {
        Db.thoughts.queryOrdered(byChild: "0").queryLimited(toLast: 3).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            UserThoughts.popularThoughts = [Thought]() // reset cuz it's live
            for snap in snapshot.children.reversed() {
                let thought = Thought(with: snap as! FIRDataSnapshot, uid: Db.user.uid)
                UserThoughts.popularThoughts.append(thought)
            }
            
            completion()
        }
    }
    
    static func getAllThoughts(completion: @escaping (()->())) {
        Db.thoughts.queryOrderedByKey().observe(.value, with:{ (snapshot: FIRDataSnapshot) in
            UserThoughts.thoughts = [Thought]() // reset cuz it's live
            for snap in snapshot.children.reversed() {
                let thought = Thought(with: snap as! FIRDataSnapshot, uid: Db.user.uid)
                UserThoughts.thoughts.append(thought)
            }
            
            completion()
        })
    }
}
