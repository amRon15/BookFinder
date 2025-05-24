//
//  User.swift
//  BookFinder
//
//  Created by 邱允聰 on 24/5/2025.
//

import Foundation

struct User{
    var name: String
    var email: String
    var imageUrl: String?
    
    init(name: String, email: String, imageUrl: String? = nil) {
        self.name = name
        self.email = email
        self.imageUrl = imageUrl
    }
}
