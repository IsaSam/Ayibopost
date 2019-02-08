//
//  ViewController.swift
//  AyiboPostIos
//
//  Created by Jules Frantz Stephane Loubeau on 10/30/18.
//  Copyright © 2018 Jules Frantz Stephane Loubeau. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DrawerControllerDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatory: UIActivityIndicatorView!
    
    
    var posts: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    var urlPost1: String?
    
     // -------------------------------
        // 1.Decllare the drawer view
        var drawerVw = DrawerView()
        
        var vwBG = UIView()
    //--------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 280
        tableView.estimatedRowHeight = 280
        
        getPostList()
        //-----------------
        self.navigationController?.navigationBar.isTranslucent = false
        //-----------------
    }
        //-----------------
        @IBAction func actShowMenu(_ sender: Any) {
            
            //**** REQUIRED ****//
            //**** 2.Implement the drawer view object and set delecate to current view controller
            drawerVw = DrawerView(aryControllers:DrawerArray.array, isBlurEffect:true, isHeaderInTop:false, controller:self)
            drawerVw.delegate = self
            
            // Can change account holder name
            drawerVw.changeUserName(name: "WELCOME")
            
            // 3.show the Navigation drawer.
            drawerVw.show()
            
            
            
        }
        
        // 6.To push the viewcontroller which is selected by user.
        func pushTo(viewController: UIViewController) {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        //-----------------
        
    private func getPostList(){
        
        self.activityIndicatory.startAnimating() //====================
      
        let url = URL(string: "https://ayibopost.com/wp-json/posts/")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {(data, response, error) in
            //-- This will run when the network request returns
            if let error = error{
                let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                self.posts = [dataDictionary]
                self.tableView.reloadData()
                self.activityIndicatory.stopAnimating()
            }
        /*
        AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts/") { (result, error) in
            
            if error != nil{
                print(error!)
                
                return
            }
            
 
            //print(result!)
            self.posts = result!
            self.tableView.reloadData() // to tell table about new data
            
            self.activityIndicatory.stopAnimating() //====================
        }*/

    }
    task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath) as! PostsCell

        
        let post = posts[indexPath.row]
        let urlPost = post["link"] as! String
        urlPost1 = urlPost as String
        
        cell.titleLabel.text = post["title"] as? String
        let htmlTag = post["content"] as! String
        let content = htmlTag.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        cell.contentLabel.text = content
        

        
        do{
            let imgArray = (posts as AnyObject).value(forKey: "featured_image")
            let dataDic = imgArray as? [[String: Any]]
            self.imgPosts = dataDic!
                
            let remoteImageUrlString = imgPosts[indexPath.row]
            let imageURL = remoteImageUrlString["source"] as? String
            //print(imageURL!)
            if let imagePath = imageURL,
                let imgUrl = URL(string:  imagePath){
                cell.imagePost.af_setImage(withURL: imgUrl)
            }
            else{
                cell.imagePost.image = nil
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let post = posts[(indexPath?.row)!]
        let imgPost = imgPosts[(indexPath?.row)!]
        let detailViewController = segue.destination as! DetailsPostViewController
        detailViewController.post = post
        detailViewController.imgPost = imgPost
        detailViewController.urlPost1 = urlPost1
    
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//----------------------

    // 7.Struct for add storyboards which you want show on navigation drawer
    struct DrawerArray {
        static let array:NSArray = ["Home", "Politique", "Society","Economie", "Culture", "Sport", "AyiboTalk"]
}
//----------------------
