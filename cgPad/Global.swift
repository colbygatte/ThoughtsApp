//
//  Global.swift
//  cgPad
//
//  Created by Colby Gatte on 11/12/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase

struct ThoughtsSettings {
    static var dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    static var enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    static var dateFormatter: DateFormatter!
}

struct Db {
    static var thoughts: FIRDatabaseReference!
    static var likes: FIRDatabaseReference!
    
    static var user: FIRUser!
    static var loggedIn: Bool = false
}

struct UserThoughts {
    static var thoughts: [Thought]!
    static var popularThoughts: [Thought]!
}
