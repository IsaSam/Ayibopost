//
//  AyiboAPIManager.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 1/28/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import Foundation

enum Result{
    
    //Associative types
    case error(String)
    case success([[String : Any]])
}

struct AyiboAPIManager{
    
    static let shared:AyiboAPIManager = AyiboAPIManager()
    
    func get(url:String, completion: @escaping (Result) -> Void ){
        let urlRequest = URLRequest(url: URL(string: url)!)
        URLSession.shared.dataTask(with: urlRequest) { ( data, response, error) in
            
            if error != nil {
                let er = Result.error(error!.localizedDescription)
                completion(er)
                return
            }
            do{
                if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String : Any]]{
                
                    completion( .success( json ))
                }
                
            }catch{
                print("Error: \(error.localizedDescription)")
            }
                
        }.resume()
    }
}
