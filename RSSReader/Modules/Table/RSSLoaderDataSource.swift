//
//  RSSLoaderDataSource.swift
//  RSSReader
//
//  Created by Алексей Папин on 17/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import FeedKit
import PromiseKit

class RSSLoaderDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    let loader = RSSLoader(url: URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!)
    var entries: [RSSEntry] = []
    var loggedUser: User?
    
    func performFetch() -> Promise<[RSSEntry]> {
        return Promise<[RSSEntry]> { resolver in
            self.loader.fetch()
                .done { feed in
                    guard let items = feed.items else {
                        let error = NSError(domain: "RSSReader", code: 404, userInfo: [NSLocalizedDescriptionKey: "There is no items in RSSFeed"])
                        resolver.reject(error)
                        return
                    }
                    let context = CoreStack.shared.persistentContainer.viewContext
                    self.entries.removeAll()
                    for item in items {
                        let entry = RSSEntry(context: context)
                        entry.update(with: item)
                        self.entries.append(entry)
                    }
                    resolver.fulfill(self.entries)
                }
                .catch { error in
                    resolver.reject(error)
                }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RSSEntryCell.reuseIdentifier, for: indexPath) as! RSSEntryCell
        cell.configure(with: self.entries[indexPath.row]) { return self.bookmark($0) }
        return cell
    }
        
    private func bookmark(_ entry: RSSEntry) -> Bool {
        store.dispatch(TableActions.bookmarkedItem(entry))
        return self.loggedUser?.bookmarkState(entry) ?? false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(TableActions.selectedItem(self.entries[indexPath.row]))
    }
}
