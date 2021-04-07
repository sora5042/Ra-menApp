//
//  User.swift
//  Ra-menApp
//
//  Created by 大谷空 on 2021/03/17.
//

import Foundation
import Firebase

class User {
    
    var email: String?
    var name: String?
    var profileImageUrl: String?
    var createAt: Timestamp
    var age: String
    var residence: String
    var favorite: String
    var uid: String
    
    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""
        self.createAt = dic["createAt"] as? Timestamp ?? Timestamp()
        self.age = dic["age"] as? String ?? ""
        self.residence = dic["residence"] as? String ?? ""
        self.favorite = dic["favorite"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
    }
}
