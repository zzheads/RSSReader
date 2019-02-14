//
//  RSSLoader.swift
//  RSSReader
//
//  Created by Алексей Папин on 13/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import FeedKit
import PromiseKit

class RSSLoader: LoaderProtocol {
    let parser: FeedParser
    
    init(url: URL) {
        self.parser = FeedParser(URL: url)
    }
    
    func fetch(offset: Int, count: Int) -> Promise<[TypeProtocol]> {
        return Promise<[TypeProtocol]> { resolver in
            self.parser.parseAsync(queue: DispatchQueue(label: "RSSDataFetch")) { result in
                switch result {
                case .rss(let rssFeed)  :
                    guard let rssFeedItems = rssFeed.items else {
                        let error = NSError(domain: "RSSReader", code: 404, userInfo: [NSLocalizedDescriptionKey: "RSSFeed is empty"])
                        resolver.reject(error)
                        return
                    }
                    resolver.fulfill(rssFeedItems)
                    
                case .failure(let error): resolver.reject(error)
                default                 :
                    let error = NSError(domain: "RSSReader", code: 405, userInfo: [NSLocalizedDescriptionKey: "RSSFeed is in incopatible format"])
                    resolver.reject(error)
                }
            }
        }
    }
    
    func getFeed() -> Promise<RSSFeed> {
        return Promise<RSSFeed> { resolver in
            self.parser.parseAsync(queue: DispatchQueue(label: "RSSDataFetch")) { result in
                switch result {
                case .rss(let rssFeed)      : resolver.fulfill(rssFeed)
                case .failure(let error)    : resolver.reject(error)
                default                     :
                    let error = NSError(domain: "RSSReader", code: 405, userInfo: [NSLocalizedDescriptionKey: "RSSFeed is in incopatible format"])
                    resolver.reject(error)
                }
            }
        }
    }
}
