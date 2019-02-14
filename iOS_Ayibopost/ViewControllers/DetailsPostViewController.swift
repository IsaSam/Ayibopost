//
//  DetailsPostViewController.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 1/15/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

enum PostKeys {
    static let title = "title"
    static let content = "content"
    static let date = "date"
    static let link = "link"
}

class DetailsPostViewController: UIViewController{
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var datePost: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    var filteredPosts: [String: Any]?
    var post: [String: Any]?
    var imgPost: [String: Any]?
    var urlPost1: String?
    
    var convertedDate: String = ""
    var convertedTime: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarLogo()
        categoryWeb()

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
    func categoryWeb(){
        if let post = post{
            
            titleLabel.text = post[PostKeys.title] as? String
            let htmlTag = post[PostKeys.content] as! String
            let content = htmlTag.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            contentLabel.text = content
            //datePost.text = post[PostKeys.date] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "MMM dd, yyyy"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH-mm-ss"
            let newTimeFormatter = DateFormatter()
            newTimeFormatter.dateFormat = "h:mm a"
            let dateTime = post[PostKeys.date] as? String
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
            
            let imageURL = imgPost!["source"] as? String
            if let imagePath = imageURL,
                let imgUrl = URL(string:  imagePath){
                postImageView.af_setImage(withURL: imgUrl)
            }
            else{
                postImageView.image = nil
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
