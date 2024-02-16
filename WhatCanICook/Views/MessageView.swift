//
//  MessageView.swift
//  ChatGPTChat
//
//  Created by LiamRMIT on 26/9/2023.
//

import SwiftUI

struct MessageView: View {
    var message: ChatMessage
    
    var body: some View {
        HStack{
            if message.sender == .user{Spacer()}
            Text(message.content)
                .foregroundColor(message.sender == .user ? .white : nil)
                .padding()
                .background(message.sender == .user ? .blue : .gray.opacity(0.4))
                .cornerRadius(24)
            if message.sender == .system{Spacer()}
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static let userMessage = ChatMessage(id: "1", content: "Hi what is your name?", createdAt: Date.now, sender: .user)
    static let systemMessage = ChatMessage(id: "2", content: "Hello, I am ChatGPT.", createdAt: Date.now, sender: .system)
    
    static var previews: some View {
        MessageView(message: userMessage)
            .previewDisplayName("User Message")
        MessageView(message: systemMessage)
            .previewDisplayName("System Message")
    }
}
