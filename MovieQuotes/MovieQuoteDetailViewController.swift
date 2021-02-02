//
//  File.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 1/26/21.
//

import UIKit

import Firebase

class MovieQuoteDetailViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    var movieQuote: MovieQuote?
    var movieQuoteRef: DocumentReference!
    var movieQuoteListener: ListenerRegistration!
    
    @IBOutlet weak var authorBox: UIStackView!
    @IBOutlet weak var authorProfilePhotoImageFiew: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
// Remove down       navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showEditDialog))
    }
    @objc func showEditDialog(){
        let alertController = UIAlertController(title: "Edit this mmovie quote", message: "", preferredStyle: .alert)
        
        alertController.addTextField{ (textField) in
            textField.placeholder = "Quote"
            textField.text = self.movieQuote?.quote
        }
        alertController.addTextField{ (textField) in
            textField.placeholder = "Movie"
            textField.text = self.movieQuote?.movie
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){ (action) in
            let quoteTextFields = alertController.textFields![0] as UITextField
            let movieTextFields = alertController.textFields![1] as UITextField
//            self.movieQuote?.quote = quoteTextFields.text!
//            self.movieQuote?.movie = movieTextFields.text!
//            self.updateView()
            self.movieQuoteRef.updateData([
                "quote" : quoteTextFields.text!,
                "movie" : movieTextFields.text!
            ])
        }
        alertController.addAction(submitAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authorBox.isHidden = true
        
        movieQuoteListener = movieQuoteRef.addSnapshotListener { (documentSnapshot, error) in
            if let error = error{
                print("Error getting movie quote \(error)")
                return
            }
            if !documentSnapshot!.exists{
                print("Go back to list")
                return
            }
            self.movieQuote = MovieQuote(documentSnapshot: documentSnapshot!)
            //Decide if we can edit or not
            if (Auth.auth().currentUser!.uid == self.movieQuote?.author){
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.showEditDialog))
            }else {
                self.navigationItem.rightBarButtonItem = nil
            }
            //Get the user object for this author
            UserManager.shared.beginListening(uid: self.movieQuote!.author, changeListener: self.updateAuthorBox)

            self.updateView()
        }
//        updateView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        updateView()
        movieQuoteListener.remove()
    }
    
    func updateView() {
        quoteLabel.text = movieQuote?.quote
        movieLabel.text = movieQuote?.movie
    }
    
    func updateAuthorBox(){
        print("Updata the author box for \(UserManager.shared.name)")
        
        authorBox.isHidden = UserManager.shared.name.isEmpty && UserManager.shared.photoUrl.isEmpty
        
        if (UserManager.shared.name.count>0){
            authorNameLabel.text = UserManager.shared.name
        }else{
            authorNameLabel.text = "unknown"
        }
        
        if (!UserManager.shared.photoUrl.isEmpty){
            ImageUtils.load(imageView: authorProfilePhotoImageFiew, from: UserManager.shared.photoUrl)
        }
    }
}
