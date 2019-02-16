//
//  Provider.swift
//  FlexAdapter
//
//  Created by Алексей Папин on 11/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import PromiseKit

class Provider<Loader: LoaderProtocol> where Loader.ItemType == TypeProtocol {
    enum RequestResult {
        case success(Int)
        case failure(Int, Int, Error)
        
        var receivedItems: Int {
            switch self {
            case .success(let count)    : return count
            case .failure(_)            : return 0
            }
        }
    }
    
    let loader: Loader
    weak var adapter: LoadingAdapter<Loader>!
    var pageSize: Int
    var log: [RequestResult] = []
    var receivedItems: Int {
        return self.log.compactMap({ $0.receivedItems }).reduce(0, +)
    }
    
    init(adapter: LoadingAdapter<Loader>, loader: Loader, pageSize: Int = 5) {
        self.adapter = adapter
        self.loader = loader
        self.pageSize = pageSize
    }

    public func fetchMore() -> Promise<[TypeProtocol]> {
        return Promise<[TypeProtocol]> { resolver in
            self.loader.fetch(offset: self.receivedItems, count: self.pageSize)
                .done { newItems in
                    self.makeUpdates(in: self.adapter, items: newItems)
                    self.log.append(.success(newItems.count))
                    resolver.fulfill(newItems)
                }
                .catch { error in
                    self.log.append(.failure(self.receivedItems, self.pageSize, error))
                    resolver.reject(error)
                }
        }
    }
    
    private func makeUpdates(in adapter: Adapter, items: [TypeProtocol]) {
        for i in 0..<items.count {
            let item = items[i]
            
            // 1 - insert section if there is no needed sections yet
            if (!adapter.sections.contains(where: { $0.header == item.sectionHeader })) {
                let insertPosition = adapter.sections.compactMap({ $0.header }).insertPosition(for: item.sectionId)
                let newSection = Section(header: item.sectionHeader)
                adapter.handle(.insertSection(newSection, insertPosition), with: .middle)
            }
            
            let sectionIndex: Int = adapter.sections.firstIndex(where: { $0.header == item.sectionHeader })!
            // 2 - check if that item already exists in the section
            if let existIndex = adapter.sections[sectionIndex].rows.firstIndex(where: { $0.item.rowId == item.rowId }) {
                adapter.handle(.updateRows([item.row], [IndexPath(row: existIndex, section: sectionIndex)]))
            } else {
                let insertPosition = adapter.sections[sectionIndex].rows.compactMap({ $0.item.rowId }).insertPosition(for: item.rowId)
                adapter.handle(.insertRows([item.row], [IndexPath(row: insertPosition, section: sectionIndex)]), with: .bottom)
            }
        }
    }
}
