//
//  GridViewConfig.swift of GridView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Policies
public extension GridView.Config {
    func insertionPolicy(_ value: MatrixInsertionPolicy) -> Self { changing(path: \.insertionPolicy, to: value) }
}

// MARK: - Composition
public extension GridView.Config {
    func columns(_ value: Int) -> Self { changing(path: \.numberOfColumns, to: value) }
    func verticalSpacing(_ value: CGFloat) -> Self { changing(path: \.spacing.vertical, to: value) }
    func horizontalSpacing(_ value: CGFloat) -> Self { changing(path: \.spacing.horizontal, to: value) }
}


// MARK: - Internal
extension GridView { public struct Config: Configurable { public init() {}
    private(set) var insertionPolicy: MatrixInsertionPolicy = .ordered

    private(set) var numberOfColumns: Int = 2
    private(set) var spacing: (vertical: CGFloat, horizontal: CGFloat) = (8, 8)
}}
