//
//  GridElement.swift of GridView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol GridElement: View {
    var columns: Int { get }
}
public extension GridElement {
    var columns: Int { 1 }
}
