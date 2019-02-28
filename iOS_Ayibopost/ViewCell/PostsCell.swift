//
//  PostsCell.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 1/15/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class PostsCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var datePost: UILabel!
    @IBOutlet weak var picMedia: UIImageView!
    @IBOutlet weak var labelMedia: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    weak var delegate: PostsCellDelegate?
    var favB: UIColor?
    var buttonTapped = false
    
    
    @IBAction func bookmarkTapped(_ sender: UIButton) {
        delegate?.PostsCellDidTapBookmark(self)
        
//            self.favClic?.setImage(UIImage(named: "addFav100"), for: .normal)
        
        if buttonTapped == false{
         //   favB = favButton.tintColor
            print("Bookmark save succesfully")
            favButton.tintColor = UIColor.green
            favButton.isEnabled = false
            buttonTapped = true
        }else{
            print("unSaved bookmark")
            favButton.tintColor = UIColor.darkGray
       //     favButton.isEnabled = true
            buttonTapped = false
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
protocol PostsCellDelegate : class {
    func PostsCellDidTapBookmark(_ sender: PostsCell)
}
