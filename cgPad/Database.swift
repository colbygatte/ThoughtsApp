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
                let thought = Thought(with: snap as! FIRDataSnapshot)
                UserThoughts.popularThoughts.append(thought)
            }
            
            completion()
        }
    }
    
    static func getAllThoughts(completion: @escaping (()->())) {
        Db.thoughts.queryOrderedByKey().observeSingleEvent(of: .value, with:{ (snapshot: FIRDataSnapshot) in
        //Db.thoughts.queryOrderedByKey().observe(.value, with:{ (snapshot: FIRDataSnapshot) in
            
            for snap in snapshot.children.reversed() {
                let thought = Thought(with: snap as! FIRDataSnapshot)
                UserThoughts.thoughts.append(thought)
            }
            
            completion()
        })
    }
    
    // can i use the query to get the thoughts equal to "0"?
    // completion after each thought needs to be better
    static func getCurrentUserLikedThoughts(completionAfterEachThoughtLoaded: @escaping (()->())) {
        let query = Db.likes.child(Db.user.uid)
        
        query.observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            UserThoughts.userLikedThoughts = [Thought]()
            
            for snap in snapshot.children {
                let likeValue = (snap as! FIRDataSnapshot).value as! Int

                if(likeValue == 1) {
                    continue
                }

                let key = (snap as! FIRDataSnapshot).key
                Db.thoughts.child(key).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                    if snapshot.childrenCount != 0 { // means it was deleted but the like from the specific user wasn't
                        let thought = Thought(with: snapshot)
                        UserThoughts.userLikedThoughts.append(thought)
                        completionAfterEachThoughtLoaded()
                    }
                    
                })
            }
            completionAfterEachThoughtLoaded()
        })
    }
}
