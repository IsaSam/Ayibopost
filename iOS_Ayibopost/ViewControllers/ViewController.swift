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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DrawerControllerDelegate, UISearchBarDelegate {
    
    var delegate: BookmarkViewController!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatory: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func onTap(_ sender: Any) {
                view.endEditing(true)
    }
    
    var filteredPosts: [[String: Any]]?
    var posts: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    var urlPost1: String?
    var refreshControl: UIRefreshControl!
    var loadNumber = 1
    var urlYoutube = ""
    var convertedDate: String = ""
    var convertedTime: String = ""
    
 //   var favResults: [Post] = []
    var favResults: [[String: Any]] = []
    var favResults1: [[String: Any]] = []
    
    var idx: Int?
    
     // -------------------------------
        // 1.Decllare the drawer view
        var drawerVw = DrawerView()
        
        var vwBG = UIView()
    //--------------------

    @IBAction func addFav(_ sender: UIButton) {
        print("Selected Item #\(sender.tag) as a favorite")
  //      favResults = [posts[idx!]]
      //  if idx! > 0{
            favResults.append(posts[sender.tag])
  //      }else{
    //        favResults.append(posts[0])
      //  }
        
        let vc = ViewController()
        vc.favResults1 = favResults
        
     //   self.delegate.favoritePosts.append(posts[sender.tag])
        
     //   favResults = [posts![idx!]]
 //       print(favResults)
        print("Counter1: \(favResults.count)")
        self.favResults.reverse() //sort
        
       // print(vc.favResults1)
//        print(vc.favResults1.count)
        print("###################################################")
        
       //  self.delegate.favoritePosts.append([favResults)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarLogo()

        searchBar.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(ViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.rowHeight = 330
        tableView.estimatedRowHeight = 350
        
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        
        getPostList()
        //-----------------
        self.navigationController?.navigationBar.isTranslucent = false
        //-----------------
        self.hideKeyboardOnTap(#selector(self.onTap(_:)))
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
        getPostList()
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
         AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?page=\(loadNumber)") { (result, error) in
         
         if error != nil{
        // print(error!)
                let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
                //print(error!)

         return
         }
         //print(result!)
         self.posts = result!
         self.tableView.reloadData() // to tell table about new data
         self.activityIndicatory.stopAnimating() //====================
         }
                self.refreshControl.endRefreshing()
                self.activityIndicatory.stopAnimating()
   
    }
    
    
    func loadMorePosts(){
      loadNumber = loadNumber + 1
      AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?page=\(loadNumber)") { (result, error) in
            
                if error != nil{
                    // print(error!)
                    let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
                    errorAlertController.addAction(cancelAction)
                    self.present(errorAlertController, animated: true)
                    //print(error!)
                    
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
                //print(result!)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath) as! PostsCell
        let post = self.searchBar.text!.isEmpty ? posts[indexPath.row] : filteredPosts![indexPath.row]
        
//        let idx: Int = indexPath.row
        idx = indexPath.row
        cell.favButton.tag = idx!

        let urlPost = post["link"] as! String
        urlPost1 = urlPost as String
        
  //      cell.titleLabel?.text = favResults[idx].title
        cell.titleLabel.text = post["title"] as? String
        let htmlTag = post["content"] as! String
        let content = htmlTag.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        cell.contentLabel.text = content

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
        cell.datePost.text = convertedDate
        
        let html2 = htmlTag.allStringsBetween(start: "<iframe src=", end: "</iframe>")
        let input = String(describing: html2)
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let urlYou = input[range]
            if urlYou != ""{
                urlYoutube = String(urlYou)
                print(urlYoutube)
                cell.picMedia.isHidden = false
                cell.labelMedia.isHidden = false
            }
            else{
                cell.picMedia.isHidden = true
                cell.labelMedia.isHidden = true
               // urlYou = ""
            }
        }
        
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
        
       if segue.identifier == "ViewFav1" {
            print("is true ++++++++++++++++++++++++++++++++")
            let controller = segue.destination as! BookmarkViewController
      //      controller.delegate = self
            controller.favoritePosts = favResults
            
        }else{
            print("is false -------------------------------")
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let post = posts[(indexPath?.row)!]
            let imgPost = imgPosts[(indexPath?.row)!]
            let detailViewController = segue.destination as! DetailsPostViewController
            detailViewController.post = post
            detailViewController.imgPost = imgPost
        }
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
    // 7.Struct for add storyboards which you want show on navigation drawer
    struct DrawerArray {
        static let array:NSArray = ["Home", "Politique", "Society","Economie", "Culture", "Sport", "AyiboTalk"]
}
//----------------------

extension UIViewController {
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

extension String{
    
    func allStringsBetween(start: String, end: String) -> [Any] {
        var strings = [Any]()
        var startRange: NSRange = (self as NSString).range(of: start)
        
        while true {
            if startRange.location != NSNotFound {
                var targetRange = NSRange()
                targetRange.location = startRange.location + startRange.length
                targetRange.length = self.count - targetRange.location
                let endRange: NSRange = (self as NSString).range(of: end, options: [], range: targetRange)
                if endRange.location != NSNotFound {
                    targetRange.length = endRange.location - targetRange.location
                    strings.append((self as NSString).substring(with: targetRange))
                    var restOfString =  NSRange()
                    restOfString.location = endRange.location + endRange.length
                    restOfString.length = self.count - restOfString.location
                    startRange = (self as NSString).range(of: start, options: [], range: restOfString)
                }
                else {
                    break
                }
            }
            else {
                break
            }
            
        }
        return strings
    }
    
}
