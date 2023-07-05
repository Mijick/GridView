//
//  Matrix.swift of GridScrollView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct Matrix {
    private var items: [[Item]]
    private let policy: MatrixInsertionPolicy

    init(columns: Int, policy: MatrixInsertionPolicy) { self.items = .init(numberOfColumns: columns); self.policy = policy }
}

// MARK: - Inserting Items
extension Matrix {
    mutating func insert(_ item: Item) { if canItemBeInserted(item) {
        let position = findPositionForItem(item)

        addNewRowIfNeeded(position)
        insertItem(item, position)
    }}
}
private extension Matrix {
    func canItemBeInserted(_ item: Item) -> Bool { !items.flatMap { $0 }.contains(item) }
    func findPositionForItem(_ item: Item) -> Position {
        switch policy {
            case .ordered: return findPositionForOrderedPolicy(item)
            case .fill: return findPositionForFillPolicy(item)
        }
    }
    mutating func addNewRowIfNeeded(_ position: Position) { if position.row >= items.count {
        items.insertEmptyRow(numberOfColumns: numberOfColumns)
    }}
    mutating func insertItem(_ item: Item, _ position: Position) {
        items[position.row][position.column] = item
    }
}
private extension Matrix {
    func findPositionForOrderedPolicy(_ item: Item) -> Position {
        let index = item.index

        let columnIndex = index % numberOfColumns
        let rowIndex = index / numberOfColumns
        return .init(row: rowIndex, column: columnIndex)
    }
    func findPositionForFillPolicy(_ item: Item) -> Position {
        let columnHeights = getColumnHeights()

        let columnIndex = columnHeights.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
        let rowIndex = items.firstIndex(where: { $0[columnIndex].isEmpty }) ?? items.count
        return .init(row: rowIndex, column: columnIndex)
    }
}
extension Matrix {
    func getColumnHeights(upToRow index: Int? = nil) -> [CGFloat] {
        let lastIndex = index ?? items.count

        var array: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        for columnIndex in 0..<numberOfColumns {
            for rowIndex in 0..<lastIndex {
                array[columnIndex] += items[rowIndex][columnIndex].value
            }
        }
        return array
    }
}

// MARK: - Getting Index Position
extension Matrix {
    func getPosition(for itemIndex: Int) -> Position {
        guard let rowIndex = items.firstIndex(where: { $0.contains(where: { $0.index == itemIndex }) }),
              let columnIndex = items[rowIndex].firstIndex(where: { $0.index == itemIndex })
        else { return .init(row: 0, column: 0) }

        return .init(row: rowIndex, column: columnIndex)
    }
}

// MARK: - Getting Column Heights
extension Matrix {
    
}


// MARK: - Testing Helpers
extension Matrix {
    func getMatrix() -> [[Item]] { items }
}








private extension Matrix {
    var numberOfColumns: Int { items.first?.count ?? 0 }
}



enum MatrixInsertionPolicy { case ordered, fill }



extension Matrix { struct Item: Equatable {
    var index: Int
    var value: CGFloat
}}
extension Matrix.Item {
    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.index == rhs.index }
}
extension Matrix.Item {
    var isEmpty: Bool { value == 0 }
}




extension Matrix { struct Position {
    var row: Int
    var column: Int
}}



// MARK: - Helpers
fileprivate extension [[Matrix.Item]] {
    init(numberOfColumns: Int) { self = [.init(repeating: .init(index: -1, value: 0), count: numberOfColumns)] }
    mutating func insertEmptyRow(numberOfColumns: Int) { append(.init(repeating: .init(index: -1, value: 0), count: numberOfColumns)) }
}
