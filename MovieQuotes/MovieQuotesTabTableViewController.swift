//
//  MovieQuotesTabTableViewController.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 1/26/21.
//

import UIKit

class MovieQuotesTabTableViewController: UITableViewController {
    var movieQuoteCellIdentifier = "MovieQuoteCell"
    var names = ["Ray", "911","Dave", "shuai", "Ji"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectioin: Int) -> Int {
        //super.viewDidLoad()
        // Do any additional setup after loading the view.
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    


}
