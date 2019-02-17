//
//  BookmarksViewController.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import ReSwift
import PromiseKit

class BookmarksViewController: BaseViewController, StoreSubscriber {
    @IBOutlet weak var tableView: UITableView!
    var bookmarks: [RSSEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(RSSEntryCell.nibName, forCellReuseIdentifier: RSSEntryCell.reuseIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        store.subscribe(self)
    }
    
    func newState(state: AppState) {
        guard let loggedUser = state.login.loggedUser else {
            return
        }
        let set = loggedUser.bookmarks as? Set<RSSEntry> ?? []
        self.bookmarks = Array(set)
        self.tableView.reloadData()
        self.tabBarItem.badgeValue = "\(self.bookmarks.count)"
    }
}

extension BookmarksViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RSSEntryCell.reuseIdentifier, for: indexPath) as! RSSEntryCell
        cell.configure(with: self.bookmarks[indexPath.row]) { entry in return true }
        return cell
    }
}

