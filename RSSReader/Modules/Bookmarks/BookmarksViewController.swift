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
    var loggedUser: User!
    var adapter: LoadingAdapter<BookmarksLoader>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.subscribe(self)
    }
    
    func newState(state: AppState) {
        guard let loggedUser = state.login.loggedUser else {
            return
        }
        self.loggedUser = loggedUser
        let loader = BookmarksLoader(loggedUser: loggedUser)
        let adapter = LoadingAdapter<BookmarksLoader>(self.tableView, loader: loader) { entry in print("Tapped: \(entry)") }
        self.tableView.dataSource = adapter
        self.tableView.delegate = adapter
        adapter.fetchMore()
        self.tableView.reloadData()
    }
}

