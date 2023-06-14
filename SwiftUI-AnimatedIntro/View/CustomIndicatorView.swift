//
//  CustomIndicatorView.swift
//  SwiftUI-AnimatedIntro
//
//  Created by macOS on 14/06/23.
//

import SwiftUI

struct CustomIndicatorView: View {
    //View Properties
    var totalPages: Int
    var currentPage: Int
    var activeTint: Color = .white
    var inActiveTint: Color = .gray.opacity(0.5)
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) {
                Circle()
                    .fill(currentPage == $0 ? activeTint : inActiveTint)
                    .frame(width: 10,height: 10)
            }
        }
    }
}

struct CustomIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
