//
//  Post.swift
//  DRPR Mobile Tech Test
//
//  Created by Daniel Pulgarin R. on 13/08/22.
//

import UIKit

enum JSONPostsResult {
    
    case success(data: PostsConfiguration)
    case failure(error: Error)
}

typealias PostsCompletionHandler = (_ data: JSONPostsResult) -> Void


class Post {
    
    func getPosts(result: @escaping PostsCompletionHandler) {
        
        JSONAPI.getPosts { (postsData, error) in
            
            if let error = error {
                
                result(JSONPostsResult.failure(error: error))
            } else if let postsData = postsData {
                
//                var bodies = [postsData]()
                for singlePost in postsData {
                    
                    print(singlePost)
                }
//                result(JSONPostsResult.success(data: PostsConfiguration(bodies: bodies)))
            }
        }
    }
}
