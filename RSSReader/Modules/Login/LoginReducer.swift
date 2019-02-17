//
//  LoginReducer.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import CoreData
import ReSwift

struct LoginState {
    var loggedUser: User?
    var error: String?
    
    init(loggedUser: User? = nil, error: String? = nil) {
        self.loggedUser = loggedUser
        self.error = error
    }
    
    init?(username: String) {
        let context = CoreStack.shared.persistentContainer.viewContext
        let request = NSFetchRequest<User>(entityName: User.entity().name!)
        request.predicate = NSPredicate(format: "username = %@", username)
        if let user = try? context.fetch(request).first {
            self.loggedUser = user
        }
    }
    
    var isLogged: Bool {
        return self.loggedUser != nil
    }
}

enum LoginActions: Action {
    case login(username: String, password: String)
    case logout
}

func loginReducer(_ action: Action, _ state: AppState) -> AppState {
    var state = state
    guard let action = action as? LoginActions else {
        return state
    }
    switch action {
    case let .login(username, password)     :
        let users = try! CoreStack.shared.persistentContainer.viewContext.fetch(User.fetchRequest()) as! [User]
        guard let user = users.first(where: { $0.username == username && $0.password == password }) else {
            state.login.error = "Invalid username or/and password"
            break
        }
        state.login.loggedUser = user
        
    case .logout            :
        state.login.loggedUser = nil
        state.login.error = nil
    }
    return state
}
