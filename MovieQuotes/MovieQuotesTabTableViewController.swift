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
    var authStateListenerHandle: AuthStateDidChangeListenerHandle!
    var isShowingAllQuotes = true
    var movieQuotes = [MovieQuote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddQuoteDialog))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showMenu))
        movieQuotRef = Firestore.firestore().collection("MovieQuotes")
    }
    @objc func showMenu(){
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Create Quote",
                                                style: .default){ (action) in
                                                self.showAddQuoteDialog()
        })
        alertController.addAction(UIAlertAction(title: self.isShowingAllQuotes ? "Show only my quotes" : "Show all quotes",
                                                style: .default){ (action) in
                                                self.isShowingAllQuotes = !self.isShowingAllQuotes
                                                //Update the list
                                                self.startListening()
        })
        alertController.addAction(UIAlertAction(title: "Sign out",
                                                style: .default){ (action) in
                                                do{
                                                    try Auth.auth().signOut()
                                                }catch {
                                                    print("Sign out error")
                                                }
        })
        alertController.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authStateListenerHandle = Auth.auth().addStateDidChangeListener{(auth, user) in
            if (Auth.auth().currentUser == nil){
                print("There is no user, Go back to sign in ")
                self.navigationController?.popViewController(animated: true)
            }else {
                print("You are signed in already")
            }
        }
        
        startListening()
    }
    
    func startListening(){
        if (MovieQuotesListener != nil){
            MovieQuotesListener.remove()
        }
        var query = movieQuotRef.order(by: "created", descending: true).limit(to:50)
        if (!isShowingAllQuotes){
            query = query.whereField("author", isEqualTo: Auth.auth().currentUser!.uid)
        }
        MovieQuotesListener = query.addSnapshotListener { (querySnapshot, error) in
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
        Auth.auth().removeStateDidChangeListener( authStateListenerHandle)
    }
    
    func showAddQuoteDialog(){
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
