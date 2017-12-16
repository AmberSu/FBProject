//
//  Permissions.swift
//  FBLogin
//
//  Created by MacOS on 15/12/2017.
//  Copyright © 2017 amberApps. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class Permissions {
    private var readPermissions: [String]?
    private var publishPermissions: [String]?
    private var button: FBSDKLoginButton?
    
    init(readPermissions: [String], button: FBSDKLoginButton) {
        self.readPermissions = readPermissions
        self.button = button
        self.button?.readPermissions = self.readPermissions
    }
    
    init(publishPermissions: [String], button: FBSDKLoginButton) {
        self.publishPermissions = publishPermissions
        self.button = button
        self.button?.publishPermissions = self.publishPermissions
    }
}
