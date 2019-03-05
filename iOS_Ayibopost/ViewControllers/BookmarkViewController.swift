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
    
 //   var favoritePosts: [Post] = []
//    var favoritePosts: [[String: Any]] = []
//    var favoritePosts: [[String: Any]] = []
    var favoritePosts: [[String: Any]]?
    var favoritePosts1: [[String: Any]]?
    var favoritesPosts: [[String: Any]] = []
    var favoritesPosts1: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    var convertedDate: String = ""
    var convertedTime: String = ""
    var urlYoutube = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell",
                                                      for: indexPath) as! PostsCell
        let idx: Int = indexPath.row
        let post = favoritesPosts[idx]
        
        cell.titleLabel.text = post["title"] as? String
        let a = post["title"] as? String
        print("index no: \([idx]) \(a!)")
        
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
        cell.datePost.text = convertedDate
        }
        
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
     //           cell.labelMedia.isHidden = false
            }
            else{
                cell.picMedia.isHidden = true
       //         cell.labelMedia.isHidden = true
                // urlYou = ""
            }
        }
        
        do{
            let imgArray = (favoritesPosts as AnyObject).value(forKey: "featured_image")
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
    
    override func viewWillAppear(_ animated: Bool) {
        favoritesPosts = favoritePosts!
        favTableView.reloadData()
        print("Counter2: \(favoritesPosts.count)")
        /*  if favoriteMovies.count == 0 {
         favoriteMovies.append(Movie(id: "m000001", title: "Coco", year: "2017", imageUrl: "https://i.pinimg.com/originals/48/6d/84/486d84da85de346d0a007af688f4ed31.jpg"))
         }*/
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarLogo()
        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
