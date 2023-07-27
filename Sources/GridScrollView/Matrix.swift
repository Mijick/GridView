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
        let range = position.createItemRange(item)

        addNewRowIfNeeded(position)
        insertItem(item, range)
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
    mutating func insertItem(_ item: Item, _ range: Range) {
        let columnHeight = getHeights()

        fillInMatrixWithEmptySpaces(range, columnHeight)
        fillInMatrixWithItem(item, range)
    }
}
// MARK: Filling Array
private extension Matrix {
    mutating func fillInMatrixWithEmptySpaces(_ range: Range, _ columnHeights: [[CGFloat]]) { if range.start.row > 0 {
        range.columns.forEach { column in
            let currentPosition = range.start.withColumn(column), previousPosition = currentPosition.previousRow()
            let difference = columnHeights[currentPosition] - columnHeights[previousPosition]

            if shouldFillInEmptySpace(difference, items[previousPosition]) {
                items[previousPosition] = .init(index: -1, value: difference, columns: 1)
            }
        }
    }}
    mutating func fillInMatrixWithItem(_ item: Item, _ range: Range) { range.columns.forEach { column in
        items[range.start.withColumn(column)] = item
    }}
}
private extension Matrix {
    func shouldFillInEmptySpace(_ difference: CGFloat, _ item: Item) -> Bool { difference > 0 && item.isEmpty }
}
// MARK: Finding Positions
private extension Matrix {
    func findPositionForOrderedPolicy(_ item: Item) -> Position {
        guard item.index > 0 else { return .zero }

        let previousItemRangeEnd = getRange(for: item.index - 1).end
        return canInsertItemInRow(item, previousItemRangeEnd) ?
            previousItemRangeEnd.nextColumn() : previousItemRangeEnd.nextRow().withColumn(0)
    }
    func canInsertItemInRow(_ item: Item, _ previousItemRangeEnd: Position) -> Bool { item.columns + previousItemRangeEnd.column < numberOfColumns }
}
private extension Matrix {
    func findPositionForFillPolicy(_ item: Item) -> Position {
        let columnsHeight = getHeights()[items.count - 1]

        let columnIndex = columnsHeight.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
        let rowIndex = items.firstIndex(where: { $0[columnIndex].isEmpty }) ?? items.count
        return .init(row: rowIndex, column: columnIndex)
    }
}

// MARK: - Getting Item Position
extension Matrix {
    func getRange(for index: Int) -> Range {
        let startPosition = getStartPosition(for: index)
        return startPosition.createItemRange(items[startPosition])
    }
}
private extension Matrix {
    func getStartPosition(for index: Int) -> Position {
        let rowIndex = items.firstIndex(where: { $0.contains(where: { $0.index == index }) }) ?? 0
        let columnIndex = items[rowIndex].firstIndex(where: { $0.index == index }) ?? 0
        return .init(row: rowIndex, column: columnIndex)
    }
}

// MARK: - Getting Column Heights
extension Matrix {
    func getHeights() -> [[CGFloat]] {
        var array: [[CGFloat]] = .init(repeating: .init(repeating: 0, count: numberOfColumns), count: items.count)

        for row in 0..<items.count {
            for column in 0..<numberOfColumns {
                let iteratorPosition = Position(row: row, column: column)

                // znajdź item, który leży na pozycji
                let item = items[iteratorPosition]
                let itemStartPosition = getStartPosition(for: item.index)
                let itemRange = itemStartPosition.createItemRange(item)
                let itemValue = getItemValue(itemStartPosition)




                // uaktualnij wysokość dla itema na danej pozycji
                let previousRowPositionValue = row > 0 ? array[iteratorPosition.previousRow()] : 0
                array[iteratorPosition] = previousRowPositionValue + itemValue



                // jeśli ostatnia kolumna danego przedmiotu, to uaktualnij wartość

                if itemRange.end.column == column {
                    let max = array[row][itemRange.columns].max() ?? 0
                    for columna in itemRange.columns {
                        array[row][columna] = max

                    }
                }


            }
        }

        array.print()



        return array
    }
}
private extension Matrix {
    func getItemValue(_ position: Position) -> CGFloat {
        let itemValue = items[position].value

        if items[position].index == -1 { return itemValue }




        return itemValue + itemsSpacing
    }
    func getEndItemColumn(_ row: Int) -> Int {
        let item = items[row][0]
        let startPosition = getStartPosition(for: item.index)
        let range = startPosition.createItemRange(item)
        return range.end.column
    }

}

// MARK: - Others
extension Matrix {
    var numberOfColumns: Int { items.first?.count ?? 0 }
}


// MARK: - Helpers
fileprivate extension [[Matrix.Item]] {
    init(numberOfColumns: Int) { self = [.empty(numberOfColumns)] }
    mutating func insertEmptyRow(numberOfColumns: Int) { append(.empty(numberOfColumns)) }
}
fileprivate extension [Matrix.Item] {
    static func empty(_ numberOfColumns: Int) -> Self { .init(repeating: .init(index: -1, value: 0, columns: 1), count: numberOfColumns) }
}





extension [[CGFloat]] {
    func print() {
        Swift.print("\n\nARRAY:")

        for row in 0..<count {
            var text = ""
            for column in 0..<self[row].count {
                text += "\(self[row][column])  "

            }
            Swift.print(text)
        }
    }



    subscript(position: Matrix.Position) -> CGFloat {
        get { self[position.row][position.column] }
        set { self[position.row][position.column] = newValue }
    }

}
