//
//  ModelService.swift
//  Ergo
//
//  Created by Lee Whitney on 7/17/24.
//

import Foundation

class ModelService {
    static func fetchResponse(for userMessage: String) async -> String? {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(Config.openAIKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "model": Config.openAIModel,
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": userMessage]
            ],
            "max_tokens": 150
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            return response.choices.first?.message.content
        } catch {
            print("Error fetching response: \(error)")
            return nil
        }
    }
}
