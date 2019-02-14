//
//  State.swift
//  RSSReader
//
//  Created by Алексей Папин on 14/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import ReSwift
import FeedKit

struct LoginState {
    var loggedUser: User?
    
    var isLogged: Bool {
        return self.loggedUser != nil
    }
}

struct TableState {
    var selectedItem: RSSFeedItem?

    var detailsViewController: DetailsViewController? {
        guard let selectedItem = self.selectedItem else {
            return nil
        }
        return DetailsViewController(selectedItem)
    }
}

struct AppState: StateType {
    var login       : LoginState = LoginState()
    var table       : TableState = TableState()
}
