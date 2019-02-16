//
//  RegisterReducer.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import ReSwift
import CoreData

struct RegisterState: Codable {
    var registeredUsers: Set<User>
    
    func validate(_ user: User) -> LoginState.LoginResult {
        return self.registeredUsers.contains(where: { $0.username == user.username && $0.password == user.password }) ? .success(user) : .failure("Incorrect username or/and password")
    }
}

enum RegisterActions: Action {
    case register(String, String)
}

func registerReducer(_ action: Action, _ state: AppState) -> AppState {
    var state = state
    guard let action = action as? RegisterActions else {
        return state
    }
    switch action {
    case let .register(username, password):
        state.register.registeredUsers.insert(User(username: username, password: password, bookmarks: []))
    }
    return state
}
