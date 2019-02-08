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

class DetailsPostViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    var filteredPosts: [String: Any]?
    var post: [String: Any]?
    var imgPost: [String: Any]?
    var urlPost1: String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        categoryWeb()

         }
    func categoryWeb(){
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
    @IBAction func btnShareTapped(_ sender: Any) {
        let title = post![PostKeys.title] as? String
        let URl = urlPost1
        let image = imgPost!["source"] as? String
        if let imagePath = image,
            let imgUrl = URL(string:  imagePath){
            postImageView.af_setImage(withURL: imgUrl)
        }
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

  /*  @IBAction func shareButton(_ sender: Any) {

        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }*/


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
