//
//  Matrix.Range.swift of MijickGridView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension Matrix { struct Range {
    var start: Position
    var end: Position

    init(from startPosition: Matrix.Position, to endPosition: Matrix.Position) {
        if startPosition > endPosition { fatalError("Start position must precede end position") }

        start = startPosition
        end = endPosition
    }
}}

extension Matrix.Range {
    func updating(newStart: Matrix.Position) -> Matrix.Range {
        let endIndexOffset = newStart.column + columns.count - 1

        var range = self
        range.start = newStart
        range.end = newStart.withColumn(endIndexOffset)
        return range
    }
}

// MARK: - Helpers
extension Matrix.Range {
    var rows: ClosedRange<Int> { start.row...end.row }
    var columns: ClosedRange<Int> { start.column...end.column }
}
