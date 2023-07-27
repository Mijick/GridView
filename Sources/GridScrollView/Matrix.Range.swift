//
//  Matrix.Range.swift of GridScrollView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension Matrix { struct Range {
    let start: Position
    let end: Position

    init(from startPosition: Matrix.Position, to endPosition: Matrix.Position) {
        if startPosition > endPosition { fatalError("Start position must precede end position") }

        start = startPosition
        end = endPosition
    }
}}

// MARK: - Helpers
extension Matrix.Range {
    var rows: ClosedRange<Int> { start.row...end.row }
    var columns: ClosedRange<Int> { start.column...end.column }
}
