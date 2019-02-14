//
//  AyiboTalk.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 2/1/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class AyiboTalk: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicat: UIActivityIndicatorView!
    
    var catPosts: [[String: Any]] = []
    //    var catPosts3 = [String]()
    
    var filteredPosts: [[String: Any]]?
    var posts: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    
    var urlPost1: String?
    var refreshControl: UIRefreshControl!
    var loadNumber = 7
    var categori = "ayibotalk"
    
    var convertedDate: String = ""
    var convertedTime: String = ""
    /*
     @IBAction func onTap(_ sender: Any) {
     view.endEditing(true)
     }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarLogo()
        
        searchBar.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(ViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.rowHeight = 395
        tableView.estimatedRowHeight = 395
        
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        
        getPostCategory()
        self.navigationController?.navigationBar.isTranslucent = false
        
        // self.hideKeyboardOnTap(#selector(self.onTap(_:)))
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
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        getPostCategory()
    }
    
    private func getPostCategory(){
        
        self.activityIndicat.startAnimating() //====================
        AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?filter[category_name]=\(categori)&filter[posts_per_page]=\(loadNumber)") { (result, error) in
            
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
            self.activityIndicat.stopAnimating() //====================
        }
        self.refreshControl.endRefreshing()
        self.activityIndicat.stopAnimating()
        
    }
    
    func loadMorePosts(){
        loadNumber = loadNumber + 1
        AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?filter[category_name]=\(categori)&filter[posts_per_page]=\(loadNumber)") { (result, error) in
            
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
            //self.posts = result!
            
            do{
                for item in result!
                {
                    //self.dataList.add(item)
                    self.posts.append(item)
                }
                print(result!)
                self.tableView.reloadData() // to tell table about new data
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == posts.count{
            loadMorePosts()
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredPosts = searchText.isEmpty ? self.posts : self.posts.filter({(post) -> Bool in
            return (post["title"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBar.text!.isEmpty{
            return self.posts.count
        }else{
            return filteredPosts?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let post = self.searchBar.text!.isEmpty ? posts[indexPath.row] : filteredPosts![indexPath.row]
        
        let urlPost = post["link"] as! String
        urlPost1 = urlPost as String
        
        cell.titleLabelCat.text = post["title"] as? String
        let htmlTag = post["content"] as! String
        let content = htmlTag.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        cell.contentLabelCat.text = content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MMM dd, yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH-mm-ss"
        let newTimeFormatter = DateFormatter()
        newTimeFormatter.dateFormat = "h:mm a"
        let dateTime = post["date"] as? String
        let dateComponents = dateTime?.components(separatedBy: "T")
        let splitDate = dateComponents![0]
        let splitTime = dateComponents![1]
        if let date = dateFormatter.date(from: splitDate) {
            convertedDate = newDateFormatter.string(from: date)
        }
        if let time = timeFormatter.date(from: splitTime){
            convertedTime = newTimeFormatter.string(from: time)
        }
        cell.dateLabelCat.text = convertedDate
        
        do{
            let imgArray = (posts as AnyObject).value(forKey: "featured_image")
            let dataDic = imgArray as? [[String: Any]]
            self.imgPosts = dataDic!
            
            let remoteImageUrlString = imgPosts[indexPath.row]
            let imageURL = remoteImageUrlString["source"] as? String
            //print(imageURL!)
            if let imagePath = imageURL,
                let imgUrl = URL(string:  imagePath){
                cell.imageCategory.af_setImage(withURL: imgUrl)
            }
            else{
                cell.imageCategory.image = nil
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
        //     detailViewController.urlPost1 = urlPost1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//----------------------

/*
 func dismissKeyboard() {
 view.endEditing(true)
 // do aditional stuff
 }
 */
/*
 extension UIViewController {
 func hideKeyboardOnTap(_ selector: Selector) {
 let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
 tap.cancelsTouchesInView = false
 view.addGestureRecognizer(tap)
 }
 }*/
