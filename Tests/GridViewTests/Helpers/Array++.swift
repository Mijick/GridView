//
//  Array++.swift of GridView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension [[CGFloat]] {
    func toString() -> String {
        var text = ""

        for row in 0..<count {
            for column in 0..<self[row].count {
                let value = Int(self[row][column])
                text += "\(value)  "
            }
            text += "\n"
        }

        text.removeLast(2)
        return text
    }
}
