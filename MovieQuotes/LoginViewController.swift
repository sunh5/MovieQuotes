//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 2/1/21.
//

import UIKit
import Firebase
import Rosefire
import GoogleSignIn

class LoginViewController: UIViewController{
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    var roseFireName: String?
        
    let showListSegueIndentifier = "ShowListSegue"
    let REGISTRY_TOKEN = "1409f402-7717-42bf-b09b-75f33c423b04"//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        GIDSignIn.sharedInstance()?.presentingViewController = self
        self.signInButton?.style = .wide
        
    }
    
    override func viewDidAppear(_ animated: Bool) {                             //Auto login
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            print("Someone already signed in! Just move on")
            self.performSegue(withIdentifier: self.showListSegueIndentifier, sender: self)
        }
        roseFireName = nil
    }
    @IBAction func pressedSignInNewUser (_ sender: Any){
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().createUser(withEmail: email, password: password){authResult, error in
            if let error = error{
                print("Error creating new user for Email/password \(error)")
            }
            print("It worked")
            print("Email: \(authResult!.user.email!) UID: \(authResult!.user.uid)")
            self.performSegue(withIdentifier: self.showListSegueIndentifier, sender: self)
        }
        
    }
    
    @IBAction func pressedLogInExistingUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password){authResult, error in
            if let error = error{
                print("Error logging in an existing user for Email/password \(error)")
            }
            print("It worked")
            print("Email \(authResult!.user.email!) UID: \(authResult!.user.uid)")
            self.performSegue(withIdentifier: self.showListSegueIndentifier, sender: self)
        }
    }
    
    @IBAction func pressedRosefireLogin(_ sender: Any) {
        Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: REGISTRY_TOKEN) { (err, result) in
          if let err = err {
            print("Rosefire sign in error! \(err)")
            return
          }
          print("Result = \(result!.token!)")
          print("Result = \(result!.username!)")
          print("Result = \(result!.name!)")
            self.roseFireName = result!.name!
          print("Result = \(result!.email!)")
          print("Result = \(result!.group!)")
            
          Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
            if let error = error {
              print("Firebase sign in error! \(error)")
              return
            }
            // User is signed in using Firebase!
            self.performSegue(withIdentifier: self.showListSegueIndentifier, sender: self)
          }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == showListSegueIndentifier{
            
            print("Checking for user \(Auth.auth().currentUser!.uid)")
            UserManage.shared.addNewUserMaybe(uid: Auth.auth().currentUser!.uid,
                                              name: Auth.auth().currentUser!.displayName,
                                              photoUrl: Auth.auth().currentUser!.photoURL?.absoluteString)
        }
    }
    
}
