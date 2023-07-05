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

        let result: [[CGFloat]] = matrix.items.toValues()
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
        for index in 0..<5 {
            matrix.insert(.init(index: index, value: 100))
        }

        let result = matrix.items.flatMap { $0 }.filter { !$0.isEmpty }.count
        let expectedResult = 5

        XCTAssertEqual(result, expectedResult)
    }
    func testInsertValue_InsertManyItemsOfDifferentIndexes_ShouldAddNewRow() {
        for index in 0..<5 {
            matrix.insert(.init(index: index, value: 100))
        }

        let result = matrix.items.count
        let expectedResult = 2

        XCTAssertEqual(result, expectedResult)
    }
    func testInsertValue_WhenMatrixHasOneRowFilled_OrderedPolicy_ShouldAddNewRow() {
        

    }
    func testInsertValue_WhenMatrixHasOneRowFilled_FillPolicy_ShouldAddNewRow() {

    }
    func testInsertValue_WhenMatrixIsNotEmpty_ShouldUpdateValue() {

    }
}

// MARK: - Calculating Column Height
extension Matrix_Test {

}


// MARK: - Helpers
fileprivate extension [[Matrix.Item]] {
    func toValues() -> [[CGFloat]] { map { $0.map(\.value) } }
}
