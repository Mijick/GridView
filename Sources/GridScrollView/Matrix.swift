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
    private var items: [[CGFloat]]
    private var indexes: [Int: (row: Int, column: Int)] = [:]


    init(columns: Int) { items = [.init(repeating: 0, count: columns)] }
}
extension Matrix {
    mutating func insert(_ item: CGFloat, itemIndex: Int, column: Int) {
        guard indexes[itemIndex] == nil else { return }

        if let index = items.firstIndex(where: { $0[column] == 0 }) {
            indexes.updateValue((index, column), forKey: itemIndex)
            items[index][column] = item
            return
        }

        items.append(.init(repeating: 0, count: numberOfColumns))

        indexes.updateValue((items.count - 1, column), forKey: itemIndex)
        lastRow[column] = item

    }
}
extension Matrix {
    func getPosition(_ index: Int) -> (row: Int, column: Int) { indexes[index] ?? (0, 0) }




    func getColumnHeights() -> [CGFloat] {
        var array: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

        for columnIndex in 0..<numberOfColumns {
            for rowIndex in 0..<items.count {
                array[columnIndex] += items[rowIndex][columnIndex]
            }
        }

        return array
    }

    func getMaxHeightRow() -> Int {
        let column = getColumnHeights().enumerated().max(by: { $0.element > $1.element })?.offset ?? 0


        let row = items.lastIndex(where: { $0[column] == 0 }) ?? items.count




        return max(0, row - 1)
    }


    func getColumnHeight(upTo row: Int, column: Int) -> CGFloat {
        var uuu = 0.0

        for index in 0..<row {
            let a = items[index][column]
            uuu += a
        }


        return uuu
    }



    func printuj() {
        print("Matrix is:")
        for x in 0..<items.count {
            for y in 0..<items[0].count {
                print(items[x][y], terminator:" ")
            }
            print("\n")
        }
    }
}

private extension Matrix {
    var numberOfColumns: Int { items.first?.count ?? 0 }



    var lastRow: [CGFloat] {
        get { items.last ?? [] }
        set { items[items.count - 1] = newValue }
    }
}
