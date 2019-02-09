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
}

class DetailsPostViewController: UIViewController {
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var post: [String: Any]?
    var imgPost: [String: Any]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         if let post = post{
         titleLabel.text = post[PostKeys.title] as? String
         let htmlTag = post[PostKeys.content] as! String
         let content = htmlTag.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
         contentLabel.text = content
   
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
