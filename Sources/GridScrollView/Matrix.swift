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

    init(columns: Int, policy: MatrixInsertionPolicy) { items = [.init(repeating: .init(value: 0), count: columns)]; itemsOld = [.init(repeating: 0, count: columns)]; self.policy = policy }
}

// MARK: - Inserting Items
extension Matrix {
    mutating func insert(_ item: Item) { if canItemBeInserted(item) {
        let position = findPositionForItem(item)

        addNewRowIfNeeded(position)
        insertItem(item, position)
    }}




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
}
private extension Matrix {
    func canItemBeInserted(_ item: Item) -> Bool { !items.flatMap { $0 }.contains(item) }
    func findPositionForItem(_ item: Item) -> Position {
        switch policy {
            case .ordered: return findPositionForOrderedPolicy()
            case .fill: return findPositionForFillPolicy()
        }
    }
    func addNewRowIfNeeded(_ position: Position) {

    }
    func insertItem(_ item: Item, _ position: Position) {

    }
}
private extension Matrix {
    func findPositionForOrderedPolicy() -> Position {
        fatalError()
    }
    func findPositionForFillPolicy() -> Position {
        fatalError()
    }
}










extension Matrix {
    func getMatrix() -> [[CGFloat]] { itemsOld }


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



    func printuj() {
        print("Matrix is:")
        for x in 0..<itemsOld.count {
            for y in 0..<itemsOld[0].count {
                print(itemsOld[x][y], terminator:" ")
            }
            print("\n")
        }
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
    var index: Int = -1
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
