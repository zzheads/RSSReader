//
//  User.swift
//  RSSReader
//
//  Created by Алексей Папин on 14/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import Foundation

class User: Codable {
    let username: String
    let password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

extension User: Hashable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username && lhs.password == rhs.password
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.username)
    }
}
