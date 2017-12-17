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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        _ = Permissions(readPermissions: ["user_posts"], button: loginButton)
        let postsRequest = Request(graphPath: "me/posts", parameters: [:], httpMethod: "GET")
        postsRequest.submitPostsRequest()
    }
    
    // login button functions
    
    private func addFacebookButton() -> FBSDKLoginButton {
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 120)
        view.addSubview(loginButton)
        return loginButton
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        tableView.isHidden = true
        posts.removeAll()
        likes.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func showTableView(_ sender: UIButton) {
        var index = 0
        if !posts.isEmpty && !likes.isEmpty {
            for post in posts {
                post.likes = likes[index]
                index+=1
            }
            posts.sort { $0.likes > $1.likes }
            tableView.isHidden = false
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

