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



    private var itemsOld: [[CGFloat]]
    private var indexes: [Int: (row: Int, column: Int)] = [:]

    init(columns: Int, policy: MatrixInsertionPolicy) { items = .init(numberOfColumns: columns); itemsOld = [.init(repeating: 0, count: columns)]; self.policy = policy }
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

        let rowIndex = index / numberOfColumns
        let columnIndex = index % numberOfColumns
        return .init(row: rowIndex, column: columnIndex)
    }
    func findPositionForFillPolicy(_ item: Item) -> Position {
        fatalError()
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









extension Matrix {
    mutating func insert(_ item: CGFloat, itemIndex: Int, column: Int) {
        guard indexes[itemIndex] == nil else { return }

        if let index = itemsOld.firstIndex(where: { $0[column] == 0 }) {
            indexes.updateValue((index, column), forKey: itemIndex)
            itemsOld[index][column] = item
            return
        }

        itemsOld.append(.init(repeating: 0, count: numberOfColumns))

        indexes.updateValue((itemsOld.count - 1, column), forKey: itemIndex)
        lastRow[column] = item

    }



    func getPosition(_ index: Int) -> (row: Int, column: Int) { indexes[index] ?? (0, 0) }




    func getColumnHeights() -> [CGFloat] {
        var array: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

        for columnIndex in 0..<numberOfColumns {
            for rowIndex in 0..<itemsOld.count {
                array[columnIndex] += itemsOld[rowIndex][columnIndex]
            }
        }

        return array
    }

    func getMaxHeightRow() -> Int {
        let column = getColumnHeights().enumerated().max(by: { $0.element > $1.element })?.offset ?? 0


        let row = itemsOld.lastIndex(where: { $0[column] == 0 }) ?? itemsOld.count




        return max(0, row - 1)
    }


    func getColumnHeight(upTo row: Int, column: Int) -> CGFloat {
        var uuu = 0.0

        for index in 0..<row {
            let a = itemsOld[index][column]
            uuu += a
        }


        return uuu
    }
}

private extension Matrix {
    var numberOfColumns: Int { itemsOld.first?.count ?? 0 }



    var lastRow: [CGFloat] {
        get { itemsOld.last ?? [] }
        set { itemsOld[itemsOld.count - 1] = newValue }
    }
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
    var isEmpty: Bool { index == -1 }
}




extension Matrix { struct Position {
    var row: Int
    var column: Int
}}




extension [[Matrix.Item]] {
    init(numberOfColumns: Int) { self = [.init(repeating: .init(index: -1, value: 0), count: numberOfColumns)] }
    mutating func insertEmptyRow(numberOfColumns: Int) { append(.init(repeating: .init(index: -1, value: 0), count: numberOfColumns)) }
}
