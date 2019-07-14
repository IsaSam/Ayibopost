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
    @IBOutlet weak var contactPage: UIView!
    @IBOutlet weak var sendEmail: UIButton!
    
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
            sendEmail.isHidden = false
            PageLabel.text? = "CONTACT"
        }
        else if categoryName == "À propos"{
            pageID = "2"
            sendEmail.isHidden = true
            PageLabel.text? = "À PROPOS"
            contentLabel.text? = """
            Bien plus qu’un média en ligne, Ayibopost est une plateforme d’auto-defense intellectuelle. Informer, éduquer et sensibiliser : voici le triptyque que nous mettons en oeuvre, et ceci surtout lorsqu’il s’agit de vulgariser des informations ou concepts d’utilité publique. Nous sommes fiers de faire du journalisme explicatif.
            
            Ayibopost est un projet collectif, basé sur la collaboration. Dans ou hors les murs nous donnons la parole à ceux et celles qui font, qui pensent, qui créent, qui luttent, qui innovent quel que soit le domaine, et quel que soit le sujet. À Ayibopost nous sommes convaincus que la rigueur et l’exigence intellectuelle forment la pierre angulaire d’un journalisme de qualité.
            
            Cette rigueur et cette exigence sont indispensables lorsque que nous traitons des sujets parfois impopulaires, tabous qui, en général, ne sont pas ou peu discutés. Nous abordons aussi des thèmes sur lesquels la société choisit –  de manière consciente ou non– de garder le silence. Ayibopost est un espace où les opinions, parfois contraires, sont diffusées et débattues.
            
            "La mission d’Ayibopost est d’être à la hauteur des défis qui se posent à la société haïtienne et des attentes de nos lecteurs.
            """
 

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
