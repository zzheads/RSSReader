//
//  Section.swift
//  FlexAdapter
//
//  Created by Алексей Папин on 11/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit

class Section {
    let header: String
    lazy var headerView: UIView = {
        let label = UILabel()
        label.text = self.header
        label.font = UIFont.bold18
        label.textAlignment = .center
        label.textColor = .darkGray
        label.backgroundColor = .lightGray
        label.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 80))
        return label
    }()
    
    var rows: [RowProtocol] = []
    
    init(header: String) {
        self.header = header
    }
    
    public var lastRowIndex: Int {
        return self.rows.count > 0 ? self.rows.count - 1 : 0
    }
}
