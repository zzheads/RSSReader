//
//  Date +.swift
//  RSSReader
//
//  Created by Алексей Папин on 13/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import Foundation

extension Date {
    static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        formatter.locale = Locale.current
        return formatter
    }
}
