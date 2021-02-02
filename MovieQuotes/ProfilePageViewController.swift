//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 2/2/21.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfilePageViewController: UIViewController {
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    override func viewDidLoad() {
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: UIControl.Event.editingChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserManager.shared.stopListening()
    }
    
    @IBAction func pressedEditPhoto(_ sender: Any) {
        let imagePicerControler = UIImagePickerController()
        imagePicerControler.delegate = self
        imagePicerControler.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("You must be on a device")
            imagePicerControler.sourceType = .camera
        }else{
            print("You must be on a simulator")
            imagePicerControler.sourceType = .photoLibrary
        }
        present(imagePicerControler, animated: true, completion: nil)
    }
    
    @objc func handleNameEdit(){
        if let name = displayNameTextField.text{
            print("Send the name update \(name) to Firestore")
            UserManager.shared.updateName(name: name)
        }
    }
    
    func updateView(){
        displayNameTextField.text = UserManager.shared.name
        
        //Figure out how to load Image
        ImageUtils.load(imageView: profilePhotoImageView, from: UserManager.shared.photoUrl)
    }
    
    func uploadImage(_ image: UIImage){
        if let imageData = ImageUtils.resize(image: image){
            // Create a storage reference from our storage service
            let storageRef = Storage.storage().reference().child(kCollectionUsers).child(Auth.auth().currentUser!.uid)
            
            let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error upload data\(error)")
                    return
                }
                print("upload complete")
                
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error upload data\(error)")
                        return
                    }
                    if let downloadURL = url {
                        print("Got the download url \(downloadURL)")
                        UserManager.shared.updatePhotoUrl(photoUrl: downloadURL.absoluteString)
                    }
                }
        
            }
    
            
        }else {
            print("Error getting iamge data")
        }
    }
}

extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
//            profilePhotoImageView.image = image
            uploadImage(image)
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
//            profilePhotoImageView.image = image
            uploadImage(image)
        }
        
        picker.dismiss(animated: true)
    }
}
