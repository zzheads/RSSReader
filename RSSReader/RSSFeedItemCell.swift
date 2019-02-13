//
//  FeedItemCell.swift
//  RSSReader
//
//  Created by Алексей Папин on 13/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import FeedKit

final class RSSFeedItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    private var item: RSSFeedItem?
}

extension RSSFeedItemCell: ConfigurableCell {
    static var cellHeight: CGFloat {
        return 165
    }
    
    func configure(with item: RSSFeedItem) {
        self.item = item
        self.titleLabel.text = item.title
        self.contentLabel.text = item.description
    }
}
