//
//  User.swift
//  RSSReader
//
//  Created by Алексей Папин on 14/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import Foundation

class User {
    static let registeredUsers = [
        User(username: "alex", password: "xela"),
        User(username: "vasya", password: "pupkin"),
        User(username: "clown", password: "red")
    ]
    
    let username: String
    let password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
