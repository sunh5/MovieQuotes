//
//  SideNavController.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 2/2/21.
//

import UIKit
import Firebase

class SideNavController: UIViewController{
    @IBAction func pressedGotoProfile(_ sender: Any) {
        dismiss(animated: false)
        tableViewController.performSegue(withIdentifier: kprofilePageSegue, sender: tableViewController)
    }
    @IBAction func pressedShowAllQuotes(_ sender: Any) {
        tableViewController.isShowingAllQuotes = true
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedShowMyQuotes(_ sender: Any) {
        tableViewController.isShowingAllQuotes = false
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedEdleteQuotes(_ sender: Any) {
        tableViewController.setEditing(!tableViewController.isEditing, animated: true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedLogout(_ sender: Any) {
        dismiss(animated: false)
        do{
            try Auth.auth().signOut()
         }catch {
            print("Sign out error")
         }
    }
    
    var tableViewController: MovieQuotesTabTableViewController{
        get {
            let navController = presentingViewController as! UINavigationController
            return navController.viewControllers.last as! MovieQuotesTabTableViewController
        }
    }
    
}
