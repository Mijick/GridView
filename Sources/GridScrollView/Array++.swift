//
//  Array++.swift of GridScrollView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Removing Duplicates
extension Array where Element: Hashable {
    func removingDuplicates() -> Self { Array(Set(self)) }
}

// MARK: - Testing Helpers
extension [[CGFloat]] {
    func print() {
        Swift.print("\n\n")

        for row in 0..<count {
            var text = ""
            for column in 0..<self[row].count {
                text += "\(self[row][column])  "

            }
            Swift.print(text)
        }

        Swift.print("\n\n")
    }
}
