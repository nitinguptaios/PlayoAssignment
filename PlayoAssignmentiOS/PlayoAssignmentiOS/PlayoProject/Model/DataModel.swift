//
//  DataModel.swift
//  PlayoAssignmentiOS
//
//  Created by iPHTech38 on 01/08/22.
//

import Foundation

class DataModel: NSObject {
    var title : String?
    var desc : String?
    var author : String?
    var imageUrl : String?
    var url: String?
        
    init(title : String, desc : String, author : String, imageUrl: String, url: String){
        self.title = title
        self.desc = desc
        self.author = author
        self.imageUrl = imageUrl
        self.url = url
    }
}
