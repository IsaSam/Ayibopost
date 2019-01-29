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
    static let postID = "id"
    static let imgURL = "source"
}

class DetailsPostViewController: UIViewController {
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var post: [String: Any]?
    //var remoteImageUrlString: [[String: Any]]?
    var imgPost: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
         if let post = post{
         titleLabel.text = post[PostKeys.title] as? String
         contentLabel.text = post["content"] as? String
   
            let imageURL = imgPost!["source"] as? String
            if let imagePath = imageURL,
                let imgUrl = URL(string:  imagePath){
                postImageView.af_setImage(withURL: imgUrl)
            }
            else{
                postImageView.image = nil
            }
         }
            /*if let imagePath = imgPost,
                let imgPost = URL(string:  imagePath){
                postImageView.af_setImage(withURL: imgPost)
            }
            else{
                postImageView.image = nil
            }*/
         }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
