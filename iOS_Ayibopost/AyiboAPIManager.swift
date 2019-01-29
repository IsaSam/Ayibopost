//
//  AyiboAPIManager.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 1/28/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import Foundation

struct AyiboAPIManager{
    
    static let shared:AyiboAPIManager = AyiboAPIManager()
    
    func get(url:String, completion: @escaping ([[String: Any]]?, String?) -> Void ){
        let urlRequest = URLRequest(url: URL(string: url)!)
        URLSession.shared.dataTask(with: urlRequest) { ( data, response, error) in
            
            if error != nil {
                completion(nil, error?.localizedDescription)
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String : Any]]
                completion(json, nil)
                
            }catch{
                print("Error: \(error.localizedDescription)")
            }
                
        }.resume()
    }
    
    /*func get(urlimg:String, completion: @escaping ([[String: Any]]?, String?) -> Void ){
        let urlRequest = URLRequest(url: URL(string: urlimg)!)
        URLSession.shared.dataTask(with: urlRequest) { ( data, response, error) in
            
            if error != nil {
                completion(nil, error?.localizedDescription)
                return
            }
            do{
                let jsonImg = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String : Any]]
                
                guard let imgArray = (jsonImg as AnyObject).value(forKey: "featured_image") else {return}
                
                //print(imgArray)
                let dataImg = imgArray as? [[String: Any]]
                completion(dataImg, nil)
                /*for dic1 in dataImg!{
                    let source = dic1["source"] as? [[String: Any]]
                    print(source!)
                    
                }*/
                
                
            }catch{
                print("Error: \(error.localizedDescription)")
            }
            
            }.resume()
    }*/
}
