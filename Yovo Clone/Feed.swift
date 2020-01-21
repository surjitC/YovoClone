//
//  Feed.swift
//  Yovo Clone
//
//  Created by Surjit's iMac on 20/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import Foundation

class Feed: Codable {
    var posts: [Post]?
}

class Post: Codable {
    var id, userName, vUrl, userImageUrl, time: String?
}

class User: Codable {
    var posts: [Post]?
    var userName, title, userImageUrl, description: String?
}
