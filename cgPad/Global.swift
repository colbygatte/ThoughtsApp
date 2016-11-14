//
//  Global.swift
//  cgPad
//
//  Created by Colby Gatte on 11/12/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase
import DGElasticPullToRefresh

struct ThoughtsSettings {
    static var dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    static var enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    static var dateFormatter: DateFormatter!
    
    struct UI {
        //static var viewBGColor = UIColor(red: 0xBF, green: 0xd3, blue: 0xea, alpha: 1.0)
        static var viewBGColor = UIColor(netHex: 0xBFD3EA)
        static var tableSeparatorColor = UIColor(netHex: 0xBFD3EA)
    }
}

struct Db {
    static var thoughts: FIRDatabaseReference!
    static var likes: FIRDatabaseReference!
    
    static var user: FIRUser!
}

struct UserThoughts {
    static var thoughts: [Thought] = [Thought]()
    static var popularThoughts: [Thought] = [Thought]()
    static var userLikedThoughts: [Thought] = [Thought]()
}


extension UITableViewController {
    func setupElasticRefresh(reload: (()->())? = nil) {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            if reload != nil {
                reload!()
            }
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }

    func setupTable(reload: (()->())? = nil) {
        self.tableView.register(UINib(nibName: "ThoughtTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ThoughtCell")
        self.tableView.estimatedRowHeight = 120
        self.tableView.backgroundColor = ThoughtsSettings.UI.viewBGColor
        self.tableView.separatorColor = ThoughtsSettings.UI.tableSeparatorColor
        self.tableView.separatorStyle = .none
        self.setupElasticRefresh(reload: reload)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}



