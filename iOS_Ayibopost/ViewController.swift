//
//  ViewController.swift
//  AyiboPostIos
//
//  Created by Jules Frantz Stephane Loubeau on 10/30/18.
//  Copyright © 2018 Jules Frantz Stephane Loubeau. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var posts: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 168
        tableView.estimatedRowHeight = 200
        
        getPostList()
        
       // load_Posts()
    }
    private func getPostList(){
        AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts/") { (result) in
            
            switch result{
            case .error(let msg):
                print("Error: \(msg)")
            case .success(let json):
                print(json) //Array of dictionnary
            }
        }
    }
    /*
    func load_Posts(){
        guard let url = URL(string: "https://ayibopost.com/wp-json/posts") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
            }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse) //Response result
                guard let dataDictionary = jsonResponse as? [[String: Any]] else{return}
                
                /*for dic in dataDictionary{
                    guard let title = dic["title"] as? String else { return }
                    guard let content = dic["content"] as? String else {return}
                    print(title) //Output
                    //self.posts.append(dic)
                    //self.posts.append(title)
                    //print(self.posts)
                    //self.tableView.reloadData()
                    
                }*/
                guard let imgArray = (jsonResponse as AnyObject).value(forKey: "featured_image") else {return}
                //print(theArray)
                let dataDic = imgArray as? [[String: Any]]
                //print(dataDic)
                for dic1 in dataDic!{
                    let source = dic1["source"] as? String
                    print(source!)
                }
                
                
                for dic in dataDictionary{
                    if let title = dic["title"] as? String,
                        let content = dic["content"] as? String{
                   // print(title) //Output
                    //self.posts.append(dic)
                    //self.posts.append(title)
                    //print(self.posts)
                    //self.tableView.reloadData()
                    }
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath) as! PostsCell

        let post = posts[indexPath.row]
   //     let title = post["title"] as! String
        cell.titleLabel.text = post["title"] as? String
    //    let htmlTag =  post["content"] as! String
        let htmlTag = post["content"] as! String
        let content = htmlTag.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        cell.contentLabel.text = content
        
        /*if let posterPath = movie["source"] as? String{
         let posterBaseUrl = "https://image.tmdb.org/t/p/w500"
         let posterUrl = URL(string:  posterBaseUrl + posterPath)
         cell.MoviesImageView.af_setImage(withURL: posterUrl!)
         }
         else{
         cell.MoviesImageView.image = nil
         }
 */
        return cell
    }
    
    
}
