import Foundation

/// A structure representing a chat message.
struct ChatMessage {
    /// unique identifier of the message.
    let id: String
    
    /// Message content
    let content: String
    
    /// Date of request
    let createdAt: Date
    
    /// The sender of the message (user or system).
    let sender: MessageSender
}

/// Enum representing the sender of a message.
enum MessageSender {
    case user
    case system
}

/// Struct representing the body of a chat request to OpenAI.
struct OpenAIChatBody: Encodable {
    /// Chat model I.E ChatGPT 3.5
    let model: String
    
    /// The list of messages in the chat.
    let messages: [Message]
}

/// Struct representing the result of a chat request to OpenAI.
struct OpenAIResult: Codable {
    /// The unique identifier of the result.
    let id, object: String
    
    /// The timestamp when the result was created.
    let created: Int
    
    /// The name of the model used for the chat.
    let model: String
    
    /// The list of choices made in the chat.
    let choices: [Choice]
    
    /// Usage information about the chat.
    let usage: Usage
}

/// Struct representing a choice made in the chat.
struct Choice: Codable {
    /// The index of the choice.
    let index: Int
    
    /// The message content of the choice.
    let message: Message
    
    /// The reason the choice was finished.
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

/// Struct representing a message in the chat.
struct Message: Codable {
    /// The role of the message (e.g., 'system' or 'user').
    let role, content: String
}

/// Structrepresenting usage information about the chat.
struct Usage: Codable {
    /// The number of tokens used for the prompt.
    let promptTokens, completionTokens, totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
