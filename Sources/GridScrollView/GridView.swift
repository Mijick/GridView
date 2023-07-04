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
    var verticalPadding: CGFloat = 8
    var horizontalPadding: CGFloat = 8
    var numberOfItems: Int = 24
    var numberOfColumns: Int = 3
    @State private var contentHeight: CGFloat = 0
    @State private var itemHeights: [Int: CGFloat] = [:]


    public init() {}
    public var body: some View {
        ScrollView {
            GeometryReader { reader in
                ZStack(alignment: .topLeading) {
                    ForEach(0..<numberOfItems, id: \.self) { index in
                        createItem(index, .random, .random(index))



                            .alignmentGuide(.top) { dimensions in
                                let itemHeight = dimensions.height
                                let itemsHeight = calculateItemsHeight(upTo: index)
                                let contentHeight = calculateContentHeight(upTo: index, itemsHeight)

                                updateItemHeights(index, itemHeight)
                                updateContentHeight(contentHeight, itemHeight)

                                return -contentHeight
                            }




                            .alignmentGuide(.leading) { d in




                                return calculateHorizontalSpacing(index, d, reader.size.width)
                            }





                            .frame(width: calculateItemWidth(reader.size.width))
                    }
                }
            }
            .padding(.horizontal, 28)
            .frame(height: contentHeight)
        }
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
        let paddingValue = getVerticalPaddingValue(index)
        return paddingValue + itemsHeight
    }
}
private extension GridView {
    func getVerticalPaddingValue(_ index: Int) -> CGFloat {
        let rowNumber = getRowNumber(index).floatValue
        return rowNumber * verticalPadding
    }
    func getRowNumber(_ index: Int) -> Int { index / numberOfColumns }
}

// MARK: - Horizontal Values
private extension GridView {
    func calculateItemWidth(_ screenWidth: CGFloat) -> CGFloat {
        let numberOfColumns = CGFloat(numberOfColumns)
        let b = (numberOfColumns - 1) * horizontalPadding
        let a = (screenWidth - b) / numberOfColumns
        return a
    }

    func calculateHorizontalSpacing(_ index: Int, _ viewDimension: ViewDimensions, _ screenWidth: CGFloat) -> CGFloat {
        let leadingValue = viewDimension[HorizontalAlignment.leading]
        let a = CGFloat(index % numberOfColumns)


        return leadingValue - a * (calculateItemWidth(screenWidth) + horizontalPadding)
    }
}

private extension GridView {

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
