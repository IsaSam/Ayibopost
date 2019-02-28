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
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: PostsCellDelegate?
    var favB: UIColor?
    var buttonTapped = false
    
    

    @IBAction func bookmarkTapped(_ sender: UIButton) {
        delegate?.PostsCellDidTapBookmark(self)
        
        let buttonRow = sender.tag

        if buttonTapped == false{

         //   favB = favButton.tintColor
            print("Bookmark saved succesfully at index \(buttonRow)")
            favButton.index(ofAccessibilityElement: buttonRow)
//            saveButton.setTitle("Saved", for: UIControlState .normal)
  //          favButton.setImage(UIImage(named: "add-tag-color100"), for: .normal)
 //           favButton.tintColor = UIColor.brown
     //       favButton.isEnabled = false
            buttonTapped = true

        }else{
            print("unSaved bookmark at index \(buttonRow)")
            favButton.index(ofAccessibilityElement: buttonRow)
 //           saveButton.setTitle("Save", for: UIControlState .normal)
            favButton.setImage(UIImage(named: "addtag100"), for: .normal)
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
