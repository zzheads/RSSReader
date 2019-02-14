//
//  DetailsViewController.swift
//  RSSReader
//
//  Created by Алексей Папин on 15/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import FeedKit
import ReSwift
import SafariServices

class DetailsViewController: SFSafariViewController {
    var rssFeedItem: RSSFeedItem
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let leftButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(leftButtonPressed(_:)))
        leftButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bold14], for: .normal)
        leftButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.bold14], for: .highlighted)
        self.navigationItem.setLeftBarButton(leftButton, animated: true)
    }

    @objc func leftButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    init?(_ item: RSSFeedItem) {
        self.rssFeedItem = item
        guard let link = item.link, let url = URL(string: link) else {
            return nil
        }
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        super.init(url: url, configuration: configuration)
    }    
}
