//
//  DataCoreLoader.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import CoreData
import PromiseKit

class CoreDataLoader: LoaderProtocol {
    func fetch(offset: Int, count: Int) -> Promise<[TypeProtocol]> {
        return Promise<[TypeProtocol]> { resolver in
            RSSEntry.fetch()
                .done { entries in resolver.fulfill(entries) }
                .catch { error in resolver.reject(error) }
        }
    }
}
