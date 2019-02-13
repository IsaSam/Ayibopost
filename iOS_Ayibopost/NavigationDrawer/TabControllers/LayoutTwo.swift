//
//  LayoutTwo.swift
//  NavigationDrawer
//
//  Created by Sowrirajan Sugumaran on 05/10/17.
//  Copyright © 2017 Sowrirajan Sugumaran. All rights reserved.
//

import UIKit

class LayoutTwo: UIViewController, DrawerControllerDelegate {

    var drawerVw = DrawerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func pushTo(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func actShowMenu(_ sender: Any) {
        drawerVw = DrawerView(aryControllers:DrawerArray.array, isBlurEffect:false, isHeaderInTop:true, controller:self)
        drawerVw.delegate = self
        
        //**** OPTIONAL ****//
        // Can change GradientColor of background view, text color, user name text color, font, username
        drawerVw.changeGradientColor(colorTop: UIColor.groupTableViewBackground, colorBottom: UIColor.white)
        drawerVw.changeCellTextColor(txtColor: UIColor.black)
        drawerVw.changeUserNameTextColor(txtColor: UIColor.black)
        drawerVw.changeFont(font: UIFont(name:"Avenir Next", size:18)!)
        drawerVw.changeUserName(name: "WELCOME")
        drawerVw.show()
    }
}
