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
    private var aaa: Bool = false

    // weź liczbę przedmiotów
    init(columns: Int, itemsSpacing: CGFloat, policy: MatrixInsertionPolicy) { self.items = .init(numberOfColumns: columns); self.itemsSpacing = itemsSpacing; self.policy = policy }
}


extension [[Matrix.Item]] {
    func minimalHeight() -> [Matrix.Item] {
        self.min(by: { $0.valueDiff() < $1.valueDiff() }) ?? []


    }
    func contains(_ element: Matrix.Item) -> Bool {
        joined().contains(where: { $0.index == element.index })
    }

    func printujKurwa() {
        self.forEach { item in
            var uu = ""
            item.forEach { uu += " \($0.index)" }
            Swift.print(uu)
        }

        Swift.print("\n\n")
    }


}
extension [Matrix.Item] {
    func valueDiff() -> CGFloat {
        // różnica między min a max


        let min = self.min(by: { $0.value < $1.value })?.value ?? 0
        let max = self.max(by: { $0.value > $1.value })?.value ?? 0


        return max - min
    }
}


// MARK: - Inserting Items
extension Matrix {
    private mutating func a() {
        // tylko w przypadku a




        // wstaw wszystkie elementy do tablicy byle jak
        // weź tablicę
        // posortuj odpowiednio
        // włóż do tablicy
        // ustaw znacznik "skończone"

        //guard !aaa else { return }


        let items = getUniqueItems()


        var array: [[Item]] = []
        for item1 in items.reversed() {
            guard !array.contains(item1) else { continue }

            var localArray: [[Item]] = []
            var loca = [item1]

            for item2 in items {
                guard !array.contains(item2) else { continue }
                guard item1 != item2 else { continue }

                let sum = loca.reduce(0, { $0 + $1.columns })

                if sum + item2.columns <= numberOfColumns { loca.append(item2) }
                else { localArray.append(loca); loca = [] }
            }

            if !loca.isEmpty { localArray.append(loca) }



            array.append(localArray.minimalHeight())
        }


        //array.printujKurwa()



        self.items = .init(numberOfColumns: numberOfColumns)


        for row in 0..<array.count {
            for column in 0..<array[row].count {
                let addColumn = column > 0 ? array[row][column - 1].columns - 1 : 0


                let position = Position(row: row, column: column + addColumn)
                let item = array[position]
                let range = position.createItemRange(item)

                //print(position, item.index)


                addNewRowIfNeeded(position)
                insertItem(item, range)
            }
        }


        self.items.printujKurwa()


        aaa = true

        //array.printujKurwa()

        //self.items = array


    }

    func getUniqueItems() -> [Item] {
        let nonEmptyItems = items
            .flatMap { $0 }
            .filter { $0.index != -1 }
        let items = Array(Set(nonEmptyItems))

        let sortedItems = items.sorted(by: { $0.columns > $1.columns })
        return sortedItems
    }





    mutating func insert(_ item: Item, isLast: Bool) {
        // ma działać tylko raz


        guard !aaa else { return }



        let position = findPositionForItem(item)
        let range = position.createItemRange(item)

        








        addNewRowIfNeeded(position)
        insertItem(item, range)



        if isLast { a() }
    }
}
private extension Matrix {
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
