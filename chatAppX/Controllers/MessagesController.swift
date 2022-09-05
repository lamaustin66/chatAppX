//
//  ViewController.swift
//  chatAppX
//
//  Created by Austin Lam on 9/1/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class MessagesController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        
        present(navController, animated: true)
    }
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            handleLogout()
        } else {
            let uid = Auth.auth().currentUser!.uid
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
                if let dictionary = snapshot.value as? NSDictionary {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserIsLoggedIn()
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true)
    }
    
    
}

