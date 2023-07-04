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

                            .alignmentGuide(.top) { d in
                                updateItemHeights(index, d.height)


                                DispatchQueue.main.async { contentHeight = max(
                                    contentHeight,
                                    abs(d[VerticalAlignment.top] - calculateUpToIndex(itemHeights, index)) + d.height
                                ) }



                                return d[VerticalAlignment.top] - calculateUpToIndex(itemHeights, index) - CGFloat(index / numberOfColumns) * verticalPadding
                            }
                            .alignmentGuide(.leading) { d in




                                return calculateHorizontalSpacing(index, d, reader.size.width)
                            }





                            .frame(width: calculateItemWidth(reader.size.width))
                    }
                }
            }
            .padding(.horizontal, 28)

            // trzeba dodać verticalPadding
            .frame(height: contentHeight)
        }
    }
}

private extension GridView {
    func updateItemHeights(_ index: Int, _ height: CGFloat) { DispatchQueue.main.async {
        itemHeights.updateValue(height, forKey: index)
    }}
    func updateContentHeight(_ index: Int) { DispatchQueue.main.async {




    }}
}

private extension GridView {
    func getRowNumber(_ index: Int) -> Int { index / numberOfColumns }
    func getVerticalPaddingValue(_ index: Int) -> CGFloat {
        let rowNumber = getRowNumber(index).floatValue
        return rowNumber * verticalPadding
    }





    //func updateContentHeight(_)








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





    func calculateUpToIndex(_ array: [Int: CGFloat], _ index: Int) -> CGFloat {
        let filteredItems = array.filter { $0.key < index }
        return filteredItems.reduce(0) {
            let value = (index - $1.key) % numberOfColumns == 0 ? $1.value : 0
            return $0 + value
        }
    }
}

private extension GridView {

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
