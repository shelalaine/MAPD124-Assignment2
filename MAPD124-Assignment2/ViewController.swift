//
//  ViewController.swift
//  MAPD124-Assignment2
//
//  Created by Shelalaine Chan on 2017-01-31.
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    let data: [String] = ["Task 1", "Task 2", "Task 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rows", for: indexPath) as! TodoTableViewCell
        
        return cell;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

}

