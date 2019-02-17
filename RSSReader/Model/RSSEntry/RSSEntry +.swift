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

extension RSSEntry: TypeProtocol {
    var sectionHeader: String {
        guard let pubDate = pubDate else {
            return ""
        }
        return Date.formatter.string(from: pubDate)
    }
    
    var sectionId: String {
        let formatter = Date.formatter
        formatter.dateFormat = "yyMMdd"
        guard let pubDate = pubDate else {
            return ""
        }
        return formatter.string(from: pubDate)
    }
    
    var rowId: String {
        return self.sectionId
    }
    
    var row: RowProtocol {
        return Row<RSSEntry, RSSEntryCell>(self)
    }
}
