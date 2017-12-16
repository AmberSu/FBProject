//
//  ViewController.swift
//  FBLogin
//
//  Created by MacOS on 08/10/2017.
//  Copyright © 2017 amberApps. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let loginButton = addFacebookButton()
        _ = Permissions(readPermissions: ["user_posts"], button: loginButton)
        if (FBSDKAccessToken.current()) != nil {
        let postsRequest = Request(graphPath: "me/posts", parameters: [:], httpMethod: "GET")
        postsRequest.submitPostsRequest()
        tableView.dataSource = self
        tableView.delegate = self
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        tableView.reloadData()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        posts.removeAll()
        likes.removeAll()
        tableView.reloadData()
    }
    
    private func addFacebookButton() -> FBSDKLoginButton {
        let loginButton = FBSDKLoginButton()
        loginButton.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 100)
        view.addSubview(loginButton)
        return loginButton
    }
    
    @IBAction func showTableView(_ sender: UIButton) {
        var index = 0
        if !posts.isEmpty && !likes.isEmpty {
            for post in posts {
                post.likes = likes[index]
                index+=1
            }
            posts.sort { $0.likes > $1.likes }
            tableView.reloadData()
        }
    }
    
    // MARK: TableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        tableViewCell.textLabel?.numberOfLines = 2
        let story = posts[indexPath.row].story
        let likes = posts[indexPath.row].likes
        tableViewCell.textLabel?.text = "Post '\(story)' got \(likes) likes"
        return tableViewCell
    }
}

