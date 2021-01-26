//
//  MovieQuotesTabTableViewController.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 1/26/21.
//

import UIKit

class MovieQuotesTabTableViewController: UITableViewController {
    var movieQuoteCellIdentifier = "MovieQuoteCell"
//    var names = ["Ray", "911","Dave", "shuai", "Ji"]
    var movieQuotes = [MovieQuote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddQuoteDialog))
        
        movieQuotes.append(MovieQuote(quote: "I be back", movie: "The ternimater"))
        movieQuotes.append(MovieQuote(quote: "Yo Ray", movie: "ROcky"))
    }
    
    @objc func showAddQuoteDialog(){
        print("you press add button")
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
    


}
