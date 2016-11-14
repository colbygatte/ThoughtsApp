//
//  CurrentUserLikedThoughtsTableViewController.swift
//  cgPad
//
//  Created by Colby Gatte on 11/13/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class CurrentUserLikedThoughtsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTable(reload: {
            Database.getCurrentUserLikedThoughts() {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        
        Database.getCurrentUserLikedThoughts() {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserThoughts.userLikedThoughts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as! ThoughtTableViewCell
        
        cell.cellSetup(UserThoughts.userLikedThoughts[indexPath.row])
        
        cell.updateManually = true
        
        return cell
    }
    

}
