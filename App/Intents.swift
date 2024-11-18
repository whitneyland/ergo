//
//  Intents.swift
//  Ergo
//
//  Created by Lee Whitney on 7/17/24.
//

//import Foundation
//
//let intentPrompt = """
//You are an AI assistant for an app which controls garage doors. Analyze the user's input and determine the most appropriate intent. Respond with only the intent name and any relevant parameters in JSON format. The possible intents are:
//
//1. OPEN_DOOR: Open a specific garage door. Parameter: doorNumber (int)
//2. CLOSE_DOOR: Close a specific garage door. Parameter: doorNumber (int)
//3. CHECK_STATUS: Check the status of a garage door. Parameter: doorNumber (int)
//4. SCHEDULE_OPERATION: Schedule a door to open or close. Parameters: doorNumber (int), operation (string: "open" or "close"), time (string in ISO 8601 format)
//5. ADD_USER: Add a new user to the system. Parameters: userName (string), doorNumbers (array of int)
//6. REMOVE_USER: Remove a user from the system. Parameter: userName (string)
//7. CHECK_BATTERY: Check the battery level of a door's sensor. Parameter: doorNumber (int)
//8. LIGHT_CONTROL: Control the garage light. Parameters: doorNumber (int), action (string: "on" or "off")
//9. GET_ACTIVITY_LOG: Retrieve the activity log for a door. Parameter: doorNumber (int)
//10. SET_NOTIFICATION: Set up a notification. Parameters: notificationType (string: "doorOpen", "doorClosed", "batteryLow", "unauthorizedAccess"), enabled (boolean)
//11. HELP: Provide help information about available commands.
//12. UNKNOWN: If the intent is not clear or doesn't match any of the above.
//
//Examples:
//User: "Open the garage door"
//Assistant: {"intent": "OPEN_DOOR", "doorNumber": 1}
//
//User: "What's the status of garage door 2?"
//Assistant: {"intent": "CHECK_STATUS", "doorNumber": 2}
//
//User: "Schedule door 1 to close at 10 PM"
//Assistant: {"intent": "SCHEDULE_OPERATION", "doorNumber": 1, "operation": "close", "time": "2023-07-17T22:00:00Z"}
//
//User input:
//"""

//class IntentParser {
//    func parse(_ input: String) async -> DoorIntent? {
//        let fullPrompt = intentPrompt + input
//
//        guard let response = await GptModel.fetchResponse(for: fullPrompt) else {
//            return nil
//        }
//
//        return parseGPTResponse(response)
//    }
//
//    private func parseGPTResponse(_ response: String) -> DoorIntent? {
//        let cleanedResponse = response.trimmingCharacters(in: .whitespacesAndNewlines)
//            .replacingOccurrences(of: "```json", with: "")
//            .replacingOccurrences(of: "```", with: "")
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//
//        guard let data = cleanedResponse.data(using: .utf8) else {
//            print("Error: Couldn't convert response to data")
//            return nil
//        }
//
//        do {
//            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                  let intentString = json["intent"] as? String else {
//                print("Error: Couldn't parse JSON or find 'intent' key")
//                return nil
//            }
//
//            switch intentString {
//            case "OPEN_DOOR":
//                if let doorNumber = json["doorNumber"] as? Int {
//                    return .openDoor(doorNumber)
//                }
//            case "CLOSE_DOOR":
//                if let doorNumber = json["doorNumber"] as? Int {
//                    return .closeDoor(doorNumber)
//                }
//            // ... handle other intents ...
//            case "UNKNOWN":
//                return nil
//            default:
//                print("Unrecognized intent: \(intentString)")
//                return nil
//            }
//
//            // If we've fallen through all cases without returning, log and return nil
//            print("Intent \(intentString) recognized but not properly handled")
//            return nil
//        } catch {
//            print("Error parsing JSON: \(error)")
//            return nil
//        }
//    }
//}
//
//enum DoorIntent {
//    case openDoor(Int)
//    case closeDoor(Int)
////    case checkDoorStatus(Int)
////    case scheduleOpen(Int, Date)
////    case scheduleClose(Int, Date)
////    case cancelSchedule(Int)
////    case addUser(String, [Int])
////    case removeUser(String)
////    case checkBatteryLevel(Int)
////    case turnOnLight(Int)
////    case turnOffLight(Int)
////    case getActivityLog(Int)
////    case setNotification(NotificationType, Bool)
//    case help
//}
//
//enum NotificationType {
//    case doorOpen
//    case doorClosed
//    case batteryLow
//    case unauthorizedAccess
//}
