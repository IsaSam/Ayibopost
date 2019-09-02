//
//  DetailsPostViewController.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 1/15/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit
//import WebKit

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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel2: UILabel!
    @IBOutlet weak var datePost2: UILabel!
    @IBOutlet weak var authorPicture: UIImageView!
    @IBOutlet weak var authorPicture2: UIImageView!
    @IBOutlet weak var authorDesc: UILabel!
    @IBOutlet weak var activityIndicatoryWeb: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
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
    var authorsImg: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    
    
    var convertedDate: String = ""
    var convertedTime: String = ""
  //  var BookmarksUp = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatoryWeb.hidesWhenStopped = true
        
        
        //print(post!)
//        print(BookmarksUp)
        topBarLogo()
        PostSelect()

         }
  /*  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        activityIndicatoryWeb.startAnimating()
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicatoryWeb.stopAnimating()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        activityIndicatoryWeb.stopAnimating()
    }*/
    
    // show indicator
    func webViewDidStartLoad(_ webView: UIWebView){
        activityIndicatoryWeb.startAnimating()
        activityIndicatoryWeb.isHidden = false
    }
    // hide indicator
    func webViewDidFinishLoad(_ webView: UIWebView){
        activityIndicatoryWeb.stopAnimating()
        activityIndicatoryWeb.isHidden = true
    }
     // hide indicator
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        activityIndicatoryWeb.stopAnimating()
        activityIndicatoryWeb.isHidden = true
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
            
            let authorImg = (author as AnyObject).value(forKey: "simple_local_avatar")
            let authorImgDic = authorImg as? [[String: Any]]
            if authorImgDic != nil{
                self.authorsImg = authorImgDic!
            }

        }
        
        for author in Name{
            let authorNameE = author["name"] as? String
            let authorDescR = author["description"] as? String
            let authorName = authorNameE?.stringByDecodingHTMLEntities
            let authorDescr = authorDescR?.stringByDecodingHTMLEntities
            if authorName == "Guest author" || authorName == "Admin" || authorName == "Ayibopost" {
                authorNameLabel.text = ""
                authorNameLabel2.text = ""
            }else{
                authorNameLabel.text = "Par " + authorName!
                authorNameLabel2.text = authorName!
            }
            authorDesc.text = authorDescr!
        }
        
        for image in authorsImg{
            let imageURL = image["80"] as? String
            let imageURL2 = image["80"] as? String
            if let imagePath = imageURL,
                let imgUrl = URL(string:  imagePath){
                authorPicture.layer.borderColor = UIColor.white.cgColor
                authorPicture.layer.borderWidth = 2.0
                authorPicture.layer.cornerRadius = authorPicture.frame.height / 2
                authorPicture.clipsToBounds = true
                authorPicture.af_setImage(withURL: imgUrl)
            }
            else{
                authorPicture.layer.borderColor = UIColor.white.cgColor
                authorPicture.layer.borderWidth = 2.0
                authorPicture.layer.cornerRadius = authorPicture.frame.height / 2
                authorPicture.clipsToBounds = true
                //cell.imageTeam.image = nil
                authorPicture.image = UIImage(named: "FN.jpg") //image place
            }
            if let imagePath2 = imageURL2,
                let imgUrl2 = URL(string: imagePath2){
                authorPicture2.layer.borderColor = UIColor.white.cgColor
                authorPicture2.layer.borderWidth = 2.0
                authorPicture2.layer.cornerRadius = authorPicture2.frame.height / 2
                authorPicture2.clipsToBounds = true
                authorPicture2.af_setImage(withURL: imgUrl2)
            }
            else{
                authorPicture2.layer.borderColor = UIColor.white.cgColor
                authorPicture2.layer.borderWidth = 2.0
                authorPicture2.layer.cornerRadius = authorPicture2.frame.height / 2
                authorPicture2.clipsToBounds = true
                //cell.imageTeam.image = nil
                authorPicture2.image = UIImage(named: "FN.jpg") //image place
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
           //     print(urlYoutube)
                webView.isHidden = false
            }
            //     urlYou = String(input[range])
        }
        if urlYoutube != ""{
                   print(urlYoutube)
            //      self.pImage.isHidden = false
            self.postImageView.isHidden = true
            webView.isHidden = false
            
            webView.allowsInlineMediaPlayback = true
            webView.loadHTMLString("<iframe width=\"\(webView.frame.width)\" height=\"\(webView.frame.height)\" src=\"\(urlYoutube)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
       //     webView.delegate = self as? UIWebViewDelegate
            self.activityIndicatoryWeb.stopAnimating()
            self.activityIndicatoryWeb.isHidden = true
        }
        else{
            webView.isHidden = true
            self.activityIndicatoryWeb.stopAnimating()
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
