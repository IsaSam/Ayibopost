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
    var loadNumber = 20
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
 
 override func viewWillAppear(_ animated: Bool) {
  fetchName()
 }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //    self.collectionView.reloadSections(IndexSet(integer: 0))
     
        topBarLogo()
     
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(TeamController.didPullToRefresh(_:)), for: .valueChanged)
     
        collectionView.delegate = self
        collectionView.dataSource = self
   
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 40
 //       fetchName()
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
       // getPost()
 //    fetchName()
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
 
 func fetchName(){
  //activityIndicator.startAnimating()
  
  let url = URL(string: "https://ayibopost.com/wp-json/pages/about-us/lequipe/")!
  
  let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
  let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
  let task = session.dataTask(with: request) {(data, response, error) in
   //-- This will run when the network request returns
   if let error = error{
    let errorAlertController = UIAlertController(title: "Cannot Get Datas", message: "The Internet connections appears to be offline", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
    errorAlertController.addAction(cancelAction)
    self.present(errorAlertController, animated: true)
    print(error.localizedDescription)
   } else if let data = data,
    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{

      self.posts1 = [dataDictionary]
      for item in self.posts1{
       let htmlTag = item["content"] as! String
       let content = htmlTag.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression, range: nil)
       let fullNameArr = content.components(separatedBy: "         ")
       
       let size = fullNameArr.count - 1
       
       for i in 0...size{
        let name = fullNameArr[i]
   //     print(name)
        self.authorArray1.append(name)
        
  //      self.collectionView.reloadData() // to tell table about new data
       }
      }

    }
   
  }
  task.resume()
  //activityIndicator.stopAnimating()
 }
 
 func fetchTeamNamePosts(){
   
   self.activityIndicatory.startAnimating() //====================
   //         AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?page=\(loadNumber)") { (result, error) in
   AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?filter[category_name]=&filter[posts_per_page]=7") { (result, error) in
    
    if error != nil{
     let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline", preferredStyle: .alert)
     let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
     errorAlertController.addAction(cancelAction)
     self.present(errorAlertController, animated: true)
     return
    }
    self.posts = result!
   // print(self.posts)
    self.collectionView.reloadData() // to tell table about new data
 //   self.activityIndicatory.stopAnimating() //====================
   }
 //  self.refreshControl.endRefreshing()
 //  self.activityIndicatory.stopAnimating()
  }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //    return self.authorArray.count
     return self.posts.count
    }
    
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCollectionViewCell", for: indexPath) as! TeamCollectionViewCell
 // let post = authorArray[indexPath.row]
 // cell.nameTeam.text = post
  
  let post = posts[indexPath.row]
  //author name
  let author = (posts as AnyObject).value(forKey: "author")
  let dataDicAuthor = author as? [[String: Any]]
  self.byName = dataDicAuthor!
  let nameString = byName[indexPath.row]
  let authorName = nameString["first_name"] as? String
  if authorName == "Guest author"{
  // cell.authorNameLabel.text = "By Guest"
   print("By Guest")
  }
 /* else if authorName == "Jameson"{
      print("\(authorName!)\(indexPath.row)")
  }else{}
  */
  
  else{
   for authorPost in byName{
      let authorPostName = authorPost["name"] as? String
 //  }
   for author in authorArray1{
    if author == authorPostName{
        print("item\(author)")
        print("Trouve \(authorPostName!) and path \(indexPath.row)")
    }else{
        print("item\(author)")
        print("item\(authorPostName!)")
        print("-------")
    }
   }
  }
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

