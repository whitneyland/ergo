//
//  Config.swift
//  Ergo
//
//  Created by Lee Whitney on 7/12/24.
//

import Foundation

enum Config {
    enum ConfigError: Error {
        case missingKey(String)
    }

    // MARK: - API Keys
    static var openAIKey: String {
        Self.getValue("OPENAI_API_KEY")
    }

    static var openAIModel: String {
        Self.getValue("OPENAI_MODEL")
    }

    static var environment: String {
        Self.getValue("ENVIRONMENT")
    }

    // MARK: - Helper Methods
    private static func getValue(_ key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            assertionFailure("Missing required configuration value: \(key)")
            return ""
        }

        // Ensure we don't ship template values
        if value.contains("your-") {
            assertionFailure("Configuration value not properly set: \(key)")
            return ""
        }

        return value
    }

    static func isProduction() -> Bool {
        environment.lowercased() == "production"
    }
}
