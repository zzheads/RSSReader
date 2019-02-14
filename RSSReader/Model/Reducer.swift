//
//  Reducer.swift
//  RSSReader
//
//  Created by Алексей Папин on 14/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import ReSwift

func loginReducer(_ action: Action, _ state: LoginState) -> LoginState {
    var state = state
    guard let action = action as? LoginActions else {
        return state
    }
    switch action {
    case .login(let username, let password):
        guard let user = User.registeredUsers.first(where: { $0.username == username && $0.password == password }) else {
            break
        }
        state.loggedUser = user
    case .logout:
        state.loggedUser = nil
    }
    return state
}

func tableReducer(_ action: Action, _ state: TableState) -> TableState {
    var state = state
    guard let action = action as? TableActions else {
        return state
    }
    switch action {
    case .selectedItem(let item)    : state.selectedItem = item
    case .detailsShown              : state.selectedItem = nil
    }
    return state
}

func rootReducer(_ action: Action, _ state: AppState?) -> AppState {
    var state = state ?? AppState()
    switch action {
    case _ as LoginActions      : state.login = loginReducer(action, state.login)
    case _ as TableActions      : state.table = tableReducer(action, state.table)
    default                     : break
    }
    return state
}
