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
    @IBOutlet weak var sharePage: UIView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var appStoreBtn: UIButton!
    @IBOutlet weak var contentShare: UIView!
    
    var postsPage: [[String: Any]] = []
    var categoryName: String?
    var pageID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        topBarLogo()
      
        categoryName = MyVariables.categoryDrawerName

        print("1***********************************************")
        print(categoryName!)

        contactPage.layer.cornerRadius = 12
        contactPage.layer.borderWidth = 1
        contactPage.layer.borderColor = UIColor.lightGray.cgColor
     
        if categoryName == "Contact"{
            pageID = "19399"
            sharePage.isHidden = true
            sendEmail.isHidden = false
            appStoreBtn.isHidden = true
            PageLabel.text? = "CONTACT"
            
            sendEmail.layer.cornerRadius = 7
            sendEmail.backgroundColor = .clear
            sendEmail.layer.borderWidth = 1
            sendEmail.layer.borderColor = UIColor.black.cgColor
            
        }
        else if categoryName == "Partager"{
            shareButton.backgroundColor = .clear
            shareButton.layer.cornerRadius = 7
            shareButton.layer.borderWidth = 1
            shareButton.layer.borderColor = UIColor.black.cgColor
            
//            imageLogo.layer.cornerRadius = imageLogo.frame.height / 2
  //          imageLogo.clipsToBounds = true
            
            imageLogo.backgroundColor = .clear
            imageLogo.layer.cornerRadius = 10
            imageLogo.layer.borderWidth = 1
            imageLogo.layer.borderColor = UIColor.lightGray.cgColor
            
            pageID = ""
            contentShare.isHidden = false
            contentShare.layer.cornerRadius = 12
            contentShare.layer.borderWidth = 1
            contentShare.layer.borderColor = UIColor.lightGray.cgColor
            contactPage.isHidden = true
            PageLabel.text? = "PARTAGER À VOS AMIS"
            
        }
        else if categoryName == "À propos"{
            pageID = "2"
            sharePage.isHidden = true
            sendEmail.isHidden = true
            appStoreBtn.isHidden = true
            contactPage.layer.borderColor = UIColor.clear.cgColor
            PageLabel.text? = "À PROPOS"
            contentLabel.text? = """
            Bien plus qu’un média en ligne, Ayibopost est une plateforme d’auto-defense intellectuelle. Informer, éduquer et sensibiliser : voici le triptyque que nous mettons en oeuvre, et ceci surtout lorsqu’il s’agit de vulgariser des informations ou concepts d’utilité publique. Nous sommes fiers de faire du journalisme explicatif.
            
            Ayibopost est un projet collectif, basé sur la collaboration. Dans ou hors les murs nous donnons la parole à ceux et celles qui font, qui pensent, qui créent, qui luttent, qui innovent quel que soit le domaine, et quel que soit le sujet. À Ayibopost nous sommes convaincus que la rigueur et l’exigence intellectuelle forment la pierre angulaire d’un journalisme de qualité.
            
            Cette rigueur et cette exigence sont indispensables lorsque que nous traitons des sujets parfois impopulaires, tabous qui, en général, ne sont pas ou peu discutés. Nous abordons aussi des thèmes sur lesquels la société choisit –  de manière consciente ou non– de garder le silence. Ayibopost est un espace où les opinions, parfois contraires, sont diffusées et débattues.
            
            La mission d’Ayibopost est d’être à la hauteur des défis qui se posent à la société haïtienne et des attentes de nos lecteurs.
            """
 

        }
        else if categoryName == "AppStore"{
            pageID = ""
            
            appStoreBtn.layer.cornerRadius = 7
            appStoreBtn.backgroundColor = .clear
            appStoreBtn.layer.borderWidth = 1
            appStoreBtn.layer.borderColor = UIColor.black.cgColor
            
            sharePage.isHidden = true
            sendEmail.isHidden = true
            appStoreBtn.isHidden = false
            PageLabel.text? = "L'APPLICATION"
            contentLabel.text? = """
            Merci d’utiliser l'application AyiboPost! Pour vous offrir la meilleure expérience possible, nous mettons régulièrement l’application à jour dans l’App Store. Profitez des dernières améliorations en téléchargeant la version la plus récente !
            
            Vous aimez AyiboPost ? N'oubliez pas de noter notre application et Laissez-nous un commentaire dans l’App Store !
            
            N’hésitez pas à nous faire part de vos envies et de vos besoins pour les prochaines mises à jour ! Nous sommes toujours à l’écoute de nos membres :) Merci d’être toujours plus nombreux chaque jour à utiliser AyiboPost!
            Et n’oubliez pas d’en parler à votre entourage, pour que chacun puisse être informer, éduquer et se sensibiser au maximum!
            """
        }
        topBarLogo()
   //     getContact()
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let title = "Je vous invite à utiliser l'application ayiboPOST"
        let URl = "https://ayibopost.com"
        let image = imageLogo.image
        
        let vc = UIActivityViewController(activityItems: [title, URl, image], applicationActivities: [])
        if let popoverController = vc.popoverPresentationController{
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        self.present(vc, animated: true, completion: nil)
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
