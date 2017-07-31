//
//  CreateUsernameViewController.swift
//  FrisbeeCommunity
//
//  Created by Thomas on 2017/7/30.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuthUI
import Firebase

class CreateUsernameViewController: UIViewController {
    // ...
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var cerateButton: UIButton!
    
    
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
       
                guard let firUser = Auth.auth().currentUser,
            let username = userName.text, !username.isEmpty
            else { return }
        
        UserService.create(firUser, username: username) { (user) in
            guard let _ = user else {
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
            if let initialViewController = storyboard.instantiateInitialViewController() {
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
                // handle newly created user here
    }
}
