//
//  RSSProvider.swift
//  RSSReader
//
//  Created by Алексей Папин on 13/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import FeedKit

extension RSSFeedItem: TypeProtocol {
    var sectionId: String {
        guard let pubDate = self.pubDate else {
            return ""
        }
        return Date.formatter.string(from: pubDate)
    }
    
    var rowId: String {
        return self.guid?.value ?? ""
    }
    
    var row: RowProtocol {
        return Row<RSSFeedItem, RSSFeedItemCell>(self)
    }
}

class RSSProvider: Provider<RSSLoader> {
    
}
