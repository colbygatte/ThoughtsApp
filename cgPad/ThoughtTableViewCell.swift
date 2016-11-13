//
//  ThoughtTableViewCell.swift
//  
//
//  Created by Colby Gatte on 11/12/16.
//
//

import UIKit

class ThoughtTableViewCell: UITableViewCell {
    @IBOutlet weak var thoughtLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var dislikeLabel: UILabel!
    
    var updateManually: Bool = false // shouldn't use this. lines using it currently commented out below
    
    
    // @@@@ is this just passing a reference?
    var thought: Thought!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func dislikeButtonPressed(_ sender: Any) {
        self.thought.like(likeValue: 1, completion: {
        
            if self.updateManually {
                self.thought.update(completion: {
                    print("@@@@@ updating DISLIKE label")
                    self.dislikeLabel.text = String(self.thought.likes[1]!)
                    self.likeLabel.text = String(self.thought.likes[0]!)
                })
            }
        })
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        self.thought.like(likeValue: 0, completion: {
        
            if self.updateManually {
                self.thought.update(completion: {
                    print("@@@@@ updating this label")
                    self.dislikeLabel.text = String(self.thought.likes[1]!)
                    self.likeLabel.text = String(self.thought.likes[0]!)
                })
            }
        })
    }
}
