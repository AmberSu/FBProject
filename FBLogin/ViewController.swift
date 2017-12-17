//
//  ViewController.swift
//  FBLogin
//
//  Created by MacOS on 08/10/2017.
//  Copyright © 2017 amberApps. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SVProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var getLikesButton: UIButton!
    
    var mostPopularPosts = [Post]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SVProgressHUD.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let loginButton = addFacebookButton()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        _ = Permissions(readPermissions: ["user_posts"], button: loginButton)
        let postsRequest = Request(graphPath: "me/posts", parameters: [:], httpMethod: "GET")
        postsRequest.submitPostsRequest()
        SVProgressHUD.dismiss()
    }
    
    // login button methods
    
    private func addFacebookButton() -> FBSDKLoginButton {
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 120)
        view.addSubview(loginButton)
        return loginButton
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        getLikesButton.isEnabled = true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        getLikesButton.isEnabled = false
        tableView.isHidden = true
        posts.removeAll()
        likes.removeAll()
    }
    
    private func sortDataForTableView() {
        var index = 0
        if !posts.isEmpty && !likes.isEmpty {
            for post in posts {
                post.likes = likes[index]
                index+=1
            }
            let sortedPosts = posts.sorted(by: { $0.likes > $1.likes })
            for index in 0...4 {
                mostPopularPosts.append(sortedPosts[index])
            }
        }
    }
  
    // MARK: TableView methods
    
    @IBAction func showTableView(_ sender: UIButton) {
        if (FBSDKAccessToken.current()) != nil {
            sortDataForTableView()
            tableView.isHidden = false
            getLikesButton.isEnabled = false
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mostPopularPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        tableViewCell.textLabel?.numberOfLines = 2
        tableViewCell.backgroundColor = UIColor(displayP3Red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        let story = mostPopularPosts[indexPath.row].story
        let likes = mostPopularPosts[indexPath.row].likes
        tableViewCell.textLabel?.text = "Post '\(story)' got \(likes) likes"
        return tableViewCell
    }
}

