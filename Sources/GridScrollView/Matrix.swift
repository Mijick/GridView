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
    private(set) var items: [[Item]]
    private let policy: MatrixInsertionPolicy
    private let itemsSpacing: CGFloat

    init(columns: Int, itemsSpacing: CGFloat, policy: MatrixInsertionPolicy) { self.items = .init(numberOfColumns: columns); self.itemsSpacing = itemsSpacing; self.policy = policy }
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
        items[position] = item
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
        let columnsHeight = getColumnsHeight()

        let columnIndex = columnsHeight.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
        let rowIndex = items.firstIndex(where: { $0[columnIndex].isEmpty }) ?? items.count
        return .init(row: rowIndex, column: columnIndex)
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
    func getColumnsHeight(upToRow index: Int? = nil) -> [CGFloat] {
        let lastIndex = index ?? items.count

        var array: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        for columnIndex in 0..<numberOfColumns {
            for rowIndex in 0..<lastIndex {
                array[columnIndex] += getItemValue(.init(row: rowIndex, column: columnIndex))
            }
        }
        return array
    }
}
private extension Matrix {
    func getItemValue(_ position: Position) -> CGFloat {
        let itemValue = items[position].value
        return itemValue + itemsSpacing
    }
}

// MARK: - Others
private extension Matrix {
    var numberOfColumns: Int { items.first?.count ?? 0 }
}


// MARK: - Helpers
fileprivate extension [[Matrix.Item]] {
    init(numberOfColumns: Int) { self = [.empty(numberOfColumns)] }
    mutating func insertEmptyRow(numberOfColumns: Int) { append(.empty(numberOfColumns)) }
}
fileprivate extension [Matrix.Item] {
    static func empty(_ numberOfColumns: Int) -> Self { .init(repeating: .init(index: -1, value: 0), count: numberOfColumns) }
}
