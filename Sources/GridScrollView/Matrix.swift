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
    private var matrixInitialised: Bool = false


    init(columns: Int, itemsSpacing: CGFloat, policy: MatrixInsertionPolicy) { self.items = .init(numberOfColumns: columns); self.itemsSpacing = itemsSpacing; self.policy = policy }
}

// MARK: - Inserting Items
extension Matrix {
    mutating func insert(_ item: Item, isLast: Bool) { if !matrixInitialised {
        let position = findPositionForItem(item)
        let range = position.createItemRange(item)

        addNewRowIfNeeded(position)
        insertItem(item, range)
        sortMatrix(isLast)
    }}
}

// MARK: Finding Position
private extension Matrix {
    func findPositionForItem(_ item: Item) -> Position {
        guard item.index > 0 else { return .zero }

        let previousItemRangeEnd = getRange(for: item.index - 1).end
        return canInsertItemInRow(item, previousItemRangeEnd) ?
            previousItemRangeEnd.nextColumn() : previousItemRangeEnd.nextRow().withColumn(0)
    }
}
private extension Matrix {
    func canInsertItemInRow(_ item: Item, _ previousItemRangeEnd: Position) -> Bool { item.columns + previousItemRangeEnd.column < numberOfColumns }
}

// MARK: Inserting New Row
private extension Matrix {
    mutating func addNewRowIfNeeded(_ position: Position) { if position.row >= items.count {
        items.insertEmptyRow(numberOfColumns: numberOfColumns)
    }}
}

// MARK: Filling Array
private extension Matrix {
    mutating func insertItem(_ item: Item, _ range: Range) {
        let columnHeight = getHeights()

        fillInMatrixWithEmptySpaces(range, columnHeight)
        fillInMatrixWithItem(item, range)
    }
}
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

// MARK: Sorting Matrix
private extension Matrix {
    mutating func sortMatrix(_ isLastItem: Bool) { if policy == .fill && isLastItem {
        let items = getUniqueItems()
        let sortedItems = getSortedItems(items)


        var array: [[Item]] = []
        for item1 in sortedItems where !array.contains(item1) {
            var proposedRows = [[item1]]


            let remainingItems = getRemainingItems(array, sortedItems, item1)


            for item2 in remainingItems {
                if proposedRows.lastItem.columns + item2.columns <= numberOfColumns { proposedRows.lastItem.append(item2) }
                else { proposedRows.append([]) }
            }
            array.append(proposedRows.g())
        }

        self.items = .init(numberOfColumns: numberOfColumns)


        for row in 0..<array.count {
            for column in 0..<array[row].count {

                var columnA = 0

                for index in 0..<column {
                    columnA += array[row][index].columns
                }


                let position = Position(row: row, column: columnA)
                let item = array[row][column]
                let range = position.createItemRange(item)

                addNewRowIfNeeded(position)
                insertItem(item, range)
            }
        }


        matrixInitialised = true
    }}
}
private extension Matrix {
    func getUniqueItems() -> [Item] {
        let nonEmptyItems = items
            .flatMap { $0 }
            .filter { $0.index != -1 }
        let items = Array(Set(nonEmptyItems))
        return items
    }
    func getSortedItems(_ items: [Item]) -> [Item] {
        items.sorted(by: { $0.columns > $1.columns })
    }
    func getRemainingItems(_ results: [[Item]], _ items: [Item], _ item1: Item) -> [Item] {
        items
            .filter { $0.columns + item1.columns <= numberOfColumns }
            .filter { !results.contains($0) }
            .filter { item1 != $0 }
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
                let item = items[iteratorPosition]

                updateValueForCurrentPosition(iteratorPosition, item, &array)
                updateValuesForMultigridItem(iteratorPosition, item, &array)
            }
        }

        return array
    }
}
private extension Matrix {
    func updateValueForCurrentPosition(_ position: Position, _ item: Item, _ array: inout [[CGFloat]]) {
        let itemsSpacingValue = item.index == -1 ? 0 : itemsSpacing
        let currentValue = item.value + itemsSpacingValue
        let previousRowPositionValue = position.row > 0 ? array[position.previousRow()] : 0

        array[position] = currentValue + previousRowPositionValue
    }
    func updateValuesForMultigridItem(_ position: Position, _ item: Item, _ array: inout [[CGFloat]]) { if item.columns > 1 {
        let range = getStartPosition(for: item.index).createItemRange(item)

        guard range.end.column == position.column else { return }

        let maxValue = array[position.row][range.columns].max() ?? 0
        range.columns.forEach { array[position.row][$0] = maxValue }
    }}
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
fileprivate extension [[CGFloat]] {
    subscript(position: Matrix.Position) -> CGFloat {
        get { self[position.row][position.column] }
        set { self[position.row][position.column] = newValue }
    }
}






extension [[Matrix.Item]] {
    func contains(_ element: Matrix.Item) -> Bool {
        joined().contains(where: { $0.index == element.index })
    }



    var lastItem: [Matrix.Item] {
        get { last ?? [] }
        set { self[count - 1] = newValue }
    }


    func g() -> [Matrix.Item] {
        self.min(by: { $0.valueDiff() < $1.valueDiff() }) ?? []
    }


}
extension [Matrix.Item] {
    func valueDiff() -> CGFloat {
        let min = self.min(by: { $0.value < $1.value })?.value ?? 0
        let max = self.max(by: { $0.value > $1.value })?.value ?? 0

        return max - min
    }


    var columns: Int { reduce(0, { $0 + $1.columns }) }
}
