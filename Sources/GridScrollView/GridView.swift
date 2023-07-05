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
    var numberOfItems: Int = 24
    var numberOfColumns: Int = 3
    var sorting: MatrixInsertionPolicy = .ordered
    @State private var itemHeights: [Int: CGFloat] = [:]
    @State private var contentHeight: CGFloat = 0




    @State private var heightMatrix: Matrix = .init(columns: 3, itemsSpacing: 8, policy: .fill)





    public init() {}
    public var body: some View { ScrollView(content: createContent) }
}

private extension GridView {
    func createContent() -> some View {
        GeometryReader { reader in
            ZStack(alignment: .topLeading) {
                ForEach(0..<numberOfItems, id: \.self) { createItem($0, reader) }
            }
        }.frame(height: calculateContentHeight())
    }
}
private extension GridView {
    func createItem(_ index: Int, _ reader: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color.random)
            .overlay(Text("\(index)"))
            .frame(height: .random(index))
            .border(Color.red)





            .frame(maxWidth: .infinity)
            .alignmentGuide(.top) { handleTopAlignmentGuide(index, $0, reader) }
            .alignmentGuide(.leading) { handleLeading(index, $0, reader) }
            .frame(width: calculateItemWidth(reader.size.width))
    }
}

// MARK: - Alignment Guides
private extension GridView {
    func handleTopAlignmentGuide(_ index: Int, _ dimensions: ViewDimensions, _ reader: GeometryProxy) -> CGFloat {
        let itemHeight = dimensions.height
        let item = Matrix.Item(index: index, value: itemHeight)

        DispatchQueue.main.async { heightMatrix.insert(item) }

        let position = heightMatrix.getPosition(for: index)


        return -heightMatrix.getColumnsHeight(upToRow: position.row)[position.column]

    }


    func handleLeading(_ index: Int, _ dimensions: ViewDimensions, _ reader: GeometryProxy) -> CGFloat {
        let availableWidth = reader.size.width
        let a = heightMatrix.getPosition(for: index).column.floatValue + 1

        let ab = calculateItemWidth(availableWidth)


        let spacing = horizontalSpacing * (a - 1)


        return -ab * a - spacing
    }


    func calculateContentHeight() -> CGFloat { heightMatrix.getColumnsHeight().max() ?? 0 }





    func handleLeadingAlignmentGuide(_ index: Int, _ dimensions: ViewDimensions, _ reader: GeometryProxy) -> CGFloat {
        let availableWidth = reader.size.width
        let itemPadding = calculateItemLeadingPadding(index, availableWidth)
        return itemPadding
    }
}

// MARK: - Horizontal Values
private extension GridView {
    func calculateItemWidth(_ availableWidth: CGFloat) -> CGFloat {
        let totalSpacingValue = getHorizontalSpacingTotalValue()
        let itemsWidth = availableWidth - totalSpacingValue
        return itemsWidth / numberOfColumns.floatValue
    }
    func calculateItemLeadingPadding(_ index: Int, _ availableWidth: CGFloat) -> CGFloat {
        let columnNumber = getColumnNumber(index)
        let itemWidth = calculateItemWidth(availableWidth)
        let totalWidth = itemWidth + horizontalSpacing
        return -columnNumber.floatValue * totalWidth
    }
}
private extension GridView {
    func getHorizontalSpacingTotalValue() -> CGFloat {
        let numberOfSpaces = numberOfColumns - 1
        return numberOfSpaces.floatValue * horizontalSpacing
    }
    func getColumnNumber(_ index: Int) -> Int { index % numberOfColumns }
}








fileprivate extension Color {
    static let random: Color = .init(.init(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1))
}
fileprivate extension CGFloat {
    static func random(_ index: Int) -> CGFloat { [100, 200, 100][index % 3 == 0 ? 0 : index % 3 == 1 ? 1 : 2] }
}






