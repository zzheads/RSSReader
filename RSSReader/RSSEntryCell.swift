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
    static let reuseIdentifier = "\(RSSEntryCell.self)"
    static let nibName = UINib(nibName: reuseIdentifier, bundle: nil)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var entry: RSSEntry?
    private var completion: ((RSSEntry) -> Bool)?
    
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
    }
    
    @objc private func favoriteButtonPressed(_ sender: UIButton) {
        guard let entry = self.entry else {
            return
        }
        let newStateButton = self.completion?(entry) ?? false
        self.setFavoriteButton(newStateButton)
    }
    
    private func setFavoriteButton(_ isFavorite: Bool) {
        let image = self.favoriteButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
        self.favoriteButton.setImage(image, for: .normal)
        self.favoriteButton.tintColor = isFavorite ? .white : .darkGray
    }
}

extension RSSEntryCell {
    static var cellHeight: CGFloat {
        return 172
    }
    
    func configure(with item: RSSEntry, completion: @escaping (RSSEntry) -> Bool) {
        self.entry = item
        self.completion = completion
        self.titleLabel.text = item.title
        self.contentLabel.text = item.content
        self.authorLabel.text = item.author
        if let pubDate = item.pubDate {
            self.dateLabel.text = Date.formatter.string(from: pubDate)
        } else {
            self.dateLabel.text = ""
        }

        _ = completion(item)
        let startState = completion(item)
        self.setFavoriteButton(startState)
        self.favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
    }
}
