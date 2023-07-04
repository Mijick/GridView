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
    var sorting: Sorting = .ordered
    @State private var itemHeights: [Int: CGFloat] = [:]
    @State private var contentHeight: CGFloat = 0




    @State private var heightMatrix: Matrix = .init(columns: 3)





    public init() {}
    public var body: some View { ScrollView(content: createContent) }
}

private extension GridView {
    func createContent() -> some View {
        GeometryReader { reader in
            ZStack(alignment: .topLeading) {
                ForEach(0..<numberOfItems, id: \.self) { createItem($0, reader) }
            }
        }.frame(height: contentHeight)
    }
}
private extension GridView {
    func createItem(_ index: Int, _ reader: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color.random)
            .overlay(Text("\(index)"))
            .frame(height: .random(index))





            .frame(maxWidth: .infinity)
            .alignmentGuide(.top) { handleTop(index, $0, reader) }
            .alignmentGuide(.leading) { handleLeadingAlignmentGuide(index, $0, reader) }
            .frame(width: calculateItemWidth(reader.size.width))
    }
}

// MARK: - Alignment Guides
private extension GridView {
    func handleTop(_ index: Int, _ dimensions: ViewDimensions, _ reader: GeometryProxy) -> CGFloat {
        let itemHeight = dimensions.height




        update(index, itemHeight)







        heightMatrix.printuj()




        return 0




    }
    func update(_ index: Int, _ itemHeight: CGFloat) { DispatchQueue.main.async {
        let min = heightMatrix.getColumnHeights().enumerated().min(by: { $0.element < $1.element })
        heightMatrix.insert(itemHeight, itemIndex: index, column: min?.offset ?? 0)
    }}


    func handleLeading(_ index: Int, _ dimensions: ViewDimensions, _ reader: GeometryProxy) -> CGFloat {



        return 0
    }








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








fileprivate extension Color {
    static let random: Color = .init(.init(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1))
}
fileprivate extension CGFloat {
    static func random(_ index: Int) -> CGFloat { [100, 200, 100][index % 3 == 0 ? 0 : index % 3 == 1 ? 1 : 2] }
}





enum Sorting { case ordered, fill }









struct Matrix {
    private var items: [[CGFloat]]
    private var usedIndexes: [Int] = []


    init(columns: Int) { items = [.init(repeating: 0, count: columns)] }
}
extension Matrix {
    mutating func insert(_ item: CGFloat, itemIndex: Int, column: Int) {
        guard !usedIndexes.contains(itemIndex) else { return }

        usedIndexes.append(itemIndex)

        if let index = items.firstIndex(where: { $0[column] == 0 }) {
            items[index][column] = item
            return
        }

        items.append(.init(repeating: 0, count: numberOfColumns))

        lastRow[column] = item

    }
}
extension Matrix {
    




    func getColumnHeights() -> [CGFloat] {
        var array: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

        for columnIndex in 0..<numberOfColumns {
            for rowIndex in 0..<items.count {
                array[columnIndex] += items[rowIndex][columnIndex]
            }
        }

        return array
    }


    func printuj() {
        print("Matrix is:")
        for x in 0..<items.count {
            for y in 0..<items[0].count {
                print(items[x][y], terminator:" ")
            }
            print("\n")
        }
    }
}

private extension Matrix {
    var numberOfColumns: Int { items.first?.count ?? 0 }



    var lastRow: [CGFloat] {
        get { items.last ?? [] }
        set { items[items.count - 1] = newValue }
    }
}
