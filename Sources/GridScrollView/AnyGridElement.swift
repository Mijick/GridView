//
//  AnyGridElement.swift of GridScrollView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct AnyGridElement: GridElement {
    let columns: Int
    private let _body: AnyView


    var body: some View { _body }
    init(_ element: some GridElement) {
        self.columns = element.columns
        self._body = AnyView(element)
    }
}
