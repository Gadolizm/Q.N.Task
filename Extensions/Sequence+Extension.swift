//
//  Sequence+Extension.swift
//  QuaNode
//
//  Created by Gado on 8/4/19.
//  Copyright © 2019 Gado. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var alreadyAdded = Set<Iterator.Element>()
        return self.filter { alreadyAdded.insert($0).inserted }
    }
}
