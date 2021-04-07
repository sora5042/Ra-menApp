//
//  Post.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/22.
//

import Foundation
import Firebase

class Post {
    
    var name: String
    var createdAt: Timestamp
    var postImageUrl: String
    var storeName: String
    var recommendPoint: String
    var comment: String
    var uid: String
    var docId: String
    var profileImageUrl: String
    var place: String
    
    init(dic: [String: Any]) {
        
        self.name = dic["name"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.postImageUrl = dic["postImageUrl"] as? String ?? ""
        self.storeName = dic["storeName"] as? String ?? ""
        self.recommendPoint = dic["recommendPoint"] as? String ?? ""
        self.comment = dic["comment"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.docId = dic["postId"] as? String ?? ""
        self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""
        self.place = dic["place"] as? String ?? ""
        
    }
}
