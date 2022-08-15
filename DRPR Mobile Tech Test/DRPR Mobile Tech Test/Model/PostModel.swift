//
//  PostModel.swift
//  DRPR Mobile Tech Test
//
//  Created by Daniel Pulgarin R. on 13/08/22.
//

import Foundation

struct PostData: Decodable {
    
    let userId, id: Int
    let title, body: String
}

struct PostsConfiguration {

    var bodies: [String]?
}

struct ChoosenPost {
    
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

struct PostCommentsData: Decodable {
    
    let postId, id: Int
    let name, email, body: String
}

struct ChoosenComment {
        
    var userId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}