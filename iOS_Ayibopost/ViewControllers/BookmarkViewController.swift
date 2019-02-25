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
    
 /*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewFav" {
            let controller = segue.destination as! ViewController
            controller.delegate = self
        }
    }*/
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
        
        //  moviecell.movieTitle?.text = favoriteMovies[idx].title
 ////       cell.titleLabel.text = favoritePosts[idx].title
  //      cell.titleLabel.text = "ok1"
   //     cell.titleLabel.text = favoritePosts["title"]
        
        //moviecell.movieYear?.text = favoriteMovies[idx].year
 /////       cell.contentLabel.text = favoritePosts[idx].content
 /////       cell.datePost.text = favoritePosts[idx].date
        
    //    displayMovieImage(idx, moviecell: moviecell)
   //     displayPostImage(idx, cell: PostsCell)
        
        return cell
    }
    
  /*  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205
    }*/
    
 /*   func displayPostImage(_ row: Int, cell: PostsCell) {
        let url: String = (URL(string: favoritePosts [row].imageUrl)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data,
            response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)
                cell.imagePost.image = image
            })
        }).resume()
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        favoritesPosts = favoritePosts!
    //    print(favoritesPosts)
 /*       for item1 in favoritesPosts1{
            favoritesPosts1.append(item1)
        }
        for item in favoritesPosts{
            favoritesPosts.append(item)
        }*/
        
        favTableView.reloadData()
        print("Counter2: \(favoritesPosts.count)")
        /*  if favoriteMovies.count == 0 {
         favoriteMovies.append(Movie(id: "m000001", title: "Coco", year: "2017", imageUrl: "https://i.pinimg.com/originals/48/6d/84/486d84da85de346d0a007af688f4ed31.jpg"))
         }*/
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        favTableView.dataSource = self
  //      favTableView.delegate = self
  //      print(favoritesPosts.count)
    //    print(favoritesPosts)
        
        favTableView.delegate = self
        favTableView.rowHeight = 330
        favTableView.estimatedRowHeight = 350
    
        favTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
