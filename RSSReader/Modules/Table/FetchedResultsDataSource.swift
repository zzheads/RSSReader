//
//  FetchedResultsController.swift
//  RSSReader
//
//  Created by Алексей Папин on 17/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import CoreData
import UIKit

class FetchedResultsDataSource: NSObject, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    var loggedUser: User?
    var entries: [RSSEntry] = []
    
    lazy var fetchedEntriesController: NSFetchedResultsController<RSSEntry> = {
        let request = NSFetchRequest<RSSEntry>(entityName: RSSEntry.entity().name!)
        let sort = NSSortDescriptor(key: "pubDate", ascending: true)
        request.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreStack.shared.persistentContainer.viewContext, sectionNameKeyPath: "pubDate", cacheName: nil)
        controller.delegate = self
        return controller
    }()

    func performFetch() throws {
        try fetchedEntriesController.performFetch()
        self.entries = fetchedEntriesController.fetchedObjects ?? []
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
        return loggedUser?.bookmarkState(entry) ?? false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(TableActions.selectedItem(self.entries[indexPath.row]))
    }
}
