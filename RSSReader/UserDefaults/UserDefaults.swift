//
//  UserDefaults.swift
//  RSSReader
//
//  Created by Алексей Папин on 17/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import Foundation

extension UserDefaults {
    static var `default` = UserDefaults(suiteName: "com.zzheads.RSSReader")!
    static var loggedUsernameKey = "LoggedUsername"
    
    var loginState: LoginState? {
        get {
            guard
                let username = self.value(forKey: UserDefaults.loggedUsernameKey) as? String,
                let loginState = LoginState(username: username)
                else {
                    return nil
            }
            return loginState
        }
        set {
            self.setValue(newValue?.loggedUser?.username, forKey: UserDefaults.loggedUsernameKey)
        }
    }
}
