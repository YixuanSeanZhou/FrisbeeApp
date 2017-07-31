//
//  LoginViewController.swift
//  FrisbeeCommunity
//
//  Created by Thomas on 2017/7/28.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuthUI
typealias FIRUser = FirebaseAuth.User


class LoginViewController: UIViewController{
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        // 2
        authUI.delegate = self
        
        // 3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
    
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        // First we check that the FIRUser returned from authentication is not nil by unwrapping it.
        guard let user = user
            else { return }
        
        // Path
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        // Read
        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            if let user = User(snapshot: snapshot) {
                print("Welcome back, \(user.username).")
            } else {
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        })
    }
}
