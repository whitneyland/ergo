//
//  ChatViewModel.swift
//  Ergo
//
//  Created by Lee Whitney on 7/12/24.
//

import SwiftUI

@Observable
class ChatViewModel {

    var messages: [ChatMessage] = [
        ChatMessage(text: "Hello 👋", isUserMessage: false),
    ]

    var messageText: String = ""

    // Not using intents for now
//    private let intentParser = IntentParser()

    func sendMessage() async {
        guard !messageText.isEmpty else { return }

        let userMessage = ChatMessage(text: messageText, isUserMessage: true)
        messages.append(userMessage)

//        if let intent = await intentParser.parse(messageText) {
//            await handleIntent(intent)
//        } else {
            if let responseText = await ModelService.fetchResponse(for: messageText) {
                let responseMessage = ChatMessage(text: responseText.trimmingCharacters(in: .whitespacesAndNewlines), isUserMessage: false)
                messages.append(responseMessage)
            } else {
                messages.append(ChatMessage(text: "I'm sorry, I couldn't process that request. Please try again.", isUserMessage: false))
            }
//        }

        messageText = ""
    }

//    private func handleIntent(_ intent: DoorIntent) async {
//        // Handle the intent and generate an appropriate response
//        switch intent {
//        case .openDoor(let doorNumber):
//            messages.append(ChatMessage(text: "Opening door \(doorNumber)...", isUserMessage: false))
//            // Add logic to actually open the door
//        case .closeDoor(let doorNumber):
//            messages.append(ChatMessage(text: "Closing door \(doorNumber)...", isUserMessage: false))
//            // Add logic to actually close the door
//        // Handle other intents...
//        case .help:
//            messages.append(ChatMessage(text: "Here are some things you can ask me to do:\n- Open/close a door\n- Check door status\n- Schedule door operations\n- Manage users\n- Check battery levels\n- Control lights\n- View activity logs\n- Set notifications", isUserMessage: false))
//        }
//    }
}

struct OpenAIResponse: Decodable {
    let choices: [Choice]

    struct Choice: Decodable {
        let message: Message

        struct Message: Decodable {
            let content: String
        }
    }
}
