//
//  Sport.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 2/1/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class Sport: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    

    var catPosts: [[String: Any]] = []
//    var catPosts3 = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 350
        self.tableView.estimatedRowHeight = 350
        
     //   loadCategory1()
        getCategory()()
        topBarLogo()
    }
    func topBarLogo(){
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "ayibopost-logo-blanc-2.png")
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    }

    func getCategory(){
        
        self.activityIndicator.startAnimating() //====================
        
        webView.delegate = self
        if let url = URL(string: "https://ayibopost.com/wp-json/posts?filter[category_name]=\(categori)&filter[posts_per_page]=20")
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            var session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                    session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                    //        self.activityIndicator.stopAnimating() //====================
                    let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline.", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Pull to Refresh", style: .cancel)
                    errorAlertController.addAction(cancelAction)
                    self.present(errorAlertController, animated: true)
                    print(error.localizedDescription)
                    
                } else{
                    self.webView.loadRequest(request)
                    self.activityIndicator.stopAnimating() //====================
                }
                self.activityIndicator.stopAnimating()
            }
            task.resume()
    }
    /*
     self.activityIndicatory.startAnimating() //====================
     AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?page=\(loadNumber)") { (result, error) in
     
     if error != nil{
     // print(error!)
     let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline", preferredStyle: .alert)
     let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
     errorAlertController.addAction(cancelAction)
     self.present(errorAlertController, animated: true)
     print(error!)
     
     return
     }
     //print(result!)
     self.posts = result!
     self.tableView.reloadData() // to tell table about new data
     self.activityIndicatory.stopAnimating() //====================
     }
     self.refreshControl.endRefreshing()
     self.activityIndicatory.stopAnimating()
    */
 
    /*
    func loadList2(){
        let categori = "SPORT"
        let url2 = URL(string: "https://ayibopost.com/wp-json/posts?filter[category_name]=\(categori)&filter[posts_per_page]=20")
        
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
                        print(myResults)
                        
                        self.catPosts = myResults as! [[String : Any]]
                      /*  for value in self.catPosts
                        {
                    //        /*
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
                         //   */
                        }*/
                    }
                }
                catch
                {
                }
            }
        }
        task.resume()
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     //   return catPosts3.count
          return catPosts.count
        
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
