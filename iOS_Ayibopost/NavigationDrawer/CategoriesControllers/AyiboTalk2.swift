//
//  AyiboTalk2.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 2/15/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class AyiboTalk2: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategory()
        topBarLogo()
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
    func getCategory(){
        
        self.activityIndicator.startAnimating() //====================
        
        webView.delegate = self
        if let url = URL(string: "https://ayibopost.com/category/ayibotalk/") {
            // let request = URLRequest(url: url)
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            var session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                    session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                    //        self.activityIndicator.stopAnimating() //====================
                    let errorAlertController = UIAlertController(title: "Cannot Get Data", message: "The Internet connections appears to be offline.", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Pull to Refresh", style: .cancel)
                    errorAlertController.addAction(cancelAction)
                    self.present(errorAlertController, animated: true)
                    print(error.localizedDescription)
                    
                } else{
                    self.webView.loadRequest(request)
                    self.activityIndicator.stopAnimating() //====================
                }
                self.activityIndicator.stopAnimating()
            }
            task.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

