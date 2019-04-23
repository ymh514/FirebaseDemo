//
//  databaseViewController.swift
//  FirebaseDemo
//
//  Created by Terry on 2019/4/23.
//  Copyright © 2019 ymh514. All rights reserved.
//

import Firebase
import FirebaseFirestore
import UIKit

class databaseViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        getInfoFromFirestore()
    }

    func getInfoFromFirestore() {
        let docRef = db.collection("Users").document("user1")
        docRef.getDocument { document, _ in
            if let document = document, document.exists {
                let dictionary: [String: Any] = document.data()!
                self.nameLabel.text = dictionary["name"] as? String
                self.ageLabel.text = dictionary["age"] as? String
                self.cityLabel.text = dictionary["city"] as? String
            } else {
                print("Document does not exist")
            }
        }
    }
}
