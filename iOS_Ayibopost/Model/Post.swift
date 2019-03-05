//
//  Post.swift
//  iOS_Ayibopost
//
//  Created by Isaac Samuel on 2/23/19.
//  Copyright © 2019 Isaac Samuel. All rights reserved.
//

import Foundation

class Post {
    var id: String = ""
    var title: String = ""
    var content: String = ""
    var imageUrl: String = ""
    var date: String = ""
    
    init(id: String, title: String, content: String, imageUrl: String, date: String = "")
    {
        self.id = id
        self.title = title
        self.content = content
        self.imageUrl = imageUrl
        self.date = date
    }
}
