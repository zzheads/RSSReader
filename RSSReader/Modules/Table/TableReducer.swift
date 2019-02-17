//
//  TableReducer.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import ReSwift
import FeedKit
import SafariServices

struct TableState {
    var selectedItem: RSSEntry?
    var bookmarks: Set<RSSEntry> = []
    
    var detailsViewController: SFSafariViewController? {
        guard
            let selectedItem = self.selectedItem,
            let link = selectedItem.link,
            let url = URL(string: link)
            else {
                return nil
        }
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = true
        configuration.entersReaderIfAvailable = true
        return SFSafariViewController(url: url, configuration: configuration)
    }
}

enum TableActions: Action {
    case selectedItem(RSSEntry)
    case bookmarkedItem(RSSEntry)
    case detailsShown
}

func tableReducer(_ action: Action, _ state: AppState) -> AppState {
    var state = state
    guard let action = action as? TableActions else {
        return state
    }
    switch action {
    case .selectedItem(let item)    : state.table.selectedItem = item
    case .detailsShown              : state.table.selectedItem = nil
    case .bookmarkedItem(let item)  :
        _ = state.login.loggedUser?.handleBookmark(item)
        _ = state.table.bookmarks.handleBookmark(item)
    }
    return state
}
