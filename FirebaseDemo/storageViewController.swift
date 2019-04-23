//
//  storageViewController.swift
//  FirebaseDemo
//
//  Created by Terry on 2019/4/23.
//  Copyright © 2019 ymh514. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage
import UIKit

class storageViewController: UIViewController {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var showImage: UIImageView!

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }

    @IBAction func uploadAction(_: UIButton) {
        let imagePickerController = UIImagePickerController()

        imagePickerController.delegate = self

        let imagePickerAlertController = UIAlertController(title: "Upload Image", message: nil, preferredStyle: .actionSheet)

        let imageFromLibAction = UIAlertAction(title: "Gallery", style: .default) { _ in

            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "Camera", style: .default) { _ in

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in

            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }

        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)

        present(imagePickerAlertController, animated: true, completion: nil)
    }

    @IBAction func getphotoAction(_: UIButton) {
        startActivity()
        let docRef = db.collection("Users").document("image")
        docRef.getDocument { document, _ in
            if let document = document, document.exists {
                let dictionary: [String: Any] = document.data()!
                let url = dictionary["url"] as? String

                if let imageUrl = URL(string: url!) {
                    URLSession.shared.dataTask(with: imageUrl, completionHandler: { data, _, error in

                        if error != nil {
                            self.stopActitivity()
                            print("Download Image Task Fail: \(error!.localizedDescription)")
                        } else if let imageData = data {
                            DispatchQueue.main.async {
                                self.stopActitivity()
                                self.showImage.image = UIImage(data: imageData)
                            }
                        }
                    }).resume()
            } } else {
                self.stopActitivity()
                print("Document does not exist")
            }
        }
    }

    func startActivity() {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func stopActitivity() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

extension storageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        startActivity()

        var selectedImageFromPicker: UIImage?

        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
        }

        let uniqueString = NSUUID().uuidString

        if let selectedImage = selectedImageFromPicker {
            print("\(uniqueString), \(selectedImage)")

            let storageRef = Storage.storage().reference().child("FirebaseDemoUpload").child("\(uniqueString).png")

            if let uploadData = selectedImage.pngData() {
                storageRef.putData(uploadData, metadata: nil) { _, err in

                    if let err = err {
                        print(err)
                    }
                    storageRef.downloadURL(completion: { url, error in
                        if error != nil {
                            print("Failed to download url:", error!)
                            return
                        } else {
                            print("Photo Url: \(url)")
                            self.db.collection("Users").document("image").setData([
                                "url": url?.absoluteString,
                            ])
                        }
                        self.stopActitivity()
                    })
                }
            }
        }

        dismiss(animated: true, completion: nil)
    }
}
