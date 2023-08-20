//
//  Public+View.swift of MijickGridView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public extension View {
    func columns(_ value: Int) -> some GridElement { AnyGridElement(self, numberOfColumns: value) }
}
