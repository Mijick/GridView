//
//  Matrix.Item.swift of GridScrollView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension Matrix { struct Item: Equatable {
    var index: Int
    var value: CGFloat
    var columns: Int
}}
extension Matrix.Item {
    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.index == rhs.index }
}
extension Matrix.Item {
    var isEmpty: Bool { value == 0 }
}


// MARK: - Array
extension [[Matrix.Item]] {
    subscript(_ position: Matrix.Position) -> Matrix.Item {
        get { self[position.row][position.column] }
        set { self[position.row][position.column] = newValue }
    }
}
