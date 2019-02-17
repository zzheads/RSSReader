//
//  ViewController.swift
//  RSSReader
//
//  Created by Алексей Папин on 13/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import FeedKit
import ReSwift
import CoreData

class TableViewController: BaseViewController, StoreSubscriber {
    @IBOutlet weak var tableView: UITableView!
    var loggedUser: User? {
        didSet {
            self.rssLoaderDataSource.loggedUser = self.loggedUser
            self.fetchedDataSource.loggedUser = self.loggedUser
        }
    }
    var updateBookmarksCount: ((Int) -> Void)?
    
    var rssLoaderDataSource = RSSLoaderDataSource()
    var fetchedDataSource = FetchedResultsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.subscribe(self)
        self.tableView.register(RSSEntryCell.nibName, forCellReuseIdentifier: RSSEntryCell.reuseIdentifier)
    }
    
    private func fetch() {
        self.tableView.dataSource = self.rssLoaderDataSource
        self.tableView.delegate = self.rssLoaderDataSource
        self.rssLoaderDataSource.performFetch()
            .done { entries in
                self.tabBarItem.badgeValue = "\(entries.count)"
                self.tableView.reloadData()
            }
            .catch { internetError in
                // Could be internet connection problems - try get entries from database
                do {
                    self.tableView.dataSource = self.fetchedDataSource
                    self.tableView.delegate = self.fetchedDataSource
                    try self.fetchedDataSource.performFetch()
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            }
    }
    
    func newState(state: AppState) {
        if let detailsViewController = state.table.detailsViewController {
            self.present(detailsViewController, animated: true) { store.dispatch(TableActions.detailsShown) }
        }
        if self.loggedUser != state.login.loggedUser {
            self.loggedUser = state.login.loggedUser
            self.fetch()
        }
    }
}



