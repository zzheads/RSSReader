//
//  Action.swift
//  RSSReader
//
//  Created by Алексей Папин on 14/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import ReSwift
import FeedKit

enum LoginActions: Action {
    case login(String?, String?)
    case logout
}

enum TableActions: Action {
    case selectedItem(RSSFeedItem)
    case detailsShown
}
