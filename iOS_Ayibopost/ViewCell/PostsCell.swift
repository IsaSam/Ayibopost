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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
