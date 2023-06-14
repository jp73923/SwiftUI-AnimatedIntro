//
//  Home.swift
//  SwiftUI-AnimatedIntro
//
//  Created by macOS on 14/06/23.
//

import SwiftUI

struct Home: View {
    // View Properties
    @State private var actionIntro: PageIntro = pageIntros[0]
    var body: some View {
        GeometryReader {
            IntroView(intro: $actionIntro, size: $0.size) {
                
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Intro View
struct IntroView<ActionView: View>: View {
    @Binding var intro: PageIntro
    var size: CGSize
    var actionView: ActionView
    
    init(intro: Binding<PageIntro>, size: CGSize, @ViewBuilder actionView: @escaping () -> ActionView) {
        self._intro = intro
        self.size = size
        self.actionView = actionView()
    }
    
    // Animation Properites
    @State private var showView: Bool = false
    @State private var hideWholeView: Bool = false

    var body: some View {
        VStack {
            // Image View
            GeometryReader {
                let size = $0.size
                
                Image(intro.introAssetImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width,height: size.height + 50)
            }
            .offset(y: showView ? 0 : -size.height / 2)
            .opacity(showView ? 1 : 0)
            
            
            // Title & Action's
            VStack(alignment: .leading, spacing: 5) {
                Spacer(minLength: 0)
                
                Text(intro.title)
                    .font(.largeTitle)
                    .bold()
                    .fontWidth(.standard)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(15)

                Text(intro.subtitle)
                    .font(.title2)
                    .font(Font.title.weight(.semibold))
                    .fontWidth(.standard)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(15)

                if !intro.displaysAction {
                    Group {
                        Spacer(minLength: 25)
                        
                        // Custom Indicator View
                        CustomIndicatorView(totalPages: filteredPages.count, currentPage: filteredPages.firstIndex(of: intro) ?? 0)
                            .frame(maxWidth: .infinity)
                        
                        Spacer(minLength: 10)
                        
                        Button {
                            if let index = pageIntros.firstIndex(of: intro) {
                                if index == 1 {
                                    // Code here of get started action
                                } else {
                                    changeIntro()
                                }
                            }
                        } label: {
                            Text(intro != pageIntros.first ? "Get Started" : "Next")
                                .font(.system(size: 20))
                                .fontWidth(.standard)
                                .foregroundColor(.black)
                                .frame(width: size.width * 0.4)
                                .padding(.vertical,15)
                                .background {
                                    Capsule()
                                        .fill(.white)
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    //Action View
                    actionView
                        .offset(y: showView ? 0 : size.height / 2)
                        .opacity(showView ? 1 : 0)
                }
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            
            //Moving Down
            .offset(y: showView ? 0 : -size.height  / 2)
            .opacity(showView ? 1 : 0)
        }
        .offset(y: hideWholeView ? size.height / 2 : 0)
        .opacity(hideWholeView ? 0 : 1)

        //Back button
        .overlay(alignment: .topLeading) {
            // Hide In first page
            if intro != pageIntros.first {
                Button {
                    changeIntro(true)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWidth(.compressed)
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                }
                .padding(10)
                
                // Animation Back
                .offset(y: showView ? 0 : -200)
                
                // Hides when go back
                .offset(y: hideWholeView ? -200 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8).delay(0.1)) {
                showView = true
            }
        }
    }
    
    //Updating Page Intro's
    func changeIntro(_ isPrevious:Bool = false) {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0)) {
            hideWholeView = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Updating Page
            if let index = pageIntros.firstIndex(of: intro), (isPrevious ? index != 0 : index != pageIntros.count - 1) {
                intro = isPrevious ? pageIntros[index - 1] : pageIntros[index + 1]
            } else {
                intro = isPrevious ? pageIntros[0] : pageIntros[pageIntros.count - 1]
            }
            
            // Re-Animating as Split Page
            hideWholeView = false
            showView = false
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0)) {
                showView = true
            }
        }
    }
    
    var filteredPages: [PageIntro] {
        return pageIntros.filter { !$0.displaysAction }
    }
}
