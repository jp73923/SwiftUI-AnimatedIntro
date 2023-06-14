//
//  PageIntro.swift
//  SwiftUI-AnimatedIntro
//
//  Created by macOS on 14/06/23.
//

import SwiftUI

// Page Intro Model
struct PageIntro: Identifiable, Hashable {
    var id: UUID = .init()
    var introAssetImage: String
    var title: String
    var subtitle: String
    var displaysAction:Bool = false
}

var pageIntros: [PageIntro] = [
    .init(introAssetImage: "Page 1"  , title: "World of AI", subtitle: "A realm of innovation, connectivity, diversity, and transformative advancements."),
    .init(introAssetImage: "Page 2"  , title: "Infinite of AI", subtitle: "Endless possibilities, intelligence, and potential unleashed through artificial intelligence."),
]
