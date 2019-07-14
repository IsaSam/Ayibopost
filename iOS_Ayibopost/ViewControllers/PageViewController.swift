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
   //     getContact()
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
