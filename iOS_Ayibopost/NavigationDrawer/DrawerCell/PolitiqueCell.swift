//
//  PolitiqueCell.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 2/13/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import UIKit

class PolitiqueCell: UITableViewCell {

 //   @IBOutlet weak var imageCategory: UIImageView!
    //@IBOutlet weak var titleLabelCat: UILabel!
   // @IBOutlet weak var dateLabelCat: UILabel!
   // @IBOutlet weak var contentLabelCat: UILabel!
    @IBOutlet weak var imageCategory: UIImageView!
    
    @IBOutlet weak var titleLabelCat: UILabel!
    
    @IBOutlet weak var contentLabelCat: UILabel!
    @IBOutlet weak var dateLabelCat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
