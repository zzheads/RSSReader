//
//  ViewController.swift
//  RSSReader
//
//  Created by Алексей Папин on 13/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import FeedKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let loader = RSSLoader(url: URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!)
    lazy var adapter: LoadingAdapter<RSSLoader> = {
        let adapter = LoadingAdapter<RSSLoader>(self.tableView, loader: self.loader)
        return adapter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adapter.fetchMore()
    }

}

