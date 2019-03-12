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

    //    self.collectionView.reloadSections(IndexSet(integer: 0))
     
        topBarLogo()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(TeamController.didPullToRefresh(_:)), for: .valueChanged)
     
        collectionView.delegate = self
        collectionView.dataSource = self
   
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 40
  /*      let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = view.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
     */
  //      collectionView.insertSubview(refreshControl, at: 0)

        getPost()
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
        getPost()
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
    
    private func getPost(){
        
        self.activityIndicatory.startAnimating() //====================
     
 //        AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts?filter[category_name]=&filter[posts_per_page]=\(loadNumber)") { (result, error) in
          
          AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/pages") { (result, error) in
            
            if error != nil{
                // print(error!)
                let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
              //  print(error!)
                
                return
            }
         //   print(result!)
            self.posts = result!
            self.collectionView.reloadData() // to tell table about new data
            self.activityIndicatory.stopAnimating() //====================
        }
        self.refreshControl.endRefreshing()
        self.activityIndicatory.stopAnimating()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.posts.count
    }
    
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCollectionViewCell", for: indexPath) as! TeamCollectionViewCell
  let post = posts[indexPath.row]
  let id = post["ID"] as? Int
  
  let htmlTag = post["content"] as! String
  let content = htmlTag.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression, range: nil)
  //    contentLabel.text = content
  if id == 15790 {
   print("content 1 |||||||||||||||||||||||||||||||||||||||||||")
   //   print("\(content)")
   //  let fullName    = "First Last Thing"
   //     let fullNameArr: [String] = []
   let fullNameArr = content.components(separatedBy: "         ")
   
   let size = fullNameArr.count - 1
   
   for i in 0...size{
    let name = fullNameArr[i]
    print("\(name)^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\(i)")
    authorArray.append(name)
   }
   
   let urlPost = post["link"] as! String
   urlPost1 = urlPost as String
   for item in authorArray{
    //print(item)
   // print(authorArray)
    cell.nameTeam.text = item

    
   }
   
  }
  
  return cell
 }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ViewFav3" {
            print("Bookmarks View segue")
            let controller = segue.destination as! BookmarkViewController
        }
        else{/*
            print("DetailsPost View segue")
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let post = posts[(indexPath?.row)!]
            let imgPost = imgPosts[(indexPath?.row)!]
            let nameString = byName[(indexPath?.row)!]
            let detailViewController = segue.destination as! DetailsPostViewController
            detailViewController.post = post
            detailViewController.imgPost = imgPost
            detailViewController.nameString = nameString
           */
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
