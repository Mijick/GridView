//
//  AnyGridElement.swift of MijickGridView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct AnyGridElement: GridElement {
    @State var height: CGFloat? = nil
    let columns: Int
    private let _body: AnyView


    var body: some View { _body }
    init(_ element: some View, numberOfColumns: Int? = nil) {
        self.columns = Self.getNumberOfColumns(element, numberOfColumns)
        self._body = AnyView(element)
    }
}
private extension AnyGridElement {
    static func getNumberOfColumns(_ element: some View, _ numberOfColumns: Int?) -> Int {
        if let element = element as? any GridElement { return element.columns }
        return numberOfColumns ?? 1
    }
}
