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
    @State private var itemHeights: [Int: CGFloat] = [:]
    @State private var contentHeight: CGFloat = 0


    public init() {}
    public var body: some View {
        ScrollView {
            GeometryReader { reader in
                ZStack(alignment: .topLeading) {
                    ForEach(0..<numberOfItems, id: \.self) { index in
                        createItem(index, .random, .random(index))
                            .alignmentGuide(.top) { handleTopAlignmentGuide(index, $0, reader) }
                            .alignmentGuide(.leading) { handleLeadingAlignmentGuide(index, $0, reader) }
                            .frame(width: calculateItemWidth(reader.size.width))
                    }
                }
            }
            .padding(.horizontal, 28)
            .frame(height: contentHeight)
        }
    }
}

// MARK: - Alignment Guides
private extension GridView {
    func handleTopAlignmentGuide(_ index: Int, _ dimensions: ViewDimensions, _ reader: GeometryProxy) -> CGFloat {
        let itemHeight = dimensions.height
        let itemsHeight = calculateItemsHeight(upTo: index)
        let contentHeight = calculateContentHeight(upTo: index, itemsHeight)

        updateItemHeights(index, itemHeight)
        updateContentHeight(contentHeight, itemHeight)

        return -contentHeight
    }
    func handleLeadingAlignmentGuide(_ index: Int, _ dimensions: ViewDimensions, _ reader: GeometryProxy) -> CGFloat {
        let availableWidth = reader.size.width
        let itemPadding = calculateItemLeadingPadding(index, availableWidth)
        return itemPadding
    }
}

// MARK: - Vertical Values
private extension GridView {
    func updateItemHeights(_ index: Int, _ itemHeight: CGFloat) { DispatchQueue.main.async {
        itemHeights.updateValue(itemHeight, forKey: index)
    }}
    func updateContentHeight(_ currentHeight: CGFloat, _ itemHeight: CGFloat) { DispatchQueue.main.async {
        contentHeight = max(contentHeight, currentHeight + itemHeight)
    }}
}
private extension GridView {
    func calculateItemsHeight(upTo index: Int) -> CGFloat {
        itemHeights
            .filter { $0.key < index }
            .filter { (index - $0.key) % numberOfColumns == 0 }
            .reduce(0) { $0 + $1.value }
    }
    func calculateContentHeight(upTo index: Int, _ itemsHeight: CGFloat) -> CGFloat {
        let spacingValue = getVerticalSpacingValue(index)
        return spacingValue + itemsHeight
    }
}
private extension GridView {
    func getVerticalSpacingValue(_ index: Int) -> CGFloat {
        let rowNumber = getRowNumber(index).floatValue
        return rowNumber * verticalSpacing
    }
    func getRowNumber(_ index: Int) -> Int { index / numberOfColumns }
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

private extension GridView {

}








fileprivate extension Color {
    static let random: Color = .init(.init(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1))
}
fileprivate extension CGFloat {
    static func random(_ index: Int) -> CGFloat { [100, 200, 100][index % 3 == 0 ? 0 : index % 3 == 1 ? 1 : 2] }
}













private extension GridView {
    func createScrollView() -> some View {
        ScrollView(content: createContent)
    }
}

private extension GridView {
    func createContent() -> some View { GeometryReader { reader in
        ZStack(alignment: .topLeading) {
            //ForEach(0..<numberOfItems, id: \.self)
        }
    }}
}

private extension GridView {
    func createItem(_ index: Int, _ contentSize: CGSize) {

    }

}









private extension GridView {
    func createItem(_ index: Int, _ color: Color, _ height: CGFloat) -> some View {
        Rectangle()
            .fill(color)
            .frame(height: height).frame(maxWidth: .infinity)
            .overlay(Text("\(index)"))
    }
}





extension Int {
    var doubleValue: Double { Double(self) }
    var floatValue: CGFloat { CGFloat(self) }
}
