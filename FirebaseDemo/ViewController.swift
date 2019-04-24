//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Terry on 2019/4/23.
//  Copyright © 2019 ymh514. All rights reserved.
//

import Firebase
import FirebaseAuth
import GoogleSignIn
import UIKit

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet weak var googleSigninBtn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        googleSigninBtn.style = .wide
    }

    @IBAction func loginAction(_: UIButton) {
        Auth.auth().signIn(withEmail: usernameText.text!, password: passwordText.text!) { _, error in
            if error == nil {
                self.performSegue(withIdentifier: "loginSucessSegue", sender: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "The password is invalid or the user does not register yet.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { _ in
                    print("You Got error")
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }


    func sign(_: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { _, error in
            if let error = error {
                print(error)
                return
            }
            self.performSegue(withIdentifier: "loginSucessSegue", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "loginSucessSegue" {
            print("pass value to loginSucessSegue")
            passwordText.text = ""
        }
    }
}
