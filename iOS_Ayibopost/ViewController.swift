//
//  ViewController.swift
//  AyiboPostIos
//
//  Created by Jules Frantz Stephane Loubeau on 10/30/18.
//  Copyright © 2018 Jules Frantz Stephane Loubeau. All rights reserved.
//

import UIKit
//import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
    
        load_Posts()
        
        
    }
    
    func loadPosts() {
        let url = URL(string: "https://ayibopost.com/wp-json/posts")!
        
        //print(url)
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                let errorAlertController = UIAlertController(title: "Cannot Get Posts", message: "The Internet connections appears to be offline.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
                print(error.localizedDescription)
            }   else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                self.posts = dataDictionary["posts"] as! [[String: Any]]
                print("post")
                self.tableView.reloadData()
            }
                /*
            //---------
            else if let data = data,
                
                
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                self.posts = dataDictionary["posts"] as! [[String: Any]]
                print("post")
                self.tableView.reloadData()
            }*/
            //---------
            //self.refreshControl.endRefreshing()
        }
        task.resume()
        //activityIndicator.stopAnimating()
    }
    func load_Posts() {
        guard let url = URL(string: "https://ayibopost.com/wp-json/posts") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse) //Response result
                //self.posts = jsonResponse as! [[String : Any]]
                //print(self.posts)
                
               // if let data = data,
                 //   let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                   // self.posts = dataDictionary[] as! [[String: Any]]
                self.posts = jsonResponse as! [[String: Any]]
                print(self.posts)
                //}
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                //print(jsonArray)
                
                //Now get title value
                /*
                 guard let title = jsonArray[0]["title"] as? String else { return }
                 //Lets print 1 title keys values
                 print(title)*/
                
                //Lets try to print all title keys values
                
                for dic in jsonArray{
                    guard let title = dic["title"] as? String else { return }
                
                    print(title) //Output
                    //print(self.posts)
                    //self.posts.append(title)
                    
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()

     }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.movies.count
        //if self.searchBar.text!.isEmpty{
        return self.posts.count
        //}else{
        // return filteredMovies?.count ?? 0
        //}
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath) as! PostsCell
        //let post = posts[indexPath.row]
        let post = posts[indexPath.row]
        let title = post["title"] as! String
        let overview = post["content"] as! String
        cell.titleLabel.text = title
        cell.contentLabel.text = overview
        
        //let posterPathString = post["poster_path"] as! String
        //this.image = jsonObject.getJSONObject("featured_image").getString("source");
        //let baseURLString = "https://image.tmdb.org/t/p/w500"
        //let posterURL = URL(string: baseURLString + posterPathString)!
        
        
        //let placeholderImage = UIImage(named: "reel_tabbar_icon")
        
        
        /*
         
         cell.posterImage.af_setImage(withURL: posterURL,
         placeholderImage: placeholderImage,
         filter: filter,
         imageTransition: .crossDissolve(1),
         runImageTransitionIfCached: false,
         completion: (nil)
         
         )
         
         let backgroundView = UIView()
         backgroundView.backgroundColor = UIColor.lightGray
         cell.selectedBackgroundView = backgroundView
         
         cell.backgroundColor = UIColor.white
         cell.layer.borderColor = UIColor.lightGray.cgColor
         cell.layer.borderWidth = 1
         cell.layer.cornerRadius = 8
         cell.clipsToBounds = true
         
         */
        
        
        
        
        return cell
    }
    
    
}

