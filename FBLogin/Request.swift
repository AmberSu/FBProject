//
//  Request.swift
//  FBLogin
//
//  Created by MacOS on 15/12/2017.
//  Copyright © 2017 amberApps. All rights reserved.
//

import Foundation
import FBSDKLoginKit


var posts = [Post]()
var likes = [Int]()

class Request {
    private let graphPath: String?
    private let parameters: [String:String]?
    private let httpMethod: String?
    private var index = 0
    
    init(graphPath: String, parameters: [String:String], httpMethod: String) {
        self.graphPath = graphPath
        self.parameters = parameters
        self.httpMethod = httpMethod
    }
    
    // function to modify the request according to it's type
    
    private func checkRequest() -> FBSDKGraphRequest? {
        guard (FBSDKAccessToken.current()) != nil else {
            print("Token Error")
            return nil
        }
        var request: FBSDKGraphRequest?
        if httpMethod == "GET" {
            request = FBSDKGraphRequest(graphPath: self.graphPath, parameters: self.parameters, httpMethod: "GET")
        } else if httpMethod == "POST" {
            request = FBSDKGraphRequest(graphPath: self.graphPath, parameters: self.parameters, httpMethod: "POST")
        }
        if let checkedRequest = request {
            return checkedRequest
        }
        return nil
    }
    
    // function to submit the posts request
    
    func submitPostsRequest() {
        guard let request = checkRequest() else {
            print("Invalid request")
            return
        }
        request.start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil) {
                var stories = self.retrieveStories(result: result!)
                self.addToPostsArray(idArray: self.retrievePosts(result: result!))
                    for post in posts {
                        post.story = stories[self.index]
                        self.index+=1
                        let likesRequest = Request(graphPath: String(post.id), parameters: ["fields":"likes"], httpMethod: "GET")
                        likesRequest.submitLikesRequest()
                    }
            } else {
                print(error as Any)
            }
        })
    }
    
    // function which retrieves posts' ids and appends them to the id array
    
    private func retrievePosts(result: Any) -> [String] {
        var idArray = [String]()
        if let retrievedData = result as? Dictionary<String, Any>, let posts = retrievedData["data"] as? Array<Dictionary<String, String>> {
            for post in posts {
                if let postId = post["id"] {
                    idArray.append(postId)
                }
            }
        }
        return idArray
    }
    
    // function which retrieves posts' stories and appends them to the story array
    
    private func retrieveStories(result: Any) -> [String] {
        var storyArray = [String]()
        if let retrievedData = result as? Dictionary<String, Any>, let posts = retrievedData["data"] as? Array<Dictionary<String, String>> {
            for post in posts {
                if let postStory = post["story"] {
                    storyArray.append(postStory)
                } else if let postMessage = post["message"] {
                    storyArray.append("Your message: \(postMessage)")
                } else {
                    storyArray.append("Your message")
                }
            }
        }
        return storyArray
    }
    
    // function which creates a Post instance and appends it to posts array
    
    private func addToPostsArray(idArray: [String]) {
        for element in idArray {
            let post = Post()
            post.id = element
            posts.append(post)
        }
    }
    
    // function to submit the likes request
    
    private func submitLikesRequest() {
        guard let request = checkRequest() else {
            print("Invalid request")
            return
        }
        request.start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil) {
                let numberOfLikes = self.retrieveNumberOfLikes(result: result!)
                likes.append(numberOfLikes)
            } else {
                print(error as Any)
            }
        })
    }
    
    // function which retrieves the number of likes for every user post
    
    private func retrieveNumberOfLikes(result: Any) -> Int {
        if let retrievedPostData = result as? Dictionary<String, Any>, let retrievedLikesData = retrievedPostData["likes"] as? Dictionary<String, Any>, let likes = retrievedLikesData["data"] as? Array<Dictionary<String, String>>  {
            return likes.count
        } else {
            return 0
        }
    }
}

