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
    
    init(graphPath: String, parameters: [String:String], httpMethod: String) {
        self.graphPath = graphPath
        self.parameters = parameters
        self.httpMethod = httpMethod
    }
    
    func addRequest() -> FBSDKGraphRequest? {
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
    
    func submitRequest() {
        guard (FBSDKAccessToken.current()) != nil else {
            return
        }
        guard let request = addRequest() else {
            print("Invalid request")
            return
        }
        
        request.start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil) {
                let sortedData = self.sortData(result: result!)
                self.createPostsArray(idArray: sortedData)
                for element in posts {
                    let request2 = Request(graphPath: String(element.id), parameters: ["fields":"likes"], httpMethod: "GET")
                    request2.submitRequest2()
                }
            } else {
                print(error)
            }
        })
    }
    
    func sortData(result: Any) -> [String] {
        var elementArray = [String]()
        if let data = result as? Dictionary<String, Any>, let array = data["data"] as? Array<Dictionary<String, String>> {
            for item in array {
                if let id = item["id"] {
                    elementArray.append(id)
                }
            }
        }
        return elementArray
    }
    
    func createPostsArray(idArray: [String]) {
        for element in idArray {
            let post = Post()
            post.id = element
            posts.append(post)
        }
    }
    
    func submitRequest2() {
        guard (FBSDKAccessToken.current()) != nil else {
            print("Token Error")
            return
        }
        guard let request = addRequest() else {
            print("Invalid request")
            return
        }
        request.start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil) {
                let likesNumber = self.sortData2(result: result!)
                likes.append(likesNumber)
            } else {
                print(error)
            }
        })
    }
    
    func sortData2(result: Any) -> Int {
        if let data1 = result as? Dictionary<String, Any>, let array1 = data1["likes"] as? Dictionary<String, Any>, let likes = array1["data"] as? Array<Dictionary<String, String>>  {
            print(likes.count)
            return likes.count
        } else {
            return 0
        }
    }
    
    func addLikesToPost() {
        var index = 0
        for post in posts {
            post.likes = likes[index]
            index+=1
        }
    }
}

