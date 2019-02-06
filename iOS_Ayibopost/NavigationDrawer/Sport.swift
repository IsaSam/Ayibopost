//
//  Sport.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 2/1/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class Sport: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [[String: Any]] = []
    var catePosts: [[String: Any]] = []
    var catePosts1: [[String: Any]] = []
    var catPosts: [[String: Any]] = []
    var catPosts3 = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 350
        self.tableView.estimatedRowHeight = 350
        
        loadCategory()
    }
    
    func loadCategory(){
        let url3 = URL(string: "https://ayibopost.com/wp-json/posts/")
        let task = URLSession.shared.dataTask(with: url3!){
            (data, response, error) in
            
            if error != nil
            {
                print("ERROR")
            }
            else{
                do{
                    
                    if let content = data{
                        let myJson = try JSONSerialization.jsonObject(with: content, options: .mutableContainers)
                        //print(myJson)
                        //dump(myJson)
                        self.posts = myJson as! [[String : Any]]
             //           if let jsonData = myJson as? [[String : Any]]{
                            do{
                                let cateArray = (self.posts as AnyObject).value(forKey: "terms")
             //                   let dataDic = cateArray as? [[String : Any]]
                               self.catePosts = cateArray as! [[String : Any]]
                                // self.catePosts = dataDic!
                            
                            for value in self.catePosts
                            {
                                if let category = value["category"]
                                {
                                    //print(category)
                                    self.catePosts1 = category as! [[String : Any]]
                                    //print(self.catePosts1)
                                    
                                    for value in self.catePosts1
                                    {
                                        if let category = value["name"] as? String
                                        {
                                            
                                            self.catPosts3 = [category]
                                            
                                            // print(self.catPosts3)
                                            
                                            print(category)
                                           /* if category.contains("SPORT"){
                                                print("found")
                                            }else{
                                                //print("not found")
                                            }*/
                                        }
                                    }
                                    }
                                }
                            }
                      //  }
                  
                    }
                        
                      
                    }
                catch
                {
                    
                }
            }
            
        }
        task.resume()
    }
    
    func loadList2(){
        let url2 = URL(string: "https://ayibopost.com/wp-json/taxonomies/category/terms")
        let task = URLSession.shared.dataTask(with: url2!){
            (data, response, error) in
            
            if error != nil
            {
                print("ERROR")
            }
            else{
                do{
                    if let content = data{
                        let myResults = try JSONSerialization.jsonObject(with: content, options: .mutableContainers)
                        //dump(myResults)
                        
                        self.catPosts = myResults as! [[String : Any]]
                        for value in self.catPosts
                        {
                            if let category = value["name"] as? String
                            {
                                self.catPosts3 = [category]
                                
                                print(category)
                               /* if category.contains("SPORT"){
                                    print("found")
                                }else{
                                    //print("not found")
                                }*/
                                //self.catPosts3 = [category]
                                //self.tableView.reloadData()
                            }
                        }
                    }
                }
                catch
                {
                }
            }
        }
        task.resume()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catPosts3.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell

 //       let term = catPosts3[indexPath.row]
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
