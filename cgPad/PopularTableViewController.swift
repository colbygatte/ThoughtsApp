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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTable(reload: {
            self.getPopularThoughts()
        })

        self.getPopularThoughts()
        

    }

    func getPopularThoughts() {
        Database.getPopularThoughts() {
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserThoughts.popularThoughts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCell", for: indexPath) as! ThoughtTableViewCell
        
        cell.cellSetup(UserThoughts.popularThoughts[indexPath.row])
        
        // update manually because you don't want things moving around on popular page
        cell.updateManually = true
        
        return cell
    }


}
