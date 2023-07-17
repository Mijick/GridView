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

extension Matrix {
    func getRange(for position: Position) -> Range<Int> {
        let startColumn = getPosition(for: items[position].index).column
        let endColumn = startColumn + items[position].columns

        return startColumn..<endColumn
    }
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
        if position.row > 0 {
            for column in position.column..<position.column + item.columns {

                //if item.index == 14 { Swift.print(getColumnsHeight(upToRow: position.row)) }




                // tu jest jakiś problem z diff

                let heights = getHeights()


                let diff = (heights[position.row][column]) - (heights[position.row - 1][column]) - itemsSpacing * CGFloat(position.row)
                let position = Position(row: position.row - 1, column: column)
                if diff > 0 && items[position].isEmpty {
                    




                    items[position] = .init(index: -1, value: abs(diff), columns: 1)
                }
            }
        }

        for column in position.column..<position.column + item.columns {
            items[Position(row: position.row, column: column)] = item
        }
    }
}
private extension Matrix {
    func findPositionForOrderedPolicy(_ item: Item) -> Position {
        let index = item.index





        if index == 0 { return .init(row: 0, column: 0) }







        let previousPosition = getPosition(for: index - 1)
        let prevCOlumns = items[previousPosition].columns


        let previousColMax = previousPosition.column + prevCOlumns - 1


        if previousPosition.column + prevCOlumns + item.columns > numberOfColumns { return .init(row: previousPosition.row + 1, column: 0) }

        return .init(row: previousPosition.row, column: previousColMax + 1)
    }
    func findPositionForFillPolicy(_ item: Item) -> Position {
        let columnsHeight = getHeights()[items.count - 1]

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
    func getHeights() -> [[CGFloat]] {
        var array: [[CGFloat]] = .init(repeating: .init(repeating: 0, count: numberOfColumns), count: items.count)

        for rowIndex in 0..<items.count {
            for columnIndex in 0..<numberOfColumns {
                let item = items[rowIndex][columnIndex]
                let position = getPosition(for: item.index)

                let range = position.column..<position.column + item.columns // zmienić potem, bo nie będzie działąć
                let value = getItemValue(position)


                let previousVal = rowIndex > 0 ? array[rowIndex - 1][columnIndex] : 0


                

                array[rowIndex][columnIndex] = previousVal + value


                let max = array[rowIndex][range].max() ?? 0

                //if item.columns > 1 && colu

                if position.column + (item.columns - 1) == columnIndex && item.columns > 1 {
                    for columna in Swift.max(position.column, columnIndex - item.columns - 1)...columnIndex {
                        array[rowIndex][columna] = max

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
}
