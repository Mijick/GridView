//
//  GridView.swift of GridScrollView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public struct GridView: View {
    var horizontalSpacing: CGFloat = 8
    var elements: [AnyGridElement] = []
    @State private var matrix: Matrix = .init(columns: 4, itemsSpacing: 8, policy: .ordered)
    @State private var heights: [CGFloat] = []


    public init(_ data: Range<Int>, @ViewBuilder content: @escaping (Int) -> any GridElement) {
        elements = data.map { .init(content($0)) }
        _heights = .init(initialValue: .init(repeating: 0, count: data.upperBound))
    }
    public var body: some View { ScrollView(content: createContent) }
}

private extension GridView {
    func createContent() -> some View {
        GeometryReader { reader in
            ZStack(alignment: .topLeading) {
                ForEach(0..<elements.count, id: \.self) { createItem($0, reader) }
            }
        }
        .frame(height: calculateContentHeight())
    }
}
private extension GridView {
    func createItem(_ index: Int, _ reader: GeometryProxy) -> some View {
        elements[index]
            .readHeight { saveHeight($0, index) }
            .alignmentGuide(.top) { handleTopAlignmentGuide(index, $0, reader) }
            .alignmentGuide(.leading) { handleLeadingAlignmentGuide(index, $0, reader) }
            .frame(width: calculateItemWidth(index, reader.size.width), height: heights[index])
    }
}

// MARK: - Reading Height
private extension GridView {
    func saveHeight(_ value: CGFloat, _ index: Int) {
        heights[index] = value
    }
}

// MARK: - Vertical Alignment
private extension GridView {
    func handleTopAlignmentGuide(_ index: Int, _ dimensions: ViewDimensions, _ reader: GeometryProxy) -> CGFloat {
        insertItem(index, dimensions.height)

        let topPadding = getTopPaddingValue(index)
        return topPadding
    }
}
private extension GridView {
    func insertItem(_ index: Int, _ value: CGFloat) { DispatchQueue.main.async {
        let item = Matrix.Item(index: index, value: value, columns: elements[index].columns)
        matrix.insert(item)
    }}
    func getTopPaddingValue(_ index: Int) -> CGFloat {
        let range = matrix.getRange(for: index)

        guard range.start.row > 0 else { return 0 }

        let heights = matrix.getHeights()[range.start.row - 1]
        let itemTopPadding = heights[range.columns].max() ?? 0
        return -itemTopPadding
    }
}

// MARK: - Horizontal Alignment
private extension GridView {
    func handleLeadingAlignmentGuide(_ index: Int, _ dimensions: ViewDimensions, _ reader: GeometryProxy) -> CGFloat {
        let availableWidth = reader.size.width
        let itemPadding = calculateItemLeadingPadding(index, availableWidth)
        return itemPadding
    }
}
private extension GridView {
    func calculateItemLeadingPadding(_ index: Int, _ availableWidth: CGFloat) -> CGFloat {
        let columnNumber = matrix.getRange(for: index).start.column
        let singleColumnWidth = calculateSingleColumnWidth(availableWidth)

        let rawColumnsPaddingValue = singleColumnWidth * columnNumber.floatValue
        let rawSpacingPaddingValue = (columnNumber.floatValue - 1) * horizontalSpacing

        let rawPaddingValue = rawColumnsPaddingValue + rawSpacingPaddingValue
        return -rawPaddingValue
    }
}

// MARK: - Dimensions
private extension GridView {
    func calculateItemWidth(_ index: Int, _ availableWidth: CGFloat) -> CGFloat {
        let itemColumns = elements[index].columns
        let singleColumnWidth = calculateSingleColumnWidth(availableWidth)

        let fixedItemWidth = singleColumnWidth * itemColumns.floatValue
        let additionalHorizontalSpacing = (itemColumns.floatValue - 1) * horizontalSpacing
        return fixedItemWidth + additionalHorizontalSpacing
    }
    func calculateContentHeight() -> CGFloat { matrix.getHeights().flatMap { $0 }.max() ?? 0 }
}
private extension GridView {
    func calculateSingleColumnWidth(_ availableWidth: CGFloat) -> CGFloat {
        let totalSpacingValue = getHorizontalSpacingTotalValue()
        let itemsWidth = availableWidth - totalSpacingValue
        return itemsWidth / matrix.numberOfColumns.floatValue
    }
    func getHorizontalSpacingTotalValue() -> CGFloat {
        let numberOfSpaces = matrix.numberOfColumns - 1
        return numberOfSpaces.floatValue * horizontalSpacing
    }
}
