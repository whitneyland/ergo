//
//  ChatView.swift
//  Ergo
//
//  Created by Lee Whitney on 6/28/24.
//

import SwiftUI

// Model for a chat message
struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUserMessage: Bool

    // Conform to Equatable
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id && lhs.text == rhs.text && lhs.isUserMessage == rhs.isUserMessage
    }
}

struct ChatView: View {
    let startTime = { print("⏰ \(Date()): ChatView struct initialized"); return Date() }()

    @Bindable private var viewModel = ChatViewModel()
    @State private var isMenuOpen: Bool = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack {
            // Main Chat View
            VStack {
                // Top Navigation Bar
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .accessibilityLabel("Open menu")
                    }
                    Spacer()
                    Menu("Options") {
                        Button("Option 1", action: {})
                        Button("Option 2", action: {})
                        Button("Option 3", action: {})
                    }
                    Spacer()
                    Button(action: {
                        // Action for new document
                    }) {
                        Image(systemName: "doc.badge.plus")
                            .accessibilityLabel("New document")
                    }
                }
                .padding()
                .background(Color(.systemGray6))

                // Main Scrollable Chat View
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.messages) { message in
                                Text(message.text)
                                    .textSelection(.enabled)
                                    .padding()
                                    .background(message.isUserMessage ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                                    .padding(.top, message.id == viewModel.messages.first?.id ? 10 : 0)
                                    .id(message.id) // Add an id to each message for scrolling
                            }
                        }
                    }
                    .contentShape(Rectangle())  // Makes the entire background tappable
                    .onTapGesture {             // Tap to dismiss keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .scrollDismissesKeyboard(.interactively)  // Handles scroll-to-dismiss
                    .onChange(of: viewModel.messages) { oldMessages, newMessages in
                        if let lastMessageId = newMessages.last?.id {
                            withAnimation {
                                scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
                            }
                        }
                    }
                }

                // Bottom Toolbar
                HStack {
                    Button(action: {
                        // Action for camera button
                    }) {
                        Image(systemName: "camera")
                            .accessibilityLabel("Camera")
                    }
                    Spacer()
                    Button(action: {
                        // Action for picture button
                    }) {
                        Image(systemName: "photo")
                            .accessibilityLabel("Photo library")
                    }
                    Spacer()
                    Button(action: {
                        // Action for folder button
                    }) {
                        Image(systemName: "folder")
                            .accessibilityLabel("Folder")
                    }
                    Spacer()
                    TextEditor(text: $viewModel.messageText)
                        .frame(height: 40)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .focused($isInputFocused)
                    Button(action: {
                        let _ = print("log button action")
                        Task {
                            await viewModel.sendMessage()
                            isInputFocused = true
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.leading, 5)
                    }
                    .disabled(viewModel.messageText.isEmpty)
                }
                .padding()
                .background(Color(.systemGray6))
            }
            .disabled(isMenuOpen) // Disable interaction when menu is open
            .blur(radius: isMenuOpen ? 5 : 0) // Add blur effect when menu is open
            .task {
                isInputFocused = true
            }
            // Slide-Out Menu
            if isMenuOpen {
                SlideOutMenu(isMenuOpen: $isMenuOpen)
                    .transition(.move(edge: .leading))
            }
        }
    }
}

struct SlideOutMenu: View {
    @Binding var isMenuOpen: Bool

    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isMenuOpen = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .padding()
                        }
                    }
                    .background(Color(.systemGray6))

                    List {
                        Text("Menu Item 1")
                        Text("Menu Item 2")
                        Text("Menu Item 3")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: geometry.size.width * 0.75) // Adjust width as needed
                .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer() // Fill the remaining space
            }
        }
    }
}

#Preview {
    ChatView()
}
