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
            do {
                let request = NSFetchRequest<RSSEntry>(entityName: RSSEntry.entity().name!)
                let context = CoreStack.shared.persistentContainer.viewContext
                let entries = try context.fetch(request)
                resolver.fulfill(entries)
            } catch {
                resolver.reject(error)
            }
        }
    }
}
