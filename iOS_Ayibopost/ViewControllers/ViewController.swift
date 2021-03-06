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
import SDWebImage

struct favResultsGlobal {
    static var favResultsData: [[String: Any]]?
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DrawerControllerDelegate, UISearchBarDelegate, PostsCellDelegate {
    
    @IBOutlet weak var titleLogo: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicatory: UIActivityIndicatorView!
    var filteredPosts: [[String: Any]]?
    var posts: [[String: Any]] = []
    var postsTitle: [[String: Any]] = []
    var postsContent: [[String: Any]] = []
    var postsEmbed: [[String: Any]] = []
    var postsEmbed1: String?
    var authorDic: [[String: Any]] = []
    var author: String?

    
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
    var authorNameShare: String?
    var imgShare: UIImage?
    var favResults: [[String: Any]] = []
    var favResults1: [[String: Any]] = []
    var postShare: [String: Any] = [:]
    var imagePost1: UIImageView?
    var imagePost2: UIImage?
    var byName: [[String: Any]] = []
    var idx: Int?
    var favClic: UIButton?
    var favClicked: UIButton?
    var f = Bool()
    var searching: [String] = []
    
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
    @IBAction func searchButton(_ sender: Any) {
//        print("Search...")
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem?.accessibilityElementsHidden = true
        navigationItem.rightBarButtonItem?.accessibilityElementsHidden = true
        searchBar.isHidden = false
    }
    
    @IBAction func addFav(_ sender: UIButton) {
        
//        print("Selected Item #\(sender.tag) as a favorite")
        favResults.append(posts[sender.tag])
 //      print(favResults)
  //      print("Counter1: \(favResults.count)")
        self.favResults.reverse() //sort
        
        storeData() //Saved posts
        
        let alert = UIAlertController(title: "Post enregistré avec succès!", message: "A lire plutard dans la liste des signets 📖", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        getData() //get bookmarks
        topBarLogo()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(ViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.rowHeight = 440
        tableView.estimatedRowHeight = 500
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        
        getPostList()
        
        //-----------------
        self.navigationController?.navigationBar.isTranslucent = false
        //-----------------
        
        self.hideKeyboardOnTap(#selector(self.onTap(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getData() // get posts
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        storeData() // saved posts
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
            //**** 2.Implement the drawer view object and set delecate to current view controller
            drawerVw = DrawerView(aryControllers:DrawerArray.array, isBlurEffect:true, isHeaderInTop:false, controller:self)
            drawerVw.delegate = self
            
            // Can change account holder name
            drawerVw.changeUserName(name: "BIENVENUE")
            
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
         AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/wp/v2/posts?&page=\(loadNumber)&_embed") { (result, error) in
         
         if error != nil{
                let errorAlertController = UIAlertController(title: "On ne peut pas obtenir de données", message: "Les connexions Internet semblent être hors ligne", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Réessayer", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
         return
         }
            
         self.posts = result!
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.activityIndicatory.stopAnimating()
                self.activityIndicatory.isHidden = true
            }
         }
         self.refreshControl.endRefreshing()
        
    }
    
    func loadMorePosts(){
        self.activityIndicatory.startAnimating()
        self.activityIndicatory.isHidden = false
        loadNumber = loadNumber + 1
         AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/wp/v2/posts?&page=\(loadNumber)&_embed") { (result, error) in
            
                if error != nil{
                    let errorAlertController = UIAlertController(title: "On ne peut pas obtenir de données", message: "Les connexions Internet semblent être hors ligne", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Réessayer", style: .cancel)
                    errorAlertController.addAction(cancelAction)
                    self.present(errorAlertController, animated: true)
                    
                    return
                }
            if result != nil{
                do{

                    for item in result!
                    {
                        
                        self.posts.append(item)
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                        self.activityIndicatory.stopAnimating()
                        self.activityIndicatory.isHidden = true
                    }
                }
        }else{
                let errorAlertController = UIAlertController(title: "Désolé, Fin des articles!", message: "Remonter la liste", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
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
        //old API
        //    let title = post["title"] as! String
        
        cell.favButton.tag = indexPath.row
        cell.btnSharePosts.tag = indexPath.row
        
        let urlPost = post["link"] as! String
        urlPost1 = urlPost as String
        
//        let encoded = post["title"] as? String            //Old API version
        let encoded = postTitle["rendered"] as? String
        cell.titleLabel.text = encoded?.stringByDecodingHTMLEntities
        titleShare = cell.titleLabel.text
        
//        let htmlTag = post["content"] as! String          //Old API version
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
                cell.picMedia.isHidden = false //icon for media files
            }
            else{
                cell.picMedia.isHidden = true //icon for media files
            }
        }
        
///////
        
        do{
            let imgArray = (postImage as AnyObject).value(forKey: "wp:featuredmedia")//{
            let mediaDetails = (imgArray as AnyObject).value(forKey: "media_details")
            let sizes = (mediaDetails as AnyObject).value(forKey: "sizes")
            do{
                if let compressImg =  (sizes as AnyObject).value(forKey: "blog_half_ft"){
                    if let compressImg2 =  (sizes as AnyObject).value(forKey: "tnm-xs-4_3"){
                         if let compressImg3 =  (sizes as AnyObject).value(forKey: "tnm-xs-1_1"){
                let dataDic = compressImg as? [[String: Any]]
                let dataDic2 = compressImg2 as? [[String: Any]]
                let dataDic3 = compressImg3 as? [[String: Any]]
                        if dataDic != nil{
                            self.imgPosts = dataDic!
                            print("image size 1: 300x300 founded")
                        }else if dataDic2 != nil{
                            self.imgPosts = dataDic2!
                            print("image size 2: 400x300 founded")
                        }else if dataDic3 != nil{
                            self.imgPosts = dataDic3!
                            print("image size 3: 400x400 founded")
                        }
                        else{
                            print("saved sizes not founded")
                        }
        //        if dataDic != nil{
           //         self.imgPosts = dataDic!
                    cell.imagePost.layer.borderColor = UIColor.white.cgColor
                    cell.imagePost.layer.borderWidth = 1.0
                    cell.imagePost.layer.cornerRadius = 10.0
                    
                    for images in imgPosts{
                        let imageURL = images["source_url"] as? String
                        if imageURL != nil{
                            imgURLShare = imageURL!
                        }
                        else{}
                        let url = URL(string: imgURLShare!)
                        cell.imagePost.sd_setImage(with: url, placeholderImage:nil, completed: { (image, error, cacheType, url) -> Void in
                            if ((error) != nil) {
              //                  print("placeholder image...")
                                cell.imagePost.image = UIImage(named: "placeholderImage.png")
                            } else {
                           //     print("Success let using the image...")
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
                }
            }
             
            }
 
        }
        cell.favButton.addTarget(self, action: #selector(ViewController.bookmarkTapped(_:)), for: .touchUpInside)
        cell.btnSharePosts.addTarget(self, action: #selector(ViewController.shareTapped(_:)), for: .touchUpInside)

        return cell
        
        
    }
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // The cell calls this method when the user taps the heart button
    func PostsCellDidTapBookmark(_ sender: PostsCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
//        print("Bookmark", sender, tappedIndexPath)
    }
    
    
    @objc func bookmarkTapped(_ sender: Any?) {
//        print("Bookmark Tapped", sender!)
    }
    func PostsCellDidTapShare(_ sender: PostsCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
 //       print("Sharing", sender, tappedIndexPath)
    }
    
    @objc func shareTapped(_ sender: Any?) {
 //       print("share Tapped", sender!)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if segue.identifier == "ViewFav1" {
   //         print("Bookmarks View segue")
            let controller = segue.destination as! BookmarkViewController
            controller.favoritePosts = favResults
            
       }
       else{
    //        print("DetailsPost View segue")
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
        
        }
    }
    
    @IBAction func btnSharePosts(_ sender: UIButton) {
        
        postShare = posts[sender.tag]
        let postShare1 = (postShare as AnyObject).value(forKey: "title") as! [String : Any]
        let embedDic = (postShare as AnyObject).value(forKey: "_embedded")
        let embedDicString = embedDic! as! [String: Any]
        
        let title = (postShare1["rendered"] as? String)?.stringByDecodingHTMLEntities
        let URl = postShare["link"] as? String
        if let img = (embedDicString as AnyObject).value(forKey: "wp:featuredmedia"){
            let dataDic = img as? [[String: Any]]
            
            self.imgPosts = dataDic!
            for images in imgPosts{
                let imageURL = images["source_url"] as? String
                if let imagePath = imageURL,
                    let imgUrl = URL(string:  imagePath){
                    imagePost1?.af_setImage(withURL: imgUrl)
                }
                else{
                    imagePost1?.image = nil
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
        }
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
        favResultsGlobal.favResultsData = favResults
        }else{}
    }
}

    // 7.Struct for add storyboards which you want show on navigation drawer
    struct DrawerArray {
    static let array:NSArray = ["Accueil", "Politique", "Société", "Économie", "Culture", "Sport", "Podcast","AyiboTalk","Le blog", "Sexualité","Vidéo", " ", "Bookmarks", "Partager", "AppStore", " ", "À propos", "Contact", "L'équipe"]
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
private let characterEntities : [ Substring : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]
extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : Substring, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : Substring) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = self[position...].range(of: ";") else {
                // No matching ';'.
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound
            
            if let decoded = decode(entity) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(contentsOf: entity)
            }
        }
        // Copy remaining characters to `result`:
        result.append(contentsOf: self[position...])
        return result
    }
}

