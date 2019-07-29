//
//  TeamController.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 3/10/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit



//class TeamController: UIViewController, UITableViewDataSource, UITableViewDelegate, DrawerControllerDelegate, PostsCellDelegate, UISearchBarDelegate{
 class TeamController: UIViewController, UITableViewDataSource, UITableViewDelegate, DrawerControllerDelegate, UISearchBarDelegate{
 
 
 @IBOutlet weak var tableView: UITableView!
 @IBOutlet weak var titleLogo: UIButton!
 @IBOutlet weak var activityIndicatory: UIActivityIndicatorView!
 
 
 var posts: [[String: Any]] = []
 var posts1: [[String: Any]] = []
 var posts2: [String: Any] = [:]
 var imgPosts: [[String: Any]] = []
 var urlPost1: String?
 var favResults: [[String: Any]] = []
 var favResults1: [[String: Any]] = []
 var post: [[String: Any]] = []
 var imagePost1: UIImageView?
 var imagePost2: UIImage?
 var idx: Int?
 var favClic: UIButton?
 var favClicked: UIButton?
 var f = Bool()
 var catPosts: [[String: Any]] = []
 var categori: String?
 var categoryName: String?
 var refreshControl: UIRefreshControl!
 var titleAuthor = ""
 var authorArray: [String] = []
 var authorArray1: [String] = []
 var authorArray2: [[String: Any]] = []
 var authorImgArray: [String] = []
 var byName: [[String: Any]] = []
 var urlImage: String?
 var urlImage1: String?
 
 var filteredPosts: [[String: Any]]?
 var urlYoutube = ""
 var convertedDate: String = ""
 var convertedTime: String = ""
 var imgURLShare: String?
 var imgURLShare2: String?
 var titleShare: String?
 var imgShare: UIImage?
 var searching: [String] = []
 let intArrID = [55, 102, 120, 3, 117, 118, 116, 105]
 var loadNumber = 0
 var postsEmbed: [[String: Any]] = []
 var postsAvatar: [[String: Any]] = []
 var id: String?
  var valueToPass:String!
 
 var delegate: BookmarkViewController!
 
 // -------------------------------
 // 1.Decllare the drawer view
 var drawerVw = DrawerView()
 var vwBG = UIView()
 //--------------------
 
 /***
 @IBAction func viewFav(_ sender: Any) {
  self.performSegue(withIdentifier: "ViewFav3", sender: self)
  //    storeData()
 }
 ***/
 override func viewDidLoad() {
  super.viewDidLoad()
  
  topBarLogo()
  
  self.refreshControl = UIRefreshControl()
  self.refreshControl.addTarget(self, action: #selector(TeamController.didPullToRefresh(_:)), for: .valueChanged)
  
  tableView.delegate = self
  tableView.rowHeight = 370
  tableView.estimatedRowHeight = 370
  tableView.insertSubview(refreshControl, at: 0)
  self.tableView.separatorColor = UIColor.white
  
  tableView.delegate = self
  tableView.dataSource = self
  
  fetchTeamID()
  self.navigationController?.navigationBar.isTranslucent = false
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
  fetchTeamID()
 }
 
 @IBAction func actShowMenu(_ sender: Any) {
  drawerVw = DrawerView(aryControllers:DrawerArray.array, isBlurEffect:true, isHeaderInTop:false, controller:self)
  drawerVw.delegate = self
  drawerVw.changeUserName(name: "WELCOME")
  drawerVw.show()
 }
 
 func pushTo(viewController: UIViewController) {
  self.navigationController?.pushViewController(viewController, animated: true)
 }
 
 func fetchTeamID(){
  let intArrID = [55, 102, 120, 3, 117, 118, 116, 105]
  let loadNumber = 0
  let ID = intArrID[loadNumber]
  let url = URL(string: "https://ayibopost.com/wp-json/wp/v2/users/\(ID)")!
  let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
  let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
  let task = session.dataTask(with: request) {(data, response, error) in
   //-- This will run when the network request returns
   if let error = error{
    let errorAlertController = UIAlertController(title: "Cannot Get data Authors", message: "The Internet connections appears to be offline", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
    errorAlertController.addAction(cancelAction)
    self.present(errorAlertController, animated: true)
    print(error.localizedDescription)
   } else if let data = data,
    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
    
    self.posts2 = dataDictionary
   //   print(self.posts2)
    
      let name = dataDictionary["name"] as! String
      print(name)
    
   }
   self.posts.append(self.posts2)
   self.tableView.reloadData()
   
  }
  task.resume()

 }
 func fetchMoreTeamID(){
  loadNumber = loadNumber + 1
  if loadNumber < intArrID.count{
     let ID = intArrID[loadNumber]
  
  let url = URL(string: "https://ayibopost.com/wp-json/wp/v2/users/\(ID)")!
  let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
  let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
  let task = session.dataTask(with: request) {(data, response, error) in
   //-- This will run when the network request returns
   if let error = error{
    let errorAlertController = UIAlertController(title: "Cannot Get data Authors", message: "The Internet connections appears to be offline", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
    errorAlertController.addAction(cancelAction)
    self.present(errorAlertController, animated: true)
    print(error.localizedDescription)
   } else if let data = data,
    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
    
    self.posts2 = dataDictionary
    
    
    let name = dataDictionary["name"] as! String
    print(name)
    
   }
   self.posts.append(self.posts2)
   self.tableView.reloadData()
   
  }
  task.resume()
   
  }else{}
  
 }
 
 
 func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
  if indexPath.row + 1 == posts.count{
        print("load More...")
        fetchMoreTeamID()
  }
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   // return self.byName.count
    return self.posts.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath) as! PostsCell
  
  cell.layer.borderColor = UIColor.white.cgColor
  cell.layer.borderWidth = 10.0
  cell.layer.masksToBounds = true
  
  
 // do{
      //============
      let embedDic = (posts as AnyObject).value(forKey: "simple_local_avatar")
      let embedDicString = embedDic as? [[String: Any]]
      if embedDicString != nil{
         self.postsEmbed = embedDicString!
      print("You selected cell #\(indexPath.row)!")
 //  }
  
  
    let post = posts[indexPath.row]
    let postImage = postsEmbed[indexPath.row]
   
  let name = (post["name"] as? String)?.stringByDecodingHTMLEntities
  let description = (post["description"] as? String)?.stringByDecodingHTMLEntities
  id = post["id"] as? String
  //// self.authorImgArray.append(imageURL!)
  cell.nameTeam.text = name?.uppercased()
  cell.descripTeam.text = description
  
  let imageURL = postImage["180"] as? String
  print(imageURL!)
  if let imagePath = imageURL,
   let imgUrl = URL(string:  imagePath){
   cell.imageTeam.layer.borderColor = UIColor.white.cgColor
   cell.imageTeam.layer.borderWidth = 6.0
   cell.imageTeam.layer.cornerRadius = cell.imageTeam.frame.height / 2
   cell.imageTeam.clipsToBounds = true
   cell.imageTeam.af_setImage(withURL: imgUrl)
  }
  else{
   cell.imageTeam.layer.borderColor = UIColor.white.cgColor
   cell.imageTeam.layer.borderWidth = 6.0
   cell.imageTeam.layer.cornerRadius = cell.imageTeam.frame.height / 2
   cell.imageTeam.clipsToBounds = true
   //cell.imageTeam.image = nil
   cell.imageTeam.image = UIImage(named: "FN.jpg") //image place
  }
  }else{}
  return cell
  
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  tableView.deselectRow(at: indexPath, animated: true)
  performSegue(withIdentifier: "authorPosts", sender: indexPath)
 }
