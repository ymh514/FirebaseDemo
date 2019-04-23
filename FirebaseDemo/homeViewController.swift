//
//  homeViewController.swift
//  FirebaseDemo
//
//  Created by Terry on 2019/4/23.
//  Copyright © 2019 ymh514. All rights reserved.
//

import Firebase
import FirebaseAuth
import UIKit

class homeViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser != nil {
            do {
                nameLabel.text = Auth.auth().currentUser?.displayName ?? "Not set yet"
                emailLabel.text = Auth.auth().currentUser?.email
            } catch _ as NSError {}
        }
    }

    @IBAction func logoutAction(_: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                presentingViewController?.dismiss(animated: true, completion: nil)
            } catch _ as NSError {
                print("Logout Error")
            }
        }
    }

    @IBAction func resetAction(_: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email!)!)
                presentingViewController?.dismiss(animated: true, completion: nil)
            } catch _ as NSError {
                print("Logout Error")
            }
        }
    }
}
