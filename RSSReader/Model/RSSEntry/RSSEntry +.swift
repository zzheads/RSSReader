//
//  RSSEntry +.swift
//  RSSReader
//
//  Created by Алексей Папин on 17/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import CoreData
import FeedKit

extension RSSEntry {
    func update(with item: RSSFeedItem) {
        self.title = item.title
        self.author = item.author
        self.content = item.description
        self.link = item.link
        self.pubDate = item.pubDate
        self.comments = item.comments
    }
}

extension Set where Element == RSSEntry {
    mutating func handleBookmark(_ entry: Element) -> Bool {
        if self.contains(entry) {
            self.remove(entry)
        } else {
            self.insert(entry)
        }
        return self.contains(entry)
    }
}

