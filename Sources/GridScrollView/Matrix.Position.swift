//
//  Matrix.Position.swift of GridScrollView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension Matrix { struct Position: Equatable, Comparable {
    let row: Int
    let column: Int
}}

// MARK: - Comparable
extension Matrix.Position {
    static func < (lhs: Matrix.Position, rhs: Matrix.Position) -> Bool {
        if lhs.row == rhs.row { return lhs.column < rhs.column }
        return lhs.row < rhs.row
    }
}

// MARK: - Helpers
extension Matrix.Position {
    func nextRow() -> Self { .init(row: row + 1, column: 0) }
    func nextColumn() -> Self { .init(row: row, column: column + 1) }
}

// MARK: - Objects
extension Matrix.Position {
    static var zero: Self { .init(row: 0, column: 0) }
}
