//
//  MovieQuotesTabTableViewController.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 1/26/21.
//

import UIKit

class MovieQuotesTabTableViewController: UITableViewController {
    var movieQuoteCellIdentifier = "MovieQuoteCell"
    let DetailSegueIdentifier = "DetailSegue"
    
    var movieQuotes = [MovieQuote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddQuoteDialog))
        
        movieQuotes.append(MovieQuote(quote: "I be back", movie: "The ternimater"))
        movieQuotes.append(MovieQuote(quote: "Yo Ray", movie: "ROcky"))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
//            print(quoteTextFields.text!)
//            print(movieTextFields.text!)
            let newMovieQuote = MovieQuote(quote: quoteTextFields.text!, movie: movieTextFields.text!)
            self.movieQuotes.insert(newMovieQuote, at: 0)
            self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            movieQuotes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DetailSegueIdentifier{
            if let indexPath = tableView.indexPathForSelectedRow{
                (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
            }
        }
    }
    
    
}
