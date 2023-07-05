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
    override func setUpWithError() throws {

    }
    override func tearDownWithError() throws {

    }
}

// MARK: - Inserting
extension Matrix_Test {
    func testInsertValue_WhenMatrixIsEmpty() {
        var matrix = Matrix(columns: 3)
        matrix.insert(100, itemIndex: 0, column: 0)

        let result: [[CGFloat]] = matrix.getMatrix()
        let expectedResult: [[CGFloat]] = [[100, 0, 0]]

        XCTAssertEqual(result, expectedResult)
    }
    func testInsertValue_WhenItemWithIndexIsPresent_ShouldNotInsertItem() {

    }
    func testInsertValue_WhenMatrixIsNotEmpty_ShouldNotAddNewRow() {
        var matrix = Matrix(columns: 3)

    }
    func testInsertValue_WhenMatrixIsNotEmpty_ShouldAddNewRow() {

    }
    func testInsertValue_WhenMatrixIsNotEmpty_ShouldUpdateValue() {

    }
}
