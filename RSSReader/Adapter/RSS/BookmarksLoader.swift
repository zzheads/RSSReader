//
//  BookmarksLoader.swift
//  RSSReader
//
//  Created by Алексей Папин on 17/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import PromiseKit

class BookmarksLoader: LoaderProtocol {
    var loggedUser: User

    init(loggedUser: User) {
        self.loggedUser = loggedUser
    }
    
    func fetch(offset: Int, count: Int) -> Promise<[TypeProtocol]> {
        return Promise<[TypeProtocol]> { resolver in
            RSSEntry.fetch()
                .done { entries in
                    let bookmarks = entries.filter({ self.loggedUser.bookmarks.contains($0.id) })
                    resolver.fulfill(bookmarks)
                }
                .catch { error in
                    resolver.reject(error)
                }
        }
    }
}
