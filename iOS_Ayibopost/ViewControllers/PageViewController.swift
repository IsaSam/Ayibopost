//
//  PageViewController.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 7/12/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit
import MessageUI

class PageViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var PageLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var postsPage: [[String: Any]] = []
    var categoryName: String?
    var pageID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        topBarLogo()
      
        categoryName = MyVariables.categoryDrawerName

        print("1***********************************************")
        print(categoryName!)
     
        if categoryName == "Contact"{
            pageID = "19399"
            PageLabel.text? = "CONTACT"
        }
        topBarLogo()
        getContact()
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
    
    private func getContact(){
        
        let url = URL(string: "https://ayibopost.com/wp-json/wp/v2/pages/\(pageID!)?&_embed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {(data, response, error) in
            //-- This will run when the network request returns
            if let error = error{
                let errorAlertController = UIAlertController(title: "Cannot Get Movies", message: "The Internet connections appears to be offline", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Retry", style: .cancel)
                errorAlertController.addAction(cancelAction)
                self.present(errorAlertController, animated: true)
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
      
                let pageContent = dataDictionary["content"] as! Dictionary<String,AnyObject>
                let htmlTag =  pageContent["rendered"] as! String
                let content = htmlTag.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                self.contentLabel.text = content.stringByDecodingHTMLEntities
                print(content)
 
            }
        }
        task.resume()
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            showMailError()
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["isaacsamuel27@gmail.com"])
        mailComposerVC.setSubject("Contact")
        mailComposerVC.setMessageBody("Composez votre message ici...", isHTML: false)
        return mailComposerVC
    }
    
    func showMailError(){
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
