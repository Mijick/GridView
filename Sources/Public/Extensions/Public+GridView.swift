//
//  Public+GridView.swift of MijickGridView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Initialisers
extension GridView {
    public init<Data: RandomAccessCollection, ID: Hashable>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> any View, configBuilder: (Config) -> Config) { self.init(
        matrix: .init(configBuilder(.init())),
        elements: data.map { .init(content($0)) },
        config: configBuilder(.init())
    )}
}
