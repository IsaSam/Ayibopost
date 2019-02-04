//
//  Sport.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 2/1/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class Sport: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [[String: Any]] = []
    var imgPosts: [[String: Any]] = []
    var termPosts: [[String: Any]] = []
    var catPost1: [[String: Any]] = []
    //var catPosts = [String: Any]()
    var catPosts: [[String: Any]] = []
    var catPosts2 = [AnyObject]()
    var catPosts3 = [String]()
    var catPosts4: [[String: AnyObject]] = []
    var catPosts5 = ["SPORT"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 350
        self.tableView.estimatedRowHeight = 350
        
        getPostList()
        loadList2()
    }
    private func getPostList(){
        AyiboAPIManager.shared.get(url: "https://ayibopost.com/wp-json/posts/") { (result, error) in
            
            if error != nil{
                print(error!)
                return
            }
            //print(result!)
            //self.posts = result!
           
            /*==============new comment
            do{
                guard let catArray = (result! as AnyObject).value(forKey: "terms") else{return}
                self.posts = catArray as! [[String : Any]]
                //print(self.posts)
                
                guard let catArray2 = (self.posts as AnyObject).value(forKey: "category") else{return}
                
               // self.catPosts2 = catArray2 as! [[String: Any]] as [AnyObject]
                self.catPosts = catArray2 as! [[String : Any]]
                //self.catPosts = (catArray2 as? [[String : Any]])!
                //print(catArray2 )
                //dump(catArray2)
                
                //for value in (catArray2 as? String)!
                for value in self.catPosts
                {
                    if let category = value["name"] as? String
                    {
                        print(category)
                    }
                }
                //}
            }*/
            /*
            do{
                guard let catArray = (result! as AnyObject).value(forKey: "terms") else{return}
                self.posts = catArray as! [[String : Any]]
                //print(self.posts)
                
                guard let catArray2 = (self.posts as AnyObject).value(forKey: "category") else{return}
                
                //self.catPosts = (catArray2 as? [[String : Any]])!
                //print(catArray2 )
                //dump(catArray2)
                
                //for value in (catArray2 as? String)!
                for value in catArray2
                {
                    if let category = value["name"] as? String
                    {
                        print(category)
                    }
                }
            }*/

                //self.catPost1 = catDic
                //print(self.catPost1)
                
                
                //print(self.posts)
                    //let catDic = catArray2 as? [[String: Any]]
                    //self.catPost1 = catDic!
                    //self.tableView.reloadData()
                    //print(self.catPost1)
                
                
                //print(catArray2)
                
                //if let catArray1 = catArray! as? [[String: Any]],
                //let catArray1 = catArray! as? [[String: Any]]

                
                
                /*========================good
                let catDic = catArray as? [[String : Any]]
                
                self.catPost1 = catDic!
                print(self.catPost1)
                ===========================*/
                /*for cat in catDic!{
                 if let name = cat["name"] as? String{
                 self.catPosts.append(name)
                 print(self.catPosts)
                 }*/
                
                
                 //}
            
           
                
            //}
            
            self.tableView.reloadData() // to tell table about new data
        }
        
    }
    
    func loadList2(){
        let url2 = URL(string: "https://ayibopost.com/wp-json/taxonomies/category/terms")
        let task = URLSession.shared.dataTask(with: url2!){
            (data, response, error) in
            
            if error != nil
            {
                print("ERROR")
            }
            else{
                do{
                    if let content = data{
                        let myResults = try JSONSerialization.jsonObject(with: content, options: .mutableContainers)
                        //print(myJson)
                        //dump(myResults)
                        
                        self.catPosts = myResults as! [[String : Any]]
                        for value in self.catPosts
                        {
                            if let category = value["name"] as? String
                            {
                                self.catPosts3 = [category]
                                
                               // print(self.catPosts3)
                                
                                print(category)
                                if category.contains("SPORT"){
                                    print("found")   }else{
                                    print("not found")   }
                                //self.catPosts3 = [category]
                                //self.tableView.reloadData()
                            }
                            
                            
                            /*
                             let result = category.filter { $0 == 5 }
                             if result.isEmpty {
                             print("no")// element does not exist in array
                             } else {
                             print("yes")// element exists
                             }
                            */

                        }
                        
                        
                        /*
                         if let jsonData = myJson as? [String : Any]
                         {
                         if let myResults = jsonData["results"] as? [[String : Any]]
                         {
                         //print(myResults)
                         //dump(myResults)
                         }
                         }*/
                    }
                }
                catch
                {
                    
                }
            }
            
        }
        task.resume()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catPosts3.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell

        let term = catPosts3[indexPath.row]
        
        
        /*
        do{
            let imgArray = (posts as AnyObject).value(forKey: "terms")    
            //let termDic = imgArray as? [[String: Any]]
            //self.termPosts = termDic!
            //print(termPosts ?? "termPost nil")
            let term1 = imgArray![indexPath.row]
            let catPos = term["category"] as? String
            print(catPos ?? "nil catpos")
            /*-------------
             do {
             if let data = data,
             let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
             let blogs = json["featured"] as? [[String: Any]] {
             print("ok1")
             for blog in blogs {
             if let name = blog["title"] as? String {
             self.names.append(name)
             print("ok2")
             }
             }
             }
             } catch {
             print("Error deserializing JSON: \(error)")
             }
             */

            do{
                //let catArray = (termPosts as AnyObject).value(forKey: "category")
                //let catDic = catArray as? [[String: Any]]
                /*for cat in catDic!{
                    if let name = cat["name"] as? String{
                        self.catPosts.append(name)
                        print(self.catPosts)
                    }
                }*/
                                       // self.catPosts = catDic!
                
                
             //   print(catArray ?? "catDic post")
               // self.catPosts = catDic!
               // let imgPost = catPosts[(indexPath.row)]
               // print(catPosts)
                //let imageURL = catPosts["name"] as? String
               // self.catPosts = catArray! as! [[String : Any]]
                //print(catPosts)
                //------------
                //let catpost = catPosts[indexPath.row]
               // cell.titleLabelCat.text = catpost["name"] as? String
                //let htmlTag = post["content"] as! String
                //let content = htmlTag.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                //cell.contentLabelCat.text = content
                //cell.contentLabelCat.text = content
                //cell.contentLabelCat.text = catPosts["slug"]
                //-------------
                
             //   let remoteCategoryString = catPosts[indexPath.row]
              //  let category = remoteCategoryString["Économie"] as? String
             //   print("ok2")
            //    print(category!)
                /*if let imagePath = imageURL,
                 let imgUrl = URL(string:  imagePath){
                 cell.imagePost.af_setImage(withURL: imgUrl)
                 }
                 else{
                 cell.imagePost.image = nil
                 }*/
            }
            //print(self.catPosts ?? "nil catposts2")
        }*/
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
