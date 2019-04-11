//
//  TeamController.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 3/10/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit



class TeamController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,DrawerControllerDelegate{
    
    @IBOutlet weak var titleLogo: UIButton!
    @IBOutlet weak var activityIndicatory: UIActivityIndicatorView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [[String: Any]] = []
    var posts1: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    var urlPost1: String?
    var loadNumber = 50
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
 
 
    var delegate: BookmarkViewController!
    
    // -------------------------------
    // 1.Decllare the drawer view
    var drawerVw = DrawerView()
    var vwBG = UIView()
    //--------------------
    
    @IBAction func viewFav(_ sender: Any) {
        self.performSegue(withIdentifier: "ViewFav3", sender: self)
        //    storeData()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
     
        topBarLogo()
     
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(TeamController.didPullToRefresh(_:)), for: .valueChanged)
     
        collectionView.delegate = self
        collectionView.dataSource = self
   
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 40
        fetchTeamNamePosts()
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
       fetchTeamNamePosts()
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

 func fetchTeamNamePosts(){
   
   self.activityIndicatory.startAnimating() //====================
   //         AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?page=\(loadNumber)") { (result, error) in
   AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?filter[category_name]=&filter[posts_per_page]=\(loadNumber)") { (result, error) in
    
    if error != nil{
     let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline", preferredStyle: .alert)
     let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
     errorAlertController.addAction(cancelAction)
     self.present(errorAlertController, animated: true)
     return
    }
    self.posts1 = result!
   // print(self.posts)
    
    let author = (self.posts1 as AnyObject).value(forKey: "author")
    let dataDicAuthor = author as? [[String: Any]]
    
    for data in dataDicAuthor!{
        print("===========================\(data)")
        let name = data["name"] as? String
     
     if self.authorArray1.contains(name!){
     }else{
          self.authorArray1.append(name!)
          self.byName.append(data)
     }
    }

    self.collectionView.reloadData() // to tell table about new data
 //   self.activityIndicatory.stopAnimating() //====================
   }

  }
 
 func loadMoreAuthors(){
  loadNumber = loadNumber + 50
  self.activityIndicatory.startAnimating() //====================
  //         AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?page=\(loadNumber)") { (result, error) in
  AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?filter[category_name]=&filter[posts_per_page]=\(loadNumber)") { (result, error) in
   
   if error != nil{
    let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
    errorAlertController.addAction(cancelAction)
    self.present(errorAlertController, animated: true)
    return
   }
 //  self.posts1 = result!
   // print(self.posts)
   //////
   do{
    for item in result!
    {
       self.posts1.append(item)
    }
    let author = (self.posts1 as AnyObject).value(forKey: "author")
    let dataDicAuthor = author as? [[String: Any]]
    
    for data in dataDicAuthor!{
     print("===========================\(data)")
     let name = data["name"] as? String
     
     if self.authorArray1.contains(name!){
     }else{
      self.authorArray1.append(name!)
      self.byName.append(data)
     }
    }
    //print(result!)
    self.collectionView.reloadData()
    
   }
   
   
   //////
   
   self.collectionView.reloadData() // to tell table about new data
   //   self.activityIndicatory.stopAnimating() //====================
  }
 }
 
/*
 
 }*/

 func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
  if indexPath.row + 1 == posts1.count{
  }
 }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return self.byName.count
    }
 //////

  /////
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCollectionViewCell", for: indexPath) as! TeamCollectionViewCell
  
  //let post = authorArray[indexPath.row]
  let post = byName[indexPath.row]
  
  let name = post["name"] as? String
  let imageURL = post["avatar"] as? String
  self.authorImgArray.append(imageURL!)

  cell.nameTeam.text = name
  
  if let imagePath = imageURL,
   let imgUrl = URL(string:  imagePath){
   cell.imageTeam.af_setImage(withURL: imgUrl)
  }
  else{
   cell.imageTeam.image = nil
  }
  

  return cell
 }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


