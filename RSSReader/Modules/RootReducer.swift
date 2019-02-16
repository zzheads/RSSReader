//
//  RootReducer.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    var login       : LoginState = LoginState()
    var table       : TableState = TableState()
    var register    : RegisterState = RegisterState(registeredUsers: [])
    
    func save() {
        UserDefaults.default.loginState = self.login
        UserDefaults.default.registerState = self.register
    }
    
    static var restored: AppState {
        let state = AppState(
            login: UserDefaults.default.loginState ?? LoginState(),
            table: TableState(),
            register: UserDefaults.default.registerState ?? RegisterState(registeredUsers: [])
        )
        return state
    }
}

func rootReducer(_ action: Action, _ state: AppState?) -> AppState {
    var state = state ?? AppState()
    switch action {
    case _ as LoginActions      : state = loginReducer(action, state)
    case _ as TableActions      : state = tableReducer(action, state)
    case _ as RegisterActions   : state = registerReducer(action, state)
    default                     : break
    }
    state.save()
    return state
}
