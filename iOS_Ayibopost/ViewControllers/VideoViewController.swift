//
//  VideoViewController.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 7/12/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    var categories = ["Nos explainers", "Discussions", "ANRIYAN", "Reportages", "AyiboSport", "Documentaires", "AyiboStudio", "FinTech Haïti 2018", "Forum International sur la Finance"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryRow
        return cell
    }




}
