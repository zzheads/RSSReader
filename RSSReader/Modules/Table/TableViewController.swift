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
        let adapter = LoadingAdapter<RSSLoader>(self.tableView, loader: self.loader)
        return adapter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.getFeed().done { rssFeed in self.title = rssFeed.description }.cauterize()
        self.adapter.fetchMore()
        self.adapter.selectDelegate = self.showDetails
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
    
    func newState(state: AppState) {
        guard let detailsViewController = state.table.detailsViewController else {
            return
        }
        self.present(detailsViewController, animated: true) { store.dispatch(TableActions.detailsShown) }
    }

    func showDetails(_ item: TypeProtocol) {
        guard let item = item as? RSSFeedItem else {
            return
        }
        store.dispatch(TableActions.selectedItem(item))
    }
}


