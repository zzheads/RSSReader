//
//  Comparable +.swift
//  RSSReader
//
//  Created by Алексей Папин on 13/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    func insertPosition(for element: Element, order: ComparisonResult = .orderedAscending ) -> Int {
        return self.firstIndex(where: { order == .orderedAscending ? element >= $0 : element <= $0 }) ?? self.count
    }
}
