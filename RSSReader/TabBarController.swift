//
//  TabBarController.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import ReSwift

class TabBarController: UITabBarController, StoreSubscriber {
    override func viewDidLoad() {
        super.viewDidLoad()
        store.subscribe(self)
    }

    private var bookmarksViewController: BookmarksViewController? {
        guard let controller = self.viewControllers?.first(where: { $0 as? BookmarksViewController != nil }) else {
            return nil
        }
        return controller as? BookmarksViewController
    }

    func newState(state: AppState) {
        self.bookmarksViewController?.tabBarItem.isEnabled = state.login.isLogged
        self.bookmarksViewController?.tabBarItem.badgeValue = "\(state.login.loggedUser?.bookmarks?.count ?? 0)"
    }
}
