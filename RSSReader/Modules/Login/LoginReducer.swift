//
//  LoginReducer.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import Foundation
import ReSwift

struct LoginState: Codable {
    enum LoginResult: Codable {
        case success(User)
        case failure(String)
        
        enum CodingKeys: String, CodingKey {
            case success
            case failure
        }
        
        enum LoginResultCodingError: Error {
            case decoding(String)
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let user = try? container.decode(User.self, forKey: .success)
            let error = try? container.decode(String.self, forKey: .failure)
            if let user = user {
                self = .success(user)
                return
            }
            if let error = error {
                self = .failure(error)
                return
            }
            throw LoginResultCodingError.decoding("Error decoding LoginResult: \(dump(container))")
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case let .success(user)     : try container.encode(user, forKey: .success)
            case let .failure(error)    : try container.encode(error, forKey: .failure)
            }
        }
    }
    
    var result: LoginResult?
    
    var loggedUser: User? {
        guard let result = self.result else {
            return nil
        }
        switch result {
        case let .success(user) : return user
        case .failure(_)        : return nil
        }
    }
    
    var isLogged: Bool {
        return self.loggedUser != nil
    }
    
    var error: String? {
        guard let result = self.result else {
            return nil
        }
        switch result {
        case let .failure(error): return error
        default                 : return nil
        }
    }
}

enum LoginActions: Action {
    case login(User)
    case logout
}

func loginReducer(_ action: Action, _ state: AppState) -> AppState {
    var state = state
    guard let action = action as? LoginActions else {
        return state
    }
    switch action {
    case let .login(user)   : state.login.result = state.register.validate(user)
    case .logout            : state.login.result = nil
    }
    return state
}
