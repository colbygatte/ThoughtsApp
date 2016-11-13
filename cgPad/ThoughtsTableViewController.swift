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
import DGElasticPullToRefresh


class ThoughtsTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ThoughtTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ThoughtCell")
        
        self.tableView.estimatedRowHeight = 120
        
        // @@@@ is this login method okay?
        self.waitForLogin()
    }
    
    func waitForLogin() {
        if Db.loggedIn {
           // Db.thoughts.queryOrdered(byChild: "user").queryEqual(toValue: Db.user.uid).observe(.value, with:{ (snapshot: FIRDataSnapshot) in // OLD
            Db.thoughts.queryOrderedByKey().observe(.value, with:{ (snapshot: FIRDataSnapshot) in
                UserThoughts.thoughts = [Thought]() // reset cuz it's live
                for snap in snapshot.children.reversed() {
                    let thought = Thought(with: snap as! FIRDataSnapshot, uid: Db.user.uid)
                    UserThoughts.thoughts.append(thought)
                }
                
                DispatchQueue.main.async() {
                    self.tableView.reloadData()
                }
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                print("\n\n@@@@ waiting for login....")
                self.waitForLogin()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserThoughts.thoughts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as! ThoughtTableViewCell
        
        let thought = UserThoughts.thoughts[indexPath.row]
        
        cell.thoughtLabel.text = thought.thought
        cell.thought = UserThoughts.thoughts[indexPath.row]
        cell.likeLabel.text = String(thought.likes[0]!)
        cell.dislikeLabel.text = String(thought.likes[1]!)
        
        cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100)
        
        if(cell.thought.likeExists) {
            cell.likeButton.setTitleColor(UIColor.white, for: .normal)
            cell.dislikeButton.setTitleColor(UIColor.white, for: .normal)
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // commented out because i went to using tabs instead of a segue to add
        //if segue.identifier == "AddItem" {
        //    let vc = segue.destination as! AddThoughtViewController
        //}
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    

}
