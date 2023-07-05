//
//  Matrix_Test.swift of GridScrollView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import XCTest
@testable import GridScrollView

final class Matrix_Test: XCTestCase {
    var matrix: Matrix = .init(columns: 4, itemsSpacing: 8, policy: .fill)
}

// MARK: - Inserting
extension Matrix_Test {
    func testInsertValue_WhenMatrixIsEmpty() {
        matrix.insert(.init(index: 0, value: 100))

        let result: [[CGFloat]] = matrix.items.map { $0.map(\.value) }
        let expectedResult: [[CGFloat]] = [[100, 0, 0, 0]]

        XCTAssertEqual(result, expectedResult)
    }
    func testInsertValue_WhenItemWithIndexIsPresent_ShouldNotInsertItem() {
        matrix.insert(.init(index: 0, value: 100))
        matrix.insert(.init(index: 0, value: 200))

        let result = matrix.items.flatMap { $0 }.filter { !$0.isEmpty }.count
        let expectedResult = 1

        XCTAssertEqual(result, expectedResult)
    }
    func testInsertValue_InsertManyItemsOfDifferentIndexes_ShouldInsertItems() {
        for index in 0..<5 { matrix.insert(.init(index: index, value: 100)) }

        let result = matrix.items.flatMap { $0 }.filter { !$0.isEmpty }.count
        let expectedResult = 5

        XCTAssertEqual(result, expectedResult)
    }
    func testInsertValue_InsertManyItemsOfDifferentIndexes_ShouldAddNewRow() {
        for index in 0..<5 { matrix.insert(.init(index: index, value: 100)) }

        let result = matrix.items.count
        let expectedResult = 2

        XCTAssertEqual(result, expectedResult)
    }
    func testInsertValue_WhenMatrixHasOneRowFilled_OrderedPolicy_ShouldMatchPattern() {
        matrix = .init(columns: 4, itemsSpacing: 8, policy: .ordered)
        for index in 0..<10 { matrix.insert(.init(index: index, value: entryValues[index])) }

        let result: [[CGFloat]] = matrix.items.map { $0.map { $0.value } }
        let expectedResult: [[CGFloat]] = [
            [100, 200, 50, 100],
            [150, 100, 50, 100],
            [100, 150, 0, 0]
        ]

        XCTAssertEqual(result, expectedResult)
    }
    func testInsertValue_WhenMatrixHasOneRowFilled_FillPolicy_ShouldMatchPattern() {
        for index in 0..<10 { matrix.insert(.init(index: index, value: entryValues[index])) }

        let result: [[CGFloat]] = matrix.items.map { $0.map { $0.value } }
        let expectedResult: [[CGFloat]] = [
            [100, 200, 50, 100],
            [100, 150, 150, 50],
            [100, 0, 0, 100]
        ]

        XCTAssertEqual(result, expectedResult)
    }
}

private extension Matrix_Test {
    var entryValues: [CGFloat] { [100, 200, 50, 100, 150, 100, 50, 100, 100, 150] }
}
