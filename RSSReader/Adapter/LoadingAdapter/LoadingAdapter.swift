//
//  LoadingAdapter.swift
//  FlexAdapter
//
//  Created by Алексей Папин on 11/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import PromiseKit

class LoadingAdapter<Loader: LoaderProtocol>: Adapter where Loader.ItemType == TypeProtocol {
    var provider: Provider<Loader>!
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(fetchMore), for: .valueChanged)
        return control
    }()
    
    init(_ tableView: UITableView, loader: Loader) {
        super.init(tableView)
        self.provider = Provider(adapter: self, loader: loader)
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.refreshControl = self.refreshControl
    }
    
    @objc func fetchMore() {
        self.provider.fetchMore()
            .done { newItems in
                print(newItems)
            }
            .catch { error in
                print(error)
            }
            .finally {
                self.refreshControl.endRefreshing()
            }
    }
}


