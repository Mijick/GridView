//
//  GridViewConfig.swift of GridScrollView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Policies
extension GridViewConfig {
    func insertionPolicy(_ value: Matrix.InsertionPolicy) -> Self { changing(path: \.insertionPolicy, to: value) }
}

// MARK: - Composition
extension GridViewConfig {
    func columns(_ value: Int) -> Self { changing(path: \.numberOfColumns, to: value) }
    func verticalSpacing(_ value: CGFloat) -> Self { changing(path: \.spacing.vertical, to: value) }
    func horizontalSpacing(_ value: CGFloat) -> Self { changing(path: \.spacing.horizontal, to: value) }
}


// MARK: - Internal
public struct GridViewConfig: Configurable { public init() {}
    private(set) var insertionPolicy: Matrix.InsertionPolicy = .ordered

    private(set) var numberOfColumns: Int = 2
    private(set) var spacing: (vertical: CGFloat, horizontal: CGFloat) = (8, 8)
}
