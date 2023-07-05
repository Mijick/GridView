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
        var matrix = Matrix(columns: 3, policy: .ordered)
        matrix.insert(.init(index: 0, value: 100))

        let result: [[Matrix.Item]] = matrix.getMatrix()
        let expectedResult: [[Matrix.Item]] = [[.init(index: 0, value: 100), .init(index: -1, value: 0), .init(index: -1, value: 0)]]

        XCTAssertEqual(result, expectedResult)
    }
    func testInsertValue_WhenItemWithIndexIsPresent_ShouldNotInsertItem() {

    }
    func testInsertValue_WhenMatrixIsNotEmpty_ShouldNotAddNewRow() {
        var matrix = Matrix(columns: 3, policy: .fill)

    }
    func testInsertValue_WhenMatrixIsNotEmpty_ShouldAddNewRow() {

    }
    func testInsertValue_WhenMatrixIsNotEmpty_ShouldUpdateValue() {

    }
}
