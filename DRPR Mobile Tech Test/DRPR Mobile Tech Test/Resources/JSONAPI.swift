//
//  JSONAPI.swift
//  DRPR Mobile Tech Test
//
//  Created by Daniel Pulgarin R. on 13/08/22.
//

import UIKit
import Foundation

class JSONAPI {
    
    // MARK: - Get Posts
    class func getPosts(completionHandler: @escaping ([PostData]?, Error?) -> Void) {

        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    guard let decodedResponse = JSONAPI.decodePostsResponseValues(data) else {
                        return completionHandler(nil, ErrorCases.decoding)
                    }
                    completionHandler(decodedResponse, nil)
                } else if let error = error {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }

    // MARK: - Delete all posts
    class func deleteAllPosts(completionHandler: @escaping (Error?) -> Void) {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
        task.resume()
    }
    

    // MARK: - Get Post Comments
    class func getPostComments(_ postId: Int, completionHandler: @escaping ([PostCommentsData]?, Error?) -> Void) {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(postId)/comments")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    guard let decodedResponse = JSONAPI.decodeCommentsResponseValues(data) else {
                        return completionHandler(nil, ErrorCases.decoding)
                    }
                    completionHandler(decodedResponse, nil)
                } else if let error = error {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }

    // MARK: - Get User Info
    class func getUserInfo(_ userId: Int, completionHandler: @escaping (UserData?, Error?) -> Void) {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(userId)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    guard let decodedResponse = JSONAPI.decodeUserResponseValues(data) else {
                        return completionHandler(nil, ErrorCases.decoding)
                    }
                    completionHandler(decodedResponse, nil)
                } else if let error = error {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }


    // MARK: - Decode Responses
    private class func decodePostsResponseValues(_ data: Data) -> [PostData]? {
        
        var postsResponseData: [PostData]?
        do {
            postsResponseData = try JSONDecoder().decode([PostData].self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)\n")
        }
        return postsResponseData
    }

    private class func decodeCommentsResponseValues(_ data: Data) -> [PostCommentsData]? {
        
        var commentsResponseData: [PostCommentsData]?
        do {
            commentsResponseData = try JSONDecoder().decode([PostCommentsData].self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)\n")
        }
        return commentsResponseData
    }

    private class func decodeUserResponseValues(_ data: Data) -> UserData? {
        
        var userResponseData: UserData?
        do {
            userResponseData = try JSONDecoder().decode(UserData.self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)\n")
        }
        return userResponseData
    }
}
