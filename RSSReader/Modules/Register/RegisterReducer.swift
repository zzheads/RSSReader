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
}

enum RegisterActions: Action {
    case register(String, String)
}

func registerReducer(_ action: Action, _ state: AppState) -> AppState {
    guard let action = action as? RegisterActions else {
        return state
    }
    switch action {
    case let .register(username, password):
        let user = User(context: CoreStack.shared.persistentContainer.viewContext)
        user.username = username
        user.password = password
        try! CoreStack.shared.persistentContainer.viewContext.save()
    }
    return state
}
