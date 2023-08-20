//
//  Array++.swift of GridView
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
