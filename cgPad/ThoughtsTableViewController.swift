//
//  ThoughtsTableViewController.swift
//  cgPad
//
//  Created by Colby Gatte on 11/10/16.
//  Copyright © 2016 colbyg. All rights reserved.
//
// dbRef.observe(.value, with: { (snapshot: FIRDataSnapshot) in
// .children
// Db.thoughts.queryOrdered(byChild: "createdAt").queryEqual(toValue: "Today").observe(.value, with:{ (snapshot: FIRDataSnapshot) in

import UIKit
import Firebase
import FirebaseAuth


class ThoughtsTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTable(reload: {
            print("@@@@ I AM LOADING SOMETHING RIGHT THIS SECOND!!!!!")
        })
        
        Database.anonymousLogin() {
            Database.getAllThoughts() {
                self.tableView.reloadData()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserThoughts.thoughts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as! ThoughtTableViewCell
        
        cell.cellSetup(UserThoughts.thoughts[indexPath.row])

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
