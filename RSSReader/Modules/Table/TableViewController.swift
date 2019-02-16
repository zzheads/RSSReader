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

class TableViewController: BaseViewController, StoreSubscriber {
    @IBOutlet weak var tableView: UITableView!
    let loader = RSSLoader(url: URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!)
    lazy var adapter: LoadingAdapter<RSSLoader> = {
        let adapter = LoadingAdapter<RSSLoader>(self.tableView, loader: self.loader) { item in print("Long tap detected: \(item) ")}
        adapter.selectDelegate = self.showDetails
        return adapter
    }()
    
    let coreDataLoader = CoreDataLoader()
    lazy var coreDataAdapter: LoadingAdapter<CoreDataLoader> = {
        let adapter = LoadingAdapter<CoreDataLoader>(self.tableView, loader: self.coreDataLoader) { item in print("Long tap detected: \(item) ")}
        adapter.selectDelegate = self.showDetails
        return adapter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.getFeed().done { rssFeed in
            self.navigationItem.title = rssFeed.description
            if let count = rssFeed.items?.count {
                self.tabBarItem.badgeValue = "\(count)"
            }
        }.cauterize()
        self.adapter.fetch()
            .done { entries in
                guard let entries = entries as? [RSSEntry] else {
                    return
                }
                entries.insertOrUpdateObjects()
                    .done { objects in print(objects) }
                    .catch { error in print(error) }
            }
            .catch { [weak self] error in
                guard let sSelf = self else {
                    return
                }
                // Connection problem possible
                sSelf.tableView.dataSource = sSelf.coreDataAdapter
                sSelf.tableView.delegate = sSelf.coreDataAdapter
                
                sSelf.coreDataAdapter.fetchMore()
            }
        
        self.navigationItem.leftBarButtonItem?.title = "Logout"
        self.navigationItem.leftBarButtonItem?.action = #selector(leftButtonPressed(_:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.unsubscribe(self)
    }
    
    @objc func leftButtonPressed(_ sender: UIBarButtonItem) {
        store.dispatch(LoginActions.logout)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func bookmark(_ entry: RSSEntry, for user: User) {
        user.bookmarks.insert(entry.id)
        user.updateObject()
        print("Entry with id=\(entry.id) bookmarked")
    }
    
    func newState(state: AppState) {
        if let detailsViewController = state.table.detailsViewController {
            self.present(detailsViewController, animated: true) { store.dispatch(TableActions.detailsShown) }
        }
        if let loggedUser = state.login.loggedUser {
            self.adapter.completion = { entry in
                guard let entry = entry as? RSSEntry else {
                    return
                }
                self.bookmark(entry, for: loggedUser)
            }
        }
    }

    func showDetails(_ item: TypeProtocol) {
        guard let item = item as? RSSEntry else {
            return
        }
        store.dispatch(TableActions.selectedItem(item))
    }
}