/***
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
  
 }***/
 
  /***
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  print("segue........")
/***
  if segue.identifier == "ViewFav3" {
   print("Bookmarks View segue")
   let controller = segue.destination as! BookmarkViewController
   controller.favoritePosts = favResults
   
  }***/
   
  if segue.identifier == "authorPosts"{
   print("By AuthorPost View segue")
   
   /***
   let cell = sender as! UITableViewCell
   let indexPath = tableView.indexPath(for: cell)
   let post = posts[(indexPath?.row)!]
 //  let imgPost = imgPosts[(indexPath?.row)!]
//   let nameString = byName[(indexPath?.row)!]
   let authorPosts = segue.destination as! AuthorPosts
   authorPosts.post = post
  // authorPosts.id = id
   
//   detailViewController.imgPost = imgPost
//   detailViewController.nameString = nameString
   
   ***/
   
  }
  else{}
  
 }
  
  ***/
  /*func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
   
   if (segue.identifier == "authorPosts") {
    print("segue............")
    // initialize new view controller and cast it as your view controller
    let authorPosts = segue.destination as! AuthorPosts
    // your new view controller should have property that will store passed value
    //authorPosts.post = post
    authorPosts.post = post
   }
  }*/
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
   // Get the index path from the cell that was tapped
   let indexPath = tableView.indexPathForSelectedRow
   // Get the Row of the Index Path and set as index
   let index = indexPath?.row
   // Get in touch with the DetailViewController
   let authorPosts = segue.destination as! AuthorPosts
   // Pass on the data to the Detail ViewController by setting it's indexPathRow value
   authorPosts.index = index
  }
 
 override func didReceiveMemoryWarning() {
  super.didReceiveMemoryWarning()
  // Dispose of any resources that can be recreated.
 }
 //Storing app data
 
 /***
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
 ***/
 
}


