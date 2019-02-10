//
//  AyiboTalk.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 2/1/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class AyiboTalk: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
