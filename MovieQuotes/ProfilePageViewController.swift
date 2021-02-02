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
        UserManage.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: UIControl.Event.editingChanged)
    }
    @IBAction func pressedEditPhoto(_ sender: Any) {
        print("Send photo")
    }
    
    @objc func handleNameEdit(){
        if let name = displayNameTextField.text{
            print("Send the name update \(name) to Firestore")
            UserManage.shared.updateName(name: name)
        }
    }
    
    func updateView(){
        displayNameTextField.text = UserManage.shared.name
        
    }
}
