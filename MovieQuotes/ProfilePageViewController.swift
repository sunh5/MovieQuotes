//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 2/2/21.
//

import UIKit

class ProfilePageViewController: UIViewController{
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    override func viewDidLoad() {
        displayNameTextField.addTarget(self, action: #selector(handleNameEdit), for: UIControl.Event.editingChanged)
    }
    @IBAction func pressedEditPhoto(_ sender: Any) {
        print("Send photo")
    }
    
    @objc func handleNameEdit(){
        if let name = displayNameTextField.text{
            print("Send the name \(name) to Firestore")
        }
    }
}
