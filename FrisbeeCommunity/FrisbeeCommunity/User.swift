
//
//  User.swift
//  FrisbeeCommunity
//
//  Created by Thomas on 2017/7/28.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import Foundation
import FirebaseDatabase.FIRDataSnapshot
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase




class User : NSObject {
    
    
    // MARK: - Properties
    //var isFollowed = false
    let uid: String
    let username: String
    // MARK: - Init
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        super.init()
    }
    
    // If the initialization of an object fail,
    //if a user doesn't have a UID or a username, we'll fail the initialization and return nil.
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        
        self.username = username
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String
            else {
                return nil
        }
        
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    // MARK: - Singleton
    
    // Create a private static variable to hold our current user. This method is private so it can't be access outside of this class.
    private static var _current: User?
    
    // Create a computed variable that only has a getter that can access the private _current variable.
    static var current: User {
        // Check that _current that is of type User? isn't nil. If _current is nil, and current is being read, the guard statement will crash with fatalError().
        guard let currentUser = _current
            else {
                fatalError("Error: current user doesn't exist")
        }
        
        // If _current isn't nil, it will be returned to the user.
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // Create a custom setter method to set the current user.
    // We add another parameter that takes a Bool on whether the user should be written to UserDefaults. We give this value a default value of false.
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // We check if the boolean value for writeToUserDefaults is true. If so, we write the user object to UserDefaults.
        if writeToUserDefaults {
            // We use NSKeyedArchiver to turn our user object into Data. We needed to implement the NSCoding protocol and inherit from NSObject to use NSKeyedArchiver.
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // We store the data for our current user with the correct key in UserDefaults.
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
    
      
    
}

//user object can properly be encoded as Data.

extension User: NSCoding {
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
    }
}
