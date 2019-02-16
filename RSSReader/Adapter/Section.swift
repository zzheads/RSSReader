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
        label.font = UIFont.bold15
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(red: 0, green: 51/255, blue: 102/255, alpha: 0.5)
        label.backgroundColor = .clear
        label.sizeToFit()
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
