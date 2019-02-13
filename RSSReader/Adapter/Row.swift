//
//  Row.swift
//  FlexAdapter
//
//  Created by Алексей Папин on 11/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit

protocol RowProtocol {
    var item: TypeProtocol { get set }
    var cellId: String { get }
    var cellNib: UINib { get }
    var cellHeight: CGFloat { get }
    func configure(cell: UITableViewCell)
}

class Row<T: TypeProtocol, Cell: UITableViewCell & ConfigurableCell> where Cell.T == T {
    var value: T
    
    init(_ value: T) {
        self.value = value
    }
}

extension Row: RowProtocol {
    var cellHeight: CGFloat {
        return Cell.cellHeight
    }
    
    var item: TypeProtocol {
        get { return self.value }
        set { self.value = newValue as! T }
    }
    
    var cellId: String {
        return Cell.reuseIdentifier
    }
    
    var cellNib: UINib {
        return Cell.cellNib
    }
    
    public func configure(cell: UITableViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.configure(with: self.value)
    }
}
