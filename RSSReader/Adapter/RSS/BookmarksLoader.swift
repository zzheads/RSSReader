//
//  BookmarksLoader.swift
//  RSSReader
//
//  Created by Алексей Папин on 17/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import PromiseKit
import CoreData

class BookmarksLoader: LoaderProtocol {
    var loggedUser: User

    init(loggedUser: User) {
        self.loggedUser = loggedUser
    }
    
    func fetch(offset: Int, count: Int) -> Promise<[TypeProtocol]> {
        return Promise<[TypeProtocol]> { resolver in
            guard let bookmarks = self.loggedUser.bookmarks as? Set<RSSEntry> else {
                let error = NSError(domain: "RSSReader", code: 403, userInfo: [NSLocalizedDescriptionKey: "Cant read bookmarks of \(self.loggedUser)"])
                resolver.reject(error)
                return
            }
            resolver.fulfill(Array(bookmarks))
        }
    }
}
