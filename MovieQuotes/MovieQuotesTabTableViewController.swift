//
//  MovieQuotesTabTableViewController.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 1/26/21.
//

import UIKit
import Firebase

class MovieQuotesTabTableViewController: UITableViewController {
    var movieQuoteCellIdentifier = "MovieQuoteCell"
    let DetailSegueIdentifier = "DetailSegue"
    var movieQuotRef: CollectionReference!
    var MovieQuotesListener: ListenerRegistration!
    var movieQuotes = [MovieQuote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddQuoteDialog))
        
//        movieQuotes.append(MovieQuote(quote: "I be back", movie: "The ternimater"))
//        movieQuotes.append(MovieQuote(quote: "Yo Ray", movie: "ROcky"))
        movieQuotRef = Firestore.firestore().collection("MovieQuotes")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (Auth.auth().currentUser == nil){
            print("signing in")//not signed
            Auth.auth().signInAnonymously { (AuthResult, error) in
                if let error = error{
                    print ("Error with anonymous auth \(error)")
                    return
                }
                print("Success sign in")
            }
        }else {
            print("you are signed in")
        }
        
        
//        tableView.reloadData()
        MovieQuotesListener = movieQuotRef.order(by: "created", descending: true).limit(to:50).addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                self.movieQuotes.removeAll()
                querySnapshot.documents.forEach { (documentSnapshot) in
//                    print(documentSnapshot.documentID)
//                    print(documentSnapshot.data())
                    self.movieQuotes.append(MovieQuote(documentSnapshot: documentSnapshot))
                }
                self.tableView.reloadData()
            }else{
                print("error getting movie quotes \(error!)")
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MovieQuotesListener.remove()
    }
    
    @objc func showAddQuoteDialog(){
        let alertController = UIAlertController(title: "Create a new mmovie quote", message: "", preferredStyle: .alert)
        
        alertController.addTextField{ (textField) in
            textField.placeholder = "Quote"
        }
        alertController.addTextField{ (textField) in
            textField.placeholder = "Movie"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Create Quote", style: .default){ (action) in
            let quoteTextFields = alertController.textFields![0] as UITextField
            let movieTextFields = alertController.textFields![1] as UITextField

//            let newMovieQuote = MovieQuote(quote: quoteTextFields.text!, movie: movieTextFields.text!)
//            self.movieQuotes.insert(newMovieQuote, at: 0)
//            self.tableView.reloadData()
            self.movieQuotRef.addDocument(data: [
                "quote": quoteTextFields.text!,
                "movie": movieTextFields.text!,
                "created": Timestamp.init(),
                "author": Auth.auth().currentUser!.uid
            ])
        }
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectioin: Int) -> Int {
        //super.viewDidLoad()
        // Do any additional setup after loading the view.
        return movieQuotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellIdentifier, for: indexPath)
        cell.textLabel?.text = movieQuotes[indexPath.row].quote
        cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let movieQuote = movieQuotes[indexPath.row]
        return Auth.auth().currentUser!.uid == movieQuote.author
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
//            movieQuotes.remove(at: indexPath.row)
//            tableView.reloadData()
            let movieQuoteToDelete = movieQuotes[indexPath.row]
            movieQuotRef.document(movieQuoteToDelete.id!).delete()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DetailSegueIdentifier{
            if let indexPath = tableView.indexPathForSelectedRow{
//                (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
                (segue.destination as! MovieQuoteDetailViewController).movieQuoteRef = movieQuotRef.document(movieQuotes[indexPath.row].id!)
            }
        }
    }
    
    
}
