//
//  WelcomeView.swift
//  WhatCanICook
//
//  Created by Vadhthanak Vibol on 13/10/2023.
//


import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcomeView: Bool ///Boolean to see if the view is already shrink or not
    
    @State private var scale: CGFloat = 1.0 ///Original scale for the picture
    
    var body: some View {///Main welcome view body
        ZStack {
            Color.green.opacity(0.2).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Welcome to WhatCanICook")  ///The welcome message for the application
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center) ///Large title due to being the main title, with bold and black color for easy viewing and clearer title
                Image("WelcomeIcon") ///The image/logo of the whole application
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 20)) ///Make it the apple aesthetic logo style
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                Spacer()
                Button(action: { ///When clicking the button, the view will shrink and transition to the main screen
                    withAnimation(.easeInOut(duration: 0.5)) {
                        scale = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showWelcomeView = false
                    }
                }) {
                    Text("Get Started") ///Text displaying for the user to start the application
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .scaleEffect(scale)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(showWelcomeView: .constant(false))
    }
}
