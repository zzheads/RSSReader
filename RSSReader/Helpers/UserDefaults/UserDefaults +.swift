//
//  UserDefaults +.swift
//  RSSReader
//
//  Created by Алексей Папин on 15/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let `default` = UserDefaults(suiteName: "RSSReader")!
    static let loginStateKey = "LoginState"
    static let registerStateKey = "RegisterState"

    var loginState: LoginState? {
        set { UserDefaults.default.set(newValue.toJSON, forKey: UserDefaults.loginStateKey) }
        get {
            guard let json = UserDefaults.default.value(forKey: UserDefaults.loginStateKey) as? JSON else {
                return nil
            }
            return LoginState(fromJSON: json)
        }
    }
    
    var registerState: RegisterState? {
        set { UserDefaults.default.set(newValue?.toJSON, forKey: UserDefaults.registerStateKey) }
        get {
            guard let json = UserDefaults.default.value(forKey: UserDefaults.registerStateKey) as? JSON else {
                return nil
            }
            return RegisterState(fromJSON: json)
        }
    }
}
