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

final class Matrix_Test: XCTestCase {}

// MARK: - Inserting
extension Matrix_Test {
    func testInsertValue_WhenMatrixIsEmpty() {
        var matrix = Matrix(columns: 3, itemsSpacing: 8, policy: .fill)
        matrix.insert(.init(index: 0, value: 100))

        let result: [[CGFloat]] = matrix.items.toValues()
        let expectedResult: [[CGFloat]] = [[100, 0, 0]]

        XCTAssertEqual(result, expectedResult)
    }
    func testInsertValue_WhenItemWithIndexIsPresent_ShouldNotInsertItem() {

    }
    func testInsertValue_WhenMatrixHasOneItem_ShouldNotAddNewRow() {


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
