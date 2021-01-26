//
//  ViewController.swift
//  MovieQuotes
//
//  Created by Haoxuan Sun on 1/5/21.
//

import UIKit

class ViewController: UITableViewController {
    var names = ["Ray", "911","Dave", "shuai", "Ji"]
    
    override func tableView(_ tableView: UITableView, numberOfRowInSection sectioin: Int) -> Int {
        //super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        return names.count
    }
    
    cellForRow


}

