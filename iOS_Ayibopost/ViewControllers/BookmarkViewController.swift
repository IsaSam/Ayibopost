//
//  BookmarkViewController.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 2/22/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit



class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favTableView: UITableView!
    
    var mainViewController:ViewController?
    
    var favoritePosts: [[String: Any]]?
    var favoritePosts1: [[String: Any]]?
    var favoritesPosts: [[String: Any]] = []
    var favoritesPosts1: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    var byName: [[String: Any]] = []
    var convertedDate: String = ""
    var convertedTime: String = ""
    var urlYoutube = ""
    
    var postsTitle: [[String: Any]] = []
    var postsContent: [[String: Any]] = []
    var postsEmbed: [[String: Any]] = []
    var imgURLShare: String?
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell",
                                                 for: indexPath) as! PostsCell
        let idx: Int = indexPath.row
        let post = favoritesPosts[idx]
        
        let titleDic = (post as AnyObject).value(forKey: "title")
        let contentDic = (post as AnyObject).value(forKey: "content")
        let embedDic = (post as AnyObject).value(forKey: "_embedded")
        
        let titleDicString = titleDic! as! [String : Any]
        let contentDicString = contentDic! as! [String: Any]
        let embedDicString = embedDic! as! [String: Any]
        
        self.postsTitle = [titleDicString]
        self.postsContent = [contentDicString]
        self.postsEmbed = [embedDicString]
        
        //        print(self.postsTitle)
        //      let postTitle = postsTitle[indexPath.row]
        cell.titleLabel.text = (titleDicString as AnyObject).value(forKey: "rendered") as? String
        let htmlTag = (contentDicString as AnyObject).value(forKey: "rendered") as? String
        let content = htmlTag?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        cell.contentLabel.text = content?.stringByDecodingHTMLEntities
        
        //Author Name
        if let author = (embedDicString as AnyObject).value(forKey: "author"){
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
        //Date
        
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
        //Images
        
        do{
            let imgArray = (embedDicString as AnyObject).value(forKey: "wp:featuredmedia")//{
            let dataDic = imgArray as? [[String: Any]]
            self.imgPosts = dataDic!
            if dataDic != nil{
          //      self.imgPosts = dataDic!
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
                    cell.imagePost.layer.borderColor = UIColor.white.cgColor
                    cell.imagePost.layer.borderWidth = 2.0
                    cell.imagePost.layer.cornerRadius = 12.0
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
                    
                    ////
                    
                    
              //        imgShare = cell.imagePost.image
                      //imagePost1 = cell.imagePost
                      //imagePost2 = cell.imagePost.image
                }
            }else{}
        }
        
        //end Img
        
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if favoritePosts != nil{
            favoritesPosts = favoritePosts!
        
        favTableView.reloadData()
        print("Counter2: \(favoritesPosts.count)")
        super.viewWillAppear(animated)
        }else{
            favoritesPosts = favResultsGlobal.favResultsData!
            favTableView.reloadData()
            print("Counter3: \(favoritesPosts.count)")
            super.viewWillAppear(animated)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarLogo()
        categoryLabel.layer.borderWidth = 0.3
        categoryLabel.layer.borderColor = UIColor.lightGray.cgColor
        
        favTableView.delegate = self
        favTableView.rowHeight = 170
        favTableView.estimatedRowHeight = 170
    
        favTableView.dataSource = self
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = favTableView.indexPath(for: cell)
        let post = favoritesPosts[(indexPath?.row)!]
        
        let detailViewController = segue.destination as! DetailsPostViewController
        detailViewController.post = post
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
