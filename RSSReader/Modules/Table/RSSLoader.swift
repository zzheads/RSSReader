//
//  _RSSLoader.swift
//  RSSReader
//
//  Created by Алексей Папин on 17/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import PromiseKit
import FeedKit
import CoreData

class RSSLoader {
    let parser: FeedParser
    
    init(url: URL) {
        self.parser = FeedParser(URL: url)
    }
    
    func fetch() -> Promise<RSSFeed> {
        return Promise<RSSFeed> { resolver in
            self.parser.parseAsync(queue: DispatchQueue(label: "RSSDataFetch")) { result in
                switch result {
                case .rss(let rssFeed)  : resolver.fulfill(rssFeed)
                case .failure(let error): resolver.reject(error)

                default                 :
                    let error = NSError(domain: "RSSReader", code: 405, userInfo: [NSLocalizedDescriptionKey: "RSSFeed is in incopatible format"])
                    resolver.reject(error)
                }
            }
        }
    }
}
