//
//  LaunchScreenViewController.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 2/9/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    var timer = Timer()
    
    @IBOutlet weak var launchImgVw: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        launchImgVw.loadGif(name: "LaunchImage")
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.goToMainScreen), userInfo: nil, repeats: true)
    }
    
    @objc func goToMainScreen() {
        
        timer.invalidate()
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
        
        
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
