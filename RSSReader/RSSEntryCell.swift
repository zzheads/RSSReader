//
//  FeedItemCell.swift
//  RSSReader
//
//  Created by Алексей Папин on 13/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import FeedKit

final class RSSEntryCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    private var entry: RSSEntry?
    private var completion: ((RSSEntry) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.selectionStyle = .none
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longDidPressed(_:)))
        self.addGestureRecognizer(recognizer)
    }
    
    @objc private func longDidPressed(_ sender: UILongPressGestureRecognizer) {
        guard let entry = self.entry else {
            return
        }
        self.completion?(entry)
    }
}

extension RSSEntryCell: ConfigurableCell {
    static var cellHeight: CGFloat {
        return 165
    }
    
    func configure(with item: RSSEntry, completion: @escaping (RSSEntry) -> Void) {
        self.entry = item
        self.completion = completion
        self.titleLabel.text = item.title
        self.contentLabel.text = item.content
    }
}
