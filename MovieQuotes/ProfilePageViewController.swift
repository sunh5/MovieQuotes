//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 2/2/21.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController{
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
        print("Send photo")
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
}
