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
    var verticalSpacing: CGFloat = 8
    var horizontalSpacing: CGFloat = 8
    var elements: [AnyGridElement] = []
    @State private var matrix: Matrix = .init(columns: 3, itemsSpacing: 8, policy: .ordered)


    public init(_ data: Range<Int>, @ViewBuilder content: @escaping (Int) -> any GridElement) {
        data.forEach { elements.append(.init(content($0))) }
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
            .frame(maxWidth: .infinity)
            .alignmentGuide(.top) { handleTopAlignmentGuide(index, $0, reader) }
            .alignmentGuide(.leading) { handleLeadingAlignmentGuide(index, $0, reader) }
            .frame(width: calculateItemWidth(index, reader.size.width))
    }
}

// MARK: - Alignment Guides
private extension GridView {
    func handleTopAlignmentGuide(_ index: Int, _ dimensions: ViewDimensions, _ reader: GeometryProxy) -> CGFloat {
        insertItem(index, dimensions.height)

        let position = matrix.getPosition(for: index)
        let topPadding = -matrix.getColumnsHeight(upToRow: position.row)[position.column]
        return topPadding
    }
    func handleLeadingAlignmentGuide(_ index: Int, _ dimensions: ViewDimensions, _ reader: GeometryProxy) -> CGFloat {
        let availableWidth = reader.size.width
        let itemPadding = calculateItemLeadingPadding(index, availableWidth)
        return itemPadding
    }
}

// MARK: - Vertical Values
private extension GridView {
    func insertItem(_ index: Int, _ value: CGFloat) { DispatchQueue.main.async {
        let item = Matrix.Item(index: index, value: value, columns: elements[index].columns)
        matrix.insert(item)
    }}
}

// MARK: - Horizontal Values
private extension GridView {
    func calculateItemWidth(_ index: Int, _ availableWidth: CGFloat) -> CGFloat {
        let itemColumns = elements[index].columns
        let singleColumnWidth = calculateSingleColumnWidth(availableWidth)

        let fixedItemWidth = singleColumnWidth * itemColumns.floatValue
        let additionalHorizontalSpacing = (itemColumns.floatValue - 1) * horizontalSpacing
        return fixedItemWidth + additionalHorizontalSpacing
    }
    func calculateItemLeadingPadding(_ index: Int, _ availableWidth: CGFloat) -> CGFloat {
        let columnNumber = matrix.getPosition(for: index).column
        let singleColumnWidth = calculateSingleColumnWidth(availableWidth)

        let rawColumnsPaddingValue = singleColumnWidth * columnNumber.floatValue
        let rawSpacingPaddingValue = (columnNumber.floatValue - 1) * horizontalSpacing

        let rawPaddingValue = rawColumnsPaddingValue + rawSpacingPaddingValue
        return -rawPaddingValue
    }
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

// MARK: - Calculating Content Height
private extension GridView {
    func calculateContentHeight() -> CGFloat { matrix.getColumnsHeight().max() ?? 0 }
}
