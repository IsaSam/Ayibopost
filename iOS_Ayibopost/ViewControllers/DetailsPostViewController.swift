//
//  DetailsPostViewController.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 1/15/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

enum PostKeys {
    static let title = "rendered"
    static let content = "rendered"
    static let image = "_embedded"
    static let date = "date"
    static let link = "link"
}

class DetailsPostViewController: UIViewController{
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var datePost: UILabel!
    @IBOutlet weak var videoView: UIWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel2: UILabel!
    @IBOutlet weak var datePost2: UILabel!
    
    var filteredPosts: [String: Any]?
    var post: [String: Any]?
    var imgPost: [String: Any]?
    var urlPost1: String?
    var urlYoutube = ""
    var nameString: [String: Any]?
    var postTitle: [String: Any]?
    var postContent: [String: Any]?
    var postAuthor: [String: Any]?
    var postImage: [String: Any]?
  //  var author: String?
    var Name: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    
    
    var convertedDate: String = ""
    var convertedTime: String = ""
  //  var BookmarksUp = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(post!)
//        print(BookmarksUp)
        topBarLogo()
        PostSelect()

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
    
    
    func PostSelect(){
        let titleDic = (post as AnyObject).value(forKey: "title")
        let contentDic = (post as AnyObject).value(forKey: "content")
        let embedDic = (post as AnyObject).value(forKey: "_embedded")
        
        let titleDicString = titleDic! as! [String : Any]
        let contentDicString = contentDic! as! [String: Any]
        let embedDicString = embedDic! as! [String: Any]
        
        titleLabel.text = (titleDicString as AnyObject).value(forKey: "rendered") as? String
 //       BookmarksUp = false
        let htmlTag = (contentDicString as AnyObject).value(forKey: "rendered") as? String
        let content = htmlTag?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        contentLabel.text = content?.stringByDecodingHTMLEntities
        
        //Author Name
        if let author = (embedDicString as AnyObject).value(forKey: "author"){
            let dataDicAuthor = author as? [[String: Any]]
            self.Name = dataDicAuthor!
        }
        for author in Name{
            let authorNameE = author["name"] as? String
            let authorName = authorNameE?.stringByDecodingHTMLEntities
            if authorName == "Guest author" || authorName == "Admin" || authorName == "Ayibopost" {
                authorNameLabel.text = ""
                authorNameLabel2.text = ""
            }else{
                authorNameLabel.text = "Par " + authorName!
                authorNameLabel2.text = "Par " + authorName!
                
                
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
        let dateTime = post!["date"] as? String
        let dateComponents = dateTime?.components(separatedBy: "T")
        let splitDate = dateComponents![0]
        let splitTime = dateComponents![1]
        if let date = dateFormatter.date(from: splitDate) {
            convertedDate = newDateFormatter.string(from: date)
        }
        if let time = timeFormatter.date(from: splitTime){
            convertedTime = newTimeFormatter.string(from: time)
        }
        datePost.text = convertedDate
        datePost2.text = convertedDate
        //Images
        let html2 = htmlTag?.allStringsBetween(start: "<iframe src=", end: "</iframe>")
        let input = String(describing: html2)
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let urlYou = input[range]
            if urlYou != ""{
                urlYoutube = String(urlYou)
                print(urlYoutube)
                videoView.isHidden = false
            }
            //     urlYou = String(input[range])
        }
        if urlYoutube != ""{
                   print(urlYoutube)
            //      self.pImage.isHidden = false
            self.postImageView.isHidden = true
            videoView.isHidden = false
            
            videoView.allowsInlineMediaPlayback = true
            videoView.loadHTMLString("<iframe width=\"\(videoView.frame.width)\" height=\"\(videoView.frame.height)\" src=\"\(urlYoutube)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        }
        else{
            videoView.isHidden = true
            if let img = (embedDicString as AnyObject).value(forKey: "wp:featuredmedia"){
                let dataDic = img as? [[String: Any]]
        
                self.imgPosts = dataDic!
                for images in imgPosts{
                    let imageURL = images["source_url"] as? String
                    if let imagePath = imageURL,
                        let imgUrl = URL(string:  imagePath){
                        postImageView.af_setImage(withURL: imgUrl)
                    }
                    else{
                        postImageView.image = nil
                    }
                }
           
            }
    }

        
    }
    

    @IBAction func btnShareTapped(_ sender: Any) {
        let title = titleLabel.text
        let URl = post![PostKeys.link]
        let image = postImageView.image
        
        let vc = UIActivityViewController(activityItems: [title, URl, image], applicationActivities: [])
        if let popoverController = vc.popoverPresentationController{
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        self.present(vc, animated: true, completion: nil)
    }
   /* func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredPosts = searchText.isEmpty ? self.imgPost : self.imgPost?.filter({(imgPost) -> Bool in
            return (imgPost[PostKeys.title] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
