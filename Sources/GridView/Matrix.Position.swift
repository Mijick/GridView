//
//  Matrix.Position.swift of GridView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension Matrix { struct Position {
    let row: Int
    let column: Int
}}
extension Matrix.Position: Comparable {
    static func < (lhs: Matrix.Position, rhs: Matrix.Position) -> Bool {
        if lhs.row == rhs.row { return lhs.column < rhs.column }
        return lhs.row < rhs.row
    }
}

// MARK: - Creating Item Range
extension Matrix.Position {
    func createItemRange(_ item: Matrix.Item) -> Matrix.Range { .init(from: self, to: withColumn(column + item.columns - 1)) }
}

// MARK: - Helpers
extension Matrix.Position {
    func withRow(_ rowIndex: Int) -> Self { .init(row: rowIndex, column: column) }
    func withColumn(_ columnIndex: Int) -> Self { .init(row: row, column: columnIndex) }

    func nextRow() -> Self { withRow(row + 1) }
    func nextColumn() -> Self { withColumn(column + 1) }

    func previousRow() -> Self { withRow(row - 1) }
    func previousColumn() -> Self { withColumn(column - 1) }
}

// MARK: - Objects
extension Matrix.Position {
    static var zero: Self { .init(row: 0, column: 0) }
}
