//
//  TheTeamController.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 7/27/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit
import YYHRequest

class TheTeamController: UIViewController, UITableViewDataSource, UITableViewDelegate, DrawerControllerDelegate, PostsCellDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLogo: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatory: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var filteredPosts: [[String: Any]]?
    var posts: [[String: Any]] = []
    var postsTitle: [[String: Any]] = []
    var postsContent: [[String: Any]] = []
    var postsEmbed: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    var imgPostShare: [String: Any]?
    var urlPost1: String?
    var refreshControl: UIRefreshControl!
    var loadNumber = 1
    var urlYoutube = ""
    var convertedDate: String = ""
    var convertedTime: String = ""
    var imgURLShare: String?
    var imgURLShare2: String?
    var titleShare: String?
    var imgShare: UIImage?
    var favResults: [[String: Any]] = []
    var favResults1: [[String: Any]] = []
    var post: [[String: Any]] = []
    var postShare: [String: Any] = [:]
    var imagePost1: UIImageView?
    var imagePost2: UIImage?
    var byName: [[String: Any]] = []
    var idx: Int?
    var favClic: UIButton?
    var favClicked: UIButton?
    var f = Bool()
    var searching: [String] = []
    var catPosts: [[String: Any]] = []
    //   var categori = "business"
    var catID: String?
    var categoryName: String?
    var teamID = false
    var bookID = false
    var shareID = false
    var aboutID = false
    var contactID = false
    var videoID = false
    var appID = false
    
    var delegate: BookmarkViewController!
    
    // -------------------------------
    // 1.Decllare the drawer view
    var drawerVw = DrawerView()
    var vwBG = UIView()
    //--------------------
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
        searchBar.isHidden = true
    }
    
    @IBAction func viewFav(_ sender: Any) {
        self.performSegue(withIdentifier: "ViewFav2", sender: self)
        //    storeData()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        print("Search...")
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem?.accessibilityElementsHidden = true
        navigationItem.rightBarButtonItem?.accessibilityElementsHidden = true
        searchBar.isHidden = false
        //     searchBar.showsCancelButton = true
        //     tableView.tableHeaderView = searchBar
        //     searchBar.searchBarStyle = UISearchBarStyle.default
        //     searchBar.alpha = 0.96
    }
    
    @IBAction func addFav(_ sender: UIButton) {
        
        print("Selected Item #\(sender.tag) as a favorite")
        favResults.append(posts[sender.tag])
        //      print(favResults)
        print("Counter1: \(favResults.count)")
        self.favResults.reverse() //sort
        
        storeData() //Saved posts
        
        let alert = UIAlertController(title: "Post saved successfully!", message: "Read Later all Bookmark's 📖", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        categoryName = MyVariables.categoryDrawerName
        
        print("1***********************************************")
        print(categoryName!)
        
        if categoryName == "Politique"{
            catID = "1"
            categoryLabel.text = "POLITIQUE"
        }
        else if categoryName == "Société"{
            catID = "3"
            categoryLabel.text = "SOCIÉTÉ"
        }
        else if categoryName == "Économie"{
            catID = "37"
            categoryLabel.text = "ÉCONOMIE"
        }
        else if categoryName == "Culture"{
            catID = "7"
            categoryLabel.text = "CULTURE"
        }
        else if categoryName == "Sport"{
            catID = "4"
            categoryLabel.text = "SPORT"
        }
        else if categoryName == "Podcast"{
            catID = "3053"
            categoryLabel.text = " PODCAST "
        }
        else if categoryName == "AyiboTalk"{
            catID = "1287"
            categoryLabel.text = " AYIBOTALK "
        }
        else if categoryName == "Le blog"{
            catID = "3199"
            categoryLabel.text = " LE BLOG "
        }
        else if categoryName == "Sexualité"{
            catID = "3196"
            categoryLabel.text = " SEXUALITÉ "
        }
            /*
             else if categoryName == " "{
             catID = ""
             //    categoryLabel.text = " SEXUALITÉ "
             }
             else if categoryName == "Vidéo"{
             videoID = true
             categoryLabel.text = " VIDÉOS "
             }
             
             else if categoryName == "Bookmarks"{
             bookID = true
             categoryLabel.text = " BOOKMARKS "
             }
             else if categoryName == "Partager"{
             shareID = true
             categoryLabel.text = " PARTAGER "
             }
             else if categoryName == "AppStore"{
             appID = true
             categoryLabel.text = " AppStore "
             }
             else if categoryName == "À propos"{
             aboutID = true
             categoryLabel.text = " À PROPOS "
             }
             else if categoryName == "Contact"{
             contactID = true
             categoryLabel.text = " CONTACT "
             }
             
             else if categoryName == "L'équipe"{
             teamID = true
             categoryLabel.text = " L'ÉQUIPE "
             }
             */
        else{
            //     catID = ""
            //   categoryLabel.text = ""
        }
        
        getData() //get bookmarks
        topBarLogo()
        
        searchBar.delegate = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(ViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.rowHeight = 420
        tableView.estimatedRowHeight = 500
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        
        getPostCategory()
        self.navigationController?.navigationBar.isTranslucent = false
        
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
        getPostCategory()
    }
    
    //-----------------
    @IBAction func actShowMenu(_ sender: Any) {
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
    
    private func getPostCategory(){
        
        self.activityIndicatory.startAnimating() //====================
        AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/wp/v2/posts?page=\(loadNumber)&categories=\(catID!)&_embed") { (result, error) in
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
        
    }
    
    func loadMorePosts(){
        loadNumber = loadNumber + 1
        
        
        
        AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/wp/v2/posts?page=\(loadNumber)&categories=\(catID!)&_embed") { (result, error) in
            
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
                
                ////
                if YYHRequest(url: NSURL(string: self.imgURLShare!)! as URL) != nil {
                    ////
                    print("===========================================")
                    print("body nil")
                    //print(request?.body as Any)
                }else{
                    
                    for item in result!
                        
                    {
                        
                        self.posts.append(item)
                    }
                    print(result!)
                    self.tableView.reloadData() // to tell table about new data
                }
                
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
        idx = indexPath.row
        //=====================================================================
        
        cell.favButton.tag = indexPath.row
        cell.btnSharePosts.tag = indexPath.row
        
        let urlPost = post["link"] as! String
        urlPost1 = urlPost as String
        
        
        do{
            let titleDic = (posts as AnyObject).value(forKey: "title")
            let contentDic = (posts as AnyObject).value(forKey: "content")
            let embedDic = (posts as AnyObject).value(forKey: "_embedded")
            
            let titleDicString = titleDic as? [[String: Any]]
            let contentDicString = contentDic as? [[String: Any]]
            let embedDicString = embedDic as? [[String: Any]]
            
            self.postsTitle = titleDicString!
            self.postsContent = contentDicString!
            self.postsEmbed = embedDicString!
        }
        let postTitle = postsTitle[indexPath.row]
        let postContent = postsContent[indexPath.row]
        let postAuthor = postsEmbed[indexPath.row]
        let postImage = postsEmbed[indexPath.row]
        
        let encoded = postTitle["rendered"] as? String
        cell.titleLabel.text = encoded?.stringByDecodingHTMLEntities
        titleShare = cell.titleLabel.text
        
        let htmlTag =  postContent["rendered"] as! String
        let content = htmlTag.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        cell.contentLabel.text = content.stringByDecodingHTMLEntities
        
        //Author Name
        if let author = (postAuthor as AnyObject).value(forKey: "author"){
            let dataDicAuthor = author as? [[String: Any]]
            self.byName = dataDicAuthor!
        }
        for author in byName{
            let authorNameE = author["name"] as? String
            let authorName = authorNameE?.stringByDecodingHTMLEntities
            if authorName == "Guest author"{
                cell.authorNameLabel.text = ""
            }else{
                cell.authorNameLabel.text = "Par " + authorName!
            }
        }
        
        //date format conversion
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDateFormatter = DateFormatter()
        //        newDateFormatter.dateFormat = "MMM dd, yyyy"
        newDateFormatter.dateFormat = "dd MMM, yyyy"
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
                cell.picMedia.isHidden = false //icon for media files
            }
            else{
                cell.picMedia.isHidden = true //icon for media files
            }
        }
        
        do{
            let imgArray = (postImage as AnyObject).value(forKey: "wp:featuredmedia")//{
            let dataDic = imgArray as? [[String: Any]]
            self.imgPosts = dataDic!
            //          let remoteImageUrlString = imgPosts[indexPath.row]
            //   }
            ////
            for images in imgPosts{
                //   let remoteImageUrlString = imgPosts[indexPath.row]
                //      let imageURL = remoteImageUrlString["source_url"] as? String
                let imageURL = images["source_url"] as? String
                //print(imageURL!)
                if imageURL != nil{
                    imgURLShare = imageURL!
                }
                else{}
                
                let url = URL(string: imgURLShare!)
                
                /*
                 if request?.body == nil{
                 print("body nil =================================")
                 }else{
                 print("nonoonononononononononononononnon")
                 }
                 
                 */
                /*    request.loadWithCompletion {response, data, error in
                 if let actualError = error {
                 // handle error
                 } else if let actualResponse = response {
                 // handle success
                 }
                 }*/
                
                cell.imagePost.sd_setImage(with: url, placeholderImage:nil, completed: { (image, error, cacheType, url) -> Void in
                    if ((error) != nil) {
                        print("placeholder image...")
                        cell.imagePost.image = UIImage(named: "placeholderImage.png")
                    } else {
                        print("Success let using the image...")
                        cell.imagePost.sd_setImage(with: url)
                    }
                })
                if let imagePath = imageURL,
                    let imgUrl = URL(string:  imagePath){
                    cell.imagePost.image = UIImage(named: "loading4.jpg") //image place
                    cell.imagePost.af_setImage(withURL: imgUrl)
                }
                else{
                    cell.imagePost.image = nil
                }
                //  imgShare = cell.imagePost.image
                imagePost1 = cell.imagePost
                imagePost2 = cell.imagePost.image
            }
        }
        
        cell.favButton.addTarget(self, action: #selector(ViewController.bookmarkTapped(_:)), for: .touchUpInside)
        cell.btnSharePosts.addTarget(self, action: #selector(ViewController.shareTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // The cell calls this method when the user taps the heart button
    func PostsCellDidTapBookmark(_ sender: PostsCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("Bookmark", sender, tappedIndexPath)
    }
    
    
    @objc func bookmarkTapped(_ sender: Any?) {
        // We need to call the method on the underlying object, but I don't know which row the user tapped!
        // The sender is the button itself, not the table view cell. One way to get the index path would be to ascend
        // the view hierarchy until we find the UITableviewCell instance.
        print("Bookmark Tapped", sender!)
    }
    func PostsCellDidTapShare(_ sender: PostsCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("Sharing", sender, tappedIndexPath)
    }
    
    @objc func shareTapped(_ sender: Any?) {
        print("share Tapped", sender!)
        
    }
    
    /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     tableView.deselectRow(at: indexPath, animated: true)
     }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ViewFav2" {
            print("Bookmarks View segue")
            let controller = segue.destination as! BookmarkViewController
            controller.favoritePosts = favResults
            
        }
        else{
            print("DetailsPost View segue")
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let post = posts[(indexPath?.row)!]
            let postTitle = postsTitle[(indexPath?.row)!]
            let postContent = postsContent[(indexPath?.row)!]
            let imgPost = postsEmbed[(indexPath?.row)!]
            let nameString = postsEmbed[(indexPath?.row)!]
            let detailViewController = segue.destination as! DetailsPostViewController
            
            detailViewController.post = post
            detailViewController.nameString = nameString
            detailViewController.postTitle = postTitle
            detailViewController.postContent = postContent
            detailViewController.imgPost = imgPost
            detailViewController.nameString = nameString
        }
    }
    
    @IBAction func btnSharePosts(_ sender: UIButton) {
        postShare = posts[sender.tag]
        let postShare1 = (postShare as AnyObject).value(forKey: "title") as! [String : Any]
        let title = (postShare1["rendered"] as? String)?.stringByDecodingHTMLEntities
        let URl = postShare["link"] as? String
        imgPostShare = imgPosts[(sender.tag)]
        let imageURL = imgPostShare!["source_url"] as? String
        
        if let imagePath = imageURL,
            let imgUrl = URL(string:  imagePath){
            imagePost1?.af_setImage(withURL: imgUrl)
        }
        else{
            //  imagePost1.image = nil
        }
        let image = imagePost1?.image
        
        let vc = UIActivityViewController(activityItems: [title, URl, image], applicationActivities: [])
        if let popoverController = vc.popoverPresentationController{
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        self.present(vc, animated: true, completion: nil)
        imagePost1?.image = imagePost2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Storing app data
    func storeData(){
        let data = NSKeyedArchiver.archivedData(withRootObject: favResults)
        UserDefaults.standard.set(data, forKey: "savedData1")
    }
    
    //Getting app data
    func getData(){
        let outData = UserDefaults.standard.data(forKey: "savedData1")
        if outData != nil{
            let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!)as! [[String: Any]]
            favResults = dict
        }else{}
    }
}
//----------------------
