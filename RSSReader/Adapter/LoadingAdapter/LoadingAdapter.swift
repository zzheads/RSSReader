//
//  LoadingAdapter.swift
//  FlexAdapter
//
//  Created by Алексей Папин on 11/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import PromiseKit

protocol DetailsProtocol {
    func showDetails(item: TypeProtocol)
}

class LoadingAdapter<Loader: LoaderProtocol>: Adapter where Loader.ItemType == TypeProtocol {
    var provider: Provider<Loader>!
    var delegate: DetailsProtocol?
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(fetchMore), for: .valueChanged)
        return control
    }()
    
    init(_ tableView: UITableView, loader: Loader, completion: @escaping (TypeProtocol) -> Bool) {
        super.init(tableView, completion: completion)
        self.provider = Provider(adapter: self, loader: loader)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.refreshControl = self.refreshControl
    }
    
    func fetch() -> Promise<[TypeProtocol]> {
        return Promise<[TypeProtocol]> { resolver in
            self.provider.fetchMore()
                .done { newItems in resolver.fulfill(newItems) }
                .catch { error in resolver.reject(error) }
                .finally { self.refreshControl.endRefreshing() }
        }
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



