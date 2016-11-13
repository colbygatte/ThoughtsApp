//
//  PopularTableViewController.swift
//  cgPad
//
//  Created by Colby Gatte on 11/12/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class PopularTableViewController: UITableViewController {

    var loadedThoughts: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ThoughtTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ThoughtCell")
        
        self.tableView.estimatedRowHeight = 120
        UserThoughts.popularThoughts = [Thought]()
        

        Db.thoughts.queryOrdered(byChild: "0").queryLimited(toLast: 3).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            UserThoughts.popularThoughts = [Thought]() // reset cuz it's live
            for snap in snapshot.children.reversed() {
                let thought = Thought(with: snap as! FIRDataSnapshot, uid: Db.user.uid)
                UserThoughts.popularThoughts.append(thought)
            }
            
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
        }
        
        var loadedThoughts = [String]()
        
        for thought in UserThoughts.popularThoughts {
            loadedThoughts.append(thought.fireRef!.key)
        }
        
        // @@@@ need to program so this only starts after pressing a like/dislike!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserThoughts.popularThoughts.count
    }

    // @@@@ Can I send the cell to a function that will format it the same way?
    // like sending just a reference for teh cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as! ThoughtTableViewCell
        
        let thought = UserThoughts.popularThoughts[indexPath.row]
        
        cell.thoughtLabel.text = thought.thought
        cell.thought = UserThoughts.popularThoughts[indexPath.row]
        cell.likeLabel.text = String(thought.likes[0]!)
        cell.dislikeLabel.text = String(thought.likes[1]!)
        
        cell.updateManually = true
        
        cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100)
        
        if(cell.thought.likeExists) {
            cell.likeButton.setTitleColor(UIColor.white, for: .normal)
            cell.dislikeButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
