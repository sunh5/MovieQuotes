//
//  File.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 1/26/21.
//

import UIKit


class MovieQuoteDetailViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
    var movieQuote: MovieQuote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showEditDialog))
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
            self.movieQuote?.quote = quoteTextFields.text!
            self.movieQuote?.movie = movieTextFields.text!
            self.updateView()
        }
        alertController.addAction(submitAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    func updateView() {
        quoteLabel.text = movieQuote?.quote
        movieLabel.text = movieQuote?.movie
    }
}
