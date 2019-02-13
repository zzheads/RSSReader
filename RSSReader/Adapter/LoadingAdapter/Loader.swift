//
//  Loader.swift
//  FlexAdapter
//
//  Created by Алексей Папин on 11/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import PromiseKit

protocol LoaderProtocol {
    associatedtype ItemType
    func fetch(offset: Int, count: Int) -> Promise<[ItemType]>
}
