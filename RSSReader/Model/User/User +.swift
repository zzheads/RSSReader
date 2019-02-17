//
//  User +.swift
//  RSSReader
//
//  Created by Алексей Папин on 17/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import CoreData

extension User {
    func handleBookmark(_ entry: RSSEntry) -> Bool {
        let context = CoreStack.shared.persistentContainer.viewContext
        guard let bookmarks = self.bookmarks as? Set<RSSEntry> else {
            return false
        }
        if bookmarks.contains(entry) {
            self.removeFromBookmarks(entry)
            try! context.save()
            return false
        } else {
            self.addToBookmarks(entry)
            try! context.save()
            return true
        }
    }
    
    func bookmarkState(_ entry: RSSEntry) -> Bool {
        guard let bookmarks = self.bookmarks as? Set<RSSEntry> else {
            return false
        }
        return bookmarks.contains(where: { entry.title == $0.title })
    }
}
