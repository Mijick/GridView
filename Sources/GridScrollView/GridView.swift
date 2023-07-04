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

    @State var maxu: CGFloat = 0


    public init() {}
    public var body: some View {
        var height: [Int: CGFloat] = [:]



        ScrollView {
            GeometryReader { reader in
                ZStack(alignment: .topLeading) {
                    ForEach(0..<numberOfItems, id: \.self) { index in
                        aaaa(index)

                            .alignmentGuide(.top) { d in
                                height.updateValue(d.height, forKey: index)


                                DispatchQueue.main.async { maxu = max(
                                    maxu,
                                    abs(d[VerticalAlignment.top] - calculateUpToIndex(height, index)) + d.height
                                ) }



                                return d[VerticalAlignment.top] - calculateUpToIndex(height, index) - CGFloat(index / numberOfColumns) * verticalPadding
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
            .frame(height: maxu)
        }
    }
}

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

private extension GridView {

}




private extension GridView {
    func aaaa(_ index: Int) -> some View {
        Rectangle()
            .fill(Color(.init(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)))
            .frame(height: [100, 200, 100][index % 3 == 0 ? 0 : index % 3 == 1 ? 1 : 2])
            .frame(maxWidth: .infinity)
            .border(Color.red)
            .overlay(Text("\(index)"))
    }
}
